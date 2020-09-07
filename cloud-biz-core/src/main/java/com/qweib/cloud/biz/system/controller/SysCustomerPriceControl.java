package com.qweib.cloud.biz.system.controller;

import com.google.common.collect.Maps;
import com.qweib.cloud.biz.common.GeneralControl;
import com.qweib.cloud.biz.system.service.SysCustomerService;
import com.qweib.cloud.biz.system.service.SysWaresService;
import com.qweib.cloud.core.domain.SysCustomer;
import com.qweib.cloud.core.domain.SysCustomerPrice;
import com.qweib.cloud.core.domain.SysLoginInfo;
import com.qweib.cloud.core.domain.SysWare;
import com.qweib.cloud.utils.BeanCopy;
import com.qweib.cloud.utils.Collections3;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/manager")
public class SysCustomerPriceControl extends GeneralControl {
    @Resource
    private SysCustomerService customerService;
    @Resource
    private SysWaresService sysWaresService;

    /**
     * 转到客户价格页面
     * @return
     */
    @RequestMapping("toCustomerPricePage")
    public String toCustomerPricePage() {
        return "/uglcw/customer/customer_price_page";
    }

    /**
     * 转到客户价格导入页面
     * @return
     */
    @RequestMapping("toCustomerPriceImport")
    public String toCustomerPriceImport() {
        return "/uglcw/customer/customer_price_import";
    }

    @RequestMapping("/toCustomerPriceSetWareTree")
    public String toCustomerPriceSetWareTree(HttpServletRequest request, Model model) {
        SysLoginInfo info = this.getLoginInfo(request);
        String customerId = request.getParameter("customerId");
        model.addAttribute("customerId", customerId);
        return "/uglcw/customer/customer_price_set_ware_tree";
    }


    @RequestMapping("/toCustomerPriceSetWarePage")
    public String toCustomerPriceSetWarePage(HttpServletRequest request, Integer wtype, Model model) {
        SysLoginInfo info = this.getLoginInfo(request);
        String customerId = request.getParameter("customerId");
        model.addAttribute("customerId", customerId);
        model.addAttribute("wtype", wtype);
        String isType = request.getParameter("isType");
        if(StrUtil.isNull(isType)){
            model.addAttribute("isType", "");
        }else{
            model.addAttribute("isType", isType);
        }
        return "/uglcw/customer/customer_price_set_ware_page";
    }

    @RequestMapping("/customerPriceSetWarePage")
    public void customerPriceSetWarePage(Integer wtype, int page, int rows, SysWare ware, HttpServletResponse response, HttpServletRequest request) {
        SysLoginInfo info = this.getLoginInfo(request);
        String customerId = request.getParameter("customerId");

        String type = request.getParameter("type");

        List<SysCustomerPrice> customerPriceList = customerService.listSysCustomerPrice(info.getDatasource(), Integer.valueOf(customerId));
        try {
            ware.setWaretype(wtype);

            Page p = null;

            if("1".equals(type)){
                p = this.customerService.queryCustomerPriceWarePage(ware,Integer.valueOf(customerId),page,rows,info.getDatasource());
            }else{
                p = this.sysWaresService.queryCompanyStockWare(ware, page, rows, info.getDatasource());
            }



            Map<Integer,SysWare> wareMap = new HashMap<Integer,SysWare>();
            if(p.getRows()!=null&&p.getRows().size()>0){
                List<SysWare> wareList = new ArrayList<SysWare>();
                for(int i=0;i<p.getRows().size();i++){
                    SysWare sysWare = (SysWare)p.getRows().get(i);
                    wareList.add(sysWare);
                }
                customerService.loadCustomerPrice(wareList, info, customerId);
                for(int i=0;i<wareList.size();i++){
                    SysWare sysWare = wareList.get(i);
                    SysWare tempWare = new SysWare();
                    BeanCopy.copyBeanProperties(tempWare,sysWare);
                    wareMap.put(sysWare.getWareId(),tempWare);
                }
            }
//            if (p.getRows() != null && p.getRows().size() > 0) {
//                customerService.loadCustomerPrice(p.getRows(), info, customerId);
//            }


            final List dataList = p.getRows();
            if (Collections3.isNotEmpty(dataList)) {
                Map<Integer, SysCustomerPrice> customerPriceMap = Maps.newHashMap();
                for (SysCustomerPrice customerPrice : customerPriceList) {
                    customerPriceMap.put(customerPrice.getWareId(), customerPrice);
                }
                for (Object data : dataList) {
                    SysWare sysWare = (SysWare) data;
                    sysWare.setWareDj(null);
                    sysWare.setSunitPrice(null);

                    SysCustomerPrice customerPrice = customerPriceMap.get(sysWare.getWareId());
                    if (customerPrice != null) {
                        if (!StrUtil.isNull(customerPrice.getSaleAmt())) {
                            sysWare.setWareDj(customerPrice.getSaleAmt().doubleValue());
                        }
                        sysWare.setLsPrice(customerPrice.getLsPrice());
                        sysWare.setCxPrice(customerPrice.getCxPrice());
                        sysWare.setFxPrice(customerPrice.getFxPrice());
                        if (!StrUtil.isNull(customerPrice.getSunitPrice())) {
                            sysWare.setSunitPrice(new BigDecimal(customerPrice.getSunitPrice()));
                        }
                        sysWare.setMinCxPrice(customerPrice.getMinCxPrice());
                        sysWare.setMinFxPrice(customerPrice.getMinFxPrice());
                        sysWare.setMinLsPrice(customerPrice.getMinLsPrice());

                        sysWare.setMaxHisGyPrice(customerPrice.getMaxHisGyPrice());
                        sysWare.setMinHisGyPrice(customerPrice.getMinHisGyPrice());

                        sysWare.setMaxHisPfPrice(customerPrice.getMaxHisPfPrice());
                        sysWare.setMaxHisPfPrices(customerPrice.getMaxHisPfPrices());

                        sysWare.setMinHisPfPrice(customerPrice.getMinHisPfPrice());
                        sysWare.setMinHisPfPrices(customerPrice.getMinHisPfPrices());

                    } else {
                        sysWare.setLsPrice(null);
                        sysWare.setCxPrice(null);
                        sysWare.setFxPrice(null);
                        sysWare.setMinCxPrice(null);
                        sysWare.setMinFxPrice(null);
                        sysWare.setMinLsPrice(null);
                    }
                }
            }

            JSONObject json = new JSONObject();
            json.put("total", p.getTotal());
            json.put("rows", dataList);
            json.put("wareMap",wareMap);
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            e.printStackTrace();
            log.error("", e);
        }
    }


