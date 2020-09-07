package com.qweib.cloud.biz.system.controller.mobile;


import com.qweib.cloud.biz.system.BaseWebService;
import com.qweib.cloud.biz.system.TokenServer;
import com.qweib.cloud.biz.system.service.plat.SysAddressUploadService;
import com.qweib.cloud.core.domain.OnlineMessage;
import com.qweib.cloud.core.domain.OnlineUser;
import com.qweib.cloud.core.domain.SysAddressUpload;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * 位置上传方式
 * @author ysg
 */
@Controller
@RequestMapping("/web")
public class SysAddressUploadWebControl extends BaseWebService {
	
	@Resource
	private SysAddressUploadService addressUploadService;
	
	/**
	 *说明：获取位置上传方式
	 *@创建：作者:ysg	
	 *@创建时间：2018-09-27
	 *@修改历史：
	 */
	@RequestMapping("queryAddressUplaodWeb")
	public void queryAddressUplaodWebByMemId(HttpServletResponse response,String token){
		try {
			if (!checkParam(response, token))
				return;
			OnlineMessage message = TokenServer.tokenCheck(token);
			if(message.isSuccess()==false){
				sendWarm(response, message.getMessage());
				return;
			}
			OnlineUser onlineUser = message.getOnlineMember();
			
			SysAddressUpload model=addressUploadService.queryByMemId(onlineUser.getMemId(), onlineUser.getDatabase());
			JSONObject json=new JSONObject();
			if(model!=null){
				json.put("state", true);
				json.put("msg", "获取位置上传方式成功");
				json.put("memId", model.getMemId());
				json.put("upload", model.getUpload());
				json.put("memUpload", model.getMemUpload());
				json.put("min", model.getMin());
			}else{
				json.put("state", false);
				json.put("msg", "暂无数据");
			}
			this.sendJsonResponse(response, json.toString());
		} catch (Exception e) {
			this.sendWarm(response, "获取位置上传方式失败");
		}
	}
	
	/**
	 *@说明：位置上传方式
	 *@创建：作者:ysg		
	 *@创建时间：2018-09-27
	 *@修改历史：
	 */
	@RequestMapping("updateAddressUpload")
	public void updateAddressUpload(SysAddressUpload model,HttpServletResponse response,HttpServletRequest request,String token){
		try {
			int count = 0;
			if (!checkParam(response, token))
				return;
			OnlineMessage message = TokenServer.tokenCheck(token);
			if(message.isSuccess()==false){
				sendWarm(response, message.getMessage());
				return;
			}
			OnlineUser onlineUser = message.getOnlineMember();
			
			SysAddressUpload model2=this.addressUploadService.queryByMemId(onlineUser.getMemId(), onlineUser.getDatabase());
			if(model2==null){
				model.setMemId(onlineUser.getMemId());
				count=this.addressUploadService.add(model, onlineUser.getDatabase());
			}else{
				//这边只修改“业务员自己上传方式”
				model2.setMemUpload(model.getMemUpload());
				count=this.addressUploadService.update(model2, onlineUser.getDatabase());
			}
			
			JSONObject json=new JSONObject();
			if(count>0){
				json.put("state", true);
				json.put("msg", "上传方式修改成功");
			}else{
				json.put("state", false);
				json.put("msg", "上传方式修改失败");
			}
			this.sendJsonResponse(response, json.toString());
		} catch (Exception e) {
			e.printStackTrace();
			this.sendWarm(response, "上传方式修改失败");
		}
	}
	
}
