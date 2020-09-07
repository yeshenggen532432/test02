package com.qweib.cloud.biz.system.controller.ws;

import com.qweib.cloud.biz.common.CnlifeConstants;
import com.qweib.cloud.biz.system.BaseWebService;
import com.qweib.cloud.biz.system.TokenServer;
import com.qweib.cloud.biz.system.jpush.JpushClassifies;
import com.qweib.cloud.biz.system.jpush.JpushClassifies2;
import com.qweib.cloud.biz.system.service.plat.*;
import com.qweib.cloud.biz.system.service.ws.SysChatMsgService;
import com.qweib.cloud.core.domain.*;

import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.DateTimeUtil;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * 说明： 易办事
 * 
 * @创建：作者:zrp 创建时间：2015-1-26
 * @修改历史： [序号](zrp 2015-1-26)<修改说明>
 */
@Controller
@RequestMapping("/web")
public class TodoTasksControl extends BaseWebService {
	
	@Resource
	private SysTaskPsnService sysTaskPsnService;
	@Resource
	private SysTaskService taskService;
	@Resource
	private SysTaskAttachmentService sysTaskAttachmentService;
	@Resource
	private SysTaskFeedBackService taskFeedBackService;
	@Resource
	private SysMemService memService;
	@Resource
	private SysChatMsgService sysChatMsgWebService;
	@Resource
	private JpushClassifies jpushClassifies;
	@Resource
	private JpushClassifies2 jpushClassifies2;
	/**
	 * 说明： 易办事-待办主任务
	 * 
	 * @创建：作者:zrp 创建时间：2015-1-26
	 * @修改历史： [序号](zrp 2015-1-26)<修改说明>
	 * @param type 1 发布人 2 责任人 3 关注人
	 * @param state 1 进行中 2 已完成 3 草稿
	 */
	@RequestMapping("noTasks")
	public void noTasks(HttpServletRequest request, HttpServletResponse response, String token,
                        Integer pageSize, Integer pageNo, String title, Integer state, String type){
		try{
			if(!checkParam(response, token,pageNo)){
				return;
			}
			if(StrUtil.isNull(pageSize)){
				pageSize=10;
			}
			if(StrUtil.isNull(state)){
				state=SysTask.STATUS_NO;
			}
			OnlineMessage message = TokenServer.tokenCheck(token);
			if(message.isSuccess()==false){
				sendWarm(response, message.getMessage());
				return;
			}
			OnlineUser onlineUser = message.getOnlineMember();
			Page page = this.taskService.queryPageByTitle(title, pageNo, pageSize,onlineUser.getDatabase(),state,onlineUser.getMemId(),type);
			JSONObject json = new JSONObject();
			json.put("state", true);
			json.put("msg", "查询成功");
			json.put("pageNo", pageNo);
			json.put("pageSize", pageSize);
			json.put("total", page.getTotal());
			json.put("totalPage", page.getTotalPage());
			json.put("rows", page.getRows());
			this.sendJsonResponse(response, json.toString());
		}catch (Exception e) {
			this.sendWarm(response, "查询失败");
		}
	}
	/**
	  *@see 查询任务(包括已办、未办、草稿)
	  *@param response
	  *@param token
	  *@param searchContent
	  *@param pageNo
	  *@创建：作者:YYP		创建时间：2015-5-19
	 */
	@RequestMapping("searchTask")
	public void searchTask(HttpServletResponse response, String token, String searchContent, Integer pageNo){
		if(!checkParam(response, token,searchContent)){
			return;
		}
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
			Page page = this.taskService.queryModelTask(searchContent, pageNo,20,onlineUser.getDatabase(),onlineUser.getMemId());
			JSONObject json = new JSONObject();
			json.put("state", true);
			json.put("msg", "查询成功");
			json.put("total", page.getTotal());
			json.put("totalPage", page.getTotalPage());
			json.put("rows", page.getRows());
			this.sendJsonResponse(response, json.toString());
		}catch (Exception e) {
			sendException(response, e);
		}
	}
	/**
	 * 说明： 易办事-待办子任务
	 * 
	 * @创建：作者:zrp 创建时间：2015-1-26
	 * @修改历史： [序号](zrp 2015-1-26)<修改说明>
	 */
	@RequestMapping("noTasksChild")
	public void noTasksChild(HttpServletRequest request, HttpServletResponse response, String token,
                             Integer pageSize, Integer pageNo, Integer taskId, Integer state){
		try{
			if(!checkParam(response, token,pageNo,taskId)){
				return;
			}
			if(StrUtil.isNull(pageSize)){
				pageSize=10;
			}
			if(StrUtil.isNull(state)){
				state=SysTask.STATUS_NO;
			}
			OnlineMessage message = TokenServer.tokenCheck(token);
			if(message.isSuccess()==false){
				sendWarm(response, message.getMessage());
				return;
			}
			OnlineUser onlineUser = message.getOnlineMember();
			Page page = this.taskService.queryPageById(taskId,pageNo, pageSize,onlineUser.getDatabase(),state);
			JSONObject json = new JSONObject();
			json.put("state", true);
			json.put("msg", "查询成功");
			json.put("pageNo", pageNo);
			json.put("pageSize", pageSize);
			json.put("total", page.getTotal());
			json.put("totalPage", page.getTotalPage());
			json.put("rows", page.getRows());
			this.sendJsonResponse(response, json.toString());
		}catch (Exception e) {
			this.sendWarm(response, "查询失败");
		}
	}
	/**
	 *  说明： 易办事-根据任务ID获取明细
	 * @param token    令牌
	 * @param taskId   任务ID
	 */
	@RequestMapping("detailTask")
	public void detailTask(HttpServletRequest request, HttpServletResponse response, String token, Integer taskId){
		try{
			if(!checkParam(response, token,taskId)){
				return;
			}
			OnlineMessage message = TokenServer.tokenCheck(token);
			if(message.isSuccess()==false){
				sendWarm(response, message.getMessage());
				return;
			}
			OnlineUser onlineUser = message.getOnlineMember();
			SysTask task = this.taskService.queryById(taskId,onlineUser.getDatabase(),onlineUser.getMemId());
			if(task==null){
				sendWarm(response, "此任务已删除");
				return;
			}
			if(null!=task.getParentId() && 0!=task.getParentId()){
				Map<String, Object> pTime = taskService.queryParentTime(task.getParentId(),onlineUser.getDatabase());
				task.setPstartTime((String)pTime.get("stime"));
				task.setPendTime((String)pTime.get("etime"));
			}
			String time = "";
			if(!StrUtil.isNull(task.getRemind4())){
				time+=task.getRemind1()+"%、";
			}
			if(!StrUtil.isNull(task.getRemind3())){
				time+=task.getRemind2()+"%、";
			}
			if(!StrUtil.isNull(task.getRemind2())){
				time+=task.getRemind3()+"%、";
			}
			if(!StrUtil.isNull(task.getRemind1())){
				time+=task.getRemind4()+"%、";
			}
			JSONObject json = new JSONObject(task);
			json.put("state", true);
			json.put("msg", "查询成功");
			if(time.length()>0){
				json.put("context", "系统将于任务完成时间剩余"+time.substring(0,time.length()-1)+"提醒您.");
				json.put("context2", "系统会提前5分钟提醒您");
			}
			//查询附件
			List<SysTaskAttachment> attList = taskService.queryTaskattachment(task.getId(),onlineUser.getDatabase());
			if(null!=attList && attList.size()!=0){
				json.put("attList",attList);
			}
			this.sendJsonResponse(response, json.toString());
		}catch (Exception e) {
			sendWarm(response, "查询失败");
		}
	}
	/**
	 * 添加任务进度(任务反馈)
	 * @param taskId 任务ID
	 * @param persent 进度
	 * @param remarks 描述
	 */
	@RequestMapping("addTaskFeedback")
	public void addTaskFeedback(HttpServletRequest request, HttpServletResponse response, String token,
                                Integer taskId, Integer persent, String remarks){
		try{
			if(!checkParam(response, token,taskId,persent,remarks)){
				return;
			}
			OnlineMessage message = TokenServer.tokenCheck(token);
			if(message.isSuccess()==false){
				sendWarm(response, message.getMessage());
				return;
			}
			if(persent>100){
				sendWarm(response,"进度不能超过100");
				return;
			}
			OnlineUser onlineUser = message.getOnlineMember();
			String database= onlineUser.getDatabase();
			Integer mId = onlineUser.getMemId();
			if(100==persent){
				Map map = this.taskService.queryByTaskIdNot(taskId,database);
				Object obj = map.get("num");
				if(Integer.valueOf(obj.toString())>0){
					sendWarm(response, "请先完成子任务");
					return;
				}
				//推送
				Map idsTelsMap = taskService.querycreatebyfocus(taskId, database,SysTaskPsn.PSN_FOCUS_ON);
				String telzr = idsTelsMap.get("tels")==null?"":idsTelsMap.get("tels").toString();
				String memIdzr = idsTelsMap.get("ids")==null?"":idsTelsMap.get("ids").toString();
				String telsfocus = idsTelsMap.get("telsfocus")==null?"":idsTelsMap.get("telsfocus").toString();
				String memIdsfocus = idsTelsMap.get("idsfocus")==null?"":idsTelsMap.get("idsfocus").toString();
				String telstotal = telzr+","+telsfocus;
				SysMember member = memService.queryMemById(onlineUser.getMemId(),database);//查询当前用户信息
				String mTel = member.getMemberMobile();//当前用户号码
				String tels = telstotal.replaceAll(","+mTel+"|"+mTel+",","");//号码排除自己(不推送自己用)
				String memIds = memIdzr+","+memIdsfocus;
			    String ids = memIds.replaceAll( ","+mId+"|"+mId+",","");//id排除自己
				if(!"".equals(ids)){
					List<SysChatMsg> sys = new ArrayList<SysChatMsg>();
					for(String d :ids.split(",")){
						if(!d.equals(mId.toString())){
							SysChatMsg scm = new SysChatMsg();
							scm.setAddtime(getDate());
							scm.setMemberId(mId);
							scm.setBelongId(taskId);
							scm.setTp("10");//完成任务
							scm.setBelongMsg("完成任务");
							scm.setMsg(onlineUser.getMemberNm()+"： ["+idsTelsMap.get("task_title")+"] 任务已完成。");
							scm.setReceiveId(Integer.valueOf(d));
							sys.add(scm);
						}
					}
					// 批量添加
					this.sysChatMsgWebService.addChatMsg(sys,database);
//					SysTaskMsg msg = new SysTaskMsg();
//					msg.setRemindTime(this.getDate());
//					msg.setNid(taskId);
//					msg.setTp("1");
//					msg.setMemId(mId);
//					msg.setContent(onlineUser.getMemberNm()+"： ["+idsTelsMap.get("task_title")+"] 任务已完成。");
//					this.taskService.addMsg(ids.indexOf(",")!=-1?ids.substring(0,ids.length()-1).split(","):ids.split(","),msg,database);
//					JpushClassify jc = new JpushClassify();
					jpushClassifies.toJpush(tels, CnlifeConstants.MODE2, CnlifeConstants.NEWMSG, null, 0, "提示",null);
					jpushClassifies2.toJpush(tels, CnlifeConstants.MODE2, CnlifeConstants.NEWMSG, null, 0, "提示",null);
				}
			}
			SysTask task = this.taskService.queryById(taskId, database);
			task.setPercent(persent);
			this.taskService.updateTask(task, database);
			SysTaskFeedback feed = new SysTaskFeedback();
			feed.setDtDate(this.getDate());
			feed.setPersent(persent);
			feed.setNid(taskId);
			feed.setRemarks(remarks);
			int id = this.taskService.addTask(feed,database);
			if(id>0 && 100==persent){
				//删除进行中任务的子表
				taskService.deleteTaskIng(taskId,database);
			}
//			if(id>0){
//				String time = this.getFilePath();
//				List<Map<String,String>> pics = this.uploadFile(request, this.getPathUpload(request)+"/"+database+"/"+time,database+"/"+time);
//				if(pics.size()>0){
//					for(int i=0;i<pics.size();i++){
//						Map<String,String> map =pics.get(i);
//						SysTaskAttachment att = new SysTaskAttachment();
//						att.setPid(id);
//						att.setAttachName(map.get("name"));
//						att.setAttacthPath(time+map.get("/path"));
//						sysTaskAttachmentService.addTaskAttachment(att,database);
//					}
//				}
//			}else{
//				sendWarm(response, "添加失败");
//				return;
//			}
			this.sendJsonResponse(response, "{\"state\":true,\"msg\":\"添加成功\"}");
		}catch (Exception e) {
			e.printStackTrace();
			sendWarm(response, "添加失败");
		}
	}
	/**
	 * 获取任务进度详情
	 * @param taskId 任务ID
	 */
	@RequestMapping("detailTaskFeed")
	public void detailTaskFeed(HttpServletRequest request, HttpServletResponse response, String token,
                               Integer feeId){
		try{
			if(!checkParam(response, token,feeId)){
				return;
			}
			OnlineMessage message = TokenServer.tokenCheck(token);
			if(message.isSuccess()==false){
				sendWarm(response, message.getMessage());
				return;
			}
			OnlineUser onlineUser = message.getOnlineMember();
			String datebase = onlineUser.getDatabase();
//			SysTaskFeedback feed = this.taskFeedBackService.queryById(feeId, datebase);
			List<SysTaskAttachment> list = this.sysTaskAttachmentService.queryFeedBackList(feeId,datebase);
			JSONObject json =  new JSONObject();
			json.put("state", true);
			json.put("msg", "查询成功");
			json.put("rows", list);
			this.sendJsonResponse(response, json.toString());
		}catch (Exception e) {
			sendWarm(response, "查询失败");
		}
	}
	/**
	 * 根据进度ID修改进度信息
	 * @param taskId 任务ID
	 */
	@RequestMapping("modTaskFeed")
	public void modTaskFeed(HttpServletRequest request, HttpServletResponse response, String token,
                            Integer feeId, String remarks){
		try{
			if(!checkParam(response, token,feeId,remarks)){
				return;
			}
			OnlineMessage message = TokenServer.tokenCheck(token);
			if(message.isSuccess()==false){
				sendWarm(response, message.getMessage());
				return;
			}
			OnlineUser onlineUser = message.getOnlineMember();
			String database = onlineUser.getDatabase();
			SysTaskFeedback feed = this.taskFeedBackService.queryById(feeId, database);
			feed.setRemarks(remarks);
			this.taskFeedBackService.updateTaskFeed(feed,database);
//			if(feed!=null){
//				String time = this.getFilePath();
//				List<Map<String,String>> pics = this.uploadFile(request, this.getPathUpload(request)+"/"+database+"/"+time,database+"/"+time);
//				if(pics.size()>0){
//					for(int i=0;i<pics.size();i++){
//						Map<String,String> map =pics.get(i);
//						SysTaskAttachment att = new SysTaskAttachment();
//						att.setPid(feeId);
//						att.setAttachName(map.get("name"));
//						att.setAttacthPath(time+map.get("/path"));
//						sysTaskAttachmentService.addTaskAttachment(att,database);
//					}
//				}
				this.sendJsonResponse(response, "{\"state\":true,\"msg\":\"修改成功\"}");
//			}else{
//				sendWarm(response, "修改失败");
//				return;
//			}
//			this.sendJsonResponse(response, "{\"state\":true,\"msg\":\"修改成功\"}");
		}catch (Exception e) {
			e.printStackTrace();
			sendWarm(response, "修改失败");
		}
	}
	/**
	 * 根据任务ID获取进度列表
	 * @param taskId 任务ID
	 */
	@RequestMapping("listTsakFeed")
	public void detailTaskFedd(HttpServletRequest request, HttpServletResponse response, String token,
                               Integer taskId, Integer pageSize, Integer pageNo){
		try{
			if(!checkParam(response, token,taskId,pageNo)){
				return;
			}
			if(StrUtil.isNull(pageSize)){
				pageSize=10;
			}
			OnlineMessage message = TokenServer.tokenCheck(token);
			if(message.isSuccess()==false){
				sendWarm(response, message.getMessage());
				return;
			}
			OnlineUser onlineUser = message.getOnlineMember();
			String database = onlineUser.getDatabase();
			SysTask task = this.taskService.queryById(taskId, database);
			int isComplete = 0;
			if(task.getPercent()>=100){
				if(queryTaskJd(database, taskId)){
					isComplete = 1;
				}
			}
			Page page = this.taskFeedBackService.queryById(taskId,database,pageNo,pageSize);
			JSONObject json = new JSONObject();
			json.put("isComplete", isComplete);
			json.put("state", true);
			json.put("msg", "查询成功");
			json.put("pageNo", pageNo);
			json.put("pageSize", pageSize);
			json.put("total", page.getTotal());
			json.put("totalPage", page.getTotalPage());
			json.put("rows", page.getRows());
			this.sendJsonResponse(response, json.toString());
		}catch (Exception e) {
			sendWarm(response, "查询失败");
		}
	}
	public boolean queryTaskJd(String database,Integer taskId){
		try{
			List<SysTask> list = this.taskService.queryForListByPid(taskId, database);
			if(list.size()>0){
				for(SysTask task : list){
					if(task.getStatus()==SysTask.STATUS_NO){
						return false;
					}else{
						if(!queryTaskJd(database, task.getId())){
							return false;
						}
					}
				}
			}else{
				return true;
			}
			return true;
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 * 修改任务完成
	 * @param taskId 任务ID
	 */
	@RequestMapping("modTaskState")
	public void modTaskState(HttpServletRequest request, HttpServletResponse response, String token,
                             Integer taskId){
		try{
			if(!checkParam(response, token,taskId)){
				return;
			}
			OnlineMessage message = TokenServer.tokenCheck(token);
			if(message.isSuccess()==false){
				sendWarm(response, message.getMessage());
				return;
			}
			OnlineUser onlineUser = message.getOnlineMember();
			String database =onlineUser.getDatabase();
			Map map = this.taskService.queryByTaskIdNot(taskId,database);
			Object obj = map.get("num");
			if(Integer.valueOf(obj.toString())>0){
				this.sendJsonResponse(response, "{\"state\":false,\"msg\":\"请先完成子任务\"}");
				return;
			}
			Integer id =this.taskService.updateState(taskId,database,SysTask.STATUS_YES,new SimpleDateFormat("yyyy-MM-dd HH:mm").format(new Date()));
			
			this.sendJsonResponse(response, "{\"state\":true,\"msg\":\"修改成功\"}");
		}catch (Exception e) {
			sendWarm(response, "结束任务失败");
		}
	}
	
	/**
	 * 说明： 易办事-修改任务-删除附件
	 * @param request
	 * @param response
	 * @param token   令牌
	 * @param id	  附件ID
	 */
	@RequestMapping("delAttachment")
	public void delAttachment(HttpServletRequest request, HttpServletResponse response, String token, Integer feeId){
		try{
			if(!checkParam(response, token,feeId)){
				return;
			}
			OnlineMessage message = TokenServer.tokenCheck(token);
			if(message.isSuccess()==false){
				sendWarm(response, message.getMessage());
				return;
			}
			String database =message.getOnlineMember().getDatabase();
			SysTaskAttachment att = this.sysTaskAttachmentService.queryById(feeId,database);
			if(att!=null){
				String pic = att.getAttacthPath();
				this.delFile(this.getPathUpload(request)+"/"+pic);
			}
			this.sysTaskAttachmentService.deleteByid(feeId,database);
			this.sendJsonResponse(response, "{\"state\":true,\"msg\":\"删除成功\"}");
		}catch (Exception e) {
			sendWarm(response, "删除失败");
		}
	}
	
	/**
	 * 说明： 易办事-复制任务（改成手机端复制任务暂时不用此接口）
	 * @param request
	 * @param response
	 * @param token   令牌
	 * @param taskId  任务ID
	 */
	/*@RequestMapping("copyTask")
	public void copyTask(HttpServletRequest request,HttpServletResponse response,String token,Integer taskId){
		try{
			if(!checkParam(response, token,taskId)){
				return;
			}
			OnlineMessage message = TokenServer.tokenCheck(token);
			if(message.isSuccess()==false){
				sendWarm(response, message.getMessage());
				return;
			}
			String database = message.getOnlineMember().getDatabase();
			String time = this.getFilePath();
			String path = this.getPathUpload(request);
			int id = this.taskService.addTaskCopy(request,path, taskId,database,time,message.getOnlineMember().getMemId());
			this.sendJsonResponse(response, "{\"state\":true,\"msg\":\"复制成功\",\"taskId\":\""+id+"\"}");
		}catch (Exception e) {
			e.printStackTrace();
			sendWarm(response, "复制失败");
		}
	}*/
	
	/**
	 * 说明： 易办事-任务催办
	 * @param request
	 * @param titile  任务名
	 * @param token   令牌
	 * @param taskId  任务ID
	 */
	@RequestMapping("addSysTaskMsg")
	public void addSysTaskMsg(HttpServletRequest request, HttpServletResponse response, String token, String taskIds){
		try{
			if(!checkParam(response, token,taskIds)){
				return;
			}
			OnlineMessage message = TokenServer.tokenCheck(token);
			if(message.isSuccess()==false){
				sendWarm(response, message.getMessage());
				return;
			}
			OnlineUser user = message.getOnlineMember();
			String database = user.getDatabase();
			String[] taskId = taskIds.split(",");
			for(String tid : taskId){
				Map map = this.taskService.queryByMember(Integer.valueOf(tid),database,SysTaskPsn.PSN_RESPONSIBILITY,null);
				if(map.get("ids")==null||map.size()==0){
					continue;
				}
				List<SysChatMsg> sys = new ArrayList<SysChatMsg>();
				String ids = map.get("ids").toString();
				String tels = map.get("tels").toString();
				String title = map.get("task_title").toString();
				String[] id = ids.split(",");
				String time = this.getDate();
				SysChatMsg scm = new SysChatMsg();
				scm.setAddtime(time);
				scm.setMemberId(user.getMemId());
				scm.setMsg(user.getMemberNm()+"：提醒您完成 ["+title+"] 任务");
				scm.setBelongId(Integer.valueOf(tid));
				scm.setBelongMsg("催办任务");
				scm.setTp("10");//催办消息
				for(String d :id){
					scm.setReceiveId(Integer.valueOf(d));
					sys.add(scm);
				}
				// 批量添加
				this.sysChatMsgWebService.addChatMsg(sys,database);
				SysTaskMsg msg = new SysTaskMsg();
				msg.setRemindTime(this.getDate());
				msg.setNid(Integer.valueOf(tid));
				msg.setTp("1");
				msg.setMemId(user.getMemId());
				msg.setContent(user.getMemberNm()+"：提醒您完成 ["+title+"] 任务");
				this.taskService.addMsg(id,msg,database);
				
//				JpushClassify jc = new JpushClassify();
				jpushClassifies.toJpush(tels, CnlifeConstants.MODE2, CnlifeConstants.NEWMSG, null, 0, "提示",null);
				jpushClassifies2.toJpush(tels, CnlifeConstants.MODE2, CnlifeConstants.NEWMSG, null, 0, "提示",null);
			}
			this.sendJsonResponse(response, "{\"state\":true,\"msg\":\"催办成功\"}");
		}catch (Exception e) {
			sendWarm(response, "催办失败");
		}
	}
	
	/**
	 * 说明： 易办事-添加任务(保存主任务或子任务)
	 * @param token    令牌
	 * @param taskTitle 标题
	 * @param startTime 开始时间
	 * @param endTime	结束时间
	 * @param taskMemo	内容
	 * @param pid 创建人ID
	 */
	@RequestMapping("addTasks")
	public void add(HttpServletRequest request, HttpServletResponse response, String token,
                    String taskTitle, String startTime, String endTime, String taskMemo, Integer parentId){
		try{
			if(!checkParam(response, token,taskTitle)){
				return;
			}
			OnlineMessage message = TokenServer.tokenCheck(token);
			if(message.isSuccess()==false){
				sendWarm(response, message.getMessage());
				return;
			}
			OnlineUser user = message.getOnlineMember();
			String database = user.getDatabase();
			SysTask task = new SysTask();
			task.setTaskTitle(taskTitle);
			task.setCreateTime(new DateTimeUtil().getDateToStr(new Date(),"yyyy-MM-dd HH:mm"));
			task.setStartTime(startTime);
			task.setEndTime(endTime);
			task.setTaskMemo(taskMemo);
			if(!StrUtil.isNull(parentId)){
				task.setParentId(parentId);
			}
			task.setCreateBy(user.getMemId());
			task.setStatus(SysTask.STATUS_DRAFT);
			task.setPercent(0);
			task.setRemind1(30);
			task.setRemind2(20);
			task.setRemind3(10);
			task.setRemind4(5);
			int id = this.taskService.addTask(task,database);
//			if(id>0){
//				String time = getFilePath();
//				List<Map<String,String>> pics = this.uploadFile(request, this.getPathUpload(request)+"/"+database+"/"+time,database+"/"+time);
//				if(pics.size()>0){
//					Map<String,String> map =pics.get(0);
//					SysTaskAttachment att = new SysTaskAttachment();
//					att.setNid(id);
//					att.setAttachName(map.get("name"));
//					att.setAttacthPath(time+map.get("/path"));
//					sysTaskAttachmentService.addTaskAttachment(att,database);
//				}
				this.sendJsonResponse(response, "{\"state\":true,\"msg\":\"添加成功\",\"taskid\":\""+id+"\"}");
//			}else{
//				sendWarm(response, "添加失败");
//			}
		}catch (Exception e) {
			e.printStackTrace();
			sendWarm(response, "添加失败");
		}
	}
	
	/**
	 * 查询已关注的人员以及通讯录
	 * @param request
	 * @param response
	 * @param token
	 * @param taskId
	 */
	@RequestMapping("queryMemlist")
	public void queryUserType(HttpServletRequest request, HttpServletResponse response,
                              String token, Integer taskId, Integer pageNo, Integer pageSize){
		try{
			if(!checkParam(response, token,pageNo)){
				return;
			}
			if(StrUtil.isNull(pageSize)){
				pageSize=10;
			}
			OnlineMessage message = TokenServer.tokenCheck(token);
			if(message.isSuccess()==false){
				sendWarm(response, message.getMessage());
				return;
			}
			OnlineUser user = message.getOnlineMember();
			String database = user.getDatabase();
			//通讯录
			Page page = this.memService.queryForPage(null, pageNo, pageSize, database);
			JSONObject json = new JSONObject();
			json.put("state", true);
			json.put("msg", "查询成功");
			json.put("pageNo", pageNo);
			json.put("pageSize", pageSize);
			json.put("total", page.getTotal());
			json.put("totalPage", page.getTotalPage());
			json.put("rows", page.getRows());
			if(!StrUtil.isNull(taskId)){
				//责任人
				List<SysMember> zrr = this.sysTaskPsnService.queryHead(taskId,database,SysTaskPsn.PSN_RESPONSIBILITY); 
				//关注人
				List<SysMember> gzr = this.sysTaskPsnService.queryHead(taskId,database,SysTaskPsn.PSN_FOCUS_ON);
				json.put("zrrlist", zrr);
				json.put("gzrlist", gzr);
			}
			this.sendJsonResponse(response, json.toString());
		}catch (Exception e) {
			sendWarm(response, "查询失败");
		}
	}
	/**
	 * @说明：易办事-添加任务-添加人、责任人
	 * @创建：作者:zrp 创建时间：2015-1-26
	 * @param person  [{"id":"100","name":"张三","type":"1"},...] 备注 type 1、责任人 2、关注人 
	 * @param taskId  任务ID
	 */
	@RequestMapping("addTaskPsn")
	public void add(HttpServletRequest request, HttpServletResponse response,
                    String person, String token, Integer taskId){
		try{
			if(!checkParam(response, token,person,taskId)){
				return;
			}
			OnlineMessage message = TokenServer.tokenCheck(token);
			if(message.isSuccess()==false){
				sendWarm(response, message.getMessage());
				return;
			}
			OnlineUser user = message.getOnlineMember();
			String database = user.getDatabase();
			this.sysTaskPsnService.deleteByTaskId(taskId,database);
 			net.sf.json.JSONArray jsonarray = net.sf.json.JSONArray.fromObject(person);
			int len = jsonarray.size();
			if(len>0){
				for(int i = 0 ;i<len;i++){
					net.sf.json.JSONObject json = (net.sf.json.JSONObject)jsonarray.get(i);
					SysTaskPsn psn = new SysTaskPsn();
					int id = Integer.valueOf(json.get("id").toString());
					psn.setNid(taskId);
					psn.setPsnType(Integer.valueOf(json.get("type").toString()));
					psn.setPsnId(id);
					this.sysTaskPsnService.addTaskPsn(psn,database);
				}
			}
			this.sendJsonResponse(response, "{\"state\":true,\"msg\":\"添加成功\"}");
		}catch (Exception e) {
			sendException(response, e);
		}
	}
	
	/**
	 * 说明： 易办事-修改提醒状态
	 * @param token    令牌
	 * @param id 任务ID
	 */
	@RequestMapping("modRemind")
	public void modRemind(HttpServletRequest request, HttpServletResponse response, String token,
                          Integer taskId, Integer remind1, Integer remind2, Integer remind3, Integer remind4){
		try{
			if(!checkParam(response, token,taskId,remind1,remind2,remind3,remind4)){
				return;
			}
			OnlineMessage message = TokenServer.tokenCheck(token);
			if(message.isSuccess()==false){
				sendWarm(response, message.getMessage());
				return;
			}
			OnlineUser user = message.getOnlineMember();
			String database = user.getDatabase();
			SysTask task = this.taskService.queryById(taskId,database);
			if(task==null)sendWarm(response, "任务不存在");
			task.setRemind1(remind1);
			task.setRemind2(remind2);
			task.setRemind3(remind3);
			task.setRemind4(remind4);
			int i = this.taskService.updateTask(task,database);
			if(i>0){
				this.sendJsonResponse(response, "{\"state\":true,\"msg\":\"修改成功\"}");
			}else{
				sendWarm(response, "修改失败");
			}
		}catch (Exception e) {
			sendException(response, e);
		}
	}
	/**
	 * 说明： 易办事-发布任务
	 * @param token    令牌
	 * @param id 任务ID
	 */
	@RequestMapping("modState")
	public void modState(HttpServletRequest request, HttpServletResponse response, String token,
                         Integer taskId){
		try{
			if(!checkParam(response, token,taskId)){
				return;
			}
			OnlineMessage message = TokenServer.tokenCheck(token);
			if(message.isSuccess()==false){
				sendWarm(response, message.getMessage());
				return;
			}
			OnlineUser user = message.getOnlineMember();
			String database = user.getDatabase();
			SysTask task = this.taskService.queryById(taskId, database);
			if(task.getStatus().equals(SysTask.STATUS_NO)){
				sendWarm(response, "不允许重复发布");
				return;
			}
			Integer isout = taskService.queryIfOutTime(task.getStartTime(),task.getEndTime(),task.getId(),database);//查询是否有子任务超过主任务时间
			if(isout>0){
				sendWarm(response, "子任务时间需在主任务时间内!");
				return;
			}
		    List<SysTask> taskList = taskService.queryTaskByzid(taskId,database);//查询该主任务的所有主子任务
			this.taskService.addupdateState(taskList, database, SysTask.STATUS_NO);
			
/////////////////////////////推送////////////////////
			Map map = taskService.queryByMember(taskId, database, SysTaskPsn.PSN_RESPONSIBILITY,SysTaskPsn.PSN_FOCUS_ON);
			String telzr = map.get("tels")==null?"":map.get("tels").toString();
			String memIdzr = map.get("ids")==null?"":map.get("ids").toString();
			String telsfocus = map.get("telsfocus")==null?"":map.get("telsfocus").toString();
			String memIdsfocus = map.get("idsfocus")==null?"":map.get("idsfocus").toString();
			String telstotal = telzr+","+telsfocus;
			SysMember member = memService.queryMemById(user.getMemId(),database);//查询当前用户信息
			String mTel = member.getMemberMobile();//当前用户号码
			String tels = telstotal.replaceAll(","+mTel+"|"+mTel+",","");//号码排除自己(不推送自己用)
			String memIds = memIdzr+","+memIdsfocus;
			if(!"".equals(memIdzr)){
			    String ids = memIds.replaceAll( ","+user.getMemId()+"|"+user.getMemId()+",","");//id排除自己
				    if(!"".equals(ids)){
						List<SysChatMsg> sys = new ArrayList<SysChatMsg>();
						if(!"".equals(memIdzr)){
							for(String d :memIdzr.split(",")){
								if(!d.equals(user.getMemId().toString())){
									SysChatMsg scm = new SysChatMsg();
									scm.setAddtime(getDate());
									scm.setMemberId(user.getMemId());
									scm.setBelongId(taskId);
									scm.setTp("10");//催办消息
									scm.setBelongMsg("新任务");
									scm.setMsg(user.getMemberNm()+"：发起 ["+task.getTaskTitle()+"] 任务，请完成");
									scm.setReceiveId(Integer.valueOf(d));
									sys.add(scm);
								}
							}
						}
						if(!"".equals(memIdsfocus)){
							for(String str :memIdsfocus.split(",")){
								if(!str.equals(user.getMemId().toString())){
									SysChatMsg scm = new SysChatMsg();
									scm.setAddtime(getDate());
									scm.setMemberId(user.getMemId());
									scm.setBelongId(taskId);
									scm.setTp("10");//催办消息
									scm.setBelongMsg("新任务");
									scm.setMsg(user.getMemberNm()+"：发起 ["+task.getTaskTitle()+"] 任务，请关注");
									scm.setReceiveId(Integer.valueOf(str));
									sys.add(scm);
								}
							}
						}
						// 批量添加
						this.sysChatMsgWebService.addChatMsg(sys,database);
						SysTaskMsg msg = new SysTaskMsg();
						msg.setRemindTime(this.getDate());
						msg.setNid(taskId);
						msg.setTp("1");
						msg.setMemId(user.getMemId());
						msg.setContent(user.getMemberNm()+"：请完成 ["+task.getTaskTitle()+"] 任务");
						this.taskService.addMsg(ids.indexOf(",")!=-1?ids.substring(0,ids.length()-1).split(","):ids.split(","),msg,database);
//						JpushClassify jc = new JpushClassify();
						jpushClassifies.toJpush(tels, CnlifeConstants.MODE2, CnlifeConstants.NEWMSG, null, 0, "提示",null);
						jpushClassifies2.toJpush(tels, CnlifeConstants.MODE2, CnlifeConstants.NEWMSG, null, 0, "提示",null);
			    }
				this.sendJsonResponse(response, "{\"state\":true,\"msg\":\"发布成功\"}");
			}else{
				sendWarm(response, "请添加责任人并重新保存");
				return;
			}
		}catch (Exception e) {
			sendException(response, e);
		}
	}
	
	//发布任务
	@RequestMapping("issueState")
	public void issueState(HttpServletRequest request, HttpServletResponse response, String token,
                           Integer taskId, String person, String taskTitle, String startTime, String endTime, String taskMemo){
		try{
			if(!checkParam(response, token,taskTitle,startTime,endTime,person)){
				return;
			}
			OnlineMessage message = TokenServer.tokenCheck(token);
			if(message.isSuccess()==false){
				sendWarm(response, message.getMessage());
				return;
			}
			OnlineUser user = message.getOnlineMember();
			String database = user.getDatabase();
			Integer isout = taskService.queryIfOutTime(startTime,endTime,taskId,database);//查询是否有子任务超过主任务时间
			if(isout>0){
				sendWarm(response, "子任务时间需在主任务时间内!");
				return;
			}
			if(null==taskId){//先保存
				//保存任务基本信息
				SysTask task = new SysTask();
				task.setTaskTitle(taskTitle);
				task.setCreateTime(new DateTimeUtil().getDateToStr(new Date(),"yyyy-MM-dd HH:mm"));
				task.setStartTime(startTime);
				task.setEndTime(endTime);
				task.setTaskMemo(taskMemo);
				task.setCreateBy(user.getMemId());
				task.setStatus(SysTask.STATUS_DRAFT);
				task.setPercent(0);
				task.setRemind1(30);
				task.setRemind2(20);
				task.setRemind3(10);
				task.setRemind4(5);
				taskId = this.taskService.addTask(task,database);
			}else{
				SysTask task = this.taskService.queryById(taskId, database);
				//更新任务
				task.setTaskTitle(taskTitle);
				task.setStartTime(startTime);
				task.setEndTime(endTime);
				task.setEndTime(endTime);
				task.setTaskMemo(taskMemo);
				taskService.updateTask(task, database);
			}
			//添加责任人关注人
			this.sysTaskPsnService.deleteByTaskId(taskId,database);
 			net.sf.json.JSONArray jsonarray = net.sf.json.JSONArray.fromObject(person);
			int len = jsonarray.size();
			if(len>0){
				for(int i = 0 ;i<len;i++){
					net.sf.json.JSONObject json = (net.sf.json.JSONObject)jsonarray.get(i);
					SysTaskPsn psn = new SysTaskPsn();
					int mId = Integer.valueOf(json.get("id").toString());
					psn.setNid(taskId);
					psn.setPsnType(Integer.valueOf(json.get("type").toString()));
					psn.setPsnId(mId);
					this.sysTaskPsnService.addTaskPsn(psn,database);
				}
			}
			//查询主子任务
//		    Map<String, Object> maps = taskService.queryTaskIds(taskId,database);
//		    String s = maps.get("ids").toString();
//		    String[] lists = s.split(",");
//			this.taskService.updateState(lists, database, SysTask.STATUS_NO);
		    List<SysTask> taskList = taskService.queryTaskByzid(taskId,database);//查询该主任务的所有主子任务
			this.taskService.addupdateState(taskList, database, SysTask.STATUS_NO);
			///////////////////////////////推送////////////////////
			Map map = taskService.queryByMember(taskId, database, SysTaskPsn.PSN_RESPONSIBILITY,SysTaskPsn.PSN_FOCUS_ON);
			String telzr = map.get("tels")==null?"":map.get("tels").toString();
			String memIdzr = map.get("ids")==null?"":map.get("ids").toString();
			String telsfocus = map.get("telsfocus")==null?"":map.get("telsfocus").toString();
			String memIdsfocus = map.get("idsfocus")==null?"":map.get("idsfocus").toString();
			String telstotal = telzr;
			if(!"".equals(telsfocus)){
				telstotal =telstotal+","+telsfocus;
			}
			SysMember member = memService.queryMemById(user.getMemId(),database);//查询当前用户信息
			String mTel = member.getMemberMobile();//当前用户号码
			String tels = telstotal.replaceAll(","+mTel+"|"+mTel+",","");//号码排除自己(不推送自己用)
			String memIds = memIdzr+","+memIdsfocus;
		    String ids = memIds.replaceAll( ","+user.getMemId()+"|"+user.getMemId()+",","");//id排除自己
		    
			if(!"".equals(memIdzr)){
				    if(!"".equals(ids)){
						List<SysChatMsg> sys = new ArrayList<SysChatMsg>();
						if(!"".equals(memIdzr)){
							for(String d :memIdzr.split(",")){
								if(!d.equals(user.getMemId().toString())){
									SysChatMsg scm = new SysChatMsg();
									scm.setAddtime(getDate());
									scm.setMemberId(user.getMemId());
									scm.setBelongId(taskId);
									scm.setTp("10");//催办消息
									scm.setBelongMsg("新任务");
									scm.setMsg(user.getMemberNm()+"：发起 ["+taskTitle+"] 任务，请完成");
									scm.setReceiveId(Integer.valueOf(d));
									sys.add(scm);
								}
							}
						}
						if(!"".equals(memIdsfocus)){
							for(String str :memIdsfocus.split(",")){
								if(!str.equals(user.getMemId().toString())){
									SysChatMsg scm = new SysChatMsg();
									scm.setAddtime(getDate());
									scm.setMemberId(user.getMemId());
									scm.setBelongId(taskId);
									scm.setTp("10");//催办消息
									scm.setBelongMsg("新任务");
									scm.setMsg(user.getMemberNm()+"：发起 ["+taskTitle+"] 任务，请关注");
									scm.setReceiveId(Integer.valueOf(str));
									sys.add(scm);
								}
							}
						}
						// 批量添加
						this.sysChatMsgWebService.addChatMsg(sys,database);
						SysTaskMsg msg = new SysTaskMsg();
						msg.setRemindTime(this.getDate());
						msg.setNid(taskId);
						msg.setTp("1");
						msg.setMemId(user.getMemId());
						msg.setContent(user.getMemberNm()+"：请完成 ["+taskTitle+"] 任务");
						this.taskService.addMsg(ids.indexOf(",")!=-1?ids.substring(0,ids.length()-1).split(","):ids.split(","),msg,database);
//						JpushClassify jc = new JpushClassify();
						jpushClassifies.toJpush(tels, CnlifeConstants.MODE2, CnlifeConstants.NEWMSG, null, 0, "提示",null);
						jpushClassifies2.toJpush(tels, CnlifeConstants.MODE2, CnlifeConstants.NEWMSG, null, 0, "提示",null);
			    }
				this.sendJsonResponse(response, "{\"state\":true,\"msg\":\"发布成功\"}");
			}else{
				sendWarm(response, "请添加责任人并重新保存");
				return;
			}
		}catch (Exception e) {
			sendException(response, e);
		}
	}
	/**
	 * 根据任务ID获取父任务ID
	 * @param taskId
	 * @param database
	 * @return
	 */
	/*public int queryParentfsfs(Integer taskId,String database){
		SysTask task = this.taskService.queryById(taskId,database);
		Integer id = task.getParentId();
		if(id!=null){
			return this.queryParent(id, database);
		}else{
			return taskId;
		}
	}
	*//**
	 * 根据任务ID获取子任务所有ID
	 * @param taskId
	 * @param database
	 * @return
	 *//*
	public void queryChila(Integer taskId,String database,List<Integer> lists){
		List<SysTask> tasks = this.taskService.queryChild(taskId,database);
		for(SysTask t : tasks){
			lists.add(t.getId());
			this.queryChila(t.getId(), database, lists);
		}
	}*/
	/**
	 * 说明： 易办事-修改任务
	 * @param token    令牌
	 * @param taskTitle 标题
	 * @param startTime 开始时间
	 * @param endTime	结束时间
	 * @param taskMemo	内容
	 * @param pid 创建人ID
	 * @param id 任务ID
	 */
	@RequestMapping("modTask")
	public void modTask(HttpServletRequest request, HttpServletResponse response, String token, Integer taskId,
                        String taskTitle, String startTime, String endTime, String taskMemo){
		try{
			if(!checkParam(response, token,taskId,taskTitle)){
				return;
			}
			OnlineMessage message = TokenServer.tokenCheck(token);
			if(message.isSuccess()==false){
				sendWarm(response, message.getMessage());
				return;
			}
			OnlineUser user = message.getOnlineMember();
			String database = user.getDatabase();
			SysTask task = this.taskService.queryById(taskId,database);
			if(!task.getCreateBy().equals(user.getMemId())){
				sendWarm(response, "不允许修改别人的任务");
				return;
			}
			if(task==null){
				sendWarm(response, "任务不存在");
				return;
			}
			task.setTaskTitle(taskTitle);
			task.setStartTime(startTime);
			task.setEndTime(endTime);
			task.setTaskMemo(taskMemo);
			int i = this.taskService.updateTask(task,database);
//			if(i>0){
//				String time = this.getFilePath();
//				List<Map<String,String>> pics = this.uploadFile(request, this.getPathUpload(request)+"/"+database+"/"+time,database+"/"+time);
//				if(pics.size()>0){
//					Map<String,String> map =pics.get(0);
//					SysTaskAttachment att = new SysTaskAttachment();
//					att.setNid(taskId);
//					att.setAttachName(map.get("name"));
//					att.setAttacthPath(map.get("path"));
//					sysTaskAttachmentService.addTaskAttachment(att,database);
//				}
				this.sendJsonResponse(response, "{\"state\":true,\"msg\":\"修改成功\"}");
//			}else{
//				sendWarm(response, "修改失败");
//			}
		}catch (Exception e) {
			sendWarm(response, "修改失败");
		}
	}
	
	/**
	 * @说明：易办事-删除任务
	 * @创建：作者:zrp 创建时间：2015-1-26
	 * @param taskId  任务ID
	 */
	@RequestMapping("delTaskDraft")
	public void delTaskDraft(HttpServletRequest request, HttpServletResponse response,
                             String token, String ids){
		try{
			if(!checkParam(response, token,ids)){
				return;
			}
			OnlineMessage message = TokenServer.tokenCheck(token);
			if(message.isSuccess()==false){
				sendWarm(response, message.getMessage());
				return;
			}
			String path = this.getPathUpload(request);
			String[] id = ids.split(",");
			for(String i :id){
				List<SysTaskAttachment> lists = this.sysTaskAttachmentService.queryForList(i,message.getOnlineMember().getDatabase());
				if(lists!=null&&lists.size()>0){
					for(SysTaskAttachment att : lists){
						this.delFile(path+"/"+att.getAttacthPath());
					}
				}
			}
			this.taskService.deleteTask(id,message.getOnlineMember().getDatabase());
			this.sendJsonResponse(response, "{\"state\":true,\"msg\":\"删除成功\"}");
		}catch (Exception e) {
			sendWarm(response, "查询失败");
		}
	}
	
	/**
	 * @说明：易办事-超期任务统计
	 * @创建：作者:zrp 创建时间：2015-1-26
	 * @param taskId  任务ID
	 */
	@RequestMapping("queryUnfinished")
	public void queryUnfinished(HttpServletRequest request, HttpServletResponse response,
                                String token, Integer pageNo, Integer pageSize, Integer state){
		Page page = new Page();
		try{
			if(!checkParam(response, token,pageNo)){
				return;
			}
			if(StrUtil.isNull(pageSize)){
				pageSize=10;
			}
			if(StrUtil.isNull(state)){
				state=1;
			}
			OnlineMessage message = TokenServer.tokenCheck(token);
			if(message.isSuccess()==false){
				sendWarm(response, message.getMessage());
				return;
			}
			String database = message.getOnlineMember().getDatabase();
			SysMember member = memService.queryMemById(message.getOnlineMember().getMemId(), database);
			if(null!=member.getBranchId() && !"0".equals(member.getBranchId())){
				page = this.taskService.queryUnfinished(state,database,member.getBranchId(),pageNo,pageSize);
			}
			JSONObject json = new JSONObject();
			json.put("state", true);
			json.put("msg", "查询成功");
			json.put("pageNo", pageNo);
			json.put("pageSize", pageSize);
			json.put("total", page.getTotal());
			json.put("totalPage", page.getTotalPage());
			json.put("rows", page.getRows());
			this.sendJsonResponse(response, json.toString());
		}catch (Exception e) {
			sendWarm(response, "查询失败");
		}
	}
	/**
	 * @说明：易办事-团队执行力统计
	 * @创建：作者:zrp 创建时间：2015-1-26
	 * @param taskId  任务ID
	 */
	@RequestMapping("queryTeam")
	public void queryTeam(HttpServletRequest request, HttpServletResponse response,
                          String token, Integer pageNo, Integer pageSize, Integer state){
		Page page = new Page();
		try{
			if(!checkParam(response, token,pageNo)){
				return;
			}
			if(StrUtil.isNull(pageSize)){
				pageSize=10;
			}
			if(StrUtil.isNull(state)){
				state=1;
			}
			OnlineMessage message = TokenServer.tokenCheck(token);
			if(message.isSuccess()==false){
				sendWarm(response, message.getMessage());
				return;
			}
			
			String database = message.getOnlineMember().getDatabase();
			SysMember member = memService.queryMemById(message.getOnlineMember().getMemId(), database);
			if(null!=member.getBranchId() && !"0".equals(member.getBranchId())){
				page = this.taskService.queryTeam(state,database,member.getBranchId(),pageNo,pageSize);
			}
			JSONObject json = new JSONObject();
			json.put("state", true);
			json.put("msg", "查询成功");
			json.put("pageNo", pageNo);
			json.put("pageSize", pageSize);
			json.put("total", page.getTotal());
			json.put("totalPage", page.getTotalPage());
			json.put("rows", page.getRows());
			this.sendJsonResponse(response, json.toString());
		}catch (Exception e) {
			sendWarm(response, "查询失败");
		}
	}
	/**
	 * @说明：易办事-团队工作负荷统计
	 * @创建：作者:zrp 创建时间：2015-1-26
	 * @param taskId  任务ID
	 */
	@RequestMapping("queryLoad")
	public void queryLoad(HttpServletRequest request, HttpServletResponse response,
                          String token, Integer pageNo, Integer pageSize, Integer state){
		Page page = new Page();
		try{
			if(!checkParam(response, token,pageNo)){
				return;
			}
			if(StrUtil.isNull(pageSize)){
				pageSize=10;
			}
			if(StrUtil.isNull(state)){
				state=1;
			}
			OnlineMessage message = TokenServer.tokenCheck(token);
			if(message.isSuccess()==false){
				sendWarm(response, message.getMessage());
				return;
			}
			String database = message.getOnlineMember().getDatabase();
			SysMember member = memService.queryMemById(message.getOnlineMember().getMemId(), database);
			if(null!=member.getBranchId() && !"0".equals(member.getBranchId())){
				page = this.taskService.queryLoad(state,database,member.getBranchId(),pageNo,pageSize);
			}
			JSONObject json = new JSONObject();
			json.put("state", true);
			json.put("msg", "查询成功");
			json.put("pageNo", pageNo);
			json.put("pageSize", pageSize);
			json.put("total", page.getTotal());
			json.put("totalPage", page.getTotalPage());
			json.put("rows", page.getRows());
			this.sendJsonResponse(response, json.toString());
		}catch (Exception e) {
			sendWarm(response, "查询失败");
		}
	}
	
	/**
	 * @说明：易办事-关注任务查询(超期)
	 * @创建：作者:zrp 创建时间：2015-1-26
	 * @param taskId  任务ID
	 */
	@RequestMapping("queryFocus")
	public void queryFocus(HttpServletRequest request, HttpServletResponse response,
                           String token, Integer pageNo, Integer pageSize){
		try{
			if(!checkParam(response, token,pageNo)){
				return;
			}
			if(StrUtil.isNull(pageSize)){
				pageSize=10;
			}
			OnlineMessage message = TokenServer.tokenCheck(token);
			if(message.isSuccess()==false){
				sendWarm(response, message.getMessage());
				return;
			}
			OnlineUser user = message.getOnlineMember();
			String database = user.getDatabase();
			Page page = this.taskService.queryFocus(user.getMemId(),database,pageNo,pageSize,1);
			JSONObject json = new JSONObject();
			json.put("state", true);
			json.put("msg", "查询成功");
			json.put("pageNo", pageNo);
			json.put("pageSize", pageSize);
			json.put("total", page.getTotal());
			json.put("totalPage", page.getTotalPage());
			json.put("rows", page.getRows());
			this.sendJsonResponse(response, json.toString());
		}catch (Exception e) {
			sendWarm(response, "查询失败");
		}
	}
	/**
	 * @说明：易办事-关注任务查询(未超期)
	 * @创建：作者:zrp 创建时间：2015-1-26
	 * @param taskId  任务ID
	 */
	@RequestMapping("queryFocusno")
	public void queryFocusno(HttpServletRequest request, HttpServletResponse response,
                             String token, Integer pageNo, Integer pageSize){
		try{
			if(!checkParam(response, token,pageNo)){
				return;
			}
			if(StrUtil.isNull(pageSize)){
				pageSize=10;
			}
			OnlineMessage message = TokenServer.tokenCheck(token);
			if(message.isSuccess()==false){
				sendWarm(response, message.getMessage());
				return;
			}
			OnlineUser user = message.getOnlineMember();
			String database = user.getDatabase();
			Page page = this.taskService.queryFocus(user.getMemId(),database,pageNo,pageSize,2);
			JSONObject json = new JSONObject();
			json.put("state", true);
			json.put("msg", "查询成功");
			json.put("pageNo", pageNo);
			json.put("pageSize", pageSize);
			json.put("total", page.getTotal());
			json.put("totalPage", page.getTotalPage());
			json.put("rows", page.getRows());
			this.sendJsonResponse(response, json.toString());
		}catch (Exception e) {
			sendWarm(response, "查询失败");
		}
	}
	/**
	 * @说明：易办事-草稿任务查询
	 * @创建：作者:zrp 创建时间：2015-1-26
	 * @param taskId  任务ID
	 */
	@RequestMapping("queryDraft")
	public void queryDraft(HttpServletRequest request, HttpServletResponse response,
                           String token, Integer pageNo, Integer pageSize, String title){
		try{
			if(!checkParam(response, token,pageNo)){
				return;
			}
			if(StrUtil.isNull(pageSize)){
				pageSize=10;
			}
			OnlineMessage message = TokenServer.tokenCheck(token);
			if(message.isSuccess()==false){
				sendWarm(response, message.getMessage());
				return;
			}
			OnlineUser user = message.getOnlineMember();
			String database = user.getDatabase();
			
			Page page = this.taskService.queryDraft(user.getMemId(),title,pageNo,pageSize,database);
			JSONObject json = new JSONObject();
			json.put("state", true);
			json.put("msg", "查询成功");
			json.put("pageNo", pageNo);
			json.put("pageSize", pageSize);
			json.put("total", page.getTotal());
			json.put("totalPage", page.getTotalPage());
			json.put("rows", page.getRows());
			this.sendJsonResponse(response, json.toString());
		}catch (Exception e) {
			sendWarm(response, "查询失败");
		}
	}
	/**
	  *@see 删除任务
	  *@param response
	  *@param token
	  *@param taskIds 用“，”隔开
	  *@创建：作者:YYP		创建时间：2015-6-3
	 */
	@RequestMapping("delTask")
	public void delTask(HttpServletResponse response, String token, String taskIds){
		if(!checkParam(response, token,token,taskIds)){
			return;
		}
		try{
			OnlineMessage message = TokenServer.tokenCheck(token);
			if(message.isSuccess()==false){
				sendWarm(response, message.getMessage());
				return;
			}
			OnlineUser user = message.getOnlineMember();
			String database = user.getDatabase();
			taskService.deleteTaskById(taskIds,database);
			sendSuccess(response, "删除成功");
		}catch (Exception e) {
			sendException(response, e);
		}
	}
	
	
	
	//子任务的添加整合
	@RequestMapping("addTaskTo")
	public void addTaskTo(HttpServletRequest request, HttpServletResponse response, String token,
                          String taskTitle, String startTime, String endTime, String taskMemo, Integer parentId,
                          String person, Integer remind1, Integer remind2, Integer remind3, Integer remind4){
		try{
			if(!checkParam(response, token,taskTitle,person)){
				return;
			}
			OnlineMessage message = TokenServer.tokenCheck(token);
			if(message.isSuccess()==false){
				sendWarm(response, message.getMessage());
				return;
			}
			OnlineUser user = message.getOnlineMember();
			String database = user.getDatabase();
			SysTask task = new SysTask();
			task.setTaskTitle(taskTitle);
			task.setCreateTime(new DateTimeUtil().getDateToStr(new Date(),"yyyy-MM-dd HH:mm"));
			task.setStartTime(startTime);
			task.setEndTime(endTime);
			task.setTaskMemo(taskMemo);
			if(!StrUtil.isNull(parentId)){
				task.setParentId(parentId);
			}
			task.setCreateBy(user.getMemId());
			task.setStatus(SysTask.STATUS_DRAFT);
			task.setPercent(0);
			if(null==remind1){
				task.setRemind1(5);
			}else{
				task.setRemind1(remind1);
			}
			if(null==remind1){
				task.setRemind2(10);
			}else{
				task.setRemind2(remind2);
			}
			if(null==remind1){
				task.setRemind3(20);
			}else{
				task.setRemind3(remind3);
			}
			if(null==remind1){
				task.setRemind4(30);
			}else{
				task.setRemind4(remind4);
			}
			Integer tId = this.taskService.addTask2(task,database,person);
			
//			if(id>0){
//				String time = getFilePath();
//				List<Map<String,String>> pics = this.uploadFile(request, this.getPathUpload(request)+"/"+database+"/"+time,database+"/"+time);
//				if(pics.size()>0){
//					Map<String,String> map =pics.get(0);
//					SysTaskAttachment att = new SysTaskAttachment();
//					att.setNid(id);
//					att.setAttachName(map.get("name"));
//					att.setAttacthPath(time+map.get("/path"));
//					sysTaskAttachmentService.addTaskAttachment(att,database);
//				}
				this.sendJsonResponse(response, "{\"state\":true,\"msg\":\"添加成功\",\"taskid\":\""+tId+"\"}");
//			}else{
//				sendWarm(response, "添加失败");
//			}
		}catch (Exception e) {
			e.printStackTrace();
			sendWarm(response, "添加失败");
		}
	}
	//修改主子任务
	@RequestMapping("modTaskTo")
	public void modTaskTo(HttpServletRequest request, HttpServletResponse response, String token, Integer taskId,
                          String taskTitle, String startTime, String endTime, String taskMemo, String person, Integer remind1,
                          Integer remind2, Integer remind3, Integer remind4){
		try{
			if(!checkParam(response, token,taskId,taskTitle,person)){
				return;
			}
			OnlineMessage message = TokenServer.tokenCheck(token);
			if(message.isSuccess()==false){
				sendWarm(response, message.getMessage());
				return;
			}
			OnlineUser user = message.getOnlineMember();
			String database = user.getDatabase();
			SysTask task = this.taskService.queryById(taskId,database);
			if(!task.getCreateBy().equals(user.getMemId())){
				sendWarm(response, "不允许修改别人的任务");
				return;
			}
			if(null==task){
				sendWarm(response, "任务不存在");
				return;
			}
			task.setTaskTitle(taskTitle);
			task.setStartTime(startTime);
			task.setEndTime(endTime);
			task.setTaskMemo(taskMemo);
			task.setRemind1(remind1);
			task.setRemind2(remind2);
			task.setRemind3(remind3);
			task.setRemind4(remind4);
			int i = this.taskService.addTaskTo(task,database,person);
			
//			if(i>0){
//				String time = this.getFilePath();
//				List<Map<String,String>> pics = this.uploadFile(request, this.getPathUpload(request)+"/"+database+"/"+time,database+"/"+time);
//				if(pics.size()>0){
//					Map<String,String> map =pics.get(0);
//					SysTaskAttachment att = new SysTaskAttachment();
//					att.setNid(taskId);
//					att.setAttachName(map.get("name"));
//					att.setAttacthPath(map.get("path"));
//					sysTaskAttachmentService.addTaskAttachment(att,database);
//				}
				this.sendJsonResponse(response, "{\"state\":true,\"msg\":\"修改成功\"}");
//			}else{
//				sendWarm(response, "修改失败");
//			}
		}catch (Exception e) {
			sendWarm(response, "修改失败");
		}
	}
	/**
	  *@see 修改任务结束时间
	  *@param request
	  *@param response
	  *@param token
	  *@param taskId
	  *@创建：作者:YYP		创建时间：2015-6-18
	 */
	@RequestMapping("updateTime")
	public void updateEndtime(HttpServletRequest request, HttpServletResponse response, String token, Integer taskId, String startTime, String endTime){
		try{
			if(!checkParam(response, token,taskId,startTime,endTime)){
				return;
			}
			OnlineMessage message = TokenServer.tokenCheck(token);
			if(message.isSuccess()==false){
				sendWarm(response, message.getMessage());
				return;
			}
			OnlineUser user = message.getOnlineMember();
			String datasource = user.getDatabase();
			SysTask task = taskService.queryById(taskId, datasource);
			if(task.getStatus()!=3 || (null!=task.getParentId() && task.getParentId()!=0) ){//不是草稿任务或者主任务
				sendWarm(response, "只能修改草稿中的主任务");
				return;
			}
			task.setStartTime(startTime);
			task.setEndTime(endTime);
			taskService.updateTask(task, datasource);//更新任务
			sendSuccess(response, "修改任务时间成功");
		}catch (Exception e) {
			sendException(response, e);
		}
	}
	//统计
	@RequestMapping("taskzhixingpages")
	public String taskzhixingpages(HttpServletResponse response, HttpServletRequest request, Model model, String token){
		model.addAttribute("token",token);
		if(!checkParam(response, token)){
			model.addAttribute("msg","参数不完整");
			return "system/task/taskzhixingpagesPhone";
		}
		try{
			OnlineMessage message = TokenServer.tokenCheck(token);
			if(message.isSuccess()==false){
				sendWarm(response, message.getMessage());
				model.addAttribute("msg","请先登录");
				return "system/task/taskzhixingpagesPhone";
			}
			OnlineUser user = message.getOnlineMember();
			String month = request.getParameter("month");
			String year = request.getParameter("year");
			String date = request.getParameter("date");
			if(StrUtil.isNull(month)){
				try {
					month = DateTimeUtil.getDateToStr(new Date(),"yyyyMM");
					year =  DateTimeUtil.getDateToStr(new Date(),"yyyy");
					date =  DateTimeUtil.getDateToStr(new Date(),"MM");
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			List<Map<String,Object>> list = this.taskService.queryTaskZhiXing(user.getDatabase(),user.getMemId(),month);
			request.setAttribute("list", list);
			request.setAttribute("month",month);
			request.setAttribute("year", year);
			request.setAttribute("date", date);
		}catch (Exception e) {
			model.addAttribute("msg","查询出错");
			return "system/task/taskzhixingpagesPhone";
		}
		return "system/task/taskzhixingpagesPhone";
	}
}
