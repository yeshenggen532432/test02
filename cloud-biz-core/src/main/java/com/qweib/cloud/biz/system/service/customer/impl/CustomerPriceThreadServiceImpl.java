package com.qweib.cloud.biz.system.service.customer.impl;

import com.google.common.collect.Lists;
import com.qweib.cloud.biz.common.ValidationBeanUtil;
import com.qweib.cloud.biz.system.controller.plat.vo.importVo.ImportCustomerPriceVo;
import com.qweib.cloud.biz.system.controller.plat.vo.importVo.ImportResults;
import com.qweib.cloud.biz.system.service.SysCustomerService;
import com.qweib.cloud.biz.system.service.SysInportTempService;
import com.qweib.cloud.biz.system.service.SysWareService;
import com.qweib.cloud.biz.system.service.customer.CustomerPriceThreadService;
import com.qweib.cloud.biz.system.utils.CustomerExecutor;
import com.qweib.cloud.biz.system.utils.ProgressUtil;
import com.qweib.cloud.core.domain.SysCustomerPrice;
import com.qweib.cloud.core.domain.SysLoginInfo;
import com.qweib.cloud.core.domain.SysWare;
import com.qweib.cloud.core.domain.customer.CustomerPriceData;
import com.qweib.cloud.core.domain.customer.CustomerPriceQuery;
import com.qweib.cloud.repository.customer.CustomerPriceDao;
import com.qweib.cloud.utils.Collections3;
import com.qweib.cloud.utils.StrUtil;
import com.qweib.commons.StringUtils;
import com.qweibframework.async.handler.AsyncProcessHandler;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.*;

/**
 * 客户价格更新子线程
 */
@Slf4j
@Service
public class CustomerPriceThreadServiceImpl implements CustomerPriceThreadService {

    @Autowired
    private CustomerPriceDao customerPriceDao;
    @Resource
    private SysWareService wareService;
    @Resource
    private SysCustomerService customerService;
    @Autowired
    private AsyncProcessHandler asyncProcessHandler;
    @Resource
    private SysInportTempService sysInportTempService;

    private SysCustomerPrice getCustomerPrice(CustomerPriceQuery query) {
        return customerPriceDao.getCustomerPrice(query);
    }


