package com.qweib.cloud.biz.system.service;

import com.qweib.cloud.core.domain.SysQuickMenu;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.repository.SysQuickMenuDao;
import com.qweib.cloud.utils.Page;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

@Service
public class SysQuickMenuService {
    @Resource
    private SysQuickMenuDao sysQuickMenuDao;

    public SysQuickMenu getById(Integer id, String database)
    {
        return sysQuickMenuDao.getById(id, database);
    }

    public int add(SysQuickMenu vo,String database)
    {
        return sysQuickMenuDao.add(vo, database);
    }

    public int delete(Integer id,String database){
        return sysQuickMenuDao.delete(id,database);
    }

    public SysQuickMenu getByMenuId(SysQuickMenu vo, String database){
        return sysQuickMenuDao.getByMenuId(vo,database);
    }
    public int update(SysQuickMenu vo,String database)
    {
        return sysQuickMenuDao.update(vo, database);
    }

    public Page pages(SysQuickMenu vo,String menuIds, String database, Integer page, Integer limit)
    {
        return sysQuickMenuDao.pages(vo,menuIds,database, page, limit);
    }
    public SysQuickMenu queryById(Integer id,String datebase){
        return sysQuickMenuDao.queryById(id,datebase);
    }
    public int updateSort(SysQuickMenu sysQuickMenu,String datebase){
        try {
            return this.sysQuickMenuDao.updateSort(sysQuickMenu, datebase);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }
}