    @RequestMapping("/updateCustomerPriceWarePrice")
    public void updateCustomerPriceWarePrice(HttpServletResponse response, HttpServletRequest request, Integer wareId, Double price, String field) {
        SysLoginInfo info = this.getLoginInfo(request);
        try {
            String customerId = request.getParameter("customerId");
            SysCustomerPrice param = new SysCustomerPrice();
            param.setCustomerId(Integer.valueOf(customerId));
            param.setWareId(wareId);
            SysCustomerPrice sysCustomerPrice = customerService.queryCustomerPrice(param, info.getDatasource());
            if (sysCustomerPrice == null) {
                sysCustomerPrice = new SysCustomerPrice();
                sysCustomerPrice.setWareId(wareId);
                sysCustomerPrice.setCustomerId(Integer.valueOf(customerId));
            }
            if ("wareDj".equals(field)) {
                if (StrUtil.isNull(price)) {
                    price = 0.0;
                }
                sysCustomerPrice.setSaleAmt(new BigDecimal(price));
            } else if ("lsPrice".equals(field)) {
                sysCustomerPrice.setLsPrice(price);
            } else if ("fxPrice".equals(field)) {
                sysCustomerPrice.setFxPrice(price);
            } else if ("cxPrice".equals(field)) {
                sysCustomerPrice.setCxPrice(price);
            } else if ("sunitPrice".equals(field)) {
                sysCustomerPrice.setSunitPrice(price);
            } else if ("minLsPrice".equals(field)) {
                sysCustomerPrice.setMinLsPrice(price);
            } else if ("minFxPrice".equals(field)) {
                sysCustomerPrice.setMinFxPrice(price);
            } else if ("minCxPrice".equals(field)) {
                sysCustomerPrice.setMinCxPrice(price);
            } else if ("maxHisGyPrice".equals(field)) {
                sysCustomerPrice.setMaxHisGyPrice(price);
            } else if ("minHisGyPrice".equals(field)) {
                sysCustomerPrice.setMinHisGyPrice(price);
            }
            int i = 0;
            i = this.customerService.updateSysCustomerPrice(info.getDatasource(), sysCustomerPrice);
            this.sendJsonResponse(response, "1");
        } catch (Exception e) {
            log.error("", e);
        }
    }


    @RequestMapping("toCustomerExecPage")
    public String toCustomerExecPage(Model model, HttpServletRequest request) {
        try {
            SysLoginInfo info = this.getLoginInfo(request);
        } catch (Exception e) {
            log.error("", e);
        }
        return "/uglcw/customer/customer_exec_page";
    }


    @RequestMapping("/toCustomerExecWarePriceTree")
    public String toCustomerExecWarePriceTree(HttpServletRequest request, Model model) {
        SysLoginInfo info = this.getLoginInfo(request);
        String customerId = request.getParameter("customerId");
        model.addAttribute("customerId", customerId);
        return "/uglcw/customer/customer_exec_ware_price_tree";
    }

