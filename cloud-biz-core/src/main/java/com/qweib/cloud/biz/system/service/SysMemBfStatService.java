package com.qweib.cloud.biz.system.service;

import com.qweib.cloud.core.domain.SysMemBfStat;
import com.qweib.cloud.repository.SysMemBfStatDao;
import com.qweib.cloud.utils.Page;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

@Service
public class SysMemBfStatService {
    @Resource
    private SysMemBfStatDao sysMemBfStatDao;

    public Page queryMemBfStatPage(SysMemBfStat vo, String database, Integer page, Integer limit)
    {
        return this.sysMemBfStatDao.queryMemBfStatPage(vo,database,page,limit);
    }
}
