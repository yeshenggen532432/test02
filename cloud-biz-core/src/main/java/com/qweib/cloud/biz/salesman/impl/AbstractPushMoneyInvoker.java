package com.qweib.cloud.biz.salesman.impl;

import com.google.common.collect.Maps;
import com.qweib.cloud.biz.salesman.PushMoneyInvoker;
import com.qweib.cloud.biz.salesman.pojo.dto.*;
import com.qweib.cloud.biz.salesman.pojo.input.PushMoneyTypeEnum;
import com.qweib.cloud.biz.salesman.service.SalesmanService;
import com.qweib.cloud.utils.Collections3;
import com.qweib.cloud.utils.SpringContextHolder;
import com.qweibframework.commons.StringUtils;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Optional;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2019/7/16 - 14:55
 */
public abstract class AbstractPushMoneyInvoker<T> implements PushMoneyInvoker<T> {

    private final String database;
    private final PushMoneyTypeEnum configType;
    /**
     * 自动配置类型 id
     */
    private final Integer configTypeId;
    protected final PushMoneyInvokerWrapper wrapper;
    private final SalesmanService salesmanService;

    protected final Map<Integer, BigDecimal> warePriceCache;
    protected final Map<Integer, Map<Integer, BigDecimal>> customerWarePriceCache;

    protected final Map<Integer, WareTypeDTO> wareTypeCache;
    protected final Map<String, Integer> customerTypeNameCache;
    protected final Map<String, CustomerLevelDTO> customerLevelNameCache;

    protected final Map<Integer, Map<Integer, CustomerTypePushMoneyDTO>> customerTypeRateCache;
    protected final Map<Integer, Map<Integer, CustomerTypeWarePushMoneyDTO>> customerTypeWareCache;

    protected final Map<Integer, Map<Integer, CustomerLevelPushMoneyDTO>> customerLevelRateCache;
    protected final Map<Integer, Map<Integer, CustomerLevelWarePushMoneyDTO>> customerLevelWareCache;

    public AbstractPushMoneyInvoker(String database, PushMoneyTypeEnum configType, Integer configTypeId) {
        this.database = database;
        this.configType = configType;
        this.configTypeId = configTypeId;
        this.wrapper = new PushMoneyInvokerWrapper();
        this.salesmanService = SpringContextHolder.getBean(SalesmanService.class);

        this.warePriceCache = Maps.newHashMap();
        this.customerWarePriceCache = Maps.newHashMap();

        this.wareTypeCache = Maps.newHashMap();
        this.customerTypeNameCache = Maps.newHashMap();
        this.customerLevelNameCache = Maps.newHashMap();

        this.customerTypeRateCache = Maps.newHashMap();
        this.customerTypeWareCache = Maps.newHashMap();

        this.customerLevelRateCache = Maps.newHashMap();
        this.customerLevelWareCache = Maps.newHashMap();
    }

    @Override
    public void initial() {
        transformWareType();
        initialWarePriceConfig();
        transformCustomerType();
        transformCustomerLevel();

        transformCustomerTypeRate();
        transformCustomerTypeWare();

        transformCustomerLevelRate();
        transformCustomerLevelWare();
    }

    @Override
    public T invoke(BillPriceDTO billPriceDTO) {
        T result = invokeCustomWare(billPriceDTO);
        if (result != null) {
            return result;
        }

        getWareDefaultFactor(billPriceDTO.getWareId())
                .ifPresent(e -> {
                    billPriceDTO.setWareDefaultFactor(e);
                });
        result = invokeLevelAndWare(billPriceDTO);
        if (result != null) {
            return result;
        }

        result = invokeLevelAndWareType(billPriceDTO);
        if (result != null) {
            return result;
        }

        result = invokeTypeAndWare(billPriceDTO);
        if (result != null) {
            return result;
        }

        result = invokeTypeAndWareType(billPriceDTO);
        if (result != null) {
            return result;
        }

        return invokeSourceWare(billPriceDTO);
    }

    private Optional<BigDecimal> getWareDefaultFactor(Integer wareId) {
        return Optional.ofNullable(this.warePriceCache.get(wareId));
    }

