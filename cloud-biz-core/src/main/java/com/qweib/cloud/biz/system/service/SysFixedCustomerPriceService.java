package com.qweib.cloud.biz.system.service;

import com.google.common.collect.Lists;
import com.qweib.cloud.core.domain.SysFixedCustomerPrice;
import com.qweib.cloud.core.domain.SysFixedCustomerPriceSumVo;
import com.qweib.cloud.core.domain.SysfixedCustomerPriceDTO;
import com.qweib.cloud.core.exception.BizException;
import com.qweib.cloud.repository.SysFixedCustomerPriceDao;
import com.qweib.cloud.utils.Page;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

@Service
public class SysFixedCustomerPriceService {
    @Resource
    private SysFixedCustomerPriceDao fixedCustomerPriceDao;


    public Page queryFixedCustomerPrice(SysFixedCustomerPrice model, int page, int rows, String database) {
        return fixedCustomerPriceDao.queryFixedCustomerPrice(model, page, rows, database);
    }

    public List<SysFixedCustomerPrice> queryList(SysFixedCustomerPrice model, String database) {
        return fixedCustomerPriceDao.queryList(model, database);
    }


    public int addFixedCustomerPrice(SysFixedCustomerPrice model, String database) {
        return fixedCustomerPriceDao.addFixedCustomerPrice(model, database);
    }

    public List<Integer> addCustomerPrice(List<Integer> customerIds, String database) {
        List<Integer> ids = Lists.newArrayList();

        for (Integer id : customerIds) {
            if (fixedCustomerPriceDao.countByCustomerId(id, database) > 0) {
                continue;
            }
            SysFixedCustomerPrice p1 = new SysFixedCustomerPrice();
            p1.setCustomerId(id);
            p1.setFixedId(1);
            ids.add(fixedCustomerPriceDao.addFixedCustomerPrice(p1, database));
            SysFixedCustomerPrice p2 = new SysFixedCustomerPrice();
            p2.setCustomerId(id);
            p2.setFixedId(2);
            ids.add(fixedCustomerPriceDao.addFixedCustomerPrice(p2, database));
        }
        return ids;
    }


    public int updateFixedCustomerPrice(SysFixedCustomerPrice model, String database) {
        return fixedCustomerPriceDao.updateFixedCustomerPrice(model, database);
    }

    public List<Map<String,Object>> getCustomerPriceList(String keyword, String status, String month, String allowEmptyMonth,String customerIds,Integer fixedId, String database){
        return fixedCustomerPriceDao.getCustomerPriceList(keyword,status,month,allowEmptyMonth,customerIds,fixedId,database);
    }

    public Page queryCustomer(Integer page, Integer rows, String keyword, String status, String month,String allowEmptyMonth,String database) {
        Page p = fixedCustomerPriceDao.queryCustomer(page, rows, keyword, status, month,allowEmptyMonth, database);
        if (p.getRows().size() == 0) {
            return p;
        }
        List<SysFixedCustomerPriceSumVo> customerPriceSum = this.fixedCustomerPriceDao.getCustomerPriceSum(keyword, status, month,allowEmptyMonth, database);

        SysfixedCustomerPriceDTO sysfixedCustomerPriceDTO = new SysfixedCustomerPriceDTO();
        sysfixedCustomerPriceDTO.setSysFixedCustomerPriceSumVos(customerPriceSum);
        sysfixedCustomerPriceDTO.setTotal(p.getTotal());
        sysfixedCustomerPriceDTO.setRows(p.getRows());
        return sysfixedCustomerPriceDTO;
    }

    public Page queryNoneCustomerPrice(Integer page, Integer rows, String khNm, Integer qdtypeId, String database) {
        return fixedCustomerPriceDao.queryNoneCustomerPrice(page, rows, khNm, qdtypeId, database);
    }

    public List<SysFixedCustomerPrice> queryCustomerPrice(List<Integer> customerIds, String datasource) {
        return fixedCustomerPriceDao.queryCustomerPrice(customerIds, datasource);
    }

    public int deleteByCustomerId(Integer customerId, String month, String database) {
        return fixedCustomerPriceDao.deleteByCustomerId(customerId, month, database);
    }

    public int updateCustomerStatus(Integer customerId, String month, String status, String database) {
        SysFixedCustomerPrice sysFixedCustomerPrice = fixedCustomerPriceDao.queryFixedCustomerPriceById(customerId,month,database);
        if(status.equals(sysFixedCustomerPrice.getStatus())){
            throw new BizException("已是当前状态不能重复操作");
        }
        return fixedCustomerPriceDao.updateCustomerStatus(customerId, month, status, database);
    }

    public void updateMonth(String database, Integer customerId, String month, String oldMonth) {
        fixedCustomerPriceDao.updateMonth(database, customerId, month, oldMonth);
    }
}
