package com.qweib.cloud.biz.system.controller.ws;

import com.qweib.cloud.biz.common.CnlifeConstants;
import com.qweib.cloud.biz.system.BaseWebService;
import com.qweib.cloud.biz.system.QiniuConfig;
import com.qweib.cloud.biz.system.TokenServer;
import com.qweib.cloud.biz.system.UploadFile;
import com.qweib.cloud.biz.system.jpush.JpushClassifies;
import com.qweib.cloud.biz.system.jpush.JpushClassifies2;
import com.qweib.cloud.biz.system.service.plat.SysEmpgroupService;
import com.qweib.cloud.biz.system.service.ws.*;
import com.qweib.cloud.core.domain.*;
import com.qweib.cloud.utils.DateTimeUtil;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import com.qweibframework.commons.StringUtils;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/web/")
public class BscEmpGroupWebControl extends BaseWebService {
	@Resource
	private BscEmpGroupWebService empGroupWebService;
	@Resource
	private SysMemWebService memWebService;
	@Resource
	private SysEmpgroupService sysEmpgroupService;
	@Resource
	private SysChatMsgService msgWebService;
	@Resource
	private SysTaskMsgService taskMsgService;
	@Resource
	private SysMemberWebService memberWebService;
	@Resource
	private JpushClassifies jpushClassifies;
	@Resource
	private JpushClassifies2 jpushClassifies2;

