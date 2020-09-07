package com.qweib.cloud.biz.system.controller;

import com.qweib.cloud.biz.system.service.BiaoXsddtjService;
import com.qweib.cloud.core.domain.BiaoXsddtj;
import com.qweib.cloud.core.domain.SysBforderDetail;
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
public class BiaoXsddtjControl extends GeneralControl{
	@Resource
	private BiaoXsddtjService xsddtjService;
	
	/**
	 *说明：到销售订单统计表主页
	 *@创建：作者:llp		创建时间：2016-7-7
	 *@修改历史：
	 *		[序号](llp	2016-7-7)<修改说明>
	 */
	@RequestMapping("/queryXsddtj")
	public String queryXsddtj(Model model, String dataTp){
		try {
			model.addAttribute("etime", DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd"));
			model.addAttribute("dataTp", dataTp);
		} catch (Exception e) {
			// TODO: handle exception
		}
		return "/uglcw/Biao/xsddtj";
	}
	/**
	 *说明：分页查询销售订单统计表
	 *@创建：作者:llp		创建时间：2016-7-7
	 *@修改历史：
	 *		[序号](llp	2016-7-7)<修改说明>
	 */
	@RequestMapping("/xsddtjPage")
	public void xsddtjPage(HttpServletRequest request, HttpServletResponse response, BiaoXsddtj Xsddtj, String dataTp, Integer page, Integer rows){
		try{
			SysLoginInfo info = this.getLoginInfo(request);
			if(StrUtil.isNull(Xsddtj.getStime())){
				Xsddtj.setStime(DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd"));
			}
			if(StrUtil.isNull(Xsddtj.getEtime())){
				Xsddtj.setEtime(DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd"));
			}
			Page p = this.xsddtjService.queryBiaoXsddtj(Xsddtj, info, dataTp, page, rows);
			List<BiaoXsddtj> vlist=(List<BiaoXsddtj>)p.getRows();
			Double num=0.0;
			double je=0.0;
			for (BiaoXsddtj biaoXsddtj : vlist) {
				double zje=0.0;
				List<SysBforderDetail> list=this.xsddtjService.queryOrderDetailS(info.getDatasource(), biaoXsddtj.getOrderIds());
				for(int i=0;i<list.size();i++){
					num=num+list.get(i).getWareNum();
					je=je+list.get(i).getWareZj();
					zje=zje+list.get(i).getWareZj();
				}
				biaoXsddtj.setZje(zje);
				biaoXsddtj.setList1(list);
			}
			JSONObject json = new JSONObject();
			json.put("total", p.getTotal());
			json.put("rows", p.getRows());
			List<ToolModel> toolModells = new ArrayList<ToolModel>();
			ToolModel toolModel = new ToolModel();
			toolModel.setMemberNm("合计：数量【"+p.getTolnum()+"】，金额【"+p.getTolprice()+"】");
			toolModells.add(toolModel);
			json.put("footer", toolModells);
			this.sendJsonResponse(response, json.toString());
			p = null;
		}catch (Exception e) {
			log.error("分页查询销售订单统计表出错", e);
		}
	}
}
