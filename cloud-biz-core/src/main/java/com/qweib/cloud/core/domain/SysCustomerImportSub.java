package com.qweib.cloud.core.domain;


import com.qweib.cloud.utils.TableAnnotation;

import java.util.List;

/**
 *说明：客户信息
 *@创建：作者:llp		创建时间：2016-2-17
 *@修改历史：
 *		[序号](llp	2016-2-17)<修改说明>
 */
public class SysCustomerImportSub {
	private Integer mastId;
	private Integer id;//客户id
	private Integer cstId;
	private String khCode;//编码
	private String khNm;//名称
	private Integer khTp;//客户种类（1经销商；2客户）
	private String erpCode;//ERP编码
	private String qdtpNm;//客户类型
	private String sctpNm;//市场类型
	private String khdjNm;//客户等级
	private String bfpcNm;//拜访频次
	private String xsjdNm;//销售阶段
	private String bfflNm;//拜访分类
	private String ghtpNm;//供货类型
	private String hzfsNm;//合作方式
	private Integer khPid;//供货经销商id
	private String linkman;//联系人
	private String tel;//电话
	private String mobile;//手机
	private String mobileCx;//手机支持彩信
	private String qq;//QQ
	private String wxCode;//微信
	private String isYx;//是否有效(1有效；其他无效)
	private String openDate;//开户日期
	private String closeDate;//闭户日期
	private String isOpen;//是否开户(1是；其他否)
	private String shZt;//审核状态(待审核；审核通过；审核不通过)
	private Integer shMid;//审核人id
	private String shTime;//审核时间
	private String province;//省
	private String city;//市
	private String area;//区县
	private String address;//地址
	private String longitude;//经度
	private String latitude;//纬度
	private String remo;//备注
	private Integer memId;//业务员id
	private Integer branchId;//部门id
	private String jxsflNm;//经销商分类
	private String jxsjbNm;//经销商级别
	private String jxsztNm;//经销商状态
	private Integer wlId;//物流公司id
	private String fman;//负责人/法人
	private String ftel;//负责人电话
	private String jyfw;//经营范围
	private String fgqy;//覆盖区域
	private String nxse;//年销售额
	private String ckmj;//仓库面积
	private String dlqtpl;//代理其他品类
	private String dlqtpp;//代理其他品牌
	private String createTime;//创建时间
	private String scbfDate;//上次拜访日期
	private Integer isDb;//是否倒闭（1是；2否）
	private String py;//助记码
	private String isEp;//是否二批客户 null或者0：否 1:是
	private String uscCode;//社会信用代码
	private String epCustomerId;//所属二批客户
	private String epCustomerName;
	private Integer regionId;//所属区域
	private String regionNm;

	private String rzMobile;//认证手机
	private Integer rzState;//认证手机状态 0:未认证；1：已认证


	public String getEpCustomerId() {
		return epCustomerId;
	}
	public void setEpCustomerId(String epCustomerId) {
		this.epCustomerId = epCustomerId;
	}
	public String getEpCustomerName() {
		return epCustomerName;
	}
	public void setEpCustomerName(String epCustomerName) {
		this.epCustomerName = epCustomerName;
	}
	public String getUscCode() {
		return uscCode;
	}
	public void setUscCode(String uscCode) {
		this.uscCode = uscCode;
	}
	public String getIsEp() {
		return isEp;
	}
	public void setIsEp(String isEp) {
		this.isEp = isEp;
	}

	private Integer orgEmpId;//原始业务ID
	private String  orgEmpNm;//原始业务员名称
	private Integer industryId;//行业ID
	private String industryNm;//行业名称
	private String lawAddress;//客户法定地址
	private String oftenAddress;//客户常用地址
	private String sendAddress2;//客户送货地址2
    private List<SysCustomerPic> customerPicList;//客户附件



