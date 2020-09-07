package com.qweib.cloud.biz.system.controller;

import com.qweib.cloud.biz.common.GeneralControl;
import com.qweib.cloud.biz.common.Response;
import com.qweib.cloud.biz.system.UserContext;
import com.qweib.cloud.biz.system.service.SysFixedCustomerPriceService;
import com.qweib.cloud.biz.system.service.SysFixedFieldService;
import com.qweib.cloud.core.domain.SysFixedCustomerPrice;
import com.qweib.cloud.core.domain.SysFixedField;
import com.qweib.cloud.core.domain.SysLoginInfo;
import com.qweib.cloud.core.exception.BizException;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import net.sf.json.JSONArray;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;

@Controller
@RequestMapping("/manager/fixedField")
public class SysFixedFieldControl extends GeneralControl {
    @Resource
    private SysFixedFieldService fixedFieldService;

    @Resource
    private SysFixedCustomerPriceService fixedCustomerPriceService;

    @RequestMapping("queryFixedField")
    public String queryFixedField(Model model, HttpServletRequest request) {
        try {
            SysLoginInfo info = this.getLoginInfo(request);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "/uglcw/fixedfield/sysFixedField";
    }

    @RequestMapping("toCustomerFixedPricePage")
    public String toCustomerFixedPricePage(Model model, HttpServletRequest request) {
        try {
            SysLoginInfo info = this.getLoginInfo(request);

            SysFixedField field = new SysFixedField();
            field.setStatus("1");
            List<SysFixedField> fixedList = fixedFieldService.queryList(field, info.getDatasource());
            JSONArray fixedListJson = JSONArray.fromObject(fixedList);
            model.addAttribute("fixedTitleJson", fixedListJson.toString());
            model.addAttribute("fields", fixedList);
            String customerId = request.getParameter("customerId");
            SysFixedCustomerPrice cp = new SysFixedCustomerPrice();
            if (!StrUtil.isNull(customerId)) {
                cp.setCustomerId(Integer.valueOf(customerId));
            }
            List<SysFixedCustomerPrice> fixedPriceList = fixedCustomerPriceService.queryList(cp, info.getDatasource());
            JSONArray fixedPriceJson = JSONArray.fromObject(fixedPriceList);
            model.addAttribute("fixedPriceJson", fixedPriceJson.toString());

        } catch (Exception e) {
            log.error("", e);
        }
        return "/uglcw/fixedfield/customer_fixedprice_page";
    }

    @RequestMapping("fixedFieldList")
    public void fixedFieldList(SysFixedField fixedField, HttpServletResponse response, HttpServletRequest request) {
        try {
            SysLoginInfo info = this.getLoginInfo(request);
            List list =   this.fixedFieldService.queryList(fixedField,info.getDatasource());
            JSONObject json = new JSONObject();
            json.put("datas", list);
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            log.error("查询固定费用列表：", e);
        }
    }

    @RequestMapping("toFixedFieldPage")
    public void toFixedFieldPage(SysFixedField FixedField, int page, int rows, HttpServletResponse response, HttpServletRequest request) {
        try {
            SysLoginInfo info = this.getLoginInfo(request);
            rows = 50;
            Page p = this.fixedFieldService.queryFixedFieldPage(FixedField, page, rows, info.getDatasource());
            JSONObject json = new JSONObject();
            json.put("total", p.getTotal());
            json.put("rows", p.getRows());
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            log.error("查询固定费用字段出错：", e);
        }
    }

    @RequestMapping("updateFixedField")
    public void updateFixedField(SysFixedField FixedField, HttpServletResponse response, HttpServletRequest request) {
        try {
            SysLoginInfo info = this.getLoginInfo(request);
            if (!StrUtil.isNull(FixedField)) {
                if (null != FixedField.getId() && FixedField.getId() > 0) {
                 /*   SysFixedField vo = this.fixedFieldService.findByName(FixedField.getName(), info.getDatasource());
                    if (vo != null && !vo.getId().equals(FixedField.getId())) {
                        this.sendHtmlResponse(response, "3");
                        return;

                    }*/
                    this.fixedFieldService.updateFixedField(FixedField, info.getDatasource());
                    this.sendHtmlResponse(response, "2");
                } else {
                    SysFixedField vo = this.fixedFieldService.findByName(FixedField.getName(), info.getDatasource());
                    if (vo != null) {
                        this.sendHtmlResponse(response, "3");
                        return;

                    }
                    this.fixedFieldService.addFixedField(FixedField, info.getDatasource());
                    this.sendHtmlResponse(response, "1");
                }
            }
        } catch (Exception e) {
            log.error("操作固定费用字段出错：", e);
            this.sendHtmlResponse(response, "-1");
        }
    }

    @ResponseBody
    @RequestMapping("updateStatus")
    public Response updateStatus(Integer fixedId, String status) {
        SysLoginInfo info = UserContext.getLoginInfo();
        SysFixedField FixedField = this.fixedFieldService.queryFixedFieldById(fixedId, info.getDatasource());
        if(status != null){
            if(status.equals(FixedField.getStatus())){
                throw new BizException("已是当前状态不能重复操作");
            }
            FixedField.setStatus(status);
        }

        this.fixedFieldService.updateFixedField(FixedField, info.getDatasource());
        return Response.createSuccess();

    }

    @RequestMapping("getFixedField")
    public void getFixedField(Integer id, HttpServletResponse response, HttpServletRequest request) {
        try {
            SysLoginInfo info = this.getLoginInfo(request);
            SysFixedField FixedField = this.fixedFieldService.queryFixedFieldById(id, info.getDatasource());
            JSONObject json = new JSONObject(FixedField);
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            log.error("获取固定费用字段出错：", e);
        }
    }

    @RequestMapping("deleteById")
    public void deleteById(Integer id, HttpServletResponse response, HttpServletRequest request) {
        try {
            SysLoginInfo info = this.getLoginInfo(request);
            this.fixedFieldService.deleteFixedField(id, info.getDatasource());
            this.sendHtmlResponse(response, "1");
        } catch (Exception e) {
            log.error("操作固定费用字段出错：", e);
            this.sendHtmlResponse(response, "-1");
        }
    }

    @RequestMapping("/updateFixedCustomerPrice")
    public void updateFixedCustomerPrice(HttpServletResponse response, HttpServletRequest request, SysFixedCustomerPrice model) {
        SysLoginInfo info = this.getLoginInfo(request);
        int i = 0;
        if (model != null) {
            if (StrUtil.isNull(model.getId())) {
                i = this.fixedCustomerPriceService.addFixedCustomerPrice(model, info.getDatasource());
            } else {
                i = this.fixedCustomerPriceService.updateFixedCustomerPrice(model, info.getDatasource());
            }
        }
        this.sendJsonResponse(response, "" + i);

    }

    @ResponseBody
    @RequestMapping("/updateMonth")
    public Response updateFixedMonth(@RequestParam("customerId") Integer customerId,
                                     @RequestParam("month") String month,
                                     @RequestParam("old") String oldMonth) {
        SysLoginInfo loginInfo = UserContext.getLoginInfo();
        this.fixedCustomerPriceService.updateMonth(loginInfo.getDatasource(), customerId, month, oldMonth);
        return Response.createSuccess().setMessage("修改成功");
    }

    @PostMapping("customer/price")
    @ResponseBody
    public Response getValues(@RequestBody List<Integer> customerIds) {
        SysLoginInfo info = UserContext.getLoginInfo();
        return Response.createSuccess(fixedCustomerPriceService.queryCustomerPrice(customerIds, info.getDatasource()));
    }

    @GetMapping("customer")
    @ResponseBody
    public Response listCustomerPrice(@RequestParam(required = false, defaultValue = "1") Integer page,
                                      @RequestParam(required = false, defaultValue = "20") Integer rows,
                                      String keyword, String status, String month,String allowEmptyMonth
    ) {
        SysLoginInfo info = UserContext.getLoginInfo();
        Page pageResult = fixedCustomerPriceService.queryCustomer(page, rows, keyword, status, month,allowEmptyMonth, info.getDatasource());
        return Response.createSuccess(pageResult);
    }

    @ResponseBody
    @PostMapping("/addCustomerPrice")
    public Response addCustomerPrice(@RequestBody List<Integer> ids) {
        SysLoginInfo info = UserContext.getLoginInfo();
        return Response.createSuccess(fixedCustomerPriceService.addCustomerPrice(ids, info.getDatasource()));
    }

    @ResponseBody
    @GetMapping("/queryNoneCustomerPrice")
    public Response queryNoneCustomerPrice(@RequestParam(required = false, defaultValue = "1") Integer page,
                                           @RequestParam(required = false, defaultValue = "20") Integer rows,
                                           String khNm, Integer qdtypeId) {
        SysLoginInfo info = UserContext.getLoginInfo();
        Page pageResult = fixedCustomerPriceService.queryNoneCustomerPrice(page, rows, khNm, qdtypeId, info.getDatasource());
        return Response.createSuccess(pageResult);
    }

    @ResponseBody
    @RequestMapping("deleteByCustomerId")
    public Response deleteByCustomerId(Integer id, String month) {
        SysLoginInfo info = UserContext.getLoginInfo();
        fixedCustomerPriceService.deleteByCustomerId(id, month, info.getDatasource());
        return Response.createSuccess();
    }

    @ResponseBody
    @RequestMapping("/updateCustomerStatus")
    public Response updateCustomerStatus(Integer id, String month, String status) {
        SysLoginInfo loginInfo = UserContext.getLoginInfo();
        int i = fixedCustomerPriceService.updateCustomerStatus(id, month, status, loginInfo.getDatasource());
        if (i < 1) {
            throw new BizException("操作失败");

        }
        return Response.createSuccess().setMessage("操作成功");

    }
}
