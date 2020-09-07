package com.qweib.cloud.factory;

import com.google.common.cache.Cache;
import com.google.common.cache.CacheBuilder;
import org.springframework.beans.factory.config.AbstractFactoryBean;

import java.util.concurrent.TimeUnit;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2019/9/10 - 11:58
 */
public class LogCacheFactory<T> extends AbstractFactoryBean<Cache<String, T>> {

    private long maximumSize;
    private long expireAfterAccess;

    @Override
    public Class<?> getObjectType() {
        return Cache.class;
    }

    @Override
    protected Cache<String, T> createInstance() throws Exception {
        return CacheBuilder.newBuilder()
                .maximumSize(maximumSize)
                .expireAfterAccess(expireAfterAccess, TimeUnit.SECONDS)
                .build();
    }

    public void setMaximumSize(long maximumSize) {
        this.maximumSize = maximumSize;
    }

    public void setExpireAfterAccess(long expireAfterAccess) {
        this.expireAfterAccess = expireAfterAccess;
    }
}
