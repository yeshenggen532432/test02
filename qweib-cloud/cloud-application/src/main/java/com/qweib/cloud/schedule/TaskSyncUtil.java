package com.qweib.cloud.schedule;


import com.qweib.cloud.biz.common.CnlifeConstants;
import com.qweib.cloud.biz.system.jpush.JpushClassifies;
import com.qweib.cloud.biz.system.jpush.JpushClassifies2;
import com.qweib.cloud.biz.system.service.plat.SysCorporationService;
import com.qweib.cloud.biz.system.service.ws.BscPlanWebService;
import com.qweib.cloud.biz.system.service.ws.SysChatMsgService;
import com.qweib.cloud.biz.system.service.ws.SysTaskMsgService;
import com.qweib.cloud.core.domain.BscPlan;
import com.qweib.cloud.core.domain.SysChatMsg;
import com.qweib.cloud.core.domain.SysTask;
import com.qweib.cloud.core.domain.SysTaskMsg;
import org.springframework.beans.factory.annotation.Autowired;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class TaskSyncUtil {

    @Autowired
    private SysCorporationService sysCorporationService;
    @Autowired
    private SysTaskMsgService sysTaskMsgService;
    @Autowired
    private SysChatMsgService sysChatMsgService;
    @Autowired
    private JpushClassifies jpushClassifies;
    @Autowired
    private JpushClassifies2 jpushClassifies2;
    @Autowired
    private BscPlanWebService bscPlanWebService;

    @Deprecated
    public void addmsg(String ids, SysChatMsg msg, SysTaskMsg taskMsg, SysTask task, Integer tx1, String database, String content) {
        for (String id : ids.split(",")) {
            msg.setReceiveId(Integer.valueOf(id));
            msg.setMsg(content);
            msg.setBelongId(task.getId());
            msg.setTp("11");
            msg.setBelongMsg("系统消息");
            taskMsg.setNid(task.getId());
            taskMsg.setPsnId(Integer.valueOf(id));
            taskMsg.setContent(content);
            taskMsg.setTp("2");
            sysTaskMsgService.addSysTaskMsg(taskMsg, database);
            sysChatMsgService.addChatMsg(msg, database);
        }
    }


    public void tasksysPush() {
//        this.toPushBscPlan();
//        //查询所有公司
//        List<SysCorporation> list = sysCorporationService.queryAllDatabase();
//        //根据公司列表查询需要推送的任务
//        String time = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date());
//        if (null != list && list.size() > 0) {
//            List<SysChatMsg> msgList = new ArrayList<SysChatMsg>();
//            String tels = "";
//            String tids = "";
//            for (SysCorporation sc : list) {
//                String database = sc.getDatasource();
//                try {
//                    List<SysTaskIng> taskIngs = sysTaskService.queryPushTaskIng(database);//查询要推送的数据
//                    if (null != taskIngs && taskIngs.size() > 0) {
//                        for (SysTaskIng sysTaskIng : taskIngs) {
//                            SysChatMsg msg = new SysChatMsg();
//                            msg.setReceiveId(sysTaskIng.getCreateBy());
//                            msg.setAddtime(time);
//                            String premind = sysTaskIng.getPremind();
//                            String content = "";
//                            if ("-1".equals(premind)) {
//                                content = "5分钟";
//                            } else {
//                                content = premind + "%";
//                            }
//                            msg.setMsg(" [" + sysTaskIng.getTaskTitle() + "] 完成时间剩余" + content + ",请尽快完成.");
//                            msg.setTp("11");
//                            Integer taskId = sysTaskIng.getTaskId();//主表任务id
//                            msg.setBelongId(taskId);
//                            msg.setBelongMsg("系统消息");
//                            msgList.add(msg);
//                            tels += sysTaskIng.getMemberMobile() + ",";//号码隔开推送用
//                            tids += sysTaskIng.getId() + ",";//删除已推送任务表数据用
//                        }
//                        Integer i = sysChatMsgService.addChatMsg(msgList, database);
//                        if (i > 0) {//未读消息保存成功，删除备份表中的数据
//                            sysTaskService.deleteTaskIngs(tids.substring(0, tids.length() - 1), database);
//                        }
//                        jpushClassifies.toJpush(tels.substring(0, tels.length() - 1), CnlifeConstants.MODE2, CnlifeConstants.NEWMSG, null, 0, "提示", null);
//                        jpushClassifies2.toJpush(tels.substring(0, tels.length() - 1), CnlifeConstants.MODE2, CnlifeConstants.NEWMSG, null, 0, "提示", null);
//                    }
//                } catch (Exception e) {
//
//                }
//
//                //轮询支付记录
//                this.shopStkOutService.updatePayLogProcess(database);
//            }
//
//        }
    }

    @Deprecated
    public void toPushBscPlan() {
        //查询所有公司
        List<String> list = sysCorporationService.queryAllDatabase();
        //根据公司列表查询需要推送的任务
        String time = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date());
        String time2 = new SimpleDateFormat("yyyy-MM-dd").format(new Date());
        String time3 = new SimpleDateFormat("HH:mm").format(new Date()).substring(0, 4);
        if (time3.equals("07:1")) {
            if (null != list && list.size() > 0) {
                List<SysChatMsg> msgList = new ArrayList<SysChatMsg>();
                String tels = "";
                for (String database : list) {
                    if (database.equals("sjk1460427117375139") || database.equals("ll137")) {
                        int count = this.sysChatMsgService.queryMsgJhCount(database, time2);
                        if (count < 1) {
                            List<BscPlan> listp = bscPlanWebService.queryPlanByPdate(time2, database);//查询要推送的数据
                            if (null != listp && listp.size() > 0) {
                                for (BscPlan bscPlan : listp) {
                                    SysChatMsg msg = new SysChatMsg();
                                    msg.setReceiveId(bscPlan.getMid());
                                    msg.setAddtime(time);
                                    msg.setMsg("您今天有" + bscPlan.getNum() + "家客户要拜访");
                                    msg.setTp("32");
                                    msg.setBelongMsg("计划提醒");
                                    msgList.add(msg);
                                    tels += bscPlan.getTel() + ",";//号码隔开推送用
                                }
                                sysChatMsgService.addChatMsg2(msgList, database);
                                jpushClassifies.toJpush(tels.substring(0, tels.length() - 1), CnlifeConstants.MODE7, CnlifeConstants.NEWMSG, null, 0, "提示", null);
                                jpushClassifies2.toJpush(tels.substring(0, tels.length() - 1), CnlifeConstants.MODE7, CnlifeConstants.NEWMSG, null, 0, "提示", null);
                            }
                        }
                    }
                }
            }
        }
    }
}
