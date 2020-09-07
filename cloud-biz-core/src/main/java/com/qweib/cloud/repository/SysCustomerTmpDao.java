package com.qweib.cloud.repository;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.SysCustomerTmp;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.MemberBranchSqlUtil;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
public class SysCustomerTmpDao {

    @Resource(name = "daoTemplate")
    private JdbcDaoTemplate daoTemplate;

    /**
     * 添加-临时客户
     */
    public int addTmpCustomer(SysCustomerTmp bean, String database) {
        try {
            return this.daoTemplate.addByObject("" + database + ".sys_customer_tmp", bean);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 删除-临时客户
     */
    public int deleteTmpCustomer(Integer id, String database) {
        String sql = "delete " + database + ".sys_customer_tmp  where id=" + id;
        return this.daoTemplate.update(sql);
    }

    /**
     * 修改-临时客户
     */
    public int updateTmpCustomer(SysCustomerTmp bean, String database) {
        try {
            Map<String, Object> whereParam = new HashMap<String, Object>();
            whereParam.put("id", bean.getId());
            return this.daoTemplate.updateByObject("" + database + ".sys_customer_tmp", bean, whereParam, "id");
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 临时客户
     */
    public SysCustomerTmp queryTmpCustomer(SysCustomerTmp bean, String database) {
        try {
            StringBuffer sb = new StringBuffer();
            sb.append(getSqlByQueryBase(database));
            if (bean != null) {
                if (!StrUtil.isNull(bean.getKhNm())) {
                    sb.append(" and a.kh_nm = '" + bean.getKhNm() + "'");
                }
                if (!StrUtil.isNull(bean.getId())) {
                    sb.append(" and a.id = '" + bean.getId() + "'");
                }
            }
            List<SysCustomerTmp> list = this.daoTemplate.queryForLists(sb.toString(), SysCustomerTmp.class);
            if (list != null && list.size() > 0) {
                return list.get(0);
            }
        } catch (Exception e) {
            throw new DaoException(e);
        }
        return null;
    }

    /**
     * 临时客户
     */
    public SysCustomerTmp queryTmpCustomerByKhNm(String khNm, String database) {
        try {
            StringBuffer sb = new StringBuffer();
            sb.append(getSqlByQueryBase(database));
            if (!StrUtil.isNull(khNm)) {
                sb.append(" and a.kh_nm = '" + khNm + "'");
            }
            List<SysCustomerTmp> list = this.daoTemplate.queryForLists(sb.toString(), SysCustomerTmp.class);
            if (list != null && list.size() > 0) {
                return list.get(0);
            }
        } catch (Exception e) {
            throw new DaoException(e);
        }
        return null;
    }

    /**
     * 分页
     */
    public Page queryTmpCustomerPageWeb(String database, Integer pageNo, Integer pageSize, Map<String, Object> map, String mids,
                                        String khNm, Double longitude, Double latitude) {
        try {
            StringBuffer sb = new StringBuffer();
            return this.daoTemplate.queryForPageByMySql(getSqlByPageOrList(database, map, mids, khNm, longitude, latitude), pageNo, pageSize, SysCustomerTmp.class);
        } catch (Exception e) {
            throw new DaoException();
        }
    }

    /**
     * 分页
     */
    public List<SysCustomerTmp> queryTmpCustomerList(String database, Map<String, Object> map, String mids,
                                                     String khNm, Double longitude, Double latitude) {
        try {
            return this.daoTemplate.queryForLists(getSqlByPageOrList(database, map, mids, khNm, longitude, latitude), SysCustomerTmp.class);
        } catch (Exception e) {
            throw new DaoException();
        }
    }

    /**
     * 分页
     */
    public Page queryCustomerTmpPage(String database, Integer pageNo, Integer pageSize, Map<String, Object> map, SysCustomerTmp bean) {
        try {
            StringBuffer sb = new StringBuffer();
            sb.append(getSqlByPageOrList(database, map, bean));
            return this.daoTemplate.queryForPageByMySql(sb.toString(), pageNo, pageSize, SysCustomerTmp.class);
        } catch (Exception e) {
            throw new DaoException();
        }
    }

    //--------------------------------------------公共sql-------------------------------------------------------------

    /**
     * 查询sql--基本
     */
    public String getSqlByQueryBase(String database) {
        StringBuffer sb = new StringBuffer();
        sb.append("select a.*, m.member_nm from " + database + ".sys_customer_tmp a");
        sb.append(" left join " + database + ".sys_mem m on a.mem_id = m.member_id");
        sb.append(" where 1 = 1");
        return sb.toString();
    }

    /**
     * 查询sql--list或者page
     */
    public String getSqlByPageOrList(String database, Map<String, Object> map, String mids, String khNm, Double longitude, Double latitude) {
        StringBuffer sb = new StringBuffer();
        sb.append("select a.*, m.member_nm, d.branch_name, " +
                " FORMAT((6371.004*ACOS(SIN(" + latitude + "/180*PI())*SIN(a.latitude/180*PI())+COS(" + latitude + "/180*PI())*COS(a.latitude/180*PI())*COS((" + longitude + "-a.longitude)/180*PI()))),1) as jlkm " +
                " from " + database + ".sys_customer_tmp a");
        sb.append(" left join " + database + ".sys_mem m on a.mem_id = m.member_id");
        sb.append(" left join " + database + ".sys_depart d on m.branch_id = d.branch_id");
        sb.append(" where 1 = 1");
        sb.append(MemberBranchSqlUtil.getMemberBranchAppendSql(mids, map));
        if (!StrUtil.isNull(khNm)) {
            sb.append(" and a.kh_nm like '%" + khNm + "%'");
        }
        sb.append(" order by a.id");
        return sb.toString();
    }

    /**
     * 查询sql--list或者page
     */
    public String getSqlByPageOrList(String database, Map<String, Object> map, SysCustomerTmp bean) {
        StringBuffer sb = new StringBuffer();
        sb.append("select a.*, m.member_nm, d.branch_name from " + database + ".sys_customer_tmp a");
        sb.append(" left join " + database + ".sys_mem m on a.mem_id = m.member_id");
        sb.append(" left join " + database + ".sys_depart d on m.branch_id = d.branch_id");
        sb.append(" where 1 = 1");
        sb.append(MemberBranchSqlUtil.getMemberBranchAppendSql(null, map));
        if(bean != null){
            if (!StrUtil.isNull(bean.getKhNm())) {
                sb.append(" and a.kh_nm like '%" + bean.getKhNm() + "%'");
            }
            if (!StrUtil.isNull(bean.getMemberNm())){
                sb.append(" and m.member_nm like '%" + bean.getMemberNm() + "%'");
            }
            if (!StrUtil.isNull(bean.getIsDb())){
                sb.append(" and a.is_db like '%" + bean.getIsDb() + "%'");
            }
        }
        sb.append(" order by a.id");
        return sb.toString();
    }

}