	/**
	  *@see 创建员工圈
	  *@param request
	  *@param response
	  *@param token
	  *@param empGroup
	  *@param ids  创建时添加普通成员
	  *@param mIds  创建时添加管理员
	  *@param isOpen 是否公开圈 1 是2 不是
	  *@param isTop 1 不置顶,2 置顶
	  *@param remindFlag 1 不提醒' 2 自动提醒
	  *@param leadShield 领导屏蔽 1 屏蔽 2 不屏蔽
	  *@创建：作者:YYP		创建时间：2015-1-29
	 */
	@RequestMapping("addGroup")
	public void addGroup(HttpServletRequest request, HttpServletResponse response, String token, String groupNm, String groupDesc, String ids, String isOpen,
                         String mIds, String isTop, String leadShield, String remindFlag){
		if (!checkParam(response, token,groupNm,isOpen,isTop,remindFlag,leadShield))
			return;
		try{
			OnlineMessage message = TokenServer.tokenCheck(token);
			if(message.isSuccess()==false){
				sendWarm(response, message.getMessage());
				return;
			}
			OnlineUser onlineUser = message.getOnlineMember();
			BscEmpgroup empGroup = new BscEmpgroup();
			empGroup.setGroupNm(groupNm);
			if(StrUtil.isNull(groupDesc)){
				empGroup.setGroupDesc(null);
			}else{
				empGroup.setGroupDesc(groupDesc);
			}
			//保存照片
			Map<String, Object> map = UploadFile.updatePhoto(request, response,null, "groupHead", "groupBg",onlineUser.getDatabase());
			if(null!=map){
				empGroup.setGroupHead(map.get("groupHead").toString());
			}
			empGroup.setMemberId(onlineUser.getMemId());
			empGroup.setCreatime(DateTimeUtil.getDateToStr(new Date(),"yyyy-MM-dd HH:mm:ss"));
			empGroup.setDatasource(onlineUser.getDatabase());
			empGroup.setIsOpen(isOpen);
			empGroup.setLeadShield(leadShield);//是否领导屏蔽
			BscEmpGroupMember groupMem = new BscEmpGroupMember();
			groupMem.setMemberId(onlineUser.getMemId());
			groupMem.setAddtime(DateTimeUtil.getDateToStr(new Date(),"yyyy-MM-dd HH:mm:ss"));
			groupMem.setRole("1");//群主
			groupMem.setRemindFlag(remindFlag);
			groupMem.setTopFlag(isTop);
			if("2".equals(isTop)){
				groupMem.setTopTime(new DateTimeUtil().getDateToStr(new Date(),"yyyy-MM-dd HH:mm:ss"));
			}
			empGroupWebService.addGroup(empGroup,ids,mIds,groupMem,onlineUser.getMemId(),onlineUser.getDatabase(),isOpen);
			this.sendJsonResponse(response, "{\"state\":true,\"msg\":\"创建成功\"}");
		}catch (Exception e) {
			sendException(response, e);
		}
	}
	/**
	  *@see 获取当前用户所在员工圈
	  *@param request
	  *@param response
	  *@param token
	  *@param pageNo 页码
	  *@创建：作者:YYP		创建时间：2015-1-29
	 */
	@RequestMapping("allGroup")
	public void allGroup(HttpServletRequest request, HttpServletResponse response, String token, Integer pageNo){
		if (!checkParam(response, token))
			return;
		if(StrUtil.isNull(pageNo)){
			pageNo=1;
		}
		try{
			OnlineMessage message = TokenServer.tokenCheck(token);
			if(message.isSuccess()==false){
				sendWarm(response, message.getMessage());
				return;
			}
			OnlineUser onlineUser = message.getOnlineMember();
			Page p = empGroupWebService.queryAllGroup(onlineUser.getMemId(),onlineUser.getDatabase(),pageNo,10);
			JSONObject json = new JSONObject();
			json.put("groups", p.getRows());
			json.put("total", p.getTotalPage());
			json.put("state",true);
			json.put("msg","查询成功");
			this.sendJsonResponse(response, json.toString());
		}catch (Exception e) {
			sendException(response, e);
		}
	}
	/**
	  *@see 圈资料详情
	  *@param request
	  *@param response
	  *@param token
	  *@param groupId
	  *@创建：作者:YYP		创建时间：2015-2-3
	 */
	@RequestMapping("groupDetail")
	public void groupDetail(HttpServletRequest request, HttpServletResponse response, String token, Integer groupId){
		if (!checkParam(response, token,groupId))
			return;
		try{
			OnlineMessage message = TokenServer.tokenCheck(token);
			if(message.isSuccess()==false){
				sendWarm(response, message.getMessage());
				return;
			}
			OnlineUser onlineUser = message.getOnlineMember();
			BscEmpgroupDTO empGroup = empGroupWebService.queryGroupDetail(groupId,onlineUser.getMemId(),onlineUser.getDatabase());
			JSONObject json = new JSONObject(empGroup);
			json.put("state",true);
			json.put("msg","查询成功");
			this.sendJsonResponse(response, json.toString());
		}catch (Exception e) {
			sendException(response, e);
		}
	}
	/**
	  *@see 退出圈
	  *@param request
	  *@param response
	  *@param token
	  *@param groupId
	  *@param role 1 为群主
	  *@创建：作者:YYP		创建时间：2015-2-3
	 */
	@RequestMapping("outGroup")
	public void outGroup(HttpServletRequest request, HttpServletResponse response, String token, Integer groupId, String role){
		if (!checkParam(response, token,groupId,role))
			return;
		try{
			OnlineMessage message = TokenServer.tokenCheck(token);
			if(message.isSuccess()==false){
				sendWarm(response, message.getMessage());
				return;
			}
			OnlineUser onlineUser = message.getOnlineMember();
			String database = onlineUser.getDatabase();
			int info = this.empGroupWebService.deleteGroup(groupId, onlineUser.getMemId(),database);//退出圈
			if(info>0 && "1".equals(role)){//删除员工圈图片和员工圈
				Map<String, Object> picMap = this.sysEmpgroupService.queryPicListById(groupId,database);
				//String path = request.getSession().getServletContext().getRealPath("/upload/");
				String path="";
				path = QiniuConfig.getValue("FILE_UPLOAD_URL");
				if(StrUtil.isNull(path)){
					path = request.getSession().getServletContext().getRealPath("/upload/");
				}
				if(null!=picMap.get("dt")){
					Object dts = picMap.get("dt");
					String[] dt = dts.toString().split(",");
					for(String dp:dt){
						this.delFile(path+"/"+dp);
					}
				}
				if(null!=picMap.get("xt")){
					Object xts = picMap.get("xt");
					String[] xt = xts.toString().split(",");
					for(String xp:xt){
						this.delFile(path+"/"+xp);
					}
				}
				Integer[] ids = new Integer[1];
				ids[0]= groupId;
				this.sysEmpgroupService.deleteByIds(ids,database);
			}else if(info>0 && !"1".equals(role)){
				//添加消息记录
				SysMemDTO mem = empGroupWebService.queryAdmins(groupId,database);//查找圈群主
				BscEmpgroup group = empGroupWebService.queryGroupById(groupId,database);
//				List<BscInvitation> ivMsgs = new ArrayList<BscInvitation>();
//				BscInvitation iv = new BscInvitation();
				String dateToStr = DateTimeUtil.getDateToStr(new Date(),"yyyy-MM-dd HH:mm:ss");
				SysTaskMsg taskMsg = new SysTaskMsg();
				taskMsg.setPsnId(mem.getMemberId());
				taskMsg.setMemId(onlineUser.getMemId());
				taskMsg.setContent("退出 ["+group.getGroupNm()+"] 圈");
				taskMsg.setTp("5");
				taskMsg.setNid(groupId);
				taskMsg.setRemindTime(dateToStr);
				taskMsgService.addSysTaskMsg(taskMsg, database);
				/*iv.setMemberId(onlineUser.getMemId());
				iv.setReceiveId(mem.getMemberId());
				iv.setTp("5");
				iv.setContent("退出 ["+group.getGroupNm()+"] 圈");
				iv.setBelongId(groupId);*/
//				iv.setIntime(dateToStr);
//				ivMsgs.add(iv);
				//添加未读消息记录
				SysChatMsg scm = new SysChatMsg();
				scm.setAddtime(dateToStr);
				scm.setMemberId(onlineUser.getMemId());
				scm.setReceiveId(mem.getMemberId());
				scm.setMsg("退出 ["+group.getGroupNm()+"] 圈");
				scm.setTp("23");//成员退出圈通知群主
				scm.setBelongId(groupId);//id
				msgWebService.addChatMsg(scm, database);
//				invitationService.addInvitationMsgs(ivMsgs);
//				publicMsgWebService.addpublicMsg(scm);
				//向群主或管理员推送信息
				jpushClassifies.toJpush(mem.getMemberMobile(),CnlifeConstants.MODE6, CnlifeConstants.NEWMSG, null, null, "退出圈",null);
				jpushClassifies2.toJpush(mem.getMemberMobile(),CnlifeConstants.MODE6, CnlifeConstants.NEWMSG, null, null, "退出圈",null);
			}
			sendSuccess(response, "退出圈成功");
		}catch (Exception e) {
			sendException(response, e);
		}
	}
	
