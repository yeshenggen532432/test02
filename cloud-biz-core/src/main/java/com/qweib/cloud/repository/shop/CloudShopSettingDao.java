package com.qweib.cloud.repository.shop;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.shop.ShopSetting;
import com.qweib.cloud.core.exception.DaoException;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;

@Repository
public class CloudShopSettingDao {

    @Resource(name = "daoTemplate")
    private JdbcDaoTemplate daoTemplate;

    public ShopSetting queryByName(String name, String database) {
        String sql = " select * from " + database + ".shop_setting where name=?";
        try {
            return this.daoTemplate.queryForObj(sql, ShopSetting.class, name);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }


}
