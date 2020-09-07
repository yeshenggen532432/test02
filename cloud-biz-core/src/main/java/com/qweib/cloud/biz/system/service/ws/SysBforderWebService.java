package com.qweib.cloud.biz.system.service.ws;

import com.qweib.cloud.biz.system.service.SysConfigService;
import com.qweib.cloud.biz.system.service.common.OrderBaseService;
import com.qweib.cloud.biz.system.service.common.dto.MemberBaseDTO;
import com.qweib.cloud.biz.system.service.plat.SysDeptmempowerService;
import com.qweib.cloud.core.domain.*;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.repository.SysBforderWebDao;
import com.qweib.cloud.repository.SysCustomerDao;
import com.qweib.cloud.repository.SysWareDao;
import com.qweib.cloud.repository.plat.SysMemberDao;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import com.qweib.commons.StringUtils;
import com.qweibframework.commons.MathUtils;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.math.BigDecimal;
import java.util.*;

@Service
public class SysBforderWebService {
    @Resource
    private SysBforderWebDao bforderWebDao;
    @Resource
    private SysDeptmempowerService deptmempowerService;
    @Resource
    private SysCustomerDao customerDao;
    @Resource
    private SysMemberDao memberDao;
    @Resource
    private SysWareDao wareDao;

    @Resource
    private SysConfigService configService;
    @Resource
    private OrderBaseService orderBaseService;
    @Resource
    private SysBforderWebDao sysBforderWebDao;

    /**
     * 说明：添加订单
     *
     * @创建：作者:llp 创建时间：2016-3-28
     * @修改历史： [序号](llp 2016 - 3 - 28)<修改说明>
     */
    public int addBforder(SysBforder bforder, List<SysBforderDetail> detail, String database) {
        int id = this.bforderWebDao.addBforder(bforder, database);
        bforder.setId(id);
        for (SysBforderDetail orderDetail : detail) {
            orderDetail.setOrderId(id);
            int detailId = this.bforderWebDao.addBforderDetail(orderDetail, database);
            orderDetail.setId(detailId);
        }

        //==========如果没有设置客户商品价格，那么就保存当前价格==============
			/*
			  Integer customerId= bforder.getCid();
			  for(SysBforderDetail orderDetail:detail){
				String beUnit = orderDetail.getBeUnit();
				Integer wareId = orderDetail.getWareId();
				Double price = orderDetail.getWareDj();
				if("正常销售".equals(orderDetail.getXsTp())){
					SysCustomerPrice scp = new SysCustomerPrice();
					scp.setCustomerId(customerId);
					scp.setWareId(wareId);
					List<SysCustomerPrice> list =	customerDao.listSysCustomerPrice(database, scp);
					if(list==null||list.size()==0){
						SysCustomerPrice temp = new SysCustomerPrice();
						if("B".equals(beUnit)){
							BigDecimal tprice=	new BigDecimal(price==null?"0":price+"");
							temp.setCustomerId(customerId);
							temp.setWareId(wareId);
							temp.setSaleAmt(tprice);
						}else{
							SysWare sysWare = wareDao.queryWareById(wareId, database);
							Integer hsNum =	sysWare.getHsNum();
							if(StrUtil.isNull(hsNum)){
								hsNum = 1;
							}
							BigDecimal tprice=	new BigDecimal(price==null?"0":price+"");
							temp.setCustomerId(customerId);
							temp.setWareId(wareId);
							temp.setSaleAmt(tprice.multiply(new BigDecimal(hsNum)));
						}
						this.customerDao.updateSysCustomerPrice(database, temp);
					}
				}
			}*/
        //=============================================================
        return id;
    }

    /**
     * 说明：删除订单
     *
     * @创建：作者:ysg 创建时间：2018-09-14
     * @修改历史： [序号](ysg 2018 - 09 - 14)<修改说明>
     */
    public int deleteBforder(SysBforder bforder, String database) {
        try {
            return this.bforderWebDao.deleteBforder(bforder, database);
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServiceException(e);
        }
    }

    public List<SysBforderDetail> queryCustomerHisWarePrice(String database, Integer customerId, Integer wareId) {
        return this.bforderWebDao.queryCustomerHisWarePrice(database, customerId, wareId);
    }

