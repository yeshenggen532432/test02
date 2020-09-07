package com.qweib.cloud.repository;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.Company;
import com.qweib.cloud.core.exception.DaoException;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.Map;

/**
 * @author: yueji.hu
 * @time: 2019-09-10 10:48
 * @description:
 */
@Repository
public class CompanyInfoDao {
    @Resource(name = "daoTemplate")
    private JdbcDaoTemplate daoTemplate;

    public Company query(String database) {
        String sql = "select * from " + database + ".company_info";
        try {
            return this.daoTemplate.queryForObj(sql, Company.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public int addModel(Company model,String database){
        try{
            return this.daoTemplate.addByObject("" +database + ".company_info",model);
        }catch (Exception e){
            throw new DaoException(e);
        }

    }

    public int updataModel(Company model,String database){
        try{
            Map<String, Object> whereParam = new HashMap<String, Object>();
            whereParam.put("id", model.getId());
            return this.daoTemplate.updateByObject(""+database+".company_info", model, whereParam,null);
        }catch (Exception e){
            throw  new DaoException(e);
        }

    }
}
