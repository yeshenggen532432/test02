package com.qweib.cloud.biz.system.controller;

import com.qweib.cloud.biz.common.GeneralControl;
import com.qweib.cloud.biz.system.service.*;
import com.qweib.cloud.biz.system.service.plat.SysMemberService;
import com.qweib.cloud.biz.system.service.ws.SysDepartService;
import com.qweib.cloud.core.domain.*;
import com.qweib.cloud.utils.*;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.*;

/**
 * 临时客户
 */
@Controller
@RequestMapping("/manager")
public class SysCustomerTmpControl extends GeneralControl {
    @Resource
    private SysCustomerTmpService customerTmpService;
    @Resource
    private SysCustomerService customerService;



    /**
     * 菜单：跳转“临时客户”
     */
    @RequestMapping("/toQueryCustomerTmp")
    public String queryCustomerTmpPage(HttpServletRequest request, Model model, String dataTp, Integer page) {
        SysLoginInfo info = this.getLoginInfo(request);
        model.addAttribute("datasource", info.getDatasource());
        model.addAttribute("dataTp", dataTp);
        if (page == null) page = 1;
        model.addAttribute("page", page);
        return "/uglcw/customer/tmp/customer_tmp";
    }

    /**
     * 分页查询临时客户
     */
    @RequestMapping("/queryCustomerTmpPage")
    public void queryCustomerTmpPage(HttpServletRequest request, HttpServletResponse response, SysCustomerTmp bean, String dataTp,
                              Integer page, Integer rows) {
        try {
            SysLoginInfo info = this.getLoginInfo(request);
            Page p = this.customerTmpService.queryCustomerTmpPage(bean, dataTp, info, page, rows);
            JSONObject json = new JSONObject();
            json.put("total", p.getTotal());
            json.put("rows", p.getRows());
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            e.printStackTrace();
            log.error("分页查询客户出错", e);
        }
    }

    /**
     * 临时客户转为正式客户
     */
    @RequestMapping("/addCustomerTmpToCustomer")
    public void addCustomerTmpToCustomer(HttpServletRequest request, HttpServletResponse response, Integer id, String khNm) {
        try {
            SysLoginInfo info = this.getLoginInfo(request);
            SysCustomer customer = this.customerService.querySysCustomerByName(info.getDatasource(), khNm);
            if(customer != null){
                this.sendHtmlResponse(response, "-1");
                return;
            }
            SysCustomerTmp customerTmp = new SysCustomerTmp();
            customerTmp.setId(id);
            SysCustomerTmp oldCustomerTmp = this.customerTmpService.queryTmpCustomer(customerTmp,info.getDatasource());
            if(oldCustomerTmp != null){
                customer = new SysCustomer();
                customer.setKhNm(khNm);
                customer.setAddress(oldCustomerTmp.getAddress());
                customer.setLongitude(oldCustomerTmp.getLongitude());
                customer.setLatitude(oldCustomerTmp.getLatitude());
                customer.setMemId(oldCustomerTmp.getMemId());
                customer.setBranchId(oldCustomerTmp.getBranchId());
                //默认的
                customer.setKhTp(1);
                customer.setCreateTime(DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd HH:mm:ss"));
            }
            int count = this.customerService.addCustomer(customer, info.getDatasource());
            if(count > 0){
                oldCustomerTmp.setIsDb(1);
                this.customerTmpService.updateTmpCustomer(oldCustomerTmp, info.getDatasource());
                this.sendHtmlResponse(response, "1");
            }else{
                this.sendHtmlResponse(response, "-2");
            }
        } catch (Exception e) {
            e.printStackTrace();
            log.error("临时客户转为正式客户失败", e);
            this.sendHtmlResponse(response, "-2");
        }
    }






}



