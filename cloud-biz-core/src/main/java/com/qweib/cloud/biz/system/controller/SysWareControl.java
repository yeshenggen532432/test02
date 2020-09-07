package com.qweib.cloud.biz.system.controller;

import com.qweib.cloud.biz.common.GeneralControl;
import com.qweib.cloud.biz.common.Response;
import com.qweib.cloud.biz.system.UploadFile;
import com.qweib.cloud.biz.system.UserContext;
import com.qweib.cloud.biz.system.service.SysConfigService;
import com.qweib.cloud.biz.system.service.SysWareService;
import com.qweib.cloud.biz.system.service.SysWaresService;
import com.qweib.cloud.biz.system.service.SysWaretypeService;
import com.qweib.cloud.core.domain.*;
import com.qweib.cloud.core.domain.dto.UpdateSunitFrontInput;
import com.qweib.cloud.core.exception.BizException;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import com.qweib.commons.StringUtils;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.lang.reflect.Field;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/manager")
public class SysWareControl extends GeneralControl {
    @Resource
    private SysWareService wareService;
    @Resource
    private SysWaresService sysWaresService;
    @Resource
    private SysWaretypeService waretypeService;
    @Resource
    private SysConfigService configService;

    /**
     * 摘要：
     *
     * @说明：到商品分类页面
     * @创建：作者:llp 创建时间：2016-3-22
     * @修改历史： [序号](llp 2016 - 3 - 22)<修改说明>
     */
    @RequestMapping("/queryware")
    public String queryWare() {
        return "/uglcw/ware/ware";
    }

    /**
     * 商品规格单位管理
     *
     * @return
     */
    @GetMapping("/ware/spec")
    public String wareSpecPage() {
        return "/uglcw/ware/spec";
    }

    /**
     * 多规格商品组名
     *
     * @return
     */
    @GetMapping("/ware/group")
    public String wareGroup() {
        return "/uglcw/ware/group";
    }

    /**
     * 多规格商品属性
     *
     * @return
     */
    @GetMapping("/ware/attribute")
    public String wareAttribute() {
        return "/uglcw/ware/attribute";
    }

    /**
     * 摘要：
     *
     * @说明：到商品分页页面
     * @创建：作者:llp 创建时间：2016-3-22
     * @修改历史： [序号](llp 2016 - 3 - 22)<修改说明>
     */
    @RequestMapping("/towares")
    public String towares(Model model, Integer wtype, HttpServletRequest request) {
        SysLoginInfo info = this.getLoginInfo(request);
        String isType = request.getParameter("isType");
        if (StrUtil.isNull(isType)) {
            model.addAttribute("isType", "");
        } else {
            model.addAttribute("isType", isType);
        }
        model.addAttribute("wtype", wtype);
        model.addAttribute("tpNm", info.getTpNm());
        return "/uglcw/ware/wares";
    }

    @ResponseBody
    @RequestMapping("/waresSpecPage")
    public Page waresSpec(Integer wtype, int page, int rows, SysWare ware, HttpServletResponse response, HttpServletRequest request) {
        SysLoginInfo info = this.getLoginInfo(request);
        try {
            ware.setWaretype(wtype);
            Page p = wareService.queryWareSpec(ware, page, rows, info.getDatasource());
           /* JSONObject json = new JSONObject();
            json.put("total", p.getTotal());
            json.put("rows", p.getRows());
            this.sendJsonResponse(response, json.toString());*/
            return p;
        } catch (Exception e) {
            e.printStackTrace();
            log.error("分页查询商品出错：", e);
            return null;
        }

    }

    /**
     * 查询多规格商品属性
     *
     * @param page
     * @param rows
     * @param request
     * @param response
     */
    @RequestMapping("/wareAttribute")
    public void wareAttributePage(int page, int rows, HttpServletRequest request, HttpServletResponse response) {
        SysLoginInfo info = this.getLoginInfo(request);
        try {
            Page p = this.wareService.wareAttributePage(page, rows, info.getDatasource());
            JSONObject json = new JSONObject();
            json.put("total", p.getTotal());
            json.put("rows", p.getRows());
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            e.printStackTrace();
            log.error("分页查询商品属性出错：", e);
        }

    }

    /**
     * 修改商品属性
     *
     * @param response
     * @param request
     * @param wareId
     * @param val
     */
    @RequestMapping("/updateWareAttribute")
    public void updateWareAttribute(HttpServletResponse response, HttpServletRequest request, Integer wareId, String val) {
        SysLoginInfo info = this.getLoginInfo(request);
        try {
            this.wareService.updateWareAttribute(val, info.getDatasource(), wareId);
            this.sendJsonResponse(response, "1");
        } catch (Exception e) {
            e.printStackTrace();
            log.error("更新商品出错", e);
        }

    }

    @RequestMapping("/updateWareSpec")
    public void updateWareSpec(HttpServletResponse response, HttpServletRequest request, Integer id, Double price, String field, String val) {
        SysLoginInfo info = this.getLoginInfo(request);
        try {
            SysWare ware = this.wareService.queryWareById(id, info.getDatasource());
            if ("wareGg".equals(field)) {
                ware.setWareGg(val);
            } else if ("minWareGg".equals(field)) {
                ware.setMinWareGg(val);
            } else if ("wareDw".equals(field)) {
                ware.setWareDw(val);
            } else if ("minUnit".equals(field)) {
                ware.setMinUnit(val);
            } else if ("sUnit".equals(field)) {
                ware.setsUnit(price);
                ware.setHsNum(ware.getsUnit() / ware.getbUnit());
            } else if ("wareNm".equals(field)) {
                ware.setWareNm(val);
            } else if ("minWarnQty".equals(field)) {
                ware.setMinWarnQty(new Double(val));
            }
            this.wareService.updateWare(ware, info.getDatasource());
            this.sendJsonResponse(response, "1");
        } catch (Exception e) {
            e.printStackTrace();

        }

    }

