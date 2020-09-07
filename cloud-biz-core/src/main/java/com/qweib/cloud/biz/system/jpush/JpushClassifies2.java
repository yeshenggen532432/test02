package com.qweib.cloud.biz.system.jpush;

import cn.jpush.api.JPushClient;
import com.qweib.cloud.repository.plat.ws.SysMemberWebDao;
import com.qweib.cloud.service.member.retrofit.SysMemberRequest;
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
public class JpushClassifies2 {

    private static JPushClient jpush = new JPushClient("187964595f8c064a5d98d596", "9ce542eead5904e20138967f");

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
        // 暂时先注释上面那个key不存在zzx 05-14
        // JpushClassifies.commonPush(jpush, threadPool, memberWebDao, memberRequest, str, deptNm, paramContent, params, sleepTime, modelName, remindFlag);
    }

}
