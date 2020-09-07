package com.qweib.cloud.core.domain;


import com.qweib.cloud.utils.TableAnnotation;

/**
 * 圈成员
 */
public class BscEmpGroupMember {
    private Integer groupId;//圈id
    private Integer memberId;//成员id
    private String role;//成员角色 1.群主2.管理员3.普通成员
    private String addtime;//加入时间
    private String lastime;//最后聊天时间
    private String remindFlag;// 0 自动提醒1 不提醒
    private String topFlag;// 0不置顶1置顶
    private String topTime;// 置顶时间

    /////不在数据库/////
    private String memberHead;//头像

    @TableAnnotation(insertAble = false, updateAble = false)
    public String getMemberHead() {
        return memberHead;
    }

    public void setMemberHead(String memberHead) {
        this.memberHead = memberHead;
    }

    public Integer getGroupId() {
        return groupId;
    }

    public void setGroupId(Integer groupId) {
        this.groupId = groupId;
    }

    public Integer getMemberId() {
        return memberId;
    }

    public void setMemberId(Integer memberId) {
        this.memberId = memberId;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getAddtime() {
        return addtime;
    }

    public void setAddtime(String addtime) {
        this.addtime = addtime;
    }

    public String getLastime() {
        return lastime;
    }

    public void setLastime(String lastime) {
        this.lastime = lastime;
    }


    public String getRemindFlag() {
        return remindFlag;
    }

    public void setRemindFlag(String remindFlag) {
        this.remindFlag = remindFlag;
    }

    public String getTopFlag() {
        return topFlag;
    }

    public void setTopFlag(String topFlag) {
        this.topFlag = topFlag;
    }

    public String getTopTime() {
        return topTime;
    }

    public void setTopTime(String topTime) {
        this.topTime = topTime;
    }


}
