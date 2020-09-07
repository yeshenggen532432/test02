package com.qweib.cloud.repository.plat;

import com.qweib.cloud.core.dao.JdbcDaoTemplatePlud;
import com.qweib.cloud.core.domain.SysRoleMember;
import com.qweib.cloud.core.exception.DaoException;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

@Repository
public class SysRoleMemberDao {
    @Resource(name = "pdaoTemplate")
    private JdbcDaoTemplatePlud daoTemplate;

    /**
     * 添加
     *
     * @param srm
     * @return
     */
    public Integer addRoleMember(SysRoleMember srm) {
        try {
            return daoTemplate.addByObject("sys_role_member", srm);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

//    /**
//     * 删除
//     */
//    public void deleteRoleMember(Integer memberId) {
//        String sql = "delete from sys_role_member where member_id=" + memberId;
//        try {
//            daoTemplate.update(sql);
//        } catch (Exception e) {
//            throw new DaoException(e);
//        }
//    }
//
//    //删除公司后删除对应的公司角色
//    public void deleteRoleMemBycid(String memIds) {
//        String sql = "delete from sys_role_member where member_id in (" + memIds + ") ";
//        try {
//            daoTemplate.update(sql);
//        } catch (Exception e) {
//            throw new DaoException(e);
//        }
//    }

    /**
     * 查询公司id下的角色memIds
     *
     * @param database
     * @return
     * @创建：作者:YYP 创建时间：2015-5-29
     */
    public List<Map<String, Object>> queryMemIds(String database) {
        StringBuilder sql = new StringBuilder(64);
        sql.append("SELECT group_concat(cast(rm.member_id as char(20))) as memIds FROM ").append(database)
        .append(".sys_role_member rm ");
        try {
            return daoTemplate.queryForList(sql.toString());
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }
}
