package com.qweib.cloud.web.interceptor;

import com.google.common.cache.Cache;
import com.qweib.cloud.factory.pojo.LogCache;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import java.util.concurrent.ExecutionException;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2019/9/10 - 18:10
 */
public abstract class AbstractLogCacheInterceptor extends HandlerInterceptorAdapter {

    @Value("${log.cache.data-maximum-size:10}")
    private long dataMaximumSize;
    @Value("${log.cache.expire-after-access:60}")
    private long expireAfterAccess;
    @Autowired
    private Cache<String, LogCache> logCache;

    protected boolean urlIsRepeatAccess(String token, String url) {
        try {
            LogCache dataCache = this.logCache.get(token, () -> new LogCache(dataMaximumSize, expireAfterAccess));
            return dataCache.checkIsExist(url);
        } catch (ExecutionException e) {
            return Boolean.FALSE;
        }
    }
}
