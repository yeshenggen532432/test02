package com.qweib.cloud.biz.system.controller;


import com.qweib.cloud.biz.common.GeneralControl;
import com.qweib.cloud.biz.system.controller.customer.price.BaseModelExecutor;
import com.qweib.cloud.biz.system.service.*;
import com.qweib.cloud.biz.system.service.plat.SysCompanyRoleService;
import com.qweib.cloud.biz.system.utils.BaseWareTypeExecutor;
import com.qweib.cloud.core.domain.*;
import com.qweib.cloud.utils.BeanCopy;
import com.qweib.cloud.utils.DateTimeUtil;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import com.qweibframework.commons.StringUtils;
import org.apache.commons.beanutils.PropertyUtils;
import org.apache.commons.lang3.math.NumberUtils;
import org.apache.poi.hssf.usermodel.*;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.OutputStream;
import java.math.BigDecimal;
import java.util.*;

@Controller
@RequestMapping("/manager")
public class SysWareImportControl extends GeneralControl {
    @Resource
    private SysWaretypeService waretypeService;

    @Resource
    private SysWareService wareService;

    @Resource
    private SysWaresService sysWaresService;
    @Resource
    private SysKhlevelService khlevelService;

    @Resource
    private SysCustomerLevelPriceService customerLevelPriceService;

    @Resource
    private SysCompanyRoleService sysCompanyRoleService;

    @Resource
    private SysConfigService configService;

    @Resource
    private SysWareImportMainService sysWareImportMainService;

