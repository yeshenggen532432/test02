package com.qweib.cloud.biz.system.controller.plat;

import com.qweib.cloud.biz.common.GeneralControl;
import com.qweib.cloud.biz.system.service.plat.BscPhWallService;
import com.qweib.cloud.core.domain.BscPhotoWall;
import com.qweib.cloud.core.domain.BscPhotoWallPic;
import com.qweib.cloud.core.domain.SysLoginInfo;
import com.qweib.cloud.utils.Page;
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
public class BscPhotoWallsControl extends GeneralControl {
	@Resource
	private BscPhWallService phWallService;

	/**
	  *摘要：到照片墙管理页面
	  *@说明：
	  *@创建：作者:YYP		创建时间：2014-4-23
	  *@param @param request
	  *@param @param model
	  *@param @return 
	  *@修改历史：
	  *		[序号](YYP	2014-4-23)<修改说明>
	 */
	@RequestMapping("/queryPhotoWall")
	public String queryPhotoWall(HttpServletRequest request, Model model){
		return "/companyPlat/photoWall/photoWall";
	}
	/**
	  *摘要：查询照片墙
	  *@说明：
	  *@创建：作者:YYP		创建时间：2014-4-23
	  *@param @param request
	  *@param @param phWall
	  *@param @param page
	  *@param @param rows 
	  *@修改历史：
	  *		[序号](YYP	2014-4-23)<修改说明>
	 */
	@RequestMapping("/photoWallPage")
	public void queryPhWall(HttpServletRequest request, HttpServletResponse response, BscPhotoWall phWall, Integer page, Integer rows){
		try{
			SysLoginInfo info = getLoginInfo(request);
			Page p = this.phWallService.queryPhWall(phWall,page,rows,info);
			JSONObject json = new JSONObject();
			json.put("total", p.getTotal());
			json.put("rows", p.getRows());
			this.sendJsonResponse(response, json.toString());
		}catch (Exception e) {
			log.error("查询照片墙失败", e);
		}
	}
	/**
	  *摘要：到查看删除照片图片页面
	  *@说明：
	  *@创建：作者:YYP		创建时间：2014-4-23
	  *@param @param request
	  *@param @param model
	  *@param @param wallId
	  *@param @return 
	  *@修改历史：
	  *		[序号](YYP	2014-4-23)<修改说明>
	 */
	@RequestMapping("/toPicPage")
	public String toOperPic(HttpServletRequest request, Model model, long wallId){
		try{
			SysLoginInfo info = getLoginInfo(request);
			List<BscPhotoWallPic> bPicList = this.phWallService.queryphWallPic(wallId,info.getDatasource());//根据id查找对应照片墙图片
			model.addAttribute("bPicList", bPicList);
		}catch (Exception e) {
			log.error("到查看删除照片墙图片页面失败", e);
		}
		return "/companyPlat/photoWall/operPicPage";
	}
	/**
	  *摘要：删除图片
	  *@说明：
	  *@创建：作者:YYP		创建时间：2014-4-23
	  *@param @param response 
	  *@修改历史：
	  *		[序号](YYP	2014-4-23)<修改说明>
	 */
	@RequestMapping("/delPic")
	public void delPic(HttpServletRequest request, HttpServletResponse response, long id){
		try{
			SysLoginInfo info = getLoginInfo(request);
			long m = this.phWallService.deletePic(id,info.getDatasource());
			if(m<1){
				this.sendHtmlResponse(response, "6");
			}else{
				this.sendHtmlResponse(response, "3");
			}
		}catch (Exception e) {
			log.error("删除照片墙图片失败", e);
			this.sendHtmlResponse(response, "6");
		}
	}
	/**
	  *摘要：照片墙置顶
	  *@说明：
	  *@创建：作者:YYP		创建时间：2014-6-10
	  *@param @param request
	  *@param @param response
	  *@param @param wallId 
	  *@修改历史：
	  *		[序号](YYP	2014-6-10)<修改说明>
	 */
	@RequestMapping("/PhotoWallToTop")
	public void photoWallToTop(HttpServletRequest request, HttpServletResponse response, Integer wallId){
		try{
			SysLoginInfo info = getLoginInfo(request);
			this.phWallService.updatePhotoWallToTop(wallId,info.getDatasource());
			this.sendHtmlResponse(response, "1");
		}catch (Exception e) {
			log.error("照片墙置顶失败", e);
			this.sendHtmlResponse(response, "-1");
		}
	}
}
