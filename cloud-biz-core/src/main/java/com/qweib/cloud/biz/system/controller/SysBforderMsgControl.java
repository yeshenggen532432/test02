package com.qweib.cloud.biz.system.controller;

import com.qweib.cloud.biz.system.service.SysBforderMsgService;
import com.qweib.cloud.core.domain.SysBforderMsg;
import com.qweib.cloud.core.domain.SysLoginInfo;
import com.qweib.cloud.biz.common.GeneralControl;
import com.qweib.cloud.utils.DateTimeUtil;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Date;
import java.util.List;

@Controller
@RequestMapping("/manager")
public class SysBforderMsgControl extends GeneralControl{
	@Resource
	private SysBforderMsgService orderMsgService;
	/**
	 *说明：列表查订单提示信息
	 *@创建：作者:llp		创建时间：2016-5-17
	 *@修改历史：
	 *		[序号](llp	2016-5-17)<修改说明>
	 */
	@RequestMapping("/queryBforderMsgls")
	public void queryBforderMsgls(HttpServletResponse response, HttpServletRequest request){
		try {
			SysLoginInfo info = getLoginInfo(request);
			List<SysBforderMsg> list=this.orderMsgService.queryBforderMsgls(info.getDatasource());
			JSONObject json = new JSONObject();
			json.put("state", 1);
			json.put("newaddtime", DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd HH:mm:ss"));
			json.put("rows", list);
			sendJsonResponse(response, json.toString());
		} catch (Exception e) {
			log.error("获取消息出错:", e);
			this.sendJsonResponse(response, "{\"state\":-1}");
		}
	}
	/**
	 *说明：修改信息已读
	 *@创建：作者:llp		创建时间：2016-5-17
	 *@修改历史：
	 *		[序号](llp	2016-5-17)<修改说明>
	 */
	@RequestMapping("/updateBforderMsgisRead")
	public void updateBforderMsgisRead(HttpServletResponse response, HttpServletRequest request, Integer id){
		try {
			SysLoginInfo info = getLoginInfo(request);
			this.orderMsgService.updateBforderMsgisRead(info.getDatasource(), id);
			this.sendHtmlResponse(response, "1");
		} catch (Exception e) {
			log.error("修改消息出错:", e);
			this.sendHtmlResponse(response, "-1");
		}
	}
}