    /**
     * 说明：修改订单
     *
     * @创建：作者:llp 创建时间：2016-3-28
     * @修改历史： [序号](llp 2016 - 3 - 28)<修改说明>
     */
    public void updateBforder(SysBforder bforder, List<SysBforderDetail> detail, String database) {
        try {
            this.bforderWebDao.updateBforder(bforder, database);
            this.bforderWebDao.deleteBforderDetail(database, bforder.getId());
            for (SysBforderDetail orderDetail : detail) {
                orderDetail.setOrderId(bforder.getId());
                this.bforderWebDao.addBforderDetail(orderDetail, database);
            }
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }


    /**
     * 说明：获取订单信息
     *
     * @创建：作者:llp 创建时间：2016-3-28
     * @修改历史： [序号](llp 2016 - 3 - 28)<修改说明>
     */
    public SysBforder queryBforderOne(String database, Integer mid, Integer cid, String oddate) {
        try {
            return this.bforderWebDao.queryBforderOne(database, mid, cid, oddate);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 说明：获取订单信息
     *
     * @创建：作者:llp 创建时间：2016-5-18
     * @修改历史： [序号](llp 2016 - 5 - 18)<修改说明>
     */
    public SysBforder queryBforderOne2(String database, Integer id) {
        try {
            return this.bforderWebDao.queryBforderOne2(database, id);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 说明：获取订单详情
     *
     * @创建：作者:llp 创建时间：2016-3-28
     * @修改历史： [序号](llp 2016 - 3 - 28)<修改说明>
     */
    public List<SysBforderDetail> queryBforderDetail(String database, Integer orderId) {
        try {
            return this.bforderWebDao.queryBforderDetail(database, orderId);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }
//	----------------------------订货下单------------------------------

    /**
     * 说明：分页查询订货下单
     *
     * @创建：作者:llp 创建时间：2016-5-16
     * @修改历史： [序号](llp 2016 - 5 - 16)<修改说明>
     */
    public Page queryDhorder(OnlineUser user, String dataTp, Integer page, Integer limit, SysBforder order) {
        try {
            String datasource = user.getDatabase();
            Integer memberId = user.getMemId();
            Map<String, Object> map = deptmempowerService.getPowerDept(dataTp, memberId, datasource);
            return this.bforderWebDao.queryDhorder(datasource, map, page, limit, order);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 说明：统计订单数量
     *
     * @创建：作者:llp 创建时间：2016-7-8
     * @修改历史： [序号](llp 2016 - 7 - 8)<修改说明>
     */
    public int queryOrderDetailCount(String database, Integer orderId) {
        try {
            return this.bforderWebDao.queryOrderDetailCount(database, orderId);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    //------------------------------车销单-----------------------------------

    /**
     * 说明：分页查询车销单
     *
     * @创建：作者:ysg
     * @创建时间：2018-09-21
     * @修改历史：
     */
    public Page queryCarOrder(OnlineUser user, String dataTp, Integer page, Integer limit, String kmNm, String sdate, String edate, String mids, String customerId, Integer stkId) {
        try {
            String datasource = user.getDatabase();
            Integer memberId = user.getMemId();
            //如果管理员：可以底下员工的单子
            Map<String, Object> map = deptmempowerService.getPowerDept(dataTp, memberId, datasource);

            return this.bforderWebDao.queryCarOrder(datasource, map, page, limit, kmNm, sdate, edate, mids, customerId, stkId);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }


    public SysStkOut saveAutoCreateOrderToSale(String database, SysBforder order, String operatorName) throws Exception {
        SysStkOut out = this.bforderWebDao.queryByOrderId(database, order.getId());//防止重复创建
        if (out != null) return out;
        out = new SysStkOut();
        Double zje = order.getZje();
        //如果是商城订单时商品总价=商品净收入总额,因为商城没有整单折扣
        if ("客户下单".equals(order.getOrderTp())) {
            zje = order.getCjje();//实收金额
            if (order.getFreight() == null) order.setFreight(new BigDecimal(0));
            order.setCjje(MathUtils.add(order.getCjje(), order.getFreight()).doubleValue());//发票金额=实收金额+运费
            if (order.getDistributionMode() != null && order.getDistributionMode() == 2) {
                out.setRemarks("配送方式:自提,自提人:" + order.getTakeName() + ",自提电话:" + order.getTakeTel());
            }
        }
        out.setOperator(operatorName);//操作人
        out.setOrderNo(order.getOrderNo());
        out.setOrderId(order.getId());
        out.setAddress(order.getAddress());
        out.setTel(order.getTel());
        out.setPszd(order.getPszd());
        out.setShr(order.getShr());
        out.setCstId(order.getCid());
        out.setEmpId(order.getMid());
        // out.setStaffTel(order.get);
        out.setRemarks((StringUtils.isEmpty(out.getRemarks()) ? "" : out.getRemarks()) + StringUtils.trimToEmpty(order.getRemo()));
        out.setDisAmt1(new BigDecimal(0));
        out.setFreeAmt(new BigDecimal(0));
        out.setDisAmt(new BigDecimal(0));
        out.setRecAmt(new BigDecimal(0));
        out.setDiscount(new BigDecimal(0));
        out.setFreight(new BigDecimal(0));

        if (!StrUtil.isNumberNullOrZero(order.getFreight())) {
            out.setFreight(order.getFreight());
        }

        if (!StrUtil.isNull(order.getZdzk())) {
            out.setDiscount(new BigDecimal(order.getZdzk()));
        }
        out.setTotalAmt(new BigDecimal(0));
        if (!StrUtil.isNull(zje)) {//合计金额
            out.setTotalAmt(new BigDecimal(zje));
        }
        if (!StrUtil.isNull(order.getCjje())) {//发票金额
            out.setDisAmt(new BigDecimal(order.getCjje()));
        }
        out.setOutTime(new Date());
        int status = Objects.equals(order.getIsPay(), 1) ? 0 : -2;
        out.setStatus(status);
        out.setMid(order.getMid());
        out.setProType(2);
        if (!StrUtil.isNull(order.getProType())) {
            out.setProType(order.getProType());
        }
        out.setOutType("销售出库");
        out.setSaleType("001");
        out.setEmpType(order.getEmpType());
        if ("客户下单".equals(order.getOrderTp())) {
            out.setSaleType("003");
        }
//        List<StkStorage> ssList = storageDao.queryAll(database);
//        if(ssList!=null&&ssList.size()>0){
//            out.setStkId(ssList.get(0).getId());
//            out.setStkName(ssList.get(0).getStkName());
//        }

        Map<String, Object> map = this.bforderWebDao.getStkStorage(database);
        if (map != null) {
            out.setStkId(Integer.valueOf(map.get("id") + ""));
            out.setStkName(map.get("stk_name") + "");
        }
        setSalesman(database, order, out);//设置业务员未测试zzx
//        if (!StrUtil.isNull(order.getMid())) {
//            SysMember member = memberDao.queryCompanySysMemberById(database, order.getMid());
//            out.setStaffTel(member.getMemberMobile());
//            out.setStaff(member.getMemberNm());
//            out.setOperator(member.getMemberNm());
//        }
        setCustomer(database, order, out);//设置客户资料未测试zzx
//        if (!StrUtil.isNull(order.getCid())) {
//            SysCustomer customer = customerDao.queryCustomerById(database, order.getCid());
//            if (customer != null) {
//                out.setKhNm(customer.getKhNm());
//                out.setShr(customer.getKhNm());
//            }
//        }
        if (!StrUtil.isNull(order.getStkId())) {
            out.setStkId(order.getStkId());
        }


        List<SysBforderDetail> orderList = order.getList();
        List<SysStkOutsub> subList = new ArrayList<SysStkOutsub>();

        SysConfig config = this.configService.querySysConfigByCode("CONFIG_OUT_PRODUCT_DATE", database);

        if (config != null && "1".equals(config.getStatus())) {
            if (StrUtil.isNull(out.getStkId())) {
                Map<String, Object> stkMap = this.bforderWebDao.getOneStkStorage(database);
                if (stkMap != null) {
                    out.setStkId(Integer.valueOf(stkMap.get("id") + ""));
                }
            }
        }

        if (orderList != null && orderList.size() > 0) {
            for (int i = 0; i < orderList.size(); i++) {
                SysBforderDetail detail = orderList.get(i);
                SysStkOutsub sub = new SysStkOutsub();
                sub.setWareId(detail.getWareId());
                sub.setQty(new BigDecimal(0));
                if (!StrUtil.isNull(detail.getWareNum())) {
                    sub.setQty(new BigDecimal(detail.getWareNum()));
                }
                if (!StrUtil.isNull(detail.getWareDw())) {
                    sub.setUnitName(detail.getWareDw());
                }
                if (!StrUtil.isNull(detail.getXsTp())) {
                    sub.setXsTp(detail.getXsTp());
                }
                if (!StrUtil.isNull(detail.getRemark())) {
                    sub.setRemarks(detail.getRemark());
                }
                if (!StrUtil.isNull(detail.getBeUnit())) {
                    sub.setBeUnit(detail.getBeUnit());
                }
                sub.setPrice(new BigDecimal(0));
                if (!StrUtil.isNull(detail.getWareDj())) {
                    sub.setPrice(new BigDecimal(detail.getWareDj()));
                }
                sub.setOutAmt(new BigDecimal(0));
                sub.setAmt(new BigDecimal(0));
                if (!StrUtil.isNull(detail.getWareZj())) {
                    //sub.setOutAmt(new BigDecimal(detail.getWareZj()));
                    sub.setAmt(new BigDecimal(detail.getWareZj()));
                }
                sub.setOutQty(new BigDecimal(0));
                List<SysWare> wareList = wareDao.queryStorageWareProductDateByWareId(detail.getWareId(), out.getStkId(), database);
                if (wareList != null && wareList.size() > 0) {
                    SysWare ware = wareList.get(0);
                    if (!StrUtil.isNull(ware.getProduceDate())) {
                        sub.setProductDate(ware.getProduceDate());
                        if (config != null && "1".equals(config.getStatus())) {
                            if (!StrUtil.isNull(ware.getSswId())) {
                                sub.setSswId(ware.getSswId() + "");
                            }
                        }
                    }
                    sub.setActiveDate(ware.getQualityDays());
                }
                subList.add(sub);
            }

        }
        this.sysBforderWebDao.updateCreate(order.getId(), database);//0：未创建 1：已创建为发票单
        this.addStkOut(out, subList, database);
        return out;
    }

    /**
     * 设置业务员资料
     *
     * @param database
     * @param order
     * @param out
     */
    private void setSalesman(String database, SysBforder order, SysStkOut out) {
        MemberBaseDTO dto = orderBaseService.getSalesman(database, order);
        if (dto != null) {
            out.setStaffTel(dto.getMobile());
            out.setStaff(dto.getName());
            out.setEmpType(order.getEmpType());
        }
    }

    /**
     * 设置客户
     *
     * @param database
     * @param order
     * @param out
     */
    private void setCustomer(String database, SysBforder order, SysStkOut out) {
        MemberBaseDTO dto = orderBaseService.getCustomer(database, order);
        if (dto != null) {
            out.setKhNm(dto.getName());
            out.setShr(dto.getName());
        }
    }

    public int updateAutoCreateOrderToSale(String database, SysBforder order) {
        SysStkOut out = this.bforderWebDao.queryByOrderId(database, order.getId());
        if (out == null) {
            return -2;
        }
        if (!StrUtil.isNull(out.getNewTime())) {
            return -1;
        }
        out.setOrderNo(order.getOrderNo());
        out.setOrderId(order.getId());
        out.setAddress(order.getAddress());
        out.setTel(order.getTel());
        out.setPszd(order.getPszd());
        out.setShr(order.getShr());
        out.setCstId(order.getCid());
        out.setEmpId(order.getMid());
        out.setRemarks(order.getRemo());
        out.setDisAmt1(new BigDecimal(0));
        out.setFreeAmt(new BigDecimal(0));
        out.setDisAmt(new BigDecimal(0));
        out.setRecAmt(new BigDecimal(0));
        out.setDiscount(new BigDecimal(0));
        if (!StrUtil.isNull(order.getZdzk())) {
            out.setDiscount(new BigDecimal(order.getZdzk()));
        }
        out.setTotalAmt(new BigDecimal(0));
        if (!StrUtil.isNull(order.getZje())) {
            out.setTotalAmt(new BigDecimal(order.getZje()));
        }
        if (!StrUtil.isNull(order.getCjje())) {
            out.setDisAmt(new BigDecimal(order.getCjje()));
        }
        out.setOutTime(new Date());
        out.setStatus(-2);
        out.setMid(order.getMid());
        out.setProType(2);
        out.setOutType("销售出库");
        out.setEmpType(order.getEmpType());
        out.setSaleType("001");
        if ("客户下单".equals(order.getOrderTp())) {
            out.setSaleType("003");
        }
        if (!StrUtil.isNull(order.getProType())) {
            out.setProType(order.getProType());
        }
//        List<StkStorage> ssList = storageDao.queryAll(database);
//        if(ssList!=null&&ssList.size()>0){
//            out.setStkId(ssList.get(0).getId());
//            out.setStkName(ssList.get(0).getStkName());
//        }

        Map<String, Object> map = this.bforderWebDao.getStkStorage(database);
        if (map != null) {
            out.setStkId(Integer.valueOf(map.get("id") + ""));
            out.setStkName(map.get("stk_name") + "");
        }

        setSalesman(database, order, out);//设置业务员未测试zzx
//        if (!StrUtil.isNull(order.getMid())) {
//            SysMember member = memberDao.queryCompanySysMemberById(database, order.getMid());
//            out.setStaffTel(member.getMemberMobile());
//            out.setStaff(member.getMemberNm());
//            out.setOperator(member.getMemberNm());
//        }
        setCustomer(database, order, out);//设置客户资料未测试zzx
//        if (!StrUtil.isNull(order.getCid())) {
//            SysCustomer customer = customerDao.queryCustomerById(database, order.getCid());
//            if (customer != null) {
//                out.setKhNm(customer.getKhNm());
//                out.setShr(customer.getKhNm());
//            }
//        }
        SysConfig config = this.configService.querySysConfigByCode("CONFIG_OUT_PRODUCT_DATE", database);

        if (!StrUtil.isNull(order.getStkId())) {
            out.setStkId(order.getStkId());
        }

        if (config != null && "1".equals(config.getStatus())) {
            if (StrUtil.isNull(out.getStkId())) {
                Map<String, Object> stkMap = this.bforderWebDao.getOneStkStorage(database);
                if (stkMap != null) {
                    out.setStkId(Integer.valueOf(stkMap.get("id") + ""));
                }
            }
        }
        List<SysBforderDetail> orderList = order.getList();
        List<SysStkOutsub> subList = new ArrayList<SysStkOutsub>();
        if (orderList != null && orderList.size() > 0) {
            for (int i = 0; i < orderList.size(); i++) {
                SysBforderDetail detail = orderList.get(i);
                SysStkOutsub sub = new SysStkOutsub();
                sub.setWareId(detail.getWareId());
                sub.setQty(new BigDecimal(0));
                if (!StrUtil.isNull(detail.getWareNum())) {
                    sub.setQty(new BigDecimal(detail.getWareNum()));
                }
                if (!StrUtil.isNull(detail.getWareDw())) {
                    sub.setUnitName(detail.getWareDw());
                }
                if (!StrUtil.isNull(detail.getXsTp())) {
                    sub.setXsTp(detail.getXsTp());
                }
                if (!StrUtil.isNull(detail.getRemark())) {
                    sub.setRemarks(detail.getRemark());
                }
                if (!StrUtil.isNull(detail.getBeUnit())) {
                    sub.setBeUnit(detail.getBeUnit());
                }
                sub.setPrice(new BigDecimal(0));
                if (!StrUtil.isNull(detail.getWareDj())) {
                    sub.setPrice(new BigDecimal(detail.getWareDj()));
                }
                sub.setOutAmt(new BigDecimal(0));
                sub.setAmt(new BigDecimal(0));
                if (!StrUtil.isNull(detail.getWareZj())) {
                    //sub.setOutAmt(new BigDecimal(detail.getWareZj()));
                    sub.setAmt(new BigDecimal(detail.getWareZj()));
                }
                sub.setOutQty(new BigDecimal(0));

                List<SysWare> wareList = wareDao.queryStorageWareProductDateByWareId(detail.getWareId(), out.getStkId(), database);
                if (wareList != null && wareList.size() > 0) {
                    SysWare ware = wareList.get(0);
                    if (!StrUtil.isNull(ware.getProduceDate())) {
                        sub.setProductDate(ware.getProduceDate());
                        if (config != null && "1".equals(config.getStatus())) {
                            if (!StrUtil.isNull(ware.getSswId())) {
                                sub.setSswId(ware.getSswId() + "");
                            }
                        }
                    }
                    sub.setActiveDate(ware.getQualityDays());
                }
                subList.add(sub);
            }

        }
        this.updateStkOut(out, subList, database);

        order.setIsCreate(1);//更新销售订单是否被关联
        this.bforderWebDao.updateBforder(order, database);

        return 1;
    }

    public void addStkOut(SysStkOut outRec, List<SysStkOutsub> list, String database) throws Exception {
        String billNo = "";
        if ("销售出库".equals(outRec.getOutType())) {
            billNo = this.bforderWebDao.newBillNoNew(database, "XSFP", "stk_out");
        }

        if (this.bforderWebDao.checkIsExist(billNo, database)) {
            if ("销售出库".equals(outRec.getOutType())) {
                billNo = this.bforderWebDao.newBillNoNew(database, "XSFP", "stk_out");
            }
            if (this.bforderWebDao.checkIsExist(billNo, database)) {
                throw new ServiceException("单号重复");
            }
        }
        if (StrUtil.isNull(outRec.getEmpType())) {
            outRec.setEmpType(1);
        }
        outRec.setBillNo(billNo);
        int id = this.bforderWebDao.addStkOut(outRec, database);
        outRec.setId(id);
        for (SysStkOutsub bo : list) {
            bo.setMastId(id);
            if (!StrUtil.isNull(outRec.getCheckAutoPrice()) && outRec.getCheckAutoPrice() == 1 && !StrUtil.isNull(bo.getPrice()) && bo.getPrice().doubleValue() != 0) {
                SysWare sysWare = wareDao.queryWareById(bo.getWareId(), database);
                if ("B".equals(bo.getBeUnit())) {
                    sysWare.setWareDj(bo.getPrice().doubleValue());
                } else if ("S".equals(bo.getBeUnit())) {
                    Double hsNum = sysWare.getHsNum();
                    BigDecimal price = bo.getPrice().multiply(new BigDecimal(hsNum));
                    price = price.setScale(2, BigDecimal.ROUND_HALF_UP);
                    sysWare.setWareDj(price.doubleValue());
                    sysWare.setSunitPrice(bo.getPrice());
                }
                this.wareDao.updateWare(sysWare, database);
            }

            this.bforderWebDao.addOutsub(bo, database);
        }
    }

    public void updateStkOut(SysStkOut outRec, List<SysStkOutsub> list, String database) {
        try {
            if (StrUtil.isNull(outRec.getEmpType())) {
                outRec.setEmpType(1);
            }
            this.bforderWebDao.updateStkout(outRec, database);
            this.bforderWebDao.deleteOutsub(database, outRec.getId());
            for (SysStkOutsub bo : list) {
                bo.setMastId(outRec.getId());
                if (!StrUtil.isNull(outRec.getCheckAutoPrice()) && outRec.getCheckAutoPrice() == 1 && !StrUtil.isNull(bo.getPrice()) && bo.getPrice().doubleValue() != 0) {
                    SysWare sysWare = wareDao.queryWareById(bo.getWareId(), database);
                    if ("B".equals(bo.getBeUnit())) {
                        sysWare.setWareDj(bo.getPrice().doubleValue());
                    } else if ("S".equals(bo.getBeUnit())) {
                        Double hsNum = sysWare.getHsNum();
                        BigDecimal price = bo.getPrice().multiply(new BigDecimal(hsNum));
                        price = price.setScale(2, BigDecimal.ROUND_HALF_UP);
                        sysWare.setWareDj(price.doubleValue());
                        sysWare.setSunitPrice(bo.getPrice());
                    }
                    this.wareDao.updateWare(sysWare, database);
                }

                this.bforderWebDao.addOutsub(bo, database);
            }

        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }


}
