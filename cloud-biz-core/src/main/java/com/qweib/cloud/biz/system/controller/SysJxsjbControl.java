package com.qweib.cloud.biz.system.controller;

import com.qweib.cloud.biz.system.service.SysJxsjbService;
import com.qweib.cloud.core.domain.SysJxsjb;
import com.qweib.cloud.core.domain.SysLoginInfo;

import com.qweib.cloud.biz.common.GeneralControl;
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
public class SysJxsjbControl extends GeneralControl{
	@Resource
	private SysJxsjbService JxsjbService;
	
	/**
	 * 
	 *摘要：
	 *@说明：经销商级别页面
	 *@创建：作者:llp		创建时间：2016-7-26
	 *@修改历史：
	 *		[序号](llp	2016-7-26)<修改说明>
	 */
	@RequestMapping("queryJxsjb")
	public String queryJxsjb(Model model){
		return "/uglcw/khgxsx/Jxsjb";
	}
	/**
	 * 
	 *摘要：
	 *@说明：分页查询经销商级别
	 *@创建：作者:llp		创建时间：2016-7-26
	 *@修改历史：
	 *		[序号](llp	2016-7-26)<修改说明>
	 */
	@RequestMapping("toJxsjbPage")
	public void toJxsjbPage(SysJxsjb Jxsjb, int page, int rows, HttpServletResponse response, HttpServletRequest request){
		try {
			SysLoginInfo info = this.getLoginInfo(request);
			Page p = this.JxsjbService.queryJxsjbPage(Jxsjb, info.getDatasource(), page, rows);
			JSONObject json = new JSONObject();
			json.put("total", p.getTotal());
			json.put("rows", p.getRows());
			this.sendJsonResponse(response, json.toString());
		} catch (Exception e) {
			log.error("分页查询经销商级别出错：", e);
		}
	}
	/**
	 * 
	 *摘要：
	 *@说明：操作经销商级别
	 *@创建：作者:llp		创建时间：2016-7-26
	 *@修改历史：
	 *		[序号](llp	2016-7-26)<修改说明>
	 */
	@RequestMapping("operJxsjb")
	public void operJxsjb(SysJxsjb Jxsjb, HttpServletResponse response, HttpServletRequest request){
		try {
			SysLoginInfo info = this.getLoginInfo(request);
			if(!StrUtil.isNull(Jxsjb)){
				if(null!=Jxsjb.getId()&&Jxsjb.getId()>0){
					this.JxsjbService.updateJxsjb(Jxsjb, info.getDatasource());
					this.sendHtmlResponse(response, "2");
				}else{
					this.JxsjbService.addJxsjb(Jxsjb, info.getDatasource());
					this.sendHtmlResponse(response, "1");
				}
			  }
		} catch (Exception e) {
			log.error("操作经销商级别出错：", e);
			this.sendHtmlResponse(response, "-1");
		}
	}
	/**
	 * 
	 *摘要：
	 *@说明：获取经销商级别
	 *@创建：作者:llp		创建时间：2016-7-26
	 *@修改历史：
	 *		[序号](llp	2016-7-26)<修改说明>
	 */
	@RequestMapping("getJxsjb")
	public void getJxsjb(Integer id, HttpServletResponse response, HttpServletRequest request){
		try {
			SysLoginInfo info = this.getLoginInfo(request);
			SysJxsjb Jxsjb=this.JxsjbService.queryJxsjbById(id, info.getDatasource());
			JSONObject json = new JSONObject(Jxsjb);
			this.sendJsonResponse(response, json.toString());
		} catch (Exception e) {
			log.error("获取经销商级别出错：", e);
		}
	}
	/**
	 * 
	 *摘要：
	 *@说明：删除经销商级别
	 *@创建：作者:llp		创建时间：2016-7-26
	 *@修改历史：
	 *		[序号](llp	2016-7-26)<修改说明>
	 */
	@RequestMapping("deleteJxsjbById")
	public void deleteJxsjbById(Integer id, HttpServletResponse response, HttpServletRequest request){
		try {
			SysLoginInfo info = this.getLoginInfo(request);
			this.JxsjbService.deleteJxsjbById(id, info.getDatasource());
			this.sendHtmlResponse(response, "1");
		} catch (Exception e) {
			log.error("操作经销商级别出错：", e);
			this.sendHtmlResponse(response, "-1");
		}
	}
}
