package com.qweib.cloud.core.dao;

import com.google.common.collect.Lists;
import com.qweib.commons.Collections3;
import com.qweib.commons.StringUtils;
import com.qweibframework.boot.datasource.DataSourceContextAllocator;
import com.qweibframework.boot.datasource.DataSourceContextHolder;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Component;

import java.util.List;

/**
 * @author jimmy.lin
 * create at 2020/1/20 17:46
 */
@Slf4j
@Component
public class DynamicDataSourceTemplate {
    private static final String PREFIX_KEY = "config::runtime:";
    private static final String KEY_DB = "db";
    private static final String KEY_DATASOURCE = "database";
    @Autowired
    @Qualifier("confStringRedisTemplate")
    private StringRedisTemplate redisTemplate;
    @Autowired
    private DataSourceContextAllocator allocator;

    public <T> T execute(String tenantId, DynamicDataSourceAction<T> action) {
        return execute(tenantId, null, action);
    }


    public <T> T execute(String tenantId, String dataSource, DynamicDataSourceAction<T> action) {
        final String old = DataSourceContextHolder.get();
        try {
            dataSource = getDataSource(tenantId, dataSource);
            allocator.alloc(dataSource, tenantId);
            return action.handle(dataSource);
        } finally {
            allocator.release();
            DataSourceContextHolder.set(old);
        }
    }


    private String getDataSource(String tenantId, String dataSource) {
        if (StringUtils.isEmpty(dataSource)) {
            List<Object> items = redisTemplate.opsForHash()
                    .multiGet(PREFIX_KEY + tenantId,
                            Lists.newArrayList(KEY_DB, KEY_DATASOURCE));
            if (Collections3.isNotEmpty(items) && items.size() == 2) {
                dataSource = (String) items.get(1);
            } else {
                log.debug("item not found for ({})", tenantId);
            }
        }
        return dataSource;
    }

}
