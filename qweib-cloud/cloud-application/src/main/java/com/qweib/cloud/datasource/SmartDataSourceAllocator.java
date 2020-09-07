package com.qweib.cloud.datasource;

import com.qweib.cloud.biz.system.UserContext;
import com.qweib.commons.StringUtils;
import com.qweibframework.boot.datasource.support.AbstractDataSourceContextAllocator;
import com.qweibframework.boot.datasource.tenancy.TenantContext;
import com.qweibframework.boot.datasource.tenancy.TenantInfo;
import com.qweibframework.boot.datasource.tenancy.TenantScope;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.data.redis.core.StringRedisTemplate;

/**
 * @author: jimmy.lin
 * @time: 2019/9/16 16:27
 * @description:
 */
@Slf4j
public class SmartDataSourceAllocator extends AbstractDataSourceContextAllocator {
    private static final String PREFIX_KEY = "config::runtime:";
    private static final String KEY_DB = "db";
    @Autowired
    @Qualifier("confStringRedisTemplate")
    private StringRedisTemplate redisTemplate;


    @Override
    public String doAlloc(String tenant, String companyId) {
        //TODO 未经open-resty获得datasource 则重新从缓存获取一次
        String key = (String) redisTemplate.opsForHash().get(PREFIX_KEY + companyId, KEY_DB);
        log.trace("{}:{} loading conf {}", companyId, tenant, key);
        
        if (StringUtils.isNotEmpty(companyId)) {
            TenantInfo tenantInfo = TenantInfo.builder()
                    .tenantId(Integer.valueOf(companyId))
                    .build();
            TenantContext.setTenant(tenantInfo);
            TenantScope scope = TenantScope.create(key);
            TenantContext.setScope(scope);
            log.trace("scope:{}", scope);
        }
        return key;
    }


}
