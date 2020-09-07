package com.qweib.cloud.repository;

import com.google.common.collect.Lists;
import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.SysSalesman;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.service.initial.domain.company.SalesmanStatusEnum;
import com.qweib.cloud.utils.Collections3;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import com.qweib.commons.MathUtils;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.*;

/**
 * @author: yueji.hu
 * @time: 2019-08-07 10:58
 * @description:
 */
@Repository
public class SysSalesmanDao {
    @Resource(name = "daoTemplate")
    private JdbcDaoTemplate daoTemplate;

    public Page queryData(SysSalesman vo, int page, int rows, String database) {
        StringBuffer sql = new StringBuffer(" select a.*,b.member_nm as member_name from " + database + ".sys_salesman a left join " + database + ".sys_mem b on a.member_id=b.member_id  where 1 = 1");

        if (null != vo) {
            if (!StrUtil.isNull(vo.getSalesmanName())) {
                sql.append(" and a.salesman_name like '%").append(vo.getSalesmanName()).append("%'");
            }
            if (vo.getStatus() != null) {
                if (vo.getStatus().equals(1)) {
                    sql.append(" and (a.status is null or a.status= '").append(vo.getStatus()).append("')");
                } else {
                    sql.append(" and a.status= '").append(vo.getStatus()).append("'");
                }

            }
        }

        sql.append(" order by id asc ");
        try {
            return this.daoTemplate.queryForPageByMySql(sql.toString(), page, rows, SysSalesman.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public List<SysSalesman> queryList(SysSalesman vo, String database) {
        StringBuffer sql = new StringBuffer(" select a.*,b.member_nm as member_name from " + database + ".sys_salesman a left join " + database + ".sys_mem b on a.member_id=b.member_id  where 1 = 1");
        if (null != vo) {
            if (!StrUtil.isNull(vo.getSalesmanName())) {
                sql.append(" and a.salesman_name like '%").append(vo.getSalesmanName()).append("%'");
            }
            if (vo.getStatus() != null) {
                if (vo.getStatus().equals(1)) {
                    sql.append(" and (a.status is null or a.status= '").append(vo.getStatus()).append("')");
                } else {
                    sql.append(" and a.status= '").append(vo.getStatus()).append("'");
                }

            }
        }
        sql.append(" order by id asc ");
        try {
            return this.daoTemplate.queryForLists(sql.toString(), SysSalesman.class);

        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public int addData(SysSalesman bo, String database) {
        try {
            return this.daoTemplate.addByObject("" + database + ".sys_salesman", bo);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public int updateData(SysSalesman bo, String database) {
        try {
            Map<String, Object> whereParam = new HashMap<String, Object>();
            whereParam.put("id", bo.getId().toString());
            return this.daoTemplate.updateByObject("" + database + ".sys_salesman", bo, whereParam, null);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public int updateMemberId(Integer id, String tel, Integer memberId, String database) {
        if (Objects.nonNull(memberId)) {
            removeBindMember(memberId, database);
        }
        return this.daoTemplate.update("update " + database + ".sys_salesman set tel = ?, member_id = ? where id = ?",
                new Object[]{tel, memberId, id});
    }

    public int removeBindMember(Integer memberId, String database) {
        return this.daoTemplate.update("update " + database + ".sys_salesman set tel = ?, member_id = ? where member_id = ?",
                new Object[]{null, null, memberId});
    }

    public int cleanBindMember(String database) {
        return this.daoTemplate.update("update " + database + ".sys_salesman set tel = null, member_id = null");
    }

//    public int deleteData(int id, String database) {
//        String sql = " delete from " + database + ".sys_salesman where id=? ";
//        try {
//            return this.daoTemplate.update(sql, id);
//        } catch (Exception e) {
//            throw new DaoException(e);
//        }
//    }

    public SysSalesman findByName(String salesmanName, String database) {
        String sql = "select * from " + database + ".sys_salesman where salesman_name=? ";
        try {
            return this.daoTemplate.queryForObj(sql, SysSalesman.class, salesmanName);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public SysSalesman queryById(Integer id, String database) {
        String sql = "select a.*,b.member_nm as member_name from " + database + ".sys_salesman a left join " + database + ".sys_mem b on a.member_id=b.member_id where id=" + id.toString();
        try {
            List<SysSalesman> list = this.daoTemplate.queryForLists(sql, SysSalesman.class);
            if (list.size() > 0) return list.get(0);
            return null;
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public SysSalesman getNoBindSalesman(String database, Integer memberId) {
        StringBuilder sql = new StringBuilder(64);
        sql.append("select * from ").append(database).append(".sys_salesman where `status` = ?");
        List<Object> values = Lists.newArrayList();
        values.add(1);
        if (Objects.nonNull(memberId)) {
            sql.append(" and member_id = ?");
            values.add(memberId);
        } else {
            sql.append(" and member_id IS NULL");
        }
        sql.append(" LIMIT 1");
        List<SysSalesman> list = this.daoTemplate.queryForLists(sql.toString(), SysSalesman.class, values.toArray());
        return  (Collections3.isNotEmpty(list)) ? list.get(0) : null;
    }

    public boolean hasEnabledSalesman(Integer memberId, String database) {
        Integer count = this.daoTemplate.queryForInt("select count(id) from " + database + ".sys_salesman where member_id = ? and status = ?",
                new Object[]{memberId, SalesmanStatusEnum.ENABLED.getStatus()});

        return MathUtils.valid(count);
    }
}
