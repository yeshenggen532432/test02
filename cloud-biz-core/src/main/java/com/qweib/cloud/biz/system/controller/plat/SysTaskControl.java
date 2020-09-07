package com.qweib.cloud.biz.system.controller.plat;

import com.qweib.cloud.biz.common.CnlifeConstants;
import com.qweib.cloud.biz.system.jpush.JpushClassifies;
import com.qweib.cloud.biz.system.jpush.JpushClassifies2;
import com.qweib.cloud.biz.system.service.plat.*;
import com.qweib.cloud.biz.system.service.ws.SysChatMsgService;
import com.qweib.cloud.core.domain.*;

import com.qweib.cloud.core.domain.SysLoginInfo;

import com.qweib.cloud.biz.common.GeneralControl;
import com.qweib.cloud.core.exception.DaoException;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.qweib.cloud.utils.DateTimeUtil;
import com.qweib.cloud.utils.JsonUtil;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartFile;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * 说明：易办事Control
 *
 * @创建：作者:zrp 创建时间：2015-02-03
 * @修改历史： [序号](zrp 2015 - 02 - 03)<修改说明>
 */
@Controller
@RequestMapping("/manager")
public class SysTaskControl extends GeneralControl {

    @Resource
    private SysTaskService taskService;
    @Resource
    private SysTaskAttachmentService sysTaskAttachmentService;
    @Resource
    private SysTaskFeedBackService sysTaskFeedBackService;
    @Resource
    private SysTaskPsnService sysTaskPsnService;
    @Resource
    private SysMemberService memberService;
    @Resource
    private SysChatMsgService sysChatMsgWebService;
    @Resource
    private JpushClassifies jpushClassifies;
    @Resource
    private JpushClassifies2 jpushClassifies2;

    /**
     * 说明：跳转任务页面
     *
     * @创建：作者:zrp 创建时间：2015-02-03
     * @修改历史： [序号](zrp 2015 - 02 - 03)<修改说明>
     */
    @RequestMapping("toquerytaskall")
    public String toList(HttpServletRequest request, Model model, Integer id) {
        SysLoginInfo info = getInfo(request);
        if (!StrUtil.isNull(id)) {
            SysTask task = this.taskService.queryById(id, info.getDatasource());
            model.addAttribute("parentId", id);
            model.addAttribute("parentName", task == null ? null : task.getTaskTitle());
        }
        if (null == info.getUsrRoleIds()) {//普通成员
            model.addAttribute("type", "1");
        } else {
            model.addAttribute("type", "2");
        }
        return "system/task/list";
    }

    @RequestMapping("toTaskParent")
    public String toTaskParent(HttpServletRequest request, Model model, Integer taskId) {
        model.addAttribute("taskId", taskId);
        return "system/task/querylist";
    }

    /**
     * 说明：跳转添加人员页面
     *
     * @创建：作者:zrp 创建时间：2015-02-03
     * @修改历史： [序号](zrp 2015 - 02 - 03)<修改说明>
     */
    @RequestMapping("totaskmem")
    public String totaskmem(String gzrIds, Model model) {
        if (null != gzrIds) {
            model.addAttribute("gzrIds", gzrIds);
        }
        return "system/task/member";
    }

    /**
     * 说明：跳转任务添加页面
     *
     * @创建：作者:zrp 创建时间：2015-02-03
     * @修改历史： [序号](zrp 2015 - 02 - 03)<修改说明>
     */
    @RequestMapping("totaskadd")
    public String totaskadd(HttpServletRequest request, Model model, Integer parentId) {
        if (!StrUtil.isNull(parentId)) {
            SysLoginInfo info = getInfo(request);
            SysTask task = this.taskService.queryById(parentId, info.getDatasource());
            model.addAttribute("parentId", parentId);
            model.addAttribute("parentName", task == null ? null : task.getTaskTitle());
            model.addAttribute("usrNm", info.getUsrNm());
        }
        model.addAttribute("attTempId", new Date().getTime());
        return "system/task/addtask";
    }

    /**
     * 说明：跳转任务修改页面
     *
     * @创建：作者:zrp 创建时间：2015-02-03
     * @修改历史： [序号](zrp 2015 - 02 - 03)<修改说明>
     */
    @RequestMapping("/taskmempage")
    public void memberPage(HttpServletRequest request, HttpServletResponse response, SysMember member, Integer page, Integer rows) {
        try {
            SysLoginInfo info = this.getLoginInfo(request);
            Page p = this.memberService.querySysMember(member, page, rows, info.getDatasource());
            JSONObject json = new JSONObject();
            json.put("total", p.getTotal());
            json.put("rows", p.getRows());
            this.sendJsonResponse(response, json.toString());
            p = null;
        } catch (Exception e) {
            log.error("分页查询成员出错", e);
        }
    }

    /**
     * 跳转任务详情页面
     *
     * @return
     */
    @RequestMapping("detailtaskfedd")
    public String detailtaskfedd(HttpServletResponse response, HttpServletRequest request, Integer id, Integer percent, String title,
                                 Model model) {
        try {
            SysLoginInfo info = this.getInfo(request);
            String datebase = info.getDatasource();
            List<SysTaskFeedback> list = this.sysTaskFeedBackService.queryByPid(id, datebase);
            for (int i = 0; i < list.size(); i++) {
                SysTaskFeedback feed = list.get(i);
                List<SysTaskAttachment> att = this.sysTaskAttachmentService.queryFeedBackList(feed.getId(), datebase);
                if (att != null && att.size() > 0) {
                    feed.setAtts(att);
                }
            }
            Integer psnId = taskService.queryPsnId(id, datebase);//查询责任人
            model.addAttribute("list", list);
            model.addAttribute("taskId", id);
            model.addAttribute("percent", percent);
            model.addAttribute("title", title);
            model.addAttribute("psnId", psnId);
            model.addAttribute("userId", info.getIdKey());
            return "system/task/feeddetail";
        } catch (Exception e) {
            log.error("任务获取详情出错", e);
            return "";
        }
    }

    /**
     * 说明：跳转任务修改页面
     *
     * @创建：作者:zrp 创建时间：2015-02-03
     * @修改历史： [序号](zrp 2015 - 02 - 03)<修改说明>
     */
    @RequestMapping("totaskbyid")
    public String toupdate(HttpServletResponse response, HttpServletRequest request, Integer id
            , Model model) {
        SysLoginInfo user = this.getInfo(request);
        SysTask task = this.taskService.queryById(id, user.getDatasource(), 0);
        Integer parentId = task.getParentId();
        if (!StrUtil.isNull(parentId)) {
            task.setParentTitle(this.taskService.queryById(parentId, user.getDatasource()).getTaskTitle());
        }
        List<SysTaskAttachment> list = this.sysTaskAttachmentService.queryForList(id.toString(), user.getDatasource());
        model.addAttribute("task", task);
        model.addAttribute("atts", list);
        return "system/task/taskDetail";
    }

