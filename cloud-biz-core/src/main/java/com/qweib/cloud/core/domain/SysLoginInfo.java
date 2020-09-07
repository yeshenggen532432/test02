package com.qweib.cloud.core.domain;

import com.qweib.cloud.service.member.common.CertifyStateEnum;

import java.io.Serializable;
import java.util.List;
import java.util.Map;


public class SysLoginInfo implements Serializable {
	private Integer idKey;				//公共平台用户id
	private String usrNm;				//用户名
	private String usrNo;				//账号
	private String usrPwd;				//密码
	private String datasource;          //数据库名称
	private List<Integer> usrRoleIds;	//角色
	private String tpNm;                //公司类型 
	private Integer cid;                //客户id
	private String fdCompanyId;
	private String fdCompanyNm;
	private String fdMemberMobile;		//手机号
	private CertifyStateEnum certifyState;		// 认证状态
	private Integer pageVersion;		// 页面版本：null:不选择; 0:旧版; 1:新版
	private String token;
	
	private  List<Map<String,Object>>  companyList;
	private String companysJson;
	private Integer shopMemberId;

	public String getCompanysJson() {
		return companysJson;
	}
	public void setCompanysJson(String companysJson) {
		this.companysJson = companysJson;
	}
	public List<Map<String, Object>> getCompanyList() {
		return companyList;
	}
	public void setCompanyList(List<Map<String, Object>> companyList) {
		this.companyList = companyList;
	}
	public String getFdMemberMobile() {
		return fdMemberMobile;
	}
	public void setFdMemberMobile(String fdMemberMobile) {
		this.fdMemberMobile = fdMemberMobile;
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
	public Integer getCid() {
		return cid;
	}
	public void setCid(Integer cid) {
		this.cid = cid;
	}
	public String getTpNm() {
		return tpNm;
	}
	public void setTpNm(String tpNm) {
		this.tpNm = tpNm;
	}
	public Integer getIdKey() {
		return idKey;
	}
	public void setIdKey(Integer idKey) {
		this.idKey = idKey;
	}
	public List<Integer> getUsrRoleIds() {
		return usrRoleIds;
	}
	public void setUsrRoleIds(List<Integer> usrRoleIds) {
		this.usrRoleIds = usrRoleIds;
	}
	public String getUsrPwd() {
		return usrPwd;
	}
	public void setUsrPwd(String usrPwd) {
		this.usrPwd = usrPwd;
	}
	public String getUsrNo() {
		return usrNo;
	}
	public void setUsrNo(String usrNo) {
		this.usrNo = usrNo;
	}
	public String getUsrNm() {
		return usrNm;
	}
	public void setUsrNm(String usrNm) {
		this.usrNm = usrNm;
	}
	public String getDatasource() {
		return datasource;
	}
	public void setDatasource(String datasource) {
		this.datasource = datasource;
	}

	public CertifyStateEnum getCertifyState() {
		return certifyState;
	}

	public void setCertifyState(CertifyStateEnum certifyState) {
		this.certifyState = certifyState;
	}

	public Integer getPageVersion() {
		return pageVersion;
	}

	public void setPageVersion(Integer pageVersion) {
		this.pageVersion = pageVersion;
	}

	public Integer getShopMemberId() {
		return shopMemberId;
	}

	public void setShopMemberId(Integer shopMemberId) {
		this.shopMemberId = shopMemberId;
	}

	public String getToken() {
		return token;
	}

	public void setToken(String token) {
		this.token = token;
	}
}