package com.qweib.cloud.biz.system.controller.mobile;


import com.qweib.cloud.biz.common.CnlifeConstants;
import com.qweib.cloud.biz.system.BaseWebService;
import com.qweib.cloud.biz.system.TokenServer;
import com.qweib.cloud.biz.system.jpush.JpushClassifies;
import com.qweib.cloud.biz.system.jpush.JpushClassifies2;
import com.qweib.cloud.biz.system.service.SysConfigService;
import com.qweib.cloud.biz.system.service.SysCustomerService;
import com.qweib.cloud.biz.system.service.SysQdtypeService;
import com.qweib.cloud.biz.system.service.ws.SysBfxsxjWebService;
import com.qweib.cloud.biz.system.service.ws.SysChatMsgService;
import com.qweib.cloud.biz.system.service.ws.SysCustomerWebService;
import com.qweib.cloud.biz.system.service.ws.SysMemberWebService;
import com.qweib.cloud.core.domain.*;
import com.qweib.cloud.utils.DateTimeUtil;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Date;
import java.util.List;

@Controller
@RequestMapping("/web")
public class SysQdtypeWebControl extends BaseWebService {
	@Resource
	private SysQdtypeService qdtypeService;

	@RequestMapping("customerTypeList")
	public void customerTypeList(Model model, HttpServletResponse response,HttpServletRequest request,String token){
		JSONObject json=new JSONObject();
		if(!checkParam(response, token)){
			return;
		}
		OnlineMessage message = TokenServer.tokenCheck(token);
		if(message.isSuccess()==false){
			sendWarm(response, message.getMessage());
			return;
		}
		OnlineUser onlineUser = message.getOnlineMember();
		try {
			List<SysQdtype> list = this.qdtypeService.queryQdtypels(onlineUser.getDatabase());
			model.addAttribute("list", list);
			json.put("state", true);
			json.put("msg", "获取客户类型列表成功");
			json.put("rows", list);
			this.sendJsonResponse(response, json.toString());
		} catch (Exception e) {
			json.put("state", false);
			this.sendJsonResponse(response, json.toString());
			log.error("",e);
		}
	}
}
