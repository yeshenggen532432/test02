package com.qweib.cloud.biz.common;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.LinkedBlockingQueue;
import java.util.concurrent.ThreadPoolExecutor;
import java.util.concurrent.TimeUnit;

/**
 * 系统统一线程池
 */
public class SysThreadPool {

    public static ExecutorService threadPool = new ThreadPoolExecutor(3, 10, 0, TimeUnit.MILLISECONDS,
            new LinkedBlockingQueue<Runnable>(), new ThreadPoolExecutor.AbortPolicy());


}
