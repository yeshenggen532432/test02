package com.qweib.cloud.biz.system.controller.mobile;


import com.qweib.cloud.biz.system.BaseWebService;
import com.qweib.cloud.biz.system.TokenServer;
import com.qweib.cloud.biz.system.service.ws.BscPlanxlDetailWebService;
import com.qweib.cloud.biz.system.service.ws.BscPlanxlWebService;
import com.qweib.cloud.core.domain.BscPlanxl;
import com.qweib.cloud.core.domain.BscPlanxlDetail;
import com.qweib.cloud.core.domain.OnlineMessage;
import com.qweib.cloud.core.domain.OnlineUser;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


@Controller
@RequestMapping("/web")
public class BscPlanxlWebControl extends BaseWebService {
	@Resource
	private BscPlanxlWebService planxlWebService;
	@Resource
	private BscPlanxlDetailWebService planxlDetailWebService;
	
	/**
	 *说明：分页查询计划线路
	 *@创建：作者:llp		创建时间：2016-8-15
	 *@修改历史：
	 *		[序号](llp	2016-8-15)<修改说明>
	 */
	@RequestMapping("queryBscPlanxlWeb")
	public void queryBscPlanxlWeb(HttpServletResponse response,String token,Integer pageNo,Integer pageSize,String xlNm, Integer mid){
		try {
			if (!checkParam(response, token))
				return;
			OnlineMessage message = TokenServer.tokenCheck(token);
			if(message.isSuccess()==false){
				sendWarm(response, message.getMessage());
				return;
			}
			if(pageSize==null){
				pageSize=10;
			}
			OnlineUser onlineUser = message.getOnlineMember();
			//如果mid为空，查询自己
			if(StrUtil.isNull(mid)){
				mid = onlineUser.getMemId();
			}
			Page p = this.planxlWebService.queryBscPlanxlWeb(onlineUser.getDatabase(), mid, pageNo, pageSize, xlNm);
			JSONObject json = new JSONObject();
			json.put("state", true);
			json.put("msg", "获取计划线路列表成功");
			json.put("pageNo", pageNo);
			json.put("pageSize", pageSize);
			json.put("total", p.getTotal());
			json.put("totalPage", p.getTotalPage());
			json.put("rows", p.getRows());
			this.sendJsonResponse(response, json.toString());
		} catch (Exception e) {
			log.error("获取计划线路列表失败", e);
			e.printStackTrace();
			this.sendWarm(response, "获取计划线路列表失败");
		}
	}
	/**
	 *说明：添加计划线路
	 *@创建：作者:llp		创建时间：2016-8-15
	 *@修改历史：
	 *		[序号](llp	2016-8-15)<修改说明>
	 */
	@RequestMapping("addBscPlanxlWeb")
	public void addBscPlanxlWeb(HttpServletResponse response,HttpServletRequest request,String token,String xlNm,String cids){
		try{
			if(!checkParam(response, token,xlNm,cids)){
				return;
			}
			OnlineMessage message = TokenServer.tokenCheck(token);
			if(message.isSuccess()==false){
				sendWarm(response, message.getMessage());
				return;
			}
			OnlineUser onlineUser = message.getOnlineMember();
			BscPlanxl planxl=new BscPlanxl();
			planxl.setMid(onlineUser.getMemId());
			planxl.setXlNm(xlNm);
			int id=this.planxlWebService.addBscPlanxlWeb(planxl, onlineUser.getDatabase());
			for(int i=0;i<cids.split(",").length;i++){
				BscPlanxlDetail planxlDetail=new BscPlanxlDetail();
				planxlDetail.setCid(Integer.parseInt(cids.split(",")[i]));
				planxlDetail.setXlId(id);
				this.planxlDetailWebService.addBscPlanxlDetailWeb(planxlDetail, onlineUser.getDatabase());
			}
			JSONObject json = new JSONObject();
			json.put("state",true);
			json.put("msg", "添加计划线路成功");
			this.sendJsonResponse(response, json.toString());
		} catch (Exception e) {
			log.error("添加计划线路失败：", e);
			this.sendWarm(response, "添加计划线路失败");
		}
	}
	/**
	 *说明：修改计划线路
	 *@创建：作者:llp		创建时间：2016-8-15
	 *@修改历史：
	 *		[序号](llp	2016-8-15)<修改说明>
	 */
	@RequestMapping("updateBscPlanxlWeb")
	public void updateBscPlanxlWeb(HttpServletResponse response,HttpServletRequest request,String token,Integer id,String xlNm){
		try{
			if(!checkParam(response, token,id,xlNm)){
				return;
			}
			OnlineMessage message = TokenServer.tokenCheck(token);
			if(message.isSuccess()==false){
				sendWarm(response, message.getMessage());
				return;
			}
			OnlineUser onlineUser = message.getOnlineMember();
			this.planxlWebService.updateBscPlanxlWeb(onlineUser.getDatabase(), id, xlNm);
			JSONObject json = new JSONObject();
			json.put("state",true);
			json.put("msg", "修改计划线路成功");
			this.sendJsonResponse(response, json.toString());
		} catch (Exception e) {
			log.error("修改计划线路失败：", e);
			this.sendWarm(response, "修改计划线路失败");
		}
	}
	/**
	 *说明：修改计划线路
	 */
	@RequestMapping("updateBscPlanxlWeb2")
	public void updateBscPlanxlWeb2(HttpServletResponse response,HttpServletRequest request,String token,Integer id,String xlNm, String cids){
		try{
			if(!checkParam(response, token,id,xlNm,cids)){
				return;
			}
			OnlineMessage message = TokenServer.tokenCheck(token);
			if(message.isSuccess()==false){
				sendWarm(response, message.getMessage());
				return;
			}
			OnlineUser onlineUser = message.getOnlineMember();
			this.planxlWebService.updateBscPlanxlWeb2(onlineUser.getDatabase(), id, xlNm, cids);
			JSONObject json = new JSONObject();
			json.put("state",true);
			json.put("msg", "修改计划线路成功");
			this.sendJsonResponse(response, json.toString());
		} catch (Exception e) {
			log.error("修改计划线路失败：", e);
			this.sendWarm(response, "修改计划线路失败");
		}
	}
	/**
	 *说明：删除计划线路
	 *@创建：作者:llp		创建时间：2016-8-15
	 *@修改历史：
	 *		[序号](llp	2016-8-15)<修改说明>
	 */
	@RequestMapping("deleteBscPlanxlWeb")
	public void deleteBscPlanxlWeb(HttpServletResponse response,HttpServletRequest request,String token,String ids){
		try{
			if(!checkParam(response, token,ids)){
				return;
			}
			OnlineMessage message = TokenServer.tokenCheck(token);
			if(message.isSuccess()==false){
				sendWarm(response, message.getMessage());
				return;
			}
			OnlineUser onlineUser = message.getOnlineMember();
			for(int i=0;i<ids.split(",").length;i++){
			 this.planxlWebService.deleteBscPlanxlWeb(onlineUser.getDatabase(), Integer.parseInt(ids.split(",")[i]));
			 this.planxlDetailWebService.deleteBscPlanxlDetailWeb(onlineUser.getDatabase(), Integer.parseInt(ids.split(",")[i]), null);
			}
			JSONObject json = new JSONObject();
			json.put("state",true);
			json.put("msg", "删除计划线路成功");
			this.sendJsonResponse(response, json.toString());
		} catch (Exception e) {
			log.error("删除计划线路失败：", e);
			this.sendWarm(response, "删除计划线路失败");
		}
	}
	//-----------------------------------------计划线路详情--------------------------------------------------
	/**
	 *说明：分页查询计划线路客户
	 *@创建：作者:llp		创建时间：2016-8-15
	 *@修改历史：
	 *		[序号](llp	2016-8-15)<修改说明>
	 */
	@RequestMapping("queryBscPlanxlDetailWeb")
	public void queryBscPlanxlDetailWeb(HttpServletResponse response,String token,Integer pageNo,Integer pageSize,Integer xlId){
		try {
			if (!checkParam(response, token))
				return;
			OnlineMessage message = TokenServer.tokenCheck(token);
			if(message.isSuccess()==false){
				sendWarm(response, message.getMessage());
				return;
			}
			if(pageSize==null){
				pageSize=10;
			}
			OnlineUser onlineUser = message.getOnlineMember();
		    Page p=this.planxlDetailWebService.queryBscPlanxlDetailWeb(onlineUser.getDatabase(), pageNo,pageSize, xlId);
			JSONObject json=new JSONObject();
			json.put("state", true);
			json.put("msg", "获取计划线路客户列表成功");
			json.put("pageNo", pageNo);
			json.put("pageSize", pageSize);
			json.put("total", p.getTotal());
			json.put("totalPage", p.getTotalPage());
			json.put("rows", p.getRows());
			this.sendJsonResponse(response, json.toString());
		} catch (Exception e) {
			this.sendWarm(response, "获取计划线路客户列表失败");
		}
	}
	/**
	 *说明：添加计划线路客户
	 *@创建：作者:llp		创建时间：2016-8-15
	 *@修改历史：
	 *		[序号](llp	2016-8-15)<修改说明>
	 */
	@RequestMapping("addBscPlanxlDetailWeb")
	public void addBscPlanxlDetailWeb(HttpServletResponse response,HttpServletRequest request,String token,Integer xlId,String cids){
		try{
			if(!checkParam(response, token,xlId,cids)){
				return;
			}
			OnlineMessage message = TokenServer.tokenCheck(token);
			if(message.isSuccess()==false){
				sendWarm(response, message.getMessage());
				return;
			}
			OnlineUser onlineUser = message.getOnlineMember();
			for(int i=0;i<cids.split(",").length;i++){
				BscPlanxlDetail planxlDetail=new BscPlanxlDetail();
				planxlDetail.setCid(Integer.parseInt(cids.split(",")[i]));
				planxlDetail.setXlId(xlId);
				this.planxlDetailWebService.addBscPlanxlDetailWeb(planxlDetail, onlineUser.getDatabase());
			}
			JSONObject json = new JSONObject();
			json.put("state",true);
			json.put("msg", "添加计划线路客户成功");
			this.sendJsonResponse(response, json.toString());
		} catch (Exception e) {
			log.error("添加计划线路详情失败：", e);
			this.sendWarm(response, "添加计划线路客户失败");
		}
	}
	/**
	 *说明：删除计划线路客户
	 *@创建：作者:llp		创建时间：2016-8-15
	 *@修改历史：
	 *		[序号](llp	2016-8-15)<修改说明>
	 */
	@RequestMapping("deleteBscPlanxlDetailWeb")
	public void deleteBscPlanxlDetailWeb(HttpServletResponse response,HttpServletRequest request,String token,Integer xlId,String cids){
		try{
			if(!checkParam(response, token,xlId,cids)){
				return;
			}
			OnlineMessage message = TokenServer.tokenCheck(token);
			if(message.isSuccess()==false){
				sendWarm(response, message.getMessage());
				return;
			}
			OnlineUser onlineUser = message.getOnlineMember();
			this.planxlDetailWebService.deleteBscPlanxlDetailWeb(onlineUser.getDatabase(), xlId, cids);
			JSONObject json = new JSONObject();
			json.put("state",true);
			json.put("msg", "删除计划线路客户成功");
			this.sendJsonResponse(response, json.toString());
		} catch (Exception e) {
			log.error("删除计划线路客户失败：", e);
			this.sendWarm(response, "删除计划线路客户失败");
		}
	}
}
