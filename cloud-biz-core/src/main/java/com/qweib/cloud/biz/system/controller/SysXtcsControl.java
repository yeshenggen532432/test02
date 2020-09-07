package com.qweib.cloud.biz.system.controller;

import com.qweib.cloud.biz.system.service.SysXtcsService;
import com.qweib.cloud.core.domain.SysLoginInfo;
import com.qweib.cloud.biz.common.GeneralControl;
import com.qweib.cloud.core.domain.SysXtcs;
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
@RequestMapping("/manager")
public class SysXtcsControl extends GeneralControl{
	@Resource
	private SysXtcsService xtcsService;
	
	/**
	 * 
	 *摘要：
	 *@说明：系统参数页面
	 *@创建：作者:llp		创建时间：2016-10-24
	 *@修改历史：
	 *		[序号](llp	2016-10-24)<修改说明>
	 */
	@RequestMapping("queryXtcs")
	public String queryXtcs(Model model){
		return "/uglcw/xtcs/xtcs";
	}
	/**
	 * 
	 *摘要：
	 *@说明：分页查询系统参数
	 *@创建：作者:llp		创建时间：2016-10-24
	 *@修改历史：
	 *		[序号](llp	2016-10-24)<修改说明>
	 */
	@RequestMapping("toXtcsPage")
	public void toXtcsPage(SysXtcs xtcs, int page, int rows, HttpServletResponse response, HttpServletRequest request){
		try {
			SysLoginInfo info = this.getLoginInfo(request);
			Page p = this.xtcsService.queryXtcsPage(xtcs, info.getDatasource(), page, rows);
			JSONObject json = new JSONObject();
			json.put("total", p.getTotal());
			json.put("rows", p.getRows());
			this.sendJsonResponse(response, json.toString());
		} catch (Exception e) {
			log.error("分页查询系统参数出错：", e);
		}
	}
	/**
	 * 
	 *摘要：
	 *@说明：操作系统参数
	 *@创建：作者:llp		创建时间：2016-10-24
	 *@修改历史：
	 *		[序号](llp	2016-10-24)<修改说明>
	 */
	@RequestMapping("operXtcs")
	public void operXtcs(SysXtcs xtcs, HttpServletResponse response, HttpServletRequest request){
		try {
			SysLoginInfo info = this.getLoginInfo(request);
			if(!StrUtil.isNull(xtcs)){
				if(null!=xtcs.getId()&&xtcs.getId()>0){
					this.xtcsService.updateXtcs(xtcs, info.getDatasource());
					this.sendHtmlResponse(response, "2");
				}
			  }
		} catch (Exception e) {
			log.error("操作系统参数出错：", e);
			this.sendHtmlResponse(response, "-1");
		}
	}
	/**
	 * 
	 *摘要：
	 *@说明：获取系统参数
	 *@创建：作者:llp		创建时间：2016-10-24
	 *@修改历史：
	 *		[序号](llp	2016-10-24)<修改说明>
	 */
	@RequestMapping("getXtcs")
	public void getXtcs(Integer id, HttpServletResponse response, HttpServletRequest request){
		try {
			SysLoginInfo info = this.getLoginInfo(request);
			SysXtcs xtcs=this.xtcsService.queryXtcsById(id, info.getDatasource());
			JSONObject json = new JSONObject(xtcs);
			this.sendJsonResponse(response, json.toString());
		} catch (Exception e) {
			log.error("获取系统参数出错：", e);
		}
	}
}