	/**
	  *@see 申请加入圈（只推送）
	  *@param res
	  *@param token
	  *@param groupId
	  *@param req
	  *@创建：作者:YYP		创建时间：2015-2-4
	 */
	@RequestMapping("applyJoin")
	public void applyForGroup(HttpServletResponse res, String token, Integer groupId, HttpServletRequest req){
		if (!checkParam(res, token,groupId))
			return;
		try {
			OnlineMessage message = TokenServer.tokenCheck(token);
			if(message.isSuccess()==false){
				sendWarm(res, message.getMessage());
				return;
			}
			OnlineUser onlineUser = message.getOnlineMember();
			String datasource = onlineUser.getDatabase();
			BscEmpgroup group = empGroupWebService.queryGroupById(groupId,datasource);
			if(null==group){
				sendWarm(res, "找不到该圈");
				return;
			}
			List<SysMemDTO> memList = empGroupWebService.queryAdminsAll(groupId,"1",datasource);//查找圈主+管理员
			if(null!=memList && memList.size()!=0){
				List<SysTaskMsg> taskMsgList = new ArrayList<SysTaskMsg>();
				List<SysChatMsg> msgs = new ArrayList<SysChatMsg>();
				StringBuffer str = new StringBuffer();
				String dateToStr = DateTimeUtil.getDateToStr(new Date(),"yyyy-MM-dd HH:mm:ss");
				for (SysMemDTO sysMemDTO : memList) {
					SysTaskMsg taskMsg = new SysTaskMsg();
					taskMsg.setPsnId(sysMemDTO.getMemberId());
					taskMsg.setMemId(onlineUser.getMemId());
					taskMsg.setContent("申请加入 ["+group.getGroupNm()+"] 圈");
					taskMsg.setTp("6");
					taskMsg.setNid(groupId);
					taskMsg.setRemindTime(dateToStr);
					taskMsgList.add(taskMsg);
					
					SysChatMsg scm = new SysChatMsg();
					scm.setAddtime(dateToStr);
					scm.setMemberId(onlineUser.getMemId());
					scm.setReceiveId(sysMemDTO.getMemberId());
					scm.setMsg("申请加入 ["+group.getGroupNm()+"] 圈");
					scm.setTp("8");//申请加入员工圈类型
					scm.setBelongId(groupId);//id
					msgs.add(scm);
					str.append(sysMemDTO.getMemberMobile()+",");
				}
				taskMsgService.addSysTaskMsgs(taskMsgList, datasource);
				msgWebService.addChatMsg(msgs, datasource);
				/*//添加消息记录
				List<BscInvitation> ivMsgs = new ArrayList<BscInvitation>();
				BscInvitation iv = new BscInvitation();
				iv.setMemberId(onlineUser.getMemId());
				iv.setReceiveId(mem.getMemberId());
				iv.setTp("1");
				iv.setContent("申请加入 ["+group.getGroupNm()+"] 圈");
				iv.setBelongId(groupId);
				iv.setIntime(dateToStr);
				ivMsgs.add(iv);
				//添加未读消息记录
				SysChatMsg scm = new SysChatMsg();
				scm.setAddtime(dateToStr);
				scm.setMemberId(onlineUser.getMemId());
				scm.setReceiveId(mem.getMemberId());
				scm.setMsg("申请加入 ["+group.getGroupNm()+"] 圈");
				scm.setTp("8");//申请加入员工圈类型
				scm.setBelongId(groupId);//id
				invitationService.addInvitationMsgs(ivMsgs);
				publicMsgWebService.addpublicMsg(scm);*/
				//向群主或管理员推送信息
				jpushClassifies.toJpush(str.substring(0,str.length()-1), CnlifeConstants.MODE6, CnlifeConstants.NEWMSG, null, null, "申请加入圈",null);
				jpushClassifies2.toJpush(str.substring(0,str.length()-1), CnlifeConstants.MODE6, CnlifeConstants.NEWMSG, null, null, "申请加入圈",null);
			}
			sendSuccess(res, "已发送申请加入圈请求");
		} catch (Exception e) {
			sendException(res, e);
		}
	}
	/**
	  *@see 添加圈友列表
	  *@param request
	  *@param response
	  *@param token
	  *@param groupId 没传groupId查询所有的成员信息
	  *@param pageNo 页码
	  *@param searchContent 搜索内容
	  *@param curRole 添加的角色 1 管理员  2 普通成员
	  *@param ids 排除的成员ids 非必传
	  *@创建：作者:YYP		创建时间：2015-2-4
	 */
	@RequestMapping("memList")
	public void memList(HttpServletRequest request, HttpServletResponse response, String token, Integer groupId
			, Integer pageNo, String searchContent, String curRole, String ids){
		if (!checkParam(response, token,curRole))
			return;
		if(StrUtil.isNull(pageNo)){
			pageNo = 1;
		}
		try{
			OnlineMessage message = TokenServer.tokenCheck(token);
			if(message.isSuccess()==false){
				sendWarm(response, message.getMessage());
				return;
			}
			OnlineUser onlineUser = message.getOnlineMember();
			String datasource = onlineUser.getDatabase();
			if(null!=groupId){//验证当前角色是否有添加权限
				BscEmpGroupMember empMem = empGroupWebService.queryGroupMem(onlineUser.getMemId(),groupId,datasource);
				if("3".equals(empMem.getRole())){//普通成员
					sendWarm(response, "普通成员没有添加圈友权限");
					return;
				}else if("2".equals(empMem.getRole()) && "1".equals(curRole)){
					sendWarm(response, "超级管理员才有添加管理员权限");
					return;
				}
			}
			Page p = empGroupWebService.queryNotInMems(groupId,onlineUser.getMemId(),pageNo,CnlifeConstants.pSize,searchContent,datasource,ids);
			JSONObject json = new JSONObject();
			json.put("members", p.getRows());
			json.put("state",true);
			json.put("msg","查询成功");
			sendJsonResponse(response, json.toString());
		}catch (Exception e) {
			sendException(response, e);
		}
	}
	/*@RequestMapping("openGroupMemList")
	public void openGroupMemList(HttpServletResponse response,String token,Integer groupId){
		if (!checkParam(response, token,groupId))
			return;
		try{
			OnlineMessage message = TokenServer.tokenCheck(token);
			if(message.isSuccess()==false){
				sendWarm(response, message.getMessage());
				return;
			}
			String datasource = message.getOnlineMember().getDatabase();
			Page p = empGroupWebService.queryOpenGroupMems(groupId,datasource);
			JSONObject json = new JSONObject();
			json.put("members", p.getRows());
			json.put("state",true);
			json.put("msg","查询成功");
			sendJsonResponse(response, json.toString());
		}catch (Exception e) {
			sendException(response, e);
		}
	}*/
	/**
	  *@see 被邀请人发送通知(暂直接加入)
	  *@param request
	  *@param response
	  *@param token
	  *@param groupId
	  *@param ids
	  *@param role 被邀请加入的角色 2 管理员 3 普通会员
	  *@创建：作者:YYP		创建时间：2015-2-7
	 */
	@RequestMapping("askAddGroup")
	public void askAddGroup(HttpServletRequest request, HttpServletResponse response, String token, Integer groupId, String ids, String role){
		if (!checkParam(response, token,groupId,ids,role))
			return;
		try{
			OnlineMessage message = TokenServer.tokenCheck(token);
			if(message.isSuccess()==false){
				sendWarm(response, message.getMessage());
				return;
			}
			if("1".equals(role) || Integer.parseInt(role)>=4){
				sendWarm(response, "角色错误");
			}
			OnlineUser onlineUser = message.getOnlineMember();
			//暂时改成直接加入********
			String[] memIds = ids.split(",");
			String time = DateTimeUtil.getDateToStr(new Date(),"yyyy-MM-dd HH:mm:ss");
			empGroupWebService.addGroupMems(memIds,groupId,role,time,onlineUser.getDatabase());//批量添加
			sendSuccess(response, "添加成功");
			/*BscEmpgroup group = empGroupWebService.queryGroupById(groupId,onlineUser.getDatabase());
			List<SysMemDTO> memList = memWebService.queryMemByIds(ids,onlineUser.getDatabase());
			List<SysTaskMsg> tMsgs = new ArrayList<SysTaskMsg>();
			int i=0;
			StringBuffer str = new StringBuffer();
			for (SysMemDTO mem : memList) {
				if(!mem.getMemberId().equals(onlineUser.getMemId())){
					SysTaskMsg tm = new SysTaskMsg();
					tm.setMemId(onlineUser.getMemId());
					tm.setPsnId(mem.getMemberId());
					tm.setRecieveMobile(mem.getMemberMobile());
					tm.setTp("3");
					tm.setContent(onlineUser.getMemberNm()+"邀请您加入"+group.getGroupNm()+"圈");
					tm.setRemindTime(DateTimeUtil.getDateToStr(new Date(),"yyyy-MM-dd HH:mm:ss"));
					tm.setMsg(role);//角色
					tMsgs.add(tm);
					if (i == memList.size() - 2) {
						str.append(mem.getMemberMobile());
					} else {
						str.append(mem.getMemberMobile() + ",");
					}
					i++;
				}
			}
			taskMsgService.addTaskMsgs(tMsgs,onlineUser.getDatabase());
			Map<String,Object> param = new HashMap<String, Object>();
			param.put("role",role);
			JpushClassify.getInstance().toJpush(str.toString(), "驰用T3", onlineUser.getMemberNm()+"邀请您加入"+group.getGroupNm()+"圈", param, null, "申请加入圈",null);
			sendSuccess(response, "被邀请人发送通知");*/
		}catch (Exception e) {
			sendException(response, e);
		}
	}
	/**
	  *@see  群主同意或不同意成员加入圈
	  *@param request
	  *@param response
	  *@param token
	  *@param groupId
	  *@param memId 邀请人id
	  *@param agree -1 不同意 1 同意
	  *@创建：作者:YYP		创建时间：2015-2-4
	 */
	@RequestMapping("addGroupMem")
	public void addGroupMem(HttpServletRequest request, HttpServletResponse response, String token
			, Integer groupId, Integer memId, String agree){
		String msg = null;
		Integer jude = null;
		if (!checkParam(response, token,groupId,memId))
			return;
		try{
			OnlineMessage message = TokenServer.tokenCheck(token);
			if(message.isSuccess()==false){
				sendWarm(response, message.getMessage());
				return;
			}
			OnlineUser onlineUser = message.getOnlineMember();
			String datasource = onlineUser.getDatabase();
			BscEmpgroup group = empGroupWebService.queryGroupById(groupId,datasource);//查询圈信息
			if(null==group){
				sendWarm(response, "该圈已删除或不存在");
				return;
			}
			if("1".equals(agree)){
				Integer info = empGroupWebService.queryIsInGroup(groupId,memId,datasource);
				if(info>0){
					sendWarm(response, "该成员已经加入圈");
					return;
				}
				BscEmpGroupMember groupMem = new BscEmpGroupMember();
				groupMem.setAddtime(DateTimeUtil.getDateToStr(new Date(),"yyyy-MM-dd HH:mm:ss"));
				groupMem.setGroupId(groupId);
				groupMem.setRole("3");
				if(StrUtil.isNull(memId)){
					groupMem.setMemberId(onlineUser.getMemId());
				}else{
					groupMem.setMemberId(memId);
				}
				jude = empGroupWebService.addGroupMem(groupMem,onlineUser.getMemId(),memId,groupId,"1",agree,datasource);
				msg = onlineUser.getMemberNm()+"同意您加入 ["+group.getGroupNm()+"] 圈";
			}else{
				jude=1;
//				jude = invitationService.updateInAgree(onlineUser.getMemId(),memId,groupId,agree,"1",datasource);
				msg = onlineUser.getMemberNm()+"拒绝您加入 ["+group.getGroupNm()+"] 圈";
			}
			 //回推
		    if(null!=jude && jude>0){
		    	SysChatMsg scm=new SysChatMsg();
				scm.setAddtime(DateTimeUtil.getDateToStr(new Date(),"yyyy-MM-dd HH:mm:ss"));
				scm.setMemberId(onlineUser.getMemId());
				scm.setMsg(msg);
				scm.setReceiveId(memId);
				scm.setTp("22");
				scm.setBelongId(group.getGroupId());//圈id
				scm.setBelongNm(group.getGroupNm());//圈名
				scm.setBelongMsg(group.getGroupHead());//圈头像
				msgWebService.addChatMsg(scm, datasource);
				SysMemDTO mem = this.memberWebService.queryMemByMemId(memId);
				jpushClassifies.toJpush(mem.getMemberMobile(), CnlifeConstants.MODE6, CnlifeConstants.NEWMSG, null, null,"同意或不同意加入圈成员申请操作推送",null);
				jpushClassifies2.toJpush(mem.getMemberMobile(), CnlifeConstants.MODE6, CnlifeConstants.NEWMSG, null, null,"同意或不同意加入圈成员申请操作推送",null);
		    }
			sendSuccess(response, "同意或不同意加入圈成员申请操作成功");
		}catch (Exception e) {
			sendException(response, e);
		}
	}
	/**
	  *@see 置顶或取消置顶
	  *@param request
	  *@param response
	  *@param token
	  *@param groupId
	  *@param isTop 1 不置顶,2 置顶
	  *@创建：作者:YYP		创建时间：2015-2-4
	 */
	@RequestMapping("updateGroupTop")
	public void updateGroupTop(HttpServletRequest request, HttpServletResponse response, String token, Integer groupId, String topFlag){
		if (!checkParam(response, token,topFlag,groupId))
			return;
		try{
			OnlineMessage message = TokenServer.tokenCheck(token);
			if(message.isSuccess()==false){
				sendWarm(response, message.getMessage());
				return;
			}
			OnlineUser onlineUser = message.getOnlineMember();
			this.empGroupWebService.updateGroupTop(groupId,onlineUser.getMemId(), topFlag,onlineUser.getDatabase());
			sendSuccess(response, "设置成功");
		}catch (Exception e) {
			sendException(response, e);
		}
	}
	/**
	  *@see 员工圈免打扰设置
	  *@param request
	  *@param response
	  *@param token
	  *@param groupId
	  *@param remindFlag 1 不提醒' 2 自动提醒
	  *@创建：作者:YYP		创建时间：2015-2-8
	 */
	@RequestMapping("updateGroupRemind")
	public void updateGroupRemind(HttpServletRequest request, HttpServletResponse response, String token, Integer groupId, String remindFlag){
		if (!checkParam(response, token,groupId,remindFlag))
			return;
		try{
			OnlineMessage message = TokenServer.tokenCheck(token);
			if(message.isSuccess()==false){
				sendWarm(response, message.getMessage());
				return;
			}
			OnlineUser onlineUser = message.getOnlineMember();
			this.empGroupWebService.updateGroupRemind(groupId,onlineUser.getMemId(), remindFlag,onlineUser.getDatabase());
			sendSuccess(response, "设置成功");
		}catch (Exception e) {
			sendException(response, e);
		}
	}
	/**
	  *@see 修改屏蔽
	  *@param request
	  *@param response
	  *@param token
	  *@param groupId
	  *@param leadShield 领导屏蔽 1 屏蔽 2 不屏蔽
	  *@创建：作者:YYP		创建时间：2015-3-6
	 */
	@RequestMapping("updateShield")
	public void updateShield(HttpServletRequest request, HttpServletResponse response, String token, Integer groupId, String leadShield){
		if (!checkParam(response, token,groupId,leadShield))
			return;
		try{
			OnlineMessage message = TokenServer.tokenCheck(token);
			if(message.isSuccess()==false){
				sendWarm(response, message.getMessage());
				return;
			}
			OnlineUser onlineUser = message.getOnlineMember();
			this.empGroupWebService.updateGroupShield(groupId, leadShield,onlineUser.getMemId(),onlineUser.getDatabase());
			sendSuccess(response, "设置成功");
		}catch (Exception e) {
			sendException(response, e);
		}
	}
	/**
	  *@see 修改圈资料
	  *@param request
	  *@param response
	  *@param token
	  *@param groupId
	  *@param groupNm
	  *@param groupDesc
	  *@创建：作者:YYP		创建时间：2015-2-10
	 */
	@RequestMapping("updateGroup")
	public void updateGroup(HttpServletRequest request, HttpServletResponse response, String token, Integer groupId, String groupNm, String groupDesc){
		if (!checkParam(response, token,groupId))
			return;
		try{
			OnlineMessage message = TokenServer.tokenCheck(token);
			if(message.isSuccess()==false){
				sendWarm(response, message.getMessage());
				return;
			}
			empGroupWebService.updateGroup(groupId,groupNm,groupDesc,null,message.getOnlineMember().getDatabase());
			sendSuccess(response, "修改圈资料成功");
		}catch (Exception e) {
			sendException(response, e);
		}
	}
	/**
	  *@see 修改群头像
	  *@param request
	  *@param response
	  *@param token
	  *@param groupId
	  *@创建：作者:YYP		创建时间：2015-2-10
	 */
	@RequestMapping("updateGroupHead")
	public void uploadPhoto(HttpServletRequest request, HttpServletResponse response, Integer groupId, String token){
		if (!checkParam(response,token,groupId))
			return;
		try {
			OnlineMessage message = TokenServer.tokenCheck(token);
			if(message.isSuccess()==false){
				sendWarm(response, message.getMessage());
				return;
			}
			OnlineUser onlineUser = message.getOnlineMember();
			String datasource = onlineUser.getDatabase();
			//圈头像
			Map<String, Object> map = UploadFile.updatePhoto(request, response,null, "groupHead", "groupBg",onlineUser.getDatabase());
			if(null!=map){
				BscEmpgroup emp = empGroupWebService.queryGroupById(groupId,datasource);
				this.empGroupWebService.updateGroup(groupId,null,null,map.get("groupHead").toString(),datasource);
				String path = request.getSession().getServletContext().getRealPath("/upload");
				File file = null;
				if(StringUtils.isNotBlank(emp.getGroupHead())){
					file = new File(path+"/"+emp.getGroupHead());
					if(file.exists()){
						file.delete();
					}
				}
				sendSuccess(response, "修改头像成功");
			}
			} catch (Exception e) {
				sendException(response, e);
			}
	}
	/**
	  *@see 查询圈成员
	  *@param request
	  *@param response
	  *@param token
	  *@param groupId
	  *@创建：作者:YYP		创建时间：2015-2-11
	 */
	@RequestMapping("groupMemberList")
	public void groupMemberList(HttpServletRequest request, HttpServletResponse response, String token, Integer groupId){
		if (!checkParam(response,token,groupId))
			return;
		try{
			OnlineMessage message = TokenServer.tokenCheck(token);
			if(message.isSuccess()==false){
				sendWarm(response, message.getMessage());
				return;
			}
			List<SysMemDTO> memberList= empGroupWebService.queryGroupAllMem(groupId,message.getOnlineMember().getDatabase());
			JSONObject json = new JSONObject();
			json.put("members", memberList);
			json.put("state",true);
			json.put("msg","查询成功");
			sendJsonResponse(response, json.toString());
		}catch (Exception e) {
			sendException(response, e);
		}
	}
	/**
	  *@see 移除成员（管理员权限）
	  *@param request
	  *@param response
	  *@param token
	  *@param groupId
	  *@param memId
	  *@创建：作者:YYP		创建时间：2015-2-11
	 */
	@RequestMapping("removeGroup")
	public void removeGroup(HttpServletRequest request, HttpServletResponse response, String token, Integer groupId, Integer memId, String role){
		if (!checkParam(response,token,groupId,memId,role))
			return;
		try{
			OnlineMessage message = TokenServer.tokenCheck(token);
			if(message.isSuccess()==false){
				sendWarm(response, message.getMessage());
				return;
			}
			OnlineUser onlineUser = message.getOnlineMember();
			String datasource = onlineUser.getDatabase();
			BscEmpGroupMember groupMem = empGroupWebService.queryGroupMem(onlineUser.getMemId(), groupId,datasource);//查询当前用户角色
			if(Integer.parseInt(role)<= Integer.parseInt(groupMem.getRole())){
				sendWarm(response, "没有移除权限");
				return;
			}
			empGroupWebService.deleteGroup(groupId, memId,datasource);
			SysMemDTO member = memWebService.queryMemByMemId(memId);
			BscEmpgroup empGroup = empGroupWebService.queryGroupById(groupId,datasource);
			String content = onlineUser.getMemberNm()+":已将你退出 ["+empGroup.getGroupNm()+"] 圈";
			String dateTime = DateTimeUtil.getDateToStr(new Date(),"yyyy-MM-dd HH:mm:ss");
			//添加消息记录
			/*SysMemDTO mem = empGroupWebService.queryAdmins(groupId);//查找圈群主
			BscEmpgroup group = empGroupWebService.queryGroupById(groupId);*/
			/*List<BscInvitation> ivMsgs = new ArrayList<BscInvitation>();
			BscInvitation iv = new BscInvitation();
			iv.setMemberId(onlineUser.getMemId());
			iv.setReceiveId(member.getMemberId());
			iv.setTp("5");
			iv.setContent(content);
			iv.setBelongId(groupId);
			iv.setIntime(dateTime);
			ivMsgs.add(iv);*/
			SysTaskMsg taskMsg = new SysTaskMsg();
			taskMsg.setPsnId(member.getMemberId());
			taskMsg.setMemId(onlineUser.getMemId());
			taskMsg.setContent(content);
			taskMsg.setTp("7");
			taskMsg.setNid(groupId);
			taskMsg.setRemindTime(dateTime);
			//添加未读消息记录
			SysChatMsg scm = new SysChatMsg();
			scm.setAddtime(dateTime);
			scm.setMemberId(onlineUser.getMemId());
			scm.setReceiveId(member.getMemberId());
			scm.setMsg(content);
			scm.setTp("25");//申请加入员工圈类型
			scm.setBelongId(groupId);//id
			scm.setBelongNm(empGroup.getGroupNm());
			scm.setBelongMsg(empGroup.getGroupHead());
//			invitationService.addInvitationMsgs(ivMsgs);
//			publicMsgWebService.addpublicMsg(scm);
			taskMsgService.addSysTaskMsg(taskMsg, datasource);
			msgWebService.addChatMsg(scm, datasource);
			jpushClassifies.toJpush(member.getMemberMobile(),CnlifeConstants.MODE6, CnlifeConstants.NEWMSG,null,null, "移除圈成员", null);
			jpushClassifies2.toJpush(member.getMemberMobile(),CnlifeConstants.MODE6, CnlifeConstants.NEWMSG,null,null, "移除圈成员", null);
			sendSuccess(response, "移除成功");
		}catch (Exception e) {
			sendException(response, e);
		}
	}
	/**
	  *@see @功能查询圈成员
	  *@param request
	  *@param response
	  *@param groupId
	  *@param token
	  *@param pageNo
	  *@创建：作者:YYP		创建时间：Aug 26, 2015
	 */
	@RequestMapping("aitaMemPage")
	public void aitaMemPage(HttpServletRequest request, HttpServletResponse response, Integer groupId, String token, Integer pageNo, String search){
		if (!checkParam(response,token,groupId))
			return;
		if(null==pageNo){
			pageNo=1;
		}
		try{
			OnlineMessage message = TokenServer.tokenCheck(token);
			if(message.isSuccess()==false){
				sendWarm(response, message.getMessage());
				return;
			}
			OnlineUser onlineUser = message.getOnlineMember();
			Page p = empGroupWebService.queryAitaMemPage(onlineUser.getMemId(),groupId,onlineUser.getDatabase(),pageNo,CnlifeConstants.pSize,search);
			JSONObject json = new JSONObject();
			json.put("members", p.getRows());
			json.put("state",true);
			json.put("msg","查询成功");
			sendJsonResponse(response, json.toString());
		}catch (Exception e) {
			sendException(response, e);
		}
	}
}