    /**
     * 处理自定义商品提成
     *
     * @param billPriceDTO
     * @return
     */
    private T invokeCustomWare(BillPriceDTO billPriceDTO) {
        final Optional<BigDecimal> priceOptional = getCustomerWarePrice(billPriceDTO.getCustomerId(), billPriceDTO.getWareId());
        if (priceOptional.isPresent()) {
            return doInvokeCustomWare(billPriceDTO, priceOptional.get());
        } else {
            return null;
        }
    }

    protected abstract T doInvokeCustomWare(BillPriceDTO billPriceDTO, BigDecimal wareCustomerFactor);

    /**
     * 按客户等级-自定义商品提成
     *
     * @param billPriceDTO
     * @return
     */
    private T invokeLevelAndWare(BillPriceDTO billPriceDTO) {
        final String customerLevelName = billPriceDTO.getCustomerLevelName();

        final Optional<CustomerLevelDTO> optional = getCustomerLevel(customerLevelName);
        if (!optional.isPresent()) {
            return null;
        }

        final Map<Integer, CustomerLevelWarePushMoneyDTO> wareCache = customerLevelWareCache.get(optional.get().getId());
        if (wareCache == null) {
            return null;
        }

        final Integer wareId = billPriceDTO.getWareId();
        final CustomerLevelWarePushMoneyDTO levelWareDTO = wareCache.get(wareId);
        if (levelWareDTO == null) {
            return null;
        }

        return doInvokeLevelAndWare(billPriceDTO, levelWareDTO);
    }

    /**
     * 调用等级--产品
     *
     * @param billPriceDTO
     * @param levelWareDTO
     * @return
     */
    protected abstract T doInvokeLevelAndWare(BillPriceDTO billPriceDTO, CustomerLevelWarePushMoneyDTO levelWareDTO);

    /**
     * 按客户等级-商品类别提成
     *
     * @param billPriceDTO
     * @return
     */
    private T invokeLevelAndWareType(BillPriceDTO billPriceDTO) {
        final String customerLevelName = billPriceDTO.getCustomerLevelName();

        final Optional<CustomerLevelDTO> optional = getCustomerLevel(customerLevelName);
        if (!optional.isPresent()) {
            return null;
        }

        final Map<Integer, CustomerLevelPushMoneyDTO> wareTypeCache = customerLevelRateCache.get(optional.get().getId());
        if (wareTypeCache == null) {
            return null;
        }

        final Integer wareTypeId = billPriceDTO.getWareTypeId();
        Integer tmpTypeId = wareTypeId;

        while (tmpTypeId != null) {
            final CustomerLevelPushMoneyDTO levelDTO = wareTypeCache.get(tmpTypeId);
            if (levelDTO != null) {
                T result = doInvokeLevelAndWareType(billPriceDTO, levelDTO);
                if (result != null) {
                    return result;
                }
            }

            final Optional<Integer> optionalParentId = getWareTypeParentId(tmpTypeId);

            tmpTypeId = optionalParentId.isPresent() ? optionalParentId.get() : null;
        }

        return null;
    }

    /**
     * 调用等级--类别
     *
     * @param billPriceDTO
     * @param levelDTO
     * @return
     */
    protected abstract T doInvokeLevelAndWareType(BillPriceDTO billPriceDTO, CustomerLevelPushMoneyDTO levelDTO);

    /**
     * 按客户类型-自定义商品提成
     *
     * @param billPriceDTO
     * @return
     */
    private T invokeTypeAndWare(BillPriceDTO billPriceDTO) {
        final String customerTypeName = billPriceDTO.getCustomerTypeName();

        final Optional<Integer> optional = getCustomerType(customerTypeName);
        if (!optional.isPresent()) {
            return null;
        }

        final Map<Integer, CustomerTypeWarePushMoneyDTO> wareCache = customerTypeWareCache.get(optional.get());
        if (wareCache == null) {
            return null;
        }

        final Integer wareId = billPriceDTO.getWareId();
        final CustomerTypeWarePushMoneyDTO typeWareDTO = wareCache.get(wareId);
        if (typeWareDTO == null) {
            return null;
        }

        return doInvokeTypeAndWare(billPriceDTO, typeWareDTO);
    }

    /**
     * 调用类型--产品
     *
     * @param billPriceDTO
     * @param typeWareDTO
     * @return
     */
    protected abstract T doInvokeTypeAndWare(BillPriceDTO billPriceDTO, CustomerTypeWarePushMoneyDTO typeWareDTO);

