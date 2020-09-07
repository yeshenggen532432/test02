package com.qweib.cloud.biz.system.controller;

import com.qweib.cloud.biz.system.service.SysKhgxsxService;
import com.qweib.cloud.core.domain.*;

import com.qweib.cloud.biz.common.GeneralControl;
import com.qweib.cloud.utils.Page;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@Controller
@RequestMapping("manager")
public class SysKhgxsxControl extends GeneralControl{
	@Resource
	private SysKhgxsxService khgxsxService;
	/**
	 *摘要：
	 *@说明：选择拜访频次
	 *@创建：作者:llp		创建时间：2016-2-16
	 *@修改历史：
	 *		[序号](llp	2016-2-16)<修改说明>
	 */
	@RequestMapping("choiceBfpc")
	public String choiceBfpc(){
		return "/uglcw/khgxsx/choiceBfpc";
	}
//	/**
//	 *
//	  *摘要：
//	  *@说明：分页查询拜访频次
//	  *@创建：作者:llp		创建时间：2016-2-16
//	  *@修改历史：
//	  *		[序号](llp	2016-2-16)<修改说明>
//	 */
//	@RequestMapping("querySysBfpc")
//	public void querySysBfpc(HttpServletRequest request, HttpServletResponse response, SysBfpc bfpc, Integer page, Integer rows){
//		try{
//			SysLoginInfo info = this.getLoginInfo(request);
//			Page p = this.khgxsxService.querySysBfpc(bfpc, info.getDatasource(), page, rows);
//			JSONObject json = new JSONObject();
//			json.put("total", p.getTotal());
//			json.put("rows", p.getRows());
//			this.sendJsonResponse(response, json.toString());
//			p = null;
//		}catch (Exception e) {
//			log.error("分页查询拜访频次出错", e);
//		}
//	}
	/**
	 *摘要：
	 *@说明：选择供货类型
	 *@创建：作者:llp		创建时间：2016-2-16
	 *@修改历史：
	 *		[序号](llp	2016-2-16)<修改说明>
	 */
	@RequestMapping("choiceGhtype")
	public String choiceGhtype(){
		return "/uglcw/khgxsx/choiceGhtype";
	}
	/**
	 *
	  *摘要：
	  *@说明：分页查询供货类型
	  *@创建：作者:llp		创建时间：2016-2-16
	  *@修改历史：
	  *		[序号](llp	2016-2-16)<修改说明>
	 */
//	@RequestMapping("querySysGhtype")
//	public void querySysGhtype(HttpServletRequest request, HttpServletResponse response, SysGhtype ghtype, Integer page, Integer rows){
//		try{
//			SysLoginInfo info = this.getLoginInfo(request);
//			Page p = this.khgxsxService.querySysGhtype(ghtype, info.getDatasource(), page, rows);
//			JSONObject json = new JSONObject();
//			json.put("total", p.getTotal());
//			json.put("rows", p.getRows());
//			this.sendJsonResponse(response, json.toString());
//			p = null;
//		}catch (Exception e) {
//			log.error("分页查询供货类型出错", e);
//		}
//	}
	/**
	 *摘要：
	 *@说明：选择经销商分类
	 *@创建：作者:llp		创建时间：2016-2-16
	 *@修改历史：
	 *		[序号](llp	2016-2-16)<修改说明>
	 */
	@RequestMapping("choiceJxsfl")
	public String choiceJxsfl(){
		return "/uglcw/khgxsx/choiceJxsfl";
	}
	/**
	 *
	  *摘要：
	  *@说明：分页查询经销商分类
	  *@创建：作者:llp		创建时间：2016-2-16
	  *@修改历史：
	  *		[序号](llp	2016-2-16)<修改说明>
	 */
	@RequestMapping("querySysJxsfl")
	public void querySysJxsfl(HttpServletRequest request, HttpServletResponse response, SysJxsfl jxsfl, Integer page, Integer rows){
		try{
			SysLoginInfo info = this.getLoginInfo(request);
			Page p = this.khgxsxService.querySysJxsfl(jxsfl, info.getDatasource(), page, rows);
			JSONObject json = new JSONObject();
			json.put("total", p.getTotal());
			json.put("rows", p.getRows());
			this.sendJsonResponse(response, json.toString());
			p = null;
		}catch (Exception e) {
			log.error("分页查询经销商分类出错", e);
		}
	}
	/**
	 *摘要：
	 *@说明：选择经销商级别
	 *@创建：作者:llp		创建时间：2016-2-16
	 *@修改历史：
	 *		[序号](llp	2016-2-16)<修改说明>
	 */
	@RequestMapping("choiceJxsjb")
	public String choiceJxsjb(){
		return "/uglcw/khgxsx/choiceJxsjb";
	}
	/**
	 *
	  *摘要：
	  *@说明：分页查询经销商级别
	  *@创建：作者:llp		创建时间：2016-2-16
	  *@修改历史：
	  *		[序号](llp	2016-2-16)<修改说明>
	 */
	@RequestMapping("querySysJxsjb")
	public void querySysJxsjb(HttpServletRequest request, HttpServletResponse response, SysJxsjb jxsjb, Integer page, Integer rows){
		try{
			SysLoginInfo info = this.getLoginInfo(request);
			Page p = this.khgxsxService.querySysJxsjb(jxsjb, info.getDatasource(), page, rows);
			JSONObject json = new JSONObject();
			json.put("total", p.getTotal());
			json.put("rows", p.getRows());
			this.sendJsonResponse(response, json.toString());
			p = null;
		}catch (Exception e) {
			log.error("分页查询经销商级别出错", e);
		}
	}
	/**
	 *摘要：
	 *@说明：选择经销商状态
	 *@创建：作者:llp		创建时间：2016-2-16
	 *@修改历史：
	 *		[序号](llp	2016-2-16)<修改说明>
	 */
	@RequestMapping("choiceJxszt")
	public String choiceJxszt(){
		return "/uglcw/khgxsx/choiceJxszt";
	}
	/**
	 *
	  *摘要：
	  *@说明：分页查询经销商状态
	  *@创建：作者:llp		创建时间：2016-2-16
	  *@修改历史：
	  *		[序号](llp	2016-2-16)<修改说明>
	 */
	@RequestMapping("querySysJxszt")
	public void querySysJxsjb(HttpServletRequest request, HttpServletResponse response, SysJxszt jxszt, Integer page, Integer rows){
		try{
			SysLoginInfo info = this.getLoginInfo(request);
			Page p = this.khgxsxService.querySysJxszt(jxszt, info.getDatasource(), page, rows);
			JSONObject json = new JSONObject();
			json.put("total", p.getTotal());
			json.put("rows", p.getRows());
			this.sendJsonResponse(response, json.toString());
			p = null;
		}catch (Exception e) {
			log.error("分页查询经销商状态出错", e);
		}
	}
	/**
	 *摘要：
	 *@说明：选择客户等级
	 *@创建：作者:llp		创建时间：2016-2-16
	 *@修改历史：
	 *		[序号](llp	2016-2-16)<修改说明>
	 */
	@RequestMapping("choiceKhlevel")
	public String choiceKhlevel(){
		return "/uglcw/khgxsx/choiceKhlevel";
	}
	/**
	 *
	  *摘要：
	  *@说明：分页查询客户等级
	  *@创建：作者:llp		创建时间：2016-2-16
	  *@修改历史：
	  *		[序号](llp	2016-2-16)<修改说明>
	 */
	@RequestMapping("querySysKhlevel")
	public void querySysKhlevel(HttpServletRequest request, HttpServletResponse response, SysKhlevel khlevel, Integer page, Integer rows){
		try{
			SysLoginInfo info = this.getLoginInfo(request);
			Page p = this.khgxsxService.querySysKhlevel(khlevel, info.getDatasource(), page, rows);
			JSONObject json = new JSONObject();
			json.put("total", p.getTotal());
			json.put("rows", p.getRows());
			this.sendJsonResponse(response, json.toString());
			p = null;
		}catch (Exception e) {
			log.error("分页查询客户等级出错", e);
		}
	}
	/**
	 *摘要：
	 *@说明：选择渠道类型
	 *@创建：作者:llp		创建时间：2016-2-16
	 *@修改历史：
	 *		[序号](llp	2016-2-16)<修改说明>
	 */
	@RequestMapping("choiceQdtype")
	public String choiceQdtype(){
		return "/uglcw/khgxsx/choiceQdtype";
	}
	/**
	 *
	  *摘要：
	  *@说明：分页查询渠道类型
	  *@创建：作者:llp		创建时间：2016-2-16
	  *@修改历史：
	  *		[序号](llp	2016-2-16)<修改说明>
	 */
	@RequestMapping("querySysQdtype")
	public void querySysQdtype(HttpServletRequest request, HttpServletResponse response, SysQdtype qdtype, Integer page, Integer rows){
		try{
			Page p = this.khgxsxService.querySysQdtype(qdtype, page, rows);
			JSONObject json = new JSONObject();
			json.put("total", p.getTotal());
			json.put("rows", p.getRows());
			this.sendJsonResponse(response, json.toString());
			p = null;
		}catch (Exception e) {
			log.error("分页查询渠道类型出错", e);
		}
	}
	/**
	 *摘要：
	 *@说明：选择市场类型
	 *@创建：作者:llp		创建时间：2016-2-16
	 *@修改历史：
	 *		[序号](llp	2016-2-16)<修改说明>
	 */
	@RequestMapping("choiceSctype")
	public String choiceSctype(){
		return "/uglcw/khgxsx/choiceSctype";
	}
	/**
	 *
	  *摘要：
	  *@说明：分页查询市场类型
	  *@创建：作者:llp		创建时间：2016-2-16
	  *@修改历史：
	  *		[序号](llp	2016-2-16)<修改说明>
	 */
	@RequestMapping("querySysSctype")
	public void querySysSctype(HttpServletRequest request, HttpServletResponse response, SysSctype sctype, Integer page, Integer rows){
		try{
			SysLoginInfo info = this.getLoginInfo(request);
			Page p = this.khgxsxService.querySysSctype(sctype, info.getDatasource(), page, rows);
			JSONObject json = new JSONObject();
			json.put("total", p.getTotal());
			json.put("rows", p.getRows());
			this.sendJsonResponse(response, json.toString());
			p = null;
		}catch (Exception e) {
			log.error("分页查询市场类型出错", e);
		}
	}
	/**
	 *摘要：
	 *@说明：选择销售阶段
	 *@创建：作者:llp		创建时间：2016-2-16
	 *@修改历史：
	 *		[序号](llp	2016-2-16)<修改说明>
	 */
	@RequestMapping("choiceXsphase")
	public String choiceXsphase(){
		return "/uglcw/khgxsx/choiceXsphase";
	}
	/**
	 *
	  *摘要：
	  *@说明：分页查询销售阶段
	  *@创建：作者:llp		创建时间：2016-2-16
	  *@修改历史：
	  *		[序号](llp	2016-2-16)<修改说明>
	 */
	@RequestMapping("querySysXsphase")
	public void querySysXsphase(HttpServletRequest request, HttpServletResponse response, SysXsphase xsphase, Integer page, Integer rows){
		try{
			SysLoginInfo info = this.getLoginInfo(request);
			Page p = this.khgxsxService.querySysXsphase(xsphase, info.getDatasource(), page, rows);
			JSONObject json = new JSONObject();
			json.put("total", p.getTotal());
			json.put("rows", p.getRows());
			this.sendJsonResponse(response, json.toString());
			p = null;
		}catch (Exception e) {
			log.error("分页查询销售阶段出错", e);
		}
	}
}
