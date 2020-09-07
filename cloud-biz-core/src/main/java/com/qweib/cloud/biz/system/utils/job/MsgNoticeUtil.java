package com.qweib.cloud.biz.system.utils.job;

import com.qweib.cloud.biz.common.JavaSmsApi;
import com.qweib.cloud.biz.common.MailUtil;
import com.qweib.cloud.biz.system.Mail;
import com.qweib.cloud.biz.system.jpush.JpushClassifies;
import com.qweib.cloud.biz.system.msg.SysMemberMsgSubscribeService;
import com.qweib.cloud.biz.system.msg.SysSubjectMsgService;
import com.qweib.cloud.biz.system.service.company.CompanyMemberService;
import com.qweib.cloud.biz.system.service.ws.SysChatMsgService;
import com.qweib.cloud.core.domain.SysChatMsg;
import com.qweib.cloud.core.domain.SysMember;
import com.qweib.cloud.core.domain.msg.SysMemberMsgSubscribe;
import com.qweib.cloud.core.domain.msg.SysSubjectMsg;
import com.qweib.cloud.utils.DateTimeUtil;
import com.qweib.cloud.utils.SpringContextHolder;
import com.qweib.cloud.utils.StrUtil;
import com.qweib.commons.StringUtils;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.beanutils.PropertyUtils;

import java.lang.reflect.InvocationTargetException;
import java.util.*;

/**
 * 消息通知工具类
 */
@Slf4j
public class MsgNoticeUtil {

    private static SysMemberMsgSubscribeService sysMemberMsgSubscribeService = SpringContextHolder.getBean(SysMemberMsgSubscribeService.class);

    private static SysSubjectMsgService sysSubjectMsgService = SpringContextHolder.getBean(SysSubjectMsgService.class);

    private static JpushClassifies jpushClassifies = SpringContextHolder.getBean(JpushClassifies.class);

    private static CompanyMemberService companyMemberService = SpringContextHolder.getBean(CompanyMemberService.class);

    private static SysChatMsgService sysChatMsgWebService = SpringContextHolder.getBean(SysChatMsgService.class);

    private static final String company_admin = "company_admin";//公司管理员标记对应数据库sys_role--role_cd

    public static void exe(MsgSubjectSignEnum sign, Map<String, String> parament, String database) {
        exe(sign, parament, null, database);
    }

    public static void exe(MsgSubjectSignEnum sign, Map<String, String> parament, Integer belongId, String database) {
        try {
            if (sign == null || StrUtil.isNull(database))
                throw new RuntimeException("消息通知出现错误信息 sign=" + sign + ",database=" + database);
            List<SysMemberMsgSubscribe> memberMsgSubscribeList = sysMemberMsgSubscribeService.findAllBySign(sign, database);//所有订阅用户
            SysSubjectMsg sysSubjectMsg = sysSubjectMsgService.findBySign(sign.toString());
            if (sysSubjectMsg == null) {
                log.info("消息通知标记未找到sign=" + sign + ",database=" + database);
                return;
            }
            formatMsg(sysSubjectMsg, parament);//格式化消息

            //订阅的会员
            Map<Integer, SysMemberMsgSubscribe> subscribeMap = new HashMap<>();

           /* //查找出公司管理员
            List<SysMember> memberList = companyMemberService.queryMenByroleCd(database, company_admin);
            //默认管理订阅推送功能
            SysMemberMsgSubscribe temp = null;
            for (SysMember sysMember : memberList) {
                temp = new SysMemberMsgSubscribe(sysMember.getMemberId());
                subscribeMap.put(sysMember.getMemberId(), temp);
            }*/

            //获取订阅的所有会员ID
            StringBuffer ids = new StringBuffer();
            for (SysMemberMsgSubscribe sysMemberMsgSubscribe : memberMsgSubscribeList) {
                if (subscribeMap.get(sysMemberMsgSubscribe.getMemberId()) != null) continue;
                if (ids.length() > 0) ids.append(",");
                ids.append(sysMemberMsgSubscribe.getMemberId());
                subscribeMap.put(sysMemberMsgSubscribe.getMemberId(), sysMemberMsgSubscribe);
            }
            List<SysMember> memberList = companyMemberService.queryCompanyMemberByIds(database, ids.toString());

            //推送
            try {
                pushNotice(getSubscribeMember(subscribeMap, memberList, "pushNotice"), sysSubjectMsg, belongId, database);
            } catch (Exception e) {
                log.error("推送消息出现错误", e);
            }
            //短信通知
            try {
                mobileNotice(getSubscribeMember(subscribeMap, memberList, "mobileNotice"), sysSubjectMsg);
            } catch (Exception e) {
                log.error("短信通知出现错误", e);
            }
            //邮件通知
            try {
                emailNotice(getSubscribeMember(subscribeMap, memberList, "emailNotice"), sysSubjectMsg);
            } catch (Exception e) {
                log.error("邮件通知出现错误", e);
            }
            //微信通知
            try {
                // wxMemberList = getSubscribeMember(subscribeMap, memberList, "wxNotice");
            } catch (Exception e) {
                log.error("微信通知出现错误", e);
            }
        } catch (Exception ex) {
            log.error("消息通知出现错误", ex);
        }
    }

