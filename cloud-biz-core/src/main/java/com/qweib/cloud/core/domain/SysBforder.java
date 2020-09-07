package com.qweib.cloud.core.domain;


import com.fasterxml.jackson.annotation.JsonFormat;
import com.qweib.cloud.utils.DateTimeUtil;
import com.qweib.cloud.utils.TableAnnotation;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

/**
 * 说明：订单
 *
 * @创建：作者:llp 创建时间：2016-3-23
 * @修改历史： [序号](llp 2016 - 3 - 23)<修改说明>
 */
public class SysBforder {
    private Integer id;//订单id
    private Integer mid;//业务员id
    private Integer empType;//OrderMemberType 业务员类型: 1员工 4：会员（商城）
    private Integer cid;//客户id
    private Integer proType;//OrderMemberType 客户类型：0供应商  1员工  2客户 3其他往外  4：会员（商城）

    private String orderNo;//订单号
    private String shr;//收货人
    private String tel;//电话
    private String address;//地址
    private Integer addressId;//地址ID
    private String remo;//备注
    private Double zje;//商城算法:商品总价(商品原单价*数量)
    private Double zdzk;//整单折扣（商城不用）
    private Double cjje;//商城算法：商品净收入总额(所有下单商品折后净单价*数量的和)不含运费 进销存发票最终获取金额
    private String oddate;//日期
    private String orderTp;//订单类型 商城=客户下单，业务员自己下单=销售订单，电脑开单
    private String shTime;//送货时间
    private String orderZt;//订单审核状态（审核，未审核，已作废)
    private String orderLb;//订单类别（拜访单，电话单，车销单）
    private String pszd;//配送指定（公司直送，转二批配送）
    private String odtime;//时间
    private Integer stkId;//仓库id
    private Integer shopMemberId;//会员ID
    private String shopMemberName;//会员名称
    private Integer status;//OrderState 0 取消1,待支付,2已支付待发货,3已发货待收货,4已完成  05-22
    private Integer isPay;//0：未支付1：支付,10:已退款
    private Integer isSend;//0: 未发货1：已发货
    private Integer isFinish;//0:未完成 1；已完成
    private Integer payType;//使用OrderPayType 0.未支付类型；1.线下支付；2.余额支付；3.微信支付；4.支付宝支付
    private String payTime;//支付时间

    private Integer isCreate;//0：未创建 1：已创建为发票单

    //------------05-27 zzx-----------
    private String transportName;//运输公司名称
    private String transportCode;//运输编号
    private Date finishTime;//确认完成时间
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    private Date cancelTime;//取消时间
    private String cancelRemo;//取消原因
    private BigDecimal freight;//运费
    private BigDecimal promotionCost;//订单促销总额
    private BigDecimal couponCost;//订单抵优惠卷总额
    private String couponCode; // 优惠券码
    private BigDecimal orderAmount;//订单实付(最终支付金额)=商品净收入总额+运费
    //private Integer shopDiningId;//点餐ID 2019-11-04
    private Date createDate;//创建时间方便查询2019-11-07
    private Integer distributionMode;//配送方式1送货上门2自提
    private String takeName;//提货人
    private String takeTel;//提货电话
    //private Integer tourId;//拼团商品设置ID 弃用
    //private Integer headTourId;//团长组团分享Id 弃用
    private Integer promotionId;//秒杀,拼团,组团,点餐ID
    //private Integer promotionType;//ShopPromotionTypeEnum 活动类型   1:秒杀 2:拼团 3:组团
    private Integer orderType;//OrderType 类型：0普通订单,1:秒杀 2:拼团  4:组团-团长,9餐饮订单
    private Integer printCount;//打印次数
    //------------------不在数据库----------------
    private String khNm;//客户名称
    private String memberNm;//业务员名称
    private String database;//数据库
    private Integer count;//笔数
    private List<SysBforderDetail> list;//详情集合
    private String sdate;//开始时间
    private String edate;//结束时间
    private Integer ddNum;//数量
    private Integer isMe;//是否我的（1是；2否）
    private String wareNm;//商品名称
    private String stkName;//仓库名称
    private Integer saleCar;//是否车销

    private String tourIds;

    private String headTourIds;

    private Integer customerId;
    private String mids;
    private Integer headTourId;
    private Integer shopDiningId;
    private Integer tourId;
    private Integer refundStatus;


    public Integer getShopMemberId() {
        return shopMemberId;
    }

    public void setShopMemberId(Integer shopMemberId) {
        this.shopMemberId = shopMemberId;
    }

    public String getShopMemberName() {
        return shopMemberName;
    }

    public void setShopMemberName(String shopMemberName) {
        this.shopMemberName = shopMemberName;
    }

    public Integer getStkId() {
        return stkId;
    }

    public void setStkId(Integer stkId) {
        this.stkId = stkId;
    }

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
    public List<SysBforderDetail> getList() {
        return list;
    }

    public Date getCreateDate() {
        return createDate;
    }

    public void setCreateDate(Date createDate) {
        this.createDate = createDate;
    }

