package com.qweib.cloud.biz.system.service.customer.impl;

import com.qweib.cloud.biz.common.CommonUtil;
import com.qweib.cloud.biz.system.controller.customer.price.BaseModelExecutor;
import com.qweib.cloud.biz.system.controller.customer.price.domain.CustomerPriceModelVo;
import com.qweib.cloud.biz.system.controller.plat.vo.importVo.ImportCustomerPriceVo;
import com.qweib.cloud.biz.system.controller.plat.vo.importVo.ImportResults;
import com.qweib.cloud.biz.system.service.SysWaretypeService;
import com.qweib.cloud.biz.system.service.customer.CustomerPriceService;
import com.qweib.cloud.biz.system.service.customer.CustomerPriceThreadService;
import com.qweib.cloud.biz.system.utils.BaseWareTypeExecutor;
import com.qweib.cloud.core.domain.SysCustomerPrice;
import com.qweib.cloud.core.domain.SysLoginInfo;
import com.qweib.cloud.core.domain.customer.CustomerPriceData;
import com.qweib.cloud.core.domain.customer.CustomerPriceQuery;
import com.qweib.cloud.repository.customer.CustomerPriceDao;
import com.qweib.cloud.utils.JsonUtil;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.annotation.DataSourceAnnotation;
import com.qweibframework.async.handler.AsyncProcessHandler;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;
import java.util.Objects;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2019/4/23 - 15:12
 */
@Slf4j
@Service
public class CustomerPriceServiceImpl implements CustomerPriceService {

    @Autowired
    private CustomerPriceDao customerPriceDao;
    @Resource
    private SysWaretypeService productTypeService;
    @Autowired
    private AsyncProcessHandler asyncProcessHandler;
    @Resource
    private CustomerPriceThreadService customerPriceThreadService;

    @Override
    public SysCustomerPrice getCustomerPrice(CustomerPriceQuery query) {
        return customerPriceDao.getCustomerPrice(query);
    }

    @Override
    public int saveCustomerPrice(String database, List<CustomerPriceData> priceDataList) {
        int repeat = 0;
        int i = 0;
        for (CustomerPriceData priceData : priceDataList) {
            if (priceData.getBigUnitTradePrice() == null && priceData.getSmallUnitTradePrice() == null) {
                continue;
            }
            CustomerPriceQuery query = new CustomerPriceQuery();
            query.setDatabase(database);
            query.setCustomerId(priceData.getCustomerId());
            query.setProductId(priceData.getProductId());
            SysCustomerPrice customerPrice = getCustomerPrice(query);
            if (customerPrice != null) {
                repeat++;
                //如果大小批发价格一样时不操作更新
                if ((priceData.getBigUnitTradePrice() == null || priceData.getBigUnitTradePrice().compareTo(customerPrice.getSaleAmt().doubleValue()) == 0)
                        && (priceData.getSmallUnitTradePrice() == null || priceData.getSmallUnitTradePrice().compareTo(customerPrice.getSunitPrice().doubleValue()) == 0))
                    continue;
                this.customerPriceDao.updateCustomerPrice(database, customerPrice.getId(), priceData);
                customerPrice.getId();
            } else {
                customerPriceDao.saveCustomerPrice(database, priceData);
            }
        }

        return repeat;
    }

    /**
     * 客户价格
     *
     * @param database
     * @param vo
     * @return
     */
    public List<CustomerPriceModelVo> queryCustomerPriceList(String database, CustomerPriceModelVo vo) {
        List<CustomerPriceModelVo> voList = customerPriceDao.queryCustomerPriceList(database, vo);
        if (voList == null || voList.isEmpty()) throw new RuntimeException("暂无数据");
        BaseWareTypeExecutor typeExecutor = new BaseWareTypeExecutor(database, BaseModelExecutor.PRODUCT_TYPE_SEPARATOR, productTypeService);
        for (CustomerPriceModelVo modelVo : voList) {
            Integer wareType = modelVo.getWaretype();
            if (wareType == null || Objects.equals(wareType, 0)) continue;
            modelVo.setProductType(typeExecutor.getProduceNames(wareType));
        }
        return voList;
    }


    @Async
    @Override
    @DataSourceAnnotation(companyId = "#info.fdCompanyId")
    public void changeCustomerPrice(long st, List<ImportCustomerPriceVo> models, SysLoginInfo info, String importId, String taskId, Map<String, String[]> requestParamMap) {
        //allocator.alloc(info.getDatasource(), info.getFdCompanyId());
        ImportResults importResults = new ImportResults();
        try {
            Page page = CommonUtil.makeListToPage(models);
            double pageScale = CommonUtil.div(100, page.getTotalPage());//每页所占比
            double totalScale = CommonUtil.div(100, page.getTotal());//每个所占比例
            for (int i = 0; i < page.getTotalPage(); i++) {
                List<ImportCustomerPriceVo> list = (List<ImportCustomerPriceVo>) page.getRows().get(i);
                customerPriceThreadService.updateImportThreadCustomerPrice(list, info, importId, taskId, pageScale * i, totalScale * list.size(), requestParamMap, importResults, (page.getCurPage() - 1) * page.getPageSize());
            }
        } finally {
            importResults.setSuccessMsg(st);
            asyncProcessHandler.doneTask(taskId, JsonUtil.toJson(importResults));
        }
    }


}
