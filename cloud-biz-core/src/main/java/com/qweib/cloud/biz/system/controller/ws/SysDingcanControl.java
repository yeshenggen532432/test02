package com.qweib.cloud.biz.system.controller.ws;

import com.qweib.cloud.biz.common.GeneralControl;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * 订餐页面
 */
@Controller
@RequestMapping("/web")
public class SysDingcanControl extends GeneralControl{

	/**
	 * 店铺
	 */
	@RequestMapping("dczxct")
	public String dczxct(HttpServletRequest request, HttpServletResponse response){
		return "companyPlat/dingcan/zxct";
	}
	/**
	 * 在线订餐
	 */
	@RequestMapping("dczxdc")
	public String dczxdc(HttpServletRequest request, HttpServletResponse response){
		return "companyPlat/dingcan/zxdc";
	}
	/**
	 * 已点查询
	 */
	@RequestMapping("dczxyd")
	public String dczxyd(HttpServletRequest request, HttpServletResponse response){
		return "companyPlat/dingcan/zxyd";
	}
	/**
	 * 我的订餐
	 */
	@RequestMapping("dcwddc")
	public String dcwddc(HttpServletRequest request, HttpServletResponse response){
		return "companyPlat/dingcan/wddc";
	}
}
