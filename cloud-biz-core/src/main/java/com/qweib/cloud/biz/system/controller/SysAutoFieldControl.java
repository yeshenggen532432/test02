package com.qweib.cloud.biz.system.controller;

import com.qweib.cloud.biz.common.GeneralControl;
import com.qweib.cloud.biz.common.Response;
import com.qweib.cloud.biz.system.UserContext;
import com.qweib.cloud.biz.system.service.SysAutoCustomerPriceService;
import com.qweib.cloud.biz.system.service.SysAutoFieldService;
import com.qweib.cloud.biz.system.service.SysAutoPriceService;
import com.qweib.cloud.core.domain.*;
import com.qweib.cloud.core.exception.BizException;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import com.qweibframework.commons.StringUtils;
import net.sf.json.JSONArray;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;

@Controller
@RequestMapping("/manager")
public class SysAutoFieldControl extends GeneralControl {
    @Resource
    private SysAutoFieldService autoFieldService;
    @Resource
    private SysAutoPriceService autoPriceService;
    @Resource
    private SysAutoCustomerPriceService autoCustomerPriceService;

    @RequestMapping("queryAutoField")
    public String queryAutoField(Model model, HttpServletRequest request) {
        try {
            SysLoginInfo info = this.getLoginInfo(request);
            SysAutoField auto = new SysAutoField();
            int page=1;
            int rows=50;
            Page p = this.autoFieldService.queryAutoFieldPage(auto,page,rows,info.getDatasource());
            if (p.getTotal() == 0) {
                initAutoField(info);
            } else {
                boolean YWTC00 = true;
                boolean YWTC01 = true;
                boolean YWTC02 = true;
                for (int i = 0; i < p.getRows().size(); i++) {
                    SysAutoField field = (SysAutoField) p.getRows().get(i);
                    if ("YWTC00".equals(field.getFdCode())) {
                        YWTC00 = false;
                    }
                    if ("YWTC01".equals(field.getFdCode())) {
                        YWTC01 = false;
                    }
                    if ("YWTC02".equals(field.getFdCode())) {
                        YWTC02 = false;
                    }
                }
                if (YWTC00) {
                    SysAutoField field = new SysAutoField();
                    field.setName("业务提成按数量");
                    field.setFdWay("00");
                    field.setStatus("1");
                    field.setFdCode("YWTC00");
                    this.autoFieldService.addAutoField(field, info.getDatasource());
                }
                if (YWTC01) {
                    SysAutoField field = new SysAutoField();
                    field.setName("业务提成按收入%");
                    field.setFdWay("01");
                    field.setStatus("0");
                    field.setFdCode("YWTC01");
                    this.autoFieldService.addAutoField(field, info.getDatasource());
                }
                if (YWTC02) {
                    SysAutoField field = new SysAutoField();
                    field.setName("业务提成按毛利%");
                    field.setFdWay("02");
                    field.setStatus("0");
                    field.setFdCode("YWTC02");
                    this.autoFieldService.addAutoField(field, info.getDatasource());
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return "/uglcw/autofield/sysAutoField";
    }

    @RequestMapping("toAutoFieldPage")
    public void toAutoFieldPage(SysAutoField autoField, int page, int rows, HttpServletResponse response, HttpServletRequest request) {
        try {
            SysLoginInfo info = this.getLoginInfo(request);
            rows = 50;
            Page  p = this.autoFieldService.queryAutoFieldPage(autoField, page, rows, info.getDatasource());

            JSONObject json = new JSONObject();
            json.put("total", p.getTotal());
            json.put("rows", p.getRows());
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            log.error("查询自定义字段出错：", e);
        }
    }


    @RequestMapping("autoFieldList")
    public void autoFieldList(SysAutoField autoField,HttpServletResponse response, HttpServletRequest request) {
        try {
            SysLoginInfo info = this.getLoginInfo(request);
            List list =   this.autoFieldService.queryList(autoField,info.getDatasource());
            JSONObject json = new JSONObject();
            json.put("datas", list);
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            log.error("查询变动费用列表：", e);
        }
    }


    private void initAutoField(SysLoginInfo info) {
        SysAutoField field = new SysAutoField();
        field.setName("业务提成按数量");
        field.setFdWay("00");
        field.setStatus("1");
        field.setFdCode("YWTC00");
        this.autoFieldService.addAutoField(field, info.getDatasource());
        field = new SysAutoField();
        field.setName("业务提成按收入%");
        field.setFdWay("001");
        field.setStatus("1");
        field.setFdCode("YWTC01");
        this.autoFieldService.addAutoField(field, info.getDatasource());
        field = new SysAutoField();
        field.setName("业务提成按毛利%");
        field.setFdWay("02");
        field.setStatus("1");
        field.setFdCode("YWTC02");
        this.autoFieldService.addAutoField(field, info.getDatasource());
    }

    @RequestMapping("updateAutoField")
    public void updateAutoField(SysAutoField autoField, HttpServletResponse response, HttpServletRequest request) {
        try {
            SysLoginInfo info = this.getLoginInfo(request);
            if (!StrUtil.isNull(autoField)) {
                if (null != autoField.getId() && autoField.getId() > 0) {
                   /* SysAutoField vo = this.autoFieldService.findByName(autoField.getName(), info.getDatasource());
                    if (vo != null && !vo.getId().equals(autoField.getId())) {
                        this.sendHtmlResponse(response, "3");
                        return;

                    }*/
                    this.autoFieldService.updateAutoField(autoField, info.getDatasource());
                    this.sendHtmlResponse(response, "2");
                } else {
                    SysAutoField vo = this.autoFieldService.findByName(autoField.getName(), info.getDatasource());
                    if (vo != null) {
                        this.sendHtmlResponse(response, "3");
                        return;

                    }
                    this.autoFieldService.addAutoField(autoField, info.getDatasource());
                    this.sendHtmlResponse(response, "1");
                }
            }
        } catch (Exception e) {
            log.error("操作自定义字段出错：", e);
            this.sendHtmlResponse(response, "-1");
        }
    }

    @ResponseBody
    @RequestMapping("updateStatus")
    public Response updateStatus(Integer autoId, String status) {
        SysLoginInfo info = UserContext.getLoginInfo();
        SysAutoField autoField = this.autoFieldService.queryAutoFieldById(autoId, info.getDatasource());
        if(status !=null){
            if(status.equals(autoField.getStatus())){
                throw new BizException("已是当前状态不能重复操作");
            }

        }
        if (StringUtils.startsWith(autoField.getFdCode(), "YWTC")) { //判断字符串以什么开头
            autoFieldService.updateAutoFieldStatus(info.getDatasource());
        }

        autoField.setStatus(status);
        this.autoFieldService.updateAutoField(autoField, info.getDatasource());
        return Response.createSuccess();
    }

    @RequestMapping("getAutoField")
    public void getAutoField(Integer id, HttpServletResponse response, HttpServletRequest request) {
        try {
            SysLoginInfo info = this.getLoginInfo(request);
            SysAutoField autoField = this.autoFieldService.queryAutoFieldById(id, info.getDatasource());
            JSONObject json = new JSONObject(autoField);
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            log.error("获取自定义字段出错：", e);
        }
    }

    @RequestMapping("deleteautoFieldById")
    public void deleteautoFieldById(Integer id, HttpServletResponse response, HttpServletRequest request) {
        try {
            SysLoginInfo info = this.getLoginInfo(request);
            this.autoFieldService.deleteAutoField(id, info.getDatasource());
            this.sendHtmlResponse(response, "1");
        } catch (Exception e) {
            log.error("操作自定义字段出错：", e);
            this.sendHtmlResponse(response, "-1");
        }
    }

    @RequestMapping("/autopricewaretype")
    public String customerwaretype(HttpServletRequest request, Model model, String dataTp) {
        SysLoginInfo info = this.getLoginInfo(request);
        model.addAttribute("datasource", info.getDatasource());
        model.addAttribute("dataTp", dataTp);
        SysAutoField field = new SysAutoField();
        field.setStatus("1");
        List<SysAutoField> autoList = autoFieldService.queryList(field, info.getDatasource());
        JSONArray autoListJson = JSONArray.fromObject(autoList);
        model.addAttribute("autoTitleJson", autoListJson.toString());
        List<SysAutoPrice> autoPriceList = autoPriceService.queryList(null, info.getDatasource());
        JSONArray autoPriceJson = JSONArray.fromObject(autoPriceList);
        model.addAttribute("autoPriceJson", autoPriceJson.toString());
        return "/uglcw/autofield/autopricewaretype";
    }

    @RequestMapping("/autopricewarepage")
    public String customerwarepage(HttpServletRequest request, Model model, Integer wtype, String dataTp, Integer autoId) {
        SysLoginInfo info = this.getLoginInfo(request);
        model.addAttribute("wtype", wtype);
        model.addAttribute("tpNm", info.getTpNm());
        List<SysAutoField> autoList = autoFieldService.queryList(null, info.getDatasource());
        JSONArray autoListJson = JSONArray.fromObject(autoList);
        model.addAttribute("autoTitleJson", autoListJson.toString());

        List<SysAutoPrice> autoPriceList = autoPriceService.queryList(null, info.getDatasource());
        JSONArray autoPriceJson = JSONArray.fromObject(autoPriceList);

        model.addAttribute("autoPriceJson", autoPriceJson.toString());

        return "/uglcw/autofield/autopricewarepage";
    }

    @RequestMapping("/autopriceoneware")
    public String autopriceoneware(HttpServletRequest request, Model model, Integer wareId) {
        SysLoginInfo info = this.getLoginInfo(request);
        List<SysAutoField> autoList = autoFieldService.queryList(null, info.getDatasource());
        model.addAttribute("autoList", autoList);
        SysAutoPrice autoPrice = new SysAutoPrice();
        if (!StrUtil.isNull(wareId)) {
            autoPrice.setWareId(wareId);
        } else {
            return null;
        }
        List<SysAutoPrice> autoPriceList = autoPriceService.queryList(autoPrice, info.getDatasource());
        model.addAttribute("autoPriceList", autoPriceList);
        model.addAttribute("wareId", wareId);
        return "/uglcw/autofield/autopriceoneware";
    }

    @RequestMapping("/updateAutoPrice")
    public void updateAutoPrice(HttpServletResponse response, HttpServletRequest request, SysAutoPrice model) {
        SysLoginInfo info = this.getLoginInfo(request);
        try {
            int i = 0;
            if (model != null) {
                if (StrUtil.isNull(model.getId())) {
                    i = this.autoPriceService.addAutoPrice(model, info.getDatasource());
                } else {
                    i = this.autoPriceService.updateAutoPrice(model, info.getDatasource());
                }
            }
            this.sendJsonResponse(response, "" + i);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @RequestMapping("/autopricecustomerwaretype")
    public String autopricecustomerwaretype(HttpServletRequest request, Model model, String dataTp) {
        SysLoginInfo info = this.getLoginInfo(request);
        model.addAttribute("datasource", info.getDatasource());
        model.addAttribute("dataTp", dataTp);
        //新ui
        SysAutoField field = new SysAutoField();
        field.setStatus("1");
        List<SysAutoField> autoList = autoFieldService.queryList(field, info.getDatasource());
        JSONArray autoListJson = JSONArray.fromObject(autoList);
        model.addAttribute("autoTitleJson", autoListJson.toString());
        String customerId = request.getParameter("customerId");
        SysAutoCustomerPrice cp = new SysAutoCustomerPrice();
        if (!StrUtil.isNull(customerId)) {
            cp.setCustomerId(Integer.valueOf(customerId));
        }
        List<SysAutoCustomerPrice> autoPriceList = autoCustomerPriceService.queryList(cp, info.getDatasource());
        JSONArray autoPriceJson = JSONArray.fromObject(autoPriceList);
        model.addAttribute("autoPriceJson", autoPriceJson.toString());
        return "/uglcw/autofield/autopricecustomerwaretype";
    }

    @RequestMapping("/autopricecustomerwarepage")
    public String autopricecustomerwarepage(HttpServletRequest request, Model model, Integer wtype, String dataTp, Integer autoId) {
        SysLoginInfo info = this.getLoginInfo(request);
        model.addAttribute("wtype", wtype);
        model.addAttribute("tpNm", info.getTpNm());
        List<SysAutoField> autoList = autoFieldService.queryList(null, info.getDatasource());
        JSONArray autoListJson = JSONArray.fromObject(autoList);
        model.addAttribute("autoTitleJson", autoListJson.toString());

        String customerId = request.getParameter("customerId");
        SysAutoCustomerPrice cp = new SysAutoCustomerPrice();

        if (!StrUtil.isNull(customerId)) {
            cp.setCustomerId(Integer.valueOf(customerId));
        }
        List<SysAutoCustomerPrice> autoPriceList = autoCustomerPriceService.queryList(cp, info.getDatasource());
        JSONArray autoPriceJson = JSONArray.fromObject(autoPriceList);

        model.addAttribute("autoPriceJson", autoPriceJson.toString());

        return "/uglcw/autofield/autopricecustomerwarepage";
    }

    @RequestMapping("/updateAutoCustomerPrice")
    public void updateAutoCustomerPrice(HttpServletResponse response, HttpServletRequest request, SysAutoCustomerPrice model) {
        SysLoginInfo info = this.getLoginInfo(request);
        try {
            int i = 0;
            if (model != null) {
                if (StrUtil.isNull(model.getId())) {
                    i = this.autoCustomerPriceService.addAutoCustomerPrice(model, info.getDatasource());
                } else {
                    i = this.autoCustomerPriceService.updateAutoCustomerPrice(model, info.getDatasource());
                }
            }
            this.sendJsonResponse(response, "" + i);
        } catch (Exception e) {
        }
    }

    @RequestMapping("/queryCustomerAutoFieldWarePage")
    public void queryCustomerAutoFieldWarePage(Integer wtype, int page, int rows, SysWare ware,Integer customerId,HttpServletResponse response, HttpServletRequest request) {
        SysLoginInfo info = this.getLoginInfo(request);
        try {
            ware.setWaretype(wtype);
            Page p = this.autoCustomerPriceService.queryCustomerAutoFieldWarePage(ware, page, rows,customerId, info.getDatasource());
            JSONObject json = new JSONObject();
            json.put("total", p.getTotal());
            json.put("rows", p.getRows());
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            log.error("查找客户商品变动费用列出错：", e);
        }
    }
}