    @RequestMapping("/wares")
    public void wares(Integer wtype, int page, int rows, SysWare ware, HttpServletResponse response, HttpServletRequest request) {
        SysLoginInfo info = this.getLoginInfo(request);
        try {
            ware.setWaretype(wtype);
            Page p = this.wareService.queryWare(ware, page, rows, info.getDatasource());
            JSONObject json = new JSONObject();
            json.put("total", p.getTotal());
            json.put("rows", p.getRows());
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            log.error("分页查询商品出错：", e);
        }
    }

    @ResponseBody
    @RequestMapping("/updateSort")
    public Response updateSort(Integer id, Integer sort) {
        try {
            SysLoginInfo info = UserContext.getLoginInfo();
            SysWare ware = this.sysWaresService.queryWareById(id, info.getDatasource());
            ware.setSort(sort);
            this.sysWaresService.updateWare(ware, info.getDatasource());
        } catch (Exception e) {
            e.printStackTrace();
        }
        return Response.createSuccess();
    }


    @RequestMapping({"dialogShopWaresPage"})
    public void dialogShopMemberPage2(SysWare ware, int page, int rows, HttpServletResponse response, HttpServletRequest request, Integer brandId, Integer type) {
        try {
            SysLoginInfo info = this.getLoginInfo(request);
            Page p = this.wareService.page2(ware, page, rows, info.getDatasource(), brandId, type);
            JSONObject json = new JSONObject();
            json.put("total", p.getTotal());
            json.put("rows", p.getRows());
            this.sendJsonResponse(response, json.toString());
        } catch (Exception var12) {
            var12.printStackTrace();
            this.log.error("查询商品出错：", var12);
        }

    }

