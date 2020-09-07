package com.qweib.cloud.biz.system.controller;

import com.qweib.cloud.biz.common.GeneralControl;
import com.qweib.cloud.biz.system.service.SysMemberImportMainService;
import com.qweib.cloud.core.domain.SysMemberImportMain;
import com.qweib.cloud.core.domain.SysMemberImportSub;
import com.qweib.cloud.core.domain.SysLoginInfo;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


@Controller
@RequestMapping("/manager/sysMemberImportMain")
public class SysMemberImportMainControl extends GeneralControl {
	@Resource
	private SysMemberImportMainService sysMemberImportMainService;

	@RequestMapping("toPage")
	public String toPage(Model model,HttpServletRequest request){
		return "/uglcw/import/sys_member_import_main_page";
	}



	@RequestMapping("toSubPage")
	public String toSubPage(Model model,HttpServletRequest request){
	    String mastId =   request.getParameter("mastId");
        request.setAttribute("mastId",mastId);
		return "/uglcw/import/sys_member_import_sub_page";
	}

	@RequestMapping("page")
	public void page(SysMemberImportMain main,int page,int rows,HttpServletResponse response,HttpServletRequest request){
		try {
			SysLoginInfo info = this.getLoginInfo(request);
			Page p = this.sysMemberImportMainService.queryPage(main, page, rows,info.getDatasource());
			JSONObject json = new JSONObject();
			json.put("total", p.getTotal());
			json.put("rows", p.getRows());
			this.sendJsonResponse(response, json.toString());
		} catch (Exception e) {
			e.printStackTrace();
			log.error("",e);
		}
	}

	@RequestMapping("subPage")
	public void subPage(SysMemberImportSub sub,int page,int rows,HttpServletResponse response,HttpServletRequest request){
		try {
			SysLoginInfo info = this.getLoginInfo(request);
			Page p = this.sysMemberImportMainService.querySubPage(sub, page, rows,info.getDatasource());
			JSONObject json = new JSONObject();
			json.put("total", p.getTotal());
			json.put("rows", p.getRows());
			this.sendJsonResponse(response, json.toString());
		} catch (Exception e) {
			log.error("",e);
		}
	}

	@RequestMapping("update")
	public void update(SysMemberImportMain main,HttpServletResponse response,HttpServletRequest request){
		JSONObject json = new JSONObject();
		try {
			json.put("state", false);
			SysLoginInfo info = this.getLoginInfo(request);
			if(!StrUtil.isNull(main)){
				this.sysMemberImportMainService.update(main,info.getDatasource());
				json.put("state", true);
				json.put("id", main.getId());
				this.sendJsonResponse(response, json.toString());
		  }
		} catch (Exception e) {
			log.error("",e);
			this.sendJsonResponse(response, json.toString());
		}
	}

	@RequestMapping("findById")
	public void findById(Integer id,HttpServletResponse response,HttpServletRequest request){
		try {
			SysLoginInfo info = this.getLoginInfo(request);
			SysMemberImportMain main=this.sysMemberImportMainService.queryById(id, info.getDatasource());
			JSONObject json = new JSONObject(main);
			this.sendJsonResponse(response, json.toString());
		} catch (Exception e) {
			log.error("", e);
		}
	}


}
