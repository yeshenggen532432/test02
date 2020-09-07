package com.qweib.cloud.biz.system.service.ws;

import java.util.List;

import javax.annotation.Resource;

import com.qweib.cloud.core.domain.BscAuditZdy;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.repository.ws.BscAuditZdyWebDao;
import com.qweib.cloud.utils.Page;
import org.springframework.stereotype.Service;


@Service
public class BscAuditZdyWebService {
    @Resource
    private BscAuditZdyWebDao auditZdyWebDao;

    /**
     * 说明：添加审批自定义
     *
     * @创建：作者:llp 创建时间：2017-1-13
     * @修改历史： [序号](llp 2017 - 1 - 13)<修改说明>
     */
    public Integer addBscAuditZdy(BscAuditZdy auditZdy, String database) {
        try {
            return this.auditZdyWebDao.addBscAuditZdy(auditZdy, database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 说明：查询审批自定义
     */
    public List<BscAuditZdy> queryAuditZdy(Integer memberId, String database) {
        try {
            return this.auditZdyWebDao.queryAuditZdy(memberId, database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 说明：查询审批自定义
     */
    public List<BscAuditZdy> queryAuditZdyList(Integer memberId, String database, BscAuditZdy bean) {
        try {
            return this.auditZdyWebDao.queryAuditZdyList(memberId, database, bean);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    public BscAuditZdy getAuditZdy(Integer memberId, String database, String zdyNm) {
        return this.auditZdyWebDao.getAuditZdy(memberId, database, zdyNm);
    }

    /**
     * 说明：修改审批自定义
     *
     * @创建：作者:llp 创建时间：2017-1-13
     * @修改历史： [序号](llp 2017 - 1 - 13)<修改说明>
     */
    public int updateAuditZdy(String database,BscAuditZdy bean) {
        try {
            return this.auditZdyWebDao.updateAuditZdy(database, bean);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 说明：删除审批自定义
     *
     * @创建：作者:llp 创建时间：2017-1-13
     * @修改历史： [序号](llp 2017 - 1 - 13)<修改说明>
     */
    public int deleteAuditZdy(String database, Integer id) {
        try {
            return this.auditZdyWebDao.deleteAuditZdy(database, id);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 摘要：判断审批自定义名称唯一
     */
    public int queryAuditZdyNmCount(String database, Integer memberId, String zdyNm) {
        try {
            return this.auditZdyWebDao.queryAuditZdyNmCount(database, memberId, zdyNm);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }


    /**
     * 摘要：根据id获取审批自定义
     */
    public BscAuditZdy queryAuditZdyById(Integer id, String database) {
        try {
            return this.auditZdyWebDao.queryAuditZdyById(id, database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 根据modeId查询审批流列表
     * 默认：启用
     */
    public List<BscAuditZdy> queryAuditZdyListByModelId( String database,Integer modelId, Integer status) {
        try {
            return auditZdyWebDao.queryAuditZdyListByModelId(database, modelId, status);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 根据modeId查询审批流列表
     * 默认：启用
     */
    public Page queryAuditZdyPageByModelId(String database, Integer modelId, Integer page, Integer rows) {
        try {
            return auditZdyWebDao.queryAuditZdyPageByModelId(database, modelId, page, rows);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    public BscAuditZdy queryAuditZdyByName(String database, String name){
        return auditZdyWebDao.queryAuditZdyByName(database, name);
    }



}
