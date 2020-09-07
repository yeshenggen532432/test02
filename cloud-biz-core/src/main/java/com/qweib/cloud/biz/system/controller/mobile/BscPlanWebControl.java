package com.qweib.cloud.biz.system.controller.mobile;


import com.qweib.cloud.biz.system.BaseWebService;
import com.qweib.cloud.biz.system.TokenServer;
import com.qweib.cloud.biz.system.service.SysCustomerService;
import com.qweib.cloud.biz.system.service.ws.BscPlanWebService;
import com.qweib.cloud.biz.system.service.ws.BscPlanxlDetailWebService;
import com.qweib.cloud.biz.system.service.ws.SysDepartService;
import com.qweib.cloud.biz.system.service.ws.SysMemberWebService;
import com.qweib.cloud.core.domain.*;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/web")
public class BscPlanWebControl extends BaseWebService {
    @Resource
    private BscPlanWebService planWebService;
    @Resource
    private SysMemberWebService memberWebService;
    @Resource
    private SysCustomerService customerService;
    @Resource
    private BscPlanxlDetailWebService planxlDetailWebService;
    @Resource
    private SysDepartService departService;

    /**
     * 说明：分页查询拜访计划
     */
    @RequestMapping("queryBscPlanWeb")
    public void queryBscPlanWeb(HttpServletResponse response, String token, Integer pageNo, Integer pageSize,
                                String pdate, String tp, String mids, @RequestParam(defaultValue = "3") String dataTp) {
        try {
            if (!checkParam(response, token, pdate, tp))
                return;
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            if (pageSize == null) {
                pageSize = 10;
            }
            OnlineUser onlineUser = message.getOnlineMember();
            SysMember member = this.memberWebService.queryAllById(onlineUser.getMemId());
            Page p = new Page();
            int coun1 = 0;
            if (tp.equals("2")) {
                p = this.planWebService.queryBscPlanWebForUnderling(onlineUser.getDatabase(), pageNo, pageSize, pdate, onlineUser.getMemId(), member.getBranchId(), "2", mids, dataTp);
                coun1 = this.planWebService.queryBscPlanWebCountForUnderling(onlineUser.getDatabase(), pdate, onlineUser.getMemId(), member.getBranchId(), "2", mids, dataTp);
            } else {
                p = this.planWebService.queryBscPlanWeb(onlineUser.getDatabase(), pageNo, pageSize, pdate, onlineUser.getMemId(), null, "1", mids);
                coun1 = this.planWebService.queryBscPlanWebCount(onlineUser.getDatabase(), pdate, onlineUser.getMemId(), null, "1", mids);
            }
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "获取拜访计划列表成功");
            json.put("pageNo", pageNo);
            json.put("pageSize", pageSize);
            json.put("total", p.getTotal());
            json.put("totalPage", p.getTotalPage());
            json.put("rows", p.getRows());
            json.put("coun1", coun1);
            json.put("coun2", p.getTotal() - coun1);
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            e.printStackTrace();
            log.error("获取拜访计划表失败", e);
            this.sendWarm(response, "获取拜访计划表失败");
        }
    }

    /**
     * 说明：分页查询拜访计划
     */
    @RequestMapping("queryBscPlanNewWeb")
    public void queryBscPlanNewWeb(HttpServletResponse response, String token, Integer pageNo, Integer pageSize,
                                   String pdate, int mid) {
        try {
            if (!checkParam(response, token, pdate)) {
                return;
            }
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                this.sendWarm(response, message.getMessage());
                return;
            }
            if (pageSize == null) {
                pageSize = 10;
            }
            OnlineUser onlineUser = message.getOnlineMember();
            Page p = new Page();
            int wcCount = 0;//完成数量
            //自己的
            BscPlanNew plan = this.planWebService.queryBscPlanNewWeb(onlineUser.getDatabase(), pdate, mid);
            if(plan != null){
                p = this.planWebService.queryBscPlanSubWeb(onlineUser.getDatabase(),plan.getId(), onlineUser.getMemId(), pageNo, pageSize);
                wcCount = this.planWebService.queryBscPlanNewWebCount(onlineUser.getDatabase(), plan.getId());
            }
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "获取拜访计划列表成功");
            json.put("pageNo", pageNo);
            json.put("pageSize", pageSize);
            json.put("total", p.getTotal());
            json.put("totalPage", p.getTotalPage());
            if(plan != null){
                json.put("xlNm", plan.getXlNm());
            }
            json.put("rows", p.getRows());
            json.put("coun1", wcCount);
            json.put("coun2", p.getTotal() - wcCount);
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            e.printStackTrace();
            log.error("获取拜访计划表失败", e);
            this.sendWarm(response, "获取拜访计划表失败");
        }
    }

    /**
     * 说明：分页查询拜访计划(下属的)
     */
    @RequestMapping("queryBscPlanNewUnderlingWeb")
    public void queryBscPlanNewUnderlingWeb(HttpServletResponse response, String token, Integer pageNo, Integer pageSize, String pdate,
                                   int mid, String mids, @RequestParam(defaultValue = "3") String dataTp) {
        try {
            if (!checkParam(response, token, pdate)) {
                return;
            }
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                this.sendWarm(response, message.getMessage());
                return;
            }
            if (pageSize == null) {
                pageSize = 10;
            }
            OnlineUser onlineUser = message.getOnlineMember();
            //获取可以部门和不可见部门
            Map<String, Object> branchMap = this.departService.getVisibleInVisibleBranchMap(onlineUser.getDatabase(), dataTp, onlineUser.getMemId());
            String visibleBranch = (String) branchMap.get("visibleBranch");
            String invisibleBranch = (String) branchMap.get("invisibleBranch");

            Page p = this.planWebService.queryBscPlanNewUnderlingWeb(onlineUser.getDatabase(), pdate, mid, mids, pageNo, pageSize, visibleBranch, invisibleBranch);
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "获取下属计划拜访列表成功");
            json.put("pageNo", pageNo);
            json.put("pageSize", pageSize);
            json.put("total", p.getTotal());
            json.put("totalPage", p.getTotalPage());
            json.put("rows", p.getRows());
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            e.printStackTrace();
            log.error("获取下属拜访计划表失败", e);
            this.sendWarm(response, "获取下属拜访计划表失败");
        }
    }

    /**
     * 说明：添加拜访计划
     */
    @RequestMapping("addBscPlanWeb")
    public void addBscPlanWeb(HttpServletResponse response, HttpServletRequest request, String token, String cids, String pdate, Integer xlId) {
        try {
            if (!checkParam(response, token, pdate)) {
                return;
            }
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            OnlineUser onlineUser = message.getOnlineMember();
            SysMember member = this.memberWebService.queryMemAndDeptById(onlineUser.getDatabase(), onlineUser.getMemId());

            if (!StrUtil.isNull(xlId)) {
                List<BscPlanxlDetail> list1 = this.planxlDetailWebService.queryPlanxlDetaills(onlineUser.getDatabase(), xlId);
                for (int i = 0; i < list1.size(); i++) {
                    List<BscPlan> list2 = this.planWebService.queryPlanByCids(list1.get(i).getCid().toString(), onlineUser.getMemId(), pdate, onlineUser.getDatabase());
                    if (list2 != null && list2.size() != 0) {

                    } else {
                        BscPlan plan = new BscPlan();
                        plan.setBranchId(member.getBranchId());
                        plan.setCid(list1.get(i).getCid());
                        plan.setIsWc(2);
                        plan.setPdate(pdate);
                        plan.setMid(onlineUser.getMemId());
                        this.planWebService.addBscPlanWeb(plan, onlineUser.getDatabase());
                    }
                }
            } else {
                List<BscPlan> list = this.planWebService.queryPlanByCids(cids, onlineUser.getMemId(), pdate, onlineUser.getDatabase());
                if (list != null && list.size() != 0) {
                    SysCustomer customer = this.customerService.queryCustomerById(onlineUser.getDatabase(), list.get(0).getCid());
                    sendWarm(response, customer.getKhNm() + "，该客户已添加了");
                    return;
                }
                for (int i = 0; i < cids.split(",").length; i++) {
                    BscPlan plan = new BscPlan();
                    plan.setBranchId(member.getBranchId());
                    plan.setCid(Integer.parseInt(cids.split(",")[i]));
                    plan.setIsWc(2);
                    plan.setPdate(pdate);
                    plan.setMid(onlineUser.getMemId());
                    this.planWebService.addBscPlanWeb(plan, onlineUser.getDatabase());
                }
            }
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "添加拜访计划成功");
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            e.printStackTrace();
            log.error("添加拜访计划失败", e);
            this.sendWarm(response, "添加拜访计划失败");
        }
    }

    /**
     * 说明：添加拜访计划(新的)
     */
    @RequestMapping("addBscPlanNewWeb")
    public void addBscPlanNewWeb(HttpServletResponse response, HttpServletRequest request, String token, String pdate, Integer xlId) {
        try {
            if (!checkParam(response, token, pdate, xlId)) {
                return;
            }
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                this.sendWarm(response, message.getMessage());
                return;
            }
            OnlineUser onlineUser = message.getOnlineMember();
            SysMember member = this.memberWebService.queryMemAndDeptById(onlineUser.getDatabase(), onlineUser.getMemId());
            if(member == null){
                this.sendWarm(response, "该用户id不存在");
                return;
            }
            //查询是否存在
            BscPlanNew plan = this.planWebService.queryBscPlanNewWeb(onlineUser.getDatabase(), pdate, member.getMemberId());
            if(plan != null){
                if(String.valueOf(xlId).equals("" +plan.getXlid())){
                    this.sendWarm(response, "该线路已添加");
                    return;
                }
                plan.setXlid(xlId);
                this.planWebService.updateBscPlanNewWeb(onlineUser.getDatabase(), plan);
                JSONObject json = new JSONObject();
                json.put("state", true);
                json.put("msg", "修改拜访计划成功");
                this.sendJsonResponse(response, json.toString());
            }else{
                this.planWebService.addBscPlanNewWeb(onlineUser.getDatabase(), pdate, xlId, member);
                JSONObject json = new JSONObject();
                json.put("state", true);
                json.put("msg", "添加拜访计划成功");
                this.sendJsonResponse(response, json.toString());
            }
        } catch (Exception e) {
            e.printStackTrace();
            log.error("编辑拜访计划失败：", e);
            this.sendWarm(response, "编辑拜访计划失败");
        }
    }

    /**
     * 说明：删除拜访计划
     */
    @RequestMapping("deleteBscPlanWeb")
    public void deleteBscPlanWeb(HttpServletResponse response, HttpServletRequest request, String token, String ids) {
        try {
            if (!checkParam(response, token, ids)) {
                return;
            }
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            OnlineUser onlineUser = message.getOnlineMember();
            for (int i = 0; i < ids.split(",").length; i++) {
                this.planWebService.deleteBscPlanWeb(onlineUser.getDatabase(), Integer.parseInt(ids.split(",")[i]));
            }
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "删除拜访计划成功");
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            log.error("删除拜访计划失败：", e);
            this.sendWarm(response, "删除拜访计划失败");
        }
    }
}
