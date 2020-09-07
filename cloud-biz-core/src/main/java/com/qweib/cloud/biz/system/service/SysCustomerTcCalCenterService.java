package com.qweib.cloud.biz.system.service;

import com.qweib.cloud.biz.common.CnlifeConstants;
import com.qweib.cloud.core.domain.*;
import com.qweib.cloud.core.domain.customer.BaseCustomer;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.repository.*;
import com.qweib.cloud.repository.company.SysDeptmempowerDao;
import com.qweib.cloud.repository.plat.ShopMemberCompanyDao;
import com.qweib.cloud.repository.plat.SysCorporationDao;
import com.qweib.cloud.repository.plat.SysMemberDao;
import com.qweib.cloud.repository.plat.ws.SysMemberWebDao;
import com.qweib.cloud.repository.ws.SysDepartDao;
import com.qweib.cloud.utils.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.math.BigDecimal;
import java.util.*;

@Service
public class SysCustomerTcCalCenterService {
    @Resource
    private SysCustomerLevelTcFactorDao customerLevelTcFactorDao;
    @Resource
    private SysCustomerLevelTcRateDao customerLevelTcRateDao;
    @Resource
    private SysQdTypeTcFactorDao qdTypeTcFactorDao;
    @Resource
    private SysQdTypeTcRateDao qdTypeTcRateDao;

    public void calCustomerWareTcFactor(List<Map<String,Object>> datas,String database){

        if(datas==null||datas.size()==0){
            return;
        }
        //客户类型对应商品类别提成系数
        List<SysQdTypeTcRate> sysQdTypeTcRateList = qdTypeTcRateDao.queryList(null,database);
        for(int i=0;i<datas.size();i++){
          Map<String,Object> data = datas.get(i);
          Object qdtpNm = data.get("qdtpNm");
            

        }
        //客户类型对应商品信息提成系数
        List<SysQdTypeTcFactor> qdTypeTcFactorList = qdTypeTcFactorDao.queryList(null,database);

        //客户等级对应商品类别提成系数
        List<SysCustomerLevelTcRate> customerLevelTcRateList = customerLevelTcRateDao.queryList(null,database);
        //考核等级对应商品信息提成系数
        List<SysCustomerLevelTcFactor> levelTcFactorList =  customerLevelTcFactorDao.queryList(null,database);
    }


    }
