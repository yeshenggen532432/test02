package com.qweib.cloud.biz.system.controller.ws;

import com.qweib.cloud.biz.common.CnlifeThread;
import com.qweib.cloud.biz.system.UploadFile;
import com.qweib.cloud.biz.system.BaseWebService;
import com.qweib.cloud.biz.system.TokenServer;
import com.qweib.cloud.biz.system.service.plat.SysMemService;
import com.qweib.cloud.biz.system.service.ws.*;
import com.qweib.cloud.core.domain.*;

import com.qweib.cloud.utils.DateTimeUtil;
import com.qweib.cloud.utils.Page;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/web")
public class BscPhotoWallControl extends BaseWebService {
	@Resource
	private BscPhotoWallService bscPhotoWallService;
    @Resource
	private BscPhotoWallPicService bscPhotoWallPicService;
    @Resource
	private BscPhotoWallCommentService bscPhotoWallCommentService;
    @Resource
	private BscPhotoWallPraiseService bscPhotoWallPraiseService;
    @Resource
	private SysMemService memService;
	@Resource
	private SysMemBindService sysMemBindService;
	@Resource
	private SysChatMsgService sysChatMsgService;
	
     /**
	 * @说明：获取用户发布的照片墙
	 * @创建者： 作者：llp 创建时间：2014-5-6
	 * @param res
	 * @修改历史： 修改者：yjp 修改时间:2014-5-27 修改原因:把数据整合在一起
	 */
	@SuppressWarnings({ "unchecked" })
	@RequestMapping("zxBscPhotoWall")
	public void getzxBscPhotoWall(HttpServletResponse res, String token, Integer pageNo, Integer memberId, String hotTopic, HttpServletRequest request) {
		OnlineUser  loginDto = TokenServer.tokenCheck(token).getOnlineMember();
		if(loginDto==null){
			this.sendJsonResponse(res,"{\"state\":-28}");
			return;
		}
		if (loginDto.getMemId()!= null) {
			try {
				if(pageNo == null){
					pageNo = 1;
				}
				Integer userId = memberId;
				if(memberId == null){
					if(hotTopic==null){
						userId = loginDto.getMemId();
					}
				}
				Page bpPage = this.bscPhotoWallService.findMemberPhoto(userId,hotTopic, pageNo, 20,loginDto.getDatabase());
				List<BscPhotoWallPic> bpwpiclist = new ArrayList<BscPhotoWallPic>();
				
				List<BscPhotoWall> bpwlist = bpPage.getRows();
				for (int i = 0; i < bpwlist.size(); i++) {
					SysMember member1 = this.memService.queryMemById(bpwlist.get(i).getMemberId(), loginDto.getDatabase());
					bpwlist.get(i).setMemberNm(member1.getMemberNm());
					// 照片墙图片
					bpwpiclist = this.bscPhotoWallPicService
							.queryPhotoWallPicList(bpwlist.get(i).getWallId(),loginDto.getDatabase());
					
					bpwlist.get(i).setPicList(bpwpiclist);
					bpwlist.get(i).setMemberHead(member1.getMemberHead());
				}
				bpPage.setRows(bpwlist);
				JSONObject json = new JSONObject();
				json.put("bpPage", bpPage.getRows());
				json.put("state", 1);
				json.put("total", bpPage.getTotalPage());
				this.sendJsonResponse(res, json.toString());
				return;
			} catch (Exception e) {
				log.error("异常", e);
				this.sendJsonResponse(res, "{\"state\":-1}");
				return;
			}
		} else {
			this.sendJsonResponse(res, "{\"state\":-1}");
		}
	}
	/**
	 * @说明：照片墙点赞
	 * @创建者： 作者：llp 创建时间：2014-5-8
	 * @param res
	 */
	@RequestMapping("operPhotoWallPraise")
    public void operPhotoWallPraise(HttpServletResponse res, String token, Integer wallId, HttpServletRequest request){
		OnlineUser  loginDto = TokenServer.tokenCheck(token).getOnlineMember();
    	if(loginDto==null){
			this.sendJsonResponse(res,"{\"state\":-28}");
			return;
		}
		if(loginDto.getMemId()!=null){
	    	try {
	    		//获取改用户是否已赞
				long praiseCount=this.bscPhotoWallPraiseService.queryPhotoPraiseCount(loginDto.getMemId(), wallId, loginDto.getDatabase());
				BscPhotoWall bpwd =  this.bscPhotoWallService.queryBscPhotoWall(wallId, loginDto.getDatabase());
				int isPoint = 0;
				if(bpwd.getMemberId().equals(loginDto.getMemId())){
					isPoint = 1;
				}
				if(praiseCount>0){
					//取消赞
					this.bscPhotoWallPraiseService.deletePhotoPraise(loginDto.getMemId(), wallId,isPoint, loginDto.getDatabase());
				}else{
                    //添加赞
					BscPhotoWallPraise photoWallPraise=new BscPhotoWallPraise();
					photoWallPraise.setMemberId(loginDto.getMemId());
					photoWallPraise.setWallId(wallId);
					photoWallPraise.setClickTime(DateTimeUtil.getDateToStr(new Date(),"yyyy-MM-dd HH:mm"));
					int result = this.bscPhotoWallPraiseService.addPhotoPraise(photoWallPraise,isPoint, loginDto.getDatabase());
					if(result > 0){
						SysMember member = this.memService.findMemberByPhotoWall(wallId, loginDto.getDatabase());
						//--保存临时消息--
						SysChatMsg scm = new SysChatMsg();
						String datetime = DateTimeUtil.getDateToStr(new Date(),
						"yyyy-MM-dd HH:mm:ss");
						scm.setAddtime(datetime);
						scm.setMemberId(loginDto.getMemId());
						scm.setReceiveId(member.getMemberId());
						scm.setTp("6");//照片墙点赞
						scm.setBelongId(wallId);//话题的ID 
						result = this.sysChatMsgService.addChatMsg(scm,loginDto.getDatabase());
						
						if(!loginDto.getMemId().equals(member.getMemberId())){
							Long timemillis = System.currentTimeMillis() / 10000;
							CnlifeThread threadNew = new CnlifeThread(timemillis, member.getMemberMobile(),"I商会",loginDto.getMemberNm()+":赞了你的照片墙", null, 100);
							Thread thread = new Thread(threadNew, "照片墙赞推送");
							thread.start();
						}
						
					}
				}
				this.sendJsonResponse(res,"{\"state\":1}");
			} catch (Exception e) {
				this.sendJsonResponse(res,"{\"state\":-1}");
				return;
			}
		}else{
			this.sendJsonResponse(res, "{\"state\":-3}");
			return;
		}
    }
    /**
	 * @说明：照片墙评论
	 * @创建者： 作者：llp 创建时间：2014-5-8
	 * @param res
	 * @param isrm 是否为回复:0:评论1:回复
	 * @param memberId 如果该条类型是回复的话则该参数的值为评论人的ID
	 */
    @RequestMapping("operPhotoWallComment")
    public void operPhotoWallComment(BscPhotoWallComment sbscPhotoWallComment, HttpServletResponse res, String token, Integer wallId
    		, Integer isrm, Integer memberId, HttpServletRequest request){
    	OnlineUser  loginDto = TokenServer.tokenCheck(token).getOnlineMember();;
    	if(loginDto==null){
			this.sendJsonResponse(res,"{\"state\":-28}");
			return;
		}
		if(loginDto.getMemId()!=null){
	    	try {
	    		String createDt = DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd HH:mm:ss");
	    		sbscPhotoWallComment.setWallId(wallId);
	    		if(isrm==null||isrm==0){
	    			sbscPhotoWallComment.setMemberId(loginDto.getMemId());
	    			sbscPhotoWallComment.setRecomment(0);
	    			sbscPhotoWallComment.setIsrc(0);
	    		}
	    		if(isrm!=null&&isrm == 1){
	    			sbscPhotoWallComment.setMemberId(loginDto.getMemId());
	    			sbscPhotoWallComment.setRecomment(memberId);
	    			sbscPhotoWallComment.setIsrc(1);
	    		}
	    		sbscPhotoWallComment.setAddtime(createDt);
	    		BscPhotoWall bpwd =  this.bscPhotoWallService.queryBscPhotoWall(wallId, loginDto.getDatabase());
	    		Integer isPoint = 0;
	    		List<BscPhotoWallComment> comlist = this.bscPhotoWallCommentService.queryPhotoWallPicList(bpwd.getWallId(), loginDto.getDatabase());
	    		boolean bool = false;
	    		for (int i = 0; i < comlist.size(); i++) {
					if(comlist.get(i).getMemberId().equals(loginDto.getMemId())){
						bool = true;
						break;
					}
				}
	    		if(bpwd.getMemberId().equals(loginDto.getMemId())||bool){
	    			isPoint = 1;
	    		}
	    		int result=this.bscPhotoWallCommentService.addPhotoComment(sbscPhotoWallComment,isPoint, loginDto.getDatabase());
	    		if(result>0){
	    			SysMember member = this.memService.findMemberByPhotoWall(wallId, loginDto.getDatabase());
					//--保存临时消息--
					SysChatMsg scm = new SysChatMsg();
					String datetime = DateTimeUtil.getDateToStr(new Date(),
					"yyyy-MM-dd HH:mm:ss");
					scm.setAddtime(datetime);
					scm.setMemberId(loginDto.getMemId());
					scm.setReceiveId(member.getMemberId());
					scm.setTp("5");//照片墙评论
					scm.setBelongId(wallId);//话题的ID 
					result = this.sysChatMsgService.addChatMsg(scm, loginDto.getDatabase());
					if(!loginDto.getMemId().equals(member.getMemberId())){
						Long timemillis = System.currentTimeMillis() / 10000;
						CnlifeThread threadNew = new CnlifeThread(timemillis, member.getMemberMobile(),"I商会",loginDto.getMemberNm()+":评论了你的照片墙", null, 100);
						Thread thread = new Thread(threadNew, "照片墙赞推送");
						thread.start();
					}
	    			this.sendJsonResponse(res,"{\"state\":1}");
	    		}else{
	    			this.sendJsonResponse(res,"{\"state\":-1}");
	    		}
			} catch (Exception e) {
				this.sendJsonResponse(res,"{\"state\":-1}");
				return;
			}
		}else{
			this.sendJsonResponse(res, "{\"state\":-3}");
			return;
		}
    }
    /**
	 * @说明： 照片墙列表
	 * @创建者： 作者：llp 创建时间：2014-5-6
	 * @param res
	 * @修改历史：
	 */
	@RequestMapping("PhotoWallPage")
	public void getBscPhotoWall(HttpServletResponse res, String token, Integer pageNo, HttpServletRequest request) {
		if (!checkParam(res, token))
			return;
		try {
			OnlineMessage message = TokenServer.tokenCheck(token);
			if(message.isSuccess()==false){
				sendWarm(res, message.getMessage());
				return;
			}
			OnlineUser onlineUser = message.getOnlineMember();
			if(pageNo == null){
				pageNo = 1;
			}
			Page page = this.bscPhotoWallService.queryHotPhotoWallList(pageNo,10,onlineUser.getDatabase());
			JSONObject json = new JSONObject();
			json.put("state",1);
			json.put("bpwlist",page.getRows());
			json.put("total",page.getTotalPage());
			this.sendJsonResponse(res, json.toString());
			return;
		} catch (Exception e) {
			log.error("照片墙列表:", e);
			sendWarm(res, "获取照片墙失败");
		}
	}
	

