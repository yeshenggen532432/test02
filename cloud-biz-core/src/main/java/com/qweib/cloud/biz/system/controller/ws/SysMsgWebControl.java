package com.qweib.cloud.biz.system.controller.ws;

import com.qweib.cloud.biz.common.CnlifeConstants;
import com.qweib.cloud.biz.system.UploadFile;
import com.qweib.cloud.biz.system.BaseWebService;
import com.qweib.cloud.biz.system.TokenServer;
import com.qweib.cloud.biz.system.jpush.JpushClassifies;
import com.qweib.cloud.biz.system.jpush.JpushClassifies2;
import com.qweib.cloud.biz.system.service.ws.*;
import com.qweib.cloud.core.domain.*;

import com.qweib.cloud.utils.DateTimeUtil;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.List;

@Controller
@RequestMapping("/web/")
public class SysMsgWebControl extends BaseWebService {
	@Resource
	private SysChatMsgService sysChatMsgWebService;
	@Resource
	private BscMsgWebService bscMsgWebService;
	@Resource
	private SysMemWebService memWebService;
	@Resource
	private SysDepartService departService;
	@Resource
	private BscEmpGroupWebService empGroupWebService;
	@Resource
	private JpushClassifies jpushClassifies;
	@Resource
	private JpushClassifies2 jpushClassifies2;
	
	
	/**
	  *@see 获取聊天记录
	  *@param request
	  *@param response
	  *@param token
	  *@param pId tp 为2 部门id tp=3 不传
	  *@param tp  2 部门 3 真心话
	  *@param id  上一页最后一条消息的id
	  *@创建：作者:YYP		创建时间：2015-2-12
	 */
	@RequestMapping("getOldMsg")
	public void getRoomMsg(HttpServletRequest request, HttpServletResponse response, String token, String tp, Integer pId, Integer id){
		if (!checkParam(response, token,tp))
			return;
		try{
			OnlineMessage message = TokenServer.tokenCheck(token);
			if(message.isSuccess()==false){
				sendWarm(response, message.getMessage());
				return;
			}
			OnlineUser onlineUser = message.getOnlineMember();
			List msgList = new ArrayList();
			msgList = bscMsgWebService.queryNextMsg(pId,id,tp,onlineUser.getDatabase());//20条
			Collections.reverse(msgList);
			JSONObject json = new JSONObject();
			json.put("msgList", msgList);
			json.put("state",true);
			json.put("msg","查询成功");
			this.sendJsonResponse(response, json.toString());
		}catch (Exception e) {
			log.error("下拉获取聊天信息失败", e);
			this.sendJsonResponse(response, "{\"state\":-1}");
			return;
		}
	}
	/**
	  *@see 查询是否部门下成员
	  *@param request
	  *@param response
	  *@param token
	  *@param deptId
	  *@创建：作者:YYP		创建时间：2015-3-25
	 */
	@RequestMapping("isDeptMem")
	public void isDeptMem(HttpServletRequest request, HttpServletResponse response, String token, Integer deptId){
		if (!checkParam(response, token,deptId))
			return;
		try{
			OnlineMessage message = TokenServer.tokenCheck(token);
			if(message.isSuccess()==false){
				sendWarm(response, message.getMessage());
				return;
			}
			OnlineUser onlineUser = message.getOnlineMember();
			// 查询该部门
			SysDepart depart = departService.queryDepartByid(deptId,onlineUser.getDatabase());
			//查询成员是否在部门下
			Integer info = departService.queryIsIndept(onlineUser.getMemId(),depart.getBranchPath(),onlineUser.getDatabase());
			JSONObject json = new JSONObject();
			json.put("info",info);//0 1
			json.put("state",true);
			json.put("msg","查询成功");
			sendJsonResponse(response, json.toString());
		}catch (Exception e) {
			sendException(response, e);
		}
	}
	/** 部门聊天(暂时屏蔽)
	  *@param response
	  *@param request
	  *@param token
	  *@param deptId
	  *@param content
	  *@param contentType 内容类型 1.文字2.图片3.语音
	  *@param voiceTime
	  *@创建：作者:YYP		创建时间：2015-3-10
	 */
	@RequestMapping("saveDeptMsg")
	@Deprecated
	public void saveDeptMsg(HttpServletResponse response, HttpServletRequest request, String token, Integer deptId,
                            String content, String contentType, Integer voiceTime, Double longitude, Double latitude){
		if (!checkParam(response, token,deptId,contentType))
			return;
		try{
			OnlineMessage message = TokenServer.tokenCheck(token);
			if(message.isSuccess()==false){
				sendWarm(response, message.getMessage());
				return;
			}
			OnlineUser onlineUser = message.getOnlineMember();
			// 查询该部门
			SysDepart depart = departService.queryDepartByid(deptId,onlineUser.getDatabase());
			// 群聊天信息
			BscDeptMsg deptMsg = new BscDeptMsg();
			String httpUrl;
			if ("2".equals(contentType) || "3".equals(contentType)) {
				httpUrl = UploadFile.savePhotoOrVoice(request, response,onlineUser.getDatabase());
				content = httpUrl;
			}
			deptMsg.setMemberId(onlineUser.getMemId());
			deptMsg.setMsgTp(contentType);
			deptMsg.setMsg(content);
			deptMsg.setDeptId(deptId);
			if (contentType.equals("3")) {
				deptMsg.setVoiceTime(voiceTime);
			}
			deptMsg.setLongitude(longitude);
			deptMsg.setLatitude(latitude);
			deptMsg.setAddtime(DateTimeUtil.getDateToStr(new Date(),"yyyy-MM-dd HH:mm:ss"));
			int result = this.bscMsgWebService.addDeptMsg(deptMsg,onlineUser.getDatabase());
			// 保存成功推送
			if(result>0){
				List<SysMemDTO> memList = memWebService.queryDeptMids(depart.getBranchPath(),onlineUser.getDatabase());
				String remind = setChatMsg(request, deptId,depart.getBranchName(),"14", content, contentType,
						onlineUser, memList,result,longitude,latitude);
				jpushClassifies.toJpush(remind, CnlifeConstants.MODE1, CnlifeConstants.NEWMSG, null, null, "部门聊天",null);//不屏蔽
				jpushClassifies2.toJpush(remind,CnlifeConstants.MODE1, CnlifeConstants.NEWMSG, null, null, "部门聊天",null);//不屏蔽
				this.sendJsonResponse(response, "{\"state\":true,\"msg\":\"添加部门聊天信息成功\",\"msgId\":"+result+"}");
			}
		}catch (Exception e) {
			sendException(response, e);
		}
	}

