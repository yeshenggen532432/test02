package com.qweib.cloud.biz.system.service;

import com.qweib.cloud.core.domain.SysWaretype;
import com.qweib.cloud.core.domain.SysWaretypePic;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.repository.SysWaretypePicDao;
import com.qweib.cloud.utils.Collections3;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.*;

/**
 * 商品分类图片
 *
 * @author Administrator
 */
@Service
public class SysWaretypePicService {
    @Resource
    private SysWaretypePicDao waretypePicDao;

    public List<SysWaretypePic> queryList(SysWaretypePic model, String database) {
        try {
            return this.waretypePicDao.queryList(model, database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    public void makePic(List<SysWaretype> wareTypes, String datasource) {
        if (Collections3.isEmpty(wareTypes)) return;
        Set<String> ids = new HashSet<>(wareTypes.size());
        for (SysWaretype waretype : wareTypes) {
            ids.add(waretype.getWaretypeId().toString());
        }
        List<SysWaretypePic> list = waretypePicDao.queryList(String.join(",", ids), datasource);
        if (Collections3.isEmpty(list)) return;
        Map<Integer, List<SysWaretypePic>> map = new HashMap<>(list.size());
        for (SysWaretypePic pic : list) {
            List<SysWaretypePic> picList = map.get(pic.getWaretypeId());
            if (picList == null) {
                picList = new ArrayList<>();
                map.put(pic.getWaretypeId(), picList);
            }
            picList.add(pic);
        }
        for (SysWaretype waretype : wareTypes) {
            waretype.setWaretypePicList(map.get(waretype.getWaretypeId()));
        }
    }

    public int addWarePic(SysWaretypePic warePic, String database) {
        return this.waretypePicDao.addWarePic(warePic, database);
    }

    public int deleteByWareTypeId(Integer waretypeId, String database) {
        return this.waretypePicDao.deleteByWareTypeId(waretypeId, database);
    }


}
