package com.qweib.cloud.biz.common;

import com.qweib.cloud.core.domain.OnlineMessage;

public class TokenContext {

    private static ThreadLocal<OnlineMessage> USER = new ThreadLocal<>();

    public static void setToken(OnlineMessage message) {
        USER.set(message);
    }

    public static OnlineMessage getToken() {
        return USER.get();
    }

    public static void clear() {
        USER.remove();
    }
}
