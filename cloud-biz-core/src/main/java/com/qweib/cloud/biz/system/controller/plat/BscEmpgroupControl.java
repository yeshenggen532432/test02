package com.qweib.cloud.biz.system.controller.plat;

import com.qweib.cloud.biz.common.GeneralControl;
import com.qweib.cloud.biz.system.service.plat.SysEmpgroupService;
import com.qweib.cloud.core.domain.BscEmpgroup;
import com.qweib.cloud.core.domain.SysLoginInfo;
import com.qweib.cloud.utils.Page;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Map;

@Controller
@RequestMapping("manager")
public class BscEmpgroupControl extends GeneralControl {
	
	@Resource
	private SysEmpgroupService sysEmpgroupService;
	/**
	 *说明：跳转员工圈页面
	 *@创建：作者:zrp		创建时间：2015-02-03
	 *@修改历史：
	 *		[序号](zrp	2015-02-03)<修改说明>
	 */
	@RequestMapping("tobscempgroup")
	public String toBscEmpgroup(HttpServletRequest request, HttpServletResponse response,
                                Model model){
		try{
			return "companyPlat/empgroup/list";
		}catch (Exception e) {
			log.error("跳转员工圈管理页面出错：", e);
			return "";
		}
	}
	/**
	 *说明：查询员工圈管理
	 *@创建：作者:zrp		创建时间：2015-02-03
	 *@修改历史：
	 *		[序号](zrp	2015-02-03)<修改说明>
	 */
	@RequestMapping("/empgroupPage")
	public void page(HttpServletRequest request, HttpServletResponse response, BscEmpgroup empgroup, Integer page, Integer rows){
		try{
			SysLoginInfo info = this.getLoginInfo(request);
			Page p = this.sysEmpgroupService.queryForPage(empgroup, page, rows,info.getDatasource());
			JSONObject json = new JSONObject();
			json.put("total", p.getTotal());
			json.put("rows", p.getRows());
			this.sendJsonResponse(response, json.toString());
			p = null;
		}catch (Exception e) {
			log.error("分页查询成员出错", e);
		}
	}
	/**
	 * 根据ID删除
	 */
	@RequestMapping("/delempgroup")
	public void del(HttpServletResponse response, HttpServletRequest request
			, Integer[] ids){
		try {
			SysLoginInfo info = getInfo(request);
			String datasource = info.getDatasource();
			String path = getPathUpload(request);
			for(Integer id:ids){
				Map<String, Object> map = this.sysEmpgroupService.queryToPicListById(id,datasource);
				if(map.get("ids")!=null){
					String mapIds = (String)map.get("ids");
					String [] d = mapIds.split(",");
					for(String s:d){
						Map<String, Object> picMap = this.sysEmpgroupService.queryPicListById(Integer.parseInt(s),datasource);
						Object dts = picMap.get("dt");
						Object xts = picMap.get("xt");
						if(dts!=null){
							String[] dt = dts.toString().split(",");
							for(String dp:dt){
								this.delFile(path+"/"+dp);
							}
							String[] xt = xts.toString().split(",");
							for(String xp:xt){
								this.delFile(path+"/"+xp);
							}
						}
					}
				}
			}
			this.sysEmpgroupService.deleteByIds(ids,datasource);
			this.sendHtmlResponse(response, "1");
		} catch (Exception e) {
			log.error("删除附件出错：", e);
			this.sendHtmlResponse(response, "-1");
		}
	}
}
