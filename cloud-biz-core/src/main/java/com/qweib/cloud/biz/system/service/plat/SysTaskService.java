package com.qweib.cloud.biz.system.service.plat;


import com.qweib.cloud.core.domain.*;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.repository.company.SysTaskDao;
import com.qweib.cloud.repository.company.SysTaskPsnDao;
import com.qweib.cloud.utils.DateTimeUtil;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * 说明：任务表Service
 * 
 * @创建：作者:zrp 创建时间：2015-1-26
 * @修改历史： [序号](zrp 2015-1-26)<修改说明>
 */
@Service
public class SysTaskService {
	
	@Resource
	private SysTaskDao taskDao;
	@Resource
	private SysTaskPsnDao sysTaskPsnDao;
	@Resource
	private SysTaskPsnDao taskPsnDao;
	/**
	 * 添加任务
	 * @param task
	 * @return
	 */
	public int addTask(SysTask task, String database){
		Integer parentId = null;
		try{
			Integer tid = taskDao.addTask(task,database);
			if(null!=task.getParentId()){
				parentId=task.getParentId();
			}
			taskDao.updateStatePath(parentId,tid,database);
			return tid;
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}
	
	public int addTask2(SysTask task,String database,String person){
		Integer parentId = null;
		try{
			Integer tid = taskDao.addTask(task,database);
			if(null!=task.getParentId()){
				parentId=task.getParentId();
			}
			taskDao.updateStatePath(parentId,tid,database);
			
			if(!StrUtil.isNull(person)){//添加责任人或关注人
	 			net.sf.json.JSONArray jsonarray = net.sf.json.JSONArray.fromObject(person);
				int len = jsonarray.size();
				if(len>0){
					for(int i = 0 ;i<len;i++){
						net.sf.json.JSONObject json = (net.sf.json.JSONObject)jsonarray.get(i);
						SysTaskPsn psn = new SysTaskPsn();
						int id = Integer.valueOf(json.get("id").toString());
						psn.setNid(tid);
						psn.setPsnType(Integer.valueOf(json.get("type").toString()));
						psn.setPsnId(id);
						taskPsnDao.addTaskPsn(psn,database);
					}
				}
			}
			return tid;
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 * 根据ID查询任务
	 * @param id
	 * @return
	 */
	public SysTask queryById(Integer id,String database) {
		try{
			return taskDao.queryById(id,database);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}
	public SysTask queryById(Integer id,String database,Integer memId) {
		try{
			SysTask task = taskDao.queryById(id,database,memId);
			Map map = this.taskDao.queryByTaskMem(id,database,SysTaskPsn.PSN_RESPONSIBILITY);
			if(null!=map.get("ids") && map.size()!=0){
				task.setMemberIds(map.get("ids").toString());
				task.setMemberNm(map.get("names").toString());
			}
			Map map2 = this.taskDao.queryByTaskMem(id,database,SysTaskPsn.PSN_FOCUS_ON);
			if(null!=map2.get("ids") && map2.size()!=0){
				task.setSupervisorIds(map2.get("ids").toString());
				task.setSupervisor(map2.get("names").toString());
			}
			task.setMemList(taskDao.queryMemList(id,database,SysTaskPsn.PSN_FOCUS_ON));
			return task;
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 * 修改任务
	 * @param task
	 * @param database 
	 * @return
	 */
	public int updateTask(SysTask task, String database) {
		try{
			return taskDao.updateTask(task,database);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}
	
	public int addTaskTo(SysTask task, String database,String person) {
		try{
			int a = taskDao.updateTask(task,database);
			//更新责任人关注人
			if(!StrUtil.isNull(person)){
				this.taskPsnDao.deleteByTaskId(task.getId(),database);
				net.sf.json.JSONArray jsonarray = net.sf.json.JSONArray.fromObject(person);
				int len = jsonarray.size();
				if(len>0){
					for(int i = 0 ;i<len;i++){
						net.sf.json.JSONObject json = (net.sf.json.JSONObject)jsonarray.get(i);
						SysTaskPsn psn = new SysTaskPsn();
						int id = Integer.valueOf(json.get("id").toString());
						psn.setNid(task.getId());
						psn.setPsnType(Integer.valueOf(json.get("type").toString()));
						psn.setPsnId(id);
						this.taskPsnDao.addTaskPsn(psn,database);
					}
				}
			}
			return a;
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}
	
	
	/**
	 * 根据ID删除任务信息
	 * @param i
	 */
	public int[] deleteTask(Integer[] id, String database) {
		try{
			return taskDao.deleteTask(id,database);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}
	public int[] deleteTask(String[] id, String database) {
		try{
			return taskDao.deleteTask(id,database);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 * 分页查询任务信息
	 * @param title
	 * @param pageNo
	 * @param pageSize
	 * @param type 1 发布人 2 责任人 3 关注人
	 * @return
	 */
	public Page queryPageByTitle(String title, Integer pageNo, Integer pageSize,String database,Integer state,Integer id,String type) {
		String tp = "";
		try{
			Page p = new Page();
			//return taskDao.queryPageByTitle(title, pageNo, pageSize, database, state, id, type);
			if("1".equals(type)){//发布人
				p = taskDao.queryPageForCreateby(pageNo, pageSize, database, state, id);
			}else if("2".equals(type) || "3".equals(type)){//责任人或关注人
				if("2".equals(type)){
					tp="1";
				}else if("3".equals(type)){
					tp="2";
				}
				p = taskDao.queryPageForPsnId(pageNo, pageSize, database, state, id,tp);
			}else {//默认查询全部
				p = taskDao.queryPageByTitle(pageNo, pageSize, database, state, id);
			}
			return p;
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}
	
	/**
	 * 根据父ID获取子任务信息
	 * @param pageNo
	 * @param pageSize
	 * @return
	 */
	public Page queryPageById(Integer taskId, Integer pageNo, Integer pageSize, String database, Integer state) {
		try{
			return taskDao.queryPageById(taskId, pageNo, pageSize,database,state);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}
	public List<SysTask> queryChild(Integer taskId, String database) {
		try{
			return taskDao.queryChild(taskId,database);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 * 添加任务进度
	 * @param feed
	 * @param database
	 */
	public int addTask(SysTaskFeedback feed, String database) {
		try{
			Integer info = taskDao.addTask(feed,database);
			if(100==feed.getPersent()){
				taskDao.updateState(feed.getNid(),database,SysTask.STATUS_YES,new SimpleDateFormat("yyyy-MM-dd HH:mm").format(new Date()));
			}
			return info;
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 * 根据任务ID修改状态
	 * @param feed
	 * @param database
	 * @param state 
	 */
	public Integer updateState(Integer taskId, String database, Integer state,String date) {
		try{
			return taskDao.updateState(taskId,database,state,date);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}
	//修改任务为进行中状态，并添加备份表数据
	public void addupdateState(List<SysTask> taskList, String database,
			Integer state) {
//		List<SysTaskIng> taskIngList = null;
		List<Integer> tids = new ArrayList<Integer>();
		try{
//			Map<String, Object> maps = taskDao.queryTaskIds(taskId,database);//查询该主任务的所有主子任务id
//		    String s = maps.get("ids").toString();
//		    String[] lists = s.split(",");
//		    System.out.println("s2");
//			taskDao.updateState(lists,database,state);
		    for (SysTask sysTask : taskList) {
//		    	SysTaskIng taskIng = new SysTaskIng(sysTask);//构造对象(time还未加入)
//		    	taskIngList.add(taskIng);
		    	tids.add(sysTask.getId());
//		    	taskDao.addTaskIng(sysTask,database);
			}
			taskDao.updatetStates(tids,database,state);
//			taskDao.addTaskIngBatch(taskList,database);
//			StringBuffer sql = new StringBuffer();
			String [] sqlstr = new String[5];
			for(int i=0;i<taskList.size();i++){
				SysTask t = taskList.get(i);
				String startTime = t.getStartTime();
				String endTime = t.getEndTime();
				String time1 = DateTimeUtil.getTimePercent(startTime,endTime,t.getRemind1());
				String time2 = DateTimeUtil.getTimePercent(startTime,endTime,t.getRemind2());
				String time3 = DateTimeUtil.getTimePercent(startTime,endTime,t.getRemind3());
				String time4 = DateTimeUtil.getTimePercent(startTime,endTime,t.getRemind4());
				String time5 = DateTimeUtil.getTimeMinus(endTime,5);
				String str = "insert into "+database+".sys_task_ing(task_id,task_title,create_by,time1,remind1) ";
				Integer id = t.getId();
				String taskTitle = t.getTaskTitle();
				Integer createBy = t.getCreateBy();//执行人
				String sql0 =str+" values("+id+",'"+taskTitle+"',"+createBy+",'"+time1+"',"+t.getRemind1()+"); ";
				sqlstr[0] = sql0;//time1
				String sql1 =str+" values("+id+",'"+taskTitle+"',"+createBy+",'"+time2+"',"+t.getRemind2()+"); ";
				sqlstr[1] = sql1;//time2
				String sql2 =str+" values("+id+",'"+taskTitle+"',"+createBy+",'"+time3+"',"+t.getRemind3()+"); ";
				sqlstr[2] = sql2;//time3
				String sql3 =str+" values("+id+",'"+taskTitle+"',"+createBy+",'"+time4+"',"+t.getRemind4()+"); ";
				sqlstr[3] = sql3;//time4
				String sql4 =str+" values("+id+",'"+taskTitle+"',"+createBy+",'"+time5+"',-1); ";
				sqlstr[4] = sql4;//time5
			}
				taskDao.updateTaskIngBySql(sqlstr);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 * 根据任务ID查询所有子任务
	 * @param feed
	 * @param database
	 * @param state 
	 */
	public List<SysTask> queryForListByPid(Integer taskId, String database) {
		try{
			return taskDao.queryForListByPid(taskId,database);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 * copy
	 * @param database 
	 * @param taskId 
	 */
	/*public int addTaskCopy(HttpServletRequest request,String path,Integer taskId, String database,String time,Integer mid){
		try{
			SysTask task = this.taskDao.queryById(taskId, database);
			task.setCreateBy(mid);
			task.setStatus(SysTask.STATUS_DRAFT);
			int parentId = this.taskDao.addTask(task,database);
			this.copyAll(request,taskId, database,parentId,time,path,mid);
			return parentId;
		}catch (Exception e) {
			throw new DaoException(e);
		}
		
	}*/
	/**
	 * 递归复制任务
	 * @param taskId
	 * @param database
	 * @param parentId
	 */
	/*public void copyAll(HttpServletRequest request,Integer taskId,String database,Integer parentId,String time,String path,Integer mid){
		try{
			List<SysTask> list = this.taskDao.queryForListByPid(taskId,database);
			if(list!=null && list.size()>0){
				for(SysTask task : list){
					task.setParentId(parentId);
					task.setStatus(SysTask.STATUS_DRAFT);
					int id = this.taskDao.addTask(task,database);
					List<SysTaskPsn> psns = this.sysTaskPsnDao.queryMemAll(taskId, database);
					for(SysTaskPsn psn:psns){
						psn.setNid(id);
						this.sysTaskPsnDao.addTaskPsn(psn, database);
					}
					this.copyAll(request,task.getId(), database, id,time,path,mid);
				}
			}
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}*/
//	List<SysTaskAttachment> attlist = this.sysTaskAttachmentDao.queryForList(task.getId().toString());
//	if(attlist!=null && attlist.size()>0){
//		for(SysTaskAttachment att : attlist){
//			String file = att.getAttacthPath();
//			String ext = file.substring(file.indexOf("."));
//			String filename = System.currentTimeMillis()+StrUtil.generateRandomString(5, 2)+ext;
//			String sourceFile = path +"/"+file;
//			String targetFile = path +"/"+time +"/"+filename;
//			FileUtil.copyFile(new File(sourceFile), new File(targetFile));
//			
//			att.setNid(id);
//			this.sysTaskAttachmentDao.addTaskAttachment(att);
//		}
//	}
	/***
	 * 根据任务ID获取责任人和关注人
	 * @param taskId
	 * @param dateBase
	 * @return
	 */
	public Map<String,Object> queryByMember(Integer taskId, String dateBase,Integer psnType,Integer focus) {
		try{
			return this.taskDao.queryByMember(taskId,dateBase,psnType,focus);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/***
	 * pc端根据任务ID获取责任人和关注人
	 * @param taskId
	 * @param dateBase
	 * @return
	 */
	public Map<String,Object> queryByMember2(Integer taskId, String dateBase) {
		try{
			return this.taskDao.queryByMember2(taskId,dateBase);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}

	//获取发布者和关注人
	public Map querycreatebyfocus(Integer taskId, String database,
			Integer pSNFOCUSON) {
		try{
			return taskDao.querycreatebyfocus(taskId,database,pSNFOCUSON);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 * 任务催办
	 * @param id
	 * @param msg
	 */
	public void addMsg(String[] id, SysTaskMsg msg, String database) {
		try{
			this.taskDao.addMsg(id,msg,database);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 * 统计超期任务
	 * @param dateBase
	 * @param pageNo
	 * @param pageSize
	 * @return
	 */
	public Page queryUnfinished(Integer state,String database,Integer branchId, Integer pageNo,
			Integer pageSize) {
		try{
			return this.taskDao.queryUnfinished(state,database,branchId, pageNo, pageSize);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 * 团队执行力统计
	 * @param dateBase
	 * @param pageNo
	 * @param pageSize
	 * @return
	 */
	public Page queryTeam(Integer state,String database,Integer branchId, Integer pageNo,
			Integer pageSize) {
		try{
			return this.taskDao.queryTeam(state,database,branchId, pageNo, pageSize);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 * 易办事-团队工作负荷统计
	 * @param dateBase
	 * @param pageNo
	 * @param pageSize
	 * @return
	 */
	public Page queryLoad(Integer state,String database,Integer branchId, Integer pageNo,
			Integer pageSize) {
		try{
			return this.taskDao.queryLoad(state,database, branchId,pageNo, pageSize);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 * 分页查询任务
	 */
	public Page queryPage(SysTask task, Integer pageNo, Integer pageSize,String database,Integer memId) {
		try{
			return this.taskDao.queryPage(task, pageNo, pageSize,database,memId);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 * 根据任务名称查询任务
	 * @param taskTitle
	 * @param database
	 * @return
	 */
	public SysTask queryByTitle(String taskTitle, String database) {
		try{
			return this.taskDao.queryByTitle(taskTitle,database);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 * @说明：易办事-关注任务查询
	 * @创建：作者:zrp 创建时间：2015-1-26
	 * @param taskId  任务ID
	 */
	public Page queryFocus(Integer id,String dateBase, Integer pageNo, Integer pageSize,Integer state) {
		try{
			return this.taskDao.queryFocus(id,dateBase,pageNo,pageSize,state);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 * 查询需要推送的数据
	 * @param datasource
	 * @return
	 */
	public List<SysTask> queryPush(String datasource) {
		try{
			return this.taskDao.queryPush(datasource);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}
	//查询需要推送的进行中任务
	public List<SysTaskIng> queryPushTaskIng(String datasource) {
		try{
			return this.taskDao.queryPushTaskIng(datasource);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 * 分页查询草稿箱信息
	 * @param title 
	 * @param pageNo
	 * @param pageSize
	 * @param database
	 * @return
	 */
	public Page queryDraft(Integer uid,String title, Integer pageNo, Integer pageSize, String database) {
		try{
			return this.taskDao.queryDraft(uid,title,pageNo,pageSize,database);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}
	public Map queryByTaskIdNot(Integer taskId, String database) {
		try{
			return this.taskDao.queryByTaskIdNot(taskId,database);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	  *@see 搜索任务(包括已办、未办、草稿)
	  *@param searchContent
	  *@param pageNo
	  *@param i
	  *@param database
	  *@param memId
	  *@return
	  *@创建：作者:YYP		创建时间：2015-5-19
	 */
	public Page queryModelTask(String searchContent, Integer pageNo, Integer pageSize,
			String datasource, Integer memId) {
		try{
			return taskDao.queryModelTask(searchContent,pageNo,pageSize,datasource,memId);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	  *@see 删除任务
	  *@param taskId
	  *@param database
	  *@创建：作者:YYP		创建时间：2015-6-3
	 */
	public void deleteTaskById(String taskIds, String datasource) {
		try{
			taskDao.deleteTaskById(taskIds,datasource);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/*public Map<String, Object> queryTaskIds(Integer taskId, String datasource) {
		try{
			return taskDao.queryTaskIds(taskId,datasource);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}*/

	/**
	 * 删除进行中子表任务
	 */
	public void deleteTaskIng(Integer taskId, String database) {
		try{
			taskDao.deleteTaskIng(taskId,database);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}

	public List<SysTask> queryTaskByzid(Integer taskId, String database) {
		try{
			return taskDao.queryTaskByzid(taskId,database);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}

	//查询任务的开始和结束时间
	public Map<String, Object> queryParentTime(Integer parentId, String database) {
		try{
			return taskDao.queryParentTime(parentId,database);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}

	//查询任务的附件
	public List<SysTaskAttachment> queryTaskattachment(Integer tid, String database) {
		try{
			return taskDao.queryTaskattachment(tid,database);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}

	//查询主子任务
	public Page queryTaskByTypeId(String type, Integer taskId,String database,Integer page,Integer rows) {
		try{
			return taskDao.queryTaskByTypeId(type,taskId,database,page,rows);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}

	//查询子任务
	public List<SysTask> querChildTask(Integer id, String datasource) {
		try{
			return taskDao.querChildTask(id,datasource);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}
	//修改主任务的persent进度
	public void updatePersent(Integer nid,Integer persent, String datasource) {
		try{
			 taskDao.updatePersent(nid,persent,datasource);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}

	/**
	 * 查询任务执行情况
	 * @param database
	 * @param memId
	 * @return
	 */
	public List<Map<String,Object>> queryTaskZhiXing(String database,Integer memId,String month){
		try{
			
			List<Map<String,Object>> mapList = taskDao.queryTaskZhiXing( database, memId,month);
			List<Map<String,Object>> newList = new ArrayList<Map<String,Object>>();
			if(mapList!=null&&mapList.size()>0){
				for(int i=0;i<mapList.size();i++){
					Map<String,Object> map = mapList.get(i);
				    Object cqCount = map.get("cq_count");
				    Object total = map.get("total");
				    Double cq = 0.0;
				    if(!StrUtil.isNull(cqCount)){
				    	cq = Double.valueOf(cqCount+"");
				    }
				    if(cq>0){
				    	map.put("cq_count", StrUtil.convertDbToInt(cqCount));
				    	map.put("total", StrUtil.convertDbToInt(total));
				    	newList.add(map);
				    }
				}
			}
			return newList;
		}catch(Exception e){
			throw new DaoException(e);
		}
	}

	//删除任务备份表数据
	public void deleteTaskIngs(String tIds, String database) {
		try{
			taskDao.deleteTaskIngs(tIds,database);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}

	//查询所有子任务时间是否超出主任务
	public Integer queryIfOutTime(String startTime, String endTime,Integer taskId,
			String database) {
		try{
			return taskDao.queryIfOutTime(startTime,endTime,taskId,database);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}

	//根据任务id查询责任人
	public Integer queryPsnId(Integer taskId, String database) {
		// TODO Auto-generated method stub
		try{
			return taskDao.queryPsnId(taskId,database);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}
	
}
