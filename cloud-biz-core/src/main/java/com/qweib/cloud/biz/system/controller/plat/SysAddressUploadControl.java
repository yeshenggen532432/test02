package com.qweib.cloud.biz.system.controller.plat;


import com.qweib.cloud.biz.system.service.plat.SysAddressUploadService;
import com.qweib.cloud.core.domain.SysAddressUpload;
import com.qweib.cloud.core.domain.SysLoginInfo;
import com.qweib.cloud.biz.common.GeneralControl;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


@Controller
@RequestMapping("/manager")
public class SysAddressUploadControl extends GeneralControl{

	@Resource
	private SysAddressUploadService addressUploadService;
	

	/**
	 *@说明：位置上传方式
	 *@创建：作者:ysg		
	 *@创建时间：2018-09-27
	 *@修改历史：
	 */
	@RequestMapping("updateAddressUpload")
	public void updateAddressUpload(SysAddressUpload model, HttpServletResponse response, HttpServletRequest request){
		SysLoginInfo info = this.getLoginInfo(request);
		int count=0;
		try {
			SysAddressUpload model2=this.addressUploadService.queryByMemId(model.getMemId(), info.getDatasource());
			if(model2==null){
				count=this.addressUploadService.add(model, info.getDatasource());
			}else{
				model2.setUpload(model.getUpload());
				model2.setMin(model.getMin());
				count=this.addressUploadService.update(model2, info.getDatasource());
			}
			if(count>0){
				this.sendHtmlResponse(response, "1");
			}else{
				this.sendHtmlResponse(response, "-1");
			}
		} catch (Exception e) {
			e.printStackTrace();
			log.error("修改位置上传出错：", e);
			this.sendHtmlResponse(response, "-1");
		}
	}
	
	
}