    @RequestMapping("/toCustomerExecWarePricePage")
    public String toCustomerExecWarePricePage(HttpServletRequest request, Integer wtype, Model model) {
        SysLoginInfo info = this.getLoginInfo(request);
        String customerId = request.getParameter("customerId");
        model.addAttribute("customerId", customerId);
        model.addAttribute("wtype", wtype);
        String isType = request.getParameter("isType");
        if(StrUtil.isNull(isType)){
            model.addAttribute("isType", "");
        }else{
            model.addAttribute("isType", isType);
        }
        return "/uglcw/customer/customer_exec_ware_price_page";
    }

    @RequestMapping("/customerExecWarePricePage")
    public void customerExecWarePricePage(Integer wtype, int page, int rows, SysWare ware, HttpServletResponse response, HttpServletRequest request) {
        SysLoginInfo info = this.getLoginInfo(request);
        ware.setWaretype(wtype);
        String customerId = request.getParameter("customerId");
        try {
            ware.setWaretype(wtype);
            Page p = this.sysWaresService.queryCompanyStockWare(ware, page, rows, info.getDatasource());
            if (p.getRows() != null && p.getRows().size() > 0) {
                customerService.loadCustomerPrice(p.getRows(), info, customerId);
            }

            JSONObject json = new JSONObject();
            json.put("total", p.getTotal());
            json.put("rows", p.getRows());
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            log.error("", e);
        }
    }

    @RequestMapping("/loadCustomerWarePrices")
    public void loadCustomerWarePrices(HttpServletResponse response, HttpServletRequest request) {
        SysLoginInfo info = this.getLoginInfo(request);
        String customerId = request.getParameter("customerId");
        String wareIds = request.getParameter("wareIds");
        try {
            List<SysWare> wareList =    this.sysWaresService.queryListByIds(wareIds,info.getDatasource());
            if (wareList != null &&wareList.size() > 0) {
                customerService.loadCustomerPrice(wareList, info, customerId);
            }
            JSONObject json = new JSONObject();
            json.put("total", wareList.size());
            json.put("rows", wareList);
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            log.error("", e);
        }
    }


    @RequestMapping("/toCustomerGroupWarePrice")
    public String toCustomerGroupWarePrice(HttpServletRequest request, Model model) {
        SysLoginInfo info = this.getLoginInfo(request);
        return "/uglcw/customer/customer_group_ware_price";
    }

    @RequestMapping("/customerGroupWarePrice")
    public void customerGroupWarePrice(int page, int rows, SysWare ware, HttpServletResponse response, HttpServletRequest request) {
        SysLoginInfo info = this.getLoginInfo(request);
        try {
            JSONObject json = new JSONObject();
            if (StrUtil.isNull(ware.getWareId())) {
                json.put("total", 0);
                json.put("rows", "");
                this.sendJsonResponse(response, json.toString());
                return;
            }
            SysWare sysWare = this.sysWaresService.queryWareById(ware.getWareId(), info.getDatasource());
            //List<SysCustomerPrice> groupWarePriceList = customerService.groupCustomerWarePrice(sysWare,info);
            List<SysWare> groupCustomerPrice = customerService.groupCustomerPrice(sysWare, info);
            json.put("total", groupCustomerPrice.size());
            json.put("rows", groupCustomerPrice);
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            log.error("", e);
        }
    }

    @RequestMapping("/toCustomerGroupWarePriceList")
    public String toCustomerGroupWarePriceList(HttpServletRequest request, SysWare sysWare, Model model) {
        SysLoginInfo info = this.getLoginInfo(request);
        request.setAttribute("sysWare", sysWare);
        return "/uglcw/customer/customer_group_ware_price_list";
    }

    @RequestMapping("/customerGroupWarePriceList")
    public void customerGroupWarePriceList(int page, int rows, SysWare ware, HttpServletResponse response, HttpServletRequest request) {
        SysLoginInfo info = this.getLoginInfo(request);
        try {
            SysWare sysWare = this.sysWaresService.queryWareById(ware.getWareId(), info.getDatasource());
            ware.setHsNum(sysWare.getHsNum());
            List<SysCustomer> customerList = customerService.calGroupCustomerPrice(ware, sysWare, info);
            JSONObject json = new JSONObject();
            json.put("total", customerList.size());
            json.put("rows", customerList);
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            log.error("", e);
        }
    }

