package com.qweib.cloud.repository;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.dao.JdbcDaoTemplatePlud;
import com.qweib.cloud.core.domain.SysBforder;
import com.qweib.cloud.core.domain.SysCompanyJoin;
import com.qweib.cloud.core.domain.SysDepart;
import com.qweib.cloud.core.domain.SysMemDTO;
import com.qweib.cloud.core.domain.vo.OrderState;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.DateTimeUtil;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
public class SysCompanyJoinDao {
    @Resource(name = "daoTemplate")
    private JdbcDaoTemplate daoTemplate;

    /**
     *  添加：申请加入公司
     */
    public int addCompanyJoin(SysCompanyJoin companyJoin, String datasource) {
        try {
            return this.daoTemplate.addByObject("" + datasource + ".sys_company_join", companyJoin);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }


    /**
     * 查询：申请加入公司
     */
    public Page queryCompanyJoinPage(SysCompanyJoin companyJoin, String datasource, Integer page, Integer limit) {
        try {
            StringBuilder sql = new StringBuilder();
            sql.append("select a.*, m.member_nm as userName from " + datasource + ".sys_company_join a");
            sql.append(" left join " + datasource + ".sys_mem m on a.user_id = m.member_id ");
            sql.append(" where 1 = 1");
            if (null != companyJoin) {
                if (!StrUtil.isNull(companyJoin.getMemberName())) {
                    sql.append(" and a.member_name like '%" + companyJoin.getMemberName() + "%'");
                }
                if (!StrUtil.isNull(companyJoin.getMemberMobile())) {
                    sql.append(" and a.member_mobile like '%" + companyJoin.getMemberMobile() + "%'");
                }
                if (!StrUtil.isNull(companyJoin.getStatus())) {
                    sql.append(" and a.status = " + companyJoin.getStatus());
                }
                if (!StrUtil.isNull(companyJoin.getSdate())) {
                    sql.append(" and a.create_time >= '").append(companyJoin.getSdate()).append("'");
                }
                if (!StrUtil.isNull(companyJoin.getEdate())) {
                    sql.append(" and a.create_time <= '").append(companyJoin.getEdate() + " 23:59:59").append("'");
                }
            }
            sql.append(" order by a.create_time desc");

            return this.daoTemplate.queryForPageByMySql(sql.toString(), page, limit, SysCompanyJoin.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 修改是否同意状态
     */
    public int updateStatusCompanyJoin(String database, Integer id, String agree, Integer userId) {
        StringBuffer sql = new StringBuffer();
        sql.append("update " + database + ".sys_company_join set status='" + agree + "' ,user_id = "+ userId +" where id = " +id);
        return this.daoTemplate.update(sql.toString());
    }

    /**
     * 删除
     */
    public int deleteCompanyJoin(String database, String ids) {
        String sql = "delete from " + database + ".sys_company_join where id in("+ ids +")";
        try {
            return this.daoTemplate.update(sql);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }


}