	/**
	  *@see 真心话聊天
	  *@param request
	  *@param response
	  *@param token
	  *@param trueId
	  *@param content
	  *@param contentType
	  *@param voiceTime
	  *@创建：作者:YYP		创建时间：2015-3-17
	 */
	@RequestMapping("trueMsg")
	public void trueMsg(HttpServletRequest request, HttpServletResponse response, String token,
                        String content, String contentType, Integer voiceTime, Double longitude, Double latitude){
		if(!checkParam(response))
			return;
		try{
			OnlineMessage message = TokenServer.tokenCheck(token);
			if(message.isSuccess()==false){
				sendWarm(response, message.getMessage());
				return;
			}
			OnlineUser onlineUser = message.getOnlineMember();
//			BscTrue t = trueWebSerivce.queryTrueByTid(trueId,onlineUser.getDatabase());
			// 群聊天信息
			BscTrueMsg trueMsg = new BscTrueMsg();
			String httpUrl;
			if ("2".equals(contentType) || "3".equals(contentType)) {
				httpUrl = UploadFile.savePhotoOrVoice(request, response,onlineUser.getDatabase());
				content = httpUrl;
			}
			trueMsg.setMemberId(onlineUser.getMemId());
			trueMsg.setMsgTp(contentType);
			trueMsg.setMsg(content);
//			trueMsg.setTrueId(trueId);
			if (contentType.equals("3")) {
				trueMsg.setVoiceTime(voiceTime);
			}
			trueMsg.setLongitude(longitude);
			trueMsg.setLatitude(latitude);
			trueMsg.setAddtime(DateTimeUtil.getDateToStr(new Date(),"yyyy-MM-dd HH:mm:ss"));
			int result = this.bscMsgWebService.addTrueMsg(trueMsg,onlineUser.getDatabase());
			// 保存成功推送
			if(result>0){
				List<SysMemDTO> memList = memWebService.queryCompanyMids(onlineUser.getDatabase());//查询公司下成员
				String remind = setChatMsg(request,null,null,"17", content, contentType,
						onlineUser, memList,result,longitude,latitude);
				if(null!=remind && !"".equals(remind)){
					jpushClassifies.toJpush(remind, CnlifeConstants.MODE4, CnlifeConstants.NEWMSG, null, null, "真心话聊天",null);//不屏蔽
					jpushClassifies2.toJpush(remind, CnlifeConstants.MODE4, CnlifeConstants.NEWMSG, null, null, "真心话聊天",null);//不屏蔽
				}
				this.sendJsonResponse(response, "{\"state\":true,\"msg\":\"添加真心话聊天信息成功\",\"msgId\":"+result+"}");
			}
		}catch (Exception e) {
			sendException(response, e);
		}
	}
	