    /**
     * 分页查询任务
     *
     * @param response
     * @param request
     * @param page
     * @param rows
     * @param task
     */
    @RequestMapping("/taskpages")
    public void page(HttpServletResponse response, HttpServletRequest request
            , Integer page, Integer rows, SysTask task) {
        Page p = null;
        try {
            SysLoginInfo info = getInfo(request);
            if (null == info.getUsrRoleIds()) {//普通成员（查询关联的任务（发布、责任、关注））
                p = this.taskService.queryPage(task, page, rows, info.getDatasource(), info.getIdKey());
            } else {//公司管理员
                p = this.taskService.queryPage(task, page, rows, info.getDatasource(), null);
            }
            JSONObject json = new JSONObject();
            json.put("total", p.getTotal());
            json.put("rows", p.getRows());
            this.sendJsonResponse(response, json.toString());
            p = null;
        } catch (Exception e) {
            log.error("任务查询出错：", e);
        }
    }

    /**
     * 修改任务信息
     *
     * @param response
     * @param request
     * @param page
     * @param rows
     * @param task
     */
    @RequestMapping("/savetask")
    public void save(HttpServletResponse response, HttpServletRequest request
            , SysTask task, String zreIds, String gzrIds) {
        try {
            SysLoginInfo info = this.getInfo(request);
            String database = info.getDatasource();
            SysTask tk = this.taskService.queryById(task.getId(), database);
            tk.setTaskTitle(task.getTaskTitle());
            tk.setStatus(task.getStatus());
            tk.setStartTime(task.getStartTime());
            tk.setEndTime(task.getEndTime());
            tk.setRemind1(task.getRemind1());
            tk.setRemind2(task.getRemind2());
            tk.setRemind3(task.getRemind3());
            tk.setRemind4(task.getRemind4());
            tk.setActTime(task.getActTime());
            tk.setPercent(task.getPercent());
            tk.setParentId(task.getParentId());
            tk.setTaskMemo(task.getTaskMemo());
            this.taskService.updateTask(tk, database);
            String time = getFilePath();
            List<Map<String, String>> pics = this.uploadFile(request, this.getPathUpload(request) + "/" + time + "/" + database, time + "/" + database);
            if (pics.size() > 0) {
                SysTaskAttachment att = new SysTaskAttachment();
                att.setNid(task.getId());
                for (Map<String, String> map : pics) {
                    att.setAttachName(map.get("name"));
                    att.setAttacthPath(map.get("path"));
                    this.sysTaskAttachmentService.addTaskAttachment(att, database);
                }
            }
            String[] zrdId = zreIds.split(",");
            String[] gzrId = gzrIds.split(",");
            SysTaskPsn psn = new SysTaskPsn();
            psn.setNid(task.getId());
            if (zrdId.length > 0) {
                psn.setPsnType(SysTaskPsn.PSN_RESPONSIBILITY);
                this.sysTaskPsnService.deleteByTaskId(task.getId(), SysTaskPsn.PSN_RESPONSIBILITY, database);
                for (String str : zrdId) {
                    psn.setPsnId(Integer.valueOf(str));
                    this.sysTaskPsnService.addTaskPsn(psn, database);
                }
            }
            if (gzrId.length > 0) {
                psn.setPsnType(SysTaskPsn.PSN_FOCUS_ON);
                this.sysTaskPsnService.deleteByTaskId(task.getId(), SysTaskPsn.PSN_FOCUS_ON, database);
                for (String str : gzrId) {
                    psn.setPsnId(Integer.valueOf(str));
                    this.sysTaskPsnService.addTaskPsn(psn, database);
                }
            }
            this.sendHtmlResponse(response, "1");
        } catch (Exception e) {
            log.error("修改任务出错：", e);
            this.sendHtmlResponse(response, "-1");
        }
    }

    /**
     * 添加任务
     *
     * @param response
     * @param request
     * @param task
     */
    @Deprecated
    @RequestMapping("/addtask")
    public void addtask(HttpServletResponse response, HttpServletRequest request
            , SysTask task, String zreIds, String gzrIds) {
        try {
            SysLoginInfo info = this.getInfo(request);
            String database = info.getDatasource();
            task.setCreateBy(info.getIdKey());
            int id = this.taskService.addTask(task, database);
            String time = getFilePath();
            List<Map<String, String>> pics = this.uploadFile(request, this.getPathUpload(request) + "/" + time + "/" + database, time + "/" + database);
            if (pics.size() > 0) {
                SysTaskAttachment att = new SysTaskAttachment();
                att.setNid(id);
                for (Map<String, String> map : pics) {
                    att.setAttachName(map.get("name"));
                    att.setAttacthPath(map.get("path"));
                    this.sysTaskAttachmentService.addTaskAttachment(att, database);
                }
            }
            String[] zrdId = zreIds.split(",");
            String[] gzrId = gzrIds.split(",");
            SysTaskPsn psn = new SysTaskPsn();
            psn.setNid(id);
            if (zrdId.length > 0) {
                psn.setPsnType(SysTaskPsn.PSN_RESPONSIBILITY);
                for (String str : zrdId) {
                    psn.setPsnId(Integer.valueOf(str));
                    this.sysTaskPsnService.addTaskPsn(psn, database);
                }
            }
            if (gzrId.length > 0) {
                psn.setPsnType(SysTaskPsn.PSN_FOCUS_ON);
                for (String str : gzrId) {
                    psn.setPsnId(Integer.valueOf(str));
                    this.sysTaskPsnService.addTaskPsn(psn, database);
                }
            }
            this.sendHtmlResponse(response, "1");
        } catch (Exception e) {
            log.error("修改任务出错：", e);
            this.sendHtmlResponse(response, "-1");
        }
    }

    /**
     * 根据附件ID删除附件
     */
    @RequestMapping("/deltaskatt")
    public void delAtt(HttpServletResponse response, HttpServletRequest request
            , Integer id) {
        try {
            SysLoginInfo info = getInfo(request);
            SysTaskAttachment att = this.sysTaskAttachmentService.queryById(id, info.getDatasource());
            if (att != null) {
                String path = this.getPathUpload(request) + "/" + att.getAttacthPath();
                this.delFile(path);
            }
            this.sysTaskAttachmentService.deleteByid(id, info.getDatasource());
            this.sendHtmlResponse(response, "1");
        } catch (Exception e) {
            log.error("删除附件出错：", e);
            this.sendHtmlResponse(response, "-1");
        }
    }

