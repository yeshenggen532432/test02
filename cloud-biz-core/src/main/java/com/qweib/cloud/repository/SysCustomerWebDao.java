package com.qweib.cloud.repository;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.SysCustomer;
import com.qweib.cloud.core.domain.SysCustomerWeb;
import com.qweib.cloud.core.domain.SysProvider;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.DateTimeUtil;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.Date;
import java.util.List;
import java.util.Map;

@Repository
public class SysCustomerWebDao {
    @Resource(name = "daoTemplate")
    private JdbcDaoTemplate daoTemplate;

    /**
     * 说明：分页查询我周边客户
     *
     * @创建：作者:llp 创建时间：2016-2-19
     * @修改历史： [序号](llp 2016 - 2 - 19)<修改说明>
     */
    public Page queryCustomerWebZb(String database, Integer memId, Integer khTp, Double longitude, Double latitude, Integer page, Integer limit, String khNm, String mids, String pxtp, String regionIds) {
        StringBuilder sql = new StringBuilder();
        sql.append("select a.id,a.kh_nm,a.kh_tp,a.qdtp_nm,a.xsjd_nm,a.linkman,a.mobile,a.tel,a.province,a.city,a.area,a.address,a.longitude,a.latitude,a.scbf_date,c.member_nm,FORMAT((6371.004*ACOS(SIN(" + latitude + "/180*PI())*SIN(a.latitude/180*PI())+COS(" + latitude + "/180*PI())*COS(a.latitude/180*PI())*COS((" + longitude + "-a.longitude)/180*PI()))),1) as jlkm  from " + database + ".sys_customer a left join " + database + ".sys_mem c on a.mem_id=c.member_id " +
                "where a.is_db=2 ");
//				+ " and (6371.004*ACOS(SIN("+latitude+"/180*PI())*SIN(a.latitude/180*PI())+COS("+latitude+"/180*PI())*COS(a.latitude/180*PI())*COS(("+longitude+"-a.longitude)/180*PI())))<10");
		/*if (!StrUtil.isNull(map.get("allDepts"))) {//要查询的部门和可见部门
			if (!StrUtil.isNull(map.get("mId"))) {//个人和可见部门结合查询
				sql.append(" AND (c.branch_id IN ("+map.get("allDepts")+") ");
				sql.append(" OR a.mem_id="+map.get("mId")+")");
			} else {
				sql.append(" AND c.branch_id IN ("+map.get("allDepts")+") ");
			}
		}else if (!StrUtil.isNull(map.get("mId"))) {//个人
			sql.append(" AND a.mem_id="+map.get("mId"));
		}
		if (!StrUtil.isNull(map.get("invisibleDepts"))) {//不可见部门
			sql.append(" AND c.branch_id NOT IN ("+map.get("invisibleDepts")+") ");
		} */
        if (!StrUtil.isNull(mids)) {
            sql.append(" AND a.mem_id in (" + mids + ")");
        }
        if (!StrUtil.isNull(khNm)) {
            sql.append(" and (a.kh_nm like '%" + khNm + "%' or c.member_nm like '%" + khNm + "%' or a.area like '%" + khNm + "%' or a.mobile like '%" + khNm + "%' or a.address like '%" + khNm + "%' or a.linkman like '%" + khNm + "%')");
        }
        if (!StrUtil.isNull(regionIds)) {
            sql.append(" and a.region_id in (" + regionIds + ")");
        }
        if (!StrUtil.isNull(pxtp)) {
            if (pxtp.equals("1")) {
                sql.append(" order by -(cast(jlkm as decimal(2,1))) desc");
            } else if (pxtp.equals("2")) {
                sql.append(" order by a.scbf_date desc");
            } else if (pxtp.equals("3")) {
                sql.append(" order by a.scbf_date asc");
            }
        } else {
            sql.append(" order by -(cast(jlkm as decimal(2,1))) desc");
        }
        try {
            return this.daoTemplate.queryForPageByMySql(sql.toString(), page, limit, SysCustomerWeb.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：分页查询我的客户
     *
     * @创建：作者:llp 创建时间：2016-3-1
     * @修改历史： [序号](llp 2016 - 3 - 1)<修改说明>
     */
    public Page queryCustomerWeb(String database, Integer khTp, Map<String, Object> map, Integer page, Integer limit, String khNm,
                                 Double longitude, Double latitude, String qdtpNms, String khdjNms, Integer xlId, String mids, String pxtp, String regionIds) {
        StringBuilder sql = new StringBuilder();
        sql.append("select a.id,a.kh_nm,a.kh_tp,a.qdtp_nm,a.xsjd_nm,a.linkman,a.mobile,a.tel,a.province,a.city,a.area,a.address,a.longitude,a.latitude,a.scbf_date,a.mem_id,c.member_nm,d.branch_name,FORMAT((6371.004*ACOS(SIN(" + latitude + "/180*PI())*SIN(a.latitude/180*PI())+COS(" + latitude + "/180*PI())*COS(a.latitude/180*PI())*COS((" + longitude + "-a.longitude)/180*PI()))),1) as jlkm " +
                "from " + database + ".sys_customer a  left join " + database + ".sys_mem c on a.mem_id=c.member_id left join " + database + ".sys_depart d on a.branch_id=d.branch_id  where  a.is_db=2");
        if (!StrUtil.isNull(mids)) {
            sql.append(" AND a.mem_id in (" + mids + ")");
        } else {
            if (!StrUtil.isNull(map.get("allDepts"))) {//要查询的部门和可见部门
                if (!StrUtil.isNull(map.get("mId"))) {//个人和可见部门结合查询
                    sql.append(" AND (c.branch_id IN (" + map.get("allDepts") + ") ");
                    sql.append(" OR a.mem_id=" + map.get("mId") + ")");
                } else {
                    sql.append(" AND a.branch_id IN (" + map.get("allDepts") + ") ");
                }
            } else if (!StrUtil.isNull(map.get("mId"))) {//个人
                sql.append(" AND a.mem_id=" + map.get("mId"));
            }
            if (!StrUtil.isNull(map.get("invisibleDepts"))) {//不可见部门
                sql.append(" AND a.branch_id NOT IN (" + map.get("invisibleDepts") + ") ");
            }
        }
        if (!StrUtil.isNull(khNm)) {
            sql.append(" and (a.kh_nm like '%" + khNm + "%' or c.member_nm like '%" + khNm + "%' or a.area like '%" + khNm + "%' or a.mobile like '%" + khNm + "%' or a.address like '%" + khNm + "%' or a.linkman like '%" + khNm + "%')");
        }
        if (!StrUtil.isNull(qdtpNms)) {
            sql.append(" and a.qdtp_nm in (" + qdtpNms + ")");
        }
        if (!StrUtil.isNull(khdjNms)) {
            sql.append(" and a.khdj_nm in (" + khdjNms + ")");
        }
        if (!StrUtil.isNull(regionIds)) {
            sql.append(" and a.region_id in (" + regionIds + ")");
        }
        if (!StrUtil.isNull(xlId)) {
            sql.append(" and a.id not in (select cid from " + database + ".bsc_planxl_detail where xl_id=" + xlId + ")");
        }
        if (!StrUtil.isNull(pxtp)) {
            if (pxtp.equals("1")) {
                sql.append(" order by -(cast(jlkm as decimal(2,1))) DESC");
            } else if (pxtp.equals("2")) {
                sql.append(" order by a.scbf_date desc");
            } else if (pxtp.equals("3")) {
                sql.append(" order by a.scbf_date asc");
            }
        } else {
            sql.append(" order by -(cast(jlkm as decimal(2,1))) DESC");
        }
        try {
            return this.daoTemplate.queryForPageByMySql(sql.toString(), page, limit, SysCustomerWeb.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：列表查经销商
     *
     * @创建：作者:llp 创建时间：2016-2-19
     * @修改历史： [序号](llp 2016 - 2 - 19)<修改说明>
     */
    public List<SysCustomerWeb> queryCustomerls1(String database) {
        String sql = "select id,kh_nm from " + database + ".sys_customer where kh_tp=1 order by id desc";
        try {
            return this.daoTemplate.queryForLists(sql, SysCustomerWeb.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：修改经销商
     *
     * @创建：作者:llp 创建时间：2016-3-10
     * @修改历史： [序号](llp 2016 - 3 - 10)<修改说明>
     */
    public void updateCustomerSj1(String database, Integer id, String khNm, String jxsflNm, String jxsztNm,
                                  String jxsjbNm, String bfpcNm, String fgqy, String linkman, String mobile, String tel, String mobileCx,
                                  String province, String city, String area, String address, String longitude, String latitude,
                                  String qq, String wxCode, String fman, String ftel, String openDate, String remo) {
        String sql = "update " + database + ".sys_customer set kh_nm='" + khNm + "',jxsfl_nm='" + jxsflNm + "',jxszt_nm='" + jxsztNm + "',jxsjb_nm='" + jxsjbNm + "',bfpc_nm='" + bfpcNm + "',fgqy='" + fgqy + "'," +
                "linkman='" + linkman + "',mobile='" + mobile + "',tel='" + tel + "',mobile_cx='" + mobileCx + "',province='" + province + "',city='" + city + "',area='" + area + "',address='" + address + "'," +
                "longitude='" + longitude + "',latitude='" + latitude + "',qq='" + qq + "',wx_code='" + wxCode + "',fman='" + fman + "',ftel='" + ftel + "',open_date='" + openDate + "',remo='" + remo + "' where id=" + id;
        try {
            this.daoTemplate.update(sql);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：修改客户
     *
     * @创建：作者:llp 创建时间：2016-3-10
     * @修改历史： [序号](llp 2016 - 3 - 10)<修改说明>
     */
    public void updateCustomerSj2(String database, Integer id, String khNm, String linkman, String mobile, String tel,
                                  String province, String city, String area, String address, String longitude, String latitude,
                                  String qdtpNm, String khdjNm, Integer qdtypeId, Integer khlevelId, String xsjdNm, String bfpcNm,
                                  String qq, String wxCode, Integer khPid, String fgqy, String openDate, String remo, String hzfsNm, Integer regionId) {
        String sql = "update " + database + ".sys_customer set kh_nm='" + khNm + "',linkman='" + linkman + "',mobile='" + mobile + "',tel='" + tel + "',province='" + province + "',city='" + city + "',area='" + area + "'," +
                "address='" + address + "',longitude='" + longitude + "',latitude='" + latitude + "',qdtp_nm='" + qdtpNm + "',khdj_nm='" + khdjNm + "',qdtype_id=" + qdtypeId + ",khlevel_id=" + khlevelId +
                ",xsjd_nm='" + xsjdNm + "',bfpc_nm='" + bfpcNm + "',qq='" + qq + "'," +
                "wx_code='" + wxCode + "',kh_pid=" + khPid + ",fgqy='" + fgqy + "',open_date='" + openDate + "',remo='" + remo + "',region_id=" + regionId + ",hzfs_nm='" + hzfsNm + "' where id=" + id;
        try {
            this.daoTemplate.update(sql);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：根据客户id修改客户状态，拜访分类
     *
     * @创建：作者:llp 创建时间：2016-3-28
     * @修改历史： [序号](llp 2016 - 3 - 28)<修改说明>
     */
    public void updateCustomerZF(String database, String xsjdNm, String bfflNm, Integer cid) {
        String sql = "update " + database + ".sys_customer set xsjd_nm='" + xsjdNm + "',bffl_nm='" + bfflNm + "' where id=" + cid;
        try {
            this.daoTemplate.update(sql);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：根据客户id修改上次拜访日期
     *
     * @创建：作者:llp 创建时间：2016-3-28
     * @修改历史： [序号](llp 2016 - 3 - 28)<修改说明>
     */
    public void updateCustomerScbfDate(String database, Integer cid) {
        try {
            String sql = "update " + database + ".sys_customer set scbf_date='" + DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd") + "' where id=" + cid;
            this.daoTemplate.update(sql);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 分页查询供应商
     */
    public Page queryProviderPage(String proName, int page, int rows, String database) {
        StringBuffer sql = new StringBuffer(" select a.*,b.name as pro_type_name from " + database + ".stk_provider a left join " + database + ".stk_provider_type b on a.pro_type_id=b.id  where 1 = 1");
        if (null != proName) {
            sql.append(" and (a.pro_name like '%").append(proName).append("%'");
            sql.append(" or a.pro_no like '%").append(proName).append("%')");
        }
        sql.append(" order by a.id asc ");
        try {
            return this.daoTemplate.queryForPageByMySql(sql.toString(), page, rows, SysProvider.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }


    /**
     * 说明：分页查询我的客户
     */
    public Page queryCustomerPage(String database, Integer page, Integer limit, String khNm,
                                  Double longitude, Double latitude, String qdtpNms, String khdjNms, Integer xlId, String mids, String pxtp, String regionIds) {
        StringBuilder sql = new StringBuilder();
        sql.append("select a.id,a.kh_nm,a.kh_tp,a.qdtp_nm,a.xsjd_nm,a.linkman,a.mobile,a.tel,a.province,a.city,a.area,a.address,a.longitude,a.latitude,a.scbf_date,a.mem_id,c.member_nm,d.branch_name,FORMAT((6371.004*ACOS(SIN(" + latitude + "/180*PI())*SIN(a.latitude/180*PI())+COS(" + latitude + "/180*PI())*COS(a.latitude/180*PI())*COS((" + longitude + "-a.longitude)/180*PI()))),1) as jlkm " +
                "from " + database + ".sys_customer a  left join " + database + ".sys_mem c on a.mem_id=c.member_id left join " + database + ".sys_depart d on a.branch_id=d.branch_id  where  a.is_db=2");
        if (!StrUtil.isNull(mids)) {
            sql.append(" AND a.mem_id in (" + mids + ")");
        }
        if (!StrUtil.isNull(khNm)) {
            sql.append(" and (a.kh_nm like '%" + khNm + "%' or c.member_nm like '%" + khNm + "%' or a.area like '%" + khNm + "%' or a.mobile like '%" + khNm + "%' or a.address like '%" + khNm + "%' or a.linkman like '%" + khNm + "%')");
        }
        if (!StrUtil.isNull(qdtpNms)) {
            sql.append(" and a.qdtp_nm in (" + qdtpNms + ")");
        }
        if (!StrUtil.isNull(khdjNms)) {
            sql.append(" and a.khdj_nm in (" + khdjNms + ")");
        }
        if (!StrUtil.isNull(regionIds)) {
            sql.append(" and a.region_id in (" + regionIds + ")");
        }
        if (!StrUtil.isNull(xlId)) {
            sql.append(" and a.id not in (select cid from " + database + ".bsc_planxl_detail where xl_id=" + xlId + ")");
        }
        if (!StrUtil.isNull(pxtp)) {
            if (pxtp.equals("1")) {
                sql.append(" order by -(cast(jlkm as decimal(2,1))) DESC");
            } else if (pxtp.equals("2")) {
                sql.append(" order by a.scbf_date desc");
            } else if (pxtp.equals("3")) {
                sql.append(" order by a.scbf_date asc");
            }
        } else {
            sql.append(" order by -(cast(jlkm as decimal(2,1))) DESC");
        }
        try {
            return this.daoTemplate.queryForPageByMySql(sql.toString(), page, limit, SysCustomerWeb.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public Page queryCustomerPageEx(SysCustomer customer,Integer page,Integer limit,String database)
    {
        StringBuilder sql = new StringBuilder();
        sql.append("select a.id,a.kh_nm,a.kh_tp,a.qdtp_nm,a.xsjd_nm,a.linkman,a.mobile,a.tel,a.province,a.city,a.area,a.address,a.longitude,a.latitude,a.scbf_date,a.mem_id,c.member_nm,d.branch_name " +
                "from " + database + ".sys_customer a  left join " + database + ".sys_mem c on a.mem_id=c.member_id left join " + database + ".sys_depart d on a.branch_id=d.branch_id  where  a.is_db=2");

        if (!StrUtil.isNull(customer.getKhNm())) {
            sql.append(" and (a.kh_nm like '%" + customer.getKhNm() + "%' or c.member_nm like '%" + customer.getKhNm() + "%' or a.area like '%" + customer.getKhNm() + "%' or a.mobile like '%" + customer.getKhNm() + "%' or a.address like '%" + customer.getKhNm() + "%' or a.linkman like '%" + customer.getKhNm() + "%')");
        }


        try {
            return this.daoTemplate.queryForPageByMySql(sql.toString(), page, limit, SysCustomerWeb.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }


    /**
     * 获取经纬度点几公里之内的客户
     */
    public List<SysCustomer> queryNearCustomerListByLatLng(String database, String latitude, String longitude, String mIds, String customerType) {
        String disSql = "(6371.004*ACOS(SIN(" + latitude + "/180*PI())*SIN(a.latitude/180*PI())+COS(" + latitude + "/180*PI())*COS(a.latitude/180*PI())*COS((" + longitude + "-a.longitude)/180*PI())))";
        StringBuilder sql = new StringBuilder();
        sql.append(" select a.*, FORMAT(" + disSql + ",1) as jlkm from " + database + ".sys_customer a ");
        sql.append(" where  a.is_db=2");
        if (!StrUtil.isNull(mIds)) {
            sql.append(" and a.mem_id in (" + mIds + ")");
        }
        if (!StrUtil.isNull(customerType)) {
            sql.append(" and a.qdtp_nm in (" + customerType + ")");
        }
        sql.append(" and " + disSql + " < 2 ");
        try {
            return this.daoTemplate.queryForLists(sql.toString(), SysCustomer.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }


}
