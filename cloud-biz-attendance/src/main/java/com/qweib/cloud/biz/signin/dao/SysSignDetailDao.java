package com.qweib.cloud.biz.signin.dao;

import com.qweib.cloud.biz.signin.model.SysSignDetail;
import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.exception.DaoException;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.List;

@Repository
public class SysSignDetailDao {
    @Resource(name="daoTemplate")
    private JdbcDaoTemplate daoTemplate;

    public int addData(SysSignDetail bo,String database)
    {
        try {
            return this.daoTemplate.addByObject(""+database+".sys_sign_detail", bo);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public List<SysSignDetail> queryDetailList(Integer signId,String database)
    {
        String sql = "select * from " + database + ".sys_sign_detail where sign_id=" + signId.toString();
        return this.daoTemplate.queryForLists(sql,SysSignDetail.class);
    }
}

