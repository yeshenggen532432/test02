package com.qweib.cloud.biz.system.controller;


import com.qweib.cloud.biz.common.GeneralControl;
import com.qweib.cloud.biz.system.service.SysLogisticsService;
import com.qweib.cloud.core.domain.SysLogistics;
import com.qweib.cloud.utils.Page;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@Controller
@RequestMapping("/manager")
public class SysLogisticsControl extends GeneralControl {
	@Resource
	private SysLogisticsService logisticsService;
	
	/**
	 * 
	  *摘要：
	  *@说明：物流公司主页
	  *@创建：作者:llp		创建时间：2016-2-17
	  *@修改历史：
	  *		[序号](llp	2016-2-17)<修改说明>
	 */
	@RequestMapping("/queryLogistics")
	public String queryLogistics(){
		return "/uglcw/logistics/logistics";
	}
	/**
	 * 
	  *摘要：
	  *@说明：分页查询物流公司
	  *@创建：作者:llp		创建时间：2016-2-17
	  *@修改历史：
	  *		[序号](llp	2016-2-17)<修改说明>
	 */
	@RequestMapping("/logisticsPage")
	public void logisticsPage(HttpServletRequest request, HttpServletResponse response, SysLogistics logistics, Integer page, Integer rows){
		try{
			Page p = this.logisticsService.queryLogistics(logistics, page, rows);
			JSONObject json = new JSONObject();
			json.put("total", p.getTotal());
			json.put("rows", p.getRows());
			this.sendJsonResponse(response, json.toString());
			p = null;
		}catch (Exception e) {
			log.error("分页查询物流公司出错", e);
		}
	}
	/**
	  *@说明：添加/修改物流公司页面
	  *@创建：作者:llp		创建时间：2016-2-17
	  *@修改历史：
	  *		[序号](llp	2016-2-17)<修改说明>
	 */
	@RequestMapping("tooperlogistics")
	public String tooperlogistics(Model model, Integer Id){
		if(null!=Id){
			try {
				SysLogistics logistics=this.logisticsService.queryLogisticsById(Id);
		        model.addAttribute("logistics", logistics);
		    } catch (Exception e) {
				log.error("获取物流公司出错：", e);
			}
		}
		return "/uglcw/logistics/logisticsoper";
	}
	/**
	  *@说明：添加/修改物流公司
	  *@创建：作者:llp		创建时间：2016-2-17
	  *@修改历史：
	  *		[序号](llp	2016-2-17)<修改说明>
	 */
	@RequestMapping("operlogistics")
	public void operlogistics(HttpServletResponse response, HttpServletRequest request, SysLogistics logistics){
		try {
            if(null==logistics.getId()){
				this.logisticsService.addLogistics(logistics);
				this.sendHtmlResponse(response, "1");
			}else{
				this.logisticsService.updateLogistics(logistics);
				this.sendHtmlResponse(response, "2");
			}
		} catch (Exception e) {
			log.error("添加/修改物流公司出错：", e);
		}
	}
	/**
	 * 
	  *摘要：
	  *@说明：选择物流公司
	  *@创建：作者:llp		创建时间：2016-2-17
	  *@修改历史：
	  *		[序号](llp	2016-2-17)<修改说明>
	 */
	@RequestMapping("/querychoicelogistics")
	public String querychoicelogistics(){
		return "/uglcw/logistics/choicelogistics";
	}
}
