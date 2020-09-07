package com.qweib.cloud.biz.signin.model;

import com.qweib.cloud.utils.TableAnnotation;

import java.util.List;

public class SysSignIn {
    private Integer id;
    private Integer mid;
    private String longitude;
    private String latitude;
    private String address;
    private String signTime;
    private String remarks;
    private Integer status;
    private Integer voiceTime;
    ////////////////////////
    private String memberNm;
    private String sdate;
    private String edate;
    private List<SysSignDetail> detailList;
    private List<SysSignImgVo> listpic;
    private String memberHead;
    private String voiceUrl;
    private String mids;
    private String signType;//1.上班，2：下班，3.流动

    public String getMids() {
        return mids;
    }

    public void setMids(String mids) {
        this.mids = mids;
    }

    @TableAnnotation(insertAble=false,updateAble=false)
    public List<SysSignImgVo> getListpic() {
        return listpic;
    }

    public void setListpic(List<SysSignImgVo> listpic) {
        this.listpic = listpic;
    }

    @TableAnnotation(insertAble=false,updateAble=false)
    public String getMemberHead() {
        return memberHead;
    }

    public void setMemberHead(String memberHead) {
        this.memberHead = memberHead;
    }

    @TableAnnotation(insertAble=false,updateAble=false)
    public String getVoiceUrl() {
        return voiceUrl;
    }

    public void setVoiceUrl(String voiceUrl) {
        this.voiceUrl = voiceUrl;
    }

    @TableAnnotation(insertAble=false,updateAble=false)
    public List<SysSignDetail> getDetailList() {
        return detailList;
    }

    public void setDetailList(List<SysSignDetail> detailList) {
        this.detailList = detailList;
    }

    public Integer getVoiceTime() {
        return voiceTime;
    }

    public void setVoiceTime(Integer voiceTime) {
        this.voiceTime = voiceTime;
    }

    @TableAnnotation(insertAble=false,updateAble=false)
    public String getSdate() {
        return sdate;
    }

    public void setSdate(String sdate) {
        this.sdate = sdate;
    }

    @TableAnnotation(insertAble=false,updateAble=false)
    public String getEdate() {
        return edate;
    }

    public void setEdate(String edate) {
        this.edate = edate;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getMid() {
        return mid;
    }

    public void setMid(Integer mid) {
        this.mid = mid;
    }

    public String getLongitude() {
        return longitude;
    }

    public void setLongitude(String longitude) {
        this.longitude = longitude;
    }

    public String getLatitude() {
        return latitude;
    }

    public void setLatitude(String latitude) {
        this.latitude = latitude;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getSignTime() {
        return signTime;
    }

    public void setSignTime(String signTime) {
        this.signTime = signTime;
    }

    public String getRemarks() {
        return remarks;
    }

    public void setRemarks(String remarks) {
        this.remarks = remarks;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

    @TableAnnotation(insertAble=false,updateAble=false)
    public String getMemberNm() {
        return memberNm;
    }

    public void setMemberNm(String memberNm) {
        this.memberNm = memberNm;
    }

    @TableAnnotation(insertAble=false,updateAble=false)
    public String getSignType() {
        return signType;
    }

    public void setSignType(String signType) {
        this.signType = signType;
    }
}
