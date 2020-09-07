package com.qweib.cloud.biz.system.service;

import com.qweib.cloud.biz.common.ValidationBeanUtil;
import com.qweib.cloud.biz.system.controller.plat.vo.importVo.ImportResults;
import com.qweib.cloud.biz.system.controller.plat.vo.importVo.ImportWareVo;
import com.qweib.cloud.biz.system.utils.ProgressUtil;
import com.qweib.cloud.core.domain.SysCustomerLevelPrice;
import com.qweib.cloud.core.domain.SysLoginInfo;
import com.qweib.cloud.core.domain.SysQdTypePrice;
import com.qweib.cloud.core.domain.SysWare;
import com.qweib.cloud.repository.SysCustomerLevelPriceDao;
import com.qweib.cloud.utils.Collections3;
import com.qweib.cloud.utils.JsonUtil;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.annotation.DataSourceAnnotation;
import com.qweibframework.async.handler.AsyncProcessHandler;
import org.dozer.Mapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.*;

@Service
public class SysCustomerLevelPriceService {
    @Resource
    private SysCustomerLevelPriceDao customerLevelPriceDao;
    //    @Resource
//    private SysConfigService configService;
    @Resource
    private SysWareService wareService;
    //    @Resource
//    private SysWaresService sysWaresService;
    //@Resource
    //private SysCustomerLevelPriceService customerLevelPriceService;
//    @Resource
//    SysWaretypeService productTypeService;
//    @Resource
//    private SysCompanyRoleService sysCompanyRoleService;
//    @Resource
//    private SysInportTempService sysInportTempService;
    @Autowired
    private AsyncProcessHandler asyncProcessHandler;
    @Resource
    private SysQdTypePriceService sysQdTypePriceService;
    @Resource
    private SysInportTempService sysInportTempService;
    @Resource
    private Mapper mapper;

    public Page queryCustomerLevelPrice(SysCustomerLevelPrice levelPrice, int page, int rows, String database) {
        return customerLevelPriceDao.queryCustomerLevelPrice(levelPrice, page, rows, database);
    }

    public List<SysCustomerLevelPrice> queryList(SysCustomerLevelPrice levelPrice, String database) {
        return customerLevelPriceDao.queryList(levelPrice, database, "");
    }

    public List<SysCustomerLevelPrice> queryList(SysCustomerLevelPrice levelPrice, String wareIds, String database) {
        return customerLevelPriceDao.queryList(levelPrice, database, wareIds);
    }

    public int addCustomerLevelPrice(SysCustomerLevelPrice levelPrice, String database) {
        return customerLevelPriceDao.addCustomerLevelPrice(levelPrice, database);
    }

    public SysCustomerLevelPrice queryCustomerLevelPriceById(Integer levelPriceId, String database) {

        return customerLevelPriceDao.queryCustomerLevelPriceById(levelPriceId, database);
    }

    public int updateCustomerLevelPrice(SysCustomerLevelPrice levelPrice, String database) {
        return customerLevelPriceDao.updateCustomerLevelPrice(levelPrice, database);
    }

    public int deleteCustomerLevelPrice(Integer id, String database) {
        return customerLevelPriceDao.deleteCustomerLevelPrice(id, database);
    }

    /**
     * 根据等级删除价格
     *
     * @param levelId
     * @param database
     * @return
     */
    public int deleteByLevelId(Integer levelId, String database) {
        return customerLevelPriceDao.deleteByLevelId(levelId, database);
    }

    public void deleteCustomerLevelAll(String database) {
        customerLevelPriceDao.deleteCustomerLevelPriceAll(database);

    }

    public SysCustomerLevelPrice queryCustomerLevelPrice(SysCustomerLevelPrice levelPrice, String database) {

        return customerLevelPriceDao.queryCustomerLevelPrice(levelPrice, database);
    }

    public SysCustomerLevelPrice queryCustomerLevelByWareIdAndLevelId(Integer levelId, Integer wareId, String database) {
        return customerLevelPriceDao.queryCustomerLevelByWareIdAndLevelId(levelId, wareId, database);
    }

