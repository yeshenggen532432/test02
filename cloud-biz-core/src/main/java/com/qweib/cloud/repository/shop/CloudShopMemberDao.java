package com.qweib.cloud.repository.shop;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.vo.ColdShopMember;
import com.qweib.cloud.core.exception.DaoException;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;

@Repository
public class CloudShopMemberDao {

    @Resource(name = "daoTemplate")
    private JdbcDaoTemplate daoTemplate;

    public ColdShopMember queryByMobile(String mobile, String database) {
        String sql = "select * from " + database + ".shop_member where mobile=?";
        try {
            return this.daoTemplate.queryForObj(sql, ColdShopMember.class, mobile);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }
}
