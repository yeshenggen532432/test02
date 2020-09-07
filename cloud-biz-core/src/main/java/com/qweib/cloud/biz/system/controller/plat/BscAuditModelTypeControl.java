package com.qweib.cloud.biz.system.controller.plat;

import com.qweib.cloud.biz.common.GeneralControl;
import com.qweib.cloud.biz.common.Response;
import com.qweib.cloud.biz.system.service.BscAuditModelService;
import com.qweib.cloud.biz.system.service.BscAuditModelTypeService;
import com.qweib.cloud.core.domain.BscAuditModel;
import com.qweib.cloud.core.domain.BscAuditModelType;
import com.qweib.cloud.core.domain.BscAuditSubject;
import com.qweib.cloud.core.domain.SysLoginInfo;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import net.sf.json.JSONArray;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.*;

/**
 * 审批类型明细（选择科目）
 */
@Controller
@RequestMapping("manager")
public class BscAuditModelTypeControl extends GeneralControl {
    @Resource
    private BscAuditModelService auditModelService;
    @Resource
    private BscAuditModelTypeService auditModelTypeService;


    @RequestMapping("toAuditModelType")
    public String toAuditModel(HttpServletRequest request, Model model) {
        return "/companyPlat/audit/auditModelType";
    }


    /**
     * 查询审批模板
     */
    @ResponseBody
    @RequestMapping("queryAuditTypeList")
    public Map<String, Object> queryAuditTypePage(HttpServletRequest request,BscAuditModel bean) {
            SysLoginInfo info = getLoginInfo(request);
            List<BscAuditModel> list = this.auditModelService.queryAuditModelListByNoType(bean, info.getDatasource());
            Map<String, Object> map = new HashMap<>();
            map.put("total", list.size());
            map.put("rows", list);
            return map;
    }

    /**
     * 批量添加审批模板类型科目
     */
    @ResponseBody
    @RequestMapping("batchAddAuditModeType")
    public Response batchAddAuditModeType(HttpServletRequest request, Integer modelId, String json) {
        SysLoginInfo info = getLoginInfo(request);
        //json转list--start
        List<BscAuditModelType> list = new ArrayList();
        JSONArray jsonarray = JSONArray.fromObject(json);
        int len = jsonarray.size();
        if (!StrUtil.isNull(json) && len > 0) {
            for(int j = 0; j < len; ++j) {
                net.sf.json.JSONObject json1 = (net.sf.json.JSONObject)jsonarray.get(j);
                BscAuditModelType bean = new BscAuditModelType();
                bean.setSubjectType(json1.getString("typeId"));
                bean.setSubjectItem(json1.getString("id"));
                list.add(bean);
            }
        }
        //json转list--end
        int[] i = auditModelTypeService.batchAddAuditModelType(info.getDatasource(),modelId,list);
        if(i != null && i.length > 0){
            return  Response.createSuccess();
        }else{
            return Response.createError("操作失败");
        }
    }

    /**
     * 批量删除审批模板类型科目
     */
    @ResponseBody
    @RequestMapping("batchDelAuditModeType")
    public Response batchDelAuditModeType(HttpServletRequest request, String ids) {
        SysLoginInfo info = getLoginInfo(request);
        int i = auditModelTypeService.batchDelAuditModeType(info.getDatasource(),ids);
        if(i > 0){
            return  Response.createSuccess();
        }else{
            return Response.createError("操作失败");
        }
    }

    /**
     * 查询审批模板类型科目
     */
    @ResponseBody
    @RequestMapping("queryAuditModelType")
    public Map<String, Object> queryAuditModelType(HttpServletRequest request, BscAuditModelType bean, Integer page, Integer rows) {
        SysLoginInfo info = getLoginInfo(request);
        Page p = auditModelTypeService.queryAuditModelType(info.getDatasource(),bean, page, rows);
        Map<String, Object> json = new HashMap<>();
        json.put("total", p.getTotal());
        json.put("rows", p.getRows());
        return json;
    }

    /**
     * 查询审批模板类型科目（过滤已添加）
     */
    @ResponseBody
    @RequestMapping("/queryAuditModelTypePageFilterAdd")
    public Map<String, Object> queryUseCostItemPage(HttpServletRequest request, BscAuditSubject item, Integer page, Integer rows) {
//        SysLoginInfo info = getLoginInfo(request);
//        item.setStatus(1);
//        Page p = this.auditModelTypeService.queryCostItemPage(item, info.getDatasource(),page, rows);
        Map<String, Object> json = new HashMap<>();
//        json.put("state", true);
//        json.put("total", p.getTotal());
//        json.put("rows", p.getRows());
        return json;
    }

}
