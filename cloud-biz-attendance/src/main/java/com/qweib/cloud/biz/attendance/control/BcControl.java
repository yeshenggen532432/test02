package com.qweib.cloud.biz.attendance.control;

import com.qweib.cloud.biz.attendance.model.KqAddress;
import com.qweib.cloud.biz.attendance.model.KqBc;
import com.qweib.cloud.biz.attendance.model.KqBcTimes;
import com.qweib.cloud.biz.attendance.service.KqBcService;
import com.qweib.cloud.biz.common.GeneralControl;
import com.qweib.cloud.core.domain.SysLoginInfo;
import com.qweib.cloud.utils.Page;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.List;


@Controller
@RequestMapping("/manager/bc")
public class BcControl extends GeneralControl {
	
	@Resource
	private KqBcService bcService;
	
	@RequestMapping("/toBaseBc")
	public String toBaseBc(HttpServletRequest request, Model model, String dataTp){
		try {
			SysLoginInfo info = this.getLoginInfo(request);
			
		} catch (Exception e) {
			// TODO: handle exception
			log.error("登录错误", e);
		}
		return "/kq/base_bc";
	}
	
	@RequestMapping("/toBaseBcNew")
	public String toBaseBcNew(HttpServletRequest request, Model model, String dataTp){
		try {
			List<KqBcTimes> subList = new ArrayList<KqBcTimes>();
			KqBcTimes time = new KqBcTimes();
			time.setBcId(0);
			time.setId(0);
			time.setStartTime("09:00");
			time.setEndTime("18:00");
			subList.add(time);
			model.addAttribute("list",subList);
			model.addAttribute("detailCount",subList.size());
		} catch (Exception e) {
			// TODO: handle exception
			log.error("登录错误", e);
		}
		return "/kq/base_bc_edit";
	}
	
	@RequestMapping("/toBaseBcEdit")
	public String toBaseBcEdit(HttpServletRequest request, Model model, Integer id){
		try {
			SysLoginInfo info = this.getLoginInfo(request);
			KqBc bcRec = this.bcService.getKqBcById(id, info.getDatasource());
			List<KqBcTimes> subList = bcRec.getSubList();
			model.addAttribute("bc",bcRec);
			model.addAttribute("list",subList);
			model.addAttribute("detailCount",subList.size());
		} catch (Exception e) {
			// TODO: handle exception
			log.error("登录错误", e);
		}
		return "/kq/base_bc_edit";
	}
	
	@RequestMapping("/queryKqBcPage")
	public void queryKqBcPage(HttpServletRequest request, HttpServletResponse response, KqBc bc,
                              Integer page, Integer rows){
		if(page == null)page = 1;
		if(rows == null)rows = 9999;
		SysLoginInfo info = this.getLoginInfo(request);
		try{			
			Page p = this.bcService.queryKqBc(bc, info.getDatasource(), page, rows);
			JSONObject json = new JSONObject();
			json.put("state",true);
			json.put("total", p.getTotal());
			json.put("rows", p.getRows());
			
			this.sendJsonResponse(response, json.toString());
			p = null;
		}catch (Exception e) {
			log.error("分页查询班次出错", e);
		}
	}
	
	@RequestMapping("updateBcStatus")
	public void updateBcStatus(HttpServletResponse response, HttpServletRequest request, Integer id, Integer status){
		SysLoginInfo info = this.getLoginInfo(request);
		try
		{
			
			this.bcService.updateBcStatus(id, status, info.getDatasource());
			JSONObject json = new JSONObject();
			
			json.put("state",true);
			json.put("id", 0);
			json.put("msg", "修改状态成功");
			this.sendJsonResponse(response, json.toString());
	} catch (Exception e) {
		this.sendJsonResponse(response, "修改班次状态失败");
	}
	}
	
	@RequestMapping("deleteKqBc")
	public void deleteKqBc(HttpServletResponse response, HttpServletRequest request, String ids){
		SysLoginInfo info = this.getLoginInfo(request);
		try
		{
			String []bcIds = ids.split(",");
			for(int i = 0;i<bcIds.length;i++)
			{
				Integer id = Integer.parseInt(bcIds[i]);
				this.bcService.deleteBc(id,info.getDatasource());
			}
			JSONObject json = new JSONObject();
			
			json.put("state",true);
			json.put("id", 0);
			json.put("msg", "删除成功");
			this.sendJsonResponse(response, json.toString());
	} catch (Exception e) {
		this.sendJsonResponse(response, "删除班次失败");
	}
	}
	
	
	@RequestMapping("/saveKqBc")
	public void saveKqBc(HttpServletResponse response, HttpServletRequest request, KqBc bc) {
		try {
			  SysLoginInfo info = this.getLoginInfo(request);
			  int ret = 0;
			  if(bc.getId()!= null)
			  {
				  if(bc.getId().intValue() > 0)ret = this.bcService.updateKqBc(bc, info.getDatasource());
				  else {
				  	bc.setStatus(1);
					  ret = this.bcService.addKqBc(bc, info.getDatasource());
				  }
			  }
			  else {
			  	bc.setStatus(1);
				  ret = this.bcService.addKqBc(bc, info.getDatasource());
			  }
			  if(ret > 0)
			  this.sendHtmlResponse(response, "1");
			  else
				  this.sendHtmlResponse(response, "-1");  
		} catch (Exception e) {
			log.error("批量修改客户分布设置出错：", e);
		}
	}
	
	@RequestMapping("/queryAddressList")
	public void queryAddressList(HttpServletRequest request, HttpServletResponse response){
		
		SysLoginInfo info = this.getLoginInfo(request);
		try{			
			List<KqAddress> list = this.bcService.queryBcAddress(info.getDatasource());
			JSONObject json = new JSONObject();
			json.put("state",true);
			json.put("total", list.size());
			json.put("rows", list);
			
			this.sendJsonResponse(response, json.toString());
			
		}catch (Exception e) {
			log.error("分页查询班次出错", e);
		}
	}
	
	@RequestMapping("updateKqAddress")
	public void updateKqAddress(HttpServletResponse response, HttpServletRequest request, KqAddress bo){
		SysLoginInfo info = this.getLoginInfo(request);
		try
		{
			
			this.bcService.updateKqAddress(bo, info.getDatasource());
			JSONObject json = new JSONObject();
			
			json.put("state",true);
			json.put("id", 0);
			json.put("msg", "修改状态成功");
			this.sendJsonResponse(response, json.toString());
	} catch (Exception e) {
		this.sendJsonResponse(response, "修改班次状态失败");
	}
	}
	
	
	@RequestMapping("/toKqAddress")
	public String toKqAddress(HttpServletRequest request, Model model){
		try {
			SysLoginInfo info = this.getLoginInfo(request);
			
		} catch (Exception e) {
			// TODO: handle exception
			log.error("登录错误", e);
		}
		return "/kq/base_address";
	}

}
