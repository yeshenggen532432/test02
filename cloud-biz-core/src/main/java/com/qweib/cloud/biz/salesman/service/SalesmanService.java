package com.qweib.cloud.biz.salesman.service;

import com.qweib.cloud.biz.salesman.pojo.dto.*;
import com.qweib.cloud.biz.salesman.pojo.input.PushMoneyTypeEnum;
import com.qweib.cloud.biz.salesman.pojo.input.SalesmanPushMoneyQuery;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2019/7/16 - 10:41
 */
public interface SalesmanService {

    /**
     * 根据配置类型 id 获取商品提成配置
     *
     * @param database
     * @param configTypeId 配置类型 id
     * @return
     */
    Map<Integer, BigDecimal> queryAutoWarePrice(String database, Integer configTypeId);

    /**
     * 根据配置类型 id 获取指定客户商品提成配置
     * @param database
     * @param configTypeId 配置类型 id
     * @param customerId
     * @return
     */
    Map<Integer, BigDecimal> queryCustomerWarePrice(String database, Integer configTypeId, Integer customerId);

    List<BillPriceDTO> queryBillWareList(String database, SalesmanPushMoneyQuery query);

    List<CustomerTypePushMoneyDTO> queryAllCustomerType(String database, PushMoneyTypeEnum type);

    List<CustomerTypeWarePushMoneyDTO> queryAllCustomerTypeSingle(String database, PushMoneyTypeEnum type);

    List<CustomerLevelPushMoneyDTO> queryAllCustomerLevel(String database, PushMoneyTypeEnum type);

    List<CustomerLevelWarePushMoneyDTO> queryAllCustomerLevelSingle(String database, PushMoneyTypeEnum type);

    List<CustomerTypeDTO> queryCustomerType(String database);

    List<CustomerLevelDTO> queryCustomerLevel(String database);

    List<WareTypeDTO> queryWareType(String database);
}
