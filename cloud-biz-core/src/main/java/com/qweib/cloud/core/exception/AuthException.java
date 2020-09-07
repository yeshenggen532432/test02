package com.qweib.cloud.core.exception;

public class AuthException extends BizException {


    public AuthException() {
        super(413, "请先登录系统");
    }

    public AuthException(String message) {
        super(message);
    }
}