    /**
     * 根据任务ID删除任务
     */
    @RequestMapping("/deltasks")
    public void delTask(HttpServletResponse response, HttpServletRequest request
            , Integer[] ids) {
        try {
            String path = this.getPathUpload(request);
            SysLoginInfo info = this.getInfo(request);
            String database = info.getDatasource();
            List<Integer> list = new ArrayList<Integer>();
            for (Integer id : ids) {
                list.add(id);
                this.queryChila(id, database, list);
            }
            List<SysTaskAttachment> atts = this.sysTaskAttachmentService.queryForListByNid(database, list);
            if (atts != null && atts.size() > 0) {
                for (SysTaskAttachment att : atts) {
                    this.delFile(path + "/" + att.getAttacthPath());
                }
            }
            List<Integer> feedlist = new ArrayList<Integer>();
            for (int i = 0; i < list.size(); i++) {
                this.queryFeed(list.get(i), database, feedlist);
            }
            if (feedlist.size() > 0) {
                atts = this.sysTaskAttachmentService.queryForlistByPid(database, feedlist);
                if (atts != null && atts.size() > 0) {
                    for (SysTaskAttachment att : atts) {
                        this.delFile(path + "/" + att.getAttacthPath());
                    }
                }
            }
            this.taskService.deleteTask(ids, database);
            this.sendHtmlResponse(response, "1");
        } catch (Exception e) {
            e.printStackTrace();
            log.error("删除附件出错：", e);
            this.sendHtmlResponse(response, "-1");
        }
    }

    /**
     * 根据任务ID获取子任务所有ID
     *
     * @param taskId
     * @param database
     * @return
     */
    public void queryChila(Integer taskId, String database, List<Integer> lists) {
        List<SysTask> tasks = this.taskService.queryChild(taskId, database);
        for (SysTask t : tasks) {
            lists.add(t.getId());
            this.queryChila(t.getId(), database, lists);
        }
    }

