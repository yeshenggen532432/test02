package com.qweib.cloud.core.domain;


import com.qweib.cloud.service.member.common.CompanyStatusEnum;
import com.qweib.cloud.utils.TableAnnotation;

public class SysCorporation {
    private Long deptId;                  //单位/部门id
    private String deptNm;                   //单位/部门名称
    private Long deptPid;                 //所属单位/部门
    private String deptLevel;                //单位级别(暂时最多3级)1.单位2.子单位 3.部门
    private String deptPath;                 //单位/部门所属关系 如:-1-2-3-
    private String deptNum;                 //公司规模
    private String deptAddr;                 //单位/部门地址
    private String deptPhone;                //单位/部门电话
    private String deptDesc;                 //单位/部门介绍
    private String deptTrade;               //公司所属行业
    private String deptHead;                //部门头像
    private String datasource;
    private String addTime;                 //创建时间
    private Integer memberId;              //创建人
    private String endDate;                 //到期日期
    private String tpNm;                 //公司类型
    private String platformCompanyId;//新平台唯一标识id
    private String dogKey;
    private String brand;
    private Integer empQty;
    private String leader;
    private Integer staffQty;
    private String email;

    //不在数据库
    private String memberNm;//创建人名称
    private String mobile;//创建人电话
    private CompanyStatusEnum status;
    private Integer pageVersion;

    private String nodeId;
    private String groupId;
    private Integer shopOpen;
    private Integer excludeMemberId;

    private String customDomain;

    @TableAnnotation(updateAble = false, insertAble = false)
    public Integer getShopOpen() {
        return shopOpen;
    }

    public void setShopOpen(Integer shopOpen) {
        this.shopOpen = shopOpen;
    }

    @TableAnnotation(updateAble = false, insertAble = false)
    public Integer getExcludeMemberId() {
        return excludeMemberId;
    }

    public void setExcludeMemberId(Integer excludeMemberId) {
        this.excludeMemberId = excludeMemberId;
    }

    public String getPlatformCompanyId() {
        return platformCompanyId;
    }

    public void setPlatformCompanyId(String platformCompanyId) {
        this.platformCompanyId = platformCompanyId;
    }

    public String getTpNm() {
        return tpNm;
    }

    public void setTpNm(String tpNm) {
        this.tpNm = tpNm;
    }

    public String getEndDate() {
        return endDate;
    }

    public void setEndDate(String endDate) {
        this.endDate = endDate;
    }

    @TableAnnotation(updateAble = false, insertAble = false)
    public String getMobile() {
        return mobile;
    }

    public void setMobile(String mobile) {
        this.mobile = mobile;
    }

    @TableAnnotation(updateAble = false, insertAble = false)
    public String getMemberNm() {
        return memberNm;
    }

    public void setMemberNm(String memberNm) {
        this.memberNm = memberNm;
    }

    public Integer getMemberId() {
        return memberId;
    }

    public void setMemberId(Integer memberId) {
        this.memberId = memberId;
    }

    public String getAddTime() {
        return addTime;
    }

    public void setAddTime(String addTime) {
        this.addTime = addTime;
    }

    public String getDatasource() {
        return datasource;
    }

    public void setDatasource(String datasource) {
        this.datasource = datasource;
    }

    public String getDeptAddr() {
        return deptAddr;
    }

    public void setDeptAddr(String deptAddr) {
        this.deptAddr = deptAddr;
    }

    public String getDeptDesc() {
        return deptDesc;
    }

    public void setDeptDesc(String deptDesc) {
        this.deptDesc = deptDesc;
    }

    public Long getDeptId() {
        return deptId;
    }

    public void setDeptId(Long deptId) {
        this.deptId = deptId;
    }

    public String getDeptLevel() {
        return deptLevel;
    }

    public void setDeptLevel(String deptLevel) {
        this.deptLevel = deptLevel;
    }

    public String getDeptNm() {
        return deptNm;
    }

    public void setDeptNm(String deptNm) {
        this.deptNm = deptNm;
    }

    public String getDeptPath() {
        return deptPath;
    }

    public void setDeptPath(String deptPath) {
        this.deptPath = deptPath;
    }

    public String getDeptPhone() {
        return deptPhone;
    }

    public void setDeptPhone(String deptPhone) {
        this.deptPhone = deptPhone;
    }

    public Long getDeptPid() {
        return deptPid;
    }

    public void setDeptPid(Long deptPid) {
        this.deptPid = deptPid;
    }

    public String getDeptNum() {
        return deptNum;
    }

    public void setDeptNum(String deptNum) {
        this.deptNum = deptNum;
    }

    public String getDeptTrade() {
        return deptTrade;
    }

    public void setDeptTrade(String deptTrade) {
        this.deptTrade = deptTrade;
    }

    public String getDeptHead() {
        return deptHead;
    }

    public void setDeptHead(String deptHead) {
        this.deptHead = deptHead;
    }

    public String getDogKey() {
        return dogKey;
    }

    public void setDogKey(String dogKey) {
        this.dogKey = dogKey;
    }

    public CompanyStatusEnum getStatus() {
        return status;
    }

    public void setStatus(CompanyStatusEnum status) {
        this.status = status;
    }

    @TableAnnotation(updateAble = false, insertAble = false)
    public Integer getPageVersion() {
        return pageVersion;
    }

    public void setPageVersion(Integer pageVersion) {
        this.pageVersion = pageVersion;
    }

    @TableAnnotation(updateAble = false, insertAble = false)
    public String getNodeId() {
        return nodeId;
    }

    public void setNodeId(String nodeId) {
        this.nodeId = nodeId;
    }

    @TableAnnotation(updateAble = false, insertAble = false)
    public String getGroupId() {
        return groupId;
    }

    public void setGroupId(String groupId) {
        this.groupId = groupId;
    }

    @TableAnnotation(updateAble = false, insertAble = false)
    public String getCustomDomain() {
        return customDomain;
    }

    public void setCustomDomain(String customDomain) {
        this.customDomain = customDomain;
    }

    public String getBrand() {
        return brand;
    }

    public void setBrand(String brand) {
        this.brand = brand;
    }

    public Integer getEmpQty() {
        return empQty;
    }

    public void setEmpQty(Integer empQty) {
        this.empQty = empQty;
    }

    public String getLeader() {
        return leader;
    }

    public void setLeader(String leader) {
        this.leader = leader;
    }

    public Integer getStaffQty() {
        return staffQty;
    }

    public void setStaffQty(Integer staffQty) {
        this.staffQty = staffQty;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }
}
