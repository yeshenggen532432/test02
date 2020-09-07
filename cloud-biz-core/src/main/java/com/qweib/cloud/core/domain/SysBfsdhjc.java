package com.qweib.cloud.core.domain;
/**
 *说明：生动化检查
 *@创建：作者:llp		创建时间：2016-3-23
 *@修改历史：
 *		[序号](llp	2016-3-23)<修改说明>
 */
public class SysBfsdhjc {
	private Integer id;//生动化检查id
	private Integer mid;//业务员id
	private Integer cid;//客户id
	private String pophb;//POP海报
	private String cq;//串旗
    private String wq;//围裙
    private String remo1;//生动化摘要
    private String isXy;//是否显眼（1有；2无）
	private String remo2;//堆头摘要
    private String sddate;//日期
    
	public Integer getCid() {
		return cid;
	}
	public void setCid(Integer cid) {
		this.cid = cid;
	}
	public String getCq() {
		return cq;
	}
	public void setCq(String cq) {
		this.cq = cq;
	}
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public String getIsXy() {
		return isXy;
	}
	public void setIsXy(String isXy) {
		this.isXy = isXy;
	}
	public Integer getMid() {
		return mid;
	}
	public void setMid(Integer mid) {
		this.mid = mid;
	}
	public String getPophb() {
		return pophb;
	}
	public void setPophb(String pophb) {
		this.pophb = pophb;
	}
	public String getRemo1() {
		return remo1;
	}
	public void setRemo1(String remo1) {
		this.remo1 = remo1;
	}
	public String getRemo2() {
		return remo2;
	}
	public void setRemo2(String remo2) {
		this.remo2 = remo2;
	}
	public String getSddate() {
		return sddate;
	}
	public void setSddate(String sddate) {
		this.sddate = sddate;
	}
	public String getWq() {
		return wq;
	}
	public void setWq(String wq) {
		this.wq = wq;
	}
    
    
   
}
