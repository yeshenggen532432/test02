package com.qweib.cloud.biz.salesman.service.impl;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.qweib.cloud.biz.salesman.dao.SalesmanCountDao;
import com.qweib.cloud.biz.salesman.pojo.dto.*;
import com.qweib.cloud.biz.salesman.pojo.input.PushMoneyTypeEnum;
import com.qweib.cloud.biz.salesman.pojo.input.SalesmanPushMoneyQuery;
import com.qweib.cloud.biz.salesman.service.SalesmanService;
import com.qweib.cloud.core.domain.*;
import com.qweib.cloud.repository.*;
import com.qweib.cloud.utils.Collections3;
import com.qweibframework.commons.MathUtils;
import com.qweibframework.commons.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2019/7/16 - 11:09
 */
@Service
public class SalesmanServiceImpl implements SalesmanService {

    @Autowired
    private SysKhlevelDao khlevelDao;
    @Autowired
    private SysQdtypeDao qdtypeDao;
    @Autowired
    private SysWaretypeDao waretypeDao;
    @Autowired
    private SysAutoPriceDao autoPriceDao;
    @Autowired
    private SysAutoCustomerPriceDao autoCustomerPriceDao;
    @Autowired
    private SysCustomerLevelTcFactorDao customerLevelTcFactorDao;
    @Autowired
    private SysCustomerLevelTcRateDao customerLevelTcRateDao;
    @Autowired
    private SysQdTypeTcFactorDao qdTypeTcFactorDao;
    @Autowired
    private SysQdTypeTcRateDao qdTypeTcRateDao;
    @Autowired
    private SalesmanCountDao salesmanCountDao;

    @Override
    public Map<Integer, BigDecimal> queryAutoWarePrice(String database, Integer configTypeId) {
        SysAutoPrice query = new SysAutoPrice();
        query.setAutoId(configTypeId);
        final List<SysAutoPrice> list = autoPriceDao.queryList(query, database, null);
        Map<Integer, BigDecimal> warePriceCache = Maps.newHashMap();
        if (Collections3.isEmpty(list)) {
            return warePriceCache;
        }

        for (SysAutoPrice autoPrice : list) {
            if (StringUtils.isBlank(autoPrice.getPrice())) {
                continue;
            }

            final Double price = StringUtils.toDouble(autoPrice.getPrice());
            if (!MathUtils.valid(price)) {
                continue;
            }

            warePriceCache.put(autoPrice.getWareId(), BigDecimal.valueOf(price));
        }

        return warePriceCache;
    }

    @Override
    public Map<Integer, BigDecimal> queryCustomerWarePrice(String database, Integer configTypeId, Integer customerId) {
        SysAutoCustomerPrice query = new SysAutoCustomerPrice();
        query.setAutoId(configTypeId);
        query.setCustomerId(customerId);
        final List<SysAutoCustomerPrice> list = autoCustomerPriceDao.queryList(query, database);
        Map<Integer, BigDecimal> warePriceCache = Maps.newHashMap();
        if (Collections3.isEmpty(list)) {
            return warePriceCache;
        }

        for (SysAutoCustomerPrice customerPrice : list) {
            if (StringUtils.isBlank(customerPrice.getPrice())) {
                continue;
            }

            final Double price = StringUtils.toDouble(customerPrice.getPrice());
            if (!MathUtils.valid(price)) {
                continue;
            }

            warePriceCache.put(customerPrice.getWareId(), BigDecimal.valueOf(price));
        }

        return warePriceCache;
    }

    @Override
    public List<BillPriceDTO> queryBillWareList(String database, SalesmanPushMoneyQuery query) {
        return salesmanCountDao.querySalesmanPushMoney(database, query);
    }