    public void setList(List<SysBforderDetail> list) {
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

    @TableAnnotation(insertAble = false, updateAble = false)
    public String getStkName() {
        return stkName;
    }

    public void setStkName(String stkName) {
        this.stkName = stkName;
    }

    public Integer getProType() {
        return proType;
    }

    public void setProType(Integer proType) {
        this.proType = proType;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public Integer getSaleCar() {
        return saleCar;
    }

    public void setSaleCar(Integer saleCar) {
        this.saleCar = saleCar;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

    public Integer getIsPay() {
        return isPay;
    }

    public void setIsPay(Integer isPay) {
        this.isPay = isPay;
    }

    public Integer getIsSend() {
        return isSend;
    }

    public void setIsSend(Integer isSend) {
        this.isSend = isSend;
    }

    public Integer getIsFinish() {
        return isFinish;
    }

    public void setIsFinish(Integer isFinish) {
        this.isFinish = isFinish;
    }

    public Integer getPayType() {
        return payType;
    }

    public void setPayType(Integer payType) {
        this.payType = payType;
    }

    public String getPayTime() {
        return payTime;
    }

    public void setPayTime(String payTime) {
        this.payTime = payTime;
    }

    public String getTransportName() {
        return transportName;
    }

    public void setTransportName(String transportName) {
        this.transportName = transportName;
    }

    public String getTransportCode() {
        return transportCode;
    }

    public void setTransportCode(String transportCode) {
        this.transportCode = transportCode;
    }


    public String getFinishTime() {
        if (this.finishTime == null) {
            return null;
        }
        return DateTimeUtil.getDateToStr(finishTime);
    }

    public void setFinishTime(Date finishTime) {
        this.finishTime = finishTime;
    }

    public String getCancelRemo() {
        return cancelRemo;
    }

    public void setCancelRemo(String cancelRemo) {
        this.cancelRemo = cancelRemo;
    }

    public Date getCancelTime() {
        return cancelTime;
    }

    public void setCancelTime(Date cancelTime) {
        this.cancelTime = cancelTime;
    }

    public BigDecimal getFreight() {
        return freight;
    }

    public void setFreight(BigDecimal freight) {
        this.freight = freight;
    }

    public BigDecimal getPromotionCost() {
        return promotionCost;
    }

    public void setPromotionCost(BigDecimal promotionCost) {
        this.promotionCost = promotionCost;
    }

    public BigDecimal getCouponCost() {
        return couponCost;
    }

    public void setCouponCost(BigDecimal couponCost) {
        this.couponCost = couponCost;
    }

    public String getCouponCode() {
        return couponCode;
    }

    public void setCouponCode(String couponCode) {
        this.couponCode = couponCode;
    }

    public BigDecimal getOrderAmount() {
        return orderAmount;
    }

    public void setOrderAmount(BigDecimal orderAmount) {
        this.orderAmount = orderAmount;
    }

    public Integer getEmpType() {
        return empType;
    }

    public void setEmpType(Integer empType) {
        this.empType = empType;
    }

/*    public Integer getShopDiningId() {
        return shopDiningId;
    }

    public void setShopDiningId(Integer shopDiningId) {
        this.shopDiningId = shopDiningId;
    }*/

    public Integer getOrderType() {
        return orderType;
    }

    public void setOrderType(Integer orderType) {
        this.orderType = orderType;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public Integer getCustomerId() {
        return customerId;
    }

    public void setCustomerId(Integer customerId) {
        this.customerId = customerId;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public String getMids() {
        return mids;
    }

    public void setMids(String mids) {
        this.mids = mids;
    }

    public Integer getIsCreate() {
        return isCreate;
    }

    public void setIsCreate(Integer isCreate) {
        this.isCreate = isCreate;
    }

    public Integer getDistributionMode() {
        return distributionMode;
    }

    public void setDistributionMode(Integer distributionMode) {
        this.distributionMode = distributionMode;
    }

    public String getTakeName() {
        return takeName;
    }

    public void setTakeName(String takeName) {
        this.takeName = takeName;
    }

    public String getTakeTel() {
        return takeTel;
    }

    public void setTakeTel(String takeTel) {
        this.takeTel = takeTel;
    }

    public Integer getPromotionId() {
        return promotionId;
    }

    public void setPromotionId(Integer promotionId) {
        this.promotionId = promotionId;
    }


    @TableAnnotation(insertAble = false, updateAble = false)
    public String getTourIds() {
        return tourIds;
    }

    public void setTourIds(String tourIds) {
        this.tourIds = tourIds;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public String getHeadTourIds() {
        return headTourIds;
    }

    public void setHeadTourIds(String headTourIds) {
        this.headTourIds = headTourIds;
    }

    public Integer getAddressId() {
        return addressId;
    }

    public void setAddressId(Integer addressId) {
        this.addressId = addressId;
    }

    public Integer getPrintCount() {
        return printCount;
    }

    public void setPrintCount(Integer printCount) {
        this.printCount = printCount;
    }

    public Integer getHeadTourId() {
        return headTourId;
    }

    public void setHeadTourId(Integer headTourId) {
        this.headTourId = headTourId;
    }

    public Integer getShopDiningId() {
        return shopDiningId;
    }

    public void setShopDiningId(Integer shopDiningId) {
        this.shopDiningId = shopDiningId;
    }

    public Integer getTourId() {
        return tourId;
    }

    public void setTourId(Integer tourId) {
        this.tourId = tourId;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public Integer getRefundStatus() {
        return refundStatus;
    }

    public void setRefundStatus(Integer refundStatus) {
        this.refundStatus = refundStatus;
    }
}