    /**
     * 按客户类型-商品类型提成
     *
     * @param billPriceDTO
     * @return
     */
    private T invokeTypeAndWareType(BillPriceDTO billPriceDTO) {
        final String customerTypeName = billPriceDTO.getCustomerTypeName();

        final Optional<Integer> optional = getCustomerType(customerTypeName);
        if (!optional.isPresent()) {
            return null;
        }

        final Map<Integer, CustomerTypePushMoneyDTO> wareTypeCache = customerTypeRateCache.get(optional.get());
        if (wareTypeCache == null) {
            return null;
        }

        final Integer wareTypeId = billPriceDTO.getWareTypeId();
        Integer tmpTypeId = wareTypeId;

        while (tmpTypeId != null) {
            final CustomerTypePushMoneyDTO levelDTO = wareTypeCache.get(tmpTypeId);
            if (levelDTO != null) {
                T result = doInvokeTypeAndWareType(billPriceDTO, levelDTO);
                if (result != null) {
                    return result;
                }
            }

            final Optional<Integer> optionalParentId = getWareTypeParentId(tmpTypeId);

            tmpTypeId = optionalParentId.isPresent() ? optionalParentId.get() : null;
        }

        return null;
    }

    /**
     * 调用类型--类别
     *
     * @param billPriceDTO
     * @param typeDTO
     * @return
     */
    protected abstract T doInvokeTypeAndWareType(BillPriceDTO billPriceDTO, CustomerTypePushMoneyDTO typeDTO);

    /**
     * 按产品初始值执行
     *
     * @param billPriceDTO
     * @return
     */
    protected abstract T invokeSourceWare(BillPriceDTO billPriceDTO);

    /**
     * 自定义客户-商品缓存
     *
     * @param customerId
     * @param wareId
     * @return
     */
    private Optional<BigDecimal> getCustomerWarePrice(Integer customerId, Integer wareId) {
        final Map<Integer, BigDecimal> warePriceCache = Optional.ofNullable(this.customerWarePriceCache.get(customerId))
                .orElseGet(() -> {
                    final Map<Integer, BigDecimal> cache = this.salesmanService.queryCustomerWarePrice(database, configTypeId, customerId);
                    customerWarePriceCache.put(customerId, cache);

                    return cache;
                });

        return Optional.ofNullable(warePriceCache.get(wareId));
    }

    /**
     * 获取客户类型
     *
     * @param customerTypeName
     * @return
     */
    private Optional<Integer> getCustomerType(String customerTypeName) {
        if (StringUtils.isBlank(customerTypeName)) {
            return Optional.empty();
        } else {
            return Optional.ofNullable(customerTypeNameCache.get(customerTypeName));
        }
    }

    /**
     * 获取客户等级
     *
     * @param customerLevelName
     * @return
     */
    private Optional<CustomerLevelDTO> getCustomerLevel(String customerLevelName) {
        if (StringUtils.isBlank(customerLevelName)) {
            return Optional.empty();
        } else {
            return Optional.ofNullable(customerLevelNameCache.get(customerLevelName));
        }
    }

    /**
     * 获取商品类别缓存
     *
     * @param wareTypeId
     * @return
     */
    private Optional<Integer> getWareTypeParentId(Integer wareTypeId) {
        final WareTypeDTO wareTypeDTO = wareTypeCache.get(wareTypeId);
        if (wareTypeDTO == null) {
            return Optional.empty();
        }

        if (Objects.equals(0, wareTypeDTO.getParentId()) ||
                Objects.equals(wareTypeId, wareTypeDTO.getParentId())) {
            return Optional.empty();
        } else {
            return Optional.ofNullable(wareTypeDTO.getParentId());
        }
    }

    private void transformWareType() {
        List<WareTypeDTO> wareTypeDTOS = this.salesmanService.queryWareType(database);
        for (WareTypeDTO wareTypeDTO : wareTypeDTOS) {
            wareTypeCache.put(wareTypeDTO.getId(), wareTypeDTO);
        }
    }

    private void initialWarePriceConfig() {
        final Map<Integer, BigDecimal> wareMap = this.salesmanService.queryAutoWarePrice(database, configTypeId);
        if (Collections3.isNotEmpty(wareMap)) {
            this.warePriceCache.putAll(wareMap);
        }
    }

