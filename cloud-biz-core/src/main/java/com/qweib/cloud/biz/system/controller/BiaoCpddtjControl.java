package com.qweib.cloud.biz.system.controller;

import com.qweib.cloud.biz.system.service.BiaoCpddtjService;
import com.qweib.cloud.core.domain.BiaoCpddtj;
import com.qweib.cloud.core.domain.SysLoginInfo;
import com.qweib.cloud.biz.common.GeneralControl;
import com.qweib.cloud.core.domain.ToolModel;
import com.qweib.cloud.utils.DateTimeUtil;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Controller
@RequestMapping("/manager")
public class BiaoCpddtjControl extends GeneralControl{
	@Resource
	private BiaoCpddtjService cpddtjService;
	
	/**
	 *说明：到产品订单统计表主页
	 *@创建：作者:llp		创建时间：2016-7-5
	 *@修改历史：
	 *		[序号](llp	2016-7-5)<修改说明>
	 */
	@RequestMapping("/queryCpddtj")
	public String queryCpddtj(Model model, String dataTp){
		try {
			model.addAttribute("etime", DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd"));
			model.addAttribute("dataTp", dataTp);
		} catch (Exception e) {
			// TODO: handle exception
		}
		return "/uglcw/Biao/cpddtj";
	}
	/**
	 *说明：分页查询产品订单统计表
	 *@创建：作者:llp		创建时间：2016-7-5
	 *@修改历史：
	 *		[序号](llp	2016-7-5)<修改说明>
	 */
	@RequestMapping("/cpddtjPage")
	public void cpddtjPage(HttpServletRequest request, HttpServletResponse response, BiaoCpddtj Cpddtj, String dataTp, Integer page, Integer rows){
		try{
			SysLoginInfo info = this.getLoginInfo(request);
			if(StrUtil.isNull(Cpddtj.getStime())){
				Cpddtj.setStime(DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd"));
			}
			if(StrUtil.isNull(Cpddtj.getEtime())){
				Cpddtj.setEtime(DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd"));
			}
			Page p = this.cpddtjService.queryBiaoCpddtj(Cpddtj, info, dataTp, page, rows);
			JSONObject json = new JSONObject();
			json.put("total", p.getTotal());
			json.put("rows", p.getRows());
			List<ToolModel> toolModells = new ArrayList<ToolModel>();
			ToolModel toolModel = new ToolModel();
			toolModel.setWareNm("合计");
			toolModel.setNums(p.getTolnum());
			toolModel.setZjs(p.getTolprice());
			toolModells.add(toolModel);
			json.put("footer", toolModells);
			this.sendJsonResponse(response, json.toString());
			p = null;
		}catch (Exception e) {
			log.error("分页查询产品订单统计表出错", e);
		}
	}
}
