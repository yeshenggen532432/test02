package com.qweib.cloud.core.domain;

import com.qweib.cloud.utils.TableAnnotation;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;
import java.util.Map;

public class SysStkOut{

	private Integer id;
	private String billNo;
	private Integer status;//状态 -2暂存  0未审 1已审 2作废
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public String getBillNo() {
		return billNo;
	}
	public void setBillNo(String billNo) {
		this.billNo = billNo;
	}
	public Integer getStatus() { return status; }
	public void setStatus(Integer status) { this.status = status; }
	private Integer orderId;//销售订单ID
	private Integer cstId;//客户ID
	private String tel;//客户电话
	private String address;//
	private Integer mid;//业务员
	private Date outTime;//出库时间
	private String pszd;//配送指定
	private String remarks;//备注
	private String outType;//出库类型 销售出库 其它出库的出库类型
	private Integer stkId;//仓库id
	private String submitUser;//审核人
	private Date submitTime;//审核时间
	
	private String cancelUser;//作废人
	private Date cancelTime;//作废时间
	private BigDecimal totalAmt;//总金额
	private BigDecimal recAmt;//已收款金额
	private BigDecimal discount;//整单折扣
	private BigDecimal disAmt;//折后金额
	private String operator;//操作员
	private String shr;//收货人
	private BigDecimal freeAmt;
	private String khNm;//客户名称
	private Integer proType;
	private BigDecimal disAmt1;//发货金额
	private String staff;
	private String staffTel;
	private String recStatus;
	private Date newTime;
	private Date createTime;
	private Date sendTime;//发货日期
	private Integer driverId;
	private Integer vehId;
	private String driverName;
	private String vehNo;
	private String saleType;//销售分类: 001:直接销售单，002:预留 003:商城销售单
	private Integer empType;//业务员类型:1员工  4：会员（商城）
	private BigDecimal freight;
	private BigDecimal freightRec;


	/////////////////////////////////////
	private Integer waretype;
	private Integer carId;
	private String reauditDesc;//说明，主要记录反审核操作
	
