package com.qweib.cloud.core.domain;


import com.qweib.cloud.utils.TableAnnotation;

/**
 * @author YYP
 * 客户端版本管理实体类
 */
public class SysVersion {
    private Long id;                  //客户端版本id
    private String versionName;          //客户端版本名称
    private String appNo;                // 具体版本号
    private String versionTime;          //版本更新时间
    private Integer versionUser;          //版本更新发布人
    private String versionType;           //版本系统类型：0:android 1:ios
    private String versionContent;        //版本更新信息
    private String versionUrl;            //下载地址
    private String isQz;                  //是否强制更新（1是；2否）
    //==============不在数据库===============//
    private String memberNm;

    @TableAnnotation(insertAble = false, updateAble = false)
    public String getMemberNm() {
        return memberNm;
    }

    public void setMemberNm(String memberNm) {
        this.memberNm = memberNm;
    }


    public String getIsQz() {
        return isQz;
    }

    public void setIsQz(String isQz) {
        this.isQz = isQz;
    }

    public String getVersionUrl() {
        return versionUrl;
    }

    public void setVersionUrl(String versionUrl) {
        this.versionUrl = versionUrl;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getVersionName() {
        return versionName;
    }

    public void setVersionName(String versionName) {
        this.versionName = versionName;
    }

    public String getAppNo() {
        return appNo;
    }

    public void setAppNo(String appNo) {
        this.appNo = appNo;
    }

    public String getVersionTime() {
        return versionTime;
    }

    public void setVersionTime(String versionTime) {
        this.versionTime = versionTime;
    }

    public Integer getVersionUser() {
        return versionUser;
    }

    public void setVersionUser(Integer versionUser) {
        this.versionUser = versionUser;
    }

    public String getVersionType() {
        return versionType;
    }

    public void setVersionType(String versionType) {
        this.versionType = versionType;
    }

    public String getVersionContent() {
        return versionContent;
    }

    public void setVersionContent(String versionContent) {
        this.versionContent = versionContent;
    }

}
