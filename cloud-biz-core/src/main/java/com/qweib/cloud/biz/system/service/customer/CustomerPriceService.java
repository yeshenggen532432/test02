package com.qweib.cloud.biz.system.service.customer;

import com.qweib.cloud.biz.system.controller.customer.price.domain.CustomerPriceModelVo;
import com.qweib.cloud.biz.system.controller.plat.vo.importVo.ImportCustomerPriceVo;
import com.qweib.cloud.core.domain.SysCustomerPrice;
import com.qweib.cloud.core.domain.SysLoginInfo;
import com.qweib.cloud.core.domain.customer.CustomerPriceData;
import com.qweib.cloud.core.domain.customer.CustomerPriceQuery;

import java.util.List;
import java.util.Map;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2019/4/23 - 15:11
 */
public interface CustomerPriceService {

    SysCustomerPrice getCustomerPrice(CustomerPriceQuery query);

    int saveCustomerPrice(String database, List<CustomerPriceData> priceDataList);

    List<CustomerPriceModelVo> queryCustomerPriceList(String database, CustomerPriceModelVo vo);

    void changeCustomerPrice(long st, List<ImportCustomerPriceVo> models, SysLoginInfo info, String importId, String taskId, Map<String, String[]> requestParamMap);
}
