package com.qweib.cloud.biz.system.controller;

import com.qweib.cloud.biz.system.service.SysKhBfDayService;
import com.qweib.cloud.biz.system.service.plat.SysMemberService;
import com.qweib.cloud.core.domain.SysKhBfDay;
import com.qweib.cloud.core.domain.SysLoginInfo;

import com.qweib.cloud.biz.common.GeneralControl;
import com.qweib.cloud.core.domain.SysMember;
import com.qweib.cloud.utils.Page;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@Controller
@RequestMapping("/manager")
public class SysKhBfDayControl extends GeneralControl{
	@Resource
	private SysKhBfDayService khBfDayService;
	@Resource
	private SysMemberService memberService;

	
	/**
	 * 
	  *摘要：
	  *@说明：客户天数主页
	  *@创建：作者:llp		创建时间：2016-6-27
	  *@修改历史：
	  *		[序号](llp	2016-6-27)<修改说明>
	 */
	@RequestMapping("/querycustomerday")
	public String querycustomerday(HttpServletRequest request, Model model, String dataTp){
		SysLoginInfo info = this.getLoginInfo(request);
		model.addAttribute("datasource", info.getDatasource());
		model.addAttribute("dataTp", dataTp);
		return "/uglcw/customer/customerday";
	}
	/**
	 * 
	  *摘要：
	  *@说明：分页查询客户天数
	  *@创建：作者:llp		创建时间：2016-6-27
	  *@修改历史：
	  *		[序号](llp	2016-6-27)<修改说明>
	 */
	@RequestMapping("/customerdayPage")
	public void customerdayPage(HttpServletRequest request, HttpServletResponse response, SysKhBfDay khBfDay, String dataTp, Integer page, Integer rows){
		try{
			SysLoginInfo info = this.getLoginInfo(request);
			khBfDay.setDatabase(info.getDatasource());
			SysMember member1=this.memberService.querySysMemberById(info.getIdKey());
//			if(member1.getIsUnitmng().equals("3")){
//				khBfDay.setMemberIds(this.memberService.queryBmMemberIds(member1.getBranchId(), info.getDatasource()).getMemberIds());
//			}
			Page p = this.khBfDayService.queryKhBfDay(khBfDay, info, dataTp, page, rows);
			JSONObject json = new JSONObject();
			json.put("total", p.getTotal());
			json.put("rows", p.getRows());
			this.sendJsonResponse(response, json.toString());
			p = null;
		}catch (Exception e) {
			log.error("分页查询客户天数出错", e);
		}
	}
}