	//推送添加未读数据
	private String setChatMsg(HttpServletRequest request, Integer id, String belongNm, String tp, String content,
                              String contentType, OnlineUser onlineUser, List<SysMemDTO> memList, Integer msgId, Double longitude, Double latitude)
			throws Exception {
		Integer voiceTime;
		List<SysChatMsg> sys = new ArrayList<SysChatMsg>();
		StringBuffer str = new StringBuffer();
		String remind = null;
		for (SysMemDTO memberDTO : memList) {
			if (!memberDTO.getMemberMobile().equals(
					onlineUser.getTel())) {
				SysChatMsg scm = new SysChatMsg();
				scm.setAddtime(DateTimeUtil.getDateToStr(new Date(),"yyyy-MM-dd HH:mm:ss"));
				scm.setMemberId(onlineUser.getMemId());
				scm.setReceiveId(memberDTO.getMemberId());
				scm.setMsg(content);
				scm.setTp(tp);//聊天类型
				scm.setBelongId(id);//id
				scm.setBelongNm(belongNm);//标题或名称
				scm.setMsgTp(contentType);// 发表类型1.文字2.图片3.语音;
				if ("3".equals(contentType )) {
					voiceTime = Integer.valueOf(request.getParameter("voiceTime"));
					scm.setVoiceTime(voiceTime);
				}
				scm.setLongitude(longitude);
				scm.setLatitude(latitude);
				scm.setMsgId(msgId);
				sys.add(scm);
				str.append(memberDTO.getMemberMobile()+",");
			}
		}
		if(str.length()>0 && !"".equals(str)){
			// 批量添加
			this.sysChatMsgWebService.addChatMsg(sys,onlineUser.getDatabase());
			// 批量推送
			remind = str.substring(0,str.length()-1);
		}
		return remind;
	}
	
	
	/**
	  *@see 圈聊天
	  *@param response
	  *@param request
	  *@param token
	  *@param groupId
	  *@param content 聊天内容
	  *@param contentType  内容类型 1.文字2.图片3.语音
	  *@param voiceTime 语音时间
	  *@创建：作者:YYP		创建时间：2015-2-6
	 */
	@RequestMapping("saveGroupMsg")
	public void saveMsg(HttpServletResponse response, HttpServletRequest request, String token, Integer groupId,
                        String content, String contentType, Integer voiceTime, Double longitude, Double latitude){
		StringBuffer str = new StringBuffer();//屏蔽号码以逗号隔开
		StringBuffer nstr = new StringBuffer();//不屏蔽号码以逗号隔开
		if (!checkParam(response, token,groupId,contentType))
			return;
		try{
			OnlineMessage message = TokenServer.tokenCheck(token);
			if(message.isSuccess()==false){
				sendWarm(response, message.getMessage());
				return;
			}
			OnlineUser onlineUser = message.getOnlineMember();
			String datasource = onlineUser.getDatabase();
			// 查询该圈
			BscEmpgroup empGroup = empGroupWebService.queryGroupById(groupId,datasource);
			if (null==empGroup) {
				// 该员工圈可能已被解散
				sendWarm(response, "该员工圈不存在或已解散");
			}
			// 群聊天信息
			BscEmpGroupMsg empMsg = new BscEmpGroupMsg();
			String httpUrl;
			if ("2".equals(contentType) || "3".equals(contentType)) {
				httpUrl = UploadFile.savePhotoOrVoice(request, response,onlineUser.getDatabase());
				content = httpUrl;
			}
			empMsg.setMemberId(onlineUser.getMemId());
			empMsg.setMsgTp(contentType);
			empMsg.setMsg(content);
			empMsg.setGroupId(groupId);
			if (contentType.equals("3")) {
				empMsg.setVoiceTime(voiceTime);
			}
			empMsg.setLongitude(longitude);
			empMsg.setLatitude(latitude);
			empMsg.setAddtime(DateTimeUtil.getDateToStr(new Date(),"yyyy-MM-dd HH:mm:ss"));
			int result = this.sysChatMsgWebService.addGroupMsg(empMsg,datasource);
			// 保存成功推送
			List<SysChatMsg> sys = new ArrayList<SysChatMsg>();
			List<SysMemDTO> memList = empGroupWebService.querymIds(groupId,onlineUser.getDatabase());
			if (result > 0) {
				for (SysMemDTO memberDTO : memList) {
					if (!memberDTO.getMemberMobile().equals(
							onlineUser.getTel())){
						SysChatMsg scm = new SysChatMsg();
						scm.setAddtime(DateTimeUtil.getDateToStr(new Date(),"yyyy-MM-dd HH:mm:ss"));
						scm.setMemberId(onlineUser.getMemId());
						scm.setReceiveId(memberDTO.getMemberId());
						scm.setMsg(content);
						scm.setTp("9");
						scm.setBelongId(groupId);//圈id
						scm.setBelongNm(empGroup.getGroupNm());//圈名称
						scm.setBelongMsg(empGroup.getGroupHead());//圈头像
						scm.setMsgTp(contentType);// 发表类型1.文字2.图片3.语音;
						if ("3".equals(contentType )) {
							voiceTime = Integer.valueOf(request.getParameter("voiceTime"));
							scm.setVoiceTime(voiceTime);
						}
						scm.setLongitude(longitude);
						scm.setLatitude(latitude);
						scm.setMsgId(result);
						sys.add(scm);
						if("1".equals(memberDTO.getRemindFlag())){//不提醒
							nstr.append(memberDTO.getMemberMobile()+",");
						}else{//提醒
							str.append(memberDTO.getMemberMobile()+",");
						}
					}
				}
				// 批量添加
				this.sysChatMsgWebService.addChatMsg(sys, datasource);
				// 批量推送
				if(nstr.length()>0){
					String remind = nstr.substring(0,nstr.length()-1);
					jpushClassifies.toJpush(remind, CnlifeConstants.MODE1, CnlifeConstants.NEWMSG, null, null, "员工圈聊天","1");//不提醒
					jpushClassifies2.toJpush(remind, CnlifeConstants.MODE1, CnlifeConstants.NEWMSG, null, null, "员工圈聊天","1");//不提醒
				}
				if(str.length()>0){
					String noRemind = str.substring(0,str.length()-1);
					jpushClassifies.toJpush(noRemind, CnlifeConstants.MODE1, CnlifeConstants.NEWMSG, null, null, "员工圈聊天","2");//提醒
					jpushClassifies2.toJpush(noRemind, CnlifeConstants.MODE1, CnlifeConstants.NEWMSG, null, null, "员工圈聊天","2");//提醒
				}
				this.sendJsonResponse(response, "{\"state\":true,\"msg\":\"添加聊天信息成功\",\"msgId\":"+result+"}");
			} else {
				sendWarm(response, "保存聊天信息失败");
				return;
			}
		}catch (Exception e) {
			sendException(response, e);
		}
	}
}
