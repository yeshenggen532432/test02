package com.qweib.cloud.biz.system.controller;

import com.qweib.cloud.biz.system.service.SysReportCdService;
import com.qweib.cloud.core.domain.SysLoginInfo;

import com.qweib.cloud.biz.common.GeneralControl;
import com.qweib.cloud.core.domain.SysReportCd;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@Controller
@RequestMapping("/manager")
public class SysReportCdControl extends GeneralControl{
	@Resource
	private SysReportCdService reportCdService;
	
	/**
	 * 
	 *摘要：
	 *@说明：到日报文字长度设置页面
	 *@创建：作者:llp		创建时间：2017-5-19
	 *@修改历史：
	 *		[序号](llp	2017-5-19)<修改说明>
	 */
	@RequestMapping("/toreportcd")
	public String toreportcd(Model model, Integer wtype, HttpServletRequest request, Integer id){
		SysLoginInfo info = this.getLoginInfo(request);
		SysReportCd reportCd=this.reportCdService.queryReportCd(info.getDatasource(),id);
		model.addAttribute("reportCd", reportCd);
		return "/uglcw/reportcd/reportcd";
	}
	/**
	 *说明：修改报文字长度设置
	 *@创建：作者:llp		创建时间：2017-2-8
	 *@修改历史：
	 *		[序号](llp	2017-2-8)<修改说明>
	 */
	@RequestMapping("/updatereportcd")
	public void updatereportcd(HttpServletResponse response, HttpServletRequest request, SysReportCd reportCd) {
		try {
			  SysLoginInfo info = this.getLoginInfo(request);
			  this.reportCdService.updateReportCd(reportCd, info.getDatasource());
			  this.sendHtmlResponse(response, "1");
		} catch (Exception e) {
			log.error("修改日报文字长度设置出错：", e);
		}
	}
}