    @RequestMapping("toUpWareTemplateData")
    public void toUpWareTemplateData(HttpServletRequest request, HttpServletResponse response) {
        try {
            SysLoginInfo info = this.getLoginInfo(request);
            MultipartHttpServletRequest multiRequest = (MultipartHttpServletRequest) request;
            MultipartFile upFile = multiRequest.getFile("upFile");
            Workbook workbook = null;
            try {
                workbook = new XSSFWorkbook(upFile.getInputStream());//2007
            } catch (Exception ex) {
                workbook = new HSSFWorkbook(upFile.getInputStream());//2003
            }
            //第一个工作表
            Sheet sheet = workbook.getSheetAt(0);
            //验证头部
            Map<String, Integer> inform = checkHeader(sheet, info);
            if (inform == null) {
                this.sendHtmlResponse(response, "表头列名格式非法，请按照模板填写商品信息！");
                return;
            }
            //List<SysWare> customers=new ArrayList<SysWare>();

            //List<SysWare> wareList = this.wareService.queryList(null, info.getDatasource());
            //List<SysWaretype> typeList = this.waretypeService.queryList(null, info.getDatasource());

            SysConfig config = this.configService.querySysConfigByCode("CONFIG_WARE_MODIFY_HS_BILI", info.getDatasource());
            //List<Map<String, Object>> mapList = sysCompanyRoleService.queryRoleButtonByCodes(info.getDatasource(), info.getUsrRoleIds(), "uglcw.sysWare.desc");
            boolean bool = false;//商品被使用，是否可以修改商品换算；
            if (config != null && "1".equals(config.getStatus())) {
                bool = true;
            }

            Set<String> sett = new HashSet<String>();
            Set<String> settCode = new HashSet<String>();
            List<SysWare> importWareList = new ArrayList<SysWare>();
            List<SysKhlevel> levelList = khlevelService.queryList(null, info.getDatasource());
            List<SysCustomerLevelPrice> levelPriceList = new ArrayList<SysCustomerLevelPrice>();
            //判断是否允许条码重复
            SysConfig config1 = this.configService.querySysConfigByCode("CONFIG_REPEAT_BE_BARCODE", info.getDatasource());

            //判断是否自动生成商品代码
            config = this.configService.querySysConfigByCode("CONFIG_WARE_AUTO_CODE", info.getDatasource());
            Integer autoWareCode = 0;
            if (config != null && "1".equals(config.getStatus())) {
                autoWareCode = this.wareService.queryWareMaxId(info.getDatasource());
            }

            for (int j = 1; j <= sheet.getLastRowNum(); j++) {
                Row row = sheet.getRow(j);
                if (StrUtil.isNull(row)) {//表格下某行不存在数据情况
                    continue;
                }
                String beBarcode1 = row.getCell(11).toString();

                this.setCellType(row, inform.size());//设置单元格格式
                String wareCode = row.getCell(inform.get("wareCode")) == null ? "" : row.getCell(inform.get("wareCode")).getStringCellValue().trim();
                String wareName = row.getCell(inform.get("wareNm")) == null ? "" : row.getCell(inform.get("wareNm")).getStringCellValue().trim();
                String wareType = row.getCell(inform.get("waretypeNm")) == null ? "" : row.getCell(inform.get("waretypeNm")).getStringCellValue().trim();
                String wareGG = row.getCell(inform.get("wareGg")) == null ? "" : row.getCell(inform.get("wareGg")).getStringCellValue().trim();
                String wareDw = row.getCell(inform.get("wareDw")) == null ? "" : row.getCell(inform.get("wareDw")).getStringCellValue().trim();
                String wareDj = row.getCell(inform.get("wareDj")) == null ? "" : row.getCell(inform.get("wareDj")).getStringCellValue().trim();
                String wareInPrice = row.getCell(inform.get("inPrice")) == null ? "" : row.getCell(inform.get("inPrice")).getStringCellValue().trim();
                String beBarcode = row.getCell(inform.get("beBarCode")) == null ? "" : row.getCell(inform.get("beBarCode")).getStringCellValue().trim();

                String remark = row.getCell(inform.get("remark")) == null ? "" : row.getCell(inform.get("remark")).getStringCellValue().trim();
                String qualityDays = row.getCell(inform.get("qualityDays")) == null ? "" : row.getCell(inform.get("qualityDays")).getStringCellValue().trim();

                String bUnit = row.getCell(inform.get("bUnit")) == null ? "" : row.getCell(inform.get("bUnit")).getStringCellValue().trim();
                String minUnit = row.getCell(inform.get("minUnit")) == null ? "" : row.getCell(inform.get("minUnit")).getStringCellValue().trim();
                String packBarCode = row.getCell(inform.get("packBarCode")) == null ? "" : row.getCell(inform.get("packBarCode")).getStringCellValue().trim();
                String sUnit = row.getCell(inform.get("sUnit")) == null ? "" : row.getCell(inform.get("sUnit")).getStringCellValue().trim();

                String sunitPrice = row.getCell(inform.get("sunitPrice")) == null ? "" : row.getCell(inform.get("sunitPrice")).getStringCellValue().trim();
                String providerName = row.getCell(inform.get("providerName")) == null ? "" : row.getCell(inform.get("providerName")).getStringCellValue().trim();

                if (config != null && "1".equals(config.getStatus())) {
                    if (StrUtil.isNull(wareCode)) {
                        wareCode = "" + autoWareCode;
                        autoWareCode = autoWareCode + 1;
                    }
                }
                if ("".equals(wareCode) && "".equals(wareName)) {//整行为空跳过(excel清空内容情况)
                    continue;
                }
                if ("".equals(wareName)) {
                    this.sendHtmlResponse(response, "第" + (j + 1) + "行名称不能为空!");//名称不能为空
                    return;
                    //continue;
                }
                SysWare ware = new SysWare();
                //ware.setStatus3(0);
                //ware.setStatus4(0);
//				SysWare checkWare = this.checkWareExist(wareName, wareList);
//				if(!StrUtil.isNull(checkWare)){
//					this.sendHtmlResponse(response,"第"+(j+1)+"行“"+wareName+"”商品名称系统已经存在，请修改!");
//					return;
//				}
                if (!sett.add(wareName)) {//set不重复加入则表格中存在重复
                    Integer seq = j + 1;
                    wareName = wareName + seq.toString();
                    //this.sendHtmlResponse(response,"第"+(j+1)+"行“"+wareName+"”名称重复，请修改!");
                    //ware.setStatus3(1);
                    //return;
                }
                if (!settCode.add(wareCode)) {//set不重复加入则表格中存在重复
                    Integer seq = j + 1;
                    wareCode = wareCode + seq;
                    //this.sendHtmlResponse(response,"第"+(j+1)+"行“"+wareCode+"”代码重复，请修改!");
                    //ware.setStatus4(1);
                    //return;
                }
                if (wareType.length() == 0) {
                    this.sendHtmlResponse(response, "第" + (j + 1) + "行没有类别!");
                }
                String[] types = wareType.split("/");//查看是否有多级
                for (int i = 0; i < types.length; i++) {

                    SysWaretype type1 = this.waretypeService.getWareTypeByName(types[i], info.getDatasource());
                    if (type1 == null)//如果空的话
                    {
                        if (i == 0)//一级
                        {
                            type1 = new SysWaretype();

                            type1.setWaretypeLeaf("0");
                            if (types.length == 1) type1.setWaretypeLeaf("1");
                            type1.setWaretypeNm(types[i]);
                            type1.setWaretypePid(0);
                            int ret = this.waretypeService.addWaretype(type1, info.getDatasource());
                            type1.setWaretypeId(ret);
                            if (ret == 0) this.sendHtmlResponse(response, "第" + (j + 1) + "行保存类别失败!");
                        } else {
                            String parentName = types[i - 1];
                            SysWaretype parentType = this.waretypeService.getWareTypeByName(parentName, info.getDatasource());
                            if (parentType == null) {
                                this.sendHtmlResponse(response, "第" + (j + 1) + "行类别数据异常!");
                            }
                            type1 = new SysWaretype();
                            type1.setWaretypeLeaf("1");
                            type1.setWaretypeNm(types[i]);
                            type1.setWaretypePid(parentType.getWaretypeId());
                            int ret = this.waretypeService.addWaretype(type1, info.getDatasource());
                            if (ret == 0) this.sendHtmlResponse(response, "第" + (j + 1) + "行保存类别失败!");

                        }
                    } else {
                        //如果名称存在先判断下父类是否相同
                        if (i == 0)//第一级类别
                        {
                            if (type1.getWaretypePid().intValue() == 0)//已经存在不用保存
                            {
                                continue;
                            } else//名称已经存在，但是不是同一级，得改名并保存
                            {
                                types[i] = types[i] + "0";
                                type1 = this.waretypeService.getWareTypeByName(types[i], info.getDatasource());
                                if (type1 == null)//不存在才增加
                                {
                                    type1 = new SysWaretype();

                                    type1.setWaretypeLeaf("0");
                                    if (types.length == 1) type1.setWaretypeLeaf("1");
                                    type1.setWaretypeNm(types[i]);
                                    type1.setWaretypePid(0);
                                    int ret = this.waretypeService.addWaretype(type1, info.getDatasource());
                                    type1.setWaretypeId(ret);
                                    if (ret == 0) this.sendHtmlResponse(response, "第" + (j + 1) + "行保存类别失败!");
                                }
                            }
                        } else {
                            SysWaretype parentType = this.waretypeService.queryWaretypeById(type1.getWaretypePid(), info.getDatasource());
                            if (parentType != null) {
                                if (parentType.getWaretypeNm().equals(types[i - 1])) continue;
                            }
                            //如果不是同一级得改名,改为上级名称+本级名称
                            types[i] = types[i - 1] + types[i];
                            type1 = this.waretypeService.getWareTypeByName(types[i], info.getDatasource());
                            if (type1 == null) {
                                parentType = this.waretypeService.getWareTypeByName(types[i - 1], info.getDatasource());
                                if (parentType == null) {
                                    this.sendHtmlResponse(response, "第" + (j + 1) + "行类别数据异常!");
                                }
                                type1 = new SysWaretype();
                                type1.setWaretypeLeaf("1");
                                type1.setWaretypeNm(types[i]);
                                type1.setWaretypePid(parentType.getWaretypeId());
                                int ret = this.waretypeService.addWaretype(type1, info.getDatasource());
                                type1.setWaretypeId(ret);
                                if (ret == 0) this.sendHtmlResponse(response, "第" + (j + 1) + "行保存类别失败!");
                            }


                        }

                    }

                }

                String typeName = types[types.length - 1];
                SysWaretype checktype = this.waretypeService.getWareTypeByName(typeName, info.getDatasource());//this.checkWareTypeExist(wareType, typeList);
                if (StrUtil.isNull(checktype)) {
                    this.sendHtmlResponse(response, "第" + (j + 1) + "行“" + wareType + "”所属分类系统中不存在，请修改!");
                    return;
                }

                String customerLevelWareSale = "";
                //====================添加渠道价格===================
                for (int k = 0; k < levelList.size(); k++) {
                    SysKhlevel level = levelList.get(k);
                    SysCustomerLevelPrice levelPrice = new SysCustomerLevelPrice();
                    String price = row.getCell(inform.get(level.getId() + "" + level.getKhdjNm())) == null ? "" : row.getCell(inform.get(level.getId() + "" + level.getKhdjNm())).getStringCellValue().trim();
                    levelPrice.setLevelId(level.getId());
                    levelPrice.setStatus("0");
                    levelPrice.setWareNm(wareName);
                    levelPrice.setPrice(price);
                    levelPriceList.add(levelPrice);
                    customerLevelWareSale = level.getKhdjNm() + ":" + price + ",";
                }
                ware.setCustomerLevelWareSale(customerLevelWareSale);
                //========================================

                if (wareDj.equals("")) wareDj = "0";
                if (wareInPrice.equals("")) wareInPrice = "0";
                if (StrUtil.isNull(sunitPrice)) sunitPrice = "0";
                ware.setFbtime(DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd HH:mm:ss"));
                ware.setIsCy(1);
                ware.setStatus("1");
                ware.setWareCode(wareCode);
                ware.setWareNm(wareName);
                ware.setWareDj(Double.valueOf(wareDj));
                ware.setInPrice(Double.valueOf(wareInPrice));
                ware.setWareDw(wareDw);
                ware.setWareGg(wareGG);
                ware.setBeBarCode(beBarcode);
                ware.setRemark(remark);
                ware.setQualityDays(qualityDays);
                ware.setPackBarCode(packBarCode);
                //=================================
                ware.setHsNum(1d);
                ware.setMaxUnitCode("B");
                ware.setMinUnitCode("S");
                // ware.setMinUnit("S");
                ware.setbUnit(1d);
                ware.setsUnit(1d);

                ware.setProviderName(providerName);
                ware.setSunitPrice(new BigDecimal(sunitPrice));
                if (!StrUtil.isNull(minUnit)) {
                    ware.setMinUnit(minUnit);
                }
                if (!StrUtil.isNull(bUnit) && !StrUtil.isNull(sUnit) && sUnit != "0") {
                    if (NumberUtils.isCreatable(bUnit) && NumberUtils.isCreatable(sUnit)) {
                        Double b = Double.valueOf(bUnit);
                        Double s = Double.valueOf(sUnit);
                        Double hsNum = s / b;
                        hsNum = (double) Math.round(hsNum * 10000000) / 10000000;
                        ware.setHsNum(hsNum);
                        ware.setbUnit(Double.valueOf(bUnit));
                        ware.setsUnit(Double.valueOf(sUnit));
                    }
                }
                //=================================
                if (!StrUtil.isNull(checktype)) {
                    ware.setWaretype(checktype.getWaretypeId());
                } else {
                }
                ware.setWaretypeNm(wareType);
                importWareList.add(ware);
            }

            List<SysWareImportSub> importSubs = new ArrayList<SysWareImportSub>();

            for (int i = 0; i < importWareList.size(); i++) {
                SysWare ware = importWareList.get(i);
                SysWare oldWare = this.wareService.queryWareByName(ware.getWareNm(), info.getDatasource());
                if (oldWare != null) {
                    ware.setWareId(oldWare.getWareId());
                }
                if (config1 == null || "0".equals(config1.getStatus())) {
                    if (StringUtils.isNotEmpty(ware.getBeBarCode())) {
                        Integer exists = this.wareService.queryWareByBeBarcode(ware.getBeBarCode(), info.getDatasource());
                        if (exists != null && !ware.getWareId().equals(exists)) {
                            this.sendHtmlResponse(response, "第" + (i + 1) + "行小单位条码已存在!");
                        }
                    }

                    if (StringUtils.isNotEmpty(ware.getPackBarCode())) {
                        Integer exists = this.wareService.queryWareByPackBarcode(ware.getPackBarCode(), info.getDatasource());
                        if (exists != null && !ware.getWareId().equals(exists)) {
                            this.sendHtmlResponse(response, "第" + (i + 1) + "行大单位条码已存在!");
                        }
                    }
                }

                int id = 0;
                SysWareImportSub importSub = new SysWareImportSub();
                if (oldWare != null) {
                    id = oldWare.getWareId();
                    oldWare.setBeBarCode(ware.getBeBarCode());
                    int k = sysWaresService.checkWareIsUse(info.getDatasource(), id);
                    if (k == 0 || bool) {
                        oldWare.setbUnit(ware.getbUnit());
                        oldWare.setsUnit(ware.getsUnit());
                        oldWare.setHsNum(ware.getHsNum());
                    }
                    oldWare.setInPrice(ware.getInPrice());
                    oldWare.setMaxUnit(ware.getMaxUnit());
                    oldWare.setPackBarCode(ware.getPackBarCode());
                    oldWare.setQualityDays(ware.getQualityDays());
                    oldWare.setMinUnit(ware.getMinUnit());
                    oldWare.setWareDj(ware.getWareDj());
                    oldWare.setWareDw(ware.getWareDw());
                    oldWare.setWareGg(ware.getWareGg());
                    oldWare.setStatus("1");
                    oldWare.setWaretype(ware.getWaretype());
                    oldWare.setWaretypeNm(ware.getWaretypeNm());
                    oldWare.setRemark(ware.getRemark());
                    oldWare.setProviderName(ware.getProviderName());
                    oldWare.setSunitPrice(ware.getSunitPrice());
                    this.wareService.updateWare(oldWare, "", info.getDatasource());
                    BeanCopy.copyBeanProperties(importSub, oldWare);
                } else {
                    id = this.wareService.addWare(ware, info.getDatasource());
                    BeanCopy.copyBeanProperties(importSub, ware);
                }
                importSubs.add(importSub);
                if (id > 0) {
                    if (levelPriceList != null) {
                        for (int j = 0; j < levelPriceList.size(); j++) {
                            SysCustomerLevelPrice levelPrice = levelPriceList.get(j);
                            if (ware.getWareNm().equals(levelPrice.getWareNm())) {
                                levelPrice.setWareId(id);
                            }
                        }
                    }
                }
            }
            //this.stkWareService.updateWareInfo(info.getDatasource(), list);
            //更新客户等级价格
            if (levelPriceList != null) {
                //客户等级对应的商品价格
                List<SysCustomerLevelPrice> oldLevelPriceList = customerLevelPriceService.queryList(null, info.getDatasource());
                for (int j = 0; j < levelPriceList.size(); j++) {
                    SysCustomerLevelPrice oldLevelPrice = fetchLevelPrice(oldLevelPriceList, levelPriceList.get(j));
                    if (oldLevelPrice != null) {
                        oldLevelPrice.setPrice(levelPriceList.get(j).getPrice());
                        this.customerLevelPriceService.updateCustomerLevelPrice(oldLevelPrice, info.getDatasource());
                    } else {
                        customerLevelPriceService.addCustomerLevelPrice(levelPriceList.get(j), info.getDatasource());
                    }
                }
            }
            try {
                SysWareImportMain main = new SysWareImportMain();
                main.setOperId(info.getIdKey());
                main.setOperName(info.getUsrNm());
                main.setImportTime(new Date());
                main.setList(importSubs);
                main.setTitle(DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd HH:mm") + "商品信息导入");
                this.sysWareImportMainService.add(main, info.getDatasource());
            } catch (Exception ex) {
                ex.printStackTrace();
                log.error("商品保存导入记录错误", ex);
            }
            this.sendHtmlResponse(response, "1");
        } catch (Exception e) {
            e.printStackTrace();
            log.error("上传商品失败", e);
            this.sendHtmlResponse(response, "上传失败,请检查商品信息！");
        }
    }


    private SysWare checkWareExist(String wareName, List<SysWare> list) {
        if (list != null) {
            for (int i = 0; i < list.size(); i++) {
                SysWare ware = list.get(i);
                if (ware.getWareNm().equals(wareName)) {
                    return ware;
                }
            }
        }
        return null;
    }

    private SysWaretype checkWareTypeExist(String typeName, List<SysWaretype> list) {
        if (list != null) {
            for (int i = 0; i < list.size(); i++) {
                SysWaretype type = list.get(i);
                if (type.getWaretypeNm().equals(typeName)) {
                    return type;
                }
            }
        }
        return null;
    }

    @RequestMapping("/toWareImportTemplate")
    public void toWareImportTemplate(HttpServletRequest request, HttpServletResponse response) {
        String fname = "wareTemplate" + System.currentTimeMillis();// Excel文件名
        try {
            OutputStream os = response.getOutputStream();// 取得输出流
            response.reset();// 清空输出流
            response.setHeader("Content-disposition", "attachment; filename="
                    + fname + ".xls"); // 设定输出文件头,该方法有两个参数，分别表示应答头的名字和值。
            response.setContentType("application/msexcel");

            createFixationSheet(os, this.getLoginInfo(request));
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @RequestMapping("/toWareImportData")
    public void toWareImportData(HttpServletRequest request, HttpServletResponse response, SysWare sysWare) {
        String fname = "wareTemplate" + System.currentTimeMillis();// Excel文件名
        try {
            OutputStream os = response.getOutputStream();// 取得输出流
            response.reset();// 清空输出流
            response.setHeader("Content-disposition", "attachment; filename="
                    + fname + ".xls"); // 设定输出文件头,该方法有两个参数，分别表示应答头的名字和值。
            response.setContentType("application/msexcel");

            createFixationSheetData(os, this.getLoginInfo(request), sysWare);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    //商品编号;商品名称;所属分类;规格;单位;单价;采购价格;商品备注
    private Map<String, Integer> checkHeader(Sheet sheet, SysLoginInfo info) {
        //String titles = "商品编号;商品名称;所属分类;规格;单位;单价;采购价格;商品备注";
        Map<String, String> titleMap = getTitleMap(info);
        int len = titleMap.size();
        //获得行数  第一行
        Row header = sheet.getRow(0);
        Map<String, Integer> valueMap = new HashMap<String, Integer>();
        setCellType(header, len);
        for (int i = 0; i < len; i++) {
            String title = header.getCell(i).getStringCellValue().trim();
            try {

                String o = titleMap.get(title);
                valueMap.put(o, i);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        if (titleMap.size() != valueMap.size()) {
            return null;
        } else {
            return valueMap;
        }
    }

   /* private Map<String, String> getTitleMap(SysLoginInfo info) {
        Map<String, String> titleMap = new HashMap<String, String>();
        titleMap.put("商品编号", "wareCode");
        titleMap.put("商品名称", "wareNm");
        titleMap.put("所属分类", "waretypeNm");
        titleMap.put("规格", "wareGg");
        titleMap.put("大单位", "wareDw");
        titleMap.put("大单位换算基数", "bUnit");
        titleMap.put("大单位条码", "packBarCode");
        titleMap.put("销售单价", "wareDj");
        titleMap.put("采购价格", "inPrice");
        titleMap.put("商品备注", "remark");
        titleMap.put("小单位", "minUnit");
        titleMap.put("小单位销售价", "sunitPrice");
        titleMap.put("小单位换算基数", "sUnit");
        titleMap.put("小条码", "beBarcode");
        titleMap.put("保质期", "qualityDays");
        titleMap.put("生产厂家", "providerName");
        List<SysKhlevel> levelList = khlevelService.queryList(null, info.getDatasource());
        if (levelList != null) {
            for (int i = 0; i < levelList.size(); i++) {
                SysKhlevel level = levelList.get(i);
                titleMap.put(level.getQdtpNm() + "-" + level.getKhdjNm(), level.getId() + "" + level.getKhdjNm());
            }
        }
        return titleMap;
    }*/


    /**
     * 设置下载文件的标题
     *
     * @param info
     * @return
     */
    private Set<String> getTitleSet(SysLoginInfo info) {
        return getTitleMap(info).keySet();
    }

    private Map<String, String> getTitleMap(SysLoginInfo info) {
        Map<String, String> titleMap = new LinkedHashMap<>();
        titleMap.put("商品编号", "wareCode");
        titleMap.put("商品名称", "wareNm");
        titleMap.put("所属分类", "waretypeNm");
        titleMap.put("规格(大)", "wareGg");
        titleMap.put("大单位", "wareDw");
        titleMap.put("单位码(大)", "packBarCode");
        titleMap.put("销售原价(大)", "lsPrice");
        titleMap.put("批发价(大)", "wareDj");
        titleMap.put("采购价(大)", "inPrice");

        titleMap.put("规格(小)", "minWareGg");
        titleMap.put("小单位", "minUnit");
        titleMap.put("单位条码(小)", "beBarCode");
        titleMap.put("销售原价(小)", "minLsPrice");
        titleMap.put("批发价(小)", "sunitPrice");
        titleMap.put("采购价(小)", "minInPrice");
        titleMap.put("大小单位换算比例(1:n)", "hsNum");
        titleMap.put("保质期", "qualityDays");
        titleMap.put("生产厂家", "providerName");
        titleMap.put("商品备注", "remark");
        titleMap.put("大单位换算基数", "bUnit");
        titleMap.put("小单位换算基数", "sUnit");


        List<SysKhlevel> levelList = khlevelService.queryList(null, info.getDatasource());
        if (levelList != null) {
            for (int i = 0; i < levelList.size(); i++) {
                String key = getLevelKey(levelList.get(i));
                if (key != null)
                    titleMap.put(key, null);
            }
        }
        return titleMap;
    }


    public String getLevelKey(SysKhlevel level) {
        if (level == null) return null;
        return level.getQdtpNm() + "-" + level.getKhdjNm();
    }

    private void setCellType(Row row, int cellCount) {
        // TODO Auto-generated method stub
        for (int i = 0; i < cellCount; i++) {
            Cell nameCell = row.getCell(i);
            if (nameCell != null) {
                nameCell.setCellType(HSSFCell.CELL_TYPE_STRING);
            }
        }

    }

    public void createFixationSheet(OutputStream os, SysLoginInfo info) throws Exception {
        // 创建工作薄
        HSSFWorkbook wb = new HSSFWorkbook();
        // 在工作薄上建一张工作表
        HSSFSheet sheet = wb.createSheet();
        HSSFRow row = sheet.createRow((short) 0);
        sheet.createFreezePane(0, 1);
        HSSFCellStyle cellstyle = wb.createCellStyle();
        cellstyle.setAlignment(HSSFCellStyle.ALIGN_CENTER_SELECTION);
        Set<String> titleSet = getTitleSet(info);
        final int[] i = {0};
        titleSet.forEach(title -> {
            cteateCell(wb, row, (short) i[0], title, cellstyle);
            i[0]++;
        });
        //setExcelTemplateWareData(os, wb, sheet, info);
        wb.write(os);
        os.flush();
        os.close();
        System.out.println("文件生成");
    }

    public void createFixationSheetData(OutputStream os, SysLoginInfo info, SysWare ware) throws Exception {
        // 创建工作薄
        HSSFWorkbook wb = new HSSFWorkbook();
        // 在工作薄上建一张工作表
        HSSFSheet sheet = wb.createSheet();
        HSSFRow row = sheet.createRow((short) 0);
        sheet.createFreezePane(0, 1);
        HSSFCellStyle cellstyle = wb.createCellStyle();
        cellstyle.setAlignment(HSSFCellStyle.ALIGN_CENTER_SELECTION);

        Set<String> titleSet = getTitleSet(info);
        final int[] i = {0};
        titleSet.forEach(title -> {
            cteateCell(wb, row, (short) i[0], title, cellstyle);
            i[0]++;
        });
        /*List<String> list = getTitleList(info);
        for (int i = 0; i < list.size(); i++) {
            cteateCell(wb, row, (short) i, list.get(i), cellstyle);
        }*/
        setExcelTemplateWareData(os, wb, sheet, info, ware);
        wb.write(os);
        os.flush();
        os.close();
        System.out.println("文件生成");
    }

    private String getwaretypeName(String path, List<SysWaretype> typeList) {
        String typeNames = "";
        try {
            String[] ids = path.split("-");
            for (int i = 0; i < ids.length; i++) {
                if (ids[i].length() == 0) continue;
                Integer waretypeId = Integer.parseInt(ids[i]);
                String tmpstr = "";
                for (SysWaretype vo : typeList) {
                    if (vo.getWaretypeId().intValue() == waretypeId.intValue()) {
                        tmpstr = vo.getWaretypeNm();
                        break;
                    }
                }
                if (tmpstr.length() > 0) {
                    if (typeNames.length() == 0) typeNames = tmpstr;
                    else typeNames = typeNames + "/" + tmpstr;
                }
            }
        } catch (Exception e) {
            log.error(path + "分类解析失败", e);
        }
        return typeNames;
    }

    /**
     * 设置模版中的初始商品信息
     *
     * @param os
     * @param info
     */
    private void setExcelTemplateWareData(OutputStream os, HSSFWorkbook wb, HSSFSheet sheet, SysLoginInfo info, SysWare ware) {
        HSSFCellStyle cellstyle = wb.createCellStyle();
        cellstyle.setAlignment(HSSFCellStyle.ALIGN_CENTER_SELECTION);
        // List<SysWare> tempWareList = this.wareService.queryList(null, info.getDatasource());
        //客户等级
        List<SysKhlevel> levelList = khlevelService.queryList(null, info.getDatasource());
        //客户等级对应的商品价格
        List<SysCustomerLevelPrice> levelPriceList = customerLevelPriceService.queryList(null, info.getDatasource());
        //List<String> titleList = getTitleList(info);
        Map<String, String> titleMap = getTitleMap(info);
        //List<SysWaretype> typeList = this.waretypeService.queryList(null, info.getDatasource());
        BaseWareTypeExecutor typeExecutor = new BaseWareTypeExecutor(info.getDatasource(), BaseModelExecutor.PRODUCT_TYPE_SEPARATOR, waretypeService);
        Page p = this.wareService.queryWare(ware, 1, 2000, info.getDatasource());
        List<SysWare> tempWareList = p.getRows();
        if (tempWareList != null) {
            for (int i = 0; i < tempWareList.size(); i++) {
                int rowIndex = i + 1;
                HSSFRow row = sheet.createRow((short) rowIndex);
                SysWare tempWare = tempWareList.get(i);
                final short[] j = {0};
                titleMap.keySet().forEach(title -> {
                    String field = titleMap.get(title);
                    Object value = null;
                    if (StringUtils.isEmpty(field)) {
                        SysKhlevel level = fetchSysKhlevel(levelList, title);
                        if (level != null) {
                            if (levelPriceList != null && levelPriceList.size() > 0) {
                                for (int z = 0; z < levelPriceList.size(); z++) {
                                    SysCustomerLevelPrice sclp = levelPriceList.get(z);
                                    if (sclp.getWareId().equals(tempWare.getWareId()) && sclp.getLevelId().equals(level.getId())) {
                                        value = sclp.getPrice();
                                        break;
                                    }
                                }
                            }
                        }
                    } else {
                        try {
                            if ("waretypeNm".equals(field))
                                value = typeExecutor.getProduceNames(tempWare.getWaretype());
                            else
                                value = PropertyUtils.getProperty(tempWare, field);
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    }
                    if (value != null)
                        cteateCell(wb, row, (short) j[0], value.toString(), cellstyle);
                    j[0]++;
                });
            }
        }
    }

    private SysKhlevel fetchSysKhlevel(List<SysKhlevel> list, String titleName) {
        if (list != null && list.size() > 0) {
            for (int i = 0; i < list.size(); i++) {
                SysKhlevel level = list.get(i);
                if (titleName.equals(getLevelKey(level))) {
                    return level;
                }
            }
        }
        return null;
    }

    private SysCustomerLevelPrice fetchLevelPrice(List<SysCustomerLevelPrice> oldLevelPriceList, SysCustomerLevelPrice newLevelPrice) {
        if (oldLevelPriceList != null && oldLevelPriceList.size() > 0) {
            for (int i = 0; i < oldLevelPriceList.size(); i++) {
                SysCustomerLevelPrice oldLevelPrice = oldLevelPriceList.get(i);
                if (oldLevelPrice.getLevelId().equals(newLevelPrice.getLevelId()) && oldLevelPrice.getWareId().equals(newLevelPrice.getWareId())) {
                    return oldLevelPrice;
                }
            }
        }
        return null;
    }


    @SuppressWarnings("deprecation")
    private void cteateCell(HSSFWorkbook wb, HSSFRow row, short col,
                            String val, HSSFCellStyle cellstyle) {
        HSSFCell cell = row.createCell(col);
        cell.setCellValue(val);
        //  HSSFCellStyle cellstyle = wb.createCellStyle();
        // cellstyle.setAlignment(HSSFCellStyle.ALIGN_CENTER_SELECTION);
        cell.setCellStyle(cellstyle);
    }

}