    @Override
    public List<CustomerTypePushMoneyDTO> queryAllCustomerType(String database, PushMoneyTypeEnum type) {
        final List<SysQdTypeTcRate> sourceList = this.qdTypeTcRateDao.queryList(null, database);
        if (Collections3.isEmpty(sourceList)) {
            return Lists.newArrayListWithCapacity(0);
        }

        final List<CustomerTypePushMoneyDTO> resultList = Lists.newArrayListWithCapacity(sourceList.size());
        for (SysQdTypeTcRate typeTcRate : sourceList) {
            CustomerTypePushMoneyDTO typeDTO;
            switch (type) {
                case QUANTITY: {
                    typeDTO = new CustomerTypePushMoneyDTO(typeTcRate.getId(), typeTcRate.getSaleQtyTcRate(),
                            typeTcRate.getRelaId(), typeTcRate.getWaretypeId());
                    break;
                }
                case SALE_AMOUNT: {
                    typeDTO = new CustomerTypePushMoneyDTO(typeTcRate.getId(), typeTcRate.getSaleProTcRate(),
                            typeTcRate.getRelaId(), typeTcRate.getWaretypeId());
                    break;
                }
                case GROSS_MARGIN: {
                    typeDTO = new CustomerTypePushMoneyDTO(typeTcRate.getId(), typeTcRate.getSaleGroTcRate(),
                            typeTcRate.getRelaId(), typeTcRate.getWaretypeId());
                    break;
                }
                default: {
                    throw new IllegalArgumentException("queryAllCustomerType Unknown type:" + type.getType());
                }
            }

            resultList.add(typeDTO);
        }

        return resultList;
    }

    @Override
    public List<CustomerTypeWarePushMoneyDTO> queryAllCustomerTypeSingle(String database, PushMoneyTypeEnum type) {
        final List<SysQdTypeTcFactor> sourceList = this.qdTypeTcFactorDao.queryList(null, database);
        if (Collections3.isEmpty(sourceList)) {
            return Lists.newArrayListWithCapacity(0);
        }

        final List<CustomerTypeWarePushMoneyDTO> resultList = Lists.newArrayListWithCapacity(sourceList.size());
        for (SysQdTypeTcFactor typeTcFactor : sourceList) {
            CustomerTypeWarePushMoneyDTO singleDTO;
            switch (type) {
                case QUANTITY: {
                    singleDTO = new CustomerTypeWarePushMoneyDTO(typeTcFactor.getId(), typeTcFactor.getSaleQtyTcRate(),
                            typeTcFactor.getRelaId(), typeTcFactor.getWareId(), typeTcFactor.getSaleQtyTc());
                    break;
                }
                case SALE_AMOUNT: {
                    singleDTO = new CustomerTypeWarePushMoneyDTO(typeTcFactor.getId(), typeTcFactor.getSaleProTcRate(),
                            typeTcFactor.getRelaId(), typeTcFactor.getWareId(), typeTcFactor.getSaleProTc());
                    break;
                }
                case GROSS_MARGIN: {
                    singleDTO = new CustomerTypeWarePushMoneyDTO(typeTcFactor.getId(), typeTcFactor.getSaleGroTcRate(),
                            typeTcFactor.getRelaId(), typeTcFactor.getWareId(), typeTcFactor.getSaleGroTc());
                    break;
                }
                default: {
                    throw new IllegalArgumentException("queryAllCustomerTypeSingle Unknown type:" + type.getType());
                }
            }

            resultList.add(singleDTO);
        }

        return resultList;
    }

    @Override
    public List<CustomerLevelPushMoneyDTO> queryAllCustomerLevel(String database, PushMoneyTypeEnum type) {
        final List<SysCustomerLevelTcRate> sourceList = this.customerLevelTcRateDao.queryList(null, database);
        if (Collections3.isEmpty(sourceList)) {
            return Lists.newArrayListWithCapacity(0);
        }

        List<CustomerLevelPushMoneyDTO> resultList = Lists.newArrayListWithCapacity(sourceList.size());
        for (SysCustomerLevelTcRate levelTcRate : sourceList) {
            CustomerLevelPushMoneyDTO levelDTO;
            switch (type) {
                case QUANTITY: {
                    levelDTO = new CustomerLevelPushMoneyDTO(levelTcRate.getId(), levelTcRate.getSaleQtyTcRate(),
                            levelTcRate.getRelaId(), levelTcRate.getWaretypeId());
                    break;
                }
                case SALE_AMOUNT: {
                    levelDTO = new CustomerLevelPushMoneyDTO(levelTcRate.getId(), levelTcRate.getSaleProTcRate(),
                            levelTcRate.getRelaId(), levelTcRate.getWaretypeId());
                    break;
                }
                case GROSS_MARGIN: {
                    levelDTO = new CustomerLevelPushMoneyDTO(levelTcRate.getId(), levelTcRate.getSaleGroTcRate(),
                            levelTcRate.getRelaId(), levelTcRate.getWaretypeId());
                    break;
                }
                default: {
                    throw new IllegalArgumentException("queryAllCustomerLevel Unknown type:" + type.getType());
                }
            }

            resultList.add(levelDTO);
        }

        return resultList;
    }

