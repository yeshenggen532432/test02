package com.qweib.cloud.biz.system.service;

import com.qweib.cloud.repository.SysQdTypePriceDao;
import com.qweib.cloud.core.domain.SysQdTypePrice;
import com.qweib.cloud.utils.Page;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service
public class SysQdTypePriceService {
    @Resource
    private SysQdTypePriceDao qdTypePriceDao;


    public Page queryQdTypePrice(SysQdTypePrice levelPrice, int page, int rows, String database) {
        return qdTypePriceDao.queryQdTypePrice(levelPrice, page, rows, database);
    }

    public List<SysQdTypePrice> queryList(SysQdTypePrice levelPrice, String database) {
        return qdTypePriceDao.queryList(levelPrice, database, "");
    }

    public List<SysQdTypePrice> queryList(SysQdTypePrice sysQdTypePrice, String wareIds, String database) {
        return qdTypePriceDao.queryList(sysQdTypePrice, database, wareIds);
    }

    public int addQdTypePrice(SysQdTypePrice levelPrice, String database) {
        return qdTypePriceDao.addQdTypePrice(levelPrice, database);
    }

    public SysQdTypePrice queryQdTypePriceById(Integer levelPriceId, String database) {

        return qdTypePriceDao.queryQdTypePriceById(levelPriceId, database);
    }

    public int updateQdTypePrice(SysQdTypePrice levelPrice, String database) {
        return qdTypePriceDao.updateQdTypePrice(levelPrice, database);
    }

    public int deleteQdTypePrice(Integer id, String database) {
        return qdTypePriceDao.deleteQdTypePrice(id, database);
    }

    public void deleteQdTypeAll(String database) {
        qdTypePriceDao.deleteQdTypePriceAll(database);

    }

    public SysQdTypePrice queryQdTypePrice(SysQdTypePrice typePrice, String database) {

        return qdTypePriceDao.queryQdTypePrice(typePrice, database);
    }

    public SysQdTypePrice queryQdTypePriceByWareIdAndRelaId(Integer relaId, Integer wareId, String database) {
        return qdTypePriceDao.queryQdTypePriceByWareIdAndRelaId(relaId, wareId, database);
    }
}