    @RequestMapping("/updateCustomerWarePrices")
    public void updateCustomerWarePrices(HttpServletResponse response, HttpServletRequest request, Integer customerId, String wareStr) {
        SysLoginInfo info = this.getLoginInfo(request);
        JSONObject json = new JSONObject();
        try {
            int i = 0;
            net.sf.json.JSONArray jsonarray = net.sf.json.JSONArray.fromObject(wareStr);
            int len = jsonarray.size();
            if (!StrUtil.isNull(wareStr)) {
                if (len > 0) {
                    for (int j = 0; j < len; j++) {
                        net.sf.json.JSONObject data = (net.sf.json.JSONObject) jsonarray.get(j);
                        Integer wareId  = data.getInt("wareId");
                        BigDecimal newHisPirce = new BigDecimal(0);
                        if(data.containsKey("price")){
                            newHisPirce = new BigDecimal(data.get("price")+"");
                        }
                        BigDecimal newHisMinPirce = new BigDecimal(0);
                        if(data.containsKey("minPrice")){
                            newHisMinPirce = new BigDecimal(data.get("minPrice")+"");
                        }
                        SysCustomerPrice param = new SysCustomerPrice();
                        param.setCustomerId(customerId);
                        param.setWareId(wareId);
                        SysCustomerPrice sysCustomerPrice = customerService.queryCustomerPrice(param, info.getDatasource());
                        if(sysCustomerPrice==null){
                            sysCustomerPrice = new SysCustomerPrice();
                            sysCustomerPrice.setWareId(wareId);
                            sysCustomerPrice.setCustomerId(customerId);
                        }

                        if(!StrUtil.isNumberNullOrZero(newHisPirce)){
                            sysCustomerPrice.setMaxHisGyPrice(newHisPirce.doubleValue());
                        }

                        if(!StrUtil.isNumberNullOrZero(newHisMinPirce)){
                            sysCustomerPrice.setMinHisGyPrice(newHisMinPirce.doubleValue());
                        }

                        this.customerService.updateSysCustomerPrice(info.getDatasource(), sysCustomerPrice);
                    }
                }
            }
            json.put("state", true);
            //i = this.customerService.updateSysCustomerPrice(info.getDatasource(), sysCustomerPrice);
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            e.printStackTrace();
            log.error("", e);
        }
    }

    @RequestMapping("/updateCustomerWareZxPrices")
    public void updateCustomerWareZxPrices(HttpServletResponse response, HttpServletRequest request, Integer customerId, String wareStr) {
        SysLoginInfo info = this.getLoginInfo(request);
        JSONObject json = new JSONObject();
        try {
            int i = 0;
            net.sf.json.JSONArray jsonarray = net.sf.json.JSONArray.fromObject(wareStr);
            int len = jsonarray.size();
            if (!StrUtil.isNull(wareStr)) {
                if (len > 0) {
                    for (int j = 0; j < len; j++) {
                        net.sf.json.JSONObject data = (net.sf.json.JSONObject) jsonarray.get(j);
                        Integer wareId  = data.getInt("wareId");
                        BigDecimal newPirce = new BigDecimal(0);
                        BigDecimal newMinPirce = new BigDecimal(0);
                        if(data.containsKey("price")){
                            newPirce = new BigDecimal(data.get("price")+"");
                        }
                        if(data.containsKey("minPrice")){
                            newMinPirce = new BigDecimal(data.get("minPrice")+"");
                        }
                        SysCustomerPrice param = new SysCustomerPrice();
                        param.setCustomerId(customerId);
                        param.setWareId(wareId);
                        SysCustomerPrice sysCustomerPrice = customerService.queryCustomerPrice(param, info.getDatasource());
                        if(sysCustomerPrice==null){
                            sysCustomerPrice = new SysCustomerPrice();
                            sysCustomerPrice.setWareId(wareId);
                            sysCustomerPrice.setCustomerId(customerId);
                        }

                        if(!StrUtil.isNumberNullOrZero(newPirce)){
                            sysCustomerPrice.setSaleAmt(newPirce);
                        }
                        if(!StrUtil.isNumberNullOrZero(newMinPirce)){
                            sysCustomerPrice.setSunitPrice(newMinPirce.doubleValue());
                        }

                        this.customerService.updateSysCustomerPrice(info.getDatasource(), sysCustomerPrice);
                    }
                }
            }
            json.put("state", true);
            //i = this.customerService.updateSysCustomerPrice(info.getDatasource(), sysCustomerPrice);
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            e.printStackTrace();
            log.error("", e);
        }
    }


    @RequestMapping("/deleteCustomerPriceByIds")
    public void deleteCustomerPriceByIds(HttpServletResponse response, HttpServletRequest request) {
        SysLoginInfo info = this.getLoginInfo(request);
        String customerIds = request.getParameter("customerIds");
        try {
            this.customerService.deleteCustomerPriceByIds(info.getDatasource(),customerIds);
            JSONObject json = new JSONObject();
            json.put("state", true);
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            log.error("", e);
        }
    }

}