    @Override
    public List<CustomerLevelWarePushMoneyDTO> queryAllCustomerLevelSingle(String database, PushMoneyTypeEnum type) {
        final List<SysCustomerLevelTcFactor> sourceList = customerLevelTcFactorDao.queryList(null, database);
        if (Collections3.isEmpty(sourceList)) {
            return Lists.newArrayListWithCapacity(0);
        }

        final List<CustomerLevelWarePushMoneyDTO> resultList = Lists.newArrayListWithCapacity(sourceList.size());
        for (SysCustomerLevelTcFactor levelTcFactor : sourceList) {
            CustomerLevelWarePushMoneyDTO singleDTO;
            switch (type) {
                case QUANTITY: {
                    singleDTO = new CustomerLevelWarePushMoneyDTO(levelTcFactor.getId(), levelTcFactor.getSaleQtyTcRate(),
                            levelTcFactor.getLevelId(), levelTcFactor.getWareId(), levelTcFactor.getSaleQtyTc());
                    break;
                }
                case SALE_AMOUNT: {
                    singleDTO = new CustomerLevelWarePushMoneyDTO(levelTcFactor.getId(), levelTcFactor.getSaleProTcRate(),
                            levelTcFactor.getLevelId(), levelTcFactor.getWareId(), levelTcFactor.getSaleProTc());
                    break;
                }
                case GROSS_MARGIN: {
                    singleDTO = new CustomerLevelWarePushMoneyDTO(levelTcFactor.getId(), levelTcFactor.getSaleGroTcRate(),
                            levelTcFactor.getLevelId(), levelTcFactor.getWareId(), levelTcFactor.getSaleGroTc());
                    break;
                }
                default: {
                    throw new IllegalArgumentException("queryAllCustomerLevel Unknown type:" + type.getType());
                }
            }

            resultList.add(singleDTO);
        }

        return resultList;
    }

    @Override
    public List<CustomerTypeDTO> queryCustomerType(String database) {
        final List<SysQdtype> sourceList = qdtypeDao.queryList(null, database);
        if (Collections3.isEmpty(sourceList)) {
            return Lists.newArrayListWithCapacity(0);
        }

        final List<CustomerTypeDTO> resultList = Lists.newArrayListWithCapacity(sourceList.size());
        for (SysQdtype qdtype : sourceList) {
            final CustomerTypeDTO singleDTO = new CustomerTypeDTO(qdtype.getId(), qdtype.getQdtpNm(),
                    qdtype.getCoding());

            resultList.add(singleDTO);
        }

        return resultList;
    }

    @Override
    public List<CustomerLevelDTO> queryCustomerLevel(String database) {
        final List<SysKhlevel> sourceList = khlevelDao.queryList(null, database);
        if (Collections3.isEmpty(sourceList)) {
            return Lists.newArrayListWithCapacity(0);
        }

        final List<CustomerLevelDTO> resultList = Lists.newArrayListWithCapacity(sourceList.size());
        for (SysKhlevel khlevel : sourceList) {
            final CustomerLevelDTO singleDTO = new CustomerLevelDTO(khlevel.getId(), khlevel.getQdId(),
                    khlevel.getKhdjNm(), khlevel.getCoding());

            resultList.add(singleDTO);
        }

        return resultList;
    }

    @Override
    public List<WareTypeDTO> queryWareType(String database) {
        final List<SysWaretype> sourceList = waretypeDao.queryList(null, database);
        if (Collections3.isEmpty(sourceList)) {
            return Lists.newArrayListWithCapacity(0);
        }

        final List<WareTypeDTO> resultList = Lists.newArrayListWithCapacity(sourceList.size());
        for (SysWaretype waretype : sourceList) {
            final WareTypeDTO singleDTO = new WareTypeDTO(waretype.getWaretypeId(),
                    waretype.getWaretypePid(), waretype.getWaretypeNm());

            resultList.add(singleDTO);
        }

        return resultList;
    }
}
