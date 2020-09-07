package com.qweib.cloud.repository;

import com.qweib.cloud.biz.customer.duplicate.DuplicateInvoker;
import com.qweib.cloud.biz.customer.duplicate.dto.CustomerDTO;
import com.qweib.cloud.biz.customer.duplicate.dto.CustomerTypeEnum;
import com.qweib.cloud.biz.customer.duplicate.dto.ResultDTO;
import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.*;
import com.qweib.cloud.core.domain.customer.BaseCustomer;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.utils.*;
import com.qweib.commons.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BatchPreparedStatementSetter;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.math.BigDecimal;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Repository
public class SysCustomerDao {
    @Resource(name = "daoTemplate")
    private JdbcDaoTemplate daoTemplate;
    //    @Resource(name = "pdaoTemplate")
//    private JdbcDaoTemplatePlud daoTemplate1;
    @Autowired
    private DuplicateInvoker duplicateInvoker;

    /**
     * 说明：分页查询客户
     *
     * @创建：作者:llp 创建时间：2016-2-17
     * @修改历史： [序号](llp 2016 - 2 - 17)<修改说明>
     */
    public Page queryCustomer(SysCustomer customer, String dataTp, Integer mId, String allDepts, String invisibleDepts, Integer page, Integer limit) {
        StringBuilder sql = new StringBuilder();
        sql.append("select a.id, a.kh_code, a.kh_nm, a.kh_tp, a.address, a.area,a.bffl_nm, a.bfpc_nm, a.branch_id, a.city, a.ckmj, a.close_date, a.create_time, a.dlqtpl, a.dlqtpp, " +
                "a.ep_Customer_Id, a.ep_Customer_Name, a.erp_code, a.fgqy, a.fman, a.ftel, a.ghtp_nm, a.hzfs_nm, a.id, a.industry_Id, a.industry_nm, a.is_db, a.is_ep, a.is_open," +
                " a.is_yx, a.jxsfl_nm, a.jxsjb_nm, a.jxszt_nm, a.jyfw, a.khlevel_id, a.kh_pid, a.law_address, a.latitude, a.zhfs_nm, a.xsjd_nm, a.wx_code, a.wl_id, a.usc_code," +
                " a.tel, a.sh_zt, a.open_date, a.often_address, a.sh_time, a.scbf_date, a.sh_mid, a.send_address2, a.sctp_nm, a.rz_state, a.rz_mobile, a.remo, a.region_id, a.qq, " +
                "a.qdtype_id, a.py, a.org_emp_id, a.org_emp_nm, a.province, a.linkman, a.mobile, a.mobile_cx, a.longitude, a.mem_id, a.nxse,q.qdtp_nm,k.khdj_nm,b.kh_code as pkhCode,b.kh_nm as pkhNm," +
                "c.member_nm,c.member_mobile,r.store_name as shopName,d.branch_name,e.member_nm as shMemberNm,region.region_nm from " +
                customer.getDatabase() + ".sys_customer a left join " +
                customer.getDatabase() + ".sys_customer b on a.kh_pid=b.id left join " + customer.getDatabase() +
                ".sys_mem c on a.mem_id=c.member_id " +
                "left join " + customer.getDatabase() + ".sys_depart d on a.branch_id=d.branch_id left join " + customer.getDatabase() + ".sys_mem e on a.sh_mid=e.member_id");
        sql.append(" left join " + customer.getDatabase() + ".sys_region region on a.region_id=region.region_id ");
        sql.append(" left join " + customer.getDatabase() + ".sys_qdtype q on a.qdtype_id=q.id");
        sql.append(" left join " + customer.getDatabase() + ".sys_khlevel k on a.khlevel_id=k.id");
        sql.append(" left join " + customer.getDatabase() + ".sys_chain_store r on a.shop_id=r.id");
        if (customer.getCostsSet() != null && customer.getCostsSet().equals(1)) {
            sql.append(" right join ( select DISTINCT (p.customer_id) cid from ").append(customer.getDatabase()).append(".sys_auto_customer_price p where p.price !=0 ) p on p.cid = a.id");
        }
        if (customer.getPriceSet() != null && customer.getPriceSet().equals(1)) {
            sql.append(" right join ( select DISTINCT (j.customer_id) id from ").append(customer.getDatabase()).append(".sys_customer_price j  WHERE j.sale_amt !=0 or j.sunit_price !=0) j on j.id = a.id");
        }
        sql.append(" where 1=1");
        if (!StrUtil.isNull(allDepts)) {//要查询的部门和可见部门
            if (!StrUtil.isNull(dataTp) && "1".equals(dataTp)) {
            } else {
                if (!StrUtil.isNull(mId)) {//个人和可见部门结合查询
                    sql.append(" AND (a.branch_id IN (" + allDepts + ") ");
                    sql.append(" OR a.mem_id=" + mId + ")");
                } else {
                    sql.append(" AND a.branch_id IN (" + allDepts + ") ");
                }
            }
        } else if (!StrUtil.isNull(mId)) {//个人
            sql.append(" AND a.mem_id=" + mId);
        }
        if (!StrUtil.isNull(invisibleDepts)) {//不可见部门
            sql.append(" AND a.branch_id NOT IN (" + invisibleDepts + ") ");
        }
        if (null != customer) {
            if (!StrUtil.isNull(customer.getKhNm())) {
                sql.append(" and a.kh_nm like '%" + customer.getKhNm() + "%' ");
            }
            if (!StrUtil.isNull(customer.getMemberNm())) {
                sql.append(" and c.member_nm like '%" + customer.getMemberNm() + "%' ");
            }
            if (!StrUtil.isNull(customer.getKhTp())) {
                sql.append(" and a.kh_tp=" + customer.getKhTp() + " ");
            }
            if (!StrUtil.isNull(customer.getMemberIds())) {
                sql.append(" and a.mem_id in(" + customer.getMemberIds() + ") ");
            }
            if (!StrUtil.isNull(customer.getIsDb())) {
                if (!customer.getIsDb().equals(0)) {
                    sql.append(" and a.is_db=" + customer.getIsDb() + " ");
                }
            }
            if (!StrUtil.isNull(customer.getQdtpNm())) {
                sql.append(" and q.qdtp_nm='" + customer.getQdtpNm() + "' ");
            }
            if (!StrUtil.isNull(customer.getKhdjNm())) {
                sql.append(" and k.khdj_nm='" + customer.getKhdjNm() + "' ");
            }
            if (!StrUtil.isNull(customer.getIsEp())) {
                sql.append(" and a.is_ep ='").append(customer.getIsEp()).append("'");
            }
            if (!StrUtil.isNull(customer.getHzfsNm())) {
                sql.append(" and a.hzfs_nm='" + customer.getHzfsNm() + "'");
            }
//            if (!StrUtil.isNull(customer.getRegionNm())) {
//                sql.append(" and region.region_nm like '%" + customer.getRegionNm() + "%'");
//            }
            if (!StrUtil.isNull(customer.getRegionId())) {
                sql.append(" and (region.region_id = " + customer.getRegionId() + " or region.region_pid = " + customer.getRegionId() + ")");
            }
            if (customer.getNullStaff() != null) {
                if (customer.getNullStaff().intValue() > 0) {
                    sql.append(" and ( a.mem_id IS NULL or a.mem_id = 0 or a.mem_id not in(select member_id from " + customer.getDatabase() + ".sys_mem))");
                }
            }
            if (customer.getCostsSet() != null && customer.getCostsSet().equals(2)) {
                sql.append(" and a.id not in ( select DISTINCT (p.customer_id) cid from ").append(customer.getDatabase()).append(".sys_auto_customer_price p where p.price <> 0 and p.customer_id is not null )");

            }
            if (customer.getPriceSet() != null && customer.getPriceSet().equals(2)) {
                sql.append(" and a.id not in ( select DISTINCT (j.customer_id) id from ").append(customer.getDatabase()).append(".sys_customer_price j WHERE j.sale_amt <> 0 or j.sunit_price <> 0 )");

            }
            if (!StrUtil.isNull(customer.getLatitude())) {
                if (customer.getLatitude().equals("1")) {
                    sql.append(" and (a.latitude is null or a.latitude ='0' or a.latitude = '')");
                }
            }
            if(!StrUtil.isNull(customer.getSdate()))sql.append(" and a.create_time>'" + customer.getSdate() + "'");
            if(!StrUtil.isNull(customer.getEdate()))sql.append(" and a.create_time<'" + customer.getEdate() + "'");
        }
        sql.append(" order by a.id desc");
        try {
            return this.daoTemplate.queryForPageByMySql(sql.toString(), page, limit, SysCustomer.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public Page customerGradePage(SysCustomer customer, int page, int rows, String database, String qdtpNm, String khdjNm, Integer type) {
        StringBuilder sql = new StringBuilder();
        sql.append("select * from " + database + ".sys_customer  where 1=1 and is_db=2 ");
        try {
            if (null != customer) {
                if (!StrUtil.isNull(customer.getKhNm())) {
                    sql.append(" and kh_nm like '%").append(customer.getKhNm()).append("%'");
                }
            }
            if (type != null && type == 1) {
                sql.append(" and qdtp_nm = '" + qdtpNm + "'");
                /*   sql.append("and khdj_nm <> '" + khdjNm + "'");*/
                sql.append(" and (khdj_nm is null or khdj_nm = '' or khdj_nm = 'null')");
            } else {
                sql.append(" and qdtp_nm= '" + qdtpNm + "'");
                sql.append(" and khdj_nm= '" + khdjNm + "'");
            }
            return this.daoTemplate.queryForPageByMySql(sql.toString(), page, rows, SysCustomer.class);
        } catch (Exception var9) {
            throw new DaoException(var9);

        }
    }

    public Page queryNoneGradeCustomer(SysCustomer sysCustomer, int page, int rows, int qdId, String database) {
        StringBuilder sql = new StringBuilder();
        sql.append("select * from " + database + ".sys_customer  where 1=1 and is_db=2 ");
        sql.append(" and qdtype_id =" + qdId);
        sql.append(" and khlevel_id is null");
        try {
            if (null != sysCustomer) {
                if (!StrUtil.isNull(sysCustomer.getKhNm())) {
                    sql.append(" and kh_nm like '%").append(sysCustomer.getKhNm()).append("%'");
                }
            }
            return this.daoTemplate.queryForPageByMySql(sql.toString(), page, rows, SysCustomer.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public Page queryCustomerByKhlevelId(SysCustomer sysCustomer, int page, int rows, int id, int qdId, String database) {
        StringBuilder sql = new StringBuilder();
        sql.append("select * from " + database + ".sys_customer  where 1=1 and is_db=2 ");
        sql.append(" and khlevel_id=" + id);
        sql.append(" and qdtype_id=" + qdId);
        try {
            if (null != sysCustomer) {
                if (!StrUtil.isNull(sysCustomer.getKhNm())) {
                    sql.append(" and kh_nm like '%").append(sysCustomer.getKhNm()).append("%'");
                }
            }
            return this.daoTemplate.queryForPageByMySql(sql.toString(), page, rows, SysCustomer.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public Page queryNoneTypedCustomer(SysCustomer sysCustomer, int page, int rows, String database) {
        StringBuilder sql = new StringBuilder();
        sql.append("select * from " + database + ".sys_customer  where 1=1 and is_db=2 ");
        sql.append(" and qdtype_id is null");
        try {
            if (null != sysCustomer) {
                if (!StrUtil.isNull(sysCustomer.getKhNm())) {
                    sql.append(" and kh_nm like '%").append(sysCustomer.getKhNm()).append("%'");
                }
            }
            return this.daoTemplate.queryForPageByMySql(sql.toString(), page, rows, SysCustomer.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public Page queryCustomerByQdtypeId(SysCustomer sysCustomer, int page, int rows, int id, String database) {
        StringBuilder sql = new StringBuilder();
        sql.append("select * from " + database + ".sys_customer  where 1=1 and is_db=2 ");
        sql.append(" and qdtype_id =" + id);
        try {
            if (null != sysCustomer) {
                if (!StrUtil.isNull(sysCustomer.getKhNm())) {
                    sql.append(" and kh_nm like '%").append(sysCustomer.getKhNm()).append("%'");
                }
            }
            return this.daoTemplate.queryForPageByMySql(sql.toString(), page, rows, SysCustomer.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public Page page2(SysCustomer customer, int page, int rows, String database, String qdtpNm, Integer type, Integer[] regionId) {
        StringBuilder sql = new StringBuilder();
        sql.append("select * from " + database + ".sys_customer  where 1=1 and is_db=2 ");
        try {
            if (null != customer) {
                if (!StrUtil.isNull(customer.getKhNm())) {
                    sql.append(" and kh_nm like '%").append(customer.getKhNm()).append("%'");
                }
            }

            if (type != null && type == 1) {
                if (qdtpNm != null) {
                    sql.append(" and (qdtp_nm is null or qdtp_nm = '' or qdtp_nm = 'null')");
                }
                if (regionId != null && regionId.length == 1 && regionId[0].equals(0)) {
                    sql.append(" and region_id is null");
                }

            } else {
                if (qdtpNm != null) {
                    sql.append(" and qdtp_nm= '" + qdtpNm + "'");
                }
                if (regionId != null && regionId.length > 0) {
                    if (regionId.length == 1 && !regionId[0].equals(0)) {
                        sql.append(" and region_id= " + regionId[0]);
                    } else {
                        sql.append(" and region_id in (" + StringUtils.join(regionId, ",") + ")");
                    }

                }
            }
            return this.daoTemplate.queryForPageByMySql(sql.toString(), page, rows, SysCustomer.class);
        } catch (Exception var9) {
            throw new DaoException(var9);

        }
    }

    public int queryQdtypeId(Integer id, String database) {
        String sql = "select count(1) from " + database + ".sys_customer where qdtype_id=? and is_db=2 ";
        try {
            return this.daoTemplate.queryForObject(sql, new Object[]{id}, Integer.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }

    }

    public int queryKhleveId(Integer id, String database) {
        String sql = "select count(1) from " + database + ".sys_customer where khlevel_id=? and is_db=2 ";
        try {
            return this.daoTemplate.queryForObject(sql, new Object[]{id}, Integer.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }

    }

    public int queryShopId(Integer id, String database) {
        String sql = "select count(1) from " + database + ".sys_customer where shop_id=? and is_db=2 ";
        try {
            return this.daoTemplate.queryForObject(sql, new Object[]{id}, Integer.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }

    }

    public List<SysCustomer> queryCustomerList(SysCustomer customer, Integer mId, String allDepts, String invisibleDepts, String database) {
        StringBuilder sql = new StringBuilder();
        sql.append("select a.*,b.kh_code as pkhCode,b.kh_nm as pkhNm,c.member_nm,c.member_mobile,d.branch_name,e.member_nm as shMemberNm from " +
                database + ".sys_customer a left join " +
                database + ".sys_customer b on a.kh_pid=b.id left join " + database +
                ".sys_mem c on a.mem_id=c.member_id " +
                "left join " + database + ".sys_depart d on a.branch_id=d.branch_id left join " + database + ".sys_mem e on a.sh_mid=e.member_id where 1=1");
//		if (!StrUtil.isNull(allDepts)) {//要查询的部门和可见部门
//			if (!StrUtil.isNull(mId)) {//个人和可见部门结合查询
//				sql.append(" AND (a.branch_id IN ("+allDepts+") ");
//				sql.append(" OR a.mem_id="+mId+")");
//			} else {
//				sql.append(" AND a.branch_id IN ("+allDepts+") ");
//			}
//		}else if (!StrUtil.isNull(mId)) {//个人
//			sql.append(" AND a.mem_id="+mId);
//		}
//		if (!StrUtil.isNull(invisibleDepts)) {//不可见部门
//			sql.append(" AND a.branch_id NOT IN ("+invisibleDepts+") ");
//		}
        if (null != customer) {
            if (!StrUtil.isNull(customer.getKhNm())) {
                sql.append(" and a.kh_nm like '%" + customer.getKhNm() + "%' ");
            }
            if (!StrUtil.isNull(customer.getMemberNm())) {
                sql.append(" and c.member_nm like '%" + customer.getMemberNm() + "%' ");
            }
            if (!StrUtil.isNull(customer.getKhTp())) {
                sql.append(" and a.kh_tp=" + customer.getKhTp() + " ");
            }
            if (!StrUtil.isNull(customer.getMemberIds())) {
                sql.append(" and a.mem_id in(" + customer.getMemberIds() + ") ");
            }
            if (!StrUtil.isNull(customer.getIsDb())) {
                if (!customer.getIsDb().equals(0)) {
                    sql.append(" and a.is_db=" + customer.getIsDb() + " ");
                }
            }
            if (!StrUtil.isNull(customer.getQdtpNm())) {
                sql.append(" and a.qdtp_nm='" + customer.getQdtpNm() + "' ");
            }
            if (!StrUtil.isNull(customer.getKhdjNm())) {
                sql.append(" and a.khdj_nm='" + customer.getKhdjNm() + "' ");
            }
        }
        sql.append(" order by a.id desc");
        try {
            return this.daoTemplate.queryForLists(sql.toString(), SysCustomer.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public List<SysCustomer> queryCustomerList(SysCustomer customer, String database) {
        StringBuilder sql = new StringBuilder();
        sql.append("select a.id,a.kh_code,a.kh_nm,a.mobile as tel,a.address,a.mem_id,a.qdtp_nm,a.khdj_nm from " +
                database + ".sys_customer a  " +
                " where 1=1 ");
        if (null != customer) {
            if (!StrUtil.isNull(customer.getIsDb())) {
                if (!customer.getIsDb().equals(0)) {
                    sql.append(" and a.is_db=" + customer.getIsDb() + " ");
                }
            }
        }
        sql.append(" order by a.id desc");
        try {
            return this.daoTemplate.queryForLists(sql.toString(), SysCustomer.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }


    /**
     * 说明：获取客户
     *
     * @创建：作者:llp 创建时间：2016-2-17
     * @修改历史： [序号](llp 2016 - 2 - 17)<修改说明>
     */
    public SysCustomer queryCustomerById(String database, Integer Id) {
        try {
            String sql = "select a.*,b.kh_nm as pkhNm,c.member_nm,d.branch_name,region.region_id,region.region_nm from " + database + ".sys_customer a left join " + database + ".sys_customer b on a.kh_pid=b.id left join " + database + ".sys_mem c on a.mem_id=c.member_id " +
                    "left join " + database + ".sys_depart d on a.branch_id=d.branch_id left join " + database + ".sys_region region on region.region_id=a.region_id where a.id=? ";
            return this.daoTemplate.queryForObj(sql, SysCustomer.class, Id);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public int queryRegionById(Integer id, String database) {
        String sql = "select count(1) from " + database + ".sys_customer where region_id=? and is_db=2 ";
        try {
            return this.daoTemplate.queryForObject(sql, new Object[]{id}, Integer.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }

    }

    public SysCustomer querySysCustomerById(Integer Id, String database) {
        try {
            String sql = "select * from " + database + ".sys_customer where id=?";
            return this.daoTemplate.queryForObj(sql, SysCustomer.class, Id);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：添加客户
     *
     * @创建：作者:llp 创建时间：2016-2-17
     * @修改历史： [序号](llp 2016 - 2 - 17)<修改说明>
     */
    public int addCustomer(SysCustomer customer, String database) {
        try {
            customer.setOpenDate(new SimpleDateFormat("yyyy-MM-dd").format(new Date()));
            customer.setCreateTime(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()));
            //经纬度
            if (StringUtils.isEmpty(customer.getLatitude()))
                customer.setLatitude("0");
            if (StringUtils.isEmpty(customer.getLongitude()))
                customer.setLongitude("0");
            //是否倒闭（1是；2否）
            if (customer.getIsDb() == null)
                customer.setIsDb(2);
            //客户种类（1经销商；2客户）
            if (customer.getKhTp() == null)
                customer.setKhTp(2);
            //是否有效(1有效；其他无效)
            if (StringUtils.isEmpty(customer.getIsYx()))
                customer.setIsYx("1");
            //是否开户(1是；其他否)
            if (StringUtils.isEmpty(customer.getIsOpen()))
                customer.setIsOpen("1");
            if (!StrUtil.isNull(customer.getLatitude())) {
                if (customer.getLatitude().equals("0")) {
                    customer.setLatitude("");
                    customer.setLongitude("");
                }
            }

            ResultDTO resultDTO = this.duplicateInvoker.invoke(database, new CustomerDTO(CustomerTypeEnum.SysCustomer, customer.getKhNm()));
            if (resultDTO.isFound()) {
                customer.setKhNm(resultDTO.getSuggestName());
            }
            return this.daoTemplate.addByObject("" + database + ".sys_customer", customer);
        } catch (Exception ex) {
            throw new DaoException(ex);
        }
    }

    /**
     * 说明：修改客户
     *
     * @创建：作者:llp 创建时间：2016-2-17
     * @修改历史： [序号](llp 2016 - 2 - 17)<修改说明>
     */
    public int updateCustomer(SysCustomer customer, String database) {
        try {
            ResultDTO resultDTO = this.duplicateInvoker.invoke(database, new CustomerDTO(customer.getId(), CustomerTypeEnum.SysCustomer, customer.getKhNm()));
            if (resultDTO.isFound()) {
                customer.setKhNm(resultDTO.getSuggestName());
            }
            Map<String, Object> map = new HashMap<String, Object>();
            map.put("id", customer.getId());
//            if (!StrUtil.isNull(customer.getDatasource())) {
//                return this.daoTemplate1.updateByObject("" + customer.getDatasource() + ".sys_mem", customer, map, "id");
//            }
            return this.daoTemplate.updateByObject("" + database + ".sys_customer", customer, map, "id");
        } catch (Exception ex) {
            throw new DaoException(ex);
        }
    }

    /**
     * 说明：删除客户
     *
     * @创建：作者:llp 创建时间：2016-2-17
     * @修改历史： [序号](llp 2016 - 2 - 17)<修改说明>
     */
    public int[] deleteCustomer(final Integer[] ids, String database) {
        try {
            String sql = "update " + database + ".sys_customer set is_db=3 where id=?";
            BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter() {
                @Override
                public int getBatchSize() {
                    return ids.length;
                }

                @Override
                public void setValues(PreparedStatement pre, int num)
                        throws SQLException {
                    pre.setInt(1, ids[num]);
                }
            };
            return this.daoTemplate.batchUpdate(sql, setter);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：自增id
     *
     * @创建：作者:llp 创建时间：2016-2-17
     * @修改历史： [序号](llp 2016 - 2 - 17)<修改说明>
     */
    public Integer getAutoId() {
        try {
            return this.daoTemplate.getAutoIdForIntByMySql();
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：修改编码
     *
     * @创建：作者:llp 创建时间：2016-2-17
     * @修改历史： [序号](llp 2016 - 2 - 17)<修改说明>
     */
    public void updatekhCode(String database, String khCode, Integer id) {
        String sql = "update " + database + ".sys_customer set kh_code='" + khCode + "' where id=" + id;
        try {
            this.daoTemplate.update(sql);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：修改客户种类
     *
     * @创建：作者:llp 创建时间：2016-2-17
     * @修改历史： [序号](llp 2016 - 2 - 17)<修改说明>
     */
    public void updatekhTp(String database, Integer khTp, Integer id) {
        String sql = "update " + database + ".sys_customer set kh_tp=" + khTp + " where id=" + id;
        try {
            this.daoTemplate.update(sql);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：判断客户编码是否存在
     *
     * @创建：作者:llp 创建时间：2016-2-17
     * @修改历史： [序号](llp 2016 - 2 - 17)<修改说明>
     */
    public int queryIskhCode(String database, String khCode) {
        String sql = "select count(1) from " + database + ".sys_customer where kh_code='" + khCode + "'";
        try {
            return this.daoTemplate.queryForObject(sql, Integer.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：审核操作
     *
     * @创建：作者:llp 创建时间：2016-2-19
     * @修改历史： [序号](llp 2016 - 2 - 18)<修改说明>
     */
    public void updateShZt(String database, String shZt, Integer shMid, String shTime, Integer id) {
        String sql = "update " + database + ".sys_customer set sh_zt='" + shZt + "',sh_mid=" + shMid + ",sh_time='" + shTime + "' where id=" + id;
        try {
            this.daoTemplate.update(sql);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：判断客户名称是否存在
     *
     * @创建：作者:llp 创建时间：2016-3-1
     * @修改历史： [序号](llp 2016 - 3 - 1)<修改说明>
     */
    public int queryIskhNm(String database, String khNm, String city) {
        StringBuilder sql = new StringBuilder("select count(1) from " + database + ".sys_customer where kh_nm='" + khNm + "'");
        if (!StrUtil.isNull(city)) {
            sql.append(" and city='" + city + "'");
        }
        try {
            return this.daoTemplate.queryForObject(sql.toString(), Integer.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：获取所有客户分布图
     *
     * @创建：作者:llp 创建时间：2016-4-5
     * @修改历史： [序号](llp 2016 - 4 - 5)<修改说明>
     */
    public List<SysCustomer> querycustomerMap(String database, String khNm, String memberNm, Integer mId, String allDepts, String invisibleDepts) {
        StringBuilder sql = new StringBuilder();
        sql.append("select a.kh_nm,a.linkman,a.tel,a.mobile,a.province,a.city,a.area,a.address,a.longitude,a.latitude,a.remo,b.member_nm,c.branch_name,(select qddate from " + database + ".sys_bfqdpz where cid=a.id and qddate!='" + new SimpleDateFormat("yyyy-MM-dd").format(new Date()) + "' order by id desc limit 0,1) as scbfDate " +
                "from " + database + ".sys_customer a left join " + database + ".sys_mem b on a.mem_id=b.member_id left join " + database + ".sys_depart c on a.branch_id=c.branch_id where a.kh_tp=2 and a.is_db=2");
        if (!StrUtil.isNull(allDepts)) {//要查询的部门和可见部门
            if (!StrUtil.isNull(mId)) {//个人和可见部门结合查询
                sql.append(" AND (a.branch_id IN (" + allDepts + ") ");
                sql.append(" OR a.mem_id=" + mId + ")");
            } else {
                sql.append(" AND a.branch_id IN (" + allDepts + ") ");
            }
        } else if (!StrUtil.isNull(mId)) {//个人
            sql.append(" AND a.mem_id=" + mId);
        }
        if (!StrUtil.isNull(invisibleDepts)) {//不可见部门
            sql.append(" AND a.branch_id NOT IN (" + invisibleDepts + ") ");
        }
        //////////////////////////////////////
        if (!StrUtil.isNull(khNm)) {
            sql.append(" and a.kh_nm like '%" + khNm + "%'");
        }
        if (!StrUtil.isNull(memberNm)) {
            sql.append(" and b.member_nm like '%" + memberNm + "%'");
        }
//		if(!StrUtil.isNull(memberIds)){
//			sql.append(" and a.mem_id in("+memberIds+") ");
//		}
        sql.append(" order by a.id desc");
        try {
            return this.daoTemplate.queryForLists(sql.toString(), SysCustomer.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：获取所有客户分布图Web
     *
     * @创建：作者:llp 创建时间：2016-7-22
     * @修改历史： [序号](llp 2016 - 7 - 22)<修改说明>
     */
    public List<SysCustomer> querycustomerWebMap(String database, String memIds) {
        StringBuilder sql = new StringBuilder();
        sql.append("select a.kh_nm,a.linkman,a.tel,a.mobile,a.province,a.city,a.area,a.address,a.longitude,a.latitude,a.remo,b.member_nm,c.branch_name,(select qddate from " + database + ".sys_bfqdpz where cid=a.id and qddate!='" + new SimpleDateFormat("yyyy-MM-dd").format(new Date()) + "' order by id desc limit 0,1) as scbfDate " +
                "from " + database + ".sys_customer a left join " + database + ".sys_mem b on a.mem_id=b.member_id left join " + database + ".sys_depart c on a.branch_id=c.branch_id where a.kh_tp=2 and a.is_db=2");
        if (!StrUtil.isNull(memIds)) {
            sql.append(" and a.mem_id in (" + memIds + ")");
        }
        sql.append(" order by a.id desc");
        try {
            return this.daoTemplate.queryForLists(sql.toString(), SysCustomer.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：修改客户是否倒闭
     *
     * @创建：作者:llp 创建时间：2016-7-20
     * @修改历史： [序号](llp 2016 - 7 - 20)<修改说明>
     */
    public void updatekhIsdb(String database, Integer isDb, Integer id) {
        String sql = "update " + database + ".sys_customer set is_db=" + isDb + " where id=" + id;
        try {
            this.daoTemplate.update(sql);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：根据手机号码获取成员条数
     *
     * @创建：作者:llp 创建时间：2015-2-3
     * @修改历史： [序号](llp 2015 - 2 - 3)<修改说明>
     */
    public int querySysCustomerByTel(String database, String name) {
        String sql = " select count(1) from " + database + ".sys_customer where kh_nm=? ";
        try {
            return this.daoTemplate.queryForObject(sql, new Object[]{name}, Integer.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public SysCustomer querySysCustomerByMobile(String database, String mobile) {
        String sql = "select * from " + database + ".sys_customer where mobile=? ";
        return this.daoTemplate.queryForObj(sql, SysCustomer.class, mobile);
        /*String sql = " select * from " + database + ".sys_customer where tel like '%" + mobile + "%' or mobile like '%" + mobile + "%' ";
        try {
            List<SysCustomer> list = this.daoTemplate.queryForLists(sql.toString(), SysCustomer.class);
            if (list != null && list.size() > 0) {
                return list.get(0);
            }
            return null;
        } catch (Exception e) {
            throw new DaoException(e);
        }*/
    }

    public SysCustomer querySysCustomerByName(String database, String name) {
        String sql = " select * from " + database + ".sys_customer where kh_nm='" + name + "' ";
        try {
            List<SysCustomer> list = this.daoTemplate.queryForLists(sql, SysCustomer.class);
            if (list == null || list.size() == 0) {
                return null;
            } else {
                return list.get(0);
            }
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：添加客户(excel导入)
     *
     * @创建：作者:llp 创建时间：2015-2-6
     * @修改历史： [序号](llp 2015 - 2 - 6)<修改说明>
     */
    @Deprecated
    public void addSysCustomerls(String database, List<SysCustomer> customerls) {
        try {
            for (int i = 0; i < customerls.size(); i++) {
                SysCustomer customer = customerls.get(i);
                if (customer.getId() != null) {
                    updateCustomer(customer, database);
                    continue;
                }
                customer.setKhTp(2);
                customer.setIsYx("1");
                customer.setIsOpen("1");
                customer.setIsDb(2);
                customer.setKhCode("" + "x" + "" + daoTemplate.getAutoIdForIntByMySql() + "");
                customer.setPy(ChineseCharToEnUtil.getFirstSpell(customer.getKhNm()));//PinyinConv.cn2py(Customer.getKhNm()));
                /*****用于更改id生成方式 by guojr******/
                int id = this.daoTemplate.addByObject("" + database + ".sys_customer", customer);

            }
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：转让业代
     *
     * @创建：作者:llp 创建时间：2016-10-11
     * @修改历史： [序号](llp 2016 - 10 - 11)<修改说明>
     */
    public void updateZryd(String database, Integer Mid, Integer branchId, Integer id) {
        String sql = "update " + database + ".sys_customer set mem_id=" + Mid + ",branch_id=" + branchId + " where id=" + id;
        try {
            this.daoTemplate.update(sql);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public int updateSysCustomerWarePrice(String database, SysCustomerWarePrice model) {
        int i = 0;
        try {
            if (model != null) {
                if (StrUtil.isNull(model.getId())) {
                    i = this.daoTemplate.addByObject("" + database + ".sys_customer_ware_price", model);
                } else {
                    String sql = "update " + database + ".sys_customer_ware_price set tran_amt=" + model.getTranAmt() + " where id=" + model.getId();
                    i = this.daoTemplate.update(sql);
                }
            }
            return i;
        } catch (Exception e) {
            e.printStackTrace();
            throw new DaoException(e);
        }
    }

    public List<SysCustomerWarePrice> listSysCustomerWarePrice(String database, Integer customerId) {

        StringBuilder sql = new StringBuilder();
        sql.append("select * from " + database + ".sys_customer_ware_price where customer_id=").append(customerId);
        try {
            return this.daoTemplate.queryForLists(sql.toString(), SysCustomerWarePrice.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }

    }

    public void updateAllPy(String database) {
        String sql = "select * from " + database + ".sys_customer ";
        List<SysCustomer> list = this.daoTemplate.queryForLists(sql, SysCustomer.class);
        for (SysCustomer bo : list) {
            bo.setPy(ChineseCharToEnUtil.getFirstSpell(bo.getKhNm()));
            String sql1 = "update " + database + ".sys_customer set py='" + bo.getPy() + "' where id=" + bo.getId();
            this.daoTemplate.update(sql1);
        }
    }

    public int updateSysCustomerSalePrice(String database, SysCustomerSalePrice model) {
        int i = 0;
        try {
            if (model != null) {
                if (StrUtil.isNull(model.getId())) {
                    i = this.daoTemplate.addByObject("" + database + ".sys_customer_sale_price", model);
                } else {
                    String sql = "update " + database + ".sys_customer_sale_price set tc_amt=" + model.getTcAmt() + " where id=" + model.getId();
                    i = this.daoTemplate.update(sql);
                }
            }
            return i;
        } catch (Exception e) {
            e.printStackTrace();
            throw new DaoException(e);
        }
    }

    public List<SysCustomerSalePrice> listSysCustomerSalePrice(String database, Integer customerId) {

        StringBuilder sql = new StringBuilder();
        sql.append("select * from " + database + ".sys_customer_sale_price where customer_id=").append(customerId);
        try {
            return this.daoTemplate.queryForLists(sql.toString(), SysCustomerSalePrice.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }

    }


    public int updateSysCustomerPrice(String database, SysCustomerPrice model) {
        int i = 0;
        try {
            if (model != null) {
                if (StrUtil.isNull(model.getId())) {
                    i = this.daoTemplate.addByObject("" + database + ".sys_customer_price", model);
                } else {
                    Map<String, Object> whereParam = new HashMap<String, Object>();
                    whereParam.put("id", model.getId());
                    return this.daoTemplate.updateByObject("" + database + ".sys_customer_price", model, whereParam, null);
                }
            }
            return i;
        } catch (Exception e) {
            e.printStackTrace();
            throw new DaoException(e);
        }
    }

    public List<SysCustomerPrice> listSysCustomerPrice(String database, Integer customerId, String wareIds) {
        StringBuilder sql = new StringBuilder();
        sql.append("select * from " + database + ".sys_customer_price where customer_id=").append(customerId);

        if (!StrUtil.isNull(wareIds)) {
            sql.append(" and ware_id in (").append(wareIds).append(")");
        }
        try {
            return this.daoTemplate.queryForLists(sql.toString(), SysCustomerPrice.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }

    }


    public Page queryCustomerPriceWarePage(SysWare ware, Integer customerId, int page, int rows, String database) {
        StringBuffer sql = new StringBuffer(" select a.*,b.waretype_nm,b.waretype_path from " + database + ".sys_ware a");
        sql.append(" left join " + database + ".sys_waretype b on a.waretype=b.waretype_id ");
        sql.append(" left join " + database + ".sys_customer_price c on c.ware_id=a.ware_id ");
        sql.append("  where 1=1 ");
        sql.append(" and ").append(WareSqlUtil.getWareWhere("a"));
        sql.append(" and ").append(WareSqlUtil.getCompanyWareTypeAppendSql("b"));
        sql.append(" and c.customer_id=").append(customerId);
        if (null != ware) {
            if (!StrUtil.isNull(ware.getWareNm())) {
                if (isContainChinese(ware.getWareNm())) {
                    ware.setWareNm(ware.getWareNm().replaceAll(" ", ""));
                    for (int i = 0; i < ware.getWareNm().length(); i++) {
                        sql.append(" and a.ware_nm like '%" + ware.getWareNm().substring(i, i + 1) + "%'");
                    }
                } else {
                    sql.append(" and (a.ware_nm like '%" + ware.getWareNm() + "%' or a.ware_code like '%" + ware.getWareNm() + "%' or a.be_bar_code like '%" + ware.getWareNm() + "%' or a.pack_bar_code like '%" + ware.getWareNm() + "%' or a.py like '%" + ware.getWareNm() + "%')");
                }
            }
            if (!StrUtil.isNull(ware.getStatus())) {
                sql.append(" and a.status=").append(ware.getStatus());
            }
            if (!StrUtil.isNull(ware.getBeBarCode())) {
                sql.append(" and a.be_bar_code like concat('%', \'").append(ware.getBeBarCode()).append("\' ,'%')");
            }
            if (!StrUtil.isNull(ware.getPackBarCode())) {
                sql.append(" and a.pack_bar_code like concat('%', \'").append(ware.getPackBarCode()).append("\' ,'%')");
            }
            if (!StrUtil.isNull(ware.getIsType())) {
                sql.append(" and b.is_type=").append(ware.getIsType());
            }
        }
        if (null != ware.getWaretype() && ware.getWaretype() != 0) {
            sql.append(" and instr(b.waretype_path,'-").append(ware.getWaretype()).append("-')>0");
        }
        sql.append(" order by a.ware_id asc ");
        try {
            return this.daoTemplate.queryForPageByMySql(sql.toString(), page, rows, SysWare.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }


    /**
     * 同步客户Ids清空当前客户对应的客户商品价格
     *
     * @param database
     * @param customerIds
     */
    public void deleteCustomerPriceByIds(String database, String customerIds) {
        String sql = "delete from " + database + ".sys_customer_price where 1=1 ";
        if (!StrUtil.isNull(customerIds)) {
            sql = sql + " and customer_id in(" + customerIds + ")";
        }
        this.daoTemplate.update(sql);

    }

    public List<SysCustomerPrice> groupSysCustomerPriceByWareId(String database, Integer wareId) {
        StringBuilder sql = new StringBuilder();
        StringBuilder sql1 = new StringBuilder();
        sql1.append(" select a.ware_id,ifnull(a.sale_amt,0) as sale_amt,ifnull(a.ls_Price,0) as ls_Price,ifnull(a.fx_Price,0) as fx_Price,ifnull(a.cx_Price,0) as cx_Price,ifnull(a.sunit_Price,0) as sunit_Price,ifnull(a.min_Ls_Price,0) as min_Ls_Price,ifnull(a.min_Fx_Price,0) as min_Fx_Price,ifnull(a.min_Cx_Price,0) as min_Cx_Price from " + database + ".sys_customer_price a where ware_id=").append(wareId);
        sql1.append(" group by a.ware_id,ifnull(a.sale_amt,0),ifnull(a.ls_Price,0),ifnull(a.fx_Price,0),ifnull(a.cx_Price,0),ifnull(a.sunit_Price,0),ifnull(a.min_Ls_Price,0),ifnull(a.min_Fx_Price,0),ifnull(a.min_Cx_Price,0)  ");

        StringBuilder sql2 = new StringBuilder();
        sql2.append(" select a.ware_id,ifnull(a.price,0) as sale_amt,ifnull(a.ls_Price,0) as ls_Price,ifnull(a.fx_Price,0) as fx_Price,ifnull(a.cx_Price,0) as cx_Price,ifnull(a.sunit_Price,0) as sunit_Price,ifnull(a.min_Ls_Price,0) as min_Ls_Price,ifnull(a.min_Fx_Price,0) as min_Fx_Price,ifnull(a.min_Cx_Price,0) as min_Cx_Price from " + database + ".sys_customer_level_price a where ware_id=").append(wareId);
        sql2.append(" group by a.ware_id,ifnull(a.price,0),ifnull(a.ls_Price,0),ifnull(a.fx_Price,0),ifnull(a.cx_Price,0),ifnull(a.sunit_Price,0),ifnull(a.min_Ls_Price,0),ifnull(a.min_Fx_Price,0),ifnull(a.min_Cx_Price,0)  ");

        StringBuilder sql3 = new StringBuilder();
        sql3.append(" select a.ware_id,ifnull(a.price,0) as sale_amt,ifnull(a.ls_Price,0) as ls_Price,ifnull(a.fx_Price,0) as fx_Price,ifnull(a.cx_Price,0) as cx_Price,ifnull(a.sunit_Price,0) as sunit_Price,ifnull(a.min_Ls_Price,0) as min_Ls_Price,ifnull(a.min_Fx_Price,0) as min_Fx_Price,ifnull(a.min_Cx_Price,0) as min_Cx_Price from " + database + ".sys_qd_type_price a where ware_id=").append(wareId);
        sql3.append(" group by a.ware_id,ifnull(a.price,0),ifnull(a.ls_Price,0),ifnull(a.fx_Price,0),ifnull(a.cx_Price,0),ifnull(a.sunit_Price,0),ifnull(a.min_Ls_Price,0),ifnull(a.min_Fx_Price,0),ifnull(a.min_Cx_Price,0)  ");
        sql.append(" select v.ware_id,ifnull(v.sale_amt,0) as sale_amt,ifnull(v.ls_price,0) as ls_price ,v.fx_price,v.cx_price,v.sunit_Price,v.min_Ls_Price,v.min_Fx_Price,v.min_Cx_Price from (");
        sql.append(sql1.toString());
        sql.append(" union all ");
        sql.append(sql2.toString());
        sql.append(" union all ");
        sql.append(sql3.toString());
        sql.append(" ) v ");
        sql.append(" group by v.ware_id,v.sale_amt,v.ls_price,v.fx_price,v.cx_price,v.sunit_Price,v.min_Ls_Price,v.min_Fx_Price,v.min_Cx_Price ");
        try {
            return this.daoTemplate.queryForLists(sql.toString(), SysCustomerPrice.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public List<SysCustomerPrice> listSysCustomerPrice(String database, SysCustomerPrice scp) {

        StringBuilder sql = new StringBuilder();
        sql.append("select * from " + database + ".sys_customer_price where 1=1 ");
        if (scp != null) {
            if (!StrUtil.isNull(scp.getCustomerId())) {
                sql.append(" and customer_id=").append(scp.getCustomerId());
            }
            if (StrUtil.isNull(scp.getWareId())) {
                sql.append(" and ware_id=").append(scp.getWareId());
            }
        }
        try {
            return this.daoTemplate.queryForLists(sql.toString(), SysCustomerPrice.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }

    }

    public int updateBatchCustomer(String ids, String customerType, String hzfsNm, Integer isDb, String khdjNm, String regionId, String database) {
        String sql = " update " + database + ".sys_customer  set ";
        int flag = 0;
        if (!StrUtil.isNull(customerType)) {
            sql += " qdtp_nm='" + customerType + "'";
            flag = 1;
        }
        if (!StrUtil.isNull(hzfsNm)) {
            if (flag == 1) sql += ",";
            sql += "hzfs_nm='" + hzfsNm + "'";
            flag = 1;
        }
        if (isDb != null) {
            if (isDb.intValue() > 0) {
                if (flag == 1) sql += ",";
                sql += "is_db=" + isDb.toString();
                flag = 1;
            }
        }
        if (!StrUtil.isNull(khdjNm)) {
            if (flag == 1) sql += ",";
            sql += "khdj_nm='" + khdjNm + "' ";
        }

        if (!StrUtil.isNull(regionId)) {
            if (flag == 1) sql += ",";
            sql += "region_id='" + regionId + "' ";
        }

        sql += " where id in (" + ids + ") ";
        try {
            return this.daoTemplate.update(sql);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }


    public SysCustomerPrice queryCustomerPrice(SysCustomerPrice customerPrice, String database) {
        try {
            StringBuffer sb = new StringBuffer();
            sb.append(" select * from " + database + ".sys_customer_price");
            sb.append(" where 1=1");
            if (null != customerPrice) {
                if (!StrUtil.isNull(customerPrice.getCustomerId())) {
                    sb.append(" and customer_id = " + customerPrice.getCustomerId());
                }
                if (!StrUtil.isNull(customerPrice.getWareId())) {
                    sb.append(" and ware_id = " + customerPrice.getWareId());
                }
            }
            return this.daoTemplate.queryForObj(sb.toString(), SysCustomerPrice.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }


    /**
     *
     */
    public Integer updateCustomerByRzMobile(SysCustomer customer, String dataSource) {
        try {
            Map<String, Object> whereParam = new HashMap<>();
            whereParam.put("id", customer.getId());
            return this.daoTemplate.updateByObject("" + dataSource + ".sys_customer", customer, whereParam, "id");
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }


    public List<SysCustomer> queryCustomerListByIds(String ids, String database) {
        StringBuilder sql = new StringBuilder();
        sql.append("select a.*,c.member_nm  from " + database + ".sys_customer a ");
        sql.append("left join " + database + ".sys_mem c on a.mem_id=c.member_id ");
        sql.append("  where 1=1  ");
        if (StringUtils.isNotEmpty(ids))
            sql.append(" and a.id in(" + ids + ")");
        sql.append(" order by a.id desc");
        try {
            return this.daoTemplate.queryForLists(sql.toString(), SysCustomer.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public List<BaseCustomer> queryAllBase(String database) {
        StringBuilder sql = new StringBuilder(64);
        sql.append("SELECT id,kh_nm,address,is_db FROM ").append(database).append(".sys_customer");

        return this.daoTemplate.query(sql.toString(), (rs, rowNum) -> {
            BaseCustomer customer = new BaseCustomer();
            customer.setId(rs.getInt("id"));
            customer.setName(rs.getString("kh_nm"));
            customer.setIsDb(rs.getInt("is_db"));
            return customer;
        });

    }

    public int batchUpdateShopCustomerType(String ids, String qdtpNm, String khdjNm, Integer regionId, String database) {
        String sql;
        try {
            if (regionId != null) {
                if (regionId.equals(0)) {
                    sql = " update " + database + ".sys_customer set region_id=null" + "  where id in(" + ids + ")";
                } else {
                    sql = " update " + database + ".sys_customer set region_id=" + regionId + "  where id in(" + ids + ")";
                }
            } else {
                sql = " update " + database + ".sys_customer set qdtp_nm='" + qdtpNm + "',khdj_nm='" + khdjNm + "' where id in (" + ids + ") ";
            }
            return this.daoTemplate.update(sql);
        } catch (Exception var6) {
            throw new DaoException(var6);
        }
    }

    public int batchUAddCustomer(String ids, Integer id, String database) {
        String sql = " update " + database + ".sys_customer set qdtype_id =" + id + ",khlevel_id=null  where id in (" + ids + ")";
        try {
            return this.daoTemplate.update(sql);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public int batchRemoveCustomerType(String ids, String database) {
        String sql = " update " + database + ".sys_customer set qdtype_id =null   where id in (" + ids + ")";
        try {
            return this.daoTemplate.update(sql);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }


    public int batchUpdateShopCustomerGrade(String ids, String qdtpNm, String khdjNm, String database) {
        String sql = " update " + database + ".sys_customer set khdj_nm='" + StringUtils.trimToEmpty(khdjNm) + "' where id in (" + ids + ") ";

        try {
            return this.daoTemplate.update(sql);
        } catch (Exception var6) {
            throw new DaoException(var6);
        }
    }

    public int batchAddCustomerGrade(String ids, Integer id, String database) {
        String sql = " update " + database + ".sys_customer set khlevel_id=" + id + " where id in (" + ids + ") ";
        try {
            return this.daoTemplate.update(sql);
        } catch (Exception var6) {
            throw new DaoException(var6);
        }
    }

    public int batchRemoveCustomerGrade(String ids, String database) {
        String sql = " update " + database + ".sys_customer set khlevel_id =null   where id in (" + ids + ")";
        try {
            return this.daoTemplate.update(sql);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public Page queryNoneChainStoreCustomer(SysCustomer sysCustomer, int page, int rows, String database) {
        StringBuilder sql = new StringBuilder();
        sql.append("select * from " + database + ".sys_customer  where 1=1 and is_db=2 ");
        sql.append(" and shop_id is null");
        try {
            if (null != sysCustomer) {
                if (!StrUtil.isNull(sysCustomer.getKhNm())) {
                    sql.append(" and kh_nm like '%").append(sysCustomer.getKhNm()).append("%'");

                }
            }
            return this.daoTemplate.queryForPageByMySql(sql.toString(), page, rows, SysCustomer.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }

    }


    public Page queryChainStoreCustomer(SysCustomer sysCustomer, int shopId, int page, int rows, String database) {
        StringBuilder sql = new StringBuilder();
        sql.append("select * from " + database + ".sys_customer  where 1=1 and is_db=2 ");
        sql.append(" and shop_id =" + shopId);
        try {
            if (null != sysCustomer) {
                if (!StrUtil.isNull(sysCustomer.getKhNm())) {
                    sql.append(" and kh_nm like '%").append(sysCustomer.getKhNm()).append("%'");

                }
            }
            return this.daoTemplate.queryForPageByMySql(sql.toString(), page, rows, SysCustomer.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }

    }

    public int batchUAddChainStoreCustomer(String ids, Integer id, String database) {
        String sql = " update " + database + ".sys_customer set shop_id=" + id + " where id in (" + ids + ")";

        try {
            return this.daoTemplate.update(sql);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }


    public int batchRemoveChainStoreCustomer(String ids, String database) {
        String sql = " update " + database + ".sys_customer set shop_id=null  where id in (" + ids + ")";
        try {
            return this.daoTemplate.update(sql);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：根据手机号码获取成员条数
     *
     * @创建：作者:llp 创建时间：2015-2-3
     * @修改历史： [序号](llp 2015 - 2 - 3)<修改说明>
     */
    /*public int querySysCustomerByRzMobile(String database, String rzMobile) {
        String sql = " select count(1) from " + database + ".sys_customer where rz_mobile=? ";
        try {
            return this.daoTemplate.queryForObject(sql, new Object[]{rzMobile}, Integer.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }*/

    /**
     * 说明：根据认证手机号码获取成员信息(企业的员工)
     */
    public SysCustomer querySysCustomerByRzMobile(String rzMobile, String datasource) {
        try {
            String sql = "select * from " + datasource + ".sys_customer where rz_mobile=? ";
            return this.daoTemplate.queryForObj(sql, SysCustomer.class, rzMobile);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @param database
     * @param customerId
     * @param wareIds
     * @return
     */
    public Map<Integer, Map<Integer, BigDecimal>> queryAdjustWarePrice(String database, Integer customerId, String wareIds) throws Exception {

        SysCustomer customer = this.querySysCustomerById(customerId, database);
        Integer customerLevelId = customer.getKhlevelId();//客户等级ID
        Integer customerTypeId = customer.getQdtypeId();//客户类型ID
        String nowDate = DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd");
        Map<Integer, Map<Integer, BigDecimal>> map = new HashMap<Integer, Map<Integer, BigDecimal>>();
        ;
        List<Map<String, Object>> list1 = getAdjustWarePriceList(database, wareIds, nowDate);
        List<Map<String, Object>> list2 = getAdjustCustomerWarePriceList(database, 3, customerTypeId, wareIds, nowDate);
        List<Map<String, Object>> list3 = getAdjustCustomerWarePriceList(database, 4, customerLevelId, wareIds, nowDate);
        List<Map<String, Object>> list4 = getAdjustCustomerWarePriceList(database, 2, customerId, wareIds, nowDate);

        dealPriceListData(list1, map);
        dealPriceListData(list2, map);
        dealPriceListData(list3, map);
        dealPriceListData(list4, map);

        return map;
    }

    private List<Map<String, Object>> getAdjustWarePriceList(String database, String wareIds, String nowDate) throws Exception {
        String sql = "select * from " + database + ".stk_adjust_price_sub where is_use=1 and type=0 and pro_type=0 ";
        if (!StrUtil.isNull(wareIds)) {
            sql = sql + " and ware_id in(" + wareIds + ")";
        }
        if (!StrUtil.isNull(nowDate)) {
            sql = sql + " and sdate<='" + nowDate + "' and edate>='" + nowDate + "'";
        }
        List<Map<String, Object>> list = this.daoTemplate.queryForList(sql.toString());
        return list;
    }

    private List<Map<String, Object>> getAdjustCustomerWarePriceList(String database, Integer proType, Integer proId, String wareIds, String nowDate) throws Exception {
        String sql = "select * from " + database + ".stk_adjust_price_sub where is_use=1 and type=0 and pro_type=" + proType + " and pro_id='" + proId + "' ";

        if (proType == 2) {
            sql = "select * from " + database + ".stk_adjust_price_sub where is_use=1 and type=0 and pro_type=" + proType + " and pro_id like ',%" + proId + ",%' ";
        }

        if (!StrUtil.isNull(wareIds)) {
            sql = sql + " and ware_id in(" + wareIds + ")";
        }
        if (!StrUtil.isNull(nowDate)) {
            sql = sql + " and sdate<='" + nowDate + "' and edate>='" + nowDate + "'";
        }
        List<Map<String, Object>> list = this.daoTemplate.queryForList(sql.toString());
        return list;
    }

    private void dealPriceListData(List<Map<String, Object>> list, Map<Integer, Map<Integer, BigDecimal>> map) {
        if (list != null && list.size() > 0) {
            for (int i = 0; i < list.size(); i++) {
                Map<String, Object> oMap = list.get(i);
                Integer wareId = Integer.valueOf(oMap.get("ware_id") + "");
                Object price = oMap.get("price");
                Object disPrice = oMap.get("dis_price");
                Map<Integer, BigDecimal> mMap = new HashMap<Integer, BigDecimal>();
                if (!StrUtil.isNumberNullOrZero(price)) {
                    mMap.put(1, new BigDecimal(price + ""));
                }
                if (!StrUtil.isNumberNullOrZero(disPrice)) {
                    mMap.put(2, new BigDecimal(disPrice + ""));
                }
                map.put(wareId, mMap);
            }
        }
    }

    public Map<String, Object> queryCustomerHisWarePrice(String database, Integer customerId, Integer wareId) {
        try {
            StringBuffer sb = new StringBuffer("select b.be_unit,c.hs_num,c.ware_dj as org_price,b.price from " + database + ".stk_out a, " + database + ".stk_outsub b," + database + ".sys_ware c ");
            sb.append(" where  a.id = b.mast_id and b.ware_id=c.ware_id   and  b.xs_tp='正常销售' and (a.status=1 or a.status=0) ")
                    .append(" and b.ware_id=" + wareId + " and (a.sale_type='001' or a.sale_type ='') and  a.cst_id=" + customerId + "")
                    .append(" ORDER BY  a.id desc  limit 0,1 ");
            return this.daoTemplate.queryForMap(sb.toString());
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public boolean isContainChinese(String str) {
        Pattern p = Pattern.compile("[\u4e00-\u9fa5]");
        Matcher m = p.matcher(str);
        if (m.find()) {
            return true;
        }
        return false;
    }

    /**
     * 认证商城手机
     */
    public int updateRzShopMobile(String mobile, Integer id, String database) {
        String sql = " update " + database + ".sys_customer  set rz_mobile='" + mobile + "' where id =" + id;
        return this.daoTemplate.update(sql);
    }


    /**
     * 查找有经纬度没有地址的客户
     */
    public List<SysCustomer> queryCustomerListByHasLatLngNoAddress(String database) {
        StringBuilder sql = new StringBuilder();
        sql.append("select a.* from " + database + ".sys_customer a ");
        sql.append(" where 1=1 ");
        sql.append(" and (a.address is null or a.address = '' or a.province is null or a.province = '' or a.city is null or a.city = '' or a.area is null or a.area = '')");
        sql.append(" and (a.latitude is not null and a.latitude != '' and a.latitude != '0' and a.longitude is not null and a.longitude != '' and a.longitude != '0')");
        sql.append(" order by a.id desc");
        try {
            return this.daoTemplate.queryForLists(sql.toString(), SysCustomer.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }
    /**
     * 查找有地址没有经纬度的客户
     */
    public List<SysCustomer> queryCustomerListByHasAddressNoLatLng(String database) {
        StringBuilder sql = new StringBuilder();
        sql.append("select a.* from " + database + ".sys_customer a ");
        sql.append(" where 1=1 ");
        sql.append(" and (a.address is not null and a.address != '')");
        sql.append(" and (a.latitude is null or a.latitude = '' or a.latitude = '0' or a.longitude is null or a.longitude = '' or a.longitude = '0')");
        sql.append(" order by a.id desc");
        try {
            return this.daoTemplate.queryForLists(sql.toString(), SysCustomer.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

}
