package com.qweib.cloud.biz.system.service;

import com.qweib.cloud.core.domain.*;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.repository.SysCompanyJoinDao;
import com.qweib.cloud.utils.Page;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

@Service
public class SysCompanyJoinService {
    @Resource
    private SysCompanyJoinDao companyJoinDao;




    /**
     *  添加：申请加入公司
     */
    public int addCompanyJoin(SysCompanyJoin companyJoin, String datasource) throws ServiceException{
        return companyJoinDao.addCompanyJoin(companyJoin, datasource);
    }
    /**
     *  修改是否同意状态
     */
    public int updateStatusCompanyJoin( String datasource, Integer id, String agree, Integer userId) throws ServiceException{
        return companyJoinDao.updateStatusCompanyJoin(datasource, id, agree, userId);
    }

    /**
     *  删除
     */
    public int deleteCompanyJoin(String database, String ids) {
        try {
            return this.companyJoinDao.deleteCompanyJoin(database, ids);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 查询：申请加入公司
     */
    public Page queryCompanyJoinPage(SysCompanyJoin companyJoin, String datasource, Integer page, Integer rows) {
        try {
            return this.companyJoinDao.queryCompanyJoinPage(companyJoin, datasource, page, rows);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }






}
