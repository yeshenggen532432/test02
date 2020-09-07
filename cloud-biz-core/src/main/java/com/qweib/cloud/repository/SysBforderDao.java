package com.qweib.cloud.repository;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.SysBforder;
import com.qweib.cloud.core.domain.SysBforderDetail;
import com.qweib.cloud.core.domain.vo.OrderState;
import com.qweib.cloud.core.domain.vo.ShopBforderDetail;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.DateTimeUtil;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import com.qweib.commons.DateUtils;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

@Repository
public class SysBforderDao {
    @Resource(name = "daoTemplate")
    private JdbcDaoTemplate daoTemplate;

    /**
     * 说明：分页查询订单
     *
     * @创建：作者:llp 创建时间：2016-4-7
     * @修改历史： [序号](llp 2016 - 4 - 7)<修改说明>
     */
    public Page queryBforderPage(SysBforder order, Integer mId, String allDepts, String invisibleDepts, Integer page, Integer limit) {
        try {
            StringBuilder sql = new StringBuilder();
            sql.append("select a.*,b.kh_nm,c.member_nm,1 as count ");
            sql.append(" from " + order.getDatabase() + ".sys_bforder a");
            sql.append(" left join " + order.getDatabase() + ".sys_customer b on a.cid=b.id ");
            sql.append(" left join " + order.getDatabase() + ".sys_mem c on a.mid=c.member_id ");
            sql.append(" where 1=1 and (a.order_tp!='客户下单' or a.order_tp is null) ");

            if (!StrUtil.isNull(allDepts)) {//要查询的部门和可见部门
                if (!StrUtil.isNull(mId)) {//个人和可见部门结合查询
                    sql.append(" AND (c.branch_id IN (" + allDepts + ") ");
                    sql.append(" OR a.mid=" + mId + ")");
                } else {
                    sql.append(" AND c.branch_id IN (" + allDepts + ") ");
                }
            } else if (!StrUtil.isNull(mId)) {//个人
                sql.append(" AND a.mid=" + mId);
            }
            if (!StrUtil.isNull(invisibleDepts)) {//不可见部门
                sql.append(" AND c.branch_id NOT IN (" + invisibleDepts + ") ");
            }

            if (null != order) {
                if (!StrUtil.isNull(order.getKhNm())) {
                    sql.append(" and b.kh_nm like '%" + order.getKhNm() + "%'");
                }
                if (!StrUtil.isNull(order.getMemberNm())) {
                    sql.append(" and c.member_nm like '%" + order.getMemberNm() + "%'");
                }
                if (!StrUtil.isNull(order.getOrderNo())) {
                    sql.append(" and a.order_no like '%" + order.getOrderNo() + "%'");
                }
                if (!StrUtil.isNull(order.getOrderZt())) {
                    sql.append(" and a.order_zt='" + order.getOrderZt() + "'");
                }
                if (!StrUtil.isNull(order.getPszd())) {
                    sql.append(" and a.pszd='" + order.getPszd() + "'");
                }
                if (!StrUtil.isNull(order.getSdate())) {
                    sql.append(" and a.oddate >='").append(order.getSdate()).append("'");
                }
                if (!StrUtil.isNull(order.getEdate())) {
                    sql.append(" and a.oddate <='").append(order.getEdate()).append("'");
                }
                if (!StrUtil.isNull(order.getStkId()) && order.getStkId() != -1) {
                    sql.append(" and a.stk_id=").append(order.getStkId());
                }
                if (!StrUtil.isNull(order.getOrderLb())) {//订单类别
                    sql.append(" and a.order_lb='" + order.getOrderLb() + "'");
                }
            }
            sql.append(" order by a.id desc");

            return this.daoTemplate.queryForPageByMySql(sql.toString(), page, limit, SysBforder.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：分页查询订单详情
     *
     * @创建：作者:llp 创建时间：2016-4-7
     * @修改历史： [序号](llp 2016 - 4 - 7)<修改说明>
     */
    public Page queryBforderDetailPage(Integer orderId, String database, Integer page, Integer limit) {
        StringBuilder sql = new StringBuilder();
        sql.append("select a.*,b.ware_nm,b.ware_gg from " + database + ".sys_bforder_detail a left join " + database + ".sys_ware b on a.ware_id=b.ware_id " +
                "where 1=1");
        if (!StrUtil.isNull(orderId)) {
            sql.append(" and a.order_id=" + orderId + "");
        }
        sql.append(" order by a.id asc");
        try {
            return this.daoTemplate.queryForPageByMySql(sql.toString(), page, limit, SysBforderDetail.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }


    public List<SysBforderDetail> queryBforderDetailList(String orderIds, String database) {
        StringBuilder sql = new StringBuilder();
        sql.append("select a.*,b.ware_nm,b.ware_gg from " + database + ".sys_bforder_detail a left join " + database + ".sys_ware b on a.ware_id=b.ware_id " +
                "where 1=1");
        if (!StrUtil.isNull(orderIds)) {
            sql.append(" and a.order_id in(" + orderIds + ")");
        }
        sql.append(" order by a.id asc");
        try {
            return this.daoTemplate.queryForLists(sql.toString(), SysBforderDetail.class);
        } catch (Exception e) {
            throw new DaoException(e);
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
        StringBuffer sql = new StringBuffer();
        sql.append("update " + database + ".sys_bforder set order_zt='已作废'");
        sql.append(",cancel_time='").append(DateTimeUtil.getDateToStr()).append("'");
        sql.append(",status=").append(OrderState.cancel.getCode());
        sql.append(",cancel_remo='").append(cancelRemo).append("'");
        if (isRefund)
            sql.append(",is_pay=").append(10);
        sql.append(" where id in (").append(ids).append(")");
        //sql.append(" and order_zt !='审核'");
        return this.daoTemplate.update(sql.toString());
    }

    /**
     * 修改订单状态
     *
     * @param database
     * @param ids      订单IDS
     * @param zt       状态
     * @return
     */
    public int updateOrderSh(String database, Integer ids, String zt) {
        StringBuffer sql = new StringBuffer();
        sql.append("update " + database + ".sys_bforder set order_zt='" + zt + "'");
        sql.append(" where id in (").append(ids).append(")");
        return this.daoTemplate.update(sql.toString());
    }

    public int updateOrderIsSend(String database, Integer id, Integer isSend) {
        String sendTime = null;
        Integer status = OrderState.sendWait.getCode(); //2已支付待发货
        if (isSend != null && isSend == 1) {//已发货待收货
            sendTime = DateTimeUtil.getDateToStr();
            status = OrderState.sendRece.getCode();//3已发货待收货
        }
        String sql = "update " + database + ".sys_bforder set is_send=?,sh_time=?,status=? where id=?";
        try {
            return this.daoTemplate.update(sql, isSend, sendTime, status, id);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public int updateOrderIsSend(String database, Integer id, Integer isSend, String transportCode, String transportName) {
        String sendTime = null;
        Integer status = OrderState.sendWait.getCode(); //2已支付待发货
        if (Objects.equals(isSend, Integer.valueOf(1))) {//已发货待收货
            sendTime = DateTimeUtil.getDateToStr();
            status = OrderState.sendRece.getCode();//3已发货待收货
        }
        String sql = "update " + database + ".sys_bforder set is_send=?,sh_time=?,status=?,transport_code=?,transport_name=? where id=?";
        try {
            return this.daoTemplate.update(sql, isSend, sendTime, status, transportCode, transportName, id);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public int update(String database, SysBforder bforder) {
        try {
            Map<String, Object> whereParam = new HashMap<>();
            if (bforder != null) {
                whereParam.put("id", bforder.getId());
            }
            return this.daoTemplate.updateByObject(database + ".sys_bforder", bforder, whereParam, null);
        } catch (Exception e) {
            throw new DaoException(e);
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
            //String sql = "select * from "+database+".sys_bforder where id=?";

            StringBuilder sql = new StringBuilder();
            sql.append("select a.*,1 as count");
            //客户名称查询
            sql.append(getKhMemberNm(database, true));
            sql.append(" from " + database + ".sys_bforder a left join  (select v.id,v.kh_nm,v.pro_type from ( select m.id,m.kh_nm,2 as pro_type from " + database + ".sys_customer m union all select n.id,n.name as kh_nm,4 as pro_type from " + database + ".shop_member n) v  ) b on a.cid=b.id and (b.pro_type=a.pro_type or a.pro_type is null) left  join " + database + ".sys_mem c on a.mid=c.member_id " +
                    "where 1=1 ").append(" and ").append(" a.id='" + id + "'");
            return this.daoTemplate.queryForObj(sql.toString(), SysBforder.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public List<SysBforderDetail> queryBforderDetail(String database, Integer orderId) {
        try {
            //String sql = "select a.*,b.ware_nm,b.ware_gg from "+database+".sys_bforder_detail a left join "+database+".sys_ware b on a.ware_id=b.ware_id where a.order_id="+orderId;

            String sql = "select a.ware_dj_original,a.detail_promotion_cost,a.detail_coupon_cost,a.detail_ware_nm,a.detail_shop_ware_alias,a.detail_ware_gg,a.ware_id,a.order_id,a.ware_num,a.ware_dj,a.ware_zj,a.ware_dw as ware_dw2,a.xs_tp,a.be_unit,a.remark,b.ware_dw,b.ware_nm,b.ware_gg,b.hs_num,b.max_unit_code,b.min_unit_code,b.min_unit from " + database + ".sys_bforder_detail a left join " + database + ".sys_ware b on a.ware_id = b.ware_id "
                    + " where a.order_id =" + orderId + " ";

            return this.daoTemplate.queryForLists(sql, SysBforderDetail.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @说明：删除订单
     * @创建：作者:llp 创建时间：2016-5-31
     * @修改历史： [序号](llp 2016 - 5 - 31)<修改说明>
     */
    public int deleteOrder(String database, Integer id) {
        String sql = "delete from " + database + ".sys_bforder where id=?";
        try {
            return this.daoTemplate.update(sql, id);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }


    /**
     * 会员下单订单查询
     *
     * @param order
     * @param page
     * @param limit
     * @return
     */
    public Page queryShopBforderPage(SysBforder order, Integer page, Integer limit) {
        try {
            StringBuilder sql = new StringBuilder();
            sql.append("select a.*,1 as count");
            //客户名称查询
            sql.append(getKhMemberNm(order.getDatabase(), false));

            sql.append(" from " + order.getDatabase() + ".sys_bforder a ");
            //自定义表v(id,kh_nm,pro_type)：客户表sys_customer和会员表shop_member合并
            //sql.append("left join (select v.id,v.kh_nm,v.pro_type from ( select m.id,m.kh_nm,2 as pro_Type from " + order.getDatabase() + ".sys_customer m union all select n.id,n.name as kh_nm,4 as pro_type from " + order.getDatabase() + ".shop_member n) v  ) b on a.cid=b.id  ");
            sql.append(getShopBforderWhere(order, true)).append(" order by a.id desc");
            if (!StrUtil.isNull(order.getKhNm())) {
                return daoTemplate.queryForPageByMySql2(sql.toString(), page, limit, SysBforder.class);
            } else {
                return this.daoTemplate.queryForPageByMySql(sql.toString(), page, limit, SysBforder.class);
            }
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public List<SysBforder> queryShopBforderList(SysBforder order, String database) {
        try {
            StringBuilder sql = new StringBuilder();
            sql.append("select a.*,1 as count ");
            sql.append(" from " + order.getDatabase() + ".sys_bforder a ");
            sql.append(getShopBforderWhere(order, true)).append(" order by a.id desc");
            return this.daoTemplate.queryForLists(sql.toString(), SysBforder.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 商城订单条件封装
     *
     * @param order
     * @return
     */
    private String getShopBforderWhere(SysBforder order, boolean khWhere) {
        StringBuffer sql = new StringBuffer();
        sql.append(" where 1=1 and a.order_tp='客户下单'");
        if (order != null) {
            if (!StrUtil.isNull(order.getShopMemberName())) {
                sql.append(" and a.shop_member_name like '%" + order.getShopMemberName() + "%'");
            }
            if(order.getDistributionMode()!= null)
            {
                if(order.getDistributionMode().intValue() > 0)
                {
                    sql.append(" and a.distribution_mode=" + order.getDistributionMode());
                }
            }
            if (!StrUtil.isNull(order.getOrderNo())) {
                sql.append(" and a.order_no like '%" + order.getOrderNo() + "%'");
            }
            if (!StrUtil.isNull(order.getOrderZt())) {
                if ("正常订单".equals(order.getOrderZt()))
                    sql.append(" and a.order_zt !='已作废'");
                else
                    sql.append(" and a.order_zt='" + order.getOrderZt() + "'");
            }
            if (!StrUtil.isNull(order.getPszd())) {
                sql.append(" and a.pszd='" + order.getPszd() + "'");
            }
            if (!StrUtil.isNull(order.getSdate())) {
                sql.append(" and a.oddate >='").append(order.getSdate()).append("'");
            }
            if (!StrUtil.isNull(order.getEdate())) {
                sql.append(" and a.oddate <='").append(order.getEdate()).append("'");
            }
            if (!StrUtil.isNull(order.getCreateDate())) {
                sql.append(" and a.create_date >='").append(DateUtils.formatDateTime(order.getCreateDate())).append("'");
            }
            if (!StrUtil.isNull(order.getStkId()) && order.getStkId() != -1) {
                sql.append(" and a.stk_id=").append(order.getStkId());
            }
            if (!StrUtil.isNull(order.getShopMemberId()) && order.getShopMemberId() != 0) {
                sql.append(" and a.shop_member_id=").append(order.getShopMemberId());
            }
            if (!StrUtil.isNull(order.getIsPay())) {
                //0或NULL:未支付；1：已支付
                if (order.getIsPay() == 1 || order.getIsPay() == 10) {
                    sql.append(" and a.is_pay='" + order.getIsPay() + "'");
                } else {
                    sql.append(" and (a.is_pay='" + order.getIsPay() + "' or a.is_pay is NULL) ");
                }
            }
            if (!StrUtil.isNull(order.getIsSend())) {
                //0或NULL:未发货；1：已发货
                if (order.getIsSend() == 1) {
                    sql.append(" and a.is_send='" + order.getIsSend() + "'");
                } else {
                    sql.append(" and (a.is_send='" + order.getIsSend() + "' or a.is_send is NULL) ");
                }
            }
            if (!StrUtil.isNull(order.getIsFinish())) {
                //0或NULL:未完成；1：已完成
                if (order.getIsFinish() == 1 || order.getIsFinish() == -1) {
                    sql.append(" and a.is_finish='" + order.getIsFinish() + "'");
                } else {
                    sql.append(" and (a.is_finish='" + order.getIsFinish() + "' or a.is_finish is NULL) ");
                }
            }
            if (!StrUtil.isNull(order.getPayType())) {
                sql.append(" and a.pay_type=" + order.getPayType());
            }
            if (!StrUtil.isNull(order.getStatus())) {
                sql.append(" and a.status=" + order.getStatus());
                if(order.getStatus().intValue() == 0)//退款
                {
                    sql.append(" and a.id in(select order_id from " + order.getDatabase() + ".shop_cancel_mast where refund_status=0 )");
                }
            }
            //餐饮订单
            /*if (order.getOrderType() != null && order.getOrderType() != 0) {
                if (order.getOrderType() == 1)
                    sql.append(" and (a.shop_dining_id is null and a.tour_id is null)");
                else if (order.getOrderType() == 9)
                    sql.append(" and a.shop_dining_id is not null");
                else if (order.getOrderType() == 10)
                    sql.append(" and a.tour_id is not null");
                else if (order.getOrderType() == 11)
                    sql.append(" and a.head_tour_id is not null");
            }*/

            if (order.getOrderType() != null) {
                sql.append(" and a.order_type =").append(order.getOrderType());
            }
            if (order.getPromotionId() != null) {
                sql.append(" and a.promotion_id =").append(order.getPromotionId());
            }

           /* if (order.getShopDiningId() != null) {
                sql.append(" and shop_dining_id=").append(order.getShopDiningId());
            }

            if (!StrUtil.isNumberNullOrZero(order.getTourId())) {
                sql.append(" and tour_id=").append(order.getTourId());
            }

            if (!StrUtil.isNumberNullOrZero(order.getHeadTourId())) {
                sql.append(" and head_tour_id=").append(order.getHeadTourId());
            }*/

            if (!StrUtil.isNull(order.getTourIds())) {
                sql.append(" and tour_id in(").append(order.getTourIds()).append(")");
            }
            if (!StrUtil.isNull(order.getAddressId())) {
                sql.append(" and address_id =").append(order.getAddressId());
            }
            if (!StrUtil.isNull(order.getTakeName())) {
                sql.append(" and a.take_name like '%" + order.getTakeName() + "%'");
            }
            if (!StrUtil.isNull(order.getTakeTel())) {
                sql.append(" and a.take_tel like '%" + order.getTakeTel() + "%'");
            }
            if (khWhere && !StrUtil.isNull(order.getKhNm())) {
                sql.append(" HAVING kh_nm like '%" + order.getKhNm() + "%'");
            }
            if(!StrUtil.isNull(order.getAddress()))
            {
                sql.append(" and a.address like '%" + order.getAddress() + "%'");
            }

        }
        return sql.toString();
    }

    /**
     * 订单中客户名称和业务员名称查询SQL
     *
     * @param database
     * @param queryMemberNm
     * @return
     */
    private String getKhMemberNm(String database, boolean queryMemberNm) {
        StringBuffer sql = new StringBuffer();
        //客户名
        sql.append(",CASE WHEN  a.pro_type = 1 THEN(SELECT m.member_nm FROM " + database + ".sys_mem m WHERE m.member_id = a.cid)");//员工
        sql.append("WHEN a.pro_type = 2 THEN (SELECT m.kh_nm FROM " + database + ".sys_customer m WHERE m.id = a.cid)");//客户
        sql.append("WHEN a.pro_type = 4 THEN(SELECT m. NAME FROM " + database + ".shop_member m WHERE m.id = a.cid)");//会员
        sql.append("END AS kh_nm");
        if (!queryMemberNm) return sql.toString();
        //业务员名
        sql.append(",CASE WHEN a.emp_type = 2 OR a.emp_type = 1 THEN(SELECT m.member_nm FROM " + database + ".sys_mem m WHERE m.member_id = a.mid)");//客户所属业务和员工
        sql.append("WHEN a.emp_type = 4 THEN(SELECT m.NAME FROM " + database + ".shop_member m WHERE CASE WHEN a.mid = -1 THEN m.id = a.cid WHEN a.mid !=-1 THEN m.mem_id = a.mid end)");//会员(如果min=-1时说明是临时会员，业务员ID=客户ID)
        sql.append("END AS member_nm");
        return sql.toString();
    }

    /**
     * 修改商城订单完成(待收货才能完成)
     */
    public int updateShopBforderIsfinish(Integer id, String database) {
        try {
            String finishTime = DateTimeUtil.getDateToStr();
            String sql = "update " + database + ".sys_bforder set is_finish=1,status=" + OrderState.finish.getCode() + ",finish_time='" + finishTime + "' where status =" + OrderState.sendRece.getCode() + " and id=" + id;
            return this.daoTemplate.update(sql);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：分页查询订单
     *
     * @创建：作者:llp 创建时间：2016-4-7
     * @修改历史： [序号](llp 2016 - 4 - 7)<修改说明>
     */
    public Page queryShopPayPage(String database, SysBforder order, Integer page, Integer limit) {
        try {
            StringBuilder sql = new StringBuilder();
            sql.append(" select v.pay_type,sum(v.cjje) as cjje from(");
            sql.append(" select a.* from " + database + ".sys_bforder a ");
            sql.append(" where 1=1 ");
            if (null != order) {
                if (!StrUtil.isNull(order.getEdate())) {
                    sql.append(" and a.oddate <='").append(order.getEdate()).append("'");
                }
                if (!StrUtil.isNull(order.getSdate())) {
                    sql.append(" and a.oddate >='").append(order.getSdate()).append("'");
                }
            }
            sql.append(" ) as v ");
            sql.append(" group by v.pay_type HAVING v.pay_type is not null ");
            return this.daoTemplate.queryForPageByMySql(sql.toString(), page, limit, SysBforder.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 修改商城订单状态
     */
    public int updateShopBforderState(Integer id, OrderState orderState, String database) {
        try {
            String finishTime = DateTimeUtil.getDateToStr();
            String sql = "update " + database + ".sys_bforder set status=" + orderState.getCode() + " where id=" + id;
            return this.daoTemplate.update(sql);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }


    /**
     * 商城订单详情（并返回商品最新单位和规格）
     *
     * @param database
     * @param orderId
     * @return
     */
    public List<ShopBforderDetail> queryShopBforderDetail(String database, Integer orderId) {
        try {
            String sql = "select a.*,b.ware_dw new_ware_dw,b.ware_gg new_ware_gg,b.max_unit_code,b.min_unit_code,b.min_unit new_min_unit,b.min_Ware_Gg new_min_ware_gg,b.hs_num,b.ware_nm from " + database + ".sys_bforder_detail a left join " + database + ".sys_ware b on a.ware_id = b.ware_id "
                    + " where a.order_id =" + orderId + " ";

            return this.daoTemplate.queryForLists(sql, ShopBforderDetail.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }


    /**
     * 会员下单订单查询
     *
     * @param order
     * @return
     */
    public List<SysBforderDetail> queryShopBforderDetailGroup(SysBforder order) {
        StringBuilder sql = new StringBuilder();
        //如果客户搜索不存在时,无须关联客户条件,如果客户名称搜索存在时用户名分组后在统计
        if (StrUtil.isNull(order.getKhNm())) {
            sql.append("SELECT d.detail_ware_nm,d.detail_ware_gg,d.ware_dw,sum(d.ware_num) as ware_num");
            sql.append(" FROM " + order.getDatabase() + ".sys_bforder a LEFT JOIN " + order.getDatabase() + ".sys_bforder_detail d on a.id=d.order_id");
            sql.append(getShopBforderWhere(order, false)).append(" GROUP BY d.ware_id,d.be_unit");
            sql.append(" order by ware_num desc");
        } else {
            sql.append("select t.detail_ware_nm,t.detail_ware_gg,t.ware_dw,sum(t.ware_num) AS ware_num from (");
            sql.append("SELECT d.ware_id,d.be_unit,d.detail_ware_nm,d.detail_ware_gg,d.ware_dw,sum(d.ware_num) as ware_num");
            sql.append(getKhMemberNm(order.getDatabase(), false));
            sql.append(" FROM " + order.getDatabase() + ".sys_bforder a LEFT JOIN " + order.getDatabase() + ".sys_bforder_detail d on a.id=d.order_id");
            sql.append(getShopBforderWhere(order, false)).append(" GROUP BY d.ware_id,d.be_unit,kh_nm");
            sql.append(" HAVING kh_nm like '%" + order.getKhNm() + "%'");
            sql.append(")t");
            sql.append(" GROUP BY t.ware_id,t.be_unit");
            sql.append(" order by ware_num desc");
        }

        return this.daoTemplate.queryForLists(sql.toString(), SysBforderDetail.class);
    }

}
