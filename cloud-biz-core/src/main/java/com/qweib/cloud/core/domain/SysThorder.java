package com.qweib.cloud.core.domain;


import com.qweib.cloud.utils.TableAnnotation;

import java.util.List;

/**
 * 说明：退货订单
 */
public class SysThorder {
    private Integer id;//退货订单id
    private Integer mid;//业务员id
    private Integer cid;//客户id
    private String orderNo;//订单号
    private String shr;//收货人
    private String tel;//电话
    private String address;//地址
    private String remo;//备注
    private Double zje;//总金额
    private Double zdzk;//整单折扣
    private Double cjje;//成交金额
    private String oddate;//日期
    private String orderTp;//退货订单类型
    private String shTime;//收获时间
    private String orderZt;//退货订单状态（审核，未审核，已作废)
    private String orderLb;//退货订单类别（拜访单，电话单）
    private String pszd;//配送指定（公司直送，转二批配送）
    private String odtime;//时间
    //------------------不在数据库----------------
    private String khNm;//客户名称
    private String memberNm;//业务员名称
    private String database;//数据库
    private Integer count;//笔数
    private List<SysThorderDetail> list;//详情集合
    private String sdate;//开始时间
    private String edate;//结束时间
    private Integer ddNum;//数量
    private Integer isMe;//是否我的（1是；2否）
    private String wareNm;//商品名称

    @TableAnnotation(insertAble = false, updateAble = false)
    public Integer getIsMe() {
        return isMe;
    }

    public void setIsMe(Integer isMe) {
        this.isMe = isMe;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public Integer getDdNum() {
        return ddNum;
    }

    public void setDdNum(Integer ddNum) {
        this.ddNum = ddNum;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public String getEdate() {
        return edate;
    }

    public void setEdate(String edate) {
        this.edate = edate;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public String getSdate() {
        return sdate;
    }

    public void setSdate(String sdate) {
        this.sdate = sdate;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public List<SysThorderDetail> getList() {
        return list;
    }

    public void setList(List<SysThorderDetail> list) {
        this.list = list;
    }

    public String getPszd() {
        return pszd;
    }

    public void setPszd(String pszd) {
        this.pszd = pszd;
    }

    @TableAnnotation(updateAble = false)
    public String getOdtime() {
        return odtime;
    }

    public void setOdtime(String odtime) {
        this.odtime = odtime;
    }

    public String getOrderLb() {
        return orderLb;
    }

    public void setOrderLb(String orderLb) {
        this.orderLb = orderLb;
    }

    public String getOrderZt() {
        return orderZt;
    }

    public void setOrderZt(String orderZt) {
        this.orderZt = orderZt;
    }

    public String getOrderTp() {
        return orderTp;
    }

    public void setOrderTp(String orderTp) {
        this.orderTp = orderTp;
    }

    public String getShTime() {
        return shTime;
    }

    public void setShTime(String shTime) {
        this.shTime = shTime;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public Integer getCount() {
        return count;
    }

    public void setCount(Integer count) {
        this.count = count;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public String getDatabase() {
        return database;
    }

    public void setDatabase(String database) {
        this.database = database;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public String getKhNm() {
        return khNm;
    }

    public void setKhNm(String khNm) {
        this.khNm = khNm;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public String getMemberNm() {
        return memberNm;
    }

    public void setMemberNm(String memberNm) {
        this.memberNm = memberNm;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public Integer getCid() {
        return cid;
    }

    public void setCid(Integer cid) {
        this.cid = cid;
    }

    public Double getCjje() {
        return cjje;
    }

    public void setCjje(Double cjje) {
        this.cjje = cjje;
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

    @TableAnnotation(updateAble = false)
    public String getOddate() {
        return oddate;
    }

    public void setOddate(String oddate) {
        this.oddate = oddate;
    }

    @TableAnnotation(updateAble = false)
    public String getOrderNo() {
        return orderNo;
    }

    public void setOrderNo(String orderNo) {
        this.orderNo = orderNo;
    }

    public String getRemo() {
        return remo;
    }

    public void setRemo(String remo) {
        this.remo = remo;
    }

    public String getShr() {
        return shr;
    }

    public void setShr(String shr) {
        this.shr = shr;
    }

    public String getTel() {
        return tel;
    }

    public void setTel(String tel) {
        this.tel = tel;
    }

    public Double getZdzk() {
        return zdzk;
    }

    public void setZdzk(Double zdzk) {
        this.zdzk = zdzk;
    }

    public Double getZje() {
        return zje;
    }

    public void setZje(Double zje) {
        this.zje = zje;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public String getWareNm() {
        return wareNm;
    }

    public void setWareNm(String wareNm) {
        this.wareNm = wareNm;
    }


}
