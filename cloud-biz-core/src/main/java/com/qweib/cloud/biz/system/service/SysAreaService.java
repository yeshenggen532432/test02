package com.qweib.cloud.biz.system.service;

import com.qweib.cloud.core.domain.SysArea;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.repository.SysAreaDao;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

/**
 * 地区
 *
 * @author zzx
 */
@Service
public class SysAreaService {

    @Resource
    private SysAreaDao sysAreaDao;

    /**
     * 根据上级ID获取子列表
     *
     * @param parentId 上级ID
     * @return
     */
    public List<SysArea> getChild(Integer parentId) {
        try {
            return this.sysAreaDao.getChild(parentId);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 获取省和市 两级
     *
     * @return
     */
    public List<SysArea> getProvinceAndCity() {
        List<SysArea> list = getChild(0);
        for (SysArea sysArea : list) {
            if (sysArea == null) continue;
            sysArea.setChildren(getChild(sysArea.getAreaId()));
        }
        return list;
    }
}
