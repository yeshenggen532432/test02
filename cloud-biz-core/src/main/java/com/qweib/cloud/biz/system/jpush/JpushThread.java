package com.qweib.cloud.biz.system.jpush;

import cn.jpush.api.JPushClient;
import cn.jpush.api.common.resp.APIConnectionException;
import cn.jpush.api.common.resp.APIRequestException;
import cn.jpush.api.push.PushResult;
import cn.jpush.api.push.model.Message;
import cn.jpush.api.push.model.Options;
import cn.jpush.api.push.model.Platform;
import cn.jpush.api.push.model.PushPayload;
import cn.jpush.api.push.model.audience.Audience;
import cn.jpush.api.push.model.notification.AndroidNotification;
import cn.jpush.api.push.model.notification.IosNotification;
import cn.jpush.api.push.model.notification.Notification;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.Map;
import java.util.concurrent.Callable;

public class JpushThread implements Callable<PushResult> {

    public static Logger logger = LoggerFactory.getLogger(JpushThread.class);

    private JPushClient jpush;
    private String mobile;
    private String msgTitle;
    private String msgContent;
    private Map<String, Object> extra;
    private String remindFlag;

    /**
     * 根据别名发送推送
     *
     * @param mobile         手机号
     * @param msgTitle       消息标题
     * @param msgContent     消息内容  必填
     * @param extra          附加参数
     * @param remindFlag     是否自定义消息
     * @return
     */
    public JpushThread(JPushClient jpush, String mobile, String msgTitle,
                       String msgContent, Map<String, Object> extra, String remindFlag) {
        this.jpush = jpush;
        this.mobile = mobile;
        this.msgTitle = msgTitle;
        this.msgContent = msgContent;
        this.extra = extra;
        this.remindFlag = remindFlag;
    }

    @Override
    public PushResult call() throws Exception {
        logger.info("极光推送开始，手机号 = " + mobile + "，是否自定义消息 = " + remindFlag);
        PushResult pushResult = null;
        try {//自定义消息
            String[] mobilArray = mobile.split(",");
            if ("1".equals(remindFlag)) {
                pushResult = jpush.sendPush(PushPayload.newBuilder()
                        .setPlatform(Platform.android_ios())
                        .setAudience(Audience.alias(mobilArray))
                        .setMessage(Message.newBuilder()
                                .setTitle(msgTitle)
                                .setMsgContent(msgContent)
                                .build())
                        .build());
            } else {//通知
                pushResult = jpush.sendPush(PushPayload.newBuilder()
                        .setPlatform(Platform.android_ios())
                        .setAudience(Audience.alias(mobilArray))
                        .setNotification(Notification.newBuilder()
                                .setAlert(msgContent)
                                .addPlatformNotification(AndroidNotification.newBuilder()
                                        .setTitle(msgTitle).build())
                                .addPlatformNotification(IosNotification.newBuilder()
                                        .setBadge(1)
                                        .setSound("happy")
                                        .addExtra("extra_key", "extra_value").build())
                                .build())
                        .setOptions(Options.newBuilder()
                                .setApnsProduction(true)
                                .build())
                        .build());
            }
            if (pushResult.isResultOK()) {
                logger.info("极光推送完成，手机号 = " + mobile);
            }
        } catch (APIConnectionException e) {
            logger.error("Connection error. Should retry later. ", e);

        } catch (APIRequestException e) {
            logger.error("极光推送异常，手机号 = " + mobile + "，异常信息:" + e.getErrorMessage());
            logger.info("极光推送失败，手机号 = " + mobile + "，HTTP Status: " + e.getStatus() + "Error Code: " + e.getErrorCode() + "Error Message: " + e.getErrorMessage() + "Msg ID: " + e.getMsgId());
        }

        return pushResult;
    }

}
