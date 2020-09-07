package com.qweib.cloud.biz.system.service;

import com.qweib.cloud.core.domain.SysBforder;
import com.qweib.cloud.core.domain.SysBforderDetail;
import com.qweib.cloud.core.domain.SysLoginInfo;
import com.qweib.cloud.core.domain.SysWarePic;
import com.qweib.cloud.core.domain.vo.OrderState;
import com.qweib.cloud.core.domain.vo.ShopBforderDetail;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.repository.SysBforderDao;
import com.qweib.cloud.repository.SysWarePicWebDao;
import com.qweib.cloud.repository.company.SysDeptmempowerDao;
import com.qweib.cloud.repository.ws.SysDepartDao;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.*;

@Service
public class SysBforderService {
    @Resource
    private SysBforderDao bforderDao;
    @Resource
    private SysDepartDao departDao;
    @Resource
    private SysDeptmempowerDao deptmempowerDao;
    @Resource
    private SysWarePicWebDao wareWebPicDao;
    @Resource
    private SysBforderPicService sysBforderPicService;

    /**
     * 说明：分页查询订单
     *
     * @创建：作者:llp 创建时间：2016-4-7
     * @修改历史： [序号](llp 2016 - 4 - 7)<修改说明>
     */
    public Page queryBforderPage(SysBforder order, String dataTp, SysLoginInfo info, Integer page, Integer limit) {
        try {
            String datasource = info.getDatasource();
            Integer memberId = info.getIdKey();
            String depts = "";//部门
            String visibleDepts = "";//可见部门
            String invisibleDepts = "";//不可见部门
            Integer mId = null;//是否个人
            if ("1".equals(dataTp)) {//查询全部部门
                Map<String, Object> allDeptsMap = departDao.queryAllDeptsForMap(datasource);
                if (null != allDeptsMap && !StrUtil.isNull(allDeptsMap.get("depts"))) {//不为空
                    depts = (String) allDeptsMap.get("depts");
                }
            } else if ("2".equals(dataTp)) {//部门及子部门
                Map<String, Object> map = departDao.queryBottomDepts(memberId, datasource);
                if (null != map && !StrUtil.isNull(map.get("depts"))) {//不为空（如:7-9-11-）
                    String dpt = (String) map.get("depts");
                    depts = dpt.substring(0, dpt.length() - 1).replace("-", ",");//去掉最后一个“-”并转成逗号隔开的字符串
                }
            } else if ("3".equals(dataTp)) {//个人
                mId = memberId;
            }


            //查询可见部门(如：-4-，-7-4-)
            visibleDepts = getPowerDepts(datasource, memberId, "1", visibleDepts);
            //查询不可见部门
            invisibleDepts = getPowerDepts(datasource, memberId, "2", invisibleDepts);
            String allDepts = StrUtil.addStr(depts, visibleDepts);//整合要查询的部门和可见部门
            return this.bforderDao.queryBforderPage(order, mId, allDepts, invisibleDepts, page, limit);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    //获取权限部门（可见或不可见）
    private String getPowerDepts(String datasource, Integer memberId, String tp, String visibleDepts) {
        Map<String, Object> visibleMap = deptmempowerDao.queryPowerDeptsByMemberId(memberId, tp, datasource);
        if (null != visibleMap && !StrUtil.isNull(visibleMap.get("depts"))) {//将查出来的格式（如：-4-，-7-4-）转换成逗号隔开（如：4,7，4）
            visibleDepts = visibleMap.get("depts").toString().replace("-,-", "-");
            visibleDepts = visibleDepts.substring(1, visibleDepts.length() - 1).replace("-", ",");
        }
        return visibleDepts;
    }

    /**
     * 说明：分页查询订单详情
     *
     * @创建：作者:llp 创建时间：2016-4-7
     * @修改历史： [序号](llp 2016 - 4 - 7)<修改说明>
     */
    public Page queryBforderDetailPage(Integer orderId, String database, Integer page, Integer limit) {
        try {
            return this.bforderDao.queryBforderDetailPage(orderId, database, page, limit);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 封装订单商品使用
     *
     * @param bforderList
     * @param database
     */
    public List<SysBforderDetail> queryBforderDetailList(List<SysBforder> bforderList, String database) {
        try {
            List<SysBforderDetail> allDetailList = new ArrayList<>();
            if (bforderList == null || bforderList.isEmpty()) return null;
            Set<String> orderIds = new HashSet<>();
            for (SysBforder sysBforder : bforderList) {
                orderIds.add(sysBforder.getId() + "");
            }
            List<SysBforderDetail> detailList = this.bforderDao.queryBforderDetailList(String.join(",", orderIds), database);
            allDetailList.addAll(detailList);
            Map<Integer, List<SysBforderDetail>> map = new HashMap<>();
            for (SysBforderDetail sysBforderDetail : detailList) {
                List<SysBforderDetail> list = map.get(sysBforderDetail.getOrderId());
                if (list == null) list = new ArrayList<>();
                if (list.size() > 50) continue;//限制列表只显示最多50条
                list.add(sysBforderDetail);
                map.put(sysBforderDetail.getOrderId(), list);
            }
            for (SysBforder sysBforder : bforderList) {
                List<SysBforderDetail> detailList1 = map.get(sysBforder.getId());
                if (detailList1 == null) detailList1 = new ArrayList<>();
                sysBforder.setList(detailList1);
            }
            return allDetailList;
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }


    /**
     * 作废订单
     *
     * @param database
     * @param ids        订单IDS
     * @param cancelRemo 取消原因
     * @param isRefund   是否退款
     * @return
     */
    public int updateOrderCancel(String database, String ids, String cancelRemo, boolean isRefund) {
        return this.bforderDao.updateOrderCancel(database, ids, cancelRemo, isRefund);
    }

    /**
     * 订单批量状态修改
     *
     * @param database
     * @param id
     * @param
     * @return
     */
    public int updateOrderSh(String database, Integer id, String sh) {
        try {
            return this.bforderDao.updateOrderSh(database, id, sh);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    public int updateOrderIsSend(String database, Integer id, Integer isSend) {
        try {
            return this.bforderDao.updateOrderIsSend(database, id, isSend);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    public int update(String database, SysBforder bforder) {
        try {
            return this.bforderDao.update(database, bforder);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 说明：根据订单id获取订单信息
     *
     * @创建：作者:llp 创建时间：2016-5-17
     * @修改历史： [序号](llp 2016 - 5 - 17)<修改说明>
     */
    public SysBforder queryBforderByid(String database, Integer id) {
        try {
            return this.bforderDao.queryBforderByid(database, id);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }


    public List<SysBforderDetail> queryBforderDetail(String database, Integer orderId) {
        try {
            return this.bforderDao.queryBforderDetail(database, orderId);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * @说明：删除订单
     * @创建：作者:llp 创建时间：2016-5-31
     * @修改历史： [序号](llp 2016 - 5 - 31)<修改说明>
     */
    public int deleteOrder(String database, Integer id) {
        try {
            return this.bforderDao.deleteOrder(database, id);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }


    /**
     * 查询会员订单
     */
    public Page queryShopBforderPage(SysBforder order, Integer page, Integer limit) {
        try {
            return this.bforderDao.queryShopBforderPage(order, page, limit);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<SysBforder> queryShopBforderList(SysBforder order, String database) {
        List<SysBforder> orderList = this.bforderDao.queryShopBforderList(order, database);
        //this.queryBforderDetailList(orderList, order.getDatabase());
        return orderList;
    }

    /**
     * 查询会员订单：并订单默认显示一个商品信息
     */
    public Page queryShopBforderPage2(SysBforder order, Integer pageNo, Integer limit) {
        try {
            Page page = this.bforderDao.queryShopBforderPage(order, pageNo, limit);
            if (page != null) {
                //分组列表
                List<SysBforder> bfOrderList = page.getRows();
                if (bfOrderList != null && !bfOrderList.isEmpty()) {
                    for (SysBforder sysBforder : bfOrderList) {
                        //备注：修改手机端的订单状态文字（后台的订单状态：审核，未审核，已作废）
                       /* if ("审核".equals(sysBforder.getOrderZt())) {
                            sysBforder.setOrderZt("已确认");
                        } else if ("未审核".equals(sysBforder.getOrderZt())) {
                            sysBforder.setOrderZt("待确认");
                        } else if ("已作废".equals(sysBforder.getOrderZt())) {
                            sysBforder.setOrderZt("已失效");
                        }*/
                        //商品列表
                        List<SysBforderDetail> list = this.bforderDao.queryBforderDetail(order.getDatabase(), sysBforder.getId());
                        if (list == null || list.isEmpty()) continue;
                        sysBforderPicService.setSysBforderDetailPic(order.getDatabase(), list);//使用快照图片zzx
                        setSysWarePic(order.getDatabase(), list);
                        /*sysBforder.setList(list);
                        if (list != null && !list.isEmpty()) {
                            //图片
                            for (SysBforderDetail sysBforderDetail : list) {
                                SysWarePic warePic = new SysWarePic();
                                warePic.setWareId(sysBforderDetail.getWareId());
                                List<SysWarePic> picList = wareWebPicDao.queryWarePic(order.getDatabase(), warePic);
                                //设置图片
                                sysBforderDetail.setWarePicList(picList);
                                if (!StrUtil.isNull(sysBforderDetail.getDetailShopWareAlias()))//订单别名zzx
                                    sysBforderDetail.setDetailWareNm(sysBforderDetail.getDetailShopWareAlias());
                            }
                        }*/
                        //设置商品列表
                        sysBforder.setList(list);
                        //order.setList(list);
                    }
                }
            }
            return page;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * 订单商品图片
     *
     * @param database
     * @param list
     */
    public void setSysWarePic(String database, List<SysBforderDetail> list) {
        Set<String> wids = new HashSet<>();
        for (SysBforderDetail sysBforderDetail : list) {
            wids.add(sysBforderDetail.getWareId().toString());
        }
        List<SysWarePic> pics = wareWebPicDao.queryWarePicByIds(database, String.join(",", wids));
        Map<Integer, List<SysWarePic>> map = new HashMap<>();
        for (SysWarePic warePic : pics) {
            List<SysWarePic> temp = map.get(warePic.getWareId());
            if (temp == null) temp = new ArrayList<>();
            temp.add(warePic);
            map.put(warePic.getWareId(), temp);
        }
        for (SysBforderDetail sysBforderDetail : list) {
            sysBforderDetail.setWarePicList(map.get(sysBforderDetail.getWareId()));
        }
    }


    /**
     * 修改商城订单是否完成
     */
    public int updateShopBforderIsfinish(Integer id, String database) {
        try {
            return this.bforderDao.updateShopBforderIsfinish(id, database);
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServiceException(e);
        }
    }

    /**
     *
     */
    public Page queryShopPayPage(String database, SysBforder order, Integer page, Integer rows) {
        try {
            return this.bforderDao.queryShopPayPage(database, order, page, rows);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }


    /**
     * 修改订单状态
     *
     * @param id
     * @param orderState
     * @param database
     * @return
     */
    public int updateShopBforderState(Integer id, OrderState orderState, String database) {
        return this.bforderDao.updateShopBforderState(id, orderState, database);
    }

    /**
     * 商城订单详情（并返回商品最新单位和规格）
     *
     * @param database
     * @param orderId
     * @return
     */
    public List<ShopBforderDetail> queryShopBforderDetail(String database, Integer orderId) {
        return bforderDao.queryShopBforderDetail(database, orderId);
    }

    /**
     * 按商品ID和简单统计数量
     *
     * @param bforder
     * @return
     */
    public List<SysBforderDetail> queryShopBforderDetailGroup(SysBforder bforder) {
        return bforderDao.queryShopBforderDetailGroup(bforder);
    }

}
