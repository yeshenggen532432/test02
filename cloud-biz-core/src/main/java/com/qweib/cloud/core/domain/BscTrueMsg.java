package com.qweib.cloud.core.domain;

public class BscTrueMsg {

    private Integer msgId;//自增id
    private Integer memberId;//发表人
    private String addtime;//发表时间
    private String msgTp;//发表类型1.文字2.图片3.语音
    private String msg;//发表内容
    private Integer voiceTime;
    private Integer trueId;
    private Double longitude;
    private Double latitude;

    //////不在数据库////
    private String memberNm;
    private String memberHead;


    public String getMemberNm() {
        return memberNm;
    }

    public void setMemberNm(String memberNm) {
        this.memberNm = memberNm;
    }

    public String getMemberHead() {
        return memberHead;
    }

    public void setMemberHead(String memberHead) {
        this.memberHead = memberHead;
    }

    public Integer getTrueId() {
        return trueId;
    }

    public void setTrueId(Integer trueId) {
        this.trueId = trueId;
    }

    public Integer getMsgId() {
        return msgId;
    }

    public void setMsgId(Integer msgId) {
        this.msgId = msgId;
    }

    public Integer getMemberId() {
        return memberId;
    }

    public void setMemberId(Integer memberId) {
        this.memberId = memberId;
    }

    public String getAddtime() {
        return addtime;
    }

    public void setAddtime(String addtime) {
        this.addtime = addtime;
    }

    public String getMsgTp() {
        return msgTp;
    }

    public void setMsgTp(String msgTp) {
        this.msgTp = msgTp;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    public Integer getVoiceTime() {
        return voiceTime;
    }

    public void setVoiceTime(Integer voiceTime) {
        this.voiceTime = voiceTime;
    }

    public Double getLongitude() {
        return longitude;
    }

    public void setLongitude(Double longitude) {
        this.longitude = longitude;
    }

    public Double getLatitude() {
        return latitude;
    }

    public void setLatitude(Double latitude) {
        this.latitude = latitude;
    }


}
