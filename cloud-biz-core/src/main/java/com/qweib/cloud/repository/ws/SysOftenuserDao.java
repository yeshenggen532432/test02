package com.qweib.cloud.repository.ws;


import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.SysMemBind;
import com.qweib.cloud.core.domain.SysOftenuser;
import com.qweib.cloud.core.exception.DaoException;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.List;

@Repository
public class SysOftenuserDao {
    @Resource(name = "daoTemplate")
    private JdbcDaoTemplate daoTemplate;

    /**
     * 添加常用联系人
     */
    public int addCyuser(String datasource, SysOftenuser oftenuser) {
        try {
            return this.daoTemplate.addByObject("" + datasource + ".sys_oftenuser", oftenuser);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 删除常用联系人
     */
    public int deleteCyuser(String datasource, Integer memberId, Integer cyId) {
        try {
            String sql = "delete from " + datasource + ".sys_oftenuser where member_id=" + memberId + " and bind_member_id=" + cyId + " ";
            return this.daoTemplate.update(sql.toString());
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 根据memberId查询sys_oftenuser表（分页）
     *
     * @param memberId
     */
    public List<SysMemBind> queryCyMember(String datasource, Integer memberId, String mems) {
        try {
            StringBuilder sql = new StringBuilder(128);
            sql.append("SELECT DISTINCT o.member_id as memberId,o.bind_member_id as bindMemberId ,m.member_nm as memberNm,m.member_mobile as memberMobile,m.first_char as firstChar,m.member_head as memberHead FROM ")
                    .append(datasource).append(".sys_oftenuser o LEFT JOIN ").append(datasource).append(".sys_mem m ON m.member_id=o.bind_member_id")
                    .append(" WHERE o.member_id=").append(memberId);
            if (null != mems) {
                sql.append(" AND o.bind_member_id NOT IN (").append(mems).append(") ORDER BY m.first_char ASC");
            }
            return this.daoTemplate.queryForLists(sql.toString(), SysMemBind.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }
}
