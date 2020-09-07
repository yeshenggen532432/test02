package com.qweib.cloud.biz.system.controller.plat;

import com.qweib.cloud.biz.common.GeneralControl;
import com.qweib.cloud.biz.system.service.plat.SysCorporationRenewService;
import com.qweib.cloud.core.domain.SysCorporationRenew;
import com.qweib.cloud.utils.Page;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@Controller
@RequestMapping("/manager")
public class SysCorporationRenewControl extends GeneralControl{
	@Resource
	private SysCorporationRenewService corporationRenewService;
	
	/**
	 * 
	  *摘要：
	  *@说明：公司续费记录主页
	  *@创建：作者:llp		创建时间：2016-7-20
	  *@修改历史：
	  *		[序号](llp	2016-7-20)<修改说明>
	 */
	@RequestMapping("/querycorporationRenew")
	public String querycorporationRenew(){
		return "/publicplat/corporation/corporationRenew";
	}

	/**
	 * 
	  *摘要：
	  *@说明：分页查询公司续费记
	  *@创建：作者:llp		创建时间：2016-7-20
	  *@修改历史：
	  *		[序号](llp	2016-7-20)<修改说明>
	 */
	@RequestMapping("/corporationRenewPage")
	public void corporationRenewPage(HttpServletRequest request, HttpServletResponse response, SysCorporationRenew corporationRenew, Integer page, Integer rows){
		try{
			Page p = this.corporationRenewService.queryCorporationRenew(corporationRenew, page, rows);
			JSONObject json = new JSONObject();
			json.put("total", p.getTotal());
			json.put("rows", p.getRows());
			this.sendJsonResponse(response, json.toString());
			p = null;
		}catch (Exception e) {
			log.error("分页查询公司续费记出错", e);
		}
	}
}