    /**
     * 格式化消息
     *
     * @param sysSubjectMsg
     * @param parament
     */
    private static void formatMsg(SysSubjectMsg sysSubjectMsg, Map<String, String> parament) {
        Iterator<String> it = parament.keySet().iterator();
        while (it.hasNext()) {
            String key = it.next();
            String value = parament.get(key);
            if (value == null) continue;
            key = "{" + key + "}";
            sysSubjectMsg.setPushMsg(sysSubjectMsg.getPushMsg().replace(key, value));
            sysSubjectMsg.setMobileMsg(sysSubjectMsg.getMobileMsg().replace(key, value));
            sysSubjectMsg.setEmailMsg(sysSubjectMsg.getEmailMsg().replace(key, value));
            sysSubjectMsg.setWxMsg(sysSubjectMsg.getWxMsg().replace(key, value));

        }
        //内容加上商城名称
        if (StringUtils.isNotBlank(parament.get("companyName"))) {
            sysSubjectMsg.setPushMsg(parament.get("companyName") + "-" + sysSubjectMsg.getPushMsg());
        }
    }

    /**
     * 获取对应订阅的会员列表
     *
     * @param subscribeMap
     * @param memberList
     * @return
     */
    private static List<SysMember> getSubscribeMember(Map<Integer, SysMemberMsgSubscribe> subscribeMap, List<SysMember> memberList, String name) throws IllegalAccessException, NoSuchMethodException, InvocationTargetException {
        List<SysMember> subscribeMemberList = new ArrayList<>();
        Iterator<Integer> it = subscribeMap.keySet().iterator();
        while (it.hasNext()) {
            Integer memberId = it.next();
            SysMemberMsgSubscribe sysMemberMsgSubscribe = subscribeMap.get(memberId);
            Object value = PropertyUtils.getProperty(sysMemberMsgSubscribe, name);
            if (value != null && Integer.valueOf(value.toString()) == 1) {//订阅状态0否1是
                for (SysMember sysMember : memberList) {
                    if (sysMember.getMemberId().equals(memberId)) {
                        subscribeMemberList.add(sysMember);
                        break;
                    }
                }
            }
        }
        return subscribeMemberList;
    }

