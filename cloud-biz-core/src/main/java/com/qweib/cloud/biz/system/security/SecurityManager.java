package com.qweib.cloud.biz.system.security;

/**
 * @author: jimmy.lin
 * @time: 2019/9/2 10:32
 * @description:
 */
public interface SecurityManager {

    /**
     * 出错后标记次数
     *
     * @param mobile
     * @param platform
     * @return
     */
    MarkResult mark(String mobile, Platform platform);

    /**
     * 登录成功或找回密码后清楚标记
     *
     * @param mobile
     * @param platform
     */
    void reset(String mobile, Platform platform);

    MarkResult get(String mobile, Platform platform);

}
