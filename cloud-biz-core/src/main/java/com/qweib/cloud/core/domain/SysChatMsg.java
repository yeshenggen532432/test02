package com.qweib.cloud.core.domain;


import com.qweib.cloud.utils.TableAnnotation;

/**
 * 消息临时表
 */
public class SysChatMsg {
    private Integer id;// 自增id
    private Integer memberId;// 发送人id
    private Integer receiveId;// 接收人id
    private String addtime;// 发表时间
    private String msgTp;// 发表类型1.文字2.图片3.语音
    private String msg;// 发表内容
    private Integer voiceTime;// 语音时间
    private String tp;// 消息类型：1 添加圈主题 2 话题评论 3 话题点赞 4 添加照片墙 5 照片墙评论 6 照片墙点赞 7@人 8 加入退出圈请求9 圈聊天  10催办  11进度 12 企业公告 13 系统公告,100以上商城
    private Integer belongId;// 对应id
    private String belongNm;//对应名称
    private String belongMsg;//对应更多信息（如圈聊天存放圈头像）
    private Integer msgId;//对应存完整数据表的msgId
    private Double longitude;
    private Double latitude;

    //不在数据库
    private String memberHead;//头像
    private String memberNm;//昵称


    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    @TableAnnotation(updateAble = false, insertAble = false)
    public String getMemberHead() {
        return memberHead;
    }

    public void setMemberHead(String memberHead) {
        this.memberHead = memberHead;
    }

    @TableAnnotation(updateAble = false, insertAble = false)
    public String getMemberNm() {
        return memberNm;
    }

    public void setMemberNm(String memberNm) {
        this.memberNm = memberNm;
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

    public Integer getReceiveId() {
        return receiveId;
    }

    public void setReceiveId(Integer receiveId) {
        this.receiveId = receiveId;
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

    public String getTp() {
        return tp;
    }

    public void setTp(String tp) {
        this.tp = tp;
    }

    public Integer getBelongId() {
        return belongId;
    }

    public void setBelongId(Integer belongId) {
        this.belongId = belongId;
    }

    public String getBelongNm() {
        return belongNm;
    }

    public void setBelongNm(String belongNm) {
        this.belongNm = belongNm;
    }

    public String getBelongMsg() {
        return belongMsg;
    }

    public void setBelongMsg(String belongMsg) {
        this.belongMsg = belongMsg;
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
