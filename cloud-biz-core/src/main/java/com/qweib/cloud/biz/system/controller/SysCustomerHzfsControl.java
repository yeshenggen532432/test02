package com.qweib.cloud.biz.system.controller;

import com.qweib.cloud.biz.system.service.SysCustomerHzfsService;
import com.qweib.cloud.core.domain.SysCustomerHzfs;
import com.qweib.cloud.core.domain.SysLoginInfo;
import com.qweib.cloud.biz.common.GeneralControl;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;

@Controller
@RequestMapping("/manager")
public class SysCustomerHzfsControl extends GeneralControl{
	
	@Resource
	private SysCustomerHzfsService hzfsService;
	
	@RequestMapping("saveHzfs")
	public void saveHzfs(SysCustomerHzfs hzfs, HttpServletResponse response, HttpServletRequest request){
		try {
			SysLoginInfo info = this.getLoginInfo(request);
			if(hzfs.getHzfsNm() == null)
				{
					this.sendHtmlResponse(response, "-1");
					return;
				}
			if(hzfs.getId() == null)
			{
				SysCustomerHzfs hzfs1 = this.hzfsService.getHzfsByName(hzfs.getHzfsNm(), info.getDatasource());
				if(hzfs1!= null)
				{
					this.sendHtmlResponse(response, "-1");
					return;
				}
				
			}
			this.hzfsService.addHzfs(hzfs, info.getDatasource());
			this.sendHtmlResponse(response, "1");
			
		} catch (Exception e) {
			log.error("操作经销商状态出错：", e);
			this.sendHtmlResponse(response, "-1");
		}
	}
	
	@RequestMapping("toCustomerHzfs")
	public String toCustomerHzfs(Model model){
		return "/uglcw/customer/hzfs";
	}
	
	@RequestMapping("/toCustomerHzfsEdit")
	public String toCustomerHzfsEdit(HttpServletRequest request, Model model, Integer id){
		try {
			SysLoginInfo info = this.getLoginInfo(request);
			SysCustomerHzfs hzfs = this.hzfsService.getHzfsById(id, info.getDatasource());
			model.addAttribute("hzfs",hzfs);
		} catch (Exception e) {
			// TODO: handle exception
			log.error("登录错误", e);
		}
		return "/uglcw/customer/hzfs_edit";
	}
	
	@RequestMapping("queryHzfsPage")
	public void queryHzfsPage(HttpServletResponse response, HttpServletRequest request){
		try {
			SysLoginInfo info = this.getLoginInfo(request);
			List<SysCustomerHzfs> list = this.hzfsService.queryHzfsList(info.getDatasource());
			JSONObject json = new JSONObject();
			json.put("total", list.size());
			json.put("rows", list);
			this.sendJsonResponse(response, json.toString());
		} catch (Exception e) {
			log.error("分页查询合作方式出错：", e);
		}
	}
	
	@RequestMapping("deleteHzfs")
	public void deleteHzfs(HttpServletResponse response, HttpServletRequest request, String token, String ids){
		SysLoginInfo info = this.getLoginInfo(request);
		try
		{
			this.hzfsService.deleteHzfs(ids, info.getDatasource());
			JSONObject json = new JSONObject();
			
			json.put("state",true);
			json.put("id", 0);
			json.put("msg", "删除成功");
			this.sendJsonResponse(response, json.toString());
	} catch (Exception e) {
		this.sendJsonResponse(response, "删除节假日失败");
	}
	}

}
