package com.qweib.cloud.biz.common;

import com.qweib.cloud.core.domain.SysLoginInfo;
import com.qweib.cloud.service.member.domain.cluster.ClusterNodeDTO;
import com.qweibframework.commons.Identities;
import com.qweibframework.commons.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Component;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2019/6/19 - 11:40
 */
@Component
public class ClusterNodeRedisHandler {

    @Qualifier("memberRedisTemplate")
    @Autowired
    private RedisTemplate redisTemplate;
    private String keyPrefix = "session_node:";

    public ClusterNodeDTO getCurrentNode(String nodeId) {
        ClusterNodeDTO nodeDTO = null;
        if (StringUtils.isNotBlank(nodeId)) {
            nodeDTO = (ClusterNodeDTO) redisTemplate.opsForValue()
                    .get("clusterNode::cluster:node:" + nodeId);
        }

        if (nodeDTO == null) {
            nodeDTO = (ClusterNodeDTO) redisTemplate.opsForValue()
                    .get("clusterNode::cluster:node:default");
        }

        return nodeDTO;
    }

    public String putNodeKey(SysLoginInfo loginInfo) {
        final String key = Identities.uuid2();
        redisTemplate.opsForValue().set(keyPrefix + key, loginInfo);

        return key;
    }

    public SysLoginInfo getAndRemoteKey(String key) {
        SysLoginInfo loginInfo = (SysLoginInfo) redisTemplate.opsForValue().get(keyPrefix + key);
        redisTemplate.delete(keyPrefix + key);

        return loginInfo;
    }

    public static String getRedirectUrl(String url) {
        if (StringUtils.isBlank(url)) {
            return StringUtils.EMPTY;
        }

        if (!StringUtils.startsWith(url, "http:")) {
            url = "http://" + url;
        }

        if (!StringUtils.endsWith(url, "/")) {
            url += "/";
        }

        return url;
    }
}
