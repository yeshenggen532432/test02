package com.qweib.cloud.core.domain;

import com.qweib.cloud.utils.TableAnnotation;

import java.math.BigDecimal;

/**
 * 供应商
 */
public class SysProvider {
    private Integer id;
    private String proNo;//编号
    private String proName;//供应商名称
    private String address;//地址
    private String tel;//联系电话
    private String mobile;//手机
    private String contact;//联系人
    private String remarks;//备注
    private BigDecimal leftAmt;//欠款金额
    private String fbtime;//发布时间
    private Integer status;
    private String uscCode;//社会信用代码
    private String py;//拼音码
    private Integer proTypeId;//供应商类别Id
    private String  proTypeName;//供应商类别名称
    //-------------------------------
    private String database;
    public Integer getId() {
        return id;
    }
    public void setId(Integer id) {
        this.id = id;
    }
    public String getProNo() {
        return proNo;
    }
    public void setProNo(String proNo) {
        this.proNo = proNo;
    }
    public String getProName() {
        return proName;
    }
    public void setProName(String proName) {
        this.proName = proName;
    }
    public String getAddress() {
        return address;
    }
    public void setAddress(String address) {
        this.address = address;
    }
    public String getTel() {
        return tel;
    }
    public void setTel(String tel) {
        this.tel = tel;
    }
    public String getMobile() {
        return mobile;
    }
    public void setMobile(String mobile) {
        this.mobile = mobile;
    }
    public String getContact() {
        return contact;
    }
    public void setContact(String contact) {
        this.contact = contact;
    }
    public String getRemarks() {
        return remarks;
    }
    public void setRemarks(String remarks) {
        this.remarks = remarks;
    }
    public BigDecimal getLeftAmt() {
        return leftAmt;
    }
    public void setLeftAmt(BigDecimal leftAmt) {
        this.leftAmt = leftAmt;
    }
    public Integer getStatus() {
        return status;
    }
    public void setStatus(Integer status) {
        this.status = status;
    }
    public String getFbtime() {
        return fbtime;
    }
    public void setFbtime(String fbtime) {
        this.fbtime = fbtime;
    }

    @TableAnnotation(insertAble=false,updateAble=false)
    public String getDatabase() {
        return database;
    }
    public void setDatabase(String database) {
        this.database = database;
    }
    public String getUscCode() {
        return uscCode;
    }
    public void setUscCode(String uscCode) {
        this.uscCode = uscCode;
    }
    public String getPy() {
        return py;
    }
    public void setPy(String py) {
        this.py = py;
    }

    public Integer getProTypeId() { return proTypeId; }
    public void setProTypeId(Integer proTypeId) { this.proTypeId = proTypeId; }
    @TableAnnotation(insertAble=false,updateAble=false)
    public String getProTypeName() { return proTypeName; }
    public void setProTypeName(String proTypeName) { this.proTypeName = proTypeName; }
}
