package com.qweib.cloud.biz.system.controller;

import com.qweib.cloud.biz.system.service.SysKhfbszService;
import com.qweib.cloud.core.domain.ArrayKhfbsz;
import com.qweib.cloud.core.domain.SysKhfbsz;
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
public class SysKhfbszControl extends GeneralControl{
	@Resource
	private SysKhfbszService khfbszService;
	
	/**
	 *说明：去客户分布设置页面
	 *@创建：作者:llp		创建时间：2017-5-16
	 *@修改历史：
	 *		[序号](llp	2017-5-16)<修改说明>
	 */
	@RequestMapping("/queryKhfbszLs")
	public String queryKhfbszLs(HttpServletRequest request, HttpServletResponse response, Model model){
		SysLoginInfo info = this.getLoginInfo(request);
		List<SysKhfbsz> list=this.khfbszService.queryKhfbszLs(info.getDatasource());
		model.addAttribute("list",list);
		model.addAttribute("detailCount",list.size());
		return "/uglcw/khfbsz/khfbsz";
	}
	/**
	 *说明：批量修改客户分布设置
	 *@创建：作者:llp		创建时间：2017-5-16
	 *@修改历史：
	 *		[序号](llp	2017-5-16)<修改说明>
	 */
	@RequestMapping("/addKhfbszLs")
	public void addKhfbszLs(HttpServletResponse response, HttpServletRequest request, ArrayKhfbsz Khfbsz) {
		try {
			  SysLoginInfo info = this.getLoginInfo(request);
			  this.khfbszService.deleteKhfbsz(info.getDatasource());
			  this.khfbszService.addKhfbszLs(Khfbsz.getKhfbszList(), info.getDatasource());
			  this.sendHtmlResponse(response, "1");
		} catch (Exception e) {
			log.error("批量修改客户分布设置出错：", e);
		}
	}

}
