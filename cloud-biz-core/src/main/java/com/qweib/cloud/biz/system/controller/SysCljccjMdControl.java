package com.qweib.cloud.biz.system.controller;

import com.qweib.cloud.biz.system.service.SysCljccjMdService;
import com.qweib.cloud.core.domain.ArraySysCljccjMd;
import com.qweib.cloud.core.domain.SysCljccjMd;
import com.qweib.cloud.core.domain.SysLoginInfo;

import com.qweib.cloud.biz.common.GeneralControl;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;

@Controller
@RequestMapping("/manager")
public class SysCljccjMdControl extends GeneralControl{
	@Resource
	private SysCljccjMdService cljccjMdService;
	
	/**
	 *说明：列表查陈列检查采集模板
	 *@创建：作者:llp		创建时间：2016-3-24
	 *@修改历史：
	 *		[序号](llp	2016-3-24)<修改说明>
	 */
	@RequestMapping("/queryCljccjMdls")
	 public String queryCljccjMdls(HttpServletRequest request, Model model){
		SysLoginInfo info = this.getLoginInfo(request);
		List<SysCljccjMd> list=this.cljccjMdService.queryCljccjMdls(info.getDatasource());
		model.addAttribute("list",list);
		return "uglcw/cljccjmd/cljccjmd";
	 }
	/**
	 * 
	 *摘要：
	 *@说明：批量修改陈列检查采集模板
	 *@创建：作者:llp		创建时间：2016-3-24
     *@修改历史：
	 *		[序号](llp	2016-3-24)<修改说明>
	 */
	@RequestMapping("/updateCljccjMdLs")
	 public void updateCljccjMdLs(HttpServletRequest request, HttpServletResponse response, ArraySysCljccjMd list){
		SysLoginInfo info = this.getLoginInfo(request);
		try{   
			this.cljccjMdService.updateCljccjMdLs(list.getCljccjMdLs(), info.getDatasource());
			this.sendHtmlResponse(response, "1");
		} catch (Exception e) {
			log.error("批量修改陈列检查采集模板：", e);
		}
	 }
}
