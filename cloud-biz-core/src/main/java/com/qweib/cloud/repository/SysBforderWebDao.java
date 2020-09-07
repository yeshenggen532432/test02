package com.qweib.cloud.repository;

import com.qweib.cloud.core.domain.SysBforder;
import com.qweib.cloud.core.domain.SysBforderDetail;
import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.SysStkOut;
import com.qweib.cloud.core.domain.SysStkOutsub;

import com.qweib.cloud.core.domain.vo.OrderType;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.Collections3;
import com.qweib.cloud.utils.DateTimeUtil;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.*;

@Repository
public class SysBforderWebDao {
    @Resource(name = "daoTemplate")
    private JdbcDaoTemplate daoTemplate;

    /**
     * 说明：添加订单
     *
     * @创建：作者:llp 创建时间：2016-3-28
     * @修改历史： [序号](llp 2016 - 3 - 28)<修改说明>
     */
    public int addBforder(SysBforder bforder, String database) {
        try {
            if (bforder.getOddate() == null)
                bforder.setOddate(DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd"));
            if (bforder.getOdtime() == null)
                bforder.setOdtime(DateTimeUtil.getDateToStr(new Date(), "HH:mm:ss"));
            bforder.setCreateDate(new Date());
            if (bforder.getOrderType() == null)//默认为普通订单
                bforder.setOrderType(OrderType.general.getCode());
            //bforder.setOrderZt("审核");
            return this.daoTemplate.addByObject("" + database + ".sys_bforder", bforder);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：删除订单
     *
     * @创建：作者:ysg 创建时间：2018-09-14
     * @修改历史： [序号](ysg 2018 - 09 - 14)<修改说明>
     */
    public int deleteBforder(SysBforder bforder, String database) {
        try {
            String sql = "";
            if (bforder != null) {
                if (!StrUtil.isNull(bforder.getId())) {
                    sql = " delete from " + database + ".sys_bforder where id=" + bforder.getId();
                }
            }
            return this.daoTemplate.update(sql);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：修改订单
     *
     * @创建：作者:llp 创建时间：2016-3-28
     * @修改历史： [序号](llp 2016 - 3 - 28)<修改说明>
     */
    public int updateBforder(SysBforder bforder, String database) {
        try {
            Map<String, Object> whereParam = new HashMap<String, Object>();
            whereParam.put("id", bforder.getId());
            return this.daoTemplate.updateByObject("" + database + ".sys_bforder", bforder, whereParam, "id");
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：自增id
     *
     * @创建：作者:llp 创建时间：2016-3-24
     * @修改历史： [序号](llp 2016 - 3 - 24)<修改说明>
     */
    public Integer getAutoId() {
        try {
            return this.daoTemplate.getAutoIdForIntByMySql();
        } catch (Exception e) {
            throw new DaoException(e);
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
//			String sql = "select * from "+database+".sys_bforder where mid=? and cid=? and oddate=? and order_lb='拜访单'";
            String sql = "select bf.*,st.stk_name as stkName from " + database + ".sys_bforder as bf left join " + database + ".stk_storage as st on (bf.stk_id=st.id) "
                    + "where mid=? and cid=? and oddate=? and order_lb='拜访单'";
            return this.daoTemplate.queryForObj(sql, SysBforder.class, mid, cid, oddate);
        } catch (Exception e) {
            throw new DaoException(e);
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
//			String sql = "select * from "+database+".sys_bforder where id=?";
            String sql = "select bf.*,st.stk_name as stkName,c.kh_nm from " + database + ".sys_bforder as bf left join " + database + ".stk_storage as st on (bf.stk_id=st.id) "
                    + " left join " + database + ".sys_customer c on c.id= bf.cid "
                    + "where bf.id=?";
            return this.daoTemplate.queryForObj(sql, SysBforder.class, id);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }
    //--------------------------------订单详情------------------------------

    /**
     * 说明：添加订单详情
     *
     * @创建：作者:llp 创建时间：2016-3-28
     * @修改历史： [序号](llp 2016 - 3 - 28)<修改说明>
     */
    public int addBforderDetail(SysBforderDetail bforderDetail, String database) {
        try {
            return this.daoTemplate.addByObject("" + database + ".sys_bforder_detail", bforderDetail);
        } catch (Exception e) {
            throw new DaoException(e);
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
            StringBuffer sb = new StringBuffer();
            sb.append("select a.*,b.ware_nm,b.ware_gg, b.hs_num, b.ware_dw as max_unit, b.min_unit, b.max_unit_code, b.min_unit_code from " + database + ".sys_bforder_detail a");
            sb.append(" left join " + database + ".sys_ware b on a.ware_id=b.ware_id");
            sb.append(" where a.order_id=" + orderId);
//            String sql = "select a.*,b.ware_nm,b.ware_gg from " + database + ".sys_bforder_detail a left join " + database + ".sys_ware b on a.ware_id=b.ware_id where a.order_id=" + orderId;
            return this.daoTemplate.queryForLists(sb.toString(), SysBforderDetail.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }


    public List<SysBforderDetail> queryCustomerHisWarePrice(String database, Integer customerId, Integer wareId) {
        try {

            StringBuffer sb = new StringBuffer("select b.ware_id,b.price as ware_dj,b.be_unit,c.hs_num,c.ware_dj as org_price from " + database + ".stk_out a, " + database + ".stk_outsub b," + database + ".sys_ware c ");
            sb.append(" where  a.id = b.mast_id and b.ware_id=c.ware_id  and (a.sale_type='001' or a.sale_type ='')   and  b.xs_tp='正常销售' and (a.status=1 or a.status=0) ")
                    .append(" and b.ware_id=" + wareId + "  and  a.cst_id=" + customerId + "")
                    .append(" ORDER BY  a.id desc  limit 0,1 ");


            return this.daoTemplate.queryForLists(sb.toString(), SysBforderDetail.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }


    /**
     * 说明：删除订单详情
     *
     * @创建：作者:llp 创建时间：2016-3-28
     * @修改历史： [序号](llp 2016 - 3 - 28)<修改说明>
     */
    public void deleteBforderDetail(String database, Integer orderId) {
        String sql = "delete from " + database + ".sys_bforder_detail where order_id=" + orderId;
        try {
            this.daoTemplate.update(sql);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }
    //----------------------------订货下单------------------------------

    /**
     * 说明：分页查询订货下单
     *
     * @创建：作者:llp 创建时间：2016-5-16
     * @修改历史： [序号](llp 2016 - 5 - 16)<修改说明>
     */
    public Page queryDhorder(String database, Map<String, Object> map, Integer page, Integer limit, SysBforder order) {
        Calendar c = Calendar.getInstance();
        String dqtime = new SimpleDateFormat("yyyy-MM-dd").format(new Date());
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
        try {
            StringBuilder sql = new StringBuilder();
            sql.append("select a.id,a.mid,a.order_no,b.kh_nm,c.member_nm,a.order_zt,a.oddate,a.odtime,a.shr,a.tel,a.cjje from " + database + ".sys_bforder a");
            sql.append(" left join " + database + ".sys_customer b on a.cid=b.id left join " + database + ".sys_mem c on a.mid=c.member_id where 1=1 ");
            if (StrUtil.isNull(order.getOrderTp()))
                sql.append(" and (a.order_tp!='客户下单' or a.order_tp is null)");
            else
                sql.append(" and a.order_tp!='" + order.getOrderTp() + "'");
            if (!StrUtil.isNull(order.getMids())) {
                sql.append(" AND a.mid in (" + order.getMids() + ")");
            } else {
                if (!StrUtil.isNull(map.get("allDepts"))) {//要查询的部门和可见部门
                    if (!StrUtil.isNull(map.get("mId"))) {//个人和可见部门结合查询
                        sql.append(" AND (c.branch_id IN (" + map.get("allDepts") + ") ");
                        sql.append(" OR a.mid=" + map.get("mId") + ")");
                    } else {
                        sql.append(" AND c.branch_id IN (" + map.get("allDepts") + ") ");
                    }
                } else if (!StrUtil.isNull(map.get("mId"))) {//个人
                    sql.append(" AND a.mid=" + map.get("mId"));
                }
                if (!StrUtil.isNull(map.get("invisibleDepts"))) {//不可见部门
                    sql.append(" AND c.branch_id NOT IN (" + map.get("invisibleDepts") + ") ");
                }
            }
            if (!StrUtil.isNull(order.getKhNm())) {
                sql.append(" and (b.kh_nm like '%" + order.getKhNm() + "%' or c.member_nm like '%" + order.getKhNm() + "%')");
            }
            if (!StrUtil.isNull(order.getSdate())) {
                sql.append(" and a.oddate >='").append(order.getSdate()).append("'");
            }
            if (!StrUtil.isNull(order.getEdate())) {
                sql.append(" and a.oddate <='").append(order.getEdate()).append("'");
            }
            if (!StrUtil.isNull(order.getCustomerId())) {
                sql.append(" and a.cid=").append(order.getCustomerId());
            }
            if (!StrUtil.isNull(order.getOrderNo())) {
                sql.append(" and a.order_no like '%" + order.getOrderNo() + "%'");
            }
            if (!StrUtil.isNull(order.getOrderZt())) {
                sql.append(" and a.order_zt='" + order.getOrderZt() + "'");
            }

            sql.append(" order by a.id desc");
            return this.daoTemplate.queryForPageByMySql(sql.toString(), page, limit, SysBforder.class);
        } catch (Exception e) {
            throw new DaoException(e);
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
            String sql = "select sum(ware_num) as sumWare from " + database + ".sys_bforder_detail where order_id=" + orderId;
            List<Integer> list = this.daoTemplate.query(sql, new RowMapper<Integer>() {

                @Override
                public Integer mapRow(ResultSet resultSet, int i) throws SQLException {
                    return resultSet.getInt("sumWare");
                }
            });

            return Collections3.isNotEmpty(list) ? list.get(0) : 0;
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    //----------------------------车销单------------------------------

    /**
     * 说明：分页查询车销单
     *
     * @创建：作者:ysg
     * @创建时间：2018-09-21
     * @修改历史：
     */
    public Page queryCarOrder(String database, Map<String, Object> map, Integer page, Integer limit, String kmNm, String sdate, String edate, String mids, String customerId, Integer stkId) {
        try {
            StringBuilder sql = new StringBuilder();
            sql.append("select a.id,a.mid,a.order_no,b.kh_nm,c.member_nm,a.order_zt,a.oddate,a.odtime,a.shr,a.tel,a.cjje ");
            sql.append(" from " + database + ".sys_bforder a ");
            sql.append(" left join " + database + ".sys_customer b on a.cid=b.id ");
            sql.append(" left join " + database + ".sys_mem c on a.mid=c.member_id ");
            sql.append(" where 1=1 and (a.order_tp!='客户下单' or a.order_tp is null) ");
            sql.append(" and a.order_lb='车销单' ");
            if (!StrUtil.isNull(mids)) {
                sql.append(" AND a.mid in (" + mids + ")");
            } else {
                if (!StrUtil.isNull(map.get("allDepts"))) {//要查询的部门和可见部门
                    if (!StrUtil.isNull(map.get("mId"))) {//个人和可见部门结合查询
                        sql.append(" AND (c.branch_id IN (" + map.get("allDepts") + ") ");
                        sql.append(" OR a.mid=" + map.get("mId") + ")");
                    } else {
                        sql.append(" AND c.branch_id IN (" + map.get("allDepts") + ") ");
                    }
                } else if (!StrUtil.isNull(map.get("mId"))) {//个人
                    sql.append(" AND a.mid=" + map.get("mId"));
                }
                if (!StrUtil.isNull(map.get("invisibleDepts"))) {//不可见部门
                    sql.append(" AND c.branch_id NOT IN (" + map.get("invisibleDepts") + ") ");
                }
            }
            if (!StrUtil.isNull(kmNm)) {
                sql.append(" and (b.kh_nm like '%" + kmNm + "%' or c.member_nm like '%" + kmNm + "%')");
            }
            if (!StrUtil.isNull(sdate)) {
                sql.append(" and a.oddate >='").append(sdate).append("'");
            }
            if (!StrUtil.isNull(edate)) {
                sql.append(" and a.oddate <='").append(edate).append("'");
            }

            if (!StrUtil.isNull(stkId) && stkId > 0) {
                sql.append(" and a.stk_id=").append(stkId);
            }

            if (!StrUtil.isNull(customerId)) {
                sql.append(" and a.cid=").append(customerId);
            }
            sql.append(" order by a.id desc");
            return this.daoTemplate.queryForPageByMySql(sql.toString(), page, limit, SysBforder.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public SysStkOut queryByOrderId(String database, Integer orderId) {
        StringBuilder sql = new StringBuilder();
        try {
            sql.append("select a.* from "
                    + database + ".stk_out a  " +
                    "where a.order_id='" + orderId + "' and a.status<>2");
            List<SysStkOut> list = this.daoTemplate.queryForLists(sql.toString(), SysStkOut.class);
            if (list != null && list.size() > 0) {
                return list.get(0);
            }
            return null;
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }


    public int addStkOut(SysStkOut outRec, String database) {
        try {
            outRec.setCreateTime(new Date());
            return this.daoTemplate.addByObject("" + database + ".stk_out", outRec);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public int updateStkout(SysStkOut outRec, String database) {
        try {
            Map<String, Object> whereParam = new HashMap<String, Object>();
            whereParam.put("id", outRec.getId());
            return this.daoTemplate.updateByObject("" + database + ".stk_out", outRec, whereParam, "id");
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public Map<String, Object> getOneStkStorage(String database) {
        String sql = "select ss.* from " + database + ".stk_storage ss where (ss.status is null or ss.status=1) limit 0,1";
        List<Map<String, Object>> list = this.daoTemplate.queryForList(sql);
        if (list != null && list.size() > 0) {
            return list.get(0);
        }
        return null;
    }

    public String newBillNoNew(String database, String bizType, String tabName) throws Exception {
        Date tmpDate = new Date();
        Date tmpDate1 = DateTimeUtil.dateTimeAdd(tmpDate, 5, 1);//增加一天
        String endDate = DateTimeUtil.getDateToStr(tmpDate1, "yyyy-MM-dd");
        String startDate = DateTimeUtil.getDateToStr(tmpDate, "yyyy-MM-dd");
        String prefix = bizType + DateTimeUtil.getDateToStr(tmpDate, "yyyyMMdd");
        String sql = "select max(bill_no) as maxNo from " + database + "." + tabName + " where create_time>='" + startDate + "' and create_time<'" + endDate + "' and bill_no like '" + prefix + "%'";
        List<String> list = this.daoTemplate.query(sql, new Object[]{}, new RowMapper<String>() {
            @Override
            public String mapRow(ResultSet rs, int rowNum) throws SQLException {
                String n = rs.getString("maxNo");
                return n;
            }
        });
        String maxNo = "";
        if (list.size() > 0) maxNo = list.get(0);
        String tmpstr = "";
        if (!StrUtil.isNull(maxNo)) tmpstr = maxNo.substring(prefix.length());
        Integer seqNo = 0;
        if (tmpstr.length() > 0) seqNo = Integer.parseInt(tmpstr);
        seqNo++;
        String billNo = prefix + String.format("%05d", seqNo);
        return billNo;
    }

    public boolean checkIsExist(String billNo, String database) {
        String sql = "select bill_no from " + database + ".stk_out where bill_no='" + billNo + "'";
        List<String> list = this.daoTemplate.query(sql, new Object[]{}, new RowMapper<String>() {
            @Override
            public String mapRow(ResultSet rs, int rowNum) throws SQLException {
                String n = rs.getString("bill_no");
                return n;
            }
        });
        if (list.size() > 0) return true;
        return false;
    }

    public int addOutsub(SysStkOutsub outSub, String database) {
        try {
            return this.daoTemplate.addByObject("" + database + ".stk_outsub", outSub);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public Map<String, Object> getStkStorage(String database) {
        String sql = " select * from " + database + ".stk_storage ";
        try {
            List list = this.daoTemplate.queryForList(sql);

            if (list != null && list.size() > 0) {
                return (Map<String, Object>) list.get(0);
            }
            return null;
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public void deleteOutsub(String database, Integer mastId) {
        String sql = "delete from " + database + ".stk_outsub where mast_id=" + mastId;
        try {
            this.daoTemplate.update(sql);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 0：未创建 1：已创建为发票单
     *
     * @param orderId
     * @param database
     * @return
     */
    public int updateCreate(Integer orderId, String database) {
        String sql = " update " + database + ".sys_bforder set is_create=1 where id=?";
        return this.daoTemplate.update(sql, orderId);
    }
}