	/**
	 * @说明：添加照片墙壁
	 * @创建者：作者：YJP 创建时间：2014-6-9
	 * @param request
	 * @param res
	 * @param token   
	 * @param publishContent 照片墙内容
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping("addWall")
	public void addWall(HttpServletRequest request, HttpServletResponse res, String token, String publishContent){
		OnlineUser  loginDto = TokenServer.tokenCheck(token).getOnlineMember();
		List<BscPhotoWallPic> wallList = new ArrayList<BscPhotoWallPic>();
		if(loginDto==null){
			this.sendJsonResponse(res,"{\"state\":-28}");
			return;
		}
		if(loginDto.getMemId()!=null){
			try {
				//添加照片墙
				BscPhotoWall bpd = new BscPhotoWall();
				StringBuffer str = new StringBuffer();
				bpd.setPublishContent(publishContent);
				bpd.setMemberId(loginDto.getMemId());
				bpd.setPublishTime(DateTimeUtil.getDateToStr(new Date(),"yyyy-MM-dd HH:mm:ss"));
				bpd.setCommentNum(0);
				bpd.setPraiseNum(0);
				bpd.setIsTop("0");
				//SysMem members = this.memService.queryDailyMember(loginDto.getMemId(), loginDto.getDatabase());
				Map<String, Object> map = UploadFile.updatePhotos(request,loginDto.getDatabase(), "wall",0);
				if("1".equals(map.get("state"))){
					if("1".equals(map.get("ifImg"))){//是否有图片
						List<String> pic = (List<String>)map.get("fileNames");
						List<String> picMini = (List<String>)map.get("smallFile");
						//循环创建图片
						for (int i = 0; i < pic.size(); i++) {
							BscPhotoWallPic bpwp = new BscPhotoWallPic();
							bpwp.setPic(pic.get(i));
							bpwp.setPicMini(picMini.get(i));
							wallList.add(bpwp);
						}
					}
				}else{
					sendWarm(res, "图片上传失败");
				}
				int wallId = this.bscPhotoWallService.addbscPhotoWall(bpd, wallList, loginDto.getDatabase());
				if(wallId>0){
					//推送并保存消息记录
					/*Page page = this.sysMemBindService.findMyAll(loginDto.getMemId(), 1, 9999,1);
					List<SysMember> member = page.getRows();*/
					List<SysMember> member = this.sysMemBindService.queryMyfs(loginDto.getMemId(), loginDto.getDatabase());//查找我的粉丝
					if(member.size()>0){
						//--推送照片墙--
						String datetime = DateTimeUtil.getDateToStr(new Date(),
						"yyyy-MM-dd HH:mm:ss");
						int i = 0;
						for (SysMember sysMember : member) {
							if(!sysMember.getMemberId().equals(loginDto.getMemId())){
								
								SysChatMsg scm = new SysChatMsg();
								scm.setAddtime(datetime);
								scm.setMemberId(loginDto.getMemId());
								scm.setReceiveId(sysMember.getMemberId());
								scm.setTp("4");//添加照片墙
								scm.setBelongId(wallId);//话题的ID 
								this.sysChatMsgService.addChatMsg(scm, loginDto.getDatabase());
								if(i==member.size()-1){
									str.append(sysMember.getMemberMobile());
								}else{
									str.append(sysMember.getMemberMobile()+",");
								}
								i++;
							}
						}
					}
				}
				Long timemillis = System.currentTimeMillis() / 1000;
				CnlifeThread threadNew = new CnlifeThread(timemillis,str.toString(),"I商会",loginDto.getMemberNm()+" 发布了照片墙:"+publishContent,null,100);
				Thread thread = new Thread(threadNew,"发表照片墙通知");
				thread.start();
				this.sendJsonResponse(res,"{\"state\":1}");
				return; 
			} catch (Exception e) {
				log.error("添加照片墙:", e);
				this.sendJsonResponse(res, "{\"state\":-1}");
				return;
			}
		}else{
			this.sendJsonResponse(res, "{\"state\":-3}");
			return;
		}
	}
	
	/**
	 * @说明：得到照片墙的评论（暂时没用）
	 * @创建者：作者：yjp 创建时间:2014-5-30
	 * @param res
	 * @param token
	 
	@SuppressWarnings("deprecation")
	@RequestMapping("wallComment")
	public void getWallComment(HttpServletResponse res,String token,HttpServletRequest request){
		OnlineUser  loginDto = TokenServer.tokenCheck(token).getOnlineMember();
		if(loginDto==null){
			this.sendJsonResponse(res,"{\"state\":-28}");
			return;
		}
		if(loginDto.getMemId()!=null){
			try {
				List<BscPhotoWallComment> bp = this.bscPhotoWallCommentService.findPhotoComment(loginDto.getMemId(), loginDto.getDatabase());
				List<BscPhotoWallPic> bpwpiclist = new ArrayList<BscPhotoWallPic>();
				SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				Date nowDate = new Date();
				int day = nowDate.getDate();
				int year = nowDate.getYear();
				int month = nowDate.getMonth();
				int hourse = nowDate.getHours();
				int minute = nowDate.getMinutes();
				int result = 0;
				for (int i = 0; i < bp.size(); i++) {
					bp.get(i).setMemberNm(loginDto.getMemberNm());
					bp.get(i).setMemberHead(loginDto.getMemberHead());
					//照片墙
					BscPhotoWall bpw = this.bscPhotoWallService.queryBscPhotoWall(bp.get(i).getWallId(), loginDto.getDatabase());
					SysMember member1 = this.memService.queryIdByDailyMember(bpw.getMemberId(), loginDto.getDatabase());
					bpw.setMemberNm(member1.getMemberNm());
					// 照片墙图片
					bpwpiclist = this.bscPhotoWallPicService
							.queryPhotoWallPicList(bpw.getWallId(), loginDto.getDatabase());
					bpw.setPicList(bpwpiclist);
					bpw.setMemberHead(member1.getMemberHead());
					Date date = format.parse(bp.get(i).getAddtime());
					if(day==date.getDate()&&year==date.getYear()&&month==date.getMonth()){
						if(hourse == date.getHours()){
							result = minute - date.getMinutes();
							bp.get(i).setAddtime(result+"分钟前");
						}else{
							result = hourse-date.getHours();
							bp.get(i).setAddtime(result+"小时前");
						}
					}
					bp.get(i).setBp(bpw);
				}
				JSONObject json = new JSONObject();
				json.put("state",1);
				json.put("commentList", bp);
				this.sendJsonResponse(res,json.toString());
				return;
			} catch (Exception e) {
				log.error("查询评论:", e);
				this.sendHtmlResponse(res,  "{\"state\":-1}");
			}
		}else{
			this.sendJsonResponse(res, "{\"state\":-3}");
			return;
		}
	}
	*/
	/**
	 * @说明：得到照片墙的赞(暂时没用)
	 * @创建者：作者：yjp 创建时间:2014-5-30
	 * @param res
	 * @param token
	 */
	@RequestMapping("wallPraise")
	public void getWallPraise(HttpServletResponse res, String token, HttpServletRequest request){
		OnlineUser  loginDto = TokenServer.tokenCheck(token).getOnlineMember();
		if(loginDto==null){
			this.sendJsonResponse(res,"{\"state\":-28}");
			return;
		}
		if(loginDto.getMemId()!=null){
			try {
				List<BscPhotoWallPraise> bp = this.bscPhotoWallPraiseService.findPhotoPraise(loginDto.getMemId(), loginDto.getDatabase());
				for (int i = 0; i < bp.size(); i++) {
					SysMember member1 = this.memService.queryDailyMember(bp.get(i).getMemberId(), loginDto.getDatabase());
					bp.get(i).setMemberNm(member1.getMemberNm());
					bp.get(i).setMemberHead(member1.getMemberHead());
				}
				JSONObject json = new JSONObject();
				json.put("state",1);
				json.put("praiseList", bp);
				this.sendJsonResponse(res,json.toString());
				return;
			} catch (Exception e) {
				log.error("查询评论:", e);
				this.sendHtmlResponse(res,  "{\"state\":-1}");
			}
		}else{
			this.sendJsonResponse(res, "{\"state\":-3}");
			return;
		}
	}
	
	  /**
	 * @说明： 热门照片墙详情
	 * @创建者： 作者：yjp 创建时间：2014-6-2
	 * @param res
	 */
	@SuppressWarnings("deprecation")
	@RequestMapping("hotPhotoWallDetail")
	public void gethotBscPhotoWall(HttpServletResponse res, String token, Integer wallId, HttpServletRequest request) {
		OnlineUser  loginDto = TokenServer.tokenCheck(token).getOnlineMember();
		if(loginDto==null){
			this.sendJsonResponse(res,"{\"state\":-28}");
			return;
		}
		if (loginDto.getMemId() != null) {
			try {
				SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				Date nowDate = new Date();
				int day = nowDate.getDate();
				int year = nowDate.getYear();
				int month = nowDate.getMonth();
				int hourse = nowDate.getHours();
				int minute = nowDate.getMinutes();
				int result = 0;
				
				BscPhotoWall bpwlist = this.bscPhotoWallService
						.queryBscPhotoWall(wallId, loginDto.getDatabase());
				
				SysMember member1 = this.memService.queryDailyMember(bpwlist.getMemberId(), loginDto.getDatabase());
				bpwlist.setMemberNm(member1.getMemberNm());
				bpwlist.setMemberHead(member1.getMemberHead());
				List<BscPhotoWallComment> bpwcommentlist = new ArrayList<BscPhotoWallComment>();
				List<BscPhotoWallPraise> bpwpraiselist = new ArrayList<BscPhotoWallPraise>();
				// 照片墙图片
				List<BscPhotoWallPic> picList = new ArrayList<BscPhotoWallPic>();
				//查询照片墙
				picList = this.bscPhotoWallPicService.queryPhotoWallPicList(bpwlist.getWallId(), loginDto.getDatabase());
				bpwlist.setPicList(picList);
				
				// 照片墙评论
				bpwcommentlist = this.bscPhotoWallCommentService
						.queryPhotoWallPicList(bpwlist.getWallId(), loginDto.getDatabase());
				for (int j = 0; j < bpwcommentlist.size(); j++) {
					SysMember member = this.memService.queryDailyMember(bpwcommentlist.get(j)
									.getMemberId(), loginDto.getDatabase());
				    Date date = format.parse(bpwcommentlist.get(j).getAddtime());
					if(day==date.getDate()&&year==date.getYear()&&month==date.getMonth()){
						if(hourse == date.getHours()){
							result = minute - date.getMinutes();
							bpwcommentlist.get(j).setAddtime(result+"分钟前");
						}else{
							result = hourse-date.getHours();
							bpwcommentlist.get(j).setAddtime(result+"小时前");
						}
					}
					bpwcommentlist.get(j).setMemberNm(member.getMemberNm());
					bpwcommentlist.get(j).setMemberHead(member.getMemberHead());
					if(bpwcommentlist.get(j).getIsrc()==1){
						member = this.memService
						.queryDailyMember(bpwcommentlist.get(j)
								.getRecomment(), loginDto.getDatabase());
						bpwcommentlist.get(j).setRecomNm(member.getMemberNm());
					}
					
				}
				// 照片墙赞
				bpwpraiselist = this.bscPhotoWallPraiseService
						.queryPhotoWallPicList(bpwlist.getWallId(), loginDto.getDatabase());
				for (int k = 0; k < bpwpraiselist.size(); k++) {
					SysMember member = this.memService
							.queryDailyMember(bpwpraiselist.get(k)
									.getMemberId(), loginDto.getDatabase());
					bpwpraiselist.get(k).setMemberNm(member.getMemberNm());
					//赞头像
					bpwpraiselist.get(k).setMemberHead(member.getMemberHead());
				}
				bpwlist.setCommentList(bpwcommentlist);
				bpwlist.setPraiseList(bpwpraiselist);
				JSONObject json = new JSONObject(bpwlist);
				json.put("state",1);
				System.out.println(json.toString());
				this.sendJsonResponse(res, json.toString());
				return;
			} catch (Exception e) {
				log.error("热门照片墙详情：", e);
				this.sendJsonResponse(res, "{\"state\":-1}");
				return;
			}
		} else {
			this.sendJsonResponse(res, "{\"state\":-1}");
		}
	}
	
	/**
	 * @说明：删除照片墙
	 * @创建者: 作者：YJP 创建时间:2014-06-010
	 * @param res
	 * @param token
	 * @param wallId
	 */
	@RequestMapping("deleteWall")
	public void deleteWall(HttpServletResponse res, String token, Integer wallId, HttpServletRequest request){
		OnlineUser  loginDto = TokenServer.tokenCheck(token).getOnlineMember();
		if(loginDto==null){
			this.sendJsonResponse(res,"{\"state\":-28}");
			return;
		}
		if (loginDto.getMemId() != null) {
			try {
				if(wallId!=null){
					int result =  this.bscPhotoWallService.deleteWall(wallId, loginDto.getDatabase());
					if(result>0){
						this.sendJsonResponse(res, "{\"state\":1}");
						return;
					}else{
						this.sendJsonResponse(res, "{\"state\":-1}");
						return;
					}
				}
			} catch (Exception e) {
				log.error("删除:", e);
				this.sendJsonResponse(res, "{\"state\":-1}");
				return;
			}
		} else {
			this.sendJsonResponse(res, "{\"state\":-3}");
			return; 
		}
	}
	
	/**
	 * @说明：删除评论
	 * @创建者: 作者：YJP 创建时间:2014-06-010
	 * @param res
	 * @param token
	 * @param commentId 评论ID
	 * @param type 1:照片墙评论  2讨论区话题评论
	 */
	@RequestMapping("deleteComment")
	public void deleteComment(HttpServletResponse res, String token, Integer commentId, Integer type, HttpServletRequest request){
		OnlineUser  loginDto = TokenServer.tokenCheck(token).getOnlineMember();
		if(loginDto==null){
			this.sendJsonResponse(res,"{\"state\":-28}");
			return;
		}
		if (loginDto.getMemId() != null) {
			try {
				int result = 0;
				if(commentId!=null){
					
						BscPhotoWall bpwd =  this.bscPhotoWallService.queryPhotoWallByCommentId(commentId, loginDto.getDatabase());
						Integer isPoint = 0;
						List<BscPhotoWallComment> comlist = this.bscPhotoWallCommentService.queryPhotoWallPicList(bpwd.getWallId(), loginDto.getDatabase());
						boolean bool = false;
			    		for (int i = 0; i < comlist.size(); i++) {
							if(comlist.get(i).getMemberId().equals(loginDto.getMemId())){
								if(comlist.get(i).getCommentId().equals(commentId)){
									continue;
								}else{
									bool = true;
									break;
								}
							}
						}
			    		if(bpwd.getMemberId().equals(loginDto.getMemId())||bool){
			    			isPoint = 1;
			    		}
						result = this.bscPhotoWallCommentService.deletePhotoComment(commentId,isPoint, loginDto.getDatabase());
					
				}
				//删除成功
				if(result>0){
					this.sendJsonResponse(res, "{\"state\":1}");
					return;
				}else{
					this.sendJsonResponse(res, "{\"state\":-1}");
					return;
				}
			} catch (Exception e) {
				log.error("删除:", e);
				this.sendJsonResponse(res, "{\"state\":-1}");
				return;
			}
		} else {
			this.sendJsonResponse(res, "{\"state\":-3}");
			return; 
		}
	}
	
}
