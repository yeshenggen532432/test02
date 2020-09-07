package com.qweib.cloud.biz.system.controller.ws;

import com.qweib.cloud.biz.system.BaseWebService;
import com.qweib.cloud.biz.system.TokenServer;
import com.qweib.cloud.biz.system.UploadFile;
import com.qweib.cloud.biz.system.service.*;
import com.qweib.cloud.biz.system.service.ws.SysWareWebService;
import com.qweib.cloud.core.domain.*;
import com.qweib.cloud.utils.StrUtil;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * 商品类别----移动端接口
 */
@Controller
@RequestMapping("/web")
public class SysWareTypeWebControl extends BaseWebService {
	@Resource
	private SysWareWebService wareWebService;
	@Resource
	private SysWaretypeService waretypeService;

	/**
	 * 查询公司类商品类别
	 * @param response
	 * @param request
	 * @param token
	 */
	@RequestMapping("queryWareTypeTree")
	public void queryWareTypeTree(HttpServletResponse response,HttpServletRequest request,String token){
		try{
			if(!checkParam(response, token)){
				return;
			}
			OnlineMessage message = TokenServer.tokenCheck(token);
			if(message.isSuccess()==false){
				sendWarm(response, message.getMessage());
				return;
			}
			OnlineUser onlineUser = message.getOnlineMember();
			SysWaretype sysType = new SysWaretype();
            sysType.setWaretypeId(0);//查询第一级
			List<SysWaretype> list = this.waretypeService.queryCompanyWaretypeList(sysType,onlineUser.getDatabase());
			for(int i=0;i<list.size();i++){
			    //查询第二级
				List<SysWaretype> list2=this.waretypeService.queryCompanyWaretypeList(list.get(i),onlineUser.getDatabase());
				list.get(i).setList2(list2);
			}

			JSONObject json = new JSONObject();
			json.put("state", true);
			json.put("msg", "获取商品类别树成功");
			json.put("list",list);
			this.sendJsonResponse(response, json.toString());
		} catch (Exception e) {
			log.error("获取商品类别树失败",e);
			e.printStackTrace();
			this.sendWarm(response, "获取商品类别树失败");
		}
	}

	/**
	 * 查询库存类公司类商品类别
	 * @param response
	 * @param request
	 * @param token
	 */
	@RequestMapping("queryStkWareType")
	public void queryStkWareType(HttpServletResponse response, HttpServletRequest request, String token,Integer isType){
		try{
			if(!checkParam(response, token)){
				return;
			}
			OnlineMessage message = TokenServer.tokenCheck(token);
			if(message.isSuccess()==false){
				sendWarm(response, message.getMessage());
				return;
			}
			OnlineUser onlineUser = message.getOnlineMember();

            SysWaretype sysType = new SysWaretype();
            sysType.setWaretypeId(0);//查询第一级
			if(isType == null){
				sysType.setIsType(0);//默认库存商品
			}
            List<SysWaretype> list = this.waretypeService.queryCompanyWaretypeList(sysType,onlineUser.getDatabase());
			for(int i=0;i<list.size();i++){
			    //查询第二级
				List<SysWaretype> list2=this.waretypeService.queryCompanyWaretypeList(list.get(i),onlineUser.getDatabase());
				list.get(i).setList2(list2);
			}
			JSONObject json = new JSONObject();
			json.put("state",true);
			json.put("msg", "获取商品类别列表成功");
			json.put("list",list);
			this.sendJsonResponse(response, json.toString());
		} catch (Exception e) {
			log.error("获取商品类别树失败",e);
			e.printStackTrace();
			this.sendWarm(response, "获取商品类别失败");
		}
	}

