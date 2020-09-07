package com.qweib.cloud.biz.system.controller;

import com.qweib.cloud.biz.system.service.SysPrintRecordService;
import com.qweib.cloud.core.domain.SysLoginInfo;

import com.qweib.cloud.biz.common.GeneralControl;
import com.qweib.cloud.core.domain.SysPrintRecord;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Date;
import java.util.List;

@Controller
@RequestMapping("/manager/sysPrintRecord")
public class SysPrintRecordControl extends GeneralControl{
	@Resource
	private SysPrintRecordService printRecordService;
	
	@RequestMapping("toPrintRecordList")
	public void toPrintRecordList(SysPrintRecord printRecord, HttpServletResponse response, HttpServletRequest request){
		try {
			SysLoginInfo info = this.getLoginInfo(request);
			List<SysPrintRecord> list = this.printRecordService.queryList(printRecord,info.getDatasource());
			JSONObject json = new JSONObject();
			json.put("total", list.size());
			json.put("rows", list);
			this.sendJsonResponse(response, json.toString());
		} catch (Exception e) {
			log.error("查询打印记录出错：", e);
		}
	}
	
	@RequestMapping("toPrintRecordPage")
	public void toPrintRecordPage(SysPrintRecord printRecord, int page, int rows, HttpServletResponse response, HttpServletRequest request){
		try {
			SysLoginInfo info = this.getLoginInfo(request);
			Page p = this.printRecordService.queryPrintRecordPage(printRecord, page, rows,info.getDatasource());
			JSONObject json = new JSONObject();
			json.put("total", p.getTotal());
			json.put("rows", p.getRows());
			this.sendJsonResponse(response, json.toString());
		} catch (Exception e) {
			log.error("查询打印记录出错：", e);
		}
	}
	
	@RequestMapping("addPrintRecord")
	public void addPrintRecord(SysPrintRecord printRecord, HttpServletResponse response, HttpServletRequest request){
		JSONObject json = new JSONObject();
		try {
			json.put("state", false);//默认保存失败
			SysLoginInfo info = this.getLoginInfo(request);
			if(!StrUtil.isNull(printRecord)){
				printRecord.setCreateId(info.getIdKey());
				printRecord.setCreateName(info.getUsrNm());
				printRecord.setCreateTime(new Date());
				this.printRecordService.addPrintRecord(printRecord,info.getDatasource());
				json.put("state", true);
				json.put("id", printRecord.getId());
				this.sendJsonResponse(response, json.toString());
			  }
		} catch (Exception e) {
			log.error("操作打印记录出错：", e);
			this.sendJsonResponse(response, json.toString());
		}
	}
	
	@RequestMapping("addPrintRecordBatch")
	public void addPrintRecordBatch(HttpServletResponse response, HttpServletRequest request){
		JSONObject json = new JSONObject();
		try {
			json.put("state", false);//默认保存失败
			SysLoginInfo info = this.getLoginInfo(request);
			String billIds = request.getParameter("fdSourceId");
			String voucherNos = request.getParameter("fdSourceNo");
			String fdModel = request.getParameter("fdModel");
			if(!StrUtil.isNull(billIds)){
				String ids[] = billIds.split(",");
				String nos[] = voucherNos.split(",");
				for(int i=0;i<ids.length;i++){
					SysPrintRecord printRecord = new SysPrintRecord();
					printRecord.setCreateId(info.getIdKey());
					printRecord.setCreateName(info.getUsrNm());
					printRecord.setCreateTime(new Date());
					printRecord.setFdModel(fdModel);
					printRecord.setFdSourceId(Integer.valueOf(ids[i]));
					printRecord.setFdSourceNo(nos[i]);
					this.printRecordService.addPrintRecord(printRecord,info.getDatasource());
				}
				json.put("state", true);
				this.sendJsonResponse(response, json.toString());
			  }
		} catch (Exception e) {
			e.printStackTrace();
			log.error("操作打印记录出错：", e);
			this.sendJsonResponse(response, json.toString());
		}
	}

	@RequestMapping("getPrintRecord")
	public void getPrintRecord(Integer id, HttpServletResponse response, HttpServletRequest request){
		try {
			SysLoginInfo info = this.getLoginInfo(request);
			SysPrintRecord printRecord=this.printRecordService.queryPrintRecordById(id, info.getDatasource());
			JSONObject json = new JSONObject(printRecord);
			this.sendJsonResponse(response, json.toString());
		} catch (Exception e) {
			log.error("获取系统参数出错：", e);
		}
	}
	@RequestMapping("queryPrintCount")
	public void queryPrintCount(SysPrintRecord printRecord, HttpServletResponse response, HttpServletRequest request){
		try {
			SysLoginInfo info = this.getLoginInfo(request);
			Integer count=this.printRecordService.queryPrintCount(printRecord, info.getDatasource());
			JSONObject json = new JSONObject();
			if(StrUtil.isNull(count)){
				count = 0;
			}
			json.put("count", count);
			json.put("id", printRecord.getFdSourceId());
			this.sendJsonResponse(response, json.toString());
		} catch (Exception e) {
			log.error("获取系统参数出错：", e);
		}
	}

	@RequestMapping("queryPrintCountList")
	public void queryPrintCountList(SysPrintRecord printRecord, HttpServletResponse response, HttpServletRequest request){
		try {
			SysLoginInfo info = this.getLoginInfo(request);
			List list=this.printRecordService.queryPrintCountList(printRecord, info.getDatasource());
			JSONObject json = new JSONObject();
			json.put("state", true);
			json.put("rows", list);
			this.sendJsonResponse(response, json.toString());
		} catch (Exception e) {
			e.printStackTrace();
			log.error("获取系统参数出错：", e);
		}
	}

	@RequestMapping("deletePrintRecordById")
	public void deletePrintRecordById(Integer id, HttpServletResponse response, HttpServletRequest request){
		try {
			SysLoginInfo info = this.getLoginInfo(request);
			this.printRecordService.deletePrintRecord(id, info.getDatasource());
			this.sendHtmlResponse(response, "1");
		} catch (Exception e) {
			log.error("操作打印记录出错：", e);
			this.sendHtmlResponse(response, "-1");
		}
	}
	
}
