package com.qweib.cloud.biz.system.service;

import com.qweib.cloud.core.domain.SysWareGroup;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.repository.SysWareGroupDao;
import com.qweib.cloud.utils.Page;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

/**
 * @author: yueji.hu
 * @time: 2019-09-05 11:36
 * @description:
 */
@Service
public class SysWareGroupService {
    @Resource
    private SysWareGroupDao sysWareGroupDao;

    public Page wareGroupPage(SysWareGroup sysWareGroup, String database, Integer page, Integer limit){
        try {
            return this.sysWareGroupDao.wareGroupPage(sysWareGroup, database, page, limit);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    public int addWareGroupName(SysWareGroup sysWareGroup,String database){
        try {
            return this.sysWareGroupDao.addWareGroupName(sysWareGroup, database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    public int updateWareGroupName(SysWareGroup sysWareGroup,String database){
        try {
            return this.sysWareGroupDao.updateWareGroupName(sysWareGroup, database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    public int deleteGroupById(Integer Id,String database){
        try {
            return this.sysWareGroupDao.deleteGroupById(Id, database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }

    }
}
