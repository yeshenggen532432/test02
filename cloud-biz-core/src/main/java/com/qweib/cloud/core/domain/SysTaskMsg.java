package com.qweib.cloud.core.domain;


import com.qweib.cloud.utils.TableAnnotation;

/**
 * 说明：催办消息模型
 *
 * @创建：作者:zrp 创建时间：2015-1-26
 * @修改历史： [序号](zrp 2015 - 1 - 26)<修改说明>
 */
public class SysTaskMsg {
    private Integer id;
    private Integer psnId;// 人员ID
    private String remindTime;// 时间
    private Integer nid;// 所属照片墙
    private String content;//内容

    private Integer memId;//发送人id
    private String tp;  //类型 :1 催办消息 2 提醒 3 申请加入通知 4 @人 5 退出圈 6 申请加入圈 7 移除成员
    private String recieveMobile;//接收人号码（邀请同事用）
    private String agree;//是否同意 -1不同意 1 同意
    private String msg;//邀请加入圈放role 邀请加入公司放database

    @TableAnnotation(updateAble = false)
    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getPsnId() {
        return psnId;
    }

    public void setPsnId(Integer psnId) {
        this.psnId = psnId;
    }

    public String getRemindTime() {
        return remindTime;
    }

    public void setRemindTime(String remindTime) {
        this.remindTime = remindTime;
    }

    public Integer getNid() {
        return nid;
    }

    public void setNid(Integer nid) {
        this.nid = nid;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Integer getMemId() {
        return memId;
    }

    public void setMemId(Integer memId) {
        this.memId = memId;
    }

    public String getTp() {
        return tp;
    }

    public void setTp(String tp) {
        this.tp = tp;
    }

    public String getRecieveMobile() {
        return recieveMobile;
    }

    public void setRecieveMobile(String recieveMobile) {
        this.recieveMobile = recieveMobile;
    }

    public String getAgree() {
        return agree;
    }

    public void setAgree(String agree) {
        this.agree = agree;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }


}
