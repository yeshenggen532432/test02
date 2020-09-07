package com.qweib.cloud.core.domain;


import com.qweib.cloud.utils.TableAnnotation;

/**
 * 系统使用日记
 *
 * @author apple
 */
public class SysUseLog {
    private Integer id;
    private String fdCreateTime;//创建日期    
    private String fdMemberId;//使用人ID
    private String fdMemberNm;//使用人名称
    private String fdMemberMobile;//使用人电话
    private String fdCompanyId;//公司Id
    private String fdCompanyNm;//公司名称
    private String dataSource;//数据源
    private String fdIp;//使用者IP地址
    private String fdUrl;//所使用的功能
    private String fdMenuName;//菜单名称


    //=============================
    private String sdate;//开始时间
    private String edate;//结束时间
    private String op;//操作

    public String getOp() {
        return op;
    }

    public void setOp(String op) {
        this.op = op;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public String getSdate() {
        return sdate;
    }

    public void setSdate(String sdate) {
        this.sdate = sdate;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
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

    public String getDataSource() {
        return dataSource;
    }

    public String getFdMemberMobile() {
        return fdMemberMobile;
    }

    public void setFdMemberMobile(String fdMemberMobile) {
        this.fdMemberMobile = fdMemberMobile;
    }

    public void setDataSource(String dataSource) {
        this.dataSource = dataSource;
    }

    public String getFdCreateTime() {
        return fdCreateTime;
    }

    public void setFdCreateTime(String fdCreateTime) {
        this.fdCreateTime = fdCreateTime;
    }

    public String getFdMemberId() {
        return fdMemberId;
    }

    public void setFdMemberId(String fdMemberId) {
        this.fdMemberId = fdMemberId;
    }

    public String getFdMemberNm() {
        return fdMemberNm;
    }

    public void setFdMemberNm(String fdMemberNm) {
        this.fdMemberNm = fdMemberNm;
    }

    public String getFdCompanyId() {
        return fdCompanyId;
    }

    public void setFdCompanyId(String fdCompanyId) {
        this.fdCompanyId = fdCompanyId;
    }

    public String getFdCompanyNm() {
        return fdCompanyNm;
    }

    public void setFdCompanyNm(String fdCompanyNm) {
        this.fdCompanyNm = fdCompanyNm;
    }

    public String getFdIp() {
        return fdIp;
    }

    public void setFdIp(String fdIp) {
        this.fdIp = fdIp;
    }

    public String getFdUrl() {
        return fdUrl;
    }

    public void setFdUrl(String fdUrl) {
        this.fdUrl = fdUrl;
    }

    public String getFdMenuName() {
        return fdMenuName;
    }

    public void setFdMenuName(String fdMenuName) {
        this.fdMenuName = fdMenuName;
    }
}
