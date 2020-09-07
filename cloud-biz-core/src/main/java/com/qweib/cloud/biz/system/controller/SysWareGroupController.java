package com.qweib.cloud.biz.system.controller;

import com.qweib.cloud.biz.common.GeneralControl;
import com.qweib.cloud.biz.system.service.SysWareGroupService;
import com.qweib.cloud.core.domain.SysLoginInfo;
import com.qweib.cloud.core.domain.SysWareGroup;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * @author: yueji.hu
 * @time: 2019-09-05 11:34
 * @description:
 */
@Controller
@RequestMapping("/manager")
public class SysWareGroupController extends GeneralControl {
    @Resource
    private SysWareGroupService sysWareGroupService;


    @RequestMapping("wareGroupPage")
    public void wareGroupPage(SysWareGroup sysWareGroup, int page, int rows, HttpServletResponse response, HttpServletRequest request){
        try {
            SysLoginInfo info = this.getLoginInfo(request);
            Page p = this.sysWareGroupService.wareGroupPage(sysWareGroup, info.getDatasource(), page, rows);
            JSONObject json = new JSONObject();
            json.put("total", p.getTotal());
            json.put("rows", p.getRows());
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            log.error("分页查询多规格商品组名出错：", e);
        }
    }

    @RequestMapping("operwareGroup")
    public void operwareGroup(SysWareGroup sysWareGroup, HttpServletResponse response, HttpServletRequest request){
        try {
            SysLoginInfo info = this.getLoginInfo(request);
            if(!StrUtil.isNull(sysWareGroup)){
                if(null!=sysWareGroup.getId()&&sysWareGroup.getId()>0){
                    this.sysWareGroupService.updateWareGroupName(sysWareGroup, info.getDatasource());
                    this.sendHtmlResponse(response, "2");
                }else{
                    this.sysWareGroupService.addWareGroupName(sysWareGroup, info.getDatasource());
                    this.sendHtmlResponse(response, "1");
                }
            }
        } catch (Exception e) {
            log.error("操作多规格商品组名出错：", e);
            this.sendHtmlResponse(response, "-1");
        }
    }

    @RequestMapping("deleteGroupById")
    public void deleteGroupById(Integer id, HttpServletResponse response, HttpServletRequest request){
        try {
            SysLoginInfo info = this.getLoginInfo(request);
            this.sysWareGroupService.deleteGroupById(id, info.getDatasource());
            this.sendHtmlResponse(response, "1");
        } catch (Exception e) {
            log.error("删除多规格商品组名：", e);
            this.sendHtmlResponse(response, "-1");
        }
    }


}
