package com.qweib.cloud.biz.system.auth.event;

import com.qweib.cloud.biz.system.auth.AuthManager;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.connection.Message;
import org.springframework.data.redis.connection.MessageListener;
import org.springframework.data.redis.serializer.StringRedisSerializer;

/**
 * @author: jimmy.lin
 * @time: 2019/11/15 17:29
 * @description:
 */
@Slf4j
public class UserRoleChangedEventListener implements MessageListener {
    @Autowired
    private AuthManager authManager;
    @Autowired
    private StringRedisSerializer redisSerializer;

    @Override
    public void onMessage(Message message, byte[] pattern) {
        String database = redisSerializer.deserialize(message.getBody());
        log.debug("on user role change event : [{}]", database);
        authManager.clearPermissionCache(database);
    }
}
