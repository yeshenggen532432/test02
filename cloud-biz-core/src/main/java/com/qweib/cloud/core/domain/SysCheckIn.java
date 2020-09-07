package com.qweib.cloud.core.domain;


import com.qweib.cloud.utils.TableAnnotation;

import java.util.List;

/**
 * 签到
 *
 * @author guojp
 */
public class SysCheckIn {
    /**
     * ID
     */
    private Integer id;
    /**
     * 人员ID
     */
    private Integer psnId;
    /**
     * 签到日期时间
     */
    private String checkTime;
    /**
     * 工作内容
     */
    private String jobContent;
    /**
     * 上传的图片
     */
    private List<SysCheckinPic> picList;
    /**
     * 位置
     */
    private String location;
    /**
     * 位置备注
     */
    private String remark;
    /**
     * 类型  1 考勤 2 外出反馈
     */
    private String tp;//1-1 上班签到 2 外出考勤 1-2 下班签到

    private Double longitude;
    private Double latitude;
    private String cdzt;//迟到/早退
    /************页面显示******************/
    private String pic;
    /************页面显示******************/

    private Integer sbType;//1:永不上报；2：始终上报
    private String autoDown;//1.自动下班

    //不在数据库
    private String memberNm;
    private Integer counts;

    @TableAnnotation(insertAble = false, updateAble = false)
    public Integer getCounts() {
        return counts;
    }

    public void setCounts(Integer counts) {
        this.counts = counts;
    }

    public String getCdzt() {
        return cdzt;
    }

    public void setCdzt(String cdzt) {
        this.cdzt = cdzt;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public String getMemberNm() {
        return memberNm;
    }

    public void setMemberNm(String memberNm) {
        this.memberNm = memberNm;
    }

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

    public String getCheckTime() {
        return checkTime;
    }

    public void setCheckTime(String checkTime) {
        this.checkTime = checkTime;
    }

    public String getJobContent() {
        return jobContent;
    }

    public void setJobContent(String jobContent) {
        this.jobContent = jobContent;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getRemark() {
        return remark;
    }

    public void setRemark(String remark) {
        this.remark = remark;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public List<SysCheckinPic> getPicList() {
        return picList;
    }

    public void setPicList(List<SysCheckinPic> picList) {
        this.picList = picList;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public String getPic() {
        return pic;
    }

    public void setPic(String pic) {
        this.pic = pic;
    }

    public String getTp() {
        return tp;
    }

    public void setTp(String tp) {
        this.tp = tp;
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

    public Integer getSbType() {
        return sbType;
    }

    public void setSbType(Integer sbType) {
        this.sbType = sbType;
    }

    public String getAutoDown() {
        return autoDown;
    }

    public void setAutoDown(String autoDown) {
        this.autoDown = autoDown;
    }
}
