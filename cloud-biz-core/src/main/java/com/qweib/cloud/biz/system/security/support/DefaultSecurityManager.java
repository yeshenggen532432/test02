package com.qweib.cloud.biz.system.security.support;

import com.qweib.cloud.biz.system.security.MarkResult;
import com.qweib.cloud.biz.system.security.Platform;
import com.qweib.cloud.biz.system.security.SecurityManager;
import com.qweibframework.commons.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.data.redis.core.StringRedisTemplate;

/**
 * @author: jimmy.lin
 * @time: 2019/9/2 12:00
 * @description:
 */
public class DefaultSecurityManager implements SecurityManager {
    private static final String KEY_PREFIX = "uglcw_security:";
    @Autowired
    @Qualifier("stringRedisTemplate")
    private StringRedisTemplate redisTemplate;

    private String key(String mobile, Platform platform) {
        return KEY_PREFIX + mobile + ":" + platform.name();
    }

    @Override
    public MarkResult mark(String mobile, Platform platform) {
        Long count = redisTemplate.opsForValue().increment(key(mobile, platform), 1);
        MarkResult result = new MarkResult();
        result.setCount(count);
        return result;
    }

    @Override
    public void reset(String mobile, Platform platform) {
        redisTemplate.delete(key(mobile, platform));
    }

    @Override
    public MarkResult get(String mobile, Platform platform) {
        String count = redisTemplate.opsForValue().get(key(mobile, platform));
        long c = 0;
        if (StringUtils.isNumeric(count)) {
            c = Long.parseLong(count);
        }
        MarkResult result = new MarkResult();
        result.setCount(c);
        return result;
    }
}
