package com.qweib.cloud.biz.system.controller;

import com.qweib.cloud.biz.common.GeneralControl;
import com.qweib.cloud.biz.system.service.SysCustomerImportMainService;
import com.qweib.cloud.core.domain.SysLoginInfo;
import com.qweib.cloud.core.domain.SysCustomerImportMain;
import com.qweib.cloud.core.domain.SysCustomerImportSub;
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
@RequestMapping("/manager/sysCustomerImportMain")
public class SysCustomerImportMainControl extends GeneralControl {
	@Resource
	private SysCustomerImportMainService sysCustomerImportMainService;

	@RequestMapping("toPage")
	public String toPage(Model model,HttpServletRequest request){
		return "/uglcw/import/sys_customer_import_main_page";
	}



	@RequestMapping("toSubPage")
	public String toSubPage(Model model,HttpServletRequest request){
	    String mastId =   request.getParameter("mastId");
        request.setAttribute("mastId",mastId);
		return "/uglcw/import/sys_customer_import_sub_page";
	}

	@RequestMapping("page")
	public void page(SysCustomerImportMain main,int page,int rows,HttpServletResponse response,HttpServletRequest request){
		try {
			SysLoginInfo info = this.getLoginInfo(request);
			Page p = this.sysCustomerImportMainService.queryPage(main, page, rows,info.getDatasource());
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
	public void subPage(SysCustomerImportSub sub,int page,int rows,HttpServletResponse response,HttpServletRequest request){
		try {
			SysLoginInfo info = this.getLoginInfo(request);
			Page p = this.sysCustomerImportMainService.querySubPage(sub, page, rows,info.getDatasource());
			JSONObject json = new JSONObject();
			json.put("total", p.getTotal());
			json.put("rows", p.getRows());
			this.sendJsonResponse(response, json.toString());
		} catch (Exception e) {
			log.error("",e);
		}
	}

	@RequestMapping("update")
	public void update(SysCustomerImportMain main,HttpServletResponse response,HttpServletRequest request){
		JSONObject json = new JSONObject();
		try {
			json.put("state", false);
			SysLoginInfo info = this.getLoginInfo(request);
			if(!StrUtil.isNull(main)){
				this.sysCustomerImportMainService.update(main,info.getDatasource());
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
			SysCustomerImportMain main=this.sysCustomerImportMainService.queryById(id, info.getDatasource());
			JSONObject json = new JSONObject(main);
			this.sendJsonResponse(response, json.toString());
		} catch (Exception e) {
			log.error("", e);
		}
	}


}
