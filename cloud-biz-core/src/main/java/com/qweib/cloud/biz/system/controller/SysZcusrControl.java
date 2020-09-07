package com.qweib.cloud.biz.system.controller;

import com.qweib.cloud.biz.system.service.SysZcusrService;
import com.qweib.cloud.core.domain.SysLoginInfo;
import com.qweib.cloud.biz.common.GeneralControl;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/manager")
public class SysZcusrControl extends GeneralControl{
	@Resource
	private SysZcusrService zcusrService;
	/**
	 *摘要：
	 *@说明：查询用户树
	 *@创建：作者:llp		创建时间：2016-6-3
     *@修改历史：
	 *		[序号](llp	2016-6-3)<修改说明>
	 */
	@RequestMapping("/queryUsrForRole")
	public void queryUsrForRole(Integer id, HttpServletRequest request, HttpServletResponse response){
		SysLoginInfo loginInfo = this.getLoginInfo(request);
		try {
			List<Map<String,Object>> usrs = this.zcusrService.queryUsrForRole(id,loginInfo.getDatasource());
			StringBuilder str = new StringBuilder();
			if(null!=usrs&&usrs.size()>0){
				str.append("[");
				String sp="";
				for (Map<String, Object> map : usrs) {
					str.append(sp).append("{\"usrid\":").append(map.get("member_id"));
					str.append(",\"usrnm\":\"").append(map.get("member_nm"));
					str.append("\",\"isuse\":").append(map.get("role_use")).append("}");
					sp=",";
				}
				str.append("]");
				this.sendJsonResponse(response, str.toString());
			}
		} catch (Exception e) {
			log.error("查询用户树出错:", e);
		}
	}
	/**
	 * 
	 * 摘要：
	 * @说明：批量添加人员分配人员
	 * @创建：作者:llp 创建时间：2016-6-3
	 * @修改历史： [序号](llp 2016-6-3)<修改说明>
	 */
	@RequestMapping("/addZcUsr")
	public void addZcUsr(Integer zusrId, Integer[] cusrIds, HttpServletResponse response, HttpServletRequest request){
		SysLoginInfo loginInfo = this.getLoginInfo(request);
		try{
			this.zcusrService.addZcUsr(cusrIds, zusrId, loginInfo.getDatasource());
			this.sendHtmlResponse(response, "2");
		}catch(Exception ex){
			log.error("添加人员与用户对应表出错:"+ex);
			this.sendHtmlResponse(response, "5");
		}
	}
}