	//----------------------不在数据库---------------------
	private String pkhCode;//供货经销商编码
	private String pkhNm;//供货经销商名称
	private String memberNm;//业务员名称
	private String memberMobile;//业务员手机号
	private String branchName;//部门名称
	private String shMemberNm;//审核人
	private String wlNm;//物流公司名称
	private String wllinkman;//物流公司联系人
	private String wltel;//物流公司电话
	private String wladdress;//物流公司地址
	private String database;//数据库
	private String datasource;
	private String memberIds;
	
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getMemberIds() {
		return memberIds;
	}
	public void setMemberIds(String memberIds) {
		this.memberIds = memberIds;
	}
	public Integer getIsDb() {
		return isDb;
	}
	public void setIsDb(Integer isDb) {
		this.isDb = isDb;
	}
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getDatabase() {
		return database;
	}
	public void setDatabase(String database) {
		this.database = database;
	}
	public String getHzfsNm() {
		return hzfsNm;
	}
	public void setHzfsNm(String hzfsNm) {
		this.hzfsNm = hzfsNm;
	}
	public String getScbfDate() {
		return scbfDate;
	}
	public void setScbfDate(String scbfDate) {
		this.scbfDate = scbfDate;
	}
	public String getBfflNm() {
		return bfflNm;
	}
	public void setBfflNm(String bfflNm) {
		this.bfflNm = bfflNm;
	}
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getShMemberNm() {
		return shMemberNm;
	}
	public void setShMemberNm(String shMemberNm) {
		this.shMemberNm = shMemberNm;
	}
	public Integer getShMid() {
		return shMid;
	}
	public void setShMid(Integer shMid) {
		this.shMid = shMid;
	}
	public String getShTime() {
		return shTime;
	}
	public void setShTime(String shTime) {
		this.shTime = shTime;
	}
	public Integer getBranchId() {
		return branchId;
	}
	public void setBranchId(Integer branchId) {
		this.branchId = branchId;
	}
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getBranchName() {
		return branchName;
	}
	public void setBranchName(String branchName) {
		this.branchName = branchName;
	}
	public Integer getKhTp() {
		return khTp;
	}
	public void setKhTp(Integer khTp) {
		this.khTp = khTp;
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
	public String getBfpcNm() {
		return bfpcNm;
	}
	public void setBfpcNm(String bfpcNm) {
		this.bfpcNm = bfpcNm;
	}
	public String getCity() {
		return city;
	}
	public void setCity(String city) {
		this.city = city;
	}
	public String getCkmj() {
		return ckmj;
	}
	public void setCkmj(String ckmj) {
		this.ckmj = ckmj;
	}
	public String getCloseDate() {
		return closeDate;
	}
	public void setCloseDate(String closeDate) {
		this.closeDate = closeDate;
	}
	public String getCreateTime() {
		return createTime;
	}
	public void setCreateTime(String createTime) {
		this.createTime = createTime;
	}
	public String getDlqtpl() {
		return dlqtpl;
	}
	public void setDlqtpl(String dlqtpl) {
		this.dlqtpl = dlqtpl;
	}
	public String getDlqtpp() {
		return dlqtpp;
	}
	public void setDlqtpp(String dlqtpp) {
		this.dlqtpp = dlqtpp;
	}
	public String getErpCode() {
		return erpCode;
	}
	public void setErpCode(String erpCode) {
		this.erpCode = erpCode;
	}
	public String getFgqy() {
		return fgqy;
	}
	public void setFgqy(String fgqy) {
		this.fgqy = fgqy;
	}
	public String getFman() {
		return fman;
	}
	public void setFman(String fman) {
		this.fman = fman;
	}
	public String getFtel() {
		return ftel;
	}
	public void setFtel(String ftel) {
		this.ftel = ftel;
	}
	public String getGhtpNm() {
		return ghtpNm;
	}
	public void setGhtpNm(String ghtpNm) {
		this.ghtpNm = ghtpNm;
	}
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public String getIsOpen() {
		return isOpen;
	}
	public void setIsOpen(String isOpen) {
		this.isOpen = isOpen;
	}
	public String getIsYx() {
		return isYx;
	}
	public void setIsYx(String isYx) {
		this.isYx = isYx;
	}
	public String getJxsflNm() {
		return jxsflNm;
	}
	public void setJxsflNm(String jxsflNm) {
		this.jxsflNm = jxsflNm;
	}
	public String getJxsjbNm() {
		return jxsjbNm;
	}
	public void setJxsjbNm(String jxsjbNm) {
		this.jxsjbNm = jxsjbNm;
	}
	public String getJxsztNm() {
		return jxsztNm;
	}
	public void setJxsztNm(String jxsztNm) {
		this.jxsztNm = jxsztNm;
	}
	public String getJyfw() {
		return jyfw;
	}
	public void setJyfw(String jyfw) {
		this.jyfw = jyfw;
	}
	public String getKhCode() {
		return khCode;
	}
	public void setKhCode(String khCode) {
		this.khCode = khCode;
	}
	public String getKhdjNm() {
		return khdjNm;
	}
	public void setKhdjNm(String khdjNm) {
		this.khdjNm = khdjNm;
	}
	public String getKhNm() {
		return khNm;
	}
	public void setKhNm(String khNm) {
		this.khNm = khNm;
	}
	public Integer getKhPid() {
		return khPid;
	}
	public void setKhPid(Integer khPid) {
		this.khPid = khPid;
	}
	public String getLatitude() {
		return latitude;
	}
	public void setLatitude(String latitude) {
		this.latitude = latitude;
	}
	public String getLinkman() {
		return linkman;
	}
	public void setLinkman(String linkman) {
		this.linkman = linkman;
	}
	public String getLongitude() {
		return longitude;
	}
	public void setLongitude(String longitude) {
		this.longitude = longitude;
	}
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getMemberMobile() {
		return memberMobile;
	}
	public void setMemberMobile(String memberMobile) {
		this.memberMobile = memberMobile;
	}
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getMemberNm() {
		return memberNm;
	}
	public void setMemberNm(String memberNm) {
		this.memberNm = memberNm;
	}
	public Integer getMemId() {
		return memId;
	}
	public void setMemId(Integer memId) {
		this.memId = memId;
	}
	public String getMobile() {
		return mobile;
	}
	public void setMobile(String mobile) {
		this.mobile = mobile;
	}
	public String getMobileCx() {
		return mobileCx;
	}
	public void setMobileCx(String mobileCx) {
		this.mobileCx = mobileCx;
	}
	public String getNxse() {
		return nxse;
	}
	public void setNxse(String nxse) {
		this.nxse = nxse;
	}
	public String getOpenDate() {
		return openDate;
	}
	public void setOpenDate(String openDate) {
		this.openDate = openDate;
	}
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getPkhCode() {
		return pkhCode;
	}
	public void setPkhCode(String pkhCode) {
		this.pkhCode = pkhCode;
	}
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getPkhNm() {
		return pkhNm;
	}
	public void setPkhNm(String pkhNm) {
		this.pkhNm = pkhNm;
	}
	public String getProvince() {
		return province;
	}
	public void setProvince(String province) {
		this.province = province;
	}
	public String getQdtpNm() {
		return qdtpNm;
	}
	public void setQdtpNm(String qdtpNm) {
		this.qdtpNm = qdtpNm;
	}
	public String getQq() {
		return qq;
	}
	public void setQq(String qq) {
		this.qq = qq;
	}
	public String getRemo() {
		return remo;
	}
	public void setRemo(String remo) {
		this.remo = remo;
	}
	public String getSctpNm() {
		return sctpNm;
	}
	public void setSctpNm(String sctpNm) {
		this.sctpNm = sctpNm;
	}
	public String getTel() {
		return tel;
	}
	public void setTel(String tel) {
		this.tel = tel;
	}
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getWladdress() {
		return wladdress;
	}
	public void setWladdress(String wladdress) {
		this.wladdress = wladdress;
	}
	public Integer getWlId() {
		return wlId;
	}
	public void setWlId(Integer wlId) {
		this.wlId = wlId;
	}
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getWllinkman() {
		return wllinkman;
	}
	public void setWllinkman(String wllinkman) {
		this.wllinkman = wllinkman;
	}
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getWlNm() {
		return wlNm;
	}
	public void setWlNm(String wlNm) {
		this.wlNm = wlNm;
	}
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getWltel() {
		return wltel;
	}
	public void setWltel(String wltel) {
		this.wltel = wltel;
	}
	public String getWxCode() {
		return wxCode;
	}
	public void setWxCode(String wxCode) {
		this.wxCode = wxCode;
	}
	public String getXsjdNm() {
		return xsjdNm;
	}
	public void setXsjdNm(String xsjdNm) {
		this.xsjdNm = xsjdNm;
	}
	public String getShZt() {
		return shZt;
	}
	public void setShZt(String shZt) {
		this.shZt = shZt;
	}
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getDatasource() {
		return datasource;
	}
	public void setDatasource(String datasource) {
		this.datasource = datasource;
	}
	public String getPy() {
		return py;
	}
	public void setPy(String py) {
		this.py = py;
	}

	public Integer getRegionId() {
		return regionId;
	}

	public void setRegionId(Integer regionId) {
		this.regionId = regionId;
	}
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getRegionNm() {
		return regionNm;
	}

	public void setRegionNm(String regionNm) {
		this.regionNm = regionNm;
	}

    public Integer getOrgEmpId() {
        return orgEmpId;
    }

    public void setOrgEmpId(Integer orgEmpId) {
        this.orgEmpId = orgEmpId;
    }

    public String getOrgEmpNm() {
        return orgEmpNm;
    }

    public void setOrgEmpNm(String orgEmpNm) {
        this.orgEmpNm = orgEmpNm;
    }

    public Integer getIndustryId() {
        return industryId;
    }

    public void setIndustryId(Integer industryId) {
        this.industryId = industryId;
    }

    public String getIndustryNm() {
        return industryNm;
    }

    public void setIndustryNm(String industryNm) {
        this.industryNm = industryNm;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public List<SysCustomerPic> getCustomerPicList() {
        return customerPicList;
    }

    public void setCustomerPicList(List<SysCustomerPic> customerPicList) {
        this.customerPicList = customerPicList;
    }

	public String getLawAddress() {
		return lawAddress;
	}

	public void setLawAddress(String lawAddress) {
		this.lawAddress = lawAddress;
	}

	public String getOftenAddress() {
		return oftenAddress;
	}

	public void setOftenAddress(String oftenAddress) {
		this.oftenAddress = oftenAddress;
	}

	public String getSendAddress2() {
		return sendAddress2;
	}

	public void setSendAddress2(String sendAddress2) {
		this.sendAddress2 = sendAddress2;
	}

	public String getRzMobile() {
		return rzMobile;
	}

	public void setRzMobile(String rzMobile) {
		this.rzMobile = rzMobile;
	}

	public Integer getRzState() {
		return rzState;
	}

	public void setRzState(Integer rzState) {
		this.rzState = rzState;
	}

	public Integer getMastId() { return mastId; }

	public void setMastId(Integer mastId) { this.mastId = mastId; }

	public Integer getCstId() { return cstId; }

	public void setCstId(Integer cstId) { this.cstId = cstId; }
}
