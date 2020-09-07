package com.qweib.cloud.biz.system.controller.ws;


import com.qweib.cloud.biz.common.CnlifeConstants;
import com.qweib.cloud.biz.system.UploadFile;
import com.qweib.cloud.biz.system.BaseWebService;
import com.qweib.cloud.biz.system.TokenServer;
import com.qweib.cloud.biz.system.jpush.JpushClassifies;
import com.qweib.cloud.biz.system.jpush.JpushClassifies2;
import com.qweib.cloud.biz.system.service.ws.BscEmpGroupWebService;
import com.qweib.cloud.biz.system.service.ws.BscTopicWebService;
import com.qweib.cloud.biz.system.service.ws.SysChatMsgService;
import com.qweib.cloud.biz.system.service.ws.SysMemberWebService;
import com.qweib.cloud.core.domain.*;

import com.qweib.cloud.utils.DateTimeUtil;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.json.JSONObject;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/web/")
public class BscTopicWebControl extends BaseWebService {
	@Resource
	private BscTopicWebService bscTopicWebService;
	
	@Resource
	private BscEmpGroupWebService empGroupWebService;
	@Resource
	private SysMemberWebService sysMemberWebService;
	@Resource
	private SysChatMsgService chatMsgService;
	@Resource
	private JpushClassifies jpushClassifies;
	@Resource
	private JpushClassifies2 jpushClassifies2;

