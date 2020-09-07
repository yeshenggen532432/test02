package com.qweib.cloud.core.domain.constants;

/**
 * @author jimmy.lin
 * create at 2020/3/25 20:19
 */
public interface Global {
    /**
     * 正常登录状态
     */
    int PRESENCE_ONLINE = 0;
    /**
     * 异地登录
     */
    int PRESENCE_KICKED_OFF = 1;
    /**
     * 系统踢出
     */
    int PRESENCE_EVICT = 2;
}
