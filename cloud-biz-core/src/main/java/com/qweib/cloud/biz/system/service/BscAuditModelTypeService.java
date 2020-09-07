package com.qweib.cloud.biz.system.service;

import com.qweib.cloud.core.domain.BscAuditModel;
import com.qweib.cloud.core.domain.BscAuditModelType;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.repository.BscAuditModelTypeDao;
import com.qweib.cloud.repository.ws.BscAuditModelDao;
import com.qweib.cloud.utils.Page;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

/**
 * 审批模板
 */
@Service
public class BscAuditModelTypeService {

    @Resource
    private BscAuditModelDao auditModelDao;
    @Resource
    private BscAuditModelTypeDao auditModelTypeDao;

    /**
     * 批量添加审批模板类型科目
     */
    public int[] batchAddAuditModelType(String database,Integer modelId, List<BscAuditModelType> list){
        return auditModelTypeDao.batchAddAuditModeType(database, modelId,list);
    }
    /**
     * 批量删除审批模板类型科目
     */
    public int batchDelAuditModeType(String database,String ids){
        return auditModelTypeDao.batchDelAuditModeType(database,ids);
    }

    /**
     *  审批模板类型科目：分页的
     */
    public Page queryAuditModelType( String database,BscAuditModelType bean, Integer page, Integer limit) {
        try {
            return this.auditModelTypeDao.queryAuditModelType(bean, database, page, limit);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }
//
//    /**
//     * 审批模板：全部数据
//     */
//    public List<BscAuditModel> queryAuditModelList(BscAuditModel bean, String database) {
//        try {
//            return this.auditModelDao.queryAuditModelList(bean, database);
//        } catch (Exception e) {
//            throw new ServiceException(e);
//        }
//    }
//    /**
//     * 审批模板：过滤没有类型的
//     */
//    public List<BscAuditModel> queryAuditModelListByNoType(BscAuditModel bean, String database) {
//        try {
//            return this.auditModelDao.queryAuditModelListByNoType(bean, database);
//        } catch (Exception e) {
//            throw new ServiceException(e);
//        }
//    }
//    /**
//     * 审批模板：单个
//     */
//    public BscAuditModel queryAuditModelById(Integer id, String database) {
//        try {
//            return this.auditModelDao.queryAuditModelById(id, database);
//        } catch (Exception e) {
//            throw new ServiceException(e);
//        }
//    }

}
