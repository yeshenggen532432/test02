package com.qweib.cloud.biz.system.controller;


import com.google.common.collect.Maps;
import com.qweib.cloud.biz.common.FileUtils;
import com.qweib.cloud.biz.common.GeneralControl;
import com.qweib.cloud.biz.common.ImportExcelsellerUtils;
import com.qweib.cloud.biz.common.SimpleExcelUtil;
import com.qweib.cloud.biz.system.controller.plat.vo.importVo.ImportTitleVo;
import com.qweib.cloud.biz.system.controller.plat.vo.importVo.ImportTypeBean;
import com.qweib.cloud.biz.system.controller.plat.vo.importVo.ImportWareInPriceVo;
import com.qweib.cloud.biz.system.service.*;
import com.qweib.cloud.biz.system.utils.BaseWareTypeExecutor;
import com.qweib.cloud.core.domain.*;
import com.qweib.cloud.utils.*;
import com.qweib.commons.StringUtils;
import com.qweibframework.async.handler.AsyncProcessHandler;
import com.qweibframework.commons.zookeeper.lock.ZkLock;
import com.qweibframework.commons.zookeeper.lock.ZkLockTemplate;
import org.apache.commons.beanutils.PropertyUtils;
import org.dozer.Mapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.util.*;
import java.util.concurrent.TimeUnit;

/**
 * 商品导入（双模版导入和大单位模版导入）
 */
@Controller
@RequestMapping("/manager/sysWareImportNew")
public class SysWareImportNewControl extends GeneralControl {
    @Resource
    private SysKhlevelService khlevelService;
    @Resource
    private SysInportTempService sysInportTempService;
    @Autowired
    private ZkLockTemplate lockTemplate;
    @Resource
    private SysCustomerLevelPriceService saveOrUpdateWareAndLevelPrice;
    @Resource
    private SysWareService wareService;
    @Resource
    private SysCustomerLevelPriceService customerLevelPriceService;
    @Resource
    private SysWaretypeService productTypeService;
    @Resource
    private Mapper mapper;
    @Resource
    private AsyncProcessHandler asyncProcessHandler;
    @Resource
    private SysQdtypeService qdtypeService;
    @Resource
    private SysQdTypePriceService sysQdTypePriceService;

