package com.qweib.cloud.biz.system.controller.customer.price;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.qweib.cloud.biz.system.controller.customer.price.domain.CustomerPriceModel;
import com.qweib.cloud.biz.system.service.SysCustomerService;
import com.qweib.cloud.biz.system.service.SysWaresService;
import com.qweib.cloud.biz.system.service.SysWaretypeService;
import com.qweib.cloud.biz.system.service.customer.CustomerPriceService;
import com.qweib.cloud.biz.system.utils.CustomerProductExecutor;
import com.qweib.cloud.core.domain.SysCustomer;
import com.qweib.cloud.core.domain.customer.BaseCustomer;
import com.qweib.cloud.core.domain.customer.CustomerPriceData;
import com.qweib.commons.Collections3;
import com.qweib.commons.DateUtils;
import com.qweib.commons.MathUtils;
import com.qweib.commons.StringUtils;
import com.qweib.commons.exceptions.BizException;
import com.qweibframework.excel.message.ErrorMessage;
import lombok.extern.slf4j.Slf4j;

import java.util.List;
import java.util.Map;

/**
 * Description: 导入单条客户价格，期间有可能需要保存产品类别，产品信息，客户信息
 *
 * @author zeng.gui
 * Created on 2019/4/22 - 18:12
 */
@Slf4j
public class CustomerPriceModelExecutor extends BaseModelExecutor<CustomerPriceModel> {

    private final SysCustomerService customerService;
    private final CustomerPriceService customerPriceService;
    private final CustomerProductExecutor productExecutor;

    private Map<String, Integer> customerCache = Maps.newHashMap();

    public CustomerPriceModelExecutor(String database, SysCustomerService customerService,
                                      SysWaretypeService productTypeService, SysWaresService productService,
                                      CustomerPriceService customerPriceService, Integer operatorId) {
        super(database, operatorId);
        this.customerService = customerService;
        this.customerPriceService = customerPriceService;
        this.productExecutor = new CustomerProductExecutor(database, PRODUCT_TYPE_SEPARATOR, productTypeService, productService);
        this.productExecutor.initialData();

        initialData();
    }

    @Override
    public List<ErrorMessage> execute(List<CustomerPriceModel> models) {
        List<ErrorMessage> errors = Lists.newArrayList();
        List<CustomerPriceData> priceDataList = Lists.newArrayListWithCapacity(models.size());
        for (CustomerPriceModel model : models) {
            ErrorMessage errorMessage = execute(priceDataList, model);
            if (errorMessage != null) {
                errors.add(errorMessage);
            }
        }

        try {
            this.repeatCount += this.customerPriceService.saveCustomerPrice(database, priceDataList);
        } catch (Exception e) {
            log.error("execute", e);
        }

        return errors;
    }

    public ErrorMessage execute(List<CustomerPriceData> priceDataList, CustomerPriceModel model) {
        try {
            Integer productId = this.productExecutor.getProduct(model.getProductType(), model.getProductName(), model);

            Integer customerId = getCustomer(model.getCustomerName(), model.getCustomerAddress());

            CustomerPriceData priceData = this.makeCustomerPrice(customerId, productId, model);
            priceDataList.add(priceData);
            return null;
        } catch (BizException e) {
            return new ErrorMessage(model.getRowNum(), e.getMessage());
        }
    }

    private CustomerPriceData makeCustomerPrice(Integer customerId, Integer productId, CustomerPriceModel model) {
        CustomerPriceData priceData = new CustomerPriceData();
        priceData.setCustomerId(customerId);
        priceData.setProductId(productId);
        priceData.setBigUnitTradePrice(StringUtils.toDouble(model.getBigUnitTradePrice()));
        priceData.setSmallUnitTradePrice(StringUtils.toDouble(model.getSmallUnitTradePrice()));

        return priceData;
    }

    /**
     * 获取客户 id
     *
     * @param customerName
     * @param customerAddress
     * @return
     */
    private Integer getCustomer(String customerName, String customerAddress) {
        /**
         * 检查缓存是否有存在客户
         */
        Integer customerId = this.customerCache.get(customerName);
        if (customerId != null) {
            return customerId;
        }

//        SysCustomer customer = customerService.querySysCustomerByName(database, customerName);
//        if (customer != null) {
//            customerId = customer.getId();
//            this.customerCache.put(customerName, customerId);
//            return customerId;
//        }

        SysCustomer customer = new SysCustomer();
        customer.setKhNm(customerName);
        customer.setAddress(customerAddress);
        customer.setMemId(operatorId);
        customer.setKhTp(2);
        customer.setCreateTime(DateUtils.getDateTime());

        customerId = this.customerService.addCustomer(customer, database);
        if (!MathUtils.valid(customerId)) {
            throw new BizException(customerName + "产品，保存客户出错");
        }
        this.customerCache.put(customerName, customerId);
        return customerId;
    }

    /**
     * 初始化所有产品类别，保存在缓存给后续导入直接调用
     */
    private void initialData() {
        List<BaseCustomer> customers = this.customerService.queryAllBase(database);
        if (Collections3.isNotEmpty(customers)) {
            for (BaseCustomer customer : customers) {
                this.customerCache.put(customer.getName(), customer.getId());
            }
        }
    }
}