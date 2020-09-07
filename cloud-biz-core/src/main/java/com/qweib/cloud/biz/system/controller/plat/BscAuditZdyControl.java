package com.qweib.cloud.biz.system.controller.plat;

import com.qweib.cloud.biz.common.GeneralControl;
import com.qweib.cloud.biz.common.Response;
import com.qweib.cloud.biz.system.UserContext;
import com.qweib.cloud.biz.system.service.ApprovalTransOrderConfigService;
import com.qweib.cloud.biz.system.service.ws.BscAuditZdyWebService;
import com.qweib.cloud.biz.system.service.ws.SysMemWebService;
import com.qweib.cloud.core.domain.*;
import com.qweib.cloud.core.domain.approval.TransOrderConfigUpdate;
import com.qweib.cloud.utils.*;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.Valid;
import java.util.*;

/**
 * 审批流程
 */
@Controller
@RequestMapping("manager")
public class BscAuditZdyControl extends GeneralControl {
    @Resource
    private SysMemWebService memWebService;
    @Resource
    private BscAuditZdyWebService auditZdyWebService;
    @Autowired
    ApprovalTransOrderConfigService approvalTransOrderConfigService;


    @RequestMapping("toAuditZdy")
    public String toAuditZdy(HttpServletRequest request, Model model) {
        return "/companyPlat/audit/auditZdy";
    }

    /**
     * 保存审批自定义
     */
    @RequestMapping("saveAuditZdy")
    public void saveAuditZdy(HttpServletRequest request, HttpServletResponse response, @RequestBody @Valid BscAuditZdy bean) {
        try {
            SysLoginInfo info = this.getLoginInfo(request);
            String zdyNm = bean.getZdyNm();
            Integer id = bean.getId();
            BscAuditZdy nameAuditZdy = this.auditZdyWebService.queryAuditZdyByName(info.getDatasource(), zdyNm);
            if (id == null) {
                if (nameAuditZdy!=null) {
                    sendHtmlResponse(response, "2");
                    return;
                }
                //私用:发起人是自己
                if("1".equals(bean.getIsSy())){
                    bean.setSendIds(""+info.getIdKey());
                }
                bean.setMemberId(info.getIdKey());
                this.auditZdyWebService.addBscAuditZdy(bean, info.getDatasource());
            } else {
                BscAuditZdy oldAuditZdy = this.auditZdyWebService.queryAuditZdyById(id, info.getDatasource());
                if (nameAuditZdy !=null && !oldAuditZdy.getZdyNm().equals(nameAuditZdy.getZdyNm())) {
                    sendHtmlResponse(response, "2");
                    return;
                }
                //私用:发起人是自己
                if("1".equals(bean.getIsSy())){
                    oldAuditZdy.setSendIds(""+info.getIdKey());
                }
                //页面上的数据
                if(Objects.isNull(oldAuditZdy.getMemberId())){
                    oldAuditZdy.setMemberId(info.getIdKey());
                }
                oldAuditZdy.setModelId(bean.getModelId());
                oldAuditZdy.setZdyNm(bean.getZdyNm());
                oldAuditZdy.setTp(bean.getTp());
                oldAuditZdy.setIsSy(bean.getIsSy());
                oldAuditZdy.setSendIds(bean.getSendIds());
                oldAuditZdy.setMemIds(bean.getMemIds());
                oldAuditZdy.setApproverId(bean.getApproverId());
                oldAuditZdy.setExecIds(bean.getExecIds());
                oldAuditZdy.setIsUpdateAudit(bean.getIsUpdateAudit());
                oldAuditZdy.setIsUpdateApprover(bean.getIsUpdateApprover());
                this.auditZdyWebService.updateAuditZdy(info.getDatasource(), oldAuditZdy);

                //如果修改了“审批模板”，“审批科目设置”要重新设置
                Integer oldModelId = oldAuditZdy.getModelId();
                if(oldModelId != null && !oldModelId.equals(bean.getModelId())){
                    approvalTransOrderConfigService.deleteByApprovalId(info.getDatasource(), "" + oldAuditZdy.getId());
                }
            }
            this.sendHtmlResponse(response, "1");
        } catch (Exception e) {
            log.error("保存审批自定义失败");
            sendHtmlResponse(response, "-1");
        }
    }

    /**
     * 查询审批自定义
     */
    @RequestMapping("queryAuditZdyList")
    public void queryAuditZdyList(HttpServletRequest request, HttpServletResponse response, BscAuditZdy bean) {
        try {
            SysLoginInfo info = this.getLoginInfo(request);
            List<BscAuditZdy> list = this.auditZdyWebService.queryAuditZdyList(info.getIdKey(), info.getDatasource(), bean);
            //添加审批人
            for (int i = 0; i < list.size(); i++) {
                if (!StrUtil.isNull(list.get(i).getMemIds())) {
                    List<SysMember> listm = new ArrayList<>();
                    for (int j = 0; j < list.get(i).getMemIds().split(",").length; j++) {
                        Integer mid = Integer.parseInt(list.get(i).getMemIds().split(",")[j]);
                        SysMember mer = this.memWebService.queryMemByMid(mid, info.getDatasource());
                        listm.add(mer);
                    }
                    list.get(i).setMlist(listm);
                }
                if (!StrUtil.isNull(list.get(i).getSendIds())) {
                    List<SysMember> sendList = new ArrayList<>();
                    for (int j = 0; j < list.get(i).getSendIds().split(",").length; j++) {
                        Integer mid = Integer.parseInt(list.get(i).getSendIds().split(",")[j]);
                        SysMember mer = this.memWebService.queryMemByMid(mid, info.getDatasource());
                        sendList.add(mer);
                    }
                    list.get(i).setSendList(sendList);
                }
                if (!StrUtil.isNull(list.get(i).getExecIds())) {
                    List<SysMember> execList = new ArrayList<>();
                    for (int j = 0; j < list.get(i).getExecIds().split(",").length; j++) {
                        Integer mid = Integer.parseInt(list.get(i).getExecIds().split(",")[j]);
                        SysMember mer = this.memWebService.queryMemByMid(mid, info.getDatasource());
                        execList.add(mer);
                    }
                    list.get(i).setExecList(execList);
                }
                if (!StrUtil.isNull(list.get(i).getApproverId())) {
                    SysMember member = this.memWebService.queryMemByMid(list.get(i).getApproverId(), info.getDatasource());
                    list.get(i).setApprover(member);
                }
            }
            JSONObject json = new JSONObject();
            json.put("total", list.size());
            json.put("rows", list);
            sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            e.printStackTrace();
            log.error("查询审批流列表失败", e);
        }
    }

