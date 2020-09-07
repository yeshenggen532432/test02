package com.qweib.cloud.biz.system.controller.ws;

import com.qweib.cloud.biz.common.GeneralControl;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * 园区页面
 */
@Controller
@RequestMapping("/web")
public class SysYuanquControl extends GeneralControl{

	/**
	 * 主页
	 */
	@RequestMapping("yqindex")
	public String yqindex(HttpServletRequest request, HttpServletResponse response){
		return "companyPlat/yuanqu/fw";
	}
	/**
	 * 园区圈
	 */
	@RequestMapping("yqyqq")
	public String yqyqq(HttpServletRequest request, HttpServletResponse response){
		return "companyPlat/yuanqu/yqq";
	}
}
