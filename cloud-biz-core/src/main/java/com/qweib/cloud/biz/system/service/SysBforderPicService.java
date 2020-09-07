package com.qweib.cloud.biz.system.service;

import com.qweib.cloud.core.domain.SysBforderDetail;
import com.qweib.cloud.core.domain.SysBforderPic;
import com.qweib.cloud.repository.SysBforderPicDao;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.*;

/**
 * 商品订单详情图片
 *
 * @author zzx
 */
@Service
public class SysBforderPicService {
    @Resource
    private SysBforderPicDao sysBforderPicDao;

    public int addWarePic(List<SysBforderDetail> detailList, Integer orderId, String database) {
        for (SysBforderDetail sysBforderDetail : detailList) {
            List<SysBforderPic> list = sysBforderDetail.getSysBforderPicList();
            sysBforderPicDao.addWarePic(list, orderId, database);
        }
        return 1;
    }

    public List<SysBforderPic> queryWarePic(String database, SysBforderPic warePic) {
        return sysBforderPicDao.queryWarePic(database, warePic);
    }

    public List<SysBforderPic> queryWarePicByIds(String database, String wids, String oids) {
        return sysBforderPicDao.queryWarePicByIds(database, wids, oids);
    }

    public void setSysBforderDetailPic(String database, List<SysBforderDetail> list) {
        Set<String> wids = new HashSet<>();
        Set<String> oids = new HashSet<>();
        for (SysBforderDetail sysBforderDetail : list) {
            wids.add(sysBforderDetail.getWareId().toString());
            oids.add(sysBforderDetail.getOrderId().toString());
        }
        List<SysBforderPic> pics = sysBforderPicDao.queryWarePicByIds(database, String.join(",", wids), String.join(",", oids));
        Map<String, List<SysBforderPic>> map = new HashMap<>();
        for (SysBforderPic sysBforderPic : pics) {
            String key = sysBforderPic.getWareId() + "," + sysBforderPic.getOrderId();
            List<SysBforderPic> temp = map.get(key);
            if (temp == null) temp = new ArrayList<>();
            temp.add(sysBforderPic);
            map.put(key, temp);
        }
        for (SysBforderDetail sysBforderDetail : list) {
            String key = sysBforderDetail.getWareId() + "," + sysBforderDetail.getOrderId();
            sysBforderDetail.setSysBforderPicList(map.get(key));
        }
    }
}