	/**
	  *@see 添加话题或真心话(真心话暂不用，改为聊天)
	  *@param request
	  *@param response
	  *@param token
	  *@param tpId tp为0，对应员工圈id    tp为1，对应真心话id(必传)
	  *@param topicTitle 标题
	  *@param topiContent 发表内容
	  *@param atMemberMobile @的手机号码
	  *@param publishTp 类型： 1：没图片 2：有图片(必传)
	  *@param tpType 0 员工圈话题 1 真心话话题 2 外部来源(发帖)(必传)
	  *@param isAnonymity 是否匿名（0 否 1 是）
	  *@param url 外部链接地址 
	  *@创建：作者:YYP		创建时间：2015-1-30
	 */
	@RequestMapping("addTopic")
	public void addTopic(HttpServletRequest request, HttpServletResponse res, String token,
                         Integer tpId, String topicTitle, String topiContent, String atMemberMobile,
                         String publishTp, Integer tpType, String isAnonymity, String url){
		String tr = "";
		StringBuffer str = new StringBuffer();//屏蔽号码以逗号隔开
		StringBuffer nstr = new StringBuffer();//不屏蔽号码以逗号隔开
		if (!checkParam(res, token,tpId,tpType))
			return;
		try{
			OnlineMessage message = TokenServer.tokenCheck(token);
			if(message.isSuccess()==false){
				sendWarm(res, message.getMessage());
				return;
			}
			OnlineUser loginDto = message.getOnlineMember();
			String datasource = loginDto.getDatabase();
			BscTopic topic = new BscTopic();
			topic.setTpType(tpType);//0 员工圈话题 1 真心话话题
			topic.setTpId(tpId);//tp为0，对应员工圈id    tp为1，对应真心话id
			if(0==tpType){//发帖
				topic.setTopicTitle(topicTitle);//主题
				tr = topicTitle;
			}else if(2==tpType){//外部来源（发帖）
				Document doc = null;
				try{
					doc=Jsoup.connect(url)
					.data("jquery", "java")
					.userAgent("Mozilla")
					.cookie("auth", "token")
					.timeout(50000)
					.get();
				}catch (Exception e) {
					try{//如果网址解析错误，加“/”再次解析
						doc=Jsoup.connect(url+"/")
						.data("jquery", "java")
						.userAgent("Mozilla")
						.cookie("auth", "token")
						.timeout(50000)
						.get();
					}catch (Exception ex) {
						try{//网站的bug,跳过该问题
							doc=Jsoup.connect(url).header("User-Agent","Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/40.0.2214.111 Safari/537.36").get();
						}catch (IOException ioex) {
							sendWarm(res, "网址错误");
							return;
						}
					}
				}
				String dtitle = doc.title();
				if(null==dtitle || "".equals(dtitle.trim())){
					dtitle="详情";
				}
				topic.setTopicTitle(dtitle);
				topic.setUrl(url);
				tr = dtitle;
			}
			topic.setTopiContent(topiContent);//内容
			topic.setMemberId(loginDto.getMemId());//发表人
			topic.setTopicTime(DateTimeUtil.getDateToStr(new Date(),"yyyy-MM-dd HH:mm:ss"));
			if(1==tpType){//真心话话题是否匿名
				if(null==isAnonymity || "".equals(isAnonymity)){
					isAnonymity = "1";
				}
				topic.setIsAnonymity(isAnonymity);
			}
			//如果有图片则添加图片
			List<BscTopicPic> btpList = new ArrayList<BscTopicPic>();
			if("2".equals(publishTp)){
				//使用request取
				Map<String, Object> map = UploadFile.updatePhotos(request,loginDto.getDatabase(), "topic",1);
				if("1".equals(map.get("state"))){
					if("1".equals(map.get("ifImg"))){//是否有图片
						BscTopicPic btp = new BscTopicPic();
						List<String> pic = (List<String>)map.get("fileNames");
						List<String> picMini = (List<String>)map.get("smallFile");
						for (int i = 0; i < pic.size(); i++) {
							btp = new BscTopicPic();
							btp.setPicMini(picMini.get(i));
							btp.setPic(pic.get(i));
							btpList.add(btp);
						}
					}
				}else{
					sendWarm(res, "图片上传失败");
				}
			}
			Integer result = this.bscTopicWebService.addBscTopic(topic,btpList,tpType,datasource);
			if(0==tpType || 2==tpType){//员工圈话题
				//BscEmpgroup empGroup = empGroupWebService.queryGroupById(tpId,loginDto.getDatabase());// 查询该圈
				List<SysChatMsg> sys = new ArrayList<SysChatMsg>();
				List<SysMemDTO> members = empGroupWebService.querymIds(tpId,loginDto.getDatabase());//查找员工圈所有成员id
				if(members.size()>0){
					for (SysMemDTO sysMem : members) {
							if(!sysMem.getMemberId().equals(loginDto.getMemId())){
								SysChatMsg scm = new SysChatMsg();
								scm.setAddtime(DateTimeUtil.getDateToStr(new Date(),"yyyy-MM-dd HH:mm:ss"));
								scm.setMemberId(loginDto.getMemId());
								scm.setReceiveId(sysMem.getMemberId());
								scm.setTp("1");//发表圈主题
								scm.setBelongId(result);//话题的ID 
								scm.setMsg("发表主题 ["+tr+"] ");
								sys.add(scm);
								if("1".equals(sysMem.getRemindFlag())){//不屏蔽
									nstr.append(sysMem.getMemberMobile()+",");
								}else{//屏蔽
									str.append(sysMem.getMemberMobile()+",");
								}
							}
					}
					// 批量添加
					this.chatMsgService.addChatMsg(sys, datasource);
					if(nstr.length()>0){
						String remind = nstr.substring(0,nstr.length()-1);
						jpushClassifies.toJpush(remind, CnlifeConstants.MODE3, CnlifeConstants.NEWMSG, null, null, "发表帖子通知","2");//不屏蔽
						jpushClassifies2.toJpush(remind, CnlifeConstants.MODE3, CnlifeConstants.NEWMSG, null, null, "发表帖子通知","2");//不屏蔽
					}
					if(str.length()>0){
						String noRemind = str.substring(0,str.length()-1);
						jpushClassifies.toJpush(noRemind, CnlifeConstants.MODE3, CnlifeConstants.NEWMSG, null, null, "发表帖子通知","1");//屏蔽
						jpushClassifies2.toJpush(noRemind, CnlifeConstants.MODE3, CnlifeConstants.NEWMSG, null, null, "发表帖子通知","1");//屏蔽
					}
				}
//				得到at人的手机号列表----暂时不启用
				/*List<BscAita> aitaList = new ArrayList<BscAita>();
				if(!StrUtil.isNull(atMemberMobile)){
					String[] atMobiles = atMemberMobile.split("@");
					List<SysMember> sysmember = this.sysMemWebService.queryLoginInfo(atMobiles,loginDto.getDatabase());
					int i = 0;
					for (SysMember sysMember : sysmember) {
						if(sysMember.getMemberId()!=loginDto.getMemId()){
							SysChatMsg scm = new SysChatMsg();
							scm.setAddtime(DateTimeUtil.getDateToStr(new Date(),"yyyy-MM-dd HH:mm:ss"));
							scm.setMemberId(loginDto.getMemId());
							scm.setReceiveId(sysMember.getMemberId());
							scm.setBelongId(result);//话题的ID
							scm.setTp("7");
							sys.add(scm);
							//生成aita对象
							BscAita ba = new BscAita(result, sysMember.getMemberId());
							aitaList.add(ba);
							if(i==sysmember.size()-1){
								str.append(sysMember.getMemberMobile());
							}else{
								str.append(sysMember.getMemberMobile()+",");
							}
							i++;
						}
					}
					this.bscAitaWebService.saveAt(aitaList,loginDto.getDatabase());
				}*/
			}
			sendSuccess(res, "成功添加话题");
		}catch (Exception e) {
			sendException(res, e);
		}
	}
	/**
	  *@see 获取主题列表
	  *@param resquest
	  *@param response
	  *@param token
	  *@param tpId 圈id
	  *@param pageNo 页数
	  *@创建：作者:YYP		创建时间：2015-2-3
	 */
	@RequestMapping("topicList")
	public void topicList(HttpServletRequest resquest, HttpServletResponse response, String token, Integer tpId, Integer pageNo){
		if (!checkParam(response, token,tpId))
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
			Page topicPage = bscTopicWebService.queryTopicPage(tpId,pageNo,CnlifeConstants.pageSize,message.getOnlineMember().getDatabase());
			JSONObject json = new JSONObject();
			json.put("tpPage",topicPage.getRows());
			json.put("total",topicPage.getTotalPage());
			json.put("state",true);
			json.put("msg","成功获取主题列表");
			this.sendJsonResponse(response, json.toString());
		}catch (Exception e) {
			sendException(response, e);
		}
	}
	/**
	  *@see 评论
	  *@param request
	  *@param response
	  *@param token
	  *@param topicComment(content,topicId,belongId,rcId,rcNm)
	  *@创建：作者:YYP		创建时间：2015-2-5
	 */
	@RequestMapping("addComment")
	public void addComment(HttpServletRequest request, HttpServletResponse response, String token, BscTopicComment topicComment){
		if (!checkParam(response, token,topicComment.getContent(),topicComment.getTopicId()))
			return;
		try{
			OnlineMessage message = TokenServer.tokenCheck(token);
			if(message.isSuccess()==false){
				sendWarm(response, message.getMessage());
				return;
			}
			OnlineUser loginDto = message.getOnlineMember();
			String datasource = loginDto.getDatabase();
			if(null!=topicComment.getRcId()){//自己不能回复自己的评论
				if(topicComment.getRcId().equals(loginDto.getMemId())){
					sendWarm(response, "自己不能回复自己的评论");
					return;
				}
			}
			topicComment.setCommentTime(DateTimeUtil.getDateToStr(new Date(),"yyyy-MM-dd HH:mm:ss"));
			topicComment.setMemberId(loginDto.getMemId());
			Integer info = this.bscTopicWebService.addTopicComment(topicComment,datasource);
				//查询主题发表人信息
			SysMemDTO member = new SysMemDTO();
			String sendContent = "";
			BscTopic topic = bscTopicWebService.queryTopicById(topicComment.getTopicId(),datasource);
			if(null!=topicComment.getRcId()){//回复
				member = sysMemberWebService.queryMemByMemId(topicComment.getRcId());
				sendContent = "回复你的 ["+topic.getTopicTitle()+"] 话题";
			}else{
				member = this.bscTopicWebService.findMemberByTopic(topicComment.getTopicId(),datasource);
				 sendContent = "评论你的 ["+topic.getTopicTitle()+"] 话题";
			}
			if(!loginDto.getMemId().equals(member.getMemberId())){
				//--保存临时消息--
				SysChatMsg scm = new SysChatMsg();
				scm.setAddtime(DateTimeUtil.getDateToStr(new Date(),"yyyy-MM-dd HH:mm:ss"));
				scm.setMemberId(loginDto.getMemId());
				scm.setReceiveId(member.getMemberId());
				scm.setTp("2");//主题评论
				scm.setBelongId(topicComment.getTopicId());//主题id
				scm.setMsg(sendContent);
//				this.publicMsgWebService.addpublicMsg(scm);
				chatMsgService.addChatMsg(scm, datasource);
				jpushClassifies.toJpush(member.getMemberMobile(), CnlifeConstants.MODE3, CnlifeConstants.NEWMSG, null,null,"话题评论推送",null);
				jpushClassifies2.toJpush(member.getMemberMobile(), CnlifeConstants.MODE3, CnlifeConstants.NEWMSG, null,null,"话题评论推送",null);
			}
				this.sendJsonResponse(response, "{\"state\":true,\"msg\":\"添加评论回复成功\",\"commentId\":"+info+"}");
		}catch (Exception e) {
			sendException(response, e);
		}
	}
	/**
	  *@see 删除评论
	  *@param request
	  *@param response
	  *@param token
	  *@param commentId
	  *@param topicId
	  *@创建：作者:YYP		创建时间：2015-2-7
	 */
	@RequestMapping("delComment")
	public void delComment(HttpServletRequest request, HttpServletResponse response, String token, Integer commentId, Integer topicId){
		if (!checkParam(response, token,commentId,topicId))
			return;
		try{
			OnlineMessage message = TokenServer.tokenCheck(token);
			if(message.isSuccess()==false){
				sendWarm(response, message.getMessage());
				return;
			}
			String datasource = message.getOnlineMember().getDatabase();
			BscTopicComment comment = bscTopicWebService.queryCommentById(commentId,datasource);
			if(!comment.getMemberId().equals(message.getOnlineMember().getMemId())){
				sendWarm(response, "只有本人才能删除自己评论");
				return;
			}
			bscTopicWebService.deleteComment(commentId,topicId,datasource);
			sendSuccess(response, "删除评论成功");
		}catch (Exception e) {
			sendException(response, e);
		}
	}
	/**
	  *@see 添加或取消主题赞
	  *@param request
	  *@param response
	  *@param token
	  *@param topicId
	  *@创建：作者:YYP		创建时间：2015-2-5
	 */
	@RequestMapping("operPraise")
	public void operPraise(HttpServletRequest request, HttpServletResponse response, String token, Integer topicId){
		if (!checkParam(response, token,topicId))
			return;
		try{
			OnlineMessage message = TokenServer.tokenCheck(token);
			if(message.isSuccess()==false){
				sendWarm(response, message.getMessage());
				return;
			}
			OnlineUser loginDto = message.getOnlineMember();
			String datasource = loginDto.getDatabase();
			//获取该用户是否已赞
			long praiseCount=this.bscTopicWebService.queryPraise(loginDto.getMemId(), topicId,datasource);
			if(praiseCount>0){
				//取消赞
				this.bscTopicWebService.deletePraise(loginDto.getMemId(), topicId,datasource);
			}else{
				BscTopicPraise topicPraise = new BscTopicPraise();
				topicPraise.setTopicId(topicId);
				topicPraise.setMemberId(loginDto.getMemId());
				bscTopicWebService.addTopicPraise(topicPraise,datasource);//添加赞
				SysMemDTO member = this.bscTopicWebService.findMemberByTopic(topicId,datasource);
				if(!loginDto.getMemId().equals(member.getMemberId())){
				//--保存临时消息--
				SysChatMsg scm = new SysChatMsg();
				scm.setAddtime(DateTimeUtil.getDateToStr(new Date(),"yyyy-MM-dd HH:mm:ss"));
				scm.setMemberId(loginDto.getMemId());
				scm.setReceiveId(member.getMemberId());
				scm.setTp("3");//主题评论
				scm.setBelongId(topicId);//主题id
				BscTopic topic = bscTopicWebService.queryTopicById(topicId,datasource);
				scm.setMsg("赞了你的 ["+topic.getTopicTitle()+"] 话题");
//				this.publicMsgWebService.addpublicMsg(scm);
				chatMsgService.addChatMsg(scm, datasource);
				jpushClassifies.toJpush(member.getMemberMobile(), CnlifeConstants.MODE3, CnlifeConstants.NEWMSG, null,null,"话题赞推送",null);
				jpushClassifies2.toJpush(member.getMemberMobile(), CnlifeConstants.MODE3, CnlifeConstants.NEWMSG, null,null,"话题赞推送",null);
				}
			}
			sendSuccess(response, "添加或删除赞成功");
		}catch (Exception e) {
			sendException(response, e);
		}
	}
	/**
	  *@see 删除帖子
	  *@param request
	  *@param response
	  *@param token
	  *@param topicId
	  *@创建：作者:YYP		创建时间：2015-5-15
	 */
	@RequestMapping("delTopic")
	public void delTopic(HttpServletRequest request, HttpServletResponse response, String token, Integer topicId){
		if (!checkParam(response, token,topicId))
			return;
		try{
			OnlineMessage message = TokenServer.tokenCheck(token);
			if(message.isSuccess()==false){
				sendWarm(response, message.getMessage());
				return;
			}
			String datasource = message.getOnlineMember().getDatabase();
			bscTopicWebService.deleteTopic(topicId,datasource);
			sendSuccess(response, "删除帖子成功");
		}catch (Exception e) {
			sendException(response, e);
		}
	}
}
