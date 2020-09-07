package com.qweib.cloud.biz.system.controller;

import com.qweib.cloud.biz.common.GeneralControl;
import com.qweib.cloud.biz.system.service.SysBrandService;
import com.qweib.cloud.core.domain.SysLoginInfo;
import com.qweib.cloud.core.domain.SysBrand;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import net.sf.json.JSONArray;
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
public class SysBrandControl extends GeneralControl{
	@Resource
	private SysBrandService brandService;


	@RequestMapping("queryBrand")
	public String queryBrand(Model model){
		return "/uglcw/brand/brand";
	}

	@RequestMapping("toBrandPage")
	public void toBrandPage(SysBrand Brand, int page, int rows, HttpServletResponse response, HttpServletRequest request){
		try {
			SysLoginInfo info = this.getLoginInfo(request);
			Page p = this.brandService.queryBrandPage(Brand, info.getDatasource(), page, rows);
			JSONObject json = new JSONObject();
			json.put("total", p.getTotal());
			json.put("rows", p.getRows());
			this.sendJsonResponse(response, json.toString());
		} catch (Exception e) {
			log.error("分页查询品牌出错：", e);
		}
	}

	@RequestMapping("/brandList")
	public void brandList(HttpServletRequest request, HttpServletResponse response,SysBrand brand)
	{
		try{
			SysLoginInfo info = this.getLoginInfo(request);
			List<SysBrand> list = this.brandService.queryList(brand,info.getDatasource());
			JSONObject json = new JSONObject();
			json.put("total", list.size());
			json.put("list", list);
			this.sendJsonResponse(response, json.toString());

		}catch (Exception e) {
			log.error("查询品牌列表错误", e);
		}
	}

	@RequestMapping("operBrand")
	public void operBrand(SysBrand Brand, HttpServletResponse response, HttpServletRequest request){
		try {
			SysLoginInfo info = this.getLoginInfo(request);
			if(!StrUtil.isNull(Brand)){
				if(null!=Brand.getId()&&Brand.getId()>0){
					this.brandService.updateBrand(Brand, info.getDatasource());
					this.sendHtmlResponse(response, "2");
				}else{
					this.brandService.addBrand(Brand, info.getDatasource());
					this.sendHtmlResponse(response, "1");
				}
			  }
		} catch (Exception e) {
			log.error("操作品牌出错：", e);
			this.sendHtmlResponse(response, "-1");
		}
	}

	@RequestMapping("getBrand")
	public void getBrand(Integer id, HttpServletResponse response, HttpServletRequest request){
		try {
			SysLoginInfo info = this.getLoginInfo(request);
			SysBrand Brand=this.brandService.queryBrandById(id, info.getDatasource());
			JSONObject json = new JSONObject(Brand);
			this.sendJsonResponse(response, json.toString());
		} catch (Exception e) {
			log.error("获取品牌出错：", e);
		}
	}

	@RequestMapping("deleteBrandById")
	public void deleteBrandById(Integer id, HttpServletResponse response, HttpServletRequest request){
		try {
			SysLoginInfo info = this.getLoginInfo(request);
			this.brandService.deleteBrandById(id, info.getDatasource());
			this.sendHtmlResponse(response, "1");
		} catch (Exception e) {
			log.error("操作品牌出错：", e);
			this.sendHtmlResponse(response, "-1");
		}
	}
	
}