    private int saveCustomerPrice(String taskId, String database, List<CustomerPriceData> priceDataList, int start, int end) {
        int repeat = 0;
        ProgressUtil progressUtil = new ProgressUtil(start, end, priceDataList.size());
        int i = 0;
        for (CustomerPriceData priceData : priceDataList) {
            i++;
            if (priceData.getBigUnitTradePrice() == null && priceData.getSmallUnitTradePrice() == null) {
                continue;
            }
            asyncProcessHandler.updateProgress(taskId, progressUtil.getCurrentRaised((i)), "正在处理客户价格:" + priceData.getCustomerName() + "-" + priceData.getProductName());
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


    @Override
    public void updateImportThreadCustomerPrice(List<ImportCustomerPriceVo> models, SysLoginInfo info, String importId, String taskId, double start, double addLen, Map<String, String[]> requestParamMap, ImportResults importResults, int startRow) {
        Map<String, String> wareNaIdMap = new HashMap<>(models.size());
        //转换成商品对象方便后继操作
        List<SysWare> wareList = makeWareList(models, wareNaIdMap, importResults, startRow);
        if (Collections3.isEmpty(wareList)) return;

        int goal = Double.valueOf(start + addLen / 2).intValue();
        wareService.saveOrUpdateWareByImport(importResults, wareList, info, importId, taskId, Double.valueOf(start).intValue(), goal, requestParamMap);
        Map<String, Integer> wareIdMap = new HashMap<>(models.size());
        for (SysWare ware : wareList) {
            if (ware.getWareId() == null)
                continue;
            wareIdMap.put(ware.getWareNm(), ware.getWareId());
        }
        List<CustomerPriceData> priceDataList = Lists.newArrayListWithCapacity(models.size());
        asyncProcessHandler.updateProgress(taskId, goal, "商品基础数据已处理完成,继续客户价格");

        CustomerExecutor customerExecutor = new CustomerExecutor(customerService, info.getDatasource(), info.getIdKey());
        Set<String> idsSet = new HashSet<>();
        for (int i = 0; i < models.size(); i++) {
            ImportCustomerPriceVo model = models.get(i);
            Integer wareId = wareIdMap.get(model.getProductName());
            if (wareId == null) {
                continue;
            }
            Integer customerId = customerExecutor.getCustomer(model.getCustomerName(), null, info);
            CustomerPriceData priceData = this.makeCustomerPrice(customerId, wareId, model);
            priceDataList.add(priceData);
            idsSet.add(wareNaIdMap.get(model.getCustomerName() + model.getProductName()));
        }
        saveCustomerPrice(taskId, info.getDatasource(), priceDataList, goal, Double.valueOf(start + addLen).intValue());
        //完成选项
        if (Collections3.isNotEmpty(idsSet))
            sysInportTempService.updateItemImportSuccess(String.join(",", idsSet), info.getDatasource());
    }


    private CustomerPriceData makeCustomerPrice(Integer customerId, Integer productId, ImportCustomerPriceVo model) {
        CustomerPriceData priceData = new CustomerPriceData();
        priceData.setCustomerId(customerId);
        priceData.setProductId(productId);
        priceData.setCustomerName(model.getCustomerName());
        priceData.setProductName(model.getProductName());
        //价格不必须，为空时不修改
        priceData.setBigUnitTradePrice(StrUtil.isNull(model.getBigUnitTradePrice()) ? null : StringUtils.toDouble(model.getBigUnitTradePrice()));
        priceData.setSmallUnitTradePrice(StrUtil.isNull(model.getSmallUnitTradePrice()) ? null : StringUtils.toDouble(model.getSmallUnitTradePrice()));
        return priceData;
    }

    private List<SysWare> makeWareList(List<ImportCustomerPriceVo> models, Map<String, String> wareNaIdMap, ImportResults importResults, int startRow) {
        if (Collections3.isEmpty(models)) return null;
        SysWare ware = null;
        List<SysWare> wareList = new ArrayList<>(models.size());
        for (int i = 0; i < models.size(); i++) {
            ImportCustomerPriceVo model = models.get(i);

            ValidationBeanUtil.ValidResult validResult = ValidationBeanUtil.validateBean(model);
            if (validResult.hasErrors()) {
                String errors = validResult.getErrors();
                importResults.setErrorMsg("第" + (startRow + i + 1) + "行“" + errors);
                continue;
            }

           /* if (StrUtil.isNull(model.getCustomerName())) {
                importResults.setErrorMsg("第" + (startRow + i + 1) + "行“" + "客户名称不能为空");
                continue;
            }
            if (StrUtil.isNull(model.getProductName())) {
                importResults.setErrorMsg("第" + (startRow + i + 1) + "行“" + "商品名称不能为空");
                continue;
            }
            if (!StrUtil.isNull(model.getBigUnitSpec()) && model.getBigUnitSpec().length() > 20) {
                importResults.setErrorMsg(model.getCustomerName() + "-" + model.getProductName() + "规格(大)超出限制!");//名称不能为空
                continue;
            }
            if (!StrUtil.isNull(model.getSmallUnitSpec()) && model.getSmallUnitSpec().length() > 20) {
                importResults.setErrorMsg(model.getCustomerName() + "-" + model.getProductName() + "规格(小)超出限制!");//名称不能为空
                continue;
            }*/
           /* if (!StrUtil.isNull(model.getSmallUnitScale())) {
                if (!MathUtils.valid(com.qweib.commons.StringUtils.toDouble(model.getSmallUnitScale()))) {
                    importResults.setErrorMsg("第" + (startRow + i + 1) + "行“" + model.getProductName() + "”，换算比例(" + model.getSmallUnitScale() + ")有误<br/>");
                    continue;
                }
            }*/
            /*if (!wareSet.add(model.getCustomerName() + model.getProductName())) {
                importResults.setErrorMsg(model.getCustomerName() + model.getProductName() + "”名称重复");
            }*/
            ware = new SysWare();
            ware.setWaretypeNm(model.getProductType());
            ware.setWareNm(model.getProductName());
            ware.setWareDw(model.getBigUnitName());
            ware.setWareGg(model.getBigUnitSpec());
            ware.setMinUnit(model.getSmallUnitName());
            ware.setMinWareGg(model.getSmallUnitSpec());
            if (!StrUtil.isNull(model.getSmallUnitScale()))
                ware.setsUnit(Double.valueOf(model.getSmallUnitScale()));
            wareList.add(ware);
            wareNaIdMap.put(model.getCustomerName() + model.getProductName(), model.getId() + "");
        }
        return wareList;
    }

}
