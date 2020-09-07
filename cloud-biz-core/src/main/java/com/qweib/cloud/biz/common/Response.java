package com.qweib.cloud.biz.common;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2018/12/27 - 14:59
 */
public class Response<T> {

    private static final int CODE_SUCCESS = 200;
    private static final int CODE_ERROR = 500;

    private boolean state;
    private int code;
    private String message;
    private String msg;
    private T data;

    public int getCode() {
        return code;
    }

    public Response<T> setCode(int code) {
        this.code = code;
        return this;
    }

    public String getMessage() {
        return message;
    }

    public Response<T> setMessage(String message) {
        this.message = message;
        this.msg = message;
        return this;
    }

    public T getData() {
        return data;
    }

    public Response<T> setData(T data) {
        this.data = data;
        return this;
    }

    public static <T> Response createSuccess(T data) {
        Response<T> response = new Response<>();
        response.setCode(CODE_SUCCESS);
        response.setData(data);
        response.setState(true);
        return response;
    }

    public static Response createSuccess() {
        return createSuccess(null);
    }

    public static Response createError(String message) {
        Response response = new Response<>();
        response.setCode(CODE_ERROR);
        response.setMessage(message);
        return response;
    }

    public boolean isState() {
        return state;
    }

    public void setState(boolean state) {
        this.state = state;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }
}
