package com.qweib.cloud.biz.system.controller.plat;

import com.qweib.cloud.biz.common.GeneralControl;
import com.qweib.cloud.biz.system.service.BscAuditModelService;
import com.qweib.cloud.biz.system.service.ws.BscAuditZdyWebService;
import com.qweib.cloud.biz.system.service.ws.SysMemWebService;
import com.qweib.cloud.core.domain.*;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.Valid;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 审批模板
 */
@Controller
@RequestMapping("manager")
public class BscAuditModelControl extends GeneralControl {
    @Resource
    private BscAuditModelService auditModelService;


    @RequestMapping("toAuditModel")
    public String toAuditModel(HttpServletRequest request, Model model) {
        return "/companyPlat/audit/auditModel";
    }


    /**
     * 查询审批模板
     */
    @ResponseBody
    @RequestMapping("queryAuditModelPage")
    public Map<String, Object> queryAuditModelPage(HttpServletRequest request,BscAuditModel bean, Integer page, Integer rows) {
            SysLoginInfo info = getLoginInfo(request);

            Page p = this.auditModelService.queryAuditModelPage(bean, info.getDatasource(), page, rows);
            Map<String, Object> map = new HashMap<>();
            map.put("total", p.getTotal());
            map.put("rows", p.getRows());
            return map;
    }

    /**
     * 查询审批模板
     */
    @ResponseBody
    @RequestMapping("queryAuditModelList")
    public Map<String, Object> queryAuditModelList(HttpServletRequest request,BscAuditModel bean) {
        SysLoginInfo info = getLoginInfo(request);
        if(bean.getDelFlag() == null){
            bean.setDelFlag(0);
        }
        List<BscAuditModel> list = this.auditModelService.queryAuditModelList(bean, info.getDatasource());

        Map<String, Object> map = new HashMap<>();
        map.put("list", list);
        return map;
    }

    /**
     * 查询审批模板
     */
    @ResponseBody
    @RequestMapping("queryAuditModelById")
    public Map<String, Object> queryAuditModelById(HttpServletRequest request, String token, Integer id) {
        SysLoginInfo info = getLoginInfo(request);
        BscAuditModel bean = this.auditModelService.queryAuditModelById(id, info.getDatasource());

        Map<String, Object> map = new HashMap<>();
        map.put("state", true);
        map.put("msg", "查询成功");
        map.put("data", bean);
        return map;
    }

}
