package com.qweib.cloud.biz.system.controller.plat;

import com.qweib.cloud.biz.system.service.plat.BscTrueService;
import com.qweib.cloud.biz.system.service.plat.SysMemService;
import com.qweib.cloud.core.domain.BscTrue;
import com.qweib.cloud.core.domain.SysLoginInfo;
import com.qweib.cloud.biz.common.GeneralControl;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.text.SimpleDateFormat;
import java.util.Date;

@Controller
@RequestMapping("manager")
public class BscTrueControl extends GeneralControl {
	@Resource
	private BscTrueService bscTrueService;
	@Resource
	private SysMemService sysMemService;
	/**
	 * 真心话页面
	 */
	@RequestMapping("totrue")
	public String totrue(HttpServletRequest request, HttpServletResponse response, Model model){
		SysLoginInfo info = getInfo(request);
//		List<SysMember> mem = this.sysMemService.mName(info.getDatasource());
//		model.addAttribute("mem", mem);
		return "/publicplat/trues/trues";
	}
	/**
	 * 真心话分页查询
	 */
	@RequestMapping("truePage")
	public void page(HttpServletRequest request, HttpServletResponse response, BscTrue bsctrue, Integer page, Integer rows){
		try {
			SysLoginInfo info = getInfo(request);
			Page p = this.bscTrueService.page(bsctrue, page, rows,info.getDatasource());
			JSONObject json = new JSONObject();
			json.put("total", p.getTotal());
			json.put("rows", p.getRows());
			this.sendJsonResponse(response, json.toString());
			p=null;
		} catch (Exception e) {
			log.error("真心话数据查询出错:", e);
		}
	}
	/**
	 * 到(添加/修改)页面
	 */
	@RequestMapping("toOperTrue")
	public String toOperNotice(HttpServletRequest request, HttpServletResponse response, Model model, Integer id){
		if(!StrUtil.isNull(id)){
			SysLoginInfo info = getInfo(request);
			BscTrue bsctrue = this.bscTrueService.queryTrueById(id,info.getDatasource());
			model.addAttribute("bsctrue", bsctrue);
		}
		return "/publicplat/trues/truesoper";
	}
	/**
	 * 添加、修改
	 */
	@RequestMapping("operTrue")
	public void operNotice(BscTrue bsctrue, HttpServletResponse response, HttpServletRequest request){
		try {
			SysLoginInfo info = getInfo(request);
			if(StrUtil.isNull(bsctrue.getTrueId())){//添加
				bsctrue.setMemberId(info.getIdKey());
				bsctrue.setTrueTime(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()));
				bsctrue.setTrueCount(0);
				this.bscTrueService.addTrue(bsctrue,info.getDatasource());
				this.sendHtmlResponse(response, "1");
			}else{//修改
				this.bscTrueService.updateTrue(bsctrue,info.getDatasource());					
				this.sendHtmlResponse(response, "2");
			}
		} catch (Exception e) {
			log.error("操作失败", e);
			this.sendHtmlResponse(response, "-1");
		}
	}
	/**
	 * 详情
	 */
	@RequestMapping("detailTrue")
	public String detailNotice(HttpServletRequest request, Model model, Integer id){
		try {
			SysLoginInfo info = getInfo(request);
			BscTrue bsctrue = this.bscTrueService.queryTrueById(id,info.getDatasource());
			model.addAttribute("bsctrue", bsctrue);
		} catch (Exception e) {
			log.error("查看失败", e);
		}
		return "/publicplat/trues/truesdetail";
	}
	/**
	 * 批量删除
	 */
	@RequestMapping("delTrue")
	public void deletenotice(HttpServletRequest request, HttpServletResponse response, Integer[] ids){
		try{
			SysLoginInfo info = getInfo(request);
			int[] result= this.bscTrueService.deletetrue(ids,info.getDatasource());
			this.sendHtmlResponse(response, "1");
		} catch (Exception e) {
			log.error("删除公告记录出错：", e);
			this.sendHtmlResponse(response, "-1");
		}
	}
}
