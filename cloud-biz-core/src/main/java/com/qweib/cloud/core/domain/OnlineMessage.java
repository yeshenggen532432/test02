package com.qweib.cloud.core.domain;

/**
 * 用户是否在线的消息提示类.
 * 
 * @author lhq
 * @since JDK 1.6
 * @see
 */
public class OnlineMessage {

    /**
     * 返回状态，标示接口调用成功或者失败.
     */
    private boolean isSuccess = false;
    /**
     * 处理结果提示信息,failure-失败;success-成功.
     */
    private String message = WebServerConstants.LONGIN_FAILURE;
    /**
     * 当前登录用户.
     */
    private OnlineUser onlineMember;

    public OnlineMessage() {
        super();
    }

    public OnlineMessage(boolean isSuccess, String message) {
        this.isSuccess = isSuccess;
        this.message = message;
    }

    public boolean isSuccess() {
        return isSuccess;
    }

    public void setSuccess(boolean isSuccess) {
        this.isSuccess = isSuccess;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public OnlineUser getOnlineMember() {
        return onlineMember;
    }

    public void setOnlineMember(OnlineUser onlineMember) {
        this.onlineMember = onlineMember;
    }

}
