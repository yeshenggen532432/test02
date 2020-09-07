package com.qweib.cloud.biz.system.auth.event;

import com.qweib.cloud.biz.system.auth.AuthManager;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.connection.Message;
import org.springframework.data.redis.connection.MessageListener;

/**
 * @author: jimmy.lin
 * @time: 2019/11/15 11:12
 * @description:
 */
@Slf4j
public class CloudMenuChangedEventListener implements MessageListener {
    @Autowired
    private AuthManager authManager;

    @Override
    public void onMessage(Message message, byte[] pattern) {
        authManager.refreshMenuMap();
        authManager.clearPermissionCache();
    }
}