	/**
	 * 查询所有商品类别
	 * @param response
	 * @param request
	 * @param token
	 */
	@RequestMapping("queryWareTypeList")
	public void queryWareTypeList(HttpServletResponse response, HttpServletRequest request, String token){
		try{
			if(!checkParam(response, token)){
				return;
			}
			OnlineMessage message = TokenServer.tokenCheck(token);
			if(message.isSuccess()==false){
				sendWarm(response, message.getMessage());
				return;
			}
            OnlineUser onlineUser = message.getOnlineMember();
            SysWaretype sysType = new SysWaretype();
            sysType.setWaretypeId(0);//查询第一级
			List<SysWaretype> list = this.waretypeService.queryWaretype(sysType,onlineUser.getDatabase());
			for(int i=0;i<list.size();i++){
			    //查询第二级
				List<SysWaretype> list2=this.waretypeService.queryWaretype(list.get(i),onlineUser.getDatabase());
				list.get(i).setList2(list2);
			}
			JSONObject json = new JSONObject();
			json.put("state",true);
			json.put("msg", "获取所有商品类别列表成功");
			json.put("list",list);
			this.sendJsonResponse(response, json.toString());
		} catch (Exception e) {
			log.error("获取商品类别树失败",e);
			e.printStackTrace();
			this.sendWarm(response, "获取所有商品类别失败");
		}
	}

	@RequestMapping("queryCompanyWareTypeTree")
	public void queryCompanyWareTypeTree(HttpServletResponse response,HttpServletRequest request,String token, String isType){
		try{
			if(!checkParam(response, token)){
				return;
			}
			OnlineMessage message = TokenServer.tokenCheck(token);
			if(message.isSuccess()==false){
				sendWarm(response, message.getMessage());
				return;
			}
			OnlineUser onlineUser = message.getOnlineMember();
			SysWaretype sysType = new SysWaretype();
			sysType.setWaretypeId(0);//查询第一级
			if(!StrUtil.isNull(isType)){
				sysType.setIsType(Integer.valueOf(isType));
			}else{
				sysType.setIsType(Integer.valueOf(0));//默认库存商品类
			}
			List<SysWaretype> list = this.waretypeService.queryCompanyWaretypeList(sysType,onlineUser.getDatabase());
			for(int i=0;i<list.size();i++){
				//查询第二级
				List<SysWaretype> list2=this.waretypeService.queryCompanyWaretypeList(list.get(i),onlineUser.getDatabase());
				list.get(i).setList2(list2);
			}

			JSONObject json = new JSONObject();
			json.put("state",true);
			json.put("msg", "获取商品类别树成功");
			json.put("list",list);
			this.sendJsonResponse(response, json.toString());
		} catch (Exception e) {
			log.error("获取商品类别树失败",e);
			e.printStackTrace();
			this.sendWarm(response, "获取商品类别树失败");
		}
	}
	@RequestMapping("queryWaretypeLs1")
	public void queryWaretypeLs1(HttpServletResponse response, HttpServletRequest request, String token){
		try{
			if(!checkParam(response, token)){
				return;
			}
			OnlineMessage message = TokenServer.tokenCheck(token);
			if(message.isSuccess()==false){
				sendWarm(response, message.getMessage());
				return;
			}
			OnlineUser onlineUser = message.getOnlineMember();
			SysWaretype sysType = new SysWaretype();
			sysType.setWaretypeId(0);//查询第一级
			List<SysWaretype> list = this.waretypeService.queryWaretype(sysType,onlineUser.getDatabase());
			for(int i=0;i<list.size();i++){
				//查询第二级
				List<SysWaretype> list2=this.waretypeService.queryWaretype(list.get(i),onlineUser.getDatabase());
				list.get(i).setList2(list2);
			}
			JSONObject json = new JSONObject();
			json.put("state",true);
			json.put("msg", "获取所有商品类别列表成功");
			json.put("list",list);
			this.sendJsonResponse(response, json.toString());
		} catch (Exception e) {
			log.error("获取商品类别树失败",e);
			e.printStackTrace();
			this.sendWarm(response, "获取所有商品类别失败");
		}
	}
}
