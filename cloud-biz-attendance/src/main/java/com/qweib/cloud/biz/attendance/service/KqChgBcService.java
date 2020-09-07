package com.qweib.cloud.biz.attendance.service;

import com.qweib.cloud.biz.attendance.dao.KqChgBcDao;
import com.qweib.cloud.biz.attendance.dao.KqPbDao;
import com.qweib.cloud.biz.attendance.model.KqChgBc;
import com.qweib.cloud.biz.attendance.model.KqPb;
import com.qweib.cloud.utils.Page;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service
public class KqChgBcService {

    @Resource
    private KqChgBcDao chgBcDao;

    @Resource
    private KqPbDao pbDao;


    //调班
    public int addChgBc(KqChgBc bo, String database) {
        this.pbDao.deleteKqPbByEmpDate(bo.getMemberId(), bo.getFromDate(), database);
        this.pbDao.deleteKqPbByEmpDate(bo.getMemberId(), bo.getToDate(), database);
        //保存排班记录
        KqPb pb = new KqPb();
        pb.setBcDate(bo.getFromDate());
        pb.setMemberId(bo.getMemberId());
        pb.setBcId(bo.getBcId2());
        this.pbDao.addKqPb(pb, database);
        KqPb pb2 = new KqPb();
        pb2.setBcDate(bo.getToDate());
        pb2.setMemberId(bo.getMemberId());
        pb2.setBcId(bo.getBcId1());
        this.pbDao.addKqPb(pb2, database);
        int ret = this.chgBcDao.addChgBc(bo, database);
        return ret;
    }


    public Page queryChgBcPage(KqChgBc vo, String database, Integer page, Integer limit) {
        Page p = this.chgBcDao.queryKqJiaPage(vo, database, page, limit);
        List<KqChgBc> list = p.getRows();
        for (KqChgBc vo1 : list) {
            if (vo1.getBcId1() == null) vo1.setBcName1("休");
            else {
                if (vo1.getBcId1().intValue() <= 0) vo1.setBcName1("休");
            }

            if (vo1.getBcId2() == null) vo1.setBcName2("休");
            else {
                if (vo1.getBcId2().intValue() <= 0) vo1.setBcName2("休");
            }
        }

        return p;
    }

}
