package com.qweib.cloud.biz.system.utils;

import com.qweib.cloud.biz.system.controller.customer.price.domain.CustomerPriceModel;
import com.qweib.cloud.biz.system.service.SysWaresService;
import com.qweib.cloud.biz.system.service.SysWaretypeService;
import com.qweib.cloud.core.domain.product.BaseProduct;
import com.qweib.cloud.core.domain.product.ProductData;
import com.qweib.commons.DateUtils;
import com.qweib.commons.MathUtils;
import com.qweib.commons.StringUtils;
import com.qweib.commons.exceptions.BizException;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2019/6/13 - 16:05
 */
public class CustomerProductExecutor extends BaseProductExecutor<CustomerPriceModel> {

    public CustomerProductExecutor(String database, String typeSeparator, SysWaretypeService productTypeService, SysWaresService productService) {
        super(database, typeSeparator, productTypeService, productService);
    }

    @Override
    protected Integer customImportProduct(Integer productTypeId, BaseProduct baseProduct, CustomerPriceModel sourceData) {
        Double bigUnitScale = 1D, smallUnitScale = 1D, conversionProportion = 1D;
        //如果是新增时
        if (StringUtils.isNotBlank(sourceData.getSmallUnitScale())) {
            smallUnitScale = StringUtils.toDouble(sourceData.getSmallUnitScale());
            if (!MathUtils.valid(smallUnitScale)) {
                throw new BizException(sourceData.getProductName() + "产品，小单位换算比例有误");
            }
            if (baseProduct != null && baseProduct.getbUnit() != null)
                bigUnitScale = baseProduct.getbUnit();
            conversionProportion = smallUnitScale / bigUnitScale;
        } else if (baseProduct != null) {//如果是修改时不默认
            bigUnitScale = null;
            smallUnitScale = null;
            conversionProportion = null;
        }

        String productCode = getMaxProductCode();

        ProductData productData = new ProductData();
        productData.setTypeId(productTypeId);
        productData.setProductCode(productCode);
        productData.setProductName(sourceData.getProductName());
        productData.setProductPinYin(sourceData.getProductName());
        productData.setBigUnitName(getBigUnitName(sourceData.getBigUnitName()));
        productData.setBigUnitSpec(getBigUnitSpec(sourceData.getBigUnitSpec()));
        productData.setBigUnitScale(bigUnitScale);
        productData.setSmallUnitName(getSmallUnitName(sourceData.getSmallUnitName()));
        productData.setSmallUnitSpec(sourceData.getSmallUnitSpec());
        productData.setSmallUnitScale(smallUnitScale);
        productData.setConversionProportion(conversionProportion);
        productData.setPublishTime(DateUtils.getDateTime());

        if (baseProduct != null) {
            if (BaseProduct.isChange(productData, baseProduct))
                productService.updateImportProduct(database, baseProduct.getId(), productData);
            return baseProduct.getId();
        } else {
            return this.productService.saveImportProduct(database, productData);
        }
    }
}