    /**
     * 保存或修改商品基础数据和等级数据
     *
     * @param tempWareList   成功数据
     * @param levelPriceList
     * @param typePriceList
     * @param wareNaIdMap
     * @param info
     * @param importId
     * @param taskId
     * @return
     * @throws Exception
     */
    @Async
    @DataSourceAnnotation(companyId = "#info.fdCompanyId")
    public void saveOrUpdateWareAndLevelAndTypePrice(long st, List<SysWare> tempWareList, List<SysCustomerLevelPrice> levelPriceList, List<SysQdTypePrice> typePriceList, Map<String, String> wareNaIdMap, SysLoginInfo info, String importId, String taskId, Map<String, String[]> requestParamMap) throws Exception {
        ImportResults importResults = new ImportResults();
        try {
            //验证数据有效性
            List<SysWare> wareList = new ArrayList<>();
            for (SysWare sysWare : tempWareList) {
                ImportWareVo importWareVo = mapper.map(sysWare, ImportWareVo.class);
                ValidationBeanUtil.ValidResult validResult = ValidationBeanUtil.validateBean(importWareVo);
                if (validResult.hasErrors()) {
                    String errors = validResult.getErrors();
                    importResults.setErrorMsg(importWareVo.getWareNm() + errors);
                    continue;
                }
                wareList.add(sysWare);
            }
            if (Collections3.isEmpty(wareList)) {
                importResults.setErrorMsg("导入数据不能为空");
                return;
            }
            String database = info.getDatasource();
            wareService.saveOrUpdateWareByImport(importResults, wareList, info, importId, taskId, 0, 50, requestParamMap);
            //名称封装成ID
            Set<String> idsSet = new HashSet(wareList.size());
            for (SysWare ware : wareList) {
                if (ware != null && ware.getWareId() != null) {
                    if (Collections3.isNotEmpty(wareNaIdMap))
                        idsSet.add(wareNaIdMap.get(ware.getWareNm()));
                    //等级类型对应的商品ID封装
                    for (int j = 0; j < typePriceList.size(); j++) {
                        SysQdTypePrice typePrice = typePriceList.get(j);
                        if (ware.getWareNm().equals(typePrice.getWareNm())) {
                            typePrice.setWareId(ware.getWareId());
                        }
                    }
                    //等级对应的商品ID封装
                    for (int j = 0; j < levelPriceList.size(); j++) {
                        SysCustomerLevelPrice levelPrice = levelPriceList.get(j);
                        if (ware.getWareNm().equals(levelPrice.getWareNm())) {
                            levelPrice.setWareId(ware.getWareId());
                        }
                    }
                }
            }
            //商品类型价格
            if (Collections3.isNotEmpty(typePriceList)) {
                asyncProcessHandler.updateProgress(taskId, 50, "商品基础数据已处理完成,继续处理类型价格");
                ProgressUtil progressUtil = new ProgressUtil(50, 75, typePriceList.size());
                int i = 0;
                for (SysQdTypePrice sysQdTypePrice : typePriceList) {
                    i++;
                    if (sysQdTypePrice == null || sysQdTypePrice.getWareId() == null) continue;
                    asyncProcessHandler.updateProgress(taskId, progressUtil.getCurrentRaised((i)), "正在处理类型价格:" + sysQdTypePrice.getWareNm());
                    SysQdTypePrice sysQdTypePrice1 = sysQdTypePriceService.queryQdTypePriceByWareIdAndRelaId(sysQdTypePrice.getRelaId(), sysQdTypePrice.getWareId(), database);
                    if (sysQdTypePrice1 != null) {
                        if (Objects.equals(sysQdTypePrice1.getPrice(), sysQdTypePrice.getPrice()))
                            continue;
                        sysQdTypePrice1.setPrice(sysQdTypePrice.getPrice());
                        sysQdTypePriceService.updateQdTypePrice(sysQdTypePrice1, database);
                    } else {
                        sysQdTypePriceService.addQdTypePrice(sysQdTypePrice, database);
                    }
                }
            }

            //商品等级价格
            if (Collections3.isNotEmpty(levelPriceList)) {
                asyncProcessHandler.updateProgress(taskId, 75, "商品类型价格已处理完成,继续处理等级价格");
                ProgressUtil progressUtil = new ProgressUtil(75, 99, levelPriceList.size());
                int i = 0;
                for (SysCustomerLevelPrice levelPrice : levelPriceList) {
                    i++;
                    if (levelPrice == null || levelPrice.getWareId() == null) continue;
                    asyncProcessHandler.updateProgress(taskId, progressUtil.getCurrentRaised((i)), "正在处理等级价格:" + levelPrice.getWareNm());
                    SysCustomerLevelPrice oldLevelPrice = queryCustomerLevelPrice(levelPrice, database);
                    if (oldLevelPrice != null) {
                        if (Objects.equals(oldLevelPrice.getPrice(), levelPrice.getPrice()))
                            continue;
                        oldLevelPrice.setPrice(levelPrice.getPrice());
                        updateCustomerLevelPrice(oldLevelPrice, database);
                    } else {
                        addCustomerLevelPrice(levelPrice, database);
                    }
                }
            }
            //完成选项
            if (Collections3.isNotEmpty(idsSet))
                sysInportTempService.updateItemImportSuccess(String.join(",", idsSet), database);
        } finally {
            importResults.setSuccessMsg(st);
            asyncProcessHandler.doneTask(taskId, JsonUtil.toJson(importResults));
        }
    }
}
