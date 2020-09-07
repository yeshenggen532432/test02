package com.qweib.cloud.biz.common;

/**
 */
public class ResponseOld<T> {

    private boolean state;
    private String msg;
    private T data;
    private T list;

    public T getData() {
        return data;
    }

    public ResponseOld<T> setData(T data) {
        this.data = data;
        return this;
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

    public T getList() {
        return list;
    }

    public void setList(T list) {
        this.list = list;
    }
}
