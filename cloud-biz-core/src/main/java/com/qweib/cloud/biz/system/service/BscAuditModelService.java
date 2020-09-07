package com.qweib.cloud.biz.system.service;

import com.qweib.cloud.core.domain.BscAuditModel;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.repository.ws.BscAuditModelDao;
import com.qweib.cloud.utils.Page;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

/**
 * 审批模板
 */
@Service
public class BscAuditModelService {

    @Resource
    private BscAuditModelDao auditModelDao;

    /**
     *  审批模板：分页的
     */
    public Page queryAuditModelPage(BscAuditModel bean, String database, Integer page, Integer limit) {
        try {
            return this.auditModelDao.queryAuditModelPage(bean, database, page, limit);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 审批模板：全部数据
     */
    public List<BscAuditModel> queryAuditModelList(BscAuditModel bean, String database) {
        try {
            return this.auditModelDao.queryAuditModelList(bean, database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }
    /**
     * 审批模板：过滤没有类型的
     */
    public List<BscAuditModel> queryAuditModelListByNoType(BscAuditModel bean, String database) {
        try {
            return this.auditModelDao.queryAuditModelListByNoType(bean, database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }
    /**
     * 审批模板：单个
     */
    public BscAuditModel queryAuditModelById(Integer id, String database) {
        try {
            return this.auditModelDao.queryAuditModelById(id, database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

}
