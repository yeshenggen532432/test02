package com.qweib.cloud.biz.system.service;

import com.qweib.cloud.core.domain.Company;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.repository.CompanyInfoDao;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

/**
 * @author: yueji.hu
 * @time: 2019-09-10 10:47
 * @description:
 */
@Service
public class CompanyService {
    @Resource
    private CompanyInfoDao companyInfoDao;

    public Company query(String database) {
        try {
            return this.companyInfoDao.query(database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    public int addModel(Company model, String database) {
        try {
            return this.companyInfoDao.addModel(model, database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }

    }

    public int updataModel(Company model, String database) {
        try {

            return this.companyInfoDao.updataModel(model, database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }
}
