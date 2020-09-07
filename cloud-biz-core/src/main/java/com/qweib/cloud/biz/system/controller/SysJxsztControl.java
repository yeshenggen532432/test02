package com.qweib.cloud.biz.system.controller;

import com.qweib.cloud.biz.system.service.SysJxsztService;
import com.qweib.cloud.core.domain.SysJxszt;
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
public class SysJxsztControl extends GeneralControl{
	@Resource
	private SysJxsztService JxsztService;
	
	/**
	 * 
	 *摘要：
	 *@说明：经销商状态页面
	 *@创建：作者:llp		创建时间：2016-7-26
	 *@修改历史：
	 *		[序号](llp	2016-7-26)<修改说明>
	 */
	@RequestMapping("queryJxszt")
	public String queryJxszt(Model model){
		return "/uglcw/khgxsx/Jxszt";
	}
	/**
	 * 
	 *摘要：
	 *@说明：分页查询经销商状态
	 *@创建：作者:llp		创建时间：2016-7-26
	 *@修改历史：
	 *		[序号](llp	2016-7-26)<修改说明>
	 */
	@RequestMapping("toJxsztPage")
	public void toJxsztPage(SysJxszt Jxszt, int page, int rows, HttpServletResponse response, HttpServletRequest request){
		try {
			SysLoginInfo info = this.getLoginInfo(request);
			Page p = this.JxsztService.queryJxsztPage(Jxszt, info.getDatasource(), page, rows);
			JSONObject json = new JSONObject();
			json.put("total", p.getTotal());
			json.put("rows", p.getRows());
			this.sendJsonResponse(response, json.toString());
		} catch (Exception e) {
			log.error("分页查询经销商状态出错：", e);
		}
	}
	/**
	 * 
	 *摘要：
	 *@说明：操作经销商状态
	 *@创建：作者:llp		创建时间：2016-7-26
	 *@修改历史：
	 *		[序号](llp	2016-7-26)<修改说明>
	 */
	@RequestMapping("operJxszt")
	public void operJxszt(SysJxszt Jxszt, HttpServletResponse response, HttpServletRequest request){
		try {
			SysLoginInfo info = this.getLoginInfo(request);
			if(!StrUtil.isNull(Jxszt)){
				if(null!=Jxszt.getId()&&Jxszt.getId()>0){
					this.JxsztService.updateJxszt(Jxszt, info.getDatasource());
					this.sendHtmlResponse(response, "2");
				}else{
					this.JxsztService.addJxszt(Jxszt, info.getDatasource());
					this.sendHtmlResponse(response, "1");
				}
			  }
		} catch (Exception e) {
			log.error("操作经销商状态出错：", e);
			this.sendHtmlResponse(response, "-1");
		}
	}
	/**
	 * 
	 *摘要：
	 *@说明：获取经销商状态
	 *@创建：作者:llp		创建时间：2016-7-26
	 *@修改历史：
	 *		[序号](llp	2016-7-26)<修改说明>
	 */
	@RequestMapping("getJxszt")
	public void getJxszt(Integer id, HttpServletResponse response, HttpServletRequest request){
		try {
			SysLoginInfo info = this.getLoginInfo(request);
			SysJxszt Jxszt=this.JxsztService.queryJxsztById(id, info.getDatasource());
			JSONObject json = new JSONObject(Jxszt);
			this.sendJsonResponse(response, json.toString());
		} catch (Exception e) {
			log.error("获取经销商状态出错：", e);
		}
	}
	/**
	 * 
	 *摘要：
	 *@说明：删除经销商状态
	 *@创建：作者:llp		创建时间：2016-7-26
	 *@修改历史：
	 *		[序号](llp	2016-7-26)<修改说明>
	 */
	@RequestMapping("deleteJxsztById")
	public void deleteJxsztById(Integer id, HttpServletResponse response, HttpServletRequest request){
		try {
			SysLoginInfo info = this.getLoginInfo(request);
			this.JxsztService.deleteJxsztById(id, info.getDatasource());
			this.sendHtmlResponse(response, "1");
		} catch (Exception e) {
			log.error("操作经销商状态出错：", e);
			this.sendHtmlResponse(response, "-1");
		}
	}
}