    /**
     * 修改审批流启用状态
     */
    @ResponseBody
    @RequestMapping("updateAuditZdyStatus")
    public Response updateAuditZdyState(Integer id){
        SysLoginInfo loginInfo = UserContext.getLoginInfo();
        BscAuditZdy oldAuditZdy = this.auditZdyWebService.queryAuditZdyById(id, loginInfo.getDatasource());
        if(oldAuditZdy != null){
            Integer state = oldAuditZdy.getStatus();
            if(state != null && state == 1){
                oldAuditZdy.setStatus(0);
            }else{
                oldAuditZdy.setStatus(1);
            }
        }
        this.auditZdyWebService.updateAuditZdy(loginInfo.getDatasource(), oldAuditZdy);
        return Response.createSuccess();
    }

    /**
     * 修改审批流是否同步手机端
     */
    @ResponseBody
    @RequestMapping("updateAuditZdyIsMobile")
    public Response updateAuditZdyIsMobile(Integer id){
        SysLoginInfo loginInfo = UserContext.getLoginInfo();
        BscAuditZdy oldAuditZdy = this.auditZdyWebService.queryAuditZdyById(id, loginInfo.getDatasource());
        if(oldAuditZdy != null){
            String isMobile = oldAuditZdy.getIsMobile();
            if(isMobile != null && "1".equals(isMobile)){
                oldAuditZdy.setIsMobile("0");
            }else{
                oldAuditZdy.setIsMobile("1");
            }
        }
        this.auditZdyWebService.updateAuditZdy(loginInfo.getDatasource(), oldAuditZdy);
        return Response.createSuccess();
    }

    @ResponseBody
    @RequestMapping("/updateAuditZdySort")
    public Response updateSort(Integer id,Integer sort){
        SysLoginInfo loginInfo = UserContext.getLoginInfo();
        BscAuditZdy oldAuditZdy = this.auditZdyWebService.queryAuditZdyById(id, loginInfo.getDatasource());
        oldAuditZdy.setSort(sort);
        this.auditZdyWebService.updateAuditZdy(loginInfo.getDatasource(), oldAuditZdy);
        return Response.createSuccess();
    }

    /**
     * 根据modelId查询审批流列表
     */
    @ResponseBody
    @RequestMapping("queryAuditZdyPageByModelId")
    public Map<String, Object> queryAuditZdyPageByModelId(Integer modelId, Integer page, Integer rows) {
        SysLoginInfo loginInfo = UserContext.getLoginInfo();
        Page p = auditZdyWebService.queryAuditZdyPageByModelId(loginInfo.getDatasource(), modelId, page, rows);
        setAuditMemberList(loginInfo.getDatasource(), p.getRows());
//        JSONObject json = new JSONObject();
//        json.put("total", p.getRows().size());
//        json.put("rows", p.getRows());
//        json.put("state", true);
//        sendJsonResponse(response, json.toString());
        Map<String, Object> map = new HashMap<>();
        map.put("total", p.getRows().size());
        map.put("rows", p.getRows());
        map.put("state", true);
        return map;
    }

    /**
     * 设置审批流的审核人，最终审核人，执行人
     */
    private void setAuditMemberList(String dataBase, List<BscAuditZdy> list) {
        List<SysMember> sysMemberList = memWebService.queryMemberList(dataBase);
        for (int i = 0; i < list.size(); i++) {
            List<SysMember> auditMemberList = new ArrayList<>();
            List<SysMember> execMemberList = new ArrayList<>();
            for (SysMember memDTO : sysMemberList) {
                if (!StrUtil.isNull(list.get(i).getMemIds())) {
                    String[] memIds = list.get(i).getMemIds().split(",");
                    for (String s : memIds) {
                        if (String.valueOf(memDTO.getMemberId()).equals(s)) {
                            auditMemberList.add(memDTO);
                            break;
                        }
                    }
                }
                if (!StrUtil.isNull(list.get(i).getExecIds())) {
                    String[] execIds = list.get(i).getExecIds().split(",");
                    for (String s : execIds) {
                        if (String.valueOf(memDTO.getMemberId()).equals(s)) {
                            execMemberList.add(memDTO);
                            break;
                        }
                    }
                }
                if (!StrUtil.isNull(list.get(i).getApproverId())) {
                    if (String.valueOf(memDTO.getMemberId()).equals("" + list.get(i).getApproverId())) {
                        list.get(i).setApprover(memDTO);
                    }
                }

            }
            list.get(i).setMlist(auditMemberList);
            list.get(i).setExecList(execMemberList);
        }
    }


}