	public Date getCreateTime() {
		return createTime;
	}
	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}
	public Date getSendTime() {
		return sendTime;
	}
	public void setSendTime(Date sendTime) {
		this.sendTime = sendTime;
	}
	private String epCustomerId;
	private String epCustomerName;
	private Integer empId;

	//--------------------------------
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
	private String memberNm;//业务员名称
	private String database;//数据库
	private Integer count;//笔数
	private List<SysStkOutsub> list;//详情集合
	private List<Map<String,Object>> maps;
	private String sdate;//开始时间
	private String edate;//结束时间
	private BigDecimal ddNum;//数量
	private Integer isMe;//是否我的（1是；2否）
	private String stkName;
	private String outDate;
	private String orderNo;
	private String billStatus;//状态
	private String xsTp;
	private String wareNm;
	private BigDecimal needRec;
	private Integer isPay;
	private Integer wareId;
	private Integer needRtn;
    private String customerType;
	private String timeType;
	private Integer wtype;
	private String branchName;
	private String subIds;
	private String sendStatus;//发货状态 0:包含未发货，1:已发货
	private String showNoModify;//只显示未修改过的单据;
	private Integer isExpand;//展开否，查询条件
	private Integer saleCar;//是否车销 1:是 0 其他否
	private BigDecimal beginAmt;//金额查询起始金额
	private BigDecimal endAmt;//金额查询终点金额
	private Integer regionId;
	private String regionNm;
	private Integer checkAutoPrice;//检查销售单是否自动更新商品信息价格
	private BigDecimal sumQty;
	private BigDecimal sumOutQty;


	@TableAnnotation(insertAble=false,updateAble=false)
	public List<Map<String, Object>> getMaps() {
		return maps;
	}
	public void setMaps(List<Map<String, Object>> maps) {
		this.maps = maps;
	}
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getShowNoModify() {
		return showNoModify;
	}
	public void setShowNoModify(String showNoModify) {
		this.showNoModify = showNoModify;
	}
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getSendStatus() {
		return sendStatus;
	}
	public void setSendStatus(String sendStatus) {
		this.sendStatus = sendStatus;
	}
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getSubIds() {
		return subIds;
	}
	public void setSubIds(String subIds) {
		this.subIds = subIds;
	}
    @TableAnnotation(insertAble=false,updateAble=false)
	public String getCustomerType() {
		return customerType;
	}
	public void setCustomerType(String customerType) {
		this.customerType = customerType;
	}
	public String getKhNm() {
		return khNm;
	}
	public void setKhNm(String khNm) {
		this.khNm = khNm;
	}
	
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getMemberNm() {
		return memberNm;
	}
	public void setMemberNm(String memberNm) {
		this.memberNm = memberNm;
	}
	
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getDatabase() {
		return database;
	}
	public void setDatabase(String database) {
		this.database = database;
	}
	
	@TableAnnotation(insertAble=false,updateAble=false)
	public Integer getCount() {
		return count;
	}
	public void setCount(Integer count) {
		this.count = count;
	}
	
	@TableAnnotation(insertAble=false,updateAble=false)
	public List<SysStkOutsub> getList() {
		return list;
	}
	public void setList(List<SysStkOutsub> list) {
		this.list = list;
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
	
	@TableAnnotation(insertAble=false,updateAble=false)
	public BigDecimal getDdNum() {
		return ddNum;
	}
	public void setDdNum(BigDecimal ddNum) {
		this.ddNum = ddNum;
	}
	
	@TableAnnotation(insertAble=false,updateAble=false)
	public Integer getIsMe() {
		return isMe;
	}
	public void setIsMe(Integer isMe) {
		this.isMe = isMe;
	}
	public Integer getOrderId() {
		return orderId;
	}
	public void setOrderId(Integer orderId) {
		this.orderId = orderId;
	}

	public Integer getCstId() {
		return cstId;
	}
	public void setCstId(Integer cstId) {
		this.cstId = cstId;
	}
	public String getTel() {
		return tel;
	}
	public void setTel(String tel) {
		this.tel = tel;
	}
	public String getAddress() {
		return address;
	}
	public void setAddress(String address) {
		this.address = address;
	}
	
	public Date getOutTime() {
		return outTime;
	}
	public void setOutTime(Date outTime) {
		this.outTime = outTime;
	}
	public String getPszd() {
		return pszd;
	}
	public void setPszd(String pszd) {
		this.pszd = pszd;
	}
	public String getRemarks() {
		return remarks;
	}
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
	public String getOutType() {
		return outType;
	}
	public void setOutType(String outType) {
		this.outType = outType;
	}
	public Integer getStkId() {
		return stkId;
	}
	public void setStkId(Integer stkId) {
		this.stkId = stkId;
	}
	
	public String getSubmitUser() {
		return submitUser;
	}
	public void setSubmitUser(String submitUser) {
		this.submitUser = submitUser;
	}
	public Date getSubmitTime() {
		return submitTime;
	}
	public void setSubmitTime(Date submitTime) {
		this.submitTime = submitTime;
	}
	
	public String getCancelUser() {
		return cancelUser;
	}
	public void setCancelUser(String cancelUser) {
		this.cancelUser = cancelUser;
	}
	public Date getCancelTime() {
		return cancelTime;
	}
	public void setCancelTime(Date cancelTime) {
		this.cancelTime = cancelTime;
	}
	public BigDecimal getTotalAmt() {
		return totalAmt;
	}
	public void setTotalAmt(BigDecimal totalAmt) {
		this.totalAmt = totalAmt;
	}
	public BigDecimal getRecAmt() {
		return recAmt;
	}
	public void setRecAmt(BigDecimal recAmt) {
		this.recAmt = recAmt;
	}
	public BigDecimal getDiscount() {
		return discount;
	}
	public void setDiscount(BigDecimal discount) {
		this.discount = discount;
	}
	public BigDecimal getDisAmt() {
		return disAmt;
	}
	public void setDisAmt(BigDecimal disAmt) {
		this.disAmt = disAmt;
	}
	public String getOperator() {
		return operator;
	}
	public void setOperator(String operator) {
		this.operator = operator;
	}
	public Integer getMid() {
		return mid;
	}
	public void setMid(Integer mid) {
		this.mid = mid;
	}
	
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getStkName() {
		return stkName;
	}
	public void setStkName(String stkName) {
		this.stkName = stkName;
	}
	
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getOutDate() {
		return outDate;
	}
	public void setOutDate(String outDate) {
		this.outDate = outDate;
	}
	
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getOrderNo() {
		return orderNo;
	}
	public void setOrderNo(String orderNo) {
		this.orderNo = orderNo;
	}
	
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getBillStatus() {
		return billStatus;
	}
	public void setBillStatus(String billStatus) {
		this.billStatus = billStatus;
	}
	public String getShr() {
		return shr;
	}
	public void setShr(String shr) {
		this.shr = shr;
	}
	
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getXsTp() {
		return xsTp;
	}
	public void setXsTp(String xsTp) {
		this.xsTp = xsTp;
	}
	
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getWareNm() {
		return wareNm;
	}
	public void setWareNm(String wareNm) {
		this.wareNm = wareNm;
	}
	public BigDecimal getFreeAmt() {
		return freeAmt;
	}
	public void setFreeAmt(BigDecimal freeAmt) {
		this.freeAmt = freeAmt;
	}
	public Integer getProType() {
		return proType;
	}
	public void setProType(Integer proType) {
		this.proType = proType;
	}
	public BigDecimal getDisAmt1() {
		return disAmt1;
	}
	public void setDisAmt1(BigDecimal disAmt1) {
		this.disAmt1 = disAmt1;
	}
	
	@TableAnnotation(insertAble=false,updateAble=false)
	public BigDecimal getNeedRec() {
		return needRec;
	}
	public void setNeedRec(BigDecimal needRec) {
		this.needRec = needRec;
	}
	@TableAnnotation(insertAble=false,updateAble=false)
	public Integer getIsPay() {
		return isPay;
	}
	public void setIsPay(Integer isPay) {
		this.isPay = isPay;
	}
	
	@TableAnnotation(insertAble=false,updateAble=false)
	public Integer getWareId() {
		return wareId;
	}
	public void setWareId(Integer wareId) {
		this.wareId = wareId;
	}
	public String getStaff() {
		return staff;
	}
	public void setStaff(String staff) {
		this.staff = staff;
	}
	public String getStaffTel() {
		return staffTel;
	}
	public void setStaffTel(String staffTel) {
		this.staffTel = staffTel;
	}
	
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getRecStatus() {
		return recStatus;
	}
	public void setRecStatus(String recStatus) {
		this.recStatus = recStatus;
	}
	public Date getNewTime() {
		return newTime;
	}
	public void setNewTime(Date newTime) {
		this.newTime = newTime;
	}
	@TableAnnotation(insertAble=false,updateAble=false)
	public Integer getNeedRtn() {
		return needRtn;
	}
	public void setNeedRtn(Integer needRtn) {
		this.needRtn = needRtn;
	}
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getTimeType() {
		return timeType;
	}
	public void setTimeType(String timeType) {
		this.timeType = timeType;
	}
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getBranchName() {
		return branchName;
	}
	public void setBranchName(String branchName) {
		this.branchName = branchName;
	}
	public Integer getEmpId() {
		return empId;
	}
	public void setEmpId(Integer empId) {
		this.empId = empId;
	}
	@TableAnnotation(insertAble=false,updateAble=false)
	public Integer getWaretype() {
		return waretype;
	}
	public void setWaretype(Integer waretype) {
		this.waretype = waretype;
	}
	
	@TableAnnotation(insertAble=false,updateAble=false)
	public Integer getIsExpand() {
		return isExpand;
	}
	public void setIsExpand(Integer isExpand) {
		this.isExpand = isExpand;
	}
	
	@TableAnnotation(insertAble=false,updateAble=false)
	public Integer getCarId() {
		return carId;
	}
	public void setCarId(Integer carId) {
		this.carId = carId;
	}
	public Integer getDriverId() {
		return driverId;
	}
	public void setDriverId(Integer driverId) {
		this.driverId = driverId;
	}
	public Integer getVehId() {
		return vehId;
	}
	public void setVehId(Integer vehId) {
		this.vehId = vehId;
	}
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getDriverName() {
		return driverName;
	}
	public void setDriverName(String driverName) {
		this.driverName = driverName;
	}
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getVehNo() {
		return vehNo;
	}
	public void setVehNo(String vehNo) {
		this.vehNo = vehNo;
	}
	@TableAnnotation(insertAble=false,updateAble=false)
	public Integer getSaleCar() {
		return saleCar;
	}
	public void setSaleCar(Integer saleCar) {
		this.saleCar = saleCar;
	}
	public String getReauditDesc() {
		return reauditDesc;
	}
	public void setReauditDesc(String reauditDesc) {
		this.reauditDesc = reauditDesc;
	}
	@TableAnnotation(insertAble=false,updateAble=false)
	public Integer getWtype() { return wtype; }
	public void setWtype(Integer wtype) { this.wtype = wtype; }
	@TableAnnotation(insertAble=false,updateAble=false)
	public Integer getCheckAutoPrice() {
		return checkAutoPrice;
	}

	public void setCheckAutoPrice(Integer checkAutoPrice) {
		this.checkAutoPrice = checkAutoPrice;
	}

	@TableAnnotation(insertAble=false,updateAble=false)
	public BigDecimal getBeginAmt() { return beginAmt; }
	public void setBeginAmt(BigDecimal beginAmt) { this.beginAmt = beginAmt; }
	@TableAnnotation(insertAble=false,updateAble=false)
	public BigDecimal getEndAmt() { return endAmt; }
	public void setEndAmt(BigDecimal endAmt) { this.endAmt = endAmt; }

	public String getSaleType() { return saleType; }
	public void setSaleType(String saleType) { this.saleType = saleType; }
	@TableAnnotation(insertAble=false,updateAble=false)
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
	@TableAnnotation(insertAble=false,updateAble=false)
	public BigDecimal getSumQty() {
		return sumQty;
	}

	public void setSumQty(BigDecimal sumQty) {
		this.sumQty = sumQty;
	}
	@TableAnnotation(insertAble=false,updateAble=false)
	public BigDecimal getSumOutQty() {
		return sumOutQty;
	}

	public void setSumOutQty(BigDecimal sumOutQty) {
		this.sumOutQty = sumOutQty;
	}

	public Integer getEmpType() { return empType; }

	public void setEmpType(Integer empType) { this.empType = empType; }

	public BigDecimal getFreight() {
		return freight;
	}

	public void setFreight(BigDecimal freight) {
		this.freight = freight;
	}

	public BigDecimal getFreightRec() {
		return freightRec;
	}

	public void setFreightRec(BigDecimal freightRec) {
		this.freightRec = freightRec;
	}
}
