package com.qweib.cloud.biz.system.controller;


import com.qweib.cloud.biz.system.UploadFile;
import com.qweib.cloud.biz.system.BaseWebService;
import com.qweib.cloud.biz.system.TokenServer;
import com.qweib.cloud.biz.system.service.ws.SysFeedbackService;
import com.qweib.cloud.core.domain.OnlineMessage;
import com.qweib.cloud.core.domain.OnlineUser;
import com.qweib.cloud.core.domain.SysFeedback;
import com.qweib.cloud.utils.DateTimeUtil;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Date;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/web/")
public class SysFeedbackWebControl extends BaseWebService {
	@Resource
	private SysFeedbackService feedbackService;


	/**
	  *@see 添加意见反馈
	  *@param request
	  *@param response
	  *@param token
	  *@param feedback String feedType,String feedContent,String plat(ios/android)
	  *@创建：作者:YYP		创建时间：2015-6-19
	 */
	@RequestMapping("addFeedback")
	public void addFeedback(HttpServletRequest request, HttpServletResponse response, String token, SysFeedback feedback){
//		List<SysFeedbackPic> picList = new ArrayList<SysFeedbackPic>();
		List<String> pic = null;
		List<String> picMini = null;
		if (!checkParam(response, token,feedback.getFeedType(),feedback.getFeedContent(),feedback.getPlat()))
			return;
		try{
			OnlineMessage message = TokenServer.tokenCheck(token);
			if(message.isSuccess()==false){
				sendWarm(response, message.getMessage());
				return;
			}
			OnlineUser onlineUser = message.getOnlineMember();
			//保存图片
			Map<String, Object> map = UploadFile.updatePhotos(request,"publicplat","feedback",null);
			if("1".equals(map.get("state"))){
				if("1".equals(map.get("ifImg"))){//是否有图片
					pic = (List<String>)map.get("fileNames");
					picMini = (List<String>)map.get("smallFile");
				}
			}else{
				sendWarm(response, "图片上传失败");
			}
			String time = DateTimeUtil.getDateToStr(new Date(),"yyyy-MM-dd HH:mm:ss");
			feedback.setFeedTime(time);
			feedback.setMemberId(onlineUser.getMemId());
			feedbackService.addFeedbackAndpic(pic,picMini,feedback);//保存意见反馈和图片
			sendSuccess(response, "添加意见反馈成功");
		}catch (Exception e) {
			sendException(response, e);
		}
	}
}
