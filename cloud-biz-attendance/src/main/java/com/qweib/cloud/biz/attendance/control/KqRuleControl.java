package com.qweib.cloud.biz.attendance.control;

import com.qweib.cloud.biz.attendance.model.KqEmpRule;
import com.qweib.cloud.biz.attendance.model.KqRule;
import com.qweib.cloud.biz.attendance.service.KqEmpRuleService;
import com.qweib.cloud.biz.attendance.service.KqRuleService;
import com.qweib.cloud.biz.common.GeneralControl;
import com.qweib.cloud.core.domain.SysLoginInfo;
import com.qweib.cloud.utils.Page;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@Controller
@RequestMapping("/manager/kqrule")
public class KqRuleControl extends GeneralControl {
    @Resource
    private KqRuleService ruleService;

    @Resource
    private KqEmpRuleService empRuleservice;

    @RequestMapping("/toBaseKqRule")
    public String toBaseKqRule(HttpServletRequest request, Model model, String dataTp) {
        try {
            SysLoginInfo info = this.getLoginInfo(request);

        } catch (Exception e) {
            // TODO: handle exception
            log.error("登录错误", e);
        }
        return "/kq/base_kqrule";
    }

    @RequestMapping("/toBaseKqRuleNew")
    public String toBaseKqRuleNew(HttpServletRequest request, Model model, String dataTp) {
        try {
            SysLoginInfo info = this.getLoginInfo(request);
            model.addAttribute("ruleId", 0);
            model.addAttribute("status", 1);
        } catch (Exception e) {
            // TODO: handle exception
            log.error("登录错误", e);
        }
        return "/kq/base_kqrule_edit";
    }

    @RequestMapping("/toBaseKqRuleEdit")
    public String toBaseKqRuleEdit(HttpServletRequest request, Model model, Integer ruleId) {
        try {
            SysLoginInfo info = this.getLoginInfo(request);
            KqRule rule = this.ruleService.getRuleById(ruleId, info.getDatasource());
            if (rule == null) {
                return "/kq/base_kqrule_edit";
            }
            model.addAttribute("kqRule", new JSONObject(rule).toString());

            model.addAttribute("ruleId", rule.getId());
            model.addAttribute("status", rule.getStatus());
        } catch (Exception e) {
            // TODO: handle exception
            log.error("登录错误", e);
        }
        return "/kq/base_kqrule_edit";
    }
	
	/*@RequestMapping("/getKqRule")
	public void getKqRule(HttpServletRequest request,HttpServletResponse response,Integer ruleId){
		SysLoginInfo info = this.getLoginInfo(request);
		try{			
			KqRule bo = this.ruleService.getRuleById(ruleId, info.getDatasource());
			JSONObject json = new JSONObject();
			json.put("state",true);
			json.put("kqRule", bo);
			json.put("rows", bo.getSubList());
			this.sendJsonResponse(response, json.toString());
			p = null;
		}catch (Exception e) {
			log.error("分页查询规律班出错", e);
		}
	}*/

    @RequestMapping("/queryKqRulePage")
    public void queryKqRulePage(HttpServletRequest request, HttpServletResponse response, KqRule ruleRec,
                                Integer page, Integer rows) {
        SysLoginInfo info = this.getLoginInfo(request);
        if (page == null) page = 1;
        if (rows == null) rows = 9999;
        try {
            Page p = this.ruleService.queryKqRulePage(ruleRec, info.getDatasource(), page, rows);
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("total", p.getTotal());
            json.put("rows", p.getRows());
            this.sendJsonResponse(response, json.toString());
            p = null;
        } catch (Exception e) {
            log.error("分页查询规律班出错", e);
        }
    }

    @RequestMapping("updateRuleStatus")
    public void updateBcStatus(HttpServletResponse response, HttpServletRequest request, String token, Integer id, Integer status) {
        SysLoginInfo info = this.getLoginInfo(request);
        try {

            this.ruleService.updateRuleStatus(id, status, info.getDatasource());
            JSONObject json = new JSONObject();

            json.put("state", true);
            json.put("id", 0);
            json.put("msg", "修改状态成功");
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            this.sendJsonResponse(response, "修改规律班状态失败");
        }
    }


    @RequestMapping("deleteKqRule")
    public void deleteKqRule(HttpServletResponse response, HttpServletRequest request, String token, String ids) {
        SysLoginInfo info = this.getLoginInfo(request);
        try {
            String[] bcIds = ids.split(",");
            for (int i = 0; i < bcIds.length; i++) {
                Integer id = Integer.parseInt(bcIds[i]);
                this.ruleService.deleteRule(id, info.getDatasource());
            }
            JSONObject json = new JSONObject();

            json.put("state", true);
            json.put("id", 0);
            json.put("msg", "删除成功");
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            this.sendJsonResponse(response, "删除规律班失败");
        }
    }


    @RequestMapping("/saveKqRule")
    public void saveKqRule(HttpServletResponse response, HttpServletRequest request, KqRule ruleRec) {
        try {
            SysLoginInfo info = this.getLoginInfo(request);
            int ret = 0;
            if (ruleRec.getStatus() == null) ruleRec.setStatus(1);
            if (ruleRec.getId() != null) {
                if (ruleRec.getId().intValue() > 0) ret = this.ruleService.updateRule(ruleRec, info.getDatasource());
                else
                    ret = this.ruleService.addRule(ruleRec, info.getDatasource());
            } else
                ret = this.ruleService.addRule(ruleRec, info.getDatasource());
            if (ret > 0)
                this.sendHtmlResponse(response, "1");
            else
                this.sendHtmlResponse(response, "-1");
        } catch (Exception e) {
            log.error("保存考勤规则出错：", e);
        }
    }

    @RequestMapping("/toBaseEmpKqRule")
    public String toBaseEmpKqRule(HttpServletRequest request, Model model, String dataTp) {
        try {
            SysLoginInfo info = this.getLoginInfo(request);

        } catch (Exception e) {
            // TODO: handle exception
            log.error("登录错误", e);
        }
        return "/kq/base_empkqrule";
    }

    @RequestMapping("/saveEmpKqRule")
    public void saveKqRule(HttpServletResponse response, HttpServletRequest request, String ids, Integer ruleId) {
        try {
            SysLoginInfo info = this.getLoginInfo(request);
            String[] idArray = ids.split(",");
            if (idArray.length == 0) {
                this.sendHtmlResponse(response, "-1");
            }

            int ret = this.empRuleservice.addEmpRule(ids, ruleId, info.getDatasource());
            JSONObject json = new JSONObject();
            if (ret > 0) {
                json.put("state", true);
            } else {
                json.put("state", false);
            }
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {

            log.error("保存考勤规则分配出错：", e);
        }
    }

    @RequestMapping("/queryKqEmpRulePage")
    public void queryKqEmpRulePage(HttpServletRequest request, HttpServletResponse response, KqEmpRule ruleRec,
                                   Integer page, Integer rows) {
        SysLoginInfo info = this.getLoginInfo(request);
        if (page == null) page = 1;
        if (rows == null) rows = 9999;
        try {
            Page p = this.empRuleservice.queryEmpRulePage(ruleRec, info.getDatasource(), page, rows);
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("total", p.getTotal());
            json.put("rows", p.getRows());
            this.sendJsonResponse(response, json.toString());
            p = null;
        } catch (Exception e) {
            log.error("分页查询规律班分配出错", e);
        }
    }

}
