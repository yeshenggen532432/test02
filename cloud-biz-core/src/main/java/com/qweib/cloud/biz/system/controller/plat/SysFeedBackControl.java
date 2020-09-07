package com.qweib.cloud.biz.system.controller.plat;

import com.qweib.cloud.biz.common.GeneralControl;
import com.qweib.cloud.biz.system.service.ws.SysFeedbackService;
import com.qweib.cloud.utils.Page;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@Controller
@RequestMapping("/manager")
public class SysFeedBackControl extends GeneralControl{
	@Resource
	private SysFeedbackService feedBackService;
	
	/**
	  *@see 到任务反馈页面
	  *@return
	  *@创建：作者:YYP		创建时间：2015-6-23
	 */
	@RequestMapping("feedBackPage")
	public String querycorporation(Model model, HttpServletRequest request, HttpServletResponse response, Integer pageNo, String feedType, String scontent){
		if(null==pageNo){//默认第一页
			pageNo=1;
		}
		if(null==feedType){//默认查询全部
			feedType="0";
		}
		try{
			Page p =feedBackService.queryFeedBackByPage(pageNo,5,feedType,scontent); 
			model.addAttribute("page", p);
			model.addAttribute("feedType",feedType);
			model.addAttribute("scontent",scontent);
			p = null;
		}catch (Exception e) {
			log.error("分页查询公司出错", e);
		}
		return "/publicplat/feedBackPage/feedBackPage";
	}

	
	@RequestMapping("toShowpic")
	public String toShowpic(HttpServletRequest request, HttpServletResponse response, Model model, String pic){
		model.addAttribute("pic",pic);
		return "/publicplat/feedBackPage/showPic";
	}
	
}
