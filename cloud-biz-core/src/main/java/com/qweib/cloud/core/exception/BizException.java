package com.qweib.cloud.core.exception;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2019/1/10 - 15:32
 */
public class BizException extends RuntimeException {

    private int code;

    public BizException() {
    }

    public BizException(int code) {
        this.code = code;
    }

    public BizException(int code, String message) {
        super(message);
        this.code = code;
    }

    public BizException(String message) {
        super(message);
        this.code = 500;
    }

    public int getCode() {
        return code;
    }

}
