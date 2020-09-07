package com.qweib.cloud.biz.system.controller;

import com.google.common.collect.Lists;
import com.qweib.cloud.biz.common.CnlifeConstants;
import com.qweib.cloud.biz.system.UploadFile;
import com.qweib.cloud.biz.system.BaseWebService;
import com.qweib.cloud.biz.system.TokenServer;
import com.qweib.cloud.biz.system.jpush.JpushClassifies;
import com.qweib.cloud.biz.system.jpush.JpushClassifies2;
import com.qweib.cloud.biz.system.service.ws.PublicMsgWebService;
import com.qweib.cloud.biz.system.service.ws.SysMemberWebService;
import com.qweib.cloud.core.domain.*;

import com.qweib.cloud.utils.DateTimeUtil;
import com.qweib.cloud.utils.StrUtil;
import com.qweibframework.commons.StringUtils;
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
public class PublicMsgWebControl extends BaseWebService {
	@Resource
	private PublicMsgWebService publicMsgWebService;
	@Resource
	private SysMemberWebService memberWebService;
	@Resource
	private JpushClassifies jpushClassifies;
	@Resource
	private JpushClassifies2 jpushClassifies2;

	/**
	  *@see 私信聊
	  *@param request
	  *@param response
	  *@param token
	  *@param memId
	  *@param content
	  *@param contentType
	  *@param voiceTime
	  *@创建：作者:YYP		创建时间：2015-2-6
	 */
	@RequestMapping("addPersonMsg")
	public void addPersonMsg(HttpServletRequest request, HttpServletResponse response, String token, Integer memId,
                             String content, String contentType, Integer voiceTime, Double longitude, Double latitude){
		if (!checkParam(response, token,memId,contentType))
			return;
		try{
			OnlineMessage message = TokenServer.tokenCheck(token);
			if(message.isSuccess()==false){
				sendWarm(response, message.getMessage());
				return;
			}
			OnlineUser onlineUser = message.getOnlineMember();
			SysMemDTO member = this.memberWebService.queryMemByMemId(memId);
			Integer info = memberWebService.queryIsFriend(member.getMemberId(),onlineUser.getMemId());
			if(info<1){//不是好友
				if(null!=member.getDatasource()){
					if(!member.getDatasource().equals(onlineUser.getDatabase())){//是否同一公司
						sendWarm(response, "该用户不是同一个公司或好友，不能私信");
						return;
					}
				}else{
					sendWarm(response, "该用户好友，不能私信");
					return;
				}
			}
			SysMemberMsg msg = new SysMemberMsg();
			msg.setMemberId(onlineUser.getMemId());
			msg.setReceiveId(memId);
			msg.setMsgTp(contentType);
			// 保存的是内容
			String httpUrl;
			if ("2".equals(contentType) ||"3".equals(contentType)) {
				httpUrl = UploadFile.savePhotoOrVoice(request, response,onlineUser.getDatabase());
				content = httpUrl;
			}
			msg.setLongitude(longitude);//经度
			msg.setLatitude(latitude);//纬度
			msg.setVoiceTime(voiceTime);
			msg.setMsg(content);
			msg.setAddtime(DateTimeUtil.getDateToStr(new Date(),"yyyy-MM-dd HH:mm:ss"));
			int result = this.publicMsgWebService.addMemerMsg(msg);
			if (result > 0) {
				// --------------先做信息保存--------------
					SysChatMsg scm = new SysChatMsg();
					scm.setAddtime(DateTimeUtil.getDateToStr(new Date(),"yyyy-MM-dd HH:mm:ss"));
					scm.setMemberId(onlineUser.getMemId());
					scm.setReceiveId(memId);
					scm.setMsg(content);
					scm.setMsgTp(contentType);// 发表类型1.文字2.图片3.语音;
					if ("3".equals(contentType)) {
						voiceTime = Integer.valueOf(request
								.getParameter("voiceTime"));
						scm.setVoiceTime(voiceTime);
					}
					scm.setTp("15");
					scm.setMsgId(result);
					scm.setLongitude(longitude);
					scm.setLatitude(latitude);
					this.publicMsgWebService.addpublicMsg(scm);
					// 批量推送
					jpushClassifies.toJpush(member.getMemberMobile(), CnlifeConstants.MODE1, CnlifeConstants.NEWMSG, null, null, "私信聊天",null);
					jpushClassifies2.toJpush(member.getMemberMobile(), CnlifeConstants.MODE1, CnlifeConstants.NEWMSG, null, null, "私信聊天",null);
					this.sendJsonResponse(response, "{\"state\":true,\"msg\":\"发私信成功\",\"msgId\":"+result+"}");
			} else {
				sendWarm(response, "添加私信消息失败");
			}
		}catch (Exception e) {
			sendException(response, e);
		}
	}
	/**
	  *@see 获取聊天记录（私信和员工圈）
	  *@param request
	  *@param response
	  *@param token
	  *@param pId tp为1员工圈id tp为4 成员id
	  *@param id 上一页最后一条消息的id
	  *@param tp 1 员工圈  4 私信
	  *@创建：作者:YYP		创建时间：2015-2-12
	 */
	@RequestMapping("getMsg")
	public void getPersonMsg(HttpServletRequest request, HttpServletResponse response, String token, Integer pId, Integer id, String tp){
		if (!checkParam(response, token,pId,tp))
			return;
		try{
			List msgList = new ArrayList();
			OnlineMessage message = TokenServer.tokenCheck(token);
			if(message.isSuccess()==false){
				sendWarm(response, message.getMessage());
				return;
			}
			OnlineUser onlineUser = message.getOnlineMember();
			String database = onlineUser.getDatabase();
			if(null==onlineUser || "".equals(database)){
				msgList = publicMsgWebService.queryLetterMsg(pId,onlineUser.getMemId(),id,tp,null);
			}else{//员工圈
				msgList = publicMsgWebService.queryLetterMsg(pId,onlineUser.getMemId(),id,tp,database);
			}
			Collections.reverse(msgList);
			JSONObject json = new JSONObject();
			json.put("msgList", msgList);
			json.put("state",true);
			json.put("msg","查询成功");
			this.sendJsonResponse(response, json.toString());
		}catch (Exception e) {
			sendException(response, e);
		}
	}
	/**
	  *@see 获取未读消息并删除
	  *@param request
	  *@param response
	  *@param token
	  *@创建：作者:YYP		创建时间：2015-2-15
	 */
	@RequestMapping("unRead")
	public void unRead(HttpServletRequest request, HttpServletResponse response, String token){
		if (!checkParam(response, token))
			return;
		try{
			OnlineMessage message = TokenServer.tokenCheck(token);
			if(message.isSuccess()==false){
				sendWarm(response, message.getMessage());
				return;
			}
			OnlineUser onlineUser = message.getOnlineMember();
			List<SysChatMsg> msgList =  publicMsgWebService.deletequeryUnReadMsg(onlineUser.getMemId(),onlineUser.getDatabase());
			JSONObject json = new JSONObject();
			json.put("msgList", msgList);
			json.put("state",true);
			json.put("msg","查询成功");
			this.sendJsonResponse(response, json.toString());
		}catch (Exception e) {
			sendException(response, e);
		}
	}
	@RequestMapping("unRead2")
	public void unRead2(HttpServletRequest request, HttpServletResponse response, String token){
		if (!checkParam(response, token))
			return;
		try{
			OnlineMessage message = TokenServer.tokenCheck(token);
			if(message.isSuccess()==false){
				sendWarm(response, message.getMessage());
				return;
			}
			OnlineUser onlineUser = message.getOnlineMember();
			List<SysChatMsg> msgList;
			if (StringUtils.isNotBlank(onlineUser.getDatabase())) {
				msgList = publicMsgWebService.queryChatMsg2(onlineUser.getMemId(), onlineUser.getDatabase());
				for (SysChatMsg chatMsg : msgList) {
					if (chatMsg.getTp().equals("41-1")) {
						//SysChatMsg chatMsg2=this.publicMsgWebService.queryChatMsgByMRB(chatMsg.getReceiveId(), chatMsg.getMemberId(), chatMsg.getBelongId(), onlineUser.getDatabase());
						SysChatMsg chatMsg2 = this.publicMsgWebService.queryChatMsgByMsgId(chatMsg.getId(), onlineUser.getDatabase());
						if (StrUtil.isNull(chatMsg2)) {
							chatMsg.setMsgTp("待处理");
						} else {
							if (chatMsg2.getMsg().indexOf("同意") >= 0) {
								chatMsg.setMsgTp("同意");
							} else {
								chatMsg.setMsgTp("拒绝");
							}
						}
					}
				}
			} else {
				/**
				 * 如果未加入公司的情况
				 */
				msgList = Lists.newArrayListWithCapacity(0);
			}
			JSONObject json = new JSONObject();
			json.put("msgList", msgList);
			json.put("state",true);
			json.put("msg","查询成功");
			this.sendJsonResponse(response, json.toString());
		}catch (Exception e) {
			sendException(response, e);
		}
	}
	public static void main(String[] args) {
		String s="同意了转让客户";
		System.out.println(s.indexOf("同意"));
	}
}
