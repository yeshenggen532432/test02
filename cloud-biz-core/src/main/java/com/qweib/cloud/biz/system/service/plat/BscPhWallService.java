package com.qweib.cloud.biz.system.service.plat;

import com.qweib.cloud.core.domain.BscPhotoWall;
import com.qweib.cloud.core.domain.BscPhotoWallPic;
import com.qweib.cloud.core.domain.SysLoginInfo;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.repository.company.BscPhWallDao;
import com.qweib.cloud.utils.Page;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service
public class BscPhWallService {
    @Resource
    private BscPhWallDao phWallDao;

    /**
     * 摘要：查询照片墙
     *
     * @param @param  phWall
     * @param @param  page
     * @param @param  rows
     * @param @return
     * @说明：
     * @创建：作者:YYP 创建时间：2014-4-23
     * @修改历史： [序号](YYP 2014 - 4 - 23)<修改说明>
     */
    public Page queryPhWall(BscPhotoWall phWall, int page, int rows, SysLoginInfo info) {
        try {
            return this.phWallDao.queryPhWall(phWall, page, rows, info);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 摘要：根据id查找照片墙照片
     *
     * @param @param  wallId
     * @param @return
     * @说明：
     * @创建：作者:YYP 创建时间：2014-4-23
     * @修改历史： [序号](YYP 2014 - 4 - 23)<修改说明>
     */
    public List<BscPhotoWallPic> queryphWallPic(long wallId, String database) {
        try {
            return this.phWallDao.queryphWallPic(wallId, database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 摘要：删除照片墙照片
     *
     * @param @param  picId
     * @param @return
     * @说明：
     * @创建：作者:YYP 创建时间：2014-4-23
     * @修改历史： [序号](YYP 2014 - 4 - 23)<修改说明>
     */
    public long deletePic(long picId, String database) {
        try {
            return this.phWallDao.deletePic(picId, database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 摘要：照片墙置顶
     *
     * @param @param wallId
     * @说明：
     * @创建：作者:YYP 创建时间：2014-6-10
     * @修改历史： [序号](YYP 2014 - 6 - 10)<修改说明>
     */
    public void updatePhotoWallToTop(Integer wallId, String database) {
        try {
            this.phWallDao.updatePhotoWallToTop(wallId, database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }
}
