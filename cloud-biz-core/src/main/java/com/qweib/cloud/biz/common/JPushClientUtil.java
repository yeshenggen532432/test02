package com.qweib.cloud.biz.common;


import cn.jpush.api.JPushClient;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.Map;

/**
 * @param
 * @author YYP by 20150721
 * @说明：发送推送
 * @创建：作者:yxy 创建时间：2013-9-4
 * @修改历史： [序号](yxy 2013 - 9 - 4)<修改说明>
 * <p>
 * 已作废
 */
@Deprecated
public class JPushClientUtil {
    public static Logger log = LoggerFactory.getLogger(JPushClientUtil.class.getName());
    private static JPushClient jpush = new JPushClient("19e79e465ebb4fad2a3a3a2a", "a6ce7e6b708f982128988e51");

    /**
     * 根据别名发送推送
     *
     * @param sendNo         自增数字
     * @param msgTitle       消息标题
     * @param msgContent     消息内容  必填
     * @param msgContentType 消息内容类型
     * @param extra          附加参数
     * @param remindFlag     是否自定义消息
     * @return
     */
    public static boolean jPushMessage(int sendNo, String alias, String msgTitle, String msgContent, Map<String, Object> extra, String remindFlag) {
//		jpush.setEnableSSL(true);
//		MessageResult msgResult = null;
//		if("1".equals(remindFlag)){//自定义消息
//			msgResult = jpush.sendCustomMessageWithAlias(sendNo, alias, msgTitle, msgContent, "2", extra);
//		}else{//通知
//			msgResult = jpush.sendNotificationWithAlias(sendNo, alias, msgTitle, msgContent, 2, extra);
//		}
//		if (null != msgResult) {
//		    if (msgResult.getErrcode() == ErrorCodeEnum.NOERROR.value()) {
//		        return true;
//		    } else {
//		    	log.error("推送错误提示代码:"+msgResult.getErrcode()+"推送错误提示信息:"+msgResult.getErrmsg());
//		    	return false;
//		    }
//		} else {
//			log.error("推送异常:未推送");
//		    return false;
//		}
        return Boolean.FALSE;
    }

    public static void main(String[] args) {
//		Thread test = new Thread();
        jpushThread jThread = new jpushThread(System.currentTimeMillis(), "14759206561", "", "", null, null, "2");
        Thread thread = new Thread(jThread, "");
        thread.start();

    }
}
