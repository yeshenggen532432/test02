package com.qweib.cloud.core.domain;

/**
 * 说明：客户信息
 *
 * @创建：作者:llp 创建时间：2016-2-17
 * @修改历史： [序号](llp 2016 - 2 - 17)<修改说明>
 */
public class SysCustomerWeb {
    private Integer id;//客户id
    private String khNm;//名称
    private Integer khTp;//客户种类（1经销商；2客户）
    private String qdtpNm;//渠道类型
    private String xsjdNm;//销售阶段
    private String linkman;//联系人
    private String mobile;//手机
    private String tel;//电话
    private String province;//省
    private String city;//市
    private String area;//区县
    private String address;//地址
    private String memberNm;//业务员名称
    private Integer memId;//业务员id
    private String branchName;//部门名称
    private String longitude;//经度
    private String latitude;//纬度
    private String jlkm;// 距离
    private String xxzt;// 新鲜度（临期，正常）
    private String scbfDate;//上次拜访日期


    public Integer getMemId() {
        return memId;
    }

    public void setMemId(Integer memId) {
        this.memId = memId;
    }

    public String getTel() {
        return tel;
    }

    public void setTel(String tel) {
        this.tel = tel;
    }

    public Integer getKhTp() {
        return khTp;
    }

    public void setKhTp(Integer khTp) {
        this.khTp = khTp;
    }

    public String getScbfDate() {
        return scbfDate;
    }

    public void setScbfDate(String scbfDate) {
        this.scbfDate = scbfDate;
    }

    public String getXxzt() {
        return xxzt;
    }

    public void setXxzt(String xxzt) {
        this.xxzt = xxzt;
    }

    public String getJlkm() {
        return jlkm;
    }

    public void setJlkm(String jlkm) {
        this.jlkm = jlkm;
    }

    public String getLatitude() {
        return latitude;
    }

    public void setLatitude(String latitude) {
        this.latitude = latitude;
    }

    public String getLongitude() {
        return longitude;
    }

    public void setLongitude(String longitude) {
        this.longitude = longitude;
    }

    public String getBranchName() {
        return branchName;
    }

    public void setBranchName(String branchName) {
        this.branchName = branchName;
    }

    public String getMemberNm() {
        return memberNm;
    }

    public void setMemberNm(String memberNm) {
        this.memberNm = memberNm;
    }

    public String getXsjdNm() {
        return xsjdNm;
    }

    public void setXsjdNm(String xsjdNm) {
        this.xsjdNm = xsjdNm;
    }

    public String getQdtpNm() {
        return qdtpNm;
    }

    public void setQdtpNm(String qdtpNm) {
        this.qdtpNm = qdtpNm;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getArea() {
        return area;
    }

    public void setArea(String area) {
        this.area = area;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getKhNm() {
        return khNm;
    }

    public void setKhNm(String khNm) {
        this.khNm = khNm;
    }

    public String getLinkman() {
        return linkman;
    }

    public void setLinkman(String linkman) {
        this.linkman = linkman;
    }

    public String getMobile() {
        return mobile;
    }

    public void setMobile(String mobile) {
        this.mobile = mobile;
    }

    public String getProvince() {
        return province;
    }

    public void setProvince(String province) {
        this.province = province;
    }


}
