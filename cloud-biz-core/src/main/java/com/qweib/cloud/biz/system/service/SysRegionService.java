package com.qweib.cloud.biz.system.service;

import com.qweib.cloud.core.domain.SysRegion;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.repository.SysRegionDao;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service
public class SysRegionService {
    @Resource
    private SysRegionDao regionDao;


    public Integer queryOneregion(SysRegion type, String database) {
        try {
            return this.regionDao.queryOneRegion(type, database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    public String queryWarePath(Integer region, String database) {
        try {
            return this.regionDao.queryWarePath(region, database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    public List<SysRegion> queryregion(SysRegion type, String database) {
        try {
            return this.regionDao.queryRegion(type, database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    public List<SysRegion> queryList(SysRegion type, String database) {
        try {
            return this.regionDao.queryList(type, database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    public int addregion(SysRegion region, String database) {
        try {
            this.regionDao.addRegion(region, database);
            int autoId = this.regionDao.queryAutoId();
            region.setRegionId(autoId);
            //修改上级leaf为0
            if (null != region.getRegionPid() && region.getRegionPid() > 0) {
                this.regionDao.updateRegionLeaf(region.getRegionPid(), "0", database);
            }
            //修改path
            String path;
            if (null != region.getRegionPid() && region.getRegionPid() > 0) {
                SysRegion parent = this.regionDao.queryRegionById(region.getRegionPid(), database);
                path = parent.getRegionPath() + autoId + "-";
            } else {
                path = "-" + autoId + "-";
            }
            this.regionDao.updateRegionPath(autoId, path, database);
            return 1;
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    public SysRegion queryRegionById(Integer regionId, String database) {
        try {
            return this.regionDao.queryRegionById(regionId, database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    public int updateRegion(SysRegion region, String database) {
        try {
            return this.regionDao.updateRegion(region, database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    public void deleteRegion(SysRegion region, String database) {
        try {
            int count = this.regionDao.queryRegionInt(region.getRegionPid(), database);
            if (count == 1) {
                this.regionDao.updateRegionLeaf(region.getRegionPid(), "1", database);
            }
            this.regionDao.deleteRegion(region.getRegionId(), database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }


    public int queryRegionNmCount(String regionNm, String database) {
        try {
            return this.regionDao.queryRegionNmCount(regionNm, database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    public SysRegion getRegionByName(String regionNm, String database) {
        return this.regionDao.getRegionByName(regionNm, database);
    }
}
