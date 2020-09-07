package com.qweib.cloud.repository;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.SysBfFlow;
import com.qweib.cloud.core.exception.DaoException;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
public class SysBfFlowDao {

    @Resource(name="daoTemplate")
    private JdbcDaoTemplate daoTemplate;

    public int addFlow(SysBfFlow bo, String database)
    {
        try {
            bo.setId(null);
            return this.daoTemplate.addByObject(""+database+".sys_bf_flow", bo);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public int updateFlow(SysBfFlow bo, String database)
    {
        try {
            Map<String,Object> whereParam = new HashMap<String, Object>();
            whereParam.put("id", bo.getId());
            return this.daoTemplate.updateByObject(""+database+".sys_bf_flow", bo, whereParam, "id");
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public int deleteFlow(Integer id,String database)
    {
        String sql = "delete from " + database + ".sys_bf_flow  where id=" + id;
        return this.daoTemplate.update(sql);
    }

    public SysBfFlow queryById(Integer id, String database)
    {
        String sql = "select * from " + database + ".sys_bf_flow where id = " + id.toString();
        List<SysBfFlow> list = this.daoTemplate.queryForLists(sql, SysBfFlow.class);
        if(list.size() > 0)return list.get(0);
        return null;
    }

    public List<SysBfFlow> queryBfFlow(String database)
    {
        String sql = "select * from " + database + ".sys_bf_flow order by seq_no asc ";
        return this.daoTemplate.queryForLists(sql, SysBfFlow.class);
    }
}
