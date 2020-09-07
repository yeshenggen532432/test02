package com.qweib.cloud.biz.system.service;

import com.qweib.cloud.core.domain.SysChainStore;
import com.qweib.cloud.core.exception.BizException;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.repository.SysChainStoreDao;
import com.qweib.cloud.utils.Page;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

/**
 * @author: yueji.hu
 * @time: 2019-09-06 14:54
 * @description:
 */
@Service
public class SysChainStoreService {
    @Resource
    private SysChainStoreDao sysChainStoreDao;

    public Page queryChainStore(SysChainStore sysChainStore, String database, Integer page, Integer limit){
        try {
            return this.sysChainStoreDao.queryChainStore(sysChainStore, database, page, limit);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    public int addCustomerChainStore(SysChainStore sysChainStore,String database){
        try {
            return this.sysChainStoreDao.addCustomerChainStore(sysChainStore, database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    public int updateCustomerChainStore(SysChainStore sysChainStore,String database){
        try {
            return this.sysChainStoreDao.updateCustomerChainStore(sysChainStore, database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    public int deleteById(Integer id,String database){
        try {
            return this.sysChainStoreDao.deleteById(id, database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }

    }
    public int updateChainStoreState(Integer id,Integer status,String database){
        SysChainStore sysChainStore = sysChainStoreDao.queryChainStoreById(id,database);
        if(status.equals(sysChainStore.getStatus())){
            throw new BizException("已是当前状态不能重复操作");
        }
        return this.sysChainStoreDao.updateChainStoreState(id,status,database);
    }
}
