package com.qweib.cloud.factory.pojo;

import com.google.common.cache.Cache;
import com.google.common.cache.CacheBuilder;

import java.util.concurrent.TimeUnit;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2019/9/10 - 17:51
 */
public class LogCache {

    private static byte[] TAG = new byte[0];

    private final Cache<String, byte[]> dataCache;

    public LogCache(long maximumSize, long expireAfterAccess) {
        this.dataCache = CacheBuilder.newBuilder()
                .maximumSize(maximumSize)
                .expireAfterAccess(expireAfterAccess, TimeUnit.SECONDS)
                .build();
    }

    public boolean checkIsExist(String url) {
        byte[] bytes = dataCache.getIfPresent(url);
        if (bytes != null) {
            return Boolean.TRUE;
        } else {
            dataCache.put(url, TAG);
            return Boolean.FALSE;
        }
    }
}