    /**
     * 查询没有组名的商品
     *
     * @param sysWare
     * @param page
     * @param rows
     * @param response
     * @param request
     */
    @RequestMapping("/queryNoneGroupWare")
    public void queryNoneGroupWare(SysWare sysWare, int page, int rows, HttpServletResponse response, HttpServletRequest request) {
        SysLoginInfo info = this.getLoginInfo(request);
        try {
            Page page1 = this.wareService.queryNoneGroupWare(sysWare, page, rows, info.getDatasource());
            JSONObject json = new JSONObject();
            json.put("total", page1.getTotal());
            json.put("rows", page1.getRows());
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    /**
     * 查询当前多规格商品（移除/查看）
     *
     * @param sysWare
     * @param groupId
     * @param page
     * @param rows
     * @param request
     * @param response
     */
    @RequestMapping("/queryWareByGroupId")
    public void queryWareByGroupId(SysWare sysWare, int groupId, int page, int rows, HttpServletRequest request, HttpServletResponse response) {
        SysLoginInfo info = this.getLoginInfo(request);
        try {
            Page p = this.wareService.queryWareByGroupId(sysWare, groupId, page, rows, info.getDatasource());
            JSONObject json = new JSONObject();
            json.put("total", p.getTotal());
            json.put("rows", p.getRows());
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 添加多规格商品
     *
     * @param ids
     * @param id
     * @param response
     * @param request
     */
    @RequestMapping("/batchUAddWareGroup")
    public void batchUAddWareGroup(String ids, Integer id, HttpServletResponse response, HttpServletRequest request) {
        SysLoginInfo info = this.getLoginInfo(request);
        try {
            if (id != null) {
                int i = this.wareService.batchUAddWareGroup(ids, id, info.getDatasource());
                if (i > 0) {
                    this.sendHtmlResponse(response, "1");
                } else {
                    this.sendHtmlResponse(response, "-1");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            this.log.error("批量添加规格商品出错：");
            this.sendHtmlResponse(response, "-1");
        }

    }

    @RequestMapping("/batchRemoveWareGroup")
    public void batchRemoveCustomerType(String ids, HttpServletRequest request, HttpServletResponse response) {
        SysLoginInfo info = this.getLoginInfo(request);
        try {
            int i = this.wareService.batchRemoveCustomerType(ids, info.getDatasource());
            if (i > 0) {
                this.sendHtmlResponse(response, "1");
            } else {
                this.sendHtmlResponse(response, "-1");
            }
        } catch (Exception e) {
            e.printStackTrace();
            this.log.error("批量移除规格商品出错：");
            this.sendHtmlResponse(response, "-1");
        }

    }

    /**
     * 商品分类管理
     *
     * @param ware
     * @param page
     * @param rows
     * @param response
     * @param request
     * @param waretypeId
     * @param
     */
    @RequestMapping({"dialogShopWareTypePage"})
    public void dialogShopWareTypePage(SysWare ware, int page, int rows, HttpServletResponse response, HttpServletRequest request, Integer[] waretypeId) {
        try {
            SysLoginInfo info = this.getLoginInfo(request);
            Page p = this.wareService.dialogShopWareTypePage(ware, page, rows, info.getDatasource(), waretypeId);
            JSONObject json = new JSONObject();
            json.put("total", p.getTotal());
            json.put("rows", p.getRows());
            this.sendJsonResponse(response, json.toString());
        } catch (Exception var12) {
            var12.printStackTrace();
            this.log.error("查询商品出错：", var12);
        }

    }


    @RequestMapping("/batchUpdateShopWareBrand")
    public void batchUpdateShopWareBrand(String ids, Integer brandId, HttpServletRequest request, HttpServletResponse response) {
        SysLoginInfo info = this.getLoginInfo(request);
        try {
            if (brandId != null && brandId.equals(0)) {
                brandId = null;
            }
            int i = this.wareService.batchUpdateShopWareBrand(ids, brandId, info.getDatasource());
            if (i > 0) {
                this.sendHtmlResponse(response, "1");
            } else {
                this.sendHtmlResponse(response, "-1");
            }
        } catch (Exception e) {
            log.error("批量更新商品品牌出错：", e);
            this.sendHtmlResponse(response, "-1");
        }
    }

    @ResponseBody
    @RequestMapping("/batchUpdateShopWaretypeId")
    public Response batchUpdateShopWaretypeId(String ids, Integer typeId) {
        SysLoginInfo info = UserContext.getLoginInfo();
        if (typeId != null) {
            //判断商品移入的分类是否是末极分类，不是末级不能移入商品
            SysWaretype waretype = this.waretypeService.queryWaretypeById(typeId, info.getDatasource());
            if (waretype.getWaretypeLeaf().equals("0")) {
                throw new BizException("不是末级分类不能迁移");
            }
            int i = this.wareService.batchUpdateShopWaretypeId(ids, typeId, info.getDatasource());
            if(i < 0){
                throw new BizException("操作失败！");
            }

        }
        return Response.createSuccess();
    }

    @ResponseBody
    @RequestMapping("/updateWaretypePid")
    public Response updateWaretypePid(Integer typeId, Integer id, Integer isType) {
        SysLoginInfo info = UserContext.getLoginInfo();
        if (typeId != null) {
            int i = this.waretypeService.updateWaretypePid(typeId, id, isType, info.getDatasource());
            if (i < 1) {
                throw new BizException("操作失败");
            }
        }
        return Response.createSuccess();

    }

    @RequestMapping("/wareSetPriceTree")
    public String wareSetPriceTree() {
        return "/uglcw/ware/ware_set_price_tree";
    }


    @RequestMapping("/toWareSetPricePage")
    public String toWareSetPricePage(Model model, Integer wtype, HttpServletRequest request) {
        SysLoginInfo info = this.getLoginInfo(request);
        model.addAttribute("wtype", wtype);
        String isType = request.getParameter("isType");
        if (StrUtil.isNull(isType)) {
            model.addAttribute("isType", "");
        } else {
            model.addAttribute("isType", isType);
        }
        return "/uglcw/ware/ware_set_price_page";
    }

    @RequestMapping("/toWareInPrice")
    public String toWareInPrice(Model model, String ids, HttpServletRequest request) {
        SysLoginInfo info = this.getLoginInfo(request);
        List<SysWare> datas = this.sysWaresService.queryList(ids, info.getDatasource());
        request.setAttribute("datas", datas);
        return "/uglcw/ware/wareinprice";
    }

    @RequestMapping("/getWareByIds")
    public void getWareByIds(Model model, String ids, HttpServletResponse response, HttpServletRequest request) {
        SysLoginInfo info = this.getLoginInfo(request);
        try {
            List<SysWare> datas = this.sysWaresService.queryList(ids, info.getDatasource());
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("rows", datas);
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            log.error("分页查询商品出错：", e);
        }
    }

    /**
     * 商品数据修复
     *
     * @param model
     * @param ids
     * @param request
     * @return
     */
    @RequestMapping("/toWareRepair")
    public String toWareRepair(Model model, String ids, HttpServletRequest request) {
        SysLoginInfo info = this.getLoginInfo(request);
        List<SysWare> datas = this.sysWaresService.queryList(ids, info.getDatasource());
        request.setAttribute("datas", datas);
        return "/uglcw/ware/warerepair";
    }

    @RequestMapping("/wareSetPricePage")
    public void wareSetPricePage(Integer wtype, int page, int rows, SysWare ware, HttpServletResponse response, HttpServletRequest request) {
        SysLoginInfo info = this.getLoginInfo(request);
        try {
            ware.setWaretype(wtype);
            Page p = this.sysWaresService.queryCompanyStockWare(ware, page, rows, info.getDatasource());
            JSONObject json = new JSONObject();
            json.put("total", p.getTotal());
            json.put("rows", p.getRows());
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            log.error("分页查询商品出错：", e);
        }
    }

    @RequestMapping("/getWareListData")
    public void getWareListData(HttpServletRequest request, HttpServletResponse response) {
        try {
            SysLoginInfo info = this.getLoginInfo(request);
            SysWare sysWare = new SysWare();
            List<SysWare> list = this.sysWaresService.queryWareLists(sysWare, info.getDatasource());
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("list", list);
            json.put("total", list.size());
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            log.error("", e);
        }
    }


    @RequestMapping("/tooperware")
    public String tooperware(Model model, Integer Id, Integer wtype,Integer click_flag, HttpServletRequest request) {
        SysLoginInfo info = this.getLoginInfo(request);
        SysWaretype wareType = null;

        SysConfig config = this.configService.querySysConfigByCode("CONFIG_WARE_SUNIT_PRICE", info.getDatasource());
        String isSUnitPrice = "0";
        if (config != null && "1".equals(config.getStatus())) {

            isSUnitPrice = "1";
        }
        if (null != Id) {
            try {
                SysWare ware = this.wareService.queryWareById(Id, info.getDatasource());
                wareType = this.waretypeService.queryWaretypeById(ware.getWaretype(), info.getDatasource());
                List<SysWarePic> pics = ware.getWarePicList();
                int len = 1;
                if (pics != null && pics.size() > 0) {
                    len = pics.size();
                }
                model.addAttribute("len", len);
                model.addAttribute("ware", ware);
            } catch (Exception e) {
                log.error("获取商品信息出错：", e);
            }
        } else {
            SysWare ware = new SysWare();
            ware.setMaxUnitCode("B");
            ware.setMinUnitCode("S");
            ware.setHsNum(1d);
            ware.setStatus("1");
            model.addAttribute("ware", ware);
            model.addAttribute("click_flag",click_flag);
            if (!StrUtil.isNull(wtype)) {
                wareType = this.waretypeService.queryWaretypeById(wtype, info.getDatasource());
            }
        }
        int i = sysWaresService.checkWareIsUse(info.getDatasource(), Id);
        request.setAttribute("wareIsUse", false);
        if (i > 0) {
            request.setAttribute("wareIsUse", true);
        }
        model.addAttribute("wtype", wtype);
        model.addAttribute("wareType", wareType);
        model.addAttribute("isSUnitPrice", isSUnitPrice);
        return "/uglcw/ware/wareoper";
    }


    @RequestMapping("/operware")
    public void operware(HttpServletResponse response, HttpServletRequest request, SysWare ware, String delPicIds) {
        SysLoginInfo info = this.getLoginInfo(request);
        try {
            //====================================添加商品===================================
            //判断是否允许条码重复
            SysConfig config = this.configService.querySysConfigByCode("CONFIG_REPEAT_BE_BARCODE", info.getDatasource());
            if (config == null || "0".equals(config.getStatus())) {
                if (StringUtils.isNotEmpty(ware.getBeBarCode())) {
                    Integer exists = this.wareService.queryWareByBeBarcode(ware.getBeBarCode(), info.getDatasource());
                    if (exists != null && !exists.equals(ware.getWareId())) {
                        //该小单位条码已存在
                        this.sendHtmlResponse(response, "-4");
                        return;
                    }
                }

                if (StringUtils.isNotEmpty(ware.getPackBarCode())) {
                    Integer exists = this.wareService.queryWareByPackBarcode(ware.getPackBarCode(), info.getDatasource());
                    if (exists != null && !exists.equals(ware.getWareId())) {
                        ////该大单位条码已存在
                        this.sendHtmlResponse(response, "-5");
                        return;
                    }
                }
            }

            int count1 = this.wareService.queryWareNmCount(ware.getWareNm(), info.getDatasource());
            int count2 = 0;
            if (!StrUtil.isNull(ware.getWareCode())) {
                count2 = this.wareService.queryWareCodeCount(ware.getWareCode(), info.getDatasource());
            }
            if (!StrUtil.isNull(ware.getWaretype()) && ware.getWaretype() == -1) {
                SysWaretype sysWaretype = this.waretypeService.getWareTypeByName("未分类", info.getDatasource());
                if (sysWaretype == null || StrUtil.isNull(sysWaretype.getWaretypeId())) {
                    sysWaretype = new SysWaretype();
                    sysWaretype.setIsType(0);
                    sysWaretype.setWaretypeNm("未分类");
                    sysWaretype.setWaretypePid(0);
                    sysWaretype.setShopQy(1);
                    sysWaretype.setWaretypeLeaf("1");
                    Integer id = this.waretypeService.addWaretype(sysWaretype, info.getDatasource());
                    sysWaretype.setWaretypeId(id);
                }
                ware.setWaretype(sysWaretype.getWaretypeId());
            }
            if (null == ware.getWareId()) {
                //该商品名称已存在了
                if (count1 > 0) {
                    this.sendHtmlResponse(response, "-2");
                    return;
                }
                //该商品编码已存在了
                if (count2 > 0) {
                    this.sendHtmlResponse(response, "-3");
                    return;
                }
                ware.setFbtime(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()));
                Map<String, Object> map = UploadFile.updatePhotos(request, info.getDatasource(), "ware/pic", 1);
                List<SysWarePic> warePicList = new ArrayList<SysWarePic>();
                if ("1".equals(map.get("state"))) {
                    if ("1".equals(map.get("ifImg"))) {//是否有图片
                        SysWarePic swp = new SysWarePic();
                        List<String> pic = (List<String>) map.get("fileNames");
                        List<String> picMini = (List<String>) map.get("smallFile");
                        for (int i = 0; i < pic.size(); i++) {
                            swp = new SysWarePic();
                            swp.setPicMini(picMini.get(i));
                            swp.setPic(pic.get(i));
                            warePicList.add(swp);
                        }
                        ware.setWarePicList(warePicList);
                    }
                }
                config = this.configService.querySysConfigByCode("CONFIG_WARE_AUTO_CODE", info.getDatasource());
                if (config != null && "1".equals(config.getStatus())) {
                    if (StrUtil.isNull(ware.getWareCode())) {
                        Integer autoWareCode = this.wareService.queryWareMaxId(info.getDatasource());
                        ware.setWareCode("w" + autoWareCode);
                    }
                }
                this.wareService.addWare(ware, info.getDatasource());
                this.sendHtmlResponse(response, "1");
            } else {
                //========================修改商品=========================
                SysWare oldWare = this.wareService.queryWareById(ware.getWareId(), info.getDatasource());
                if (count1 > 0) {
                    if (!ware.getWareNm().equals(oldWare.getWareNm())) {
                        this.sendHtmlResponse(response, "-2");
                        return;
                    }
                }
                if (count2 > 0) {
                    if (!ware.getWareCode().equals(oldWare.getWareCode())) {
                        this.sendHtmlResponse(response, "-3");
                        return;
                    }
                }
                Map<String, Object> map = UploadFile.updatePhotos(request, info.getDatasource(), "ware/pic", 1);
                List<SysWarePic> warePicList = new ArrayList<SysWarePic>();
                if ("1".equals(map.get("state"))) {
                    if ("1".equals(map.get("ifImg"))) {//是否有图片
                        SysWarePic swp = new SysWarePic();
                        List<String> pic = (List<String>) map.get("fileNames");
                        List<String> picMini = (List<String>) map.get("smallFile");
                        for (int i = 0; i < pic.size(); i++) {
                            swp = new SysWarePic();
                            swp.setPicMini(picMini.get(i));
                            swp.setPic(pic.get(i));
                            warePicList.add(swp);
                        }
                        ware.setWarePicList(warePicList);
                    }
                }
                //商城相关的
                ware.setGroupIds(oldWare.getGroupIds());
                ware.setGroupNms(oldWare.getGroupNms());
                ware.setWareDesc(oldWare.getWareDesc());
                if (ware.getShopAlarm() == null) ware.setShopAlarm(oldWare.getShopAlarm());
                if (ware.getDefaultQty() == null) ware.setDefaultQty(oldWare.getDefaultQty());
                if (ware.getInitQty() == null) ware.setInitQty(oldWare.getInitQty());
                if (ware.getIsUseStk() == null) ware.setIsUseStk(oldWare.getIsUseStk());
                if (ware.getPosPrice1() == null) ware.setPosPrice1(oldWare.getPosPrice1());
                if (ware.getPosPrice2() == null) ware.setPosPrice2(oldWare.getPosPrice2());
                if (ware.getSunitFront() == null) ware.setSunitFront(oldWare.getSunitFront());
                ware.calLsPrice();
                this.wareService.updateWare(ware, delPicIds, info.getDatasource());
                this.sendHtmlResponse(response, "2");
            }
        } catch (Exception e) {
            e.printStackTrace();
            log.error("添加/修改商品出错：", e);
        }
    }


    @RequestMapping("warexq")
    public String groupgoodsxq(Model model, Integer Id, HttpServletRequest request) {
        SysLoginInfo info = this.getLoginInfo(request);
        SysWare ware = this.wareService.queryWareById(Id, info.getDatasource());
        model.addAttribute("ware", ware);
        return "/uglcw/ware/warexq";
    }


    @RequestMapping("/deleteware")
    public void deleteware(String ids, HttpServletResponse response, HttpServletRequest request) {
        SysLoginInfo info = this.getLoginInfo(request);
        try {
            String[] idsStr = ids.split(",");
            for (int i = 0; i < idsStr.length; i++) {
                Integer id = Integer.parseInt(idsStr[i]);
                if (id == 0) continue;
                int ret = sysWaresService.checkWareIsUse(info.getDatasource(), id);
                if (ret > 0) {
                    //this.sendHtmlResponse(response, "2");
                    this.wareService.updateWareStatus(info.getDatasource(), id, "2");
                } else {
                    //this.wareService.deleteWare(id, info.getDatasource());j

                    SysWare sysWare = this.sysWaresService.queryWareById(id,info.getDatasource());
                    sysWare.setStatus("2");
                    this.sysWaresService.updateWare(sysWare,info.getDatasource());
                }
            }
            this.sendHtmlResponse(response, "1");
        } catch (Exception e) {
            log.error("删除商品出错：", e);
            this.sendHtmlResponse(response, "-1");
        }
    }

    @PostMapping("/batchUpdateWareSunitFront")
    @ResponseBody
    public Response batchUpdateWareSunitFront(@RequestBody UpdateSunitFrontInput input) {
        final String datasource = UserContext.getLoginInfo().getDatasource();
        wareService.updateSunitFront(input.getIds(), input.getType(), datasource);
        return Response.createSuccess().setMessage("操作成功");
    }

    @RequestMapping("/batchUpdateWareType")
    public void batchUpdateWareType(String ids, Integer wareType, HttpServletResponse response, HttpServletRequest request) {
        SysLoginInfo info = this.getLoginInfo(request);
        try {
            int i = this.wareService.updateBatchWare(ids, wareType, info.getDatasource());
            if (i > 0) {
                this.sendHtmlResponse(response, "2");
            } else {
                this.sendHtmlResponse(response, "1");
            }
        } catch (Exception e) {
            e.printStackTrace();
            log.error("删除更改产品类别出错：", e);
            this.sendHtmlResponse(response, "-1");
        }
    }

    @RequestMapping("/updateWareIsCy")
    public void updateWareIsCy(HttpServletResponse response, HttpServletRequest request, Integer id, Integer isCy) {
        SysLoginInfo info = this.getLoginInfo(request);
        try {
            this.wareService.updateWareIsCy(info.getDatasource(), id, isCy);
            this.sendJsonResponse(response, "1");
        } catch (Exception e) {
            log.error("修改商品是否常用出错：", e);
            this.sendHtmlResponse(response, "-1");
        }
    }

    @RequestMapping("/updateWareSpecsunitFront")
    public void updateWareSpecsunitFront(HttpServletResponse response, HttpServletRequest request, Integer id, Integer sunitFront) {
        SysLoginInfo info = this.getLoginInfo(request);
        try {
            this.wareService.updateWareSpecsunitFront(info.getDatasource(), id, sunitFront);
            this.sendJsonResponse(response, "1");
        } catch (Exception e) {
            log.error("修改商品是否常用出错：", e);
            this.sendHtmlResponse(response, "-1");
        }
    }

    @RequestMapping("/updateWareTranAmt")
    public void updateWareTranAmt(HttpServletResponse response, HttpServletRequest request, Integer id, Double tranAmt) {
        SysLoginInfo info = this.getLoginInfo(request);
        try {
            this.wareService.updateWareTranAmt(info.getDatasource(), id, tranAmt);
            this.sendJsonResponse(response, "1");
        } catch (Exception e) {
        }
    }

    @RequestMapping("/updateWareInPrice")
    public void updateWareInPrice(HttpServletResponse response, HttpServletRequest request, Integer id, Double inPrice) {
        SysLoginInfo info = this.getLoginInfo(request);
        try {
            SysWare ware = this.wareService.queryWareById(id, info.getDatasource());
            ware.setInPrice(inPrice);
            ware.calLsPrice();
            this.wareService.updateWare(ware, info.getDatasource());
            this.sendHtmlResponse(response, "1");
        } catch (Exception e) {
            e.printStackTrace();
            log.error("修改采购价失败", e);
        }
    }

    /**
     * 修改商品信息比例
     *
     * @param response
     * @param request
     * @param id
     */
    @RequestMapping("/updateWareScale")
    public void updateWareScale(HttpServletResponse response, HttpServletRequest request, Integer id) {
        SysLoginInfo info = this.getLoginInfo(request);
        try {
            SysWare ware = this.wareService.queryWareById(id, info.getDatasource());
            String bUnit = request.getParameter("bUnit");
            String sUnit = request.getParameter("sUnit");
            if (StrUtil.isNull(bUnit)) {
                bUnit = "1";
            }
            if (StrUtil.isNull(sUnit)) {
                sUnit = "1";
            }
            Double hsNum = 1.0;
            hsNum = Double.valueOf(sUnit) / Double.valueOf(bUnit);
            ware.setHsNum(hsNum);
            ware.setbUnit(Double.valueOf(bUnit));
            ware.setsUnit(Double.valueOf(sUnit));
            this.wareService.updateWare(ware, info.getDatasource());
            this.sendHtmlResponse(response, "1");
        } catch (Exception e) {
            e.printStackTrace();
            log.error("修改商品信息比例失败", e);
        }
    }

    @RequestMapping("/updateWareUnit")
    public void updateWareUnit(HttpServletResponse response, HttpServletRequest request, Integer id) {
        SysLoginInfo info = this.getLoginInfo(request);
        try {
            SysWare ware = this.wareService.queryWareById(id, info.getDatasource());
            String wareDw = request.getParameter("wareDw");
            String minUnit = request.getParameter("minUnit");
            ware.setWareDw(wareDw);
            ware.setMinUnit(minUnit);
            this.wareService.updateWare(ware, info.getDatasource());
            this.sendHtmlResponse(response, "1");
        } catch (Exception e) {
            e.printStackTrace();
            log.error("修改商品信息大小单位失败", e);
        }
    }

    @RequestMapping("/updateWarePrice")
    public void updateWarePrice(HttpServletResponse response, HttpServletRequest request, Integer id, Double price, String field) {
        SysLoginInfo info = this.getLoginInfo(request);
        JSONObject json = new JSONObject();
        try {
            SysWare ware = this.wareService.queryWareById(id, info.getDatasource());

            if(StrUtil.isNumberNullOrZero(price)){
                price=null;
            }
            if ("inPrice".equals(field)) {
                ware.setInPrice(price);
                ware.calLsPrice();
            } else if ("wareDj".equals(field)) {
                ware.setWareDj(price);
            } else if ("lsPrice".equals(field)) {
                ware.setLsPrice(price);
                ware.setAddRate(null);
            } else if ("fxPrice".equals(field)) {
                ware.setFxPrice(price);
            } else if ("cxPrice".equals(field)) {
                ware.setCxPrice(price);
            } else if ("minInPrice".equals(field)) {
                ware.setMinInPrice(price);
                ware.calLsPrice();
            } else if ("sunitPrice".equals(field)) {
                ware.setSunitPrice(StrUtil.isNumberNullOrZero(price)?null:new BigDecimal(price));
            } else if ("minLsPrice".equals(field)) {
                ware.setMinLsPrice(price);
                ware.setAddRate(null);
            } else if ("minFxPrice".equals(field)) {
                ware.setMinFxPrice(price);
            } else if ("minCxPrice".equals(field)) {
                ware.setMinCxPrice(price);
            } else if ("tcAmt".equals(field)) {
                ware.setTcAmt(StrUtil.isNumberNullOrZero(price)?null:new BigDecimal(price));
            } else if ("saleProTc".equals(field)) {
                ware.setSaleProTc(StrUtil.isNumberNullOrZero(price)?null:new BigDecimal(price));
            } else if ("saleGroTc".equals(field)) {
                ware.setSaleGroTc(StrUtil.isNumberNullOrZero(price)?null:new BigDecimal(price));
            }else if ("addRate".equals(field)) {
                ware.setAddRate(StrUtil.isNumberNullOrZero(price)?null:new BigDecimal(price));
                ware.calLsPrice();
            }else if("posPrice1".equals(field)){
                ware.setPosPrice1(price);
            }else if("posPrice2".equals(field)){
                ware.setPosPrice2(price);
            }else if("shopWarePrice".equals(field)){
                ware.setShopWarePrice(price);
            }else if("shopWareSmallPrice".equals(field)){
                ware.setShopWareSmallPrice(price);
            }else if("shopWareLsPrice".equals(field)){
                ware.setShopWareLsPrice(price);
            }else if("shopWareSmallLsPrice".equals(field)){
                ware.setShopWareSmallLsPrice(price);
            }
            json.put("lsPrice",ware.getLsPrice());
            json.put("minLsPrice",ware.getMinLsPrice());
            json.put("addRate",ware.getAddRate());
            json.put("state",true);
            this.wareService.updateWare(ware, info.getDatasource());
        } catch (Exception e) {
            json.put("state",false);
            e.printStackTrace();
        }
        this.sendJsonResponse(response,json.toString());
    }


    @RequestMapping("/updateWareFieldValue")
    public void updateWareFieldValue(HttpServletResponse response, HttpServletRequest request, Integer wareId, String value, String field) {
        SysLoginInfo info = this.getLoginInfo(request);
        JSONObject json = new JSONObject();
        try {
             SysWare ware = this.wareService.queryWareById(wareId, info.getDatasource());
             if("beBarCode".equals(field)){
                 //判断是否允许条码重复
                 SysConfig config = this.configService.querySysConfigByCode("CONFIG_REPEAT_BE_BARCODE", info.getDatasource());
                 if (config == null || "0".equals(config.getStatus())) {
                     if (StringUtils.isNotEmpty(value)) {
                         Integer exists = this.wareService.queryWareByBeBarcode(value, info.getDatasource());
                         if (exists != null && !exists.equals(ware.getWareId())) {
                             //该小单位条码已存在
                             json.put("state",false);
                             json.put("msg","该小单位条码已存在");
                             this.sendJsonResponse(response,json.toString());
                             return;
                         }
                     }
                 }
             }
             if("packBarCode".equals(field)){
                 SysConfig config = this.configService.querySysConfigByCode("CONFIG_REPEAT_BE_BARCODE", info.getDatasource());
                 if (config == null || "0".equals(config.getStatus())) {
                     if (StringUtils.isNotEmpty(value)) {
                         Integer exists = this.wareService.queryWareByPackBarcode(value, info.getDatasource());
                         if (exists != null && !exists.equals(ware.getWareId())) {
                             ////该大单位条码已存在
                             json.put("state",false);
                             json.put("msg","该大单位条码已存在");
                             this.sendJsonResponse(response,json.toString());
                             return;
                         }
                     }
                 }
             }
            if("wareNm".equals(field)){
                int count1 = this.wareService.queryWareNmCount(value, info.getDatasource());
                if (count1 > 0) {
                    if (!value.equals(ware.getWareNm())) {
                        json.put("state",false);
                        json.put("msg","该商品名称已经存在!");
                        this.sendJsonResponse(response,json.toString());
                        return;
                    }
                }
            }
            if("wareCode".equals(field)){
                int count1 = this.wareService.queryWareCodeCount(value, info.getDatasource());
                if (count1 > 0) {
                    if (!value.equals(ware.getWareCode())) {
                        json.put("state",false);
                        json.put("msg","该商品代码已经存在!");
                        this.sendJsonResponse(response,json.toString());
                        return;
                    }
                }
            }
             Class wareClass =   ware.getClass();
             Field f = wareClass.getDeclaredField(field);
             f.setAccessible(true); // 设置属性可以直接的进行访问
             f.set(ware,value);
            this.wareService.updateWare(ware, info.getDatasource());
            json.put("state",true);
        } catch (Exception e) {
             json.put("state",false);
             json.put("msg","保存失败");
        }
        this.sendJsonResponse(response,json.toString());
    }

    @RequestMapping("/updateWareTcAmt")
    public void updateWareTcAmt(HttpServletResponse response, HttpServletRequest request, Integer id, Double tcAmt) {
        SysLoginInfo info = this.getLoginInfo(request);
        try {
            this.wareService.updateWareTcAmt(info.getDatasource(), id, tcAmt);
            this.sendJsonResponse(response, "1");
        } catch (Exception e) {
            e.printStackTrace();
            log.error("", e);
        }
    }

    @RequestMapping("/querywareshop")
    public String queryWareShop() {
        return "/uglcw/ware/wareshop";
    }

    @RequestMapping("/towaresshop")
    public String towaresshop(Model model, Integer wtype, HttpServletRequest request) {
        SysLoginInfo info = this.getLoginInfo(request);
        model.addAttribute("wtype", wtype);
        model.addAttribute("tpNm", info.getTpNm());
        return "/uglcw/ware/waresshop";
    }

    @RequestMapping("/waresshop")
    public void waresshop(Integer wtype, int page, int rows, SysWare ware, HttpServletResponse response, HttpServletRequest request) {
        SysLoginInfo info = this.getLoginInfo(request);
//		if(null==wtype || wtype==0){
//			SysWaretype type = new SysWaretype();
//			wtype = this.waretypeService.queryOneWaretype(type,info.getDatasource());
//		}
//		if(null==wtype || wtype==0){
//			return;
//		}
        try {
            ware.setWaretype(wtype);
            Page p = this.wareService.queryWarePics(ware, page, rows, info.getDatasource());
            JSONObject json = new JSONObject();
            json.put("total", p.getTotal());
            json.put("rows", p.getRows());
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            log.error("分页查询商品出错：", e);
        }
    }

    @RequestMapping("/updateTabWare")
    public void updateTabWare(HttpServletResponse response, HttpServletRequest request, Integer id, String field, String value) {
        SysLoginInfo info = this.getLoginInfo(request);
        try {
            SysWare ware = this.wareService.queryWareById(id, info.getDatasource());
            if (!StrUtil.isNull(ware)) {

                if ("aliasName".equals(field)) {
                    ware.setAliasName(value);
                }
                if ("asnNo".equals(field)) {
                    ware.setAsnNo(value);
                }
                this.wareService.updateWare(ware, info.getDatasource());
            }
            this.sendHtmlResponse(response, "1");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    /**
     * 快速添加商品
     */
    @RequestMapping("/saveQuickWare")
    public void saveQuickWare(HttpServletResponse response, HttpServletRequest request, SysWare ware) {
        SysLoginInfo info = this.getLoginInfo(request);
        try {

            int count1 = this.wareService.queryWareNmCount(ware.getWareNm(), info.getDatasource());
            SysWare sysWare = null;
            if (!StrUtil.isNull(ware.getWareId())) {
                sysWare = this.wareService.queryWareById(ware.getWareId(), info.getDatasource());
            } else {
                if (count1 > 0) {
                    sysWare = this.wareService.queryWareByName(ware.getWareNm(), info.getDatasource());
                }
            }

            if (null == ware.getWareId()) {
                int count2 = 0;
                if (!StrUtil.isNull(ware.getWareCode())) {
                    count2 = this.wareService.queryWareCodeCount(ware.getWareCode(), info.getDatasource());
                }
                //该商品名称已存在了
                if (count1 > 0) {
                    this.sendHtmlResponse(response, "-2");
                    return;
                }
                //该商品编码已存在了
                if (count2 > 0) {
                    this.sendHtmlResponse(response, "-3");
                    return;
                }
                if (StrUtil.isNull(ware.getWareGg())) {
                    ware.setWareGg("*");
                }
                if (StrUtil.isNull(ware.getWareDw())) {
                    ware.setWareDw("B");
                }
                if (StrUtil.isNull(ware.getMinUnit())) {
                    //ware.setMinUnit("S");
                }
                ware.setFbtime(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()));
                SysConfig config = this.configService.querySysConfigByCode("CONFIG_WARE_AUTO_CODE", info.getDatasource());
                if (config != null && "1".equals(config.getStatus())) {
                    if (StrUtil.isNull(ware.getWareCode())) {
                        Integer autoWareCode = this.wareService.queryWareMaxId(info.getDatasource());
                        ware.setWareCode("w" + autoWareCode);
                    }
                }
                if (!StrUtil.isNull(ware.getWaretype()) && ware.getWaretype() != -1) {
//                    SysWaretype sysWaretype =   this.waretypeService.getWareTypeByName("未分类",info.getDatasource());
//                    if(sysWaretype==null||StrUtil.isNull(sysWaretype.getWaretypeId())){
//                        sysWaretype = new SysWaretype();
//                        sysWaretype.setIsType(0);
//                        sysWaretype.setWaretypeNm("未分类");
//                        sysWaretype.setWaretypePid(0);
//                        sysWaretype.setShopQy(1);
//                        Integer id =  this.waretypeService.addWaretype(sysWaretype,info.getDatasource());
//                        sysWaretype.setWaretypeId(id);
//                    }
                    //ware.setWaretype(sysWaretype.getWaretypeId());
                }
                if (StrUtil.isNull(ware.getWaretype()) || ware.getWaretype() == -1 || "-1".equals(ware.getWaretype() + "")) {
                    SysWaretype sysWaretype = waretypeService.getWareTypeByName("未分类", info.getDatasource());
                    if (sysWaretype == null) {
                        SysWaretype type = new SysWaretype();
                        type.setWaretypeNm("未分类");
                        type.setWaretypePid(0);
                        type.setWaretypeLeaf("1");
                        Integer typeId = this.waretypeService.addWaretype(type, info.getDatasource());
                        ware.setWaretype(typeId);
                    } else {
                        ware.setWaretype(sysWaretype.getWaretypeId());
                    }
                }
                ware.setStatus("1");
                Integer wareId = this.wareService.addWare(ware, info.getDatasource());
                SysWare sw = this.wareService.queryWareById(wareId, info.getDatasource());
                JSONObject json = new JSONObject();
                json.put("state", true);
                json.put("ware", new JSONObject(sw));
                this.sendJsonResponse(response, json.toString());
            } else {
                sysWare.setInPrice(ware.getInPrice());
                sysWare.setHsNum(ware.getHsNum());
                sysWare.setbUnit(ware.getbUnit());
                sysWare.setStatus("1");
                sysWare.setsUnit(ware.getsUnit());
                sysWare.setWareDj(ware.getWareDj());
                sysWare.setWareGg(ware.getWareGg());
                sysWare.setWaretype(ware.getWaretype());
                this.wareService.updateWare(sysWare, info.getDatasource());
                JSONObject json = new JSONObject();
                json.put("state", true);
                json.put("ware", new JSONObject(sysWare));
                this.sendJsonResponse(response, json.toString());
            }
        } catch (Exception e) {
            log.error("快速添加商品失败：", e);
            this.sendJsonResponse(response, "{state:false}");
        }
    }

    @RequestMapping("getWareById")
    public void getWareById(HttpServletResponse response, HttpServletRequest request, Integer wareId) {
        try {
            SysLoginInfo info = this.getLoginInfo(request);
            SysWare sysWare = this.wareService.queryWareById(wareId, info.getDatasource());
            JSONObject json = new JSONObject();
            if (!StrUtil.isNull(sysWare)) {
                sysWare.setBbUnit(sysWare.getbUnit() + "");
                sysWare.setSsUnit(sysWare.getsUnit() + "");
                json.put("state", true);
                json.put("ware", new JSONObject(sysWare));
            } else {
                json.put("state", false);
                json.put("msg", "暂无记录");
            }
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            this.sendJsonResponse(response, "{state:false}");
        }
    }

    @RequestMapping("/toquickware")
    public String toquickware(Model model, Integer Id, Integer wtype, HttpServletRequest request) {
        SysLoginInfo info = this.getLoginInfo(request);
        SysWaretype wareType = null;

        SysConfig config = this.configService.querySysConfigByCode("CONFIG_WARE_SUNIT_PRICE", info.getDatasource());
        String isSUnitPrice = "0";
        if (config != null && "1".equals(config.getStatus())) {

            isSUnitPrice = "1";
        }

        SysWare ware = new SysWare();
        ware.setMaxUnitCode("B");
        ware.setMinUnitCode("S");
        ware.setHsNum(1d);
        ware.setStatus("1");
        model.addAttribute("ware", ware);
        model.addAttribute("wtype", wtype);
        model.addAttribute("wareType", wareType);
        model.addAttribute("isSUnitPrice", isSUnitPrice);
        return "/uglcw/ware/warequickadd";
    }

    //=========================================================================================================================================

    /**
     * 查找公司产品
     *
     * @param wtype
     * @param page
     * @param rows
     * @param ware
     * @param response
     * @param request
     */
    @RequestMapping("/queryCompanyWares")
    public void queryCompanyWares(Integer wtype, int page, int rows, SysWare ware, HttpServletResponse response, HttpServletRequest request) {
        SysLoginInfo info = this.getLoginInfo(request);
        String isType = request.getParameter("isType");
        try {
            if (!StrUtil.isNull(isType)) {
                ware.setIsType(Integer.valueOf(isType));
            }
            ware.setWaretype(wtype);
            Page p = this.sysWaresService.queryCompanyWare(ware, page, rows, info.getDatasource());
            JSONObject json = new JSONObject();
            json.put("total", p.getTotal());
            json.put("rows", p.getRows());
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            log.error("分页查找公司产品出错：", e);
        }
    }


    /**
     * 查找库存类公司产品
     *
     * @param wtype
     * @param page
     * @param rows
     * @param ware
     * @param response
     * @param request
     */
    @RequestMapping("/queryCompanyStockWares")
    public void queryCompanyStockWares(Integer wtype, int page, int rows, SysWare ware, HttpServletResponse response, HttpServletRequest request) {
        SysLoginInfo info = this.getLoginInfo(request);
        try {
            ware.setWaretype(wtype);
            Page p = this.sysWaresService.queryCompanyStockWare(ware, page, rows, info.getDatasource());
            JSONObject json = new JSONObject();
            json.put("total", p.getTotal());
            json.put("rows", p.getRows());
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            log.error("分页查找库存类公司产品出错：", e);
        }
    }
}
