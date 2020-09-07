package com.qweib.cloud.biz.system.jpush;

import cn.jpush.api.JPushClient;
import com.qweib.cloud.repository.plat.ws.SysMemberWebDao;
import com.qweib.cloud.repository.utils.HttpResponseUtils;
import com.qweib.cloud.service.member.retrofit.SysMemberRequest;
import com.qweib.cloud.utils.PropertiesUtils;
import com.qweibframework.commons.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Component;

import javax.annotation.Resource;
import java.util.Map;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.LinkedBlockingQueue;
import java.util.concurrent.ThreadPoolExecutor;
import java.util.concurrent.TimeUnit;

@Component
public class JpushClassifies {

    private static final Logger logger = LoggerFactory.getLogger(JpushClassifies.class);

    public static JPushClient jpush = null;

    static {
        String appKey = PropertiesUtils.readProperties("/properties/application.properties", "jpush.appKey");
        String masterSecret = PropertiesUtils.readProperties("/properties/application.properties", "jpush.masterSecret");
        jpush = new JPushClient(masterSecret, appKey);
    }

    @Resource
    private SysMemberWebDao memberWebDao;
//    @Qualifier("memberRequest")
//    @Autowired
//    private SysMemberRequest memberRequest;

    private ExecutorService threadPool = new ThreadPoolExecutor(3, 6, 0, TimeUnit.MILLISECONDS,
            new LinkedBlockingQueue<Runnable>(), new ThreadPoolExecutor.AbortPolicy());

    /**
     * @param str          要推送的对象（手机号码），多个用“，”隔开
     * @param deptNm       应用名称，如“驰用T3”
     * @param paramContent 推送的内容
     * @param params       手机端解析的参数内容可为null(map格式的key，value)
     * @param sleepTime    线程延迟时间
     * @param modelName    模块名称（例：员工圈模块...）
     * @param remindFlag   是否自定义消息 (1 是  其他为 通知)
     * @创建：作者:YYP 创建时间：2015-1-30
     * @see
     */
    public void toJpush(String str, String deptNm, String paramContent, Map<String, Object> params, Integer sleepTime, String modelName, String remindFlag) {
        //commonPush(jpush,threadPool, memberWebDao, memberRequest, str, deptNm, paramContent, params, sleepTime, modelName, remindFlag);
    }

    public static void commonPush(JPushClient jpush,ExecutorService threadPool, SysMemberWebDao memberWebDao, SysMemberRequest memberRequest,
                                  String str, String deptNm, String paramContent, Map<String, Object> params, Integer sleepTime, String modelName, String remindFlag) {
        try {
            logger.info(modelName + "消息推送信息为：手机号码  = " + str + "，应用名称 = " + deptNm + "，线程延迟时间 = " + sleepTime + "，是否自定义消息 = " + remindFlag);
            final long starttime = System.currentTimeMillis() / 1000;
            // 不是自定义消息
            if (!"1".equals(remindFlag)) {
                // 免打扰
//                String info = HttpResponseUtils.convertResponseNull(memberRequest.findMobilesByState("1", str));
////                Object info = memberWebDao.querySetting(str, "1").get("str");
//                String nonInfo = HttpResponseUtils.convertResponseNull(memberRequest.findMobilesByState("2", str));
////                Object noinfo = memberWebDao.querySetting(str, "2").get("str");
//                if (StringUtils.isNotBlank(info)) {
//                    threadPool.submit(new JpushThread(jpush, info, deptNm, paramContent, params, "1"));
//                }
//                if (StringUtils.isNotBlank(nonInfo)) {
//                    threadPool.submit(new JpushThread(jpush, nonInfo, deptNm, paramContent, params, "2"));
//                }
            } else {
                // 1员工圈针对单个圈设置的免打扰
                threadPool.submit(new JpushThread(jpush, str, deptNm, paramContent, params, remindFlag));
            }
            final long endTime = System.currentTimeMillis() / 1000;
            logger.info(modelName + "消息推送结束：手机号码  = " + str + "，应用名称 = " + deptNm +
                    "，起始时间秒 = " + starttime + "，结束时间秒 = " + endTime + "，耗时 = " + (endTime - starttime));
        } catch (Exception e) {
            logger.error(modelName + "消息推送失败，原因为：", e);
        }
    }
}
