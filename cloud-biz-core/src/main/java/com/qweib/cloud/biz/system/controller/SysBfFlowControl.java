package com.qweib.cloud.biz.system.controller;

import com.qweib.cloud.biz.common.GeneralControl;
import com.qweib.cloud.biz.system.service.SysBfFlowService;
import com.qweib.cloud.core.domain.SysBfFlow;
import com.qweib.cloud.core.domain.SysLoginInfo;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;

@Controller
@RequestMapping("/manager")
public class SysBfFlowControl extends GeneralControl {
    @Resource
    private SysBfFlowService sysBfFlowService;


    @RequestMapping("/queryBfFlow")
    public void queryBfFlow(HttpServletRequest request, HttpServletResponse response) {

        SysLoginInfo info = this.getLoginInfo(request);
        try {
            List<SysBfFlow> list = this.sysBfFlowService.queryFlowList(info.getDatasource());
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("total", list.size());
            json.put("rows", list);

            this.sendJsonResponse(response, json.toString());

        } catch (Exception e) {
            log.error("查询拜访流程出错", e);
        }
    }

    @RequestMapping("/toSysBfFlow")
    public String toSysBfFlow(HttpServletRequest request, Model model, String dataTp) {
        try {
            SysLoginInfo info = this.getLoginInfo(request);

        } catch (Exception e) {
            // TODO: handle exception
            log.error("登录错误", e);
        }
        return "/uglcw/bfxsxj/sys_bf_flow";
    }

    @RequestMapping("/saveBfFlow")
    public void saveBfFlow(HttpServletResponse response, HttpServletRequest request, SysBfFlow flow) {
        try {
            SysLoginInfo info = this.getLoginInfo(request);
            int ret = 0;
            if (flow.getId() != null) {
                if (flow.getId().intValue() > 0) ret = this.sysBfFlowService.updateBfFlow(flow,info.getDatasource());
                else
                    ret = this.sysBfFlowService.addBfFlow(flow, info.getDatasource());
            } else
                ret = this.sysBfFlowService.addBfFlow(flow, info.getDatasource());
            if (ret > 0)
                this.sendHtmlResponse(response, "1");
            else
                this.sendHtmlResponse(response, "-1");
        } catch (Exception e) {
            log.error("保存拜访流程设置出错：", e);
        }
    }

    @RequestMapping("/chooseBfFlow")
    public void chooseBfFlow(HttpServletResponse response, HttpServletRequest request, SysBfFlow flow) {
        try {
            SysLoginInfo info = this.getLoginInfo(request);
            int ret = 0;
            SysBfFlow flow1 = this.sysBfFlowService.getFlowById(flow.getId(),info.getDatasource());
            if(flow1 == null)
            {
                this.sendHtmlResponse(response, "-1");
                return;
            }
            flow1.setStatus(flow.getStatus());
            ret = this.sysBfFlowService.updateBfFlow(flow1,info.getDatasource());

            if (ret > 0)
                this.sendHtmlResponse(response, "1");
            else
                this.sendHtmlResponse(response, "-1");
        } catch (Exception e) {
            log.error("保存拜访流程设置出错：", e);
        }
    }

    @RequestMapping("deleteBfFlow")
    public void deleteBfFlow(HttpServletResponse response, HttpServletRequest request, String token, Integer id) {
        SysLoginInfo info = this.getLoginInfo(request);
        try {

            int ret = this.sysBfFlowService.deleteBfFlow(id,info.getDatasource());
            JSONObject json = new JSONObject();
            if (ret > 0) {
                json.put("state", true);
                json.put("id", 0);
                json.put("msg", "删除成功");
            } else {
                json.put("state", false);
                json.put("id", 0);
                json.put("msg", "删除失败");
            }
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            this.sendJsonResponse(response, "删除流程失败");
        }
    }





}