    /**
     * 推送方法
     *
     * @param memberList
     * @param sysSubjectMsg
     * @param database
     */
    private static void pushNotice(List<SysMember> memberList, SysSubjectMsg sysSubjectMsg, Integer belongId, String database) {
        if (memberList == null || memberList.isEmpty() || StrUtil.isNull(sysSubjectMsg.getPushMsg())) return;

     /*   List<SysChatMsg> msgs = new ArrayList<SysChatMsg>();
        StringBuffer str = new StringBuffer();
        for (SysMember sysMemDTO : memberList) {
            SysChatMsg scm = new SysChatMsg();
            try {
                scm.setAddtime(DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd HH:mm:ss"));
            } catch (Exception e) {
                e.printStackTrace();
            }
            //scm.setMemberId(0);
            scm.setMsg("新订单支付成功");
//				scm.setMsgTp("1");
            scm.setReceiveId(sysMemDTO.getMemberId());
            scm.setTp("100");
            scm.setBelongId(1);
            scm.setBelongNm("新订单号5555");
            scm.setBelongMsg("新订单支付成功说明xxxxxx支付类型:xxx");
            msgs.add(scm);
            if (str.length() > 0) str.append(",");
            str.append(sysMemDTO.getMemberMobile());
        }
        sysChatMsgWebService.addChatMsg(msgs, database);

        // 批量推送
        jpushClassifies.toJpush(str.toString(), CnlifeConstants.MODE9, CnlifeConstants.NEWMSG, null, null, "订单支付成功消息推送", "2");//不屏蔽
*/

        // --------------先做信息保存--------------
        List<SysChatMsg> msgs = new ArrayList<SysChatMsg>();
        StringBuffer str = new StringBuffer();
        for (SysMember sysMember : memberList) {
            SysChatMsg scm = new SysChatMsg();
            try {
                scm.setAddtime(DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd HH:mm:ss"));
            } catch (Exception e) {
                e.printStackTrace();
            }
            //scm.setMemberId(0);
            scm.setMsg(sysSubjectMsg.getName());
//				scm.setMsgTp("1");
            scm.setReceiveId(sysMember.getMemberId());
            scm.setTp(sysSubjectMsg.getPushType());
            scm.setBelongId(belongId);
            scm.setBelongNm(sysSubjectMsg.getName());
            //scm.setBelongMsg(sysSubjectMsg.getPushMsg());
            scm.setMsg(sysSubjectMsg.getPushMsg());
            msgs.add(scm);
            if (str.length() > 0) str.append(",");
            str.append(sysMember.getMemberMobile());
        }
        sysChatMsgWebService.addChatMsg(msgs, database);
        // 批量推送
        //jpushClassifies.toJpush(str.toString(), sysSubjectMsg.getPushMode(), CnlifeConstants.NEWMSG, null, null, sysSubjectMsg.getName(), "2");//不屏蔽
        String pushMsg = sysSubjectMsg.getPushMsg();
        if (pushMsg.length() > 30)
            pushMsg = pushMsg.substring(0, 30) + "...";
        jpushClassifies.toJpush(str.toString(), sysSubjectMsg.getPushMode(), pushMsg, null, null, sysSubjectMsg.getName(), "2");//不屏蔽
    }

    /**
     * 短信批量发送
     *
     * @param memberList
     * @param sysSubjectMsg
     */
    private static void mobileNotice(List<SysMember> memberList, SysSubjectMsg sysSubjectMsg) {
        List<String> mobileList = getMemberProperty(memberList, "memberMobile");
        if (mobileList == null || StrUtil.isNull(sysSubjectMsg.getMobileMsg())) return;
        JavaSmsApi.batchSend(sysSubjectMsg.getMobileMsg(), String.join(",", mobileList));
    }

    /**
     * 邮件发送批量发送
     *
     * @param memberList
     * @param sysSubjectMsg
     */
    private static void emailNotice(List<SysMember> memberList, SysSubjectMsg sysSubjectMsg) {
        List<String> emailList = getMemberProperty(memberList, "email");
        if (emailList == null || StrUtil.isNull(sysSubjectMsg.getEmailMsg())) return;
        Mail mail = new Mail();
        MailUtil.sendMails(String.join(",", emailList), sysSubjectMsg.getName(), sysSubjectMsg.getEmailMsg());
        // boolean flag = mail.sendMail((String[]) emailList.toArray(), sysSubjectMsg.getEmailMsg(), sysSubjectMsg.getName());
    }


    /**
     * 获取用户对应中对应的数据
     *
     * @param memberList
     * @param name
     */
    private static List<String> getMemberProperty(List<SysMember> memberList, String name) {
        if (memberList == null || memberList.isEmpty()) return null;
        List<String> list = new ArrayList<>();
        for (SysMember sysMember : memberList) {
            try {
                Object str = PropertyUtils.getProperty(sysMember, name);
                if (str != null && str.toString().length() > 0)
                    list.add(str + "");
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return list;
    }
}
