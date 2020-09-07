package com.qweib.cloud.core.domain;


import com.qweib.cloud.utils.TableAnnotation;

public class BscSort {

    private Integer sortId;//评论id
    private Integer groupId;//员工圈id
    private String sortNm;//所属话题
    private Integer memberId;//添加人id
    private String createTime;//创建时间

    //不在数据库中
    private String memberNm;//添加人用户名

    @TableAnnotation(updateAble = false, insertAble = false)
    public String getMemberNm() {
        return memberNm;
    }

    public void setMemberNm(String memberNm) {
        this.memberNm = memberNm;
    }

    public Integer getSortId() {
        return sortId;
    }

    public void setSortId(Integer sortId) {
        this.sortId = sortId;
    }

    public String getSortNm() {
        return sortNm;
    }

    public void setSortNm(String sortNm) {
        this.sortNm = sortNm;
    }

    public Integer getMemberId() {
        return memberId;
    }

    public void setMemberId(Integer memberId) {
        this.memberId = memberId;
    }

    public String getCreateTime() {
        return createTime;
    }

    public void setCreateTime(String createTime) {
        this.createTime = createTime;
    }

    public Integer getGroupId() {
        return groupId;
    }

    public void setGroupId(Integer groupId) {
        this.groupId = groupId;
    }


}
