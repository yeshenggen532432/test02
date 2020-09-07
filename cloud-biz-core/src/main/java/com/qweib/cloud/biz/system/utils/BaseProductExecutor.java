package com.qweib.cloud.biz.system.utils;

import com.google.common.collect.Maps;
import com.qweib.cloud.biz.system.service.SysWaresService;
import com.qweib.cloud.biz.system.service.SysWaretypeService;
import com.qweib.cloud.core.domain.product.BaseProduct;
import com.qweib.cloud.utils.ChineseCharToEnUtil;
import com.qweib.commons.Collections3;
import com.qweib.commons.MathUtils;
import com.qweib.commons.StringUtils;
import com.qweib.commons.exceptions.BizException;

import java.util.List;
import java.util.Map;
import java.util.Optional;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2019/6/13 - 15:46
 */
public abstract class BaseProductExecutor<T> {


    private final Map<String, BaseProduct> productCache = Maps.newHashMap();

    protected final String database;
    private final String typeSeparator;
    private final SysWaretypeService productTypeService;
    protected final SysWaresService productService;
    private Integer maxProductId;
    private final BaseWareTypeExecutor typeExecutor;

    public BaseProductExecutor(String database, String typeSeparator, SysWaretypeService productTypeService, SysWaresService productService) {
        this.database = database;
        this.typeSeparator = typeSeparator;
        this.productTypeService = productTypeService;
        this.productService = productService;
        maxProductId = Optional.ofNullable(this.productService.queryWareMaxId(database)).orElse(1);
        this.typeExecutor = new BaseWareTypeExecutor(database, typeSeparator, productTypeService);
        typeExecutor.initialData();
    }

    public Integer getProduct(final String productType, final String productName,
                              final T sourceData) {
        Integer typeId = typeExecutor.getProductType(productType);
        if (typeId == null) {
            throw new BizException(productName + "产品，保存产品类别失败");
        }
        BaseProduct baseProduct = this.productCache.get(productName);

        Integer productId = this.customImportProduct(typeId, baseProduct, sourceData);
        if (!MathUtils.valid(productId)) {
            throw new BizException(productName + "产品，保存新产品出错");
        }

        this.productCache.put(productName, new BaseProduct(productId, sourceData));
        return productId;
    }

    /**
     * 获取最大的产品编码
     *
     * @return
     */
    protected String getMaxProductCode() {
        String productCode = new StringBuilder(10).append("w")
                .append(maxProductId++).toString();

        return productCode;
    }


    protected abstract Integer customImportProduct(Integer productTypeId, BaseProduct baseProduct, T sourceData);

    public void initialData() {
        List<BaseProduct> products = this.productService.queryAllBase(database);
        if (Collections3.isNotEmpty(products)) {
            for (BaseProduct product : products) {
                this.productCache.put(product.getName(), product);
            }
        }
    }


    protected String getBigUnitName(String bigUnitName) {
        return StringUtils.isNotBlank(bigUnitName) ? bigUnitName : "";
    }

    protected String getSmallUnitName(String smallUnitName) {
        return StringUtils.isNotBlank(smallUnitName) ? smallUnitName : "";
    }

    protected String getBigUnitSpec(String bigUnitSpec) {
        return StringUtils.trimToEmpty(bigUnitSpec);
    }

    protected String getProductPinYin(String productName) {
        return ChineseCharToEnUtil.getFirstSpell(productName);
    }
}
