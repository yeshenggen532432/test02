package com.qweib.cloud.biz.system.controller.ws;

import com.qweib.cloud.biz.system.BaseWebService;
import com.qweib.cloud.biz.system.service.ws.BscTopicWebService;
import com.qweib.cloud.biz.system.service.ws.BscTrueWebSerivce;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;

/**
 * 真心话接口
 * @author guojp
 */
@Controller
@RequestMapping("/web")
public class BscTrueWebControl extends BaseWebService {
	@Resource
	private BscTrueWebSerivce bscTrueWebSerivce;
	@Resource
	private BscTopicWebService bscTopicWebService;
	/**
	 * 查询真心话页面(分页)
	 * @param pageNo	当前的页数(必选项，默认第1页)
	 * @param pageSize 每页的记录条数(必选项,默认10条)
	 */
	/*@RequestMapping("truelist")
	public void truelist(HttpServletResponse response,String token,Integer pageNo,Integer pageSize){
		if(null==pageSize){
			pageSize = 10;
		}
		if(null==pageNo){
			pageNo = 1;
		}
		
		if (!checkParam(response, token))
			return;
		try {
			OnlineMessage message = TokenServer.tokenCheck(token);
			if(message.isSuccess()==false){
				sendWarm(response, message.getMessage());
				return;
			}
			OnlineUser onlineUser = message.getOnlineMember();
			Page page = this.bscTrueWebSerivce.page(null, pageNo, pageSize,onlineUser.getDatabase());
			if(page.getTotal()==0){
				sendSuccess(response, "暂时没有人发表真心话");
				return;
			}
			JSONObject json = new JSONObject();
			json.put("state", true);
			json.put("msg", "查询成功");
			json.put("rows", page.getRows());
			json.put("pageNo", page.getCurPage());
			json.put("pageSize", page.getPageSize());
			json.put("totalCount", page.getTotal());
			json.put("hasNext",page.getTotalPage()<=page.getCurPage()?false:true);
			sendJsonResponse(response, json.toString());
		} catch (JSONException e) {
			sendException(response, e);
		}
	}
	*//**
	 * 真心话详情(暂时不用改为聊天)
	 * @param token(口令,必填)
	 * @param trueId(真心话id,必填)
	 *//*
	@RequestMapping("trueDetail")
	public void trueDetail(HttpServletRequest request,HttpServletResponse response,String token,Integer trueId,Integer pageNo,Integer pageSize){
		if(!checkParam(response, trueId))
			return;
		if(StrUtil.isNull(pageNo)){
			pageNo=1;
		}
		if(StrUtil.isNull(pageSize)){
			pageSize=10;
		}
		try {
			OnlineMessage message = TokenServer.tokenCheck(token);
			if(message.isSuccess()==false){
				sendWarm(response, message.getMessage());
				return;
			}
			OnlineUser onlineUser = message.getOnlineMember();
			BscTrue bsctrue = this.bscTrueWebSerivce.queryTrueByTid(trueId,onlineUser.getDatabase());
			if(StrUtil.isNull(bsctrue)){
				sendWarm(response, "找不到对应的真心话");
				return;
			}
			Page pages = this.bscTopicWebService.pages(trueId,onlineUser.getDatabase(), pageNo, pageSize);
			
			JSONObject json = new JSONObject();
			json.put("state", true);
			json.put("msg", "查询成功");
			json.put("bsctrue",new JSONObject(bsctrue));
			json.put("total", pages.getTotalPage());
			json.put("rows", pages.getRows());
			json.put("pageNo", pages.getCurPage());
			json.put("pageSize", pages.getPageSize());
			json.put("totalCount", pages.getTotal());
			json.put("hasNext",pages.getTotalPage()<=pages.getCurPage()?false:true);
			sendJsonResponse(response, json.toString());
		} catch (JSONException e) {
			sendException(response, e);
		}
	}*/
}