    /**
     * 导入数据到临时表
     *
     * @param request
     * @param response
     */
    @ResponseBody
    @RequestMapping("/toUpExcel")
    public Map<String, Object> toUpExcel1(HttpServletRequest request, HttpServletResponse response, MultipartFile upFile, @RequestParam(value = "type", required = true) Integer type) {
        Map<String, Object> map = new HashMap<>();
        map.put("state", false);
        map.put("msg", "导入失败");
        SysLoginInfo info = this.getLoginInfo(request);
        ZkLock lock = null;
        File importFile = FileUtils.copyFile(upFile, request);
        try {
            lock = this.lockTemplate.getLock("cloud:sys:import:temp:" + info.getFdCompanyId() + ":" + type);
            boolean acquire = lock.acquire(1, TimeUnit.SECONDS);
            if (acquire) {
                List<ImportTitleVo> voTitleList = getImportTitleVoList(type, info);
                Map<String, String> titleMap = getTitleMap(type, info);
                //读取EXCEL中的表头和数据
                List<String> titleList = new ArrayList<>();
                List<List> dataList = new ArrayList<>();
                ImportExcelsellerUtils.readExcel(new FileInputStream(importFile), titleList, dataList);
                if (titleList.isEmpty()) {
                    map.put("msg", "第一标题解析失败");
                    return map;
                }
                if (dataList.isEmpty()) {
                    map.put("msg", "暂无数据");
                    return map;
                }
                List<Map<String, Object>> datasList = new ArrayList<>();
                Map<String, Object> dataMap = null;
                for (int j = 0; j < dataList.size(); j++) {
                    dataMap = new LinkedHashMap<>();
                    List datas = dataList.get(j);
                    for (int i = 0; i < titleList.size(); i++) {
                        String field = titleMap.get(titleList.get(i));
                        if (StrUtil.isNull(field)) continue;
                        dataMap.put(field, datas.get(i));
                    }
                    datasList.add(dataMap);
                }
                int tempId = sysInportTempService.save(datasList, voTitleList, info, type, SysImportTemp.InputDownEnum.input.getCode());
                if (tempId > 0) {
                    map.put("state", true);
                    map.put("importId", tempId);
                    map.put("msg", "导入成功");
                }
            } else {
                map.put("msg", "已有其他人员在处理中，请稍等");
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            map.put("msg", "导入出现错误" + ex.getMessage());
        } finally {
            if (lock != null)
                lock.release();
            if (importFile.exists()) {
                importFile.delete();
            }
        }
        return map;
    }


    /**
     * 处理导入数据
     *
     * @param request
     * @param response
     * @return
     */
    @ResponseBody
    @RequestMapping("toUpWareNew")
    public Map<String, Object> toUpWareNew(HttpServletRequest request, HttpServletResponse response) {
        Map<String, Object> map = new HashMap<>();
        map.put("state", false);
        map.put("msg", "操作失败");
        try {
            SysLoginInfo info = this.getLoginInfo(request);
            long st = System.currentTimeMillis();
            Set<String> sett = new HashSet<String>();
            Set<String> settCode = new HashSet<String>();
            List<SysKhlevel> levelList = khlevelService.queryList(null, info.getDatasource());
            List<SysQdtype> qdtypeList = qdtypeService.queryList(null, info.getDatasource());

            List<SysCustomerLevelPrice> levelPriceList = new ArrayList<SysCustomerLevelPrice>();
            List<SysQdTypePrice> typePriceList = new ArrayList<SysQdTypePrice>();

            //封装对象并返回需要处理的所有临时数据
            Map<Integer, SysImportTempItem> itemMap = new HashMap<>();
            List list = sysInportTempService.queryItemList(request, info.getDatasource(), itemMap);
            List<SysWare> wareList = new ArrayList<>();
            Map<String, String> wareNaIdMap = new HashMap<>();
            for (int j = 0; j < list.size(); j++) {
                Object voObj = list.get(j);
                if (voObj == null) continue;
                SysWare sysWare = mapper.map(voObj, SysWare.class);
                String wareGg = sysWare.getWareGg() == null ? "" : sysWare.getWareGg().toString().trim();
                String wareName = sysWare.getWareNm() == null ? "" : sysWare.getWareNm().toString().trim();
                String minWareGg = sysWare.getMinWareGg() == null ? "" : sysWare.getMinWareGg().toString().trim();


               /* if (StrUtil.isNull(wareName)) {
                    msg.append("第" + (j + 1) + "行名称不能为空!<br/>");//名称不能为空
                    continue;
                }
                if (!StrUtil.isNull(wareGg) && wareGg.length() > 0) {
                    msg.append("第" + (j + 1) + "行规格(大)超出限制!<br/>");//名称不能为空
                    continue;
                }
                if (!StrUtil.isNull(wareGg) && wareGg.length() > 20) {
                    msg.append("第" + (j + 1) + "行规格(大)超出限制!<br/>");//名称不能为空
                    continue;
                }
                if (!StrUtil.isNull(minWareGg) && minWareGg.length() > 20) {
                    msg.append("第" + (j + 1) + "行规格(小)超出限制!<br/>");//名称不能为空
                    continue;
                }*/
                /*if (!sett.add(wareName)) {//set不重复加入则表格中存在重复
                    Integer seq = j + 1;
                    wareName = wareName + seq.toString();
                    msg.append("第" + (j + 1) + "行商品名称“" + wareName + "”表格中重复，请修改!<br/>");
                    continue;
                }*/
                /*if (!settCode.add(wareCode)) {//set不重复加入则表格中存在重复
                    msg.append("第" + (j + 1) + "行“" + wareCode + "”代码重复，请修改!<br/>");
                    continue;
                }*/
                //====================添加渠道价格===================
                //等级值
                if (Collections3.isNotEmpty(levelList)) {
                    Object id = PropertyUtils.getProperty(voObj, "id");
                    Map<String, Object> contextMap = JsonUtil.readJsonObject(itemMap.get(id).getContextJson(), Map.class);
                    SysCustomerLevelPrice levelPrice = null;
                    for (SysKhlevel level : levelList) {
                        Object obj = contextMap.get(getLevelField(level));
                        if (StrUtil.isNull(obj))
                            continue;
                        levelPrice = new SysCustomerLevelPrice();
                        String price = obj == null ? "" : obj.toString().trim();
                        levelPrice.setLevelId(level.getId());
                        levelPrice.setStatus("0");
                        levelPrice.setWareNm(wareName);
                        levelPrice.setPrice(price);
                        levelPriceList.add(levelPrice);
                    }
                }
                //客户类型商品价格
                if (Collections3.isNotEmpty(qdtypeList)) {
                    Object id = PropertyUtils.getProperty(voObj, "id");
                    Map<String, Object> contextMap = JsonUtil.readJsonObject(itemMap.get(id).getContextJson(), Map.class);
                    SysQdTypePrice qdTypePrice = null;
                    for (SysQdtype sysQdtype : qdtypeList) {
                        Object obj = contextMap.get(getTypeField(sysQdtype));
                        if (StrUtil.isNull(obj))
                            continue;
                        qdTypePrice = new SysQdTypePrice();
                        String price = obj == null ? "" : obj.toString().trim();
                        qdTypePrice.setRelaId(sysQdtype.getId());
                        qdTypePrice.setStatus("0");
                        qdTypePrice.setWareNm(wareName);
                        qdTypePrice.setPrice(price);
                        typePriceList.add(qdTypePrice);
                    }
                }
                wareNaIdMap.put(sysWare.getWareNm(), PropertyUtils.getProperty(voObj, "id") + "");
                wareList.add(sysWare);
            }
            if (Collections3.isNotEmpty(wareList)) {
                String taskId = asyncProcessHandler.createTask();
                map.put("taskId", taskId);
                saveOrUpdateWareAndLevelPrice.saveOrUpdateWareAndLevelAndTypePrice(st, wareList, levelPriceList, typePriceList, wareNaIdMap, info, request.getParameter("importId"), taskId, Maps.newHashMap(request.getParameterMap()));
                map.put("state", true);
                map.put("msg", "已提交后台处理");
            } else {
                map.put("msg", "暂无有效数据可导入");
            }
        } catch (Exception e) {
            e.printStackTrace();
            log.error("上传商品失败", e);
            map.put("msg", "上传失败,请检查商品格式！" + e.getMessage());
        }
        return map;
    }

    /**
     * 下载模版
     *
     * @param request
     * @param response
     * @param type
     */
    @RequestMapping("/toWareImportTemplate")
    public void toWareImportTemplate(HttpServletRequest request, HttpServletResponse response, @RequestParam(value = "type", required = true) Integer type) {
        String fname = "qweib_wareTemplate" + type + "_import";// Excel文件名
        try {
            SysLoginInfo info = this.getLoginInfo(request);
            Map<String, String> titleMap = getTitleMap(type, info);
            SimpleExcelUtil.downExcel(response, new ArrayList<>(titleMap.keySet()), fname);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 下载数据到临时表
     *
     * @param request
     * @param response
     * @param type
     */
    @ResponseBody
    @RequestMapping("/downSysWareToImportTemp")
    public Map<String, Object> downSysWareToImportTemp(HttpServletRequest request, HttpServletResponse response, @RequestParam(value = "type", required = true) Integer type, @ModelAttribute SysWare query) {
        Map<String, Object> map = new HashMap<>();
        map.put("state", false);
        map.put("msg", "导入失败");
        try {
            SysLoginInfo info = this.getLoginInfo(request);
            query.setStatus("1");//只导出已启用数据
            List<Map<String, Object>> list = queryWareVoList(info.getDatasource(), type, query);
            if (StringUtils.isNotEmpty(request.getParameter("downExcel"))) {
                sysInportTempService.downDataToExcel(response, getImportTitleVoList(type, info), list, "商品信息");
                return null;
            }
            int tempId = sysInportTempService.save(list, getDownTitleVoList(type, info), info, type, SysImportTemp.InputDownEnum.down.getCode());
            if (tempId > 0) {
                map.put("state", true);
                map.put("importId", tempId);
                map.put("msg", "导入成功");
            }
        } catch (Exception e) {
            e.printStackTrace();
            map.put("msg", "出现错误" + e.getMessage());
        }
        return map;
    }


    /**
     * 所有商品列表后封装成对应的MAP实体
     *
     * @param database
     * @return
     */
    public List<Map<String, Object>> queryWareVoList(String database, Integer type, SysWare query) throws Exception {
        //List<SysWare> tempWareList = this.wareService.queryList(query, database);
        Page p = this.wareService.queryWare(query, 1, 10000, database);

        if (p == null || Collections3.isEmpty(p.getRows())) throw new RuntimeException("未找到数据");

        List<SysWare> tempWareList = p.getRows();
        //封装分类名称
        Set<String> ids = new HashSet<>();
        BaseWareTypeExecutor typeExecutor = new BaseWareTypeExecutor(database, SysWareService.typeSeparator, productTypeService);
        for (SysWare ware : tempWareList) {
            Integer wareType = ware.getWaretype();
            if (wareType == null || Objects.equals(wareType, 0)) continue;
            ware.setWaretypeNm(typeExecutor.getProduceNames(ware.getWaretype()));
            ids.add(ware.getWareId() + "");
        }
        //客户等级
        List<SysKhlevel> levelList = khlevelService.queryList(null, database);
        //客户等级对应的商品价格
        List<SysCustomerLevelPrice> levelPriceList = null;
        if (Collections3.isNotEmpty(levelList)) {
            Set<String> idsSet = new HashSet<>(levelList.size());
            for (SysKhlevel sysKhlevel : levelList)
                idsSet.add(sysKhlevel.getId() + "");
            SysCustomerLevelPrice levelPrice = new SysCustomerLevelPrice();
            levelPrice.setLevelIds(String.join(",", idsSet));
            levelPriceList = customerLevelPriceService.queryList(levelPrice, String.join(",", ids), database);
        }

        //类型价格
        List<SysQdtype> qdtypeList = qdtypeService.queryQdtypels(database);
        List<SysQdTypePrice> qdTypePriceList = null;
        if (Collections3.isNotEmpty(qdtypeList)) {
            Set<String> idsSet = new HashSet<>(qdtypeList.size());
            for (SysQdtype sysQdtype : qdtypeList)
                idsSet.add(sysQdtype.getId() + "");
            SysQdTypePrice sysQdTypePrice = new SysQdTypePrice();
            sysQdTypePrice.setRelaIds(String.join(",", idsSet));
            qdTypePriceList = sysQdTypePriceService.queryList(sysQdTypePrice, String.join(",", ids), database);
        }

        //把对象和对应的等级价格进行封装
        List<Map<String, Object>> dataList = new ArrayList();
        ImportTypeBean typeBean = SysImportTemp.typeMap.get(type);
        Object obj = typeBean.getDownVo();
        if (obj == null)
            obj = typeBean.getVo();
        for (SysWare ware : tempWareList) {
            obj = obj.getClass().newInstance();
            PropertyUtils.copyProperties(obj, ware);
            Map<String, Object> map = mapper.map(obj, Map.class);

            //类型价格
            if (Collections3.isNotEmpty(qdtypeList)) {
                for (SysQdtype sysQdtype : qdtypeList) {
                    if (sysQdtype == null) continue;
                    Object va = "";
                    if (Collections3.isNotEmpty(qdtypeList)) {
                        for (SysQdTypePrice sysQdTypePrice : qdTypePriceList) {
                            if (sysQdTypePrice == null) continue;
                            if (Objects.equals(ware.getWareId(), sysQdTypePrice.getWareId()) && Objects.equals(sysQdtype.getId(), sysQdTypePrice.getRelaId())) {
                                va = sysQdTypePrice.getPrice();
                                break;
                            }
                        }
                    }
                    map.put(getTypeField(sysQdtype), va);
                }
            }

            //等级价格
            if (Collections3.isNotEmpty(levelList)) {
                for (SysKhlevel sysKhlevel : levelList) {
                    if (sysKhlevel == null) continue;
                    Object va = "";
                    if (Collections3.isNotEmpty(levelPriceList)) {
                        for (SysCustomerLevelPrice levelPrice : levelPriceList) {
                            if (levelPrice == null) continue;
                            if (Objects.equals(ware.getWareId(), levelPrice.getWareId()) && Objects.equals(sysKhlevel.getId(), levelPrice.getLevelId())) {
                                va = levelPrice.getPrice();
                                break;
                            }
                        }
                    }
                    map.put(getLevelField(sysKhlevel), va);
                }
            }

            dataList.add(map);
        }
        return dataList;
    }


    /**
     * 编辑页面
     *
     * @param model
     * @param request
     * @param id
     * @return
     */
    @RequestMapping("toCreateEmpty")
    public String toCreateEmpty(Model model, HttpServletRequest
            request, @RequestParam(value = "id", required = false, defaultValue = "0") Integer
                                        id, @RequestParam(value = "type", required = true) Integer type) {
        SysLoginInfo info = this.getLoginInfo(request);
        ImportTypeBean typeBean = SysImportTemp.typeMap.get(type);
        List<ImportTitleVo> titleList = null;
        if (id != null && !Objects.equals(id, 0)) {
            SysImportTemp sysImportTemp = sysInportTempService.queryById(id, info.getDatasource());
            titleList = JsonUtil.readJsonList(sysImportTemp.getTitleJson(), ImportTitleVo.class);
            model.addAttribute("inputDown", sysImportTemp.getInputDown());
        } else {
            titleList = new ArrayList<>();
            titleList.addAll(getImportTitleVoList(type, info));
        }
        model.addAttribute("titleList", titleList);
        model.addAttribute("editUrl", typeBean.getHandleExcelUrl());
        model.addAttribute("id", id);
        model.addAttribute("type", type);
        return "/uglcw/import/sys_import_edit";
    }


    private Map<String, String> getTitleMap(Integer type, SysLoginInfo info) {
        List<ImportTitleVo> voList = getImportTitleVoList(type, info);
        Map<String, String> titleMap = new LinkedHashMap<>();
        for (ImportTitleVo vo : voList) {
            titleMap.put(vo.getTitle(), vo.getField());
        }
        return titleMap;
    }

    /**
     * 获取表格标题 zzx
     *
     * @return
     */
    private List<ImportTitleVo> getImportTitleVoList(Integer type, SysLoginInfo info) {
        ImportTypeBean typeBean = SysImportTemp.typeMap.get(type);
        List<ImportTitleVo> volist = sysInportTempService.getModelPropertyList(typeBean.getVo());
        volist.addAll(getLevelTitleVoList(info));
        return volist;
    }

    /**
     * 获取表格标题 zzx
     *
     * @return
     */
    private List<ImportTitleVo> getDownTitleVoList(Integer type, SysLoginInfo info) {
        ImportTypeBean typeBean = SysImportTemp.typeMap.get(type);
        Object obj = typeBean.getDownVo();
        if (obj == null) obj = typeBean.getVo();
        List<ImportTitleVo> volist = sysInportTempService.getModelPropertyList(obj);
        volist.addAll(getLevelTitleVoList(info));
        return volist;
    }


    /**
     * 等级对应的表头
     *
     * @param info
     * @return
     */
    private List<ImportTitleVo> getLevelTitleVoList(SysLoginInfo info) {
        List<ImportTitleVo> list = new ArrayList<>();
        ImportTitleVo vo = null;
        List<SysQdtype> qdtypeList = qdtypeService.queryQdtypels(info.getDatasource());
        if (Collections3.isNotEmpty(qdtypeList)) {
            for (SysQdtype sysQdtype : qdtypeList) {
                vo = new ImportTitleVo();
                vo.setTitle(sysQdtype.getQdtpNm());
                vo.setType(Double.class.getSimpleName());
                vo.setField(getTypeField(sysQdtype));//字段名以标题产字母
                list.add(vo);
            }
        }

        List<SysKhlevel> levelList = khlevelService.queryList(null, info.getDatasource());
        if (Collections3.isNotEmpty(levelList)) {
            for (SysKhlevel level : levelList) {
                vo = new ImportTitleVo();
                vo.setTitle(level.getQdtpNm() + "-" + level.getKhdjNm());
                vo.setType(Double.class.getSimpleName());
                vo.setField(getLevelField(level));//字段名以标题产字母+ID防止重复
                list.add(vo);
            }
        }
        return list;
    }

    /**
     * 等级对应的列名
     *
     * @param level
     * @return
     */
    private String getLevelField(SysKhlevel level) {
        return pinyingTool.getFirstSpell(level.getQdtpNm() + "-" + level.getKhdjNm() + level.getId());
    }

    /**
     * 客户类型列名
     *
     * @param sysQdtype
     * @return
     */
    private String getTypeField(SysQdtype sysQdtype) {
        return pinyingTool.getFirstSpell(sysQdtype.getQdtpNm() + sysQdtype.getId());
    }


    /**
     * 下载(商品采购设置)数据到临时表
     *
     * @param request
     * @param query
     */
    @ResponseBody
    @RequestMapping("/downWareInPriceToImportTemp")
    public Map<String, Object> downWareInPriceToImportTemp(HttpServletRequest request, @ModelAttribute SysWare
            query) {
        Map<String, Object> map = new HashMap<>();
        map.put("state", false);
        map.put("msg", "导入失败");
        try {
            SysLoginInfo info = this.getLoginInfo(request);
            List<SysWare> list = this.wareService.queryList(query, info.getDatasource());
            if (Collections3.isNotEmpty(list)) {
                List<ImportWareInPriceVo> volist = new ArrayList<>(list.size());
                ImportWareInPriceVo vo = null;
                for (SysWare sysWare : list) {
                    vo = new ImportWareInPriceVo();
                    BeanCopy.copyBeanProperties(vo, sysWare);
                    volist.add(vo);
                }

                int tempId = sysInportTempService.save(volist, SysImportTemp.TypeEnum.type_ware_in_price.getCode(), info, SysImportTemp.InputDownEnum.down.getCode());
                if (tempId > 0) {
                    map.put("state", true);
                    map.put("importId", tempId);
                    map.put("msg", "导入成功");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            map.put("msg", "出现错误" + e.getMessage());
        }
        return map;
    }

    /**
     * 上传编辑后数据zzx
     *
     * @param request
     * @param response
     * @return
     */
    @ResponseBody
    @RequestMapping("/toUpWareInPrice")
    public Map<String, Object> toUpWareInPrice(HttpServletRequest request, HttpServletResponse response) {
        Map<String, Object> map = new HashMap<>();
        map.put("state", false);
        map.put("msg", "操作失败");
        try {
            SysLoginInfo info = this.getLoginInfo(request);
            List<ImportWareInPriceVo> list = sysInportTempService.queryItemList(request, info.getDatasource());
            String msg = wareService.updateWareInPrice(list, info.getDatasource());
            if (StrUtil.isNull(msg)) {
                map.put("state", true);
                map.put("msg", "操作成功");
            } else {
                map.put("msg", msg);
            }
        } catch (Exception e) {
            e.printStackTrace();
            map.put("msg", "出现错误" + e.getMessage());
        }
        return map;
    }


}
