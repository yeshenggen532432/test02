package com.qweib.cloud.biz.system.controller.plat;

import com.qweib.cloud.biz.common.GeneralControl;

//@Controller
//@RequestMapping("/manager")
public class SysDeptmempowerControl extends GeneralControl  {
//	@Resource
//	private SysDeptmempowerService deptmempowerService;
//
//	/**
//	 * 查询角色菜单应用树
//	 * @param response
//	 * @param request
//	 * @param roleId
//	 * @param tp
//	 */
//	@RequestMapping("deptpowertree")
//	public void deptpowertree(HttpServletResponse response, HttpServletRequest request, Integer deptId, String tp){
//		try{
//			SysLoginInfo info = getInfo(request);
//			List<SysUsrVO> deptPower = this.deptmempowerService.queryMempowerForDept(deptId, tp, info.getDatasource());
//			JSONArray json = new JSONArray(deptPower);
//			this.sendJsonResponse(response, json.toString());
//			deptPower=null;
//		}catch(Exception ex){
//			log.error("查询部门权限树出错:"+ex);
//		}
//	}
//	/**
//	 * 保存部门成员权限关系
//	 * @param response
//	 * @param request
//	 * @param deptId
//	 * @param usrid
//	 */
//	@RequestMapping("saveDeptPower")
//	public void saveDeptPower(HttpServletResponse response, HttpServletRequest request, Integer deptId, Long[] usrid, String powertp){
//		try{
//			SysLoginInfo info = getInfo(request);
//			this.deptmempowerService.updateDeptmempower(usrid, deptId, powertp, info.getDatasource());
//			this.sendHtmlResponse(response, "2");
//		}catch(Exception ex){
//			log.error("保存部门成员权限关系出错:"+ex);
//			this.sendHtmlResponse(response, "5");
//		}
//	}
}
