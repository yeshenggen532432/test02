package com.qweib.cloud.biz.system.controller;

import com.qweib.cloud.biz.common.GeneralControl;
import com.qweib.cloud.biz.common.Response;
import com.qweib.cloud.biz.system.UserContext;
import com.qweib.cloud.biz.system.service.SysChainStoreService;
import com.qweib.cloud.biz.system.service.SysCustomerService;
import com.qweib.cloud.core.domain.SysChainStore;
import com.qweib.cloud.core.domain.SysLoginInfo;
import com.qweib.cloud.core.exception.BizException;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * @author: yueji.hu
 * @time: 2019-09-06 14:54
 * @description:
 */
@Controller
@RequestMapping("/manager")
public class SysChainStoreController extends GeneralControl {
    @Resource
    private SysChainStoreService sysChainStoreService;
    @Resource
    private SysCustomerService customerService;

    @GetMapping("/chain/store")
    public String toChainstore() {
        return "uglcw/chainstore/index";

    }

    @RequestMapping("queryChainStore")
    public void wareGroupPage(SysChainStore sysChainStore, int page, int rows, HttpServletResponse response, HttpServletRequest request){
        try {
            SysLoginInfo info = this.getLoginInfo(request);
            Page p = this.sysChainStoreService.queryChainStore(sysChainStore, info.getDatasource(), page, rows);
            JSONObject json = new JSONObject();
            json.put("total", p.getTotal());
            json.put("rows", p.getRows());
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            log.error("分页查询多规格商品组名出错：", e);
        }
    }

    @RequestMapping("operChainStore")
    public void operChainStore(SysChainStore sysChainStore, HttpServletResponse response, HttpServletRequest request){
        try {
            SysLoginInfo info = this.getLoginInfo(request);
            if(!StrUtil.isNull(sysChainStore)){
                if(null!=sysChainStore.getId()&&sysChainStore.getId()>0){
                    this.sysChainStoreService.updateCustomerChainStore(sysChainStore, info.getDatasource());
                    this.sendHtmlResponse(response, "2");
                }else{
                    this.sysChainStoreService.addCustomerChainStore(sysChainStore, info.getDatasource());
                    this.sendHtmlResponse(response, "1");
                }
            }
        } catch (Exception e) {
            log.error("操作多规格商品组名出错：", e);
            this.sendHtmlResponse(response, "-1");
        }
    }

    @RequestMapping("deleteById")
    public void deleteById(Integer id, HttpServletResponse response, HttpServletRequest request){
        try {
            SysLoginInfo info = this.getLoginInfo(request);
            int count =this.customerService.queryShopId(id,info.getDatasource());
            if(count>0){
                this.sendHtmlResponse(response, "2");
                return;
            }
            this.sysChainStoreService.deleteById(id, info.getDatasource());
            this.sendHtmlResponse(response, "1");
        } catch (Exception e) {
            log.error("删除多规格商品组名：", e);
            this.sendHtmlResponse(response, "-1");
        }
    }
    @ResponseBody
    @RequestMapping("updateChainStoreState")
    public Response updateChainStoreState(Integer id ,Integer status){
        SysLoginInfo info = UserContext.getLoginInfo();
        if(status.equals(2)){
            int count =this.customerService.queryShopId(id,info.getDatasource());
            if(count>0){
                throw new BizException("连锁店内有归属客户不能禁用");
            }
        }
        int i = this.sysChainStoreService.updateChainStoreState(id, status, info.getDatasource());
        if(i < 1){
            throw new BizException("操作失败");

        }
        return  Response.createSuccess().setMessage("操作成功");
    }

}
