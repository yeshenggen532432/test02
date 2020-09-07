package com.qweib.cloud.biz.system.service;

import com.qweib.cloud.core.domain.SysBfFlow;
import com.qweib.cloud.core.domain.SysBfxsxj;
import com.qweib.cloud.repository.SysBfFlowDao;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import javax.xml.crypto.Data;
import java.util.ArrayList;
import java.util.List;

@Service
public class SysBfFlowService {

    @Resource
    private SysBfFlowDao sysBfFlowDao;

    public int addBfFlow(SysBfFlow bo,String database)
    {
        return this.sysBfFlowDao.addFlow(bo,database);
    }

    public int updateBfFlow(SysBfFlow bo,String database)
    {
        return this.sysBfFlowDao.updateFlow(bo,database);
    }

    public int deleteBfFlow(Integer id,String database)
    {
        return this.sysBfFlowDao.deleteFlow(id,database);
    }

    public SysBfFlow getFlowById(Integer id,String database)
    {
        return this.sysBfFlowDao.queryById(id, database);
    }

    public List<SysBfFlow> queryFlowList(String database)
    {
        List<SysBfFlow> list = this.sysBfFlowDao.queryBfFlow(database);
        List<SysBfFlow> retList = new ArrayList<SysBfFlow>();
        SysBfFlow bo1 = new SysBfFlow();
        bo1.setId(0);
        bo1.setStatus(1);
        bo1.setFlowName("拜访签到拍照");
        retList.add(bo1);
        for(SysBfFlow bo: list)
        {
            retList.add(bo);
        }
        bo1 = new SysBfFlow();
        bo1.setId(0);
        bo1.setStatus(1);
        bo1.setFlowName("道谢并告知下次拜访日期");
        retList.add(bo1);
        return retList;
    }
}
