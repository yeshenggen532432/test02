package com.qweib.cloud.biz.system.utils;

import com.google.common.collect.Maps;
import com.qweib.cloud.biz.system.service.SysCustomerService;
import com.qweib.cloud.core.domain.SysCustomer;
import com.qweib.cloud.core.domain.SysLoginInfo;
import com.qweib.cloud.core.domain.customer.BaseCustomer;
import com.qweib.cloud.utils.StrUtil;
import com.qweib.commons.Collections3;
import com.qweib.commons.DateUtils;
import com.qweib.commons.MathUtils;
import com.qweib.commons.exceptions.BizException;

import java.util.List;
import java.util.Map;

/**
 * 客户处理类
 */
public class CustomerExecutor {

    private final SysCustomerService customerService;
    private final String database;
    private Map<String, BaseCustomer> customerCache = Maps.newHashMap();
    private final Integer memId;

    public CustomerExecutor(SysCustomerService customerService, String database, Integer memId) {
        this.customerService = customerService;
        this.database = database;
        this.memId = memId;
        initialData();
    }


    /**
     * 获取客户 id
     *
     * @param customerName
     * @param customerAddress
     * @return
     */
    public Integer getCustomer(String customerName, String customerAddress, SysLoginInfo info) {
        /**
         * 检查缓存是否有存在客户
         */
        BaseCustomer baseCustomer = this.customerCache.get(customerName);
        if (baseCustomer != null) {
            //如果地址不同时修改,或删除客户时需要更新
            if ((baseCustomer.getIsDb() != null && baseCustomer.getIsDb() == 3) || (!StrUtil.isNull(customerAddress) && !customerAddress.equals(baseCustomer.getAddress()))) {
                SysCustomer customer = customerService.queryCustomerById(database, baseCustomer.getId());
                customer.setAddress(customerAddress);
                customer.setIsDb(2);
                customerService.updateCustomer(customer, database, null, info);
            }
            return baseCustomer.getId();
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
        customer.setMemId(memId);
        customer.setKhTp(2);
        customer.setCreateTime(DateUtils.getDateTime());
        customer.setIsDb(2);

        Integer customerId = this.customerService.addCustomer(customer, database);
        if (!MathUtils.valid(customerId)) {
            throw new BizException(customerName + "产品，保存客户出错");
        }
        this.customerCache.put(customerName, new BaseCustomer(customerId, customerName, customerAddress, 2));
        return customerId;
    }


    /**
     * 初始化所有产品类别，保存在缓存给后续导入直接调用
     */
    private void initialData() {
        List<BaseCustomer> customers = this.customerService.queryAllBase(database);
        if (Collections3.isNotEmpty(customers)) {
            for (BaseCustomer customer : customers) {
                this.customerCache.put(customer.getName(), customer);
            }
        }
    }
}