    private void transformCustomerType() {
        final List<CustomerTypeDTO> customerTypeDTOS = this.salesmanService.queryCustomerType(database);
        for (CustomerTypeDTO customerTypeDTO : customerTypeDTOS) {
            customerTypeNameCache.put(customerTypeDTO.getName(), customerTypeDTO.getId());
        }
    }

    private void transformCustomerLevel() {
        final List<CustomerLevelDTO> customerLevelDTOS = this.salesmanService.queryCustomerLevel(database);
        for (CustomerLevelDTO customerLevelDTO : customerLevelDTOS) {
            customerLevelNameCache.put(customerLevelDTO.getName(), customerLevelDTO);
        }
    }

    private void transformCustomerTypeRate() {
        List<CustomerTypePushMoneyDTO> sourceList = this.salesmanService.queryAllCustomerType(database, configType);
        for (CustomerTypePushMoneyDTO typeRateDTO : sourceList) {
            final Integer customerTypeId = typeRateDTO.getCustomerTypeId();
            final Map<Integer, CustomerTypePushMoneyDTO> wareTypeTcCache = Optional.ofNullable(customerTypeRateCache.get(customerTypeId)).orElseGet(() -> {
                Map<Integer, CustomerTypePushMoneyDTO> cache = Maps.newHashMap();
                customerTypeRateCache.put(customerTypeId, cache);
                return cache;
            });

            wareTypeTcCache.put(typeRateDTO.getWareTypeId(), typeRateDTO);
        }
    }

    private void transformCustomerTypeWare() {
        final List<CustomerTypeWarePushMoneyDTO> sourceList = this.salesmanService.queryAllCustomerTypeSingle(database, configType);
        for (CustomerTypeWarePushMoneyDTO typeSingleDTO : sourceList) {
            final Integer customerTypeId = typeSingleDTO.getCustomerTypeId();
            final Map<Integer, CustomerTypeWarePushMoneyDTO> wareTcCache = Optional.ofNullable(customerTypeWareCache.get(customerTypeId)).orElseGet(() -> {
                Map<Integer, CustomerTypeWarePushMoneyDTO> cache = Maps.newHashMap();
                customerTypeWareCache.put(customerTypeId, cache);
                return cache;
            });

            wareTcCache.put(typeSingleDTO.getWareId(), typeSingleDTO);
        }
    }

    private void transformCustomerLevelRate() {
        List<CustomerLevelPushMoneyDTO> sourceList = this.salesmanService.queryAllCustomerLevel(database, configType);
        for (CustomerLevelPushMoneyDTO levelRateDTO : sourceList) {
            final Integer customerLevelId = levelRateDTO.getCustomerLevelId();
            final Map<Integer, CustomerLevelPushMoneyDTO> wareTypeTcCache = Optional.ofNullable(customerLevelRateCache.get(customerLevelId)).orElseGet(() -> {
                Map<Integer, CustomerLevelPushMoneyDTO> cache = Maps.newHashMap();
                customerLevelRateCache.put(customerLevelId, cache);
                return cache;
            });

            wareTypeTcCache.put(levelRateDTO.getWareTypeId(), levelRateDTO);
        }
    }

    private void transformCustomerLevelWare() {
        final List<CustomerLevelWarePushMoneyDTO> sourceList = this.salesmanService.queryAllCustomerLevelSingle(database, configType);
        for (CustomerLevelWarePushMoneyDTO typeSingleDTO : sourceList) {
            final Integer customerLevelId = typeSingleDTO.getCustomerLevelId();
            final Map<Integer, CustomerLevelWarePushMoneyDTO> wareTcCache = Optional.ofNullable(customerLevelWareCache.get(customerLevelId)).orElseGet(() -> {
                Map<Integer, CustomerLevelWarePushMoneyDTO> cache = Maps.newHashMap();
                customerLevelWareCache.put(customerLevelId, cache);
                return cache;
            });

            wareTcCache.put(typeSingleDTO.getWareId(), typeSingleDTO);
        }
    }

    protected BigDecimal multiplyByAssign(BigDecimal billData, BigDecimal wareDate) {
        return billData.multiply(wareDate);
    }

    /**
     * 比例相乘方式
     *
     * @param billData
     * @param wareData
     * @param rateData
     * @return
     */
    protected BigDecimal multiplyByRate(BigDecimal billData, BigDecimal wareData, BigDecimal rateData) {
        return billData.multiply(wareData).multiply(rateData);
    }
}
