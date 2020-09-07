package com.qweib.cloud.repository;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.SysChainStore;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.Map;

/**
 * @author: yueji.hu
 * @time: 2019-09-06 14:55
 * @description:
 */
@Repository
public class SysChainStoreDao {
    @Resource(name="daoTemplate")
    private JdbcDaoTemplate daoTemplate;


    public Page queryChainStore(SysChainStore sysChainStore, String database, Integer page, Integer limit){
        StringBuilder sql = new StringBuilder();
        sql.append("select * from "+database+".sys_chain_store where 1=1");
        if(null!=sysChainStore){
            if(!StrUtil.isNull(sysChainStore.getStoreName())){
                sql.append(" and store_name like '%"+sysChainStore.getStoreName()+"%' ");
            }
            if (sysChainStore.getStatus()!=null) {
                if(sysChainStore.getStatus().equals(1)){
                    sql.append(" and (status is null or status= '").append(sysChainStore.getStatus()).append("')");
                }else{
                    sql.append(" and status= '").append(sysChainStore.getStatus()).append("'");
                }
            }
        }
        sql.append(" order by id desc");
        try {
            return this.daoTemplate.queryForPageByMySql(sql.toString(), page, limit, SysChainStore.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public int addCustomerChainStore(SysChainStore sysChainStore, String database){
        try{
            return this.daoTemplate.addByObject(database+".sys_chain_store", sysChainStore);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public int updateCustomerChainStore(SysChainStore sysChainStore, String database){
        try{
            Map<String,Object> whereParam = new HashMap<String, Object>();
            whereParam.put("id", sysChainStore.getId());
            return this.daoTemplate.updateByObject(database+".sys_chain_store", sysChainStore, whereParam, "id");
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public int deleteById(Integer id,String database){
        try{
            String sql = "delete  from "+database+".sys_chain_store where id=? ";
            return this.daoTemplate.update(sql, id);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }
    public int updateChainStoreState(Integer id,Integer status,String database){
        String sql = "update "+database+".sys_chain_store set status=? where id=?";
        try{
            return this.daoTemplate.update(sql,status,id);
        }catch (Exception e){
            throw  new DaoException(e);
        }

    }
    public SysChainStore queryChainStoreById(Integer id,String database){
        String sql = "select * from "+database+".sys_chain_store where id= ?";
        try{
            return this.daoTemplate.queryForObj(sql,SysChainStore.class,id);
        }catch (Exception e){
            throw new DaoException(e);
        }
    }
}