    /**
     * 获取进度ID
     *
     * @param taskId
     * @param database
     * @param lists
     */
    public void queryFeed(Integer taskId, String database, List<Integer> lists) {
        try {
            List<SysTaskFeedback> tasks = this.sysTaskFeedBackService.queryByPid(taskId, database);
            for (SysTaskFeedback t : tasks) {
                lists.add(t.getId());
            }
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 下载附件
     */
    @RequestMapping("/download")
    public void download(HttpServletResponse response, HttpServletRequest request
            , String path, String filename) {
        try {
            File file = new File(this.getPathUpload(request) + "/" + path);
            if (!StrUtil.isNull(filename)) {
                if (file.exists()) {
                    String fileName = new String(filename.getBytes("ISO-8859-1"), "UTF-8");
                    // 读到流中
                    InputStream inStream = new FileInputStream(file);// 文件的存放路径
                    // 设置输出的格式
                    response.reset();
                    response.setContentType("bin");
                    //		        response.addHeader("Content-Disposition", "attachment; filename=\"" +  java.net.URLEncoder.encode(filename, "UTF-8") + "\"");
                    response.setHeader("Content-disposition", "attachment;filename=" + new String(fileName.getBytes("gb2312"), "iso8859-1"));//设置头部信息
                    // 循环取出流中的数据
                    byte[] b = new byte[100];
                    int len;
                    try {
                        while ((len = inStream.read(b)) > 0)
                            response.getOutputStream().write(b, 0, len);
                    } finally {
                        if (inStream != null) {
                            inStream.close();
                        }
                    }
                }
            }
        } catch (Exception e) {
            log.error("文件下载出错", e);
        }
    }

    /**
     * @param response
     * @param request
     * @param model
     * @param startTime
     * @param endTime
     * @param num
     * @return
     * @创建：作者:YYP 创建时间：2015-7-1
     * @see 到添加子任务页面
     */
    @RequestMapping("toChildtaskPage")
    public String toChildtaskPage(HttpServletResponse response, HttpServletRequest request, Model model, String startTime, String endTime, String num) {
        model.addAttribute("startTime", startTime);
        model.addAttribute("endTime", endTime);
        model.addAttribute("num", num);
        model.addAttribute("attTempId", new Date().getTime());
        return "system/task/childTaskadd";
    }

    //上传子任务附件
    @RequestMapping("addchildtaskfile")
    public void addchildtaskfile(HttpServletRequest request, HttpServletResponse response) {
        try {
            SysLoginInfo info = this.getInfo(request);
            String datasource = info.getDatasource();
            String time = getFilePath();
            List<Map<String, String>> pics = this.uploadFile(request, this.getPathUpload(request) + "/" + datasource + "/" + time, datasource + "/" + time);
            JSONObject json = new JSONObject();
            json.put("pics", pics);
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            log.error("保存子任务文件失败", e);
        }
    }

    /**
     * @param request
     * @param response
     * @param task
     * @param zreIds
     * @param gzrIds
     * @param attTempId 附件临时id
     * @创建：作者:YYP 创建时间：2015-7-2
     * @see 添加主任务和子任务
     */
    @RequestMapping("addTaskAndChild")
    public void test(HttpServletRequest request, HttpServletResponse response, SysTask task, String zreIds, String gzrIds, Integer type, String attTempId) {
        String[] taskchilds = request.getParameterValues("taskchild");
        try {
            SysLoginInfo info = this.getInfo(request);
            String database = info.getDatasource();
            String addTime = DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd HH:mm");
            task.setCreateTime(addTime);
            Integer userId = info.getIdKey();
            task.setCreateBy(userId);
            task.setStatus(type);
            int id = this.taskService.addTask(task, database);
            sysTaskAttachmentService.updateAtt(attTempId, id, database);//更新附件对应的任务id
            addzrandgz(zreIds, gzrIds, database, id);
            //添加子任务
            if (taskchilds.length > 1) {
                for (int i = 0; i < taskchilds.length - 1; i++) {
                    JsonObject root = new JsonParser().parse(taskchilds[i]).getAsJsonObject();  //转成json对象
                    SysTask ctask = new SysTask();
                    taskset(type, info, addTime, id, root, ctask);//task赋值
                    int childid = this.taskService.addTask(ctask, database);
                    if (!"\"\"".equals(root.get("attTempId").toString())) {
                        String attId = root.get("attTempId").toString();//转换会带有“”
                        attId = attId.substring(1, attId.length() - 1);//去掉“”
                        sysTaskAttachmentService.updateAtt(attId, childid, database);//更新附件对应的任务id
                    }
                    String memberIds = root.get("memberIds").toString();
                    String supervisorIds = root.get("supervisorIds").toString();
                    addzrandgz(memberIds.substring(1, memberIds.length() - 1), supervisorIds.substring(1, supervisorIds.length() - 1), database, childid);//添加责任人和关注人
                }
            }
            if (1 == type) {//未完成
                List<SysTask> taskList = taskService.queryTaskByzid(id, database);//查询该主任务的所有主子任务
                this.taskService.addupdateState(taskList, database, SysTask.STATUS_NO);
                //////////推送
                StringBuffer tels = new StringBuffer("");
                List<SysChatMsg> sys = new ArrayList<SysChatMsg>();
                Integer idKey = info.getIdKey();
                Map idsTelsMap = taskService.queryByMember2(id, database);
                //解析任务查询数据
                String telzr = idsTelsMap.get("tels") == null ? "" : idsTelsMap.get("tels").toString();
                String memIdzr = idsTelsMap.get("ids") == null ? "" : idsTelsMap.get("ids").toString();
                String telsfocus = idsTelsMap.get("telsfocus") == null ? "" : idsTelsMap.get("telsfocus").toString();
                String memIdsfocus = idsTelsMap.get("idsfocus") == null ? "" : idsTelsMap.get("idsfocus").toString();
                String titles = idsTelsMap.get("titles") == null ? "" : idsTelsMap.get("titles").toString();
                String taskIds = idsTelsMap.get("taskids") == null ? "" : idsTelsMap.get("taskids").toString();

                String[] titlets = titles.split(",");
                String[] tIds = taskIds.split(",");
                if (!StrUtil.isNull(memIdzr)) {//责任人
                    String[] zrIds = memIdzr.split(",");
                    String[] zrTels = telzr.split(",");
                    for (int i = 0; i < zrIds.length; i++) {
                        if (!zrIds[i].equals(idKey.toString())) {
                            SysChatMsg scm = new SysChatMsg();
                            scm.setAddtime(getDate());
                            scm.setMemberId(idKey);
                            scm.setBelongId(Integer.parseInt(tIds[i]));
                            scm.setTp("10");//完成任务
                            scm.setBelongMsg("新任务");
                            scm.setMsg(info.getUsrNm() + "：发起 [" + titlets[i] + "] 任务，请完成");
                            scm.setReceiveId(Integer.valueOf(zrIds[i]));
                            sys.add(scm);
                            tels.append(zrTels[i] + ",");
                        }
                    }
                }
                if (!StrUtil.isNull(memIdsfocus)) {//关注人
                    String[] fIds = memIdsfocus.substring(0, memIdsfocus.length() - 1).split("-,");//多个任务隔开
                    String[] fTels = telsfocus.substring(0, telsfocus.length() - 1).split("-,");
                    for (int j = 0; j < fIds.length; j++) {
                        String[] gzIds = fIds[j].split(",");//一个任务含有多个关注人
                        String[] gzTels = fTels[j].split(",");
                        for (int i = 0; i < gzIds.length; i++) {
                            if (!gzIds[i].equals(idKey.toString())) {
                                SysChatMsg scm = new SysChatMsg();
                                scm.setAddtime(getDate());
                                scm.setMemberId(idKey);
                                scm.setBelongId(Integer.parseInt(tIds[j]));
                                scm.setTp("10");//完成任务
                                scm.setBelongMsg("新任务");
                                scm.setMsg(info.getUsrNm() + "：发起 [" + titlets[j] + "] 任务，请关注");
                                scm.setReceiveId(Integer.valueOf(gzIds[i]));
                                sys.add(scm);
                                tels.append(gzTels[i] + ",");
                            }
                        }
                    }
                }
                if (null != sys && sys.size() > 0) {
                    // 批量添加
                    this.sysChatMsgWebService.addChatMsg(sys, database);
//					JpushClassify jc = new JpushClassify();
                    String pushTels = tels.toString();
                    jpushClassifies.toJpush(pushTels.substring(0, pushTels.length() - 1), CnlifeConstants.MODE2, CnlifeConstants.NEWMSG, null, 0, "提示", null);
                    jpushClassifies2.toJpush(pushTels.substring(0, pushTels.length() - 1), CnlifeConstants.MODE2, CnlifeConstants.NEWMSG, null, 0, "提示", null);
                }
            }
            this.sendHtmlResponse(response, "1");
            return;
        } catch (Exception e) {
            log.error("修改任务出错：", e);
            this.sendHtmlResponse(response, "-1");
            return;
        }
    }

    //task赋值
    private void taskset(Integer status, SysLoginInfo info, String addTime,
                         int id, JsonObject root, SysTask ctask) {
        String taskTitle = root.get("taskTitle").toString();//转换会带有“”
        ctask.setTaskTitle(taskTitle.substring(1, taskTitle.length() - 1));//去掉“”
        String startTime = root.get("startTime").toString();
        ctask.setStartTime(startTime.substring(1, startTime.length() - 1));
        String endTime = root.get("endTime").toString();
        ctask.setEndTime(endTime.substring(1, endTime.length() - 1));
        String remind1 = root.get("remind1").toString();
        ctask.setRemind1(Integer.parseInt(remind1.substring(1, remind1.length() - 1)));
        String remind2 = root.get("remind2").toString();
        ctask.setRemind2(Integer.parseInt(remind2.substring(1, remind2.length() - 1)));
        String remind3 = root.get("remind3").toString();
        ctask.setRemind3(Integer.parseInt(remind3.substring(1, remind3.length() - 1)));
        String remind4 = root.get("remind4").toString();
        ctask.setRemind4(Integer.parseInt(remind4.substring(1, remind4.length() - 1)));
        String taskMemo = root.get("taskMemo").toString();
        ctask.setTaskMemo(taskMemo.substring(1, taskMemo.length() - 1));
        ctask.setParentId(id);
        ctask.setCreateBy(info.getIdKey());
        ctask.setCreateTime(addTime);
        ctask.setStatus(status);
    }

    //添加责任人和关注人
    private void addzrandgz(String zreIds, String gzrIds, String database,
                            int id) {
        String[] zrdId = zreIds.split(",");
        String[] gzrId = gzrIds.split(",");
        if (!StrUtil.isNull(zrdId)) {
            for (String str : zrdId) {
                SysTaskPsn psn = new SysTaskPsn();
                psn.setPsnType(SysTaskPsn.PSN_RESPONSIBILITY);
                psn.setNid(id);
                psn.setPsnId(Integer.valueOf(str));
                this.sysTaskPsnService.addTaskPsn(psn, database);
            }
        }
        if (!StrUtil.isNull(gzrIds)) {
            for (String str : gzrId) {
                SysTaskPsn psn = new SysTaskPsn();
                psn.setPsnType(SysTaskPsn.PSN_FOCUS_ON);
                psn.setNid(id);
                psn.setPsnId(Integer.valueOf(str));
                this.sysTaskPsnService.addTaskPsn(psn, database);
            }
        }
    }

    /**
     * @param request
     * @param response
     * @param type=1查看主任务 2 查看子任务
     * @param taskId
     * @创建：作者:YYP 创建时间：2015-7-8
     * @see 查询主子任务
     */
    @RequestMapping("querytasks")
    public void querytasks(HttpServletRequest request, HttpServletResponse response, String type, Integer taskId, Model model, Integer page, Integer rows) {
        try {
            SysLoginInfo info = this.getInfo(request);
            String database = info.getDatasource();
            Page p = taskService.queryTaskByTypeId(type, taskId, database, page, rows);
            JSONObject json = new JSONObject();
            json.put("total", p.getTotal());
            json.put("rows", p.getRows());
            this.sendJsonResponse(response, json.toString());
            p = null;
        } catch (Exception e) {
            log.error("查询主子任务详情出错：", e);
        }
    }

    //到主子任务详细页面
    @RequestMapping("topctaskdetail")
    public String topctaskdetail(Model model, String type, Integer taskId) {
        model.addAttribute("type", type);
        model.addAttribute("taskId", taskId);
        return "system/task/pctaskdetail";
    }

    //到修改任务页面
    @RequestMapping("toupdatetask")
    public String toupdatetask(HttpServletResponse response, HttpServletRequest request, Integer id, Model model) {
        try {
            SysLoginInfo user = this.getInfo(request);
            SysTask task = this.taskService.queryById(id, user.getDatasource(), 0);
            List<SysTaskAttachment> attachmentList = this.sysTaskAttachmentService.queryForList(id.toString(), user.getDatasource());
            List<SysTask> childList = taskService.querChildTask(id, user.getDatasource());
            model.addAttribute("task", task);
            model.addAttribute("atts", attachmentList);
            model.addAttribute("childList", childList);
        } catch (Exception e) {
            log.error("到修改任务页面出错：", e);
        }
        return "system/task/updatetask";
    }

    //删除子任务
    @RequestMapping("delchild")
    public void delchild(HttpServletResponse response, HttpServletRequest request, Integer taskId) {
        try {
            SysLoginInfo user = this.getInfo(request);
            Integer[] id = {taskId};
            taskService.deleteTask(id, user.getDatasource());
            sendHtmlResponse(response, "1");
            return;
        } catch (Exception e) {
            log.error("删除子任务出错：", e);
            sendHtmlResponse(response, "-1");
        }
    }

    //到修改子任务页面
    @RequestMapping("toUpdateChild")
    public String toUpdateChild(HttpServletRequest response, HttpServletRequest request, Model model, Integer taskId) {
        try {
            SysLoginInfo user = this.getInfo(request);
            SysTask task = this.taskService.queryById(taskId, user.getDatasource(), 0);
            List<SysTaskAttachment> list = this.sysTaskAttachmentService.queryForList(taskId.toString(), user.getDatasource());
            model.addAttribute("task", task);
            model.addAttribute("atts", list);
        } catch (Exception e) {
            log.error("删除子任务出错：", e);
        }
        return "system/task/updatechildTask";
    }

    //修改子任务
    @RequestMapping("updatectask")
    public void updatectask(HttpServletResponse response, HttpServletRequest request, SysTask task, String zreIds, String gzrIds) {
        try {
            String addTime = DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd HH:mm");
            SysLoginInfo info = this.getInfo(request);
            String database = info.getDatasource();
            int updateset = this.taskService.updateTask(task, database);
            if (updateset > 0) {
                //删除关注人和执行人
                Integer taskId = task.getId();
                sysTaskPsnService.deleteByTaskId(taskId, database);
                //添加关注人和执行人
                addzrandgz(zreIds, gzrIds, database, taskId);
				/*String time = getFilePath();
				List<Map<String, String>> pics = this.uploadFile(request, this.getPathUpload(request)+"/"+database+"/"+time,database+"/"+time);
				if(null!=pics &&pics.size()>0){
					for(Map<String,String> map : pics){
						SysTaskAttachment att = new SysTaskAttachment();
						att.setNid(taskId);
						att.setAttachName(map.get("name"));
						att.setAttacthPath(map.get("path"));
						att.setFsize(map.get("fsize"));
						att.setAddTime(addTime);
						this.sysTaskAttachmentService.addTaskAttachment(att, database);
					}
				}*/
            }
            sendHtmlResponse(response, "1");
        } catch (Exception e) {
            log.error("保存子任务出错：", e);
            sendHtmlResponse(response, "-1");
        }
    }

    //更新草稿
    @RequestMapping("updateDraft")
    public void updateDraft(HttpServletRequest request, HttpServletResponse response, SysTask task, String zreIds, String gzrIds, Integer type) {
        String[] taskchilds = request.getParameterValues("taskchild");
        try {
            Integer taskId = task.getId();
            String addTime = DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd HH:mm");
            SysLoginInfo info = this.getInfo(request);
            String database = info.getDatasource();
            int updateset = this.taskService.updateTask(task, database);
            if (updateset > 0) {
                //删除关注人和执行人
                sysTaskPsnService.deleteByTaskId(taskId, database);
                //添加关注人和执行人
                addzrandgz(zreIds, gzrIds, database, taskId);
            }
            //添加子任务
            if (taskchilds.length > 1) {
                for (int i = 0; i < taskchilds.length - 1; i++) {
                    JsonObject root = new JsonParser().parse(taskchilds[i]).getAsJsonObject();  //转成json对象
                    SysTask ctask = new SysTask();
                    taskset(type, info, addTime, taskId, root, ctask);//task赋值
                    int childid = this.taskService.addTask(ctask, database);
                    if (!"\"\"".equals(root.get("attTempId").toString())) {
                        String attId = root.get("attTempId").toString();//转换会带有“”
                        attId = attId.substring(1, attId.length() - 1);//去掉“”
                        sysTaskAttachmentService.updateAtt(attId, childid, database);//更新附件对应的任务id
                    }
                    String memberIds = root.get("memberIds").toString();
                    String supervisorIds = root.get("supervisorIds").toString();
                    addzrandgz(memberIds.substring(1, memberIds.length() - 1), supervisorIds.substring(1, supervisorIds.length() - 1), database, childid);//添加责任人和关注人
                }
            }
            if (1 == type) {//未完成(发布)
                List<SysTask> taskList = taskService.queryTaskByzid(taskId, database);//查询该主任务的所有主子任务
                this.taskService.addupdateState(taskList, database, SysTask.STATUS_NO);
                //////////推送
                StringBuffer tels = new StringBuffer("");
                List<SysChatMsg> sys = new ArrayList<SysChatMsg>();
                Integer idKey = info.getIdKey();
                Map idsTelsMap = taskService.queryByMember2(taskId, database);

                String telzr = idsTelsMap.get("tels") == null ? "" : idsTelsMap.get("tels").toString();
                String memIdzr = idsTelsMap.get("ids") == null ? "" : idsTelsMap.get("ids").toString();
                String telsfocus = idsTelsMap.get("telsfocus") == null ? "" : idsTelsMap.get("telsfocus").toString();
                String memIdsfocus = idsTelsMap.get("idsfocus") == null ? "" : idsTelsMap.get("idsfocus").toString();
                String titles = idsTelsMap.get("titles") == null ? "" : idsTelsMap.get("titles").toString();
                String taskIds = idsTelsMap.get("taskids") == null ? "" : idsTelsMap.get("taskids").toString();

                String[] titlets = titles.split(",");
                String[] tIds = taskIds.split(",");
                if (!StrUtil.isNull(memIdzr)) {//责任人
                    String[] zrIds = memIdzr.split(",");
                    String[] zrTels = telzr.split(",");
                    for (int i = 0; i < zrIds.length; i++) {
                        if (!zrIds[i].equals(idKey.toString())) {
                            SysChatMsg scm = new SysChatMsg();
                            scm.setAddtime(getDate());
                            scm.setMemberId(idKey);
                            scm.setBelongId(Integer.parseInt(tIds[i]));
                            scm.setTp("10");//完成任务
                            scm.setBelongMsg("新任务");
                            scm.setMsg(info.getUsrNm() + "：发起 [" + titlets[i] + "] 任务，请完成");
                            scm.setReceiveId(Integer.valueOf(zrIds[i]));
                            sys.add(scm);
                            tels.append(zrTels[i] + ",");
                        }
                    }
                }
                if (!StrUtil.isNull(memIdsfocus)) {//关注人
                    String[] fIds = memIdsfocus.substring(0, memIdsfocus.length() - 1).split("-,");//多个任务隔开
                    String[] fTels = telsfocus.substring(0, telsfocus.length() - 1).split("-,");
                    for (int j = 0; j < fIds.length; j++) {
                        String[] gzIds = fIds[j].split(",");//一个任务含有多个关注人
                        String[] gzTels = fTels[j].split(",");
                        for (int i = 0; i < gzIds.length; i++) {
                            if (!gzIds[i].equals(idKey.toString())) {
                                SysChatMsg scm = new SysChatMsg();
                                scm.setAddtime(getDate());
                                scm.setMemberId(idKey);
                                scm.setBelongId(Integer.parseInt(tIds[j]));
                                scm.setTp("10");//完成任务
                                scm.setBelongMsg("新任务");
                                scm.setMsg(info.getUsrNm() + "：发起 [" + titlets[j] + "] 任务，请关注");
                                scm.setReceiveId(Integer.valueOf(gzIds[i]));
                                sys.add(scm);
                                tels.append(gzTels[i] + ",");
                            }
                        }
                    }
                }
                if (null != sys && sys.size() > 0) {
                    // 批量添加
                    this.sysChatMsgWebService.addChatMsg(sys, database);
//					JpushClassify jc = new JpushClassify();
                    String pushTels = tels.toString();
                    jpushClassifies.toJpush(pushTels.substring(0, pushTels.length() - 1), CnlifeConstants.MODE2, CnlifeConstants.NEWMSG, null, 0, "提示", null);
                    jpushClassifies2.toJpush(pushTels.substring(0, pushTels.length() - 1), CnlifeConstants.MODE2, CnlifeConstants.NEWMSG, null, 0, "提示", null);
                }
            }
            this.sendHtmlResponse(response, "1");
            return;
        } catch (Exception e) {
            log.error("修改任务出错：", e);
            this.sendHtmlResponse(response, "-1");
            return;
        }
    }

    //到添加任务反馈页面
    @RequestMapping("toAddFeed")
    public String toAddFeed(HttpServletRequest request, HttpServletResponse response, Model model, Integer taskId, Integer percent) {
        model.addAttribute("taskId", taskId);
        model.addAttribute("percent", percent);
        model.addAttribute("attTempId", new Date().getTime());
        return "system/task/addFeed";
    }

    //增加任务反馈
    @RequestMapping("addFeed")
    public void addFeed(HttpServletRequest request, HttpServletResponse response, SysTaskFeedback feed, String attTempId) {
        try {
            SysLoginInfo info = this.getInfo(request);
            String database = info.getDatasource();
            String ntime = DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd HH:mm:ss");
            //添加任务反馈
            feed.setDtDate(ntime);
            Integer fid = sysTaskFeedBackService.addFeed(feed, database);
            if (fid > 0) {
                Integer persent = feed.getPersent();
                Integer taskId = feed.getNid();
                taskService.updatePersent(taskId, persent, database);//修改主任务的persent进度
				/*String time = getFilePath();
				List<Map<String, String>> pics = this.uploadFile(request, this.getPathUpload(request)+"/"+database+"/"+time,database+"/"+time);
				if(null!=pics &&pics.size()>0){
					for(Map<String,String> map : pics){
						SysTaskAttachment att = new SysTaskAttachment();
						att.setRefId(fid);//反馈任务id
						att.setAttachName(map.get("name"));
						att.setAttacthPath(map.get("path"));
						att.setFsize(map.get("fsize"));
						att.setAddTime(ntime);
						this.sysTaskAttachmentService.addTaskAttachment(att, database);
					}
				}*/
                sysTaskAttachmentService.updateAttForFeedId(attTempId, fid, database);//更新附件对应的任务id
                if (100 == persent) {
                    Map map = this.taskService.queryByTaskIdNot(taskId, database);
                    Object obj = map.get("num");
                    if (Integer.valueOf(obj.toString()) > 0) {
                        this.sendHtmlResponse(response, "2");
                        return;
                    }
                    taskService.updateState(taskId, database, 2, ntime);//修改任务为已完成
                    //推送
                    StringBuffer tels = new StringBuffer("");
                    List<SysChatMsg> sys = new ArrayList<SysChatMsg>();
                    Integer idKey = info.getIdKey();
                    Map idsTelsMap = taskService.queryByMember2(taskId, database);

                    String telzr = idsTelsMap.get("tels") == null ? "" : idsTelsMap.get("tels").toString();
                    String memIdzr = idsTelsMap.get("ids") == null ? "" : idsTelsMap.get("ids").toString();
                    String telsfocus = idsTelsMap.get("telsfocus") == null ? "" : idsTelsMap.get("telsfocus").toString();
                    String memIdsfocus = idsTelsMap.get("idsfocus") == null ? "" : idsTelsMap.get("idsfocus").toString();
                    String titles = idsTelsMap.get("titles") == null ? "" : idsTelsMap.get("titles").toString();
                    String taskIds = idsTelsMap.get("taskids") == null ? "" : idsTelsMap.get("taskids").toString();

                    String[] titlets = titles.split(",");
                    String[] tIds = taskIds.split(",");
                    if (!StrUtil.isNull(memIdzr)) {//责任人
                        String[] zrIds = memIdzr.split(",");
                        String[] zrTels = telzr.split(",");
                        for (int i = 0; i < zrIds.length; i++) {
                            if (!zrIds[i].equals(idKey.toString())) {
                                SysChatMsg scm = new SysChatMsg();
                                scm.setAddtime(getDate());
                                scm.setMemberId(idKey);
                                scm.setBelongId(Integer.parseInt(tIds[i]));
                                scm.setTp("10");//完成任务
                                scm.setBelongMsg("完成任务");
                                scm.setMsg(info.getUsrNm() + "： [" + titlets[i] + "] 任务已完成。");
                                scm.setReceiveId(Integer.valueOf(zrIds[i]));
                                sys.add(scm);
                                tels.append(zrTels[i] + ",");
                            }
                        }
                    }
                    if (!StrUtil.isNull(memIdsfocus)) {//关注人
                        String[] fIds = memIdsfocus.substring(0, memIdsfocus.length() - 1).split("-,");//多个任务隔开
                        String[] fTels = telsfocus.substring(0, telsfocus.length() - 1).split("-,");
                        for (int j = 0; j < fIds.length; j++) {
                            String[] gzIds = fIds[j].split(",");//一个任务含有多个关注人
                            String[] gzTels = fTels[j].split(",");
                            for (int i = 0; i < gzIds.length; i++) {
                                if (!gzIds[i].equals(idKey.toString())) {
                                    SysChatMsg scm = new SysChatMsg();
                                    scm.setAddtime(getDate());
                                    scm.setMemberId(idKey);
                                    scm.setBelongId(Integer.parseInt(tIds[j]));
                                    scm.setTp("10");//完成任务
                                    scm.setBelongMsg("新任务");
                                    scm.setMsg(info.getUsrNm() + "：发起 [" + titlets[j] + "] 任务，请关注");
                                    scm.setReceiveId(Integer.valueOf(gzIds[i]));
                                    sys.add(scm);
                                    tels.append(gzTels[i] + ",");
                                }
                            }
                        }
                    }
                    if (null != sys && sys.size() > 0) {
                        // 批量添加
                        this.sysChatMsgWebService.addChatMsg(sys, database);
//						JpushClassify jc = new JpushClassify();
                        String pushTels = tels.toString();
                        jpushClassifies.toJpush(pushTels.substring(0, pushTels.length() - 1), CnlifeConstants.MODE2, CnlifeConstants.NEWMSG, null, 0, "提示", null);
                        jpushClassifies2.toJpush(pushTels.substring(0, pushTels.length() - 1), CnlifeConstants.MODE2, CnlifeConstants.NEWMSG, null, 0, "提示", null);
                    }
                }
            }
            this.sendHtmlResponse(response, "1");
            return;
        } catch (Exception e) {
            log.error("添加任务反馈出错：", e);
            this.sendHtmlResponse(response, "-1");
            return;
        }
    }

    /**
     * 新增时的上传附件
     *
     * @param request
     * @param response
     * @param file
     * @throws JSONException
     * @author 小杨 by 20150714
     */
    @RequestMapping("uploadFile")
    public void uploadFile(HttpServletRequest request, HttpServletResponse response, MultipartFile file, String attTempId) throws JSONException {
        try {
            SysLoginInfo info = this.getInfo(request);
            String database = info.getDatasource();
            if (file != null) {
                String regex_exe = "^.+\\.exe$";
                String regex_rar = "^.+\\.rar$";
                String regex_zip = "^.+\\.zip$";
                String originalFilename = file.getOriginalFilename();
                if (!originalFilename.matches(regex_exe) && !originalFilename.matches(regex_rar) && !originalFilename.matches(regex_zip)) {
                    //限制文件大小
                    long fileSize = file.getSize();
                    if (fileSize > CnlifeConstants.MAXFILESIZE) {
                        PushMsg pushMsg = pushMsg("上传的附件不能超过50M", Boolean.FALSE);
                        sendJsonResponse(response, JsonUtil.toJson(pushMsg));
                        return;
                    }
                    // 文件上传到目录
                    String fileNm = getFilePath();
                    String addTime = DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd HH:mm:ss");
                    List<Map<String, String>> pics = this.uploadFile(request, this.getPathUpload(request) + "/" + database + "/" + fileNm, database + "/" + fileNm);
                    // 附件信息保存
                    if (null != pics && pics.size() > 0) {
                        for (Map<String, String> map : pics) {
                            SysTaskAttachment att = new SysTaskAttachment();
                            att.setAttachName(map.get("name"));
                            att.setAttacthPath(map.get("path"));
                            att.setFsize(map.get("fsize"));
                            att.setAddTime(addTime);
                            att.setTempid(attTempId);
                            this.sysTaskAttachmentService.addTaskAttachment(att, database);
                        }
                    }
                    // 把相关附件信息全部取出 List<SysTaskAttachment>
                    List<SysTaskAttachment> attachmentList = sysTaskAttachmentService.queryAttByTempid(attTempId, database);
                    PushMsg pushMsg = pushMsg(attachmentList, Boolean.TRUE);
                    sendJsonResponse(response, JsonUtil.toJson(pushMsg));
                } else {
                    PushMsg pushMsg = pushMsg("上传的附件不能是.exe,.rar,.zip数据，上传失败", Boolean.FALSE);
                    sendJsonResponse(response, JsonUtil.toJson(pushMsg));
                }
            } else {
                PushMsg pushMsg = pushMsg("未有附件上传数据，上传失败", Boolean.FALSE);
                sendJsonResponse(response, JsonUtil.toJson(pushMsg));
            }
        } catch (Exception e) {
            PushMsg pushMsg = pushMsg("上传附件失败", Boolean.FALSE);
            sendJsonResponse(response, JsonUtil.toJson(pushMsg));
        }
    }

    /**
     * 修改时的上传附件
     *
     * @param request
     * @param response
     * @param file
     * @param id       任务ID
     * @throws JSONException
     * @创建：作者:YYP 创建时间：2015-7-15
     * @see
     */
    @RequestMapping("uploadFileForUpdate")
    public void uploadFileForUpdate(HttpServletRequest request, HttpServletResponse response, MultipartFile file, Integer id) throws JSONException {
        try {
            SysLoginInfo info = this.getInfo(request);
            String database = info.getDatasource();
            if (file != null) {
                String regex_exe = "^.+\\.exe$";
                String regex_rar = "^.+\\.rar$";
                String regex_zip = "^.+\\.zip$";
                String originalFilename = file.getOriginalFilename();

                if (!originalFilename.matches(regex_exe) && !originalFilename.matches(regex_rar) && !originalFilename.matches(regex_zip)) {
                    //限制文件大小
                    long fileSize = file.getSize();
                    if (fileSize > CnlifeConstants.MAXFILESIZE) {
                        PushMsg pushMsg = pushMsg("上传的附件不能超过50M", Boolean.FALSE);
                        sendJsonResponse(response, JsonUtil.toJson(pushMsg));
                        return;
                    }
                    // 文件上传到目录
                    String fileNm = getFilePath();
                    String addTime = DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd HH:mm:ss");
                    List<Map<String, String>> pics = this.uploadFile(request, this.getPathUpload(request) + "/" + database + "/" + fileNm, database + "/" + fileNm);
                    // 附件信息保存
                    if (null != pics && pics.size() > 0) {
                        for (Map<String, String> map : pics) {
                            SysTaskAttachment att = new SysTaskAttachment();
                            att.setAttachName(map.get("name"));
                            att.setAttacthPath(map.get("path"));
                            att.setFsize(map.get("fsize"));
                            att.setAddTime(addTime);
                            att.setNid(id);
                            this.sysTaskAttachmentService.addTaskAttachment(att, database);
                        }
                    }
                    // 把相关附件信息全部取出 List<SysTaskAttachment>
                    List<SysTaskAttachment> attachmentList = sysTaskAttachmentService.queryAttBynid(id, database);//根据任务nid查询附件信息
                    PushMsg pushMsg = pushMsg(attachmentList, Boolean.TRUE);
                    sendJsonResponse(response, JsonUtil.toJson(pushMsg));
                } else {
                    PushMsg pushMsg = pushMsg("上传的附件不能是.exe,.rar,.zip数据，上传失败", Boolean.FALSE);
                    sendJsonResponse(response, JsonUtil.toJson(pushMsg));
                }
            } else {
                PushMsg pushMsg = pushMsg("未有附件上传数据，上传失败", Boolean.FALSE);
                sendJsonResponse(response, JsonUtil.toJson(pushMsg));
            }
        } catch (Exception e) {
            PushMsg pushMsg = pushMsg("上传附件失败", Boolean.FALSE);
            sendJsonResponse(response, JsonUtil.toJson(pushMsg));
        }
    }


    /**
     * 新增时的删除附件
     *
     * @param request
     * @param response
     * @param attachmentId
     * @author 小杨 by 20150714
     */
    @RequestMapping("doUnloadFile")
    public void doUnloadFile(HttpServletRequest request, HttpServletResponse response, String attachmentId, String attTempId) {
        PushMsg pushMsg = null;
        SysLoginInfo info = this.getInfo(request);
        String database = info.getDatasource();
        if (attachmentId != null) {
			/*String[] _attachmentIds = attachmentId.split("\\,");
			for (String s : _attachmentIds) {
				System.out.println(s);
			}*/
            // 删除数据库数据
            Integer i = sysTaskAttachmentService.deleteByids(attachmentId, database);
            if (i > 0) {//删除附件
                List<SysTaskAttachment> attachmentList = sysTaskAttachmentService.queryAttByids(attachmentId, database);
                for (SysTaskAttachment sysTaskAttachment : attachmentList) {
                    String path = getPathUpload(request);
                    this.delFile(path + "/" + sysTaskAttachment.getAttacthPath());
                }
            }
            // 把相关附件信息全部取出 List<SysTaskAttachment>
            List<SysTaskAttachment> attachmentList = sysTaskAttachmentService.queryAttByTempid(attTempId, database);
            pushMsg = pushMsg(attachmentList, Boolean.TRUE);
        } else {
            pushMsg = pushMsg("未有删除数据", Boolean.FALSE);
        }
        sendJsonResponse(response, JsonUtil.toJson(pushMsg));
    }

    /**
     * 修改时的删除附件
     *
     * @param request
     * @param response
     * @param attachmentId
     * @param id           任务id
     * @author 小杨 by 20150714
     */
    @RequestMapping("doUnloadFileByUpdate")
    public void doUnloadFileByUpdate(HttpServletRequest request, HttpServletResponse response, String attachmentId, Integer id) {
        PushMsg pushMsg = null;
        SysLoginInfo info = this.getInfo(request);
        String database = info.getDatasource();
        if (attachmentId != null) {
            // 删除数据库数据
            Integer i = sysTaskAttachmentService.deleteByids(attachmentId, database);
            if (i > 0) {//删除附件
                List<SysTaskAttachment> attachmentList = sysTaskAttachmentService.queryAttByids(attachmentId, database);
                for (SysTaskAttachment sysTaskAttachment : attachmentList) {
                    String path = getPathUpload(request);
                    this.delFile(path + "/" + sysTaskAttachment.getAttacthPath());
                }
            }
            // 把相关附件信息全部取出 List<SysTaskAttachment>
            List<SysTaskAttachment> attachmentList = sysTaskAttachmentService.queryAttBynid(id, database);//根据任务nid查询附件信息
            pushMsg = pushMsg(attachmentList, Boolean.TRUE);
        } else {
            pushMsg = pushMsg("未有删除数据", Boolean.FALSE);
        }
        sendJsonResponse(response, JsonUtil.toJson(pushMsg));
    }

    /**
     * 分页查询任务
     *
     * @param response
     * @param request
     * @param task     author guojr
     *                 date 2015-7-9
     */
    @RequestMapping("taskzhixingpages")
    public String taskzhixingpages(HttpServletResponse response, HttpServletRequest request, SysTask task) {
        SysLoginInfo info = getInfo(request);
        String month = request.getParameter("month");
        String year = request.getParameter("year");
        String date = request.getParameter("date");
        if (StrUtil.isNull(month)) {
            try {
                month = DateTimeUtil.getDateToStr(new Date(), "yyyyMM");
                year = DateTimeUtil.getDateToStr(new Date(), "yyyy");
                date = DateTimeUtil.getDateToStr(new Date(), "MM");
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        List<Map<String, Object>> list = this.taskService.queryTaskZhiXing(info.getDatasource(), info.getIdKey(), month);
        request.setAttribute("list", list);
        request.setAttribute("month", month);
        request.setAttribute("year", year);
        request.setAttribute("date", date);
        return "system/task/taskzhixingpages";
    }

    /**
     * @param response
     * @param request
     * @param tid
     * @创建：作者:YYP 创建时间：2015-7-16
     * @see 任务催办
     */
    @RequestMapping("taskcbMsg")
    public void taskcbMsg(HttpServletResponse response, HttpServletRequest request, Integer tid) {
        PushMsg pushMsg = null;
        SysLoginInfo info = this.getInfo(request);
        String database = info.getDatasource();
        try {
            Map map = this.taskService.queryByMember(tid, database, SysTaskPsn.PSN_RESPONSIBILITY, null);
            if (null != map.get("ids") && map.size() != 0) {
                if (!map.get("ids").equals(info.getIdKey().toString())) {
                    Integer idKey = info.getIdKey();
                    String usrNm = info.getUsrNm();
                    List<SysChatMsg> sys = new ArrayList<SysChatMsg>();
                    String ids = map.get("ids").toString();
                    String tels = map.get("tels").toString();
                    String title = map.get("task_title").toString();
                    String[] id = ids.split(",");
                    String time = this.getDate();
                    SysChatMsg scm = new SysChatMsg();
                    scm.setAddtime(time);
                    scm.setMemberId(idKey);
                    scm.setMsg(usrNm + "：提醒您完成 [" + title + "] 任务");
                    scm.setBelongId(Integer.valueOf(tid));
                    scm.setBelongMsg("催办任务");
                    scm.setTp("10");//催办消息
                    for (String d : id) {
                        scm.setReceiveId(Integer.valueOf(d));
                        sys.add(scm);
                    }
                    // 批量添加
                    this.sysChatMsgWebService.addChatMsg(sys, database);
                    SysTaskMsg msg = new SysTaskMsg();
                    msg.setRemindTime(this.getDate());
                    msg.setNid(Integer.valueOf(tid));
                    msg.setTp("1");
                    msg.setMemId(idKey);
                    msg.setContent(usrNm + "：提醒您完成 [" + title + "] 任务");
                    this.taskService.addMsg(id, msg, database);

//					JpushClassify jc = new JpushClassify();
                    jpushClassifies.toJpush(tels, CnlifeConstants.MODE2, CnlifeConstants.NEWMSG, null, 0, "提示", null);
                    jpushClassifies2.toJpush(tels, CnlifeConstants.MODE2, CnlifeConstants.NEWMSG, null, 0, "提示", null);
                    pushMsg = pushMsg("催办成功", Boolean.TRUE);
                } else {
                    pushMsg = pushMsg("自己不催办", Boolean.FALSE);
                }
            } else {
                pushMsg = pushMsg("无催办对象", Boolean.FALSE);
            }
        } catch (Exception e) {
            pushMsg = pushMsg("催办失败", Boolean.TRUE);
        }
        sendJsonResponse(response, JsonUtil.toJson(pushMsg));
        return;
    }


}
