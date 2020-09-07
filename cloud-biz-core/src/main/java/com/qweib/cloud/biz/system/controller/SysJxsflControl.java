package com.qweib.cloud.biz.system.controller;

import com.qweib.cloud.biz.system.service.SysJxsflService;
import com.qweib.cloud.core.domain.SysJxsfl;
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
public class SysJxsflControl extends GeneralControl{
	@Resource
	private SysJxsflService JxsflService;
	
	/**
	 * 
	 *摘要：
	 *@说明：经销商分类页面
	 *@创建：作者:llp		创建时间：2016-7-26
	 *@修改历史：
	 *		[序号](llp	2016-7-26)<修改说明>
	 */
	@RequestMapping("queryJxsfl")
	public String queryJxsfl(Model model){
		return "/uglcw/khgxsx/Jxsfl";
	}
	/**
	 * 
	 *摘要：
	 *@说明：分页查询经销商分类
	 *@创建：作者:llp		创建时间：2016-7-26
	 *@修改历史：
	 *		[序号](llp	2016-7-26)<修改说明>
	 */
	@RequestMapping("toJxsflPage")
	public void toJxsflPage(SysJxsfl Jxsfl, int page, int rows, HttpServletResponse response, HttpServletRequest request){
		try {
			SysLoginInfo info = this.getLoginInfo(request);
			Page p = this.JxsflService.queryJxsflPage(Jxsfl, info.getDatasource(), page, rows);
			JSONObject json = new JSONObject();
			json.put("total", p.getTotal());
			json.put("rows", p.getRows());
			this.sendJsonResponse(response, json.toString());
		} catch (Exception e) {
			log.error("分页查询经销商分类出错：", e);
		}
	}
	/**
	 * 
	 *摘要：
	 *@说明：操作经销商分类
	 *@创建：作者:llp		创建时间：2016-7-26
	 *@修改历史：
	 *		[序号](llp	2016-7-26)<修改说明>
	 */
	@RequestMapping("operJxsfl")
	public void operJxsfl(SysJxsfl Jxsfl, HttpServletResponse response, HttpServletRequest request){
		try {
			SysLoginInfo info = this.getLoginInfo(request);
			if(!StrUtil.isNull(Jxsfl)){
				if(null!=Jxsfl.getId()&&Jxsfl.getId()>0){
					this.JxsflService.updateJxsfl(Jxsfl, info.getDatasource());
					this.sendHtmlResponse(response, "2");
				}else{
					this.JxsflService.addJxsfl(Jxsfl, info.getDatasource());
					this.sendHtmlResponse(response, "1");
				}
			  }
		} catch (Exception e) {
			log.error("操作经销商分类出错：", e);
			this.sendHtmlResponse(response, "-1");
		}
	}
	/**
	 * 
	 *摘要：
	 *@说明：获取经销商分类
	 *@创建：作者:llp		创建时间：2016-7-26
	 *@修改历史：
	 *		[序号](llp	2016-7-26)<修改说明>
	 */
	@RequestMapping("getJxsfl")
	public void getJxsfl(Integer id, HttpServletResponse response, HttpServletRequest request){
		try {
			SysLoginInfo info = this.getLoginInfo(request);
			SysJxsfl Jxsfl=this.JxsflService.queryJxsflById(id, info.getDatasource());
			JSONObject json = new JSONObject(Jxsfl);
			this.sendJsonResponse(response, json.toString());
		} catch (Exception e) {
			log.error("获取经销商分类出错：", e);
		}
	}
	/**
	 * 
	 *摘要：
	 *@说明：删除经销商分类
	 *@创建：作者:llp		创建时间：2016-7-26
	 *@修改历史：
	 *		[序号](llp	2016-7-26)<修改说明>
	 */
	@RequestMapping("deleteJxsflById")
	public void deleteJxsflById(Integer id, HttpServletResponse response, HttpServletRequest request){
		try {
			SysLoginInfo info = this.getLoginInfo(request);
			this.JxsflService.deleteJxsflById(id, info.getDatasource());
			this.sendHtmlResponse(response, "1");
		} catch (Exception e) {
			log.error("操作经销商分类出错：", e);
			this.sendHtmlResponse(response, "-1");
		}
	}
}
