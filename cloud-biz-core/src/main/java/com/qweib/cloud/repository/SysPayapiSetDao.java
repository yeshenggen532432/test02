package com.qweib.cloud.repository;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.SysPayapiSet;
import com.qweib.cloud.core.exception.DaoException;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
public class SysPayapiSetDao {

    @Resource(name="daoTemplate")
    private JdbcDaoTemplate daoTemplate;

    public int addData(SysPayapiSet bo)
    {
        try{
            return this.daoTemplate.addByObject("publicplat.sys_payapi_set", bo);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public int updateData(SysPayapiSet bo)
    {
        try{
            Map<String,Object> whereParam = new HashMap<String, Object>();
            whereParam.put("id", bo.getId());
            return this.daoTemplate.updateByObject("publicplat.sys_payapi_set", bo, whereParam, "id");
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }


    public SysPayapiSet queryByCompanyId(Integer companyId)
    {
        String sql = "select a.*,b.pay_api_url from publicplat.sys_payapi_set a join publicplat.sys_corporation b on a.company_id=b.dept_id where company_id=" + companyId.toString();
        List<SysPayapiSet> list = this.daoTemplate.queryForLists(sql,SysPayapiSet.class);
        if(list.size() > 0)
        {
            return list.get(0);
        }
        return null;
    }
}
