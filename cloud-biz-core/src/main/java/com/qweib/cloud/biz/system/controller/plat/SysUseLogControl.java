package com.qweib.cloud.biz.system.controller.plat;

import com.qweib.cloud.biz.common.GeneralControl;
import com.qweib.cloud.biz.system.service.plat.SysUseLogService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;

@Controller
@RequestMapping("/manager")
public class SysUseLogControl extends GeneralControl {
    @Resource
    private SysUseLogService useLogService;

//	@RequestMapping("/querysysuselog")
//	public String querysysuselog(Model model){
//		Calendar calendar = Calendar.getInstance();
//		Integer year = calendar.get(Calendar.YEAR);
//		Integer month = calendar.get(Calendar.MONTH);
//		Date startDate = DateTimeUtil.getDateTime(year, month, 1);
//		try {
//			model.addAttribute("sdate", DateTimeUtil.getDateToStr(startDate, "yyyy-MM-dd"));
//			model.addAttribute("edate", DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd"));
//		} catch (Exception e) {
//			log.error("分页查询访问日志出错", e);
//		}
//		return "/publicplat/sysuselog/sys_company_use_log";
//	}
//	
//	@RequestMapping("/querymembersysuselog")
//	public String querymembersysuselog(Model model,HttpServletRequest request){
//		try {
//			String sdate = request.getParameter("sdate");
//			String edate = request.getParameter("edate");
//			String fdCompanyNm = request.getParameter("fdCompanyNm");
//			String fdMemberNm = request.getParameter("fdMemberNm");
//			model.addAttribute("sdate", sdate);
//			model.addAttribute("edate", edate);
//			model.addAttribute("fdCompanyNm", fdCompanyNm);
//			model.addAttribute("fdMemberNm", fdMemberNm);
//		} catch (Exception e) {
//			log.error("分页查询访问日志出错", e);
//		}
//		return "/publicplat/sysuselog/sys_member_use_log";
//	}
//	@RequestMapping("/sysMemberUseLogPage")
//	public void sysMemberUseLogPage(HttpServletRequest request,HttpServletResponse response,SysUseLog uselog,Integer page,Integer rows){
//		try{
//			
//			String tmpstr = uselog.getEdate();
//			Date tmpDate = DateTimeUtil.getStrToDate(tmpstr,"yyyy-MM-dd");
//			tmpDate = DateTimeUtil.dateTimeAdd(tmpDate, 5, 1);//增加一天
//			tmpstr = DateTimeUtil.getDateToStr(tmpDate, "yyyy-MM-dd");
//			uselog.setEdate(tmpstr);
//			
//			Page p = this.useLogService.queryMemberUseLog(uselog, page, rows);
//			JSONObject json = new JSONObject();
//			json.put("total", p.getTotal());
//			json.put("rows", p.getRows());
//			this.sendJsonResponse(response, json.toString());
//			p = null;
//		}catch (Exception e) {
//			log.error("分页查询访问日志出错", e);
//		}
//	}
//	
//	@RequestMapping("/querysysuselogdetail")
//	public String querysysuselogdetail(Model model,HttpServletRequest request){
//		try {
//			String sdate = request.getParameter("sdate");
//			String edate = request.getParameter("edate");
//			String fdCompanyNm = request.getParameter("fdCompanyNm");
//			String fdMemberNm = request.getParameter("fdMemberNm");
//			model.addAttribute("sdate", sdate);
//			model.addAttribute("edate", edate);
//			model.addAttribute("fdCompanyNm", fdCompanyNm);
//			model.addAttribute("fdMemberNm", fdMemberNm);
//		} catch (Exception e) {
//			log.error("分页查询访问日志出错", e);
//		}
//		return "/publicplat/sysuselog/sys_use_log";
//	}
//	@RequestMapping("/sysUseLogPage")
//	public void sysUseLogPage(HttpServletRequest request,HttpServletResponse response,SysUseLog uselog,Integer page,Integer rows){
//		try{
//			
//			String tmpstr = uselog.getEdate();
//			Date tmpDate = DateTimeUtil.getStrToDate(tmpstr,"yyyy-MM-dd");
//			tmpDate = DateTimeUtil.dateTimeAdd(tmpDate, 5, 1);//增加一天
//			tmpstr = DateTimeUtil.getDateToStr(tmpDate, "yyyy-MM-dd");
//			uselog.setEdate(tmpstr);
//			
//			Page p = this.useLogService.queryUseLog(uselog, page, rows);
//			JSONObject json = new JSONObject();
//			json.put("total", p.getTotal());
//			json.put("rows", p.getRows());
//			this.sendJsonResponse(response, json.toString());
//			p = null;
//		}catch (Exception e) {
//			log.error("分页查询访问日志出错", e);
//		}
//	}
//
//	@RequestMapping("/sysCompanyUseLogPage")
//	public void sysCompanyUseLogPage(HttpServletRequest request,HttpServletResponse response,SysUseLog uselog,Integer page,Integer rows){
//		try{
//			
//			String tmpstr = uselog.getEdate();
//			Date tmpDate = DateTimeUtil.getStrToDate(tmpstr,"yyyy-MM-dd");
//			tmpDate = DateTimeUtil.dateTimeAdd(tmpDate, 5, 1);//增加一天
//			tmpstr = DateTimeUtil.getDateToStr(tmpDate, "yyyy-MM-dd");
//			uselog.setEdate(tmpstr);
//			
//			Page p = this.useLogService.queryCompanyUseLog(uselog, page, rows);
//			JSONObject json = new JSONObject();
//			json.put("total", p.getTotal());
//			json.put("rows", p.getRows());
//			this.sendJsonResponse(response, json.toString());
//			p = null;
//		}catch (Exception e) {
//			e.printStackTrace();
//			log.error("分页查询访问日志出错", e);
//		}
//	}
//	
//	@RequestMapping("addUseLog")
//	public void addUseLog(HttpServletResponse response,HttpServletRequest request,SysUseLog uselog){
//		try{
//			String endDate=DateTimeUtil.dateTimeAddToStr(DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd"), 2, 1, "yyyy-MM-dd");
//			int i = useLogService.addUseLog(uselog);
//			this.sendHtmlResponse(response, "-1");
//		}catch (Exception e) {
//			log.error("添加访问日志出错", e);
//			this.sendHtmlResponse(response, "-1");
//		}
//	}


}
