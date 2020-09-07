package com.qweib.cloud.core.domain;


import com.qweib.cloud.utils.TableAnnotation;

/**
 *说明：销售小结
 *@创建：作者:llp		创建时间：2016-3-23
 *@修改历史：
 *		[序号](llp	2016-3-23)<修改说明>
 */
public class SysBfxsxj {
	private Integer id;//销售小结id
	private Integer mid;//业务员id
	private Integer cid;//客户id
	private Integer wid;//商品id
	private Integer dhNum;//到货量
	private Integer sxNum;//实销量
	private Integer kcNum;//库存量
	private Integer ddNum;//订单数
	private String xstp;//售销类型
	private String remo;//备注
	private Integer xxd;//新鲜度
	private String xjdate;//日期
	//-------------------不在数据库--------------
	private String wareNm;//商品名称
	private String wareGg;//规格
	private String khNm;
	private String memberNm;
	private String sdate;
	private String edate;
	private Integer waretype;
	private Integer noCompany;//是否公司产品
	private String database;
	private String customerType;
	private String hzfsNm;
	private Integer kcNum1;//非公司商品库存
	private String regionNm;

	private String sort;
	private String order;

	@TableAnnotation(insertAble=false,updateAble=false)
	public String getSort() {
		return sort;
	}

	public void setSort(String sort) {
		this.sort = sort;
	}

	@TableAnnotation(insertAble=false,updateAble=false)
	public String getOrder() {
		return order;
	}

	public void setOrder(String order) {
		this.order = order;
	}

	@TableAnnotation(insertAble=false,updateAble=false)
	public String getRegionNm() {
		return regionNm;
	}

	public void setRegionNm(String regionNm) {
		this.regionNm = regionNm;
	}

	@TableAnnotation(insertAble=false,updateAble=false)
	public Integer getKcNum1() {
		return kcNum1;
	}

	public void setKcNum1(Integer kcNum1) {
		this.kcNum1 = kcNum1;
	}

	public Integer getXxd() {
		return xxd;
	}
	public void setXxd(Integer xxd) {
		this.xxd = xxd;
	}
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getWareGg() {
		return wareGg;
	}
	public void setWareGg(String wareGg) {
		this.wareGg = wareGg;
	}
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getWareNm() {
		return wareNm;
	}
	public void setWareNm(String wareNm) {
		this.wareNm = wareNm;
	}
	public Integer getCid() {
		return cid;
	}
	public void setCid(Integer cid) {
		this.cid = cid;
	}
	public Integer getDdNum() {
		return ddNum;
	}
	public void setDdNum(Integer ddNum) {
		this.ddNum = ddNum;
	}
	public Integer getDhNum() {
		return dhNum;
	}
	public void setDhNum(Integer dhNum) {
		this.dhNum = dhNum;
	}
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public Integer getKcNum() {
		return kcNum;
	}
	public void setKcNum(Integer kcNum) {
		this.kcNum = kcNum;
	}
	public Integer getMid() {
		return mid;
	}
	public void setMid(Integer mid) {
		this.mid = mid;
	}
	public String getRemo() {
		return remo;
	}
	public void setRemo(String remo) {
		this.remo = remo;
	}
	public Integer getSxNum() {
		return sxNum;
	}
	public void setSxNum(Integer sxNum) {
		this.sxNum = sxNum;
	}
	public Integer getWid() {
		return wid;
	}
	public void setWid(Integer wid) {
		this.wid = wid;
	}
	public String getXjdate() {
		return xjdate;
	}
	public void setXjdate(String xjdate) {
		this.xjdate = xjdate;
	}
	public String getXstp() {
		return xstp;
	}
	public void setXstp(String xstp) {
		this.xstp = xstp;
	}
	@TableAnnotation(insertAble=false,updateAble=false)
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
	public Integer getWaretype() {
		return waretype;
	}
	public void setWaretype(Integer waretype) {
		this.waretype = waretype;
	}
	@TableAnnotation(insertAble=false,updateAble=false)
	public Integer getNoCompany() {
		return noCompany;
	}
	public void setNoCompany(Integer noCompany) {
		this.noCompany = noCompany;
	}
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getDatabase() {
		return database;
	}
	public void setDatabase(String database) {
		this.database = database;
	}
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getCustomerType() {
		return customerType;
	}
	public void setCustomerType(String customerType) {
		this.customerType = customerType;
	}
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getHzfsNm() {
		return hzfsNm;
	}
	public void setHzfsNm(String hzfsNm) {
		this.hzfsNm = hzfsNm;
	}
	
	

}
