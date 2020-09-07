package com.qweib.cloud.biz.system.service;

import com.qweib.cloud.core.domain.SysWare;
import com.qweib.cloud.core.domain.SysWarePic;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.repository.SysWarePicWebDao;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

@Service
public class SysWarePicService {
    @Resource
    private SysWarePicWebDao warePicWebDao;

    /**
     * 查询商品图片列表
     */
    public List<SysWarePic> queryWarePic(SysWarePic warePic, String database) {
        try {
            return this.warePicWebDao.queryWarePic(database, warePic);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    public void queryWarePic(String database, List<? extends SysWare> wares) {
        this.warePicWebDao.queryWarePic(database, wares);
    }

    public Map<Integer, List<SysWarePic>> queryWarePicMap(String wareIds, String database) {
        return this.warePicWebDao.queryWarePicMap(wareIds, database);
    }

    public int updateWareMainPic(String database, Integer wareId, Integer picId) {
        return warePicWebDao.updateWareMainPic(database, wareId, picId);
    }

    public List<SysWarePic> queryWarePic(String database, SysWarePic warePic) {
        return warePicWebDao.queryWarePic(database, warePic);
    }

    public void deleteWarePic(String database, SysWarePic warePice) {
        warePicWebDao.deleteWarePic(database, warePice);
    }

    public int addWarePic(SysWarePic warePic, String database) {
        return warePicWebDao.addWarePic(warePic, database);
    }

    public int updatePic(SysWarePic warePic, String database) {
        return warePicWebDao.updatePic(warePic, database);
    }
}
