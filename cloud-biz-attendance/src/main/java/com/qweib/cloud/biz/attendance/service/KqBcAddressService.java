package com.qweib.cloud.biz.attendance.service;

import com.qweib.cloud.biz.attendance.dao.KqBcAddressDao;
import com.qweib.cloud.biz.attendance.model.KqAddress;
import com.qweib.cloud.core.domain.BscAuditZdy;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.repository.ws.BscAuditZdyWebDao;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

/**
 * 考勤班次地址
 */
@Service
public class KqBcAddressService {
    @Resource
    private KqBcAddressDao kqBcAddressDao;

//    /**
//     * 说明：添加审批自定义
//     *
//     * @创建：作者:llp 创建时间：2017-1-13
//     * @修改历史： [序号](llp 2017 - 1 - 13)<修改说明>
//     */
//    public Integer addBscAuditZdy(BscAuditZdy auditZdy, String database) {
//        try {
//            return this.auditZdyWebDao.addBscAuditZdy(auditZdy, database);
//        } catch (Exception e) {
//            throw new ServiceException(e);
//        }
//    }
//
//    /**
//     * 说明：查询审批自定义
//     */
//    public List<BscAuditZdy> queryAuditZdy(Integer memberId, String database) {
//        try {
//            return this.auditZdyWebDao.queryAuditZdy(memberId, database);
//        } catch (Exception e) {
//            throw new ServiceException(e);
//        }
//    }
//
//    /**
//     * 说明：查询审批自定义
//     */
//    public List<BscAuditZdy> queryAuditZdyList(Integer memberId, String database, BscAuditZdy bean) {
//        try {
//            return this.auditZdyWebDao.queryAuditZdyList(memberId, database, bean);
//        } catch (Exception e) {
//            throw new ServiceException(e);
//        }
//    }
//
//    public BscAuditZdy getAuditZdy(Integer memberId, String database, String zdyNm) {
//        return this.auditZdyWebDao.getAuditZdy(memberId, database, zdyNm);
//    }
//
//    /**
//     * 说明：修改审批自定义
//     *
//     * @创建：作者:llp 创建时间：2017-1-13
//     * @修改历史： [序号](llp 2017 - 1 - 13)<修改说明>
//     */
//    public int updateAuditZdy(String database,BscAuditZdy bean) {
//        try {
//            return this.auditZdyWebDao.updateAuditZdy(database, bean);
//        } catch (Exception e) {
//            throw new ServiceException(e);
//        }
//    }
//
//    /**
//     * 说明：删除审批自定义
//     *
//     * @创建：作者:llp 创建时间：2017-1-13
//     * @修改历史： [序号](llp 2017 - 1 - 13)<修改说明>
//     */
//    public int deleteAuditZdy(String database, Integer id) {
//        try {
//            return this.auditZdyWebDao.deleteAuditZdy(database, id);
//        } catch (Exception e) {
//            throw new ServiceException(e);
//        }
//    }
//
//    /**
//     * 摘要：
//     *
//     * @说明：判断审批自定义名称唯一
//     * @创建：作者:llp 创建时间：2017-1-19
//     * @修改历史： [序号](llp 2017 - 1 - 19)<修改说明>
//     */
//    public int queryAuditZdyNmCount(String database, Integer memberId, String zdyNm) {
//        try {
//            return this.auditZdyWebDao.queryAuditZdyNmCount(database, memberId, zdyNm);
//        } catch (Exception e) {
//            throw new ServiceException(e);
//        }
//    }
//
//
//    /**
//     * 摘要：
//     *
//     * @说明：根据id获取审批自定义
//     * @创建：作者:llp 创建时间：2017-1-19
//     * @修改历史： [序号](llp 2017 - 1 - 19)<修改说明>
//     */
//    public BscAuditZdy queryAuditZdyById(Integer id, String database) {
//        try {
//            return this.auditZdyWebDao.queryAuditZdyById(id, database);
//        } catch (Exception e) {
//            throw new ServiceException(e);
//        }
//    }


    //------------------------------------------------------

    /**
     * 根据“地址”查询考勤班次地址
     */
    public KqAddress queryKqBcAddressByAddress(String database, String address) {
        try {
            return this.kqBcAddressDao.queryKqBcAddressByAddress(database, address);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 根据id查询
     */
    public KqAddress queryById(String database, Integer id) {
        try {
            return this.kqBcAddressDao.queryById(database, id);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 说明：查询审批自定义
     */
    public List<KqAddress> queryList(String database, KqAddress bean) {
        try {
            return this.kqBcAddressDao.queryList(database, bean);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 添加
     */
    public Integer add(String database, KqAddress bean) {
        try {
            return this.kqBcAddressDao.add(database, bean);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 修改
     */
    public int update(String database,KqAddress bean) {
        try {
            return this.kqBcAddressDao.update(database, bean);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }
}
