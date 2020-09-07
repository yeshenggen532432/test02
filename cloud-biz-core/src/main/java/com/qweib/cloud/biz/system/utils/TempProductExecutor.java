package com.qweib.cloud.biz.system.utils;

import com.qweib.cloud.biz.system.service.SysWaresService;
import com.qweib.cloud.biz.system.service.SysWaretypeService;
import com.qweib.cloud.core.domain.SysWare;
import com.qweib.cloud.core.domain.product.BaseProduct;
import com.qweib.cloud.core.domain.product.ProductData;
import com.qweib.cloud.core.domain.product.TempProductDTO;
import com.qweibframework.commons.DateUtils;
import com.qweibframework.commons.MathUtils;
import com.qweibframework.commons.StringUtils;
import org.apache.commons.beanutils.PropertyUtils;

import java.math.BigDecimal;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2019/6/13 - 16:17
 */
public class TempProductExecutor extends BaseProductExecutor<TempProductDTO> {

    public TempProductExecutor(String database, String typeSeparator, SysWaretypeService productTypeService, SysWaresService productService) {
        super(database, typeSeparator, productTypeService, productService);
    }

    @Override
    protected Integer customImportProduct(Integer productTypeId, BaseProduct baseProduct, TempProductDTO sourceData) {

        if (baseProduct != null) {
            ProductData productData = new ProductData();
            try {
                PropertyUtils.copyProperties(productData, sourceData);
            } catch (Exception e) {
                e.printStackTrace();
            }
            productService.updateImportProduct(database, baseProduct.getId(), productData);
            return baseProduct.getId();
        }
        final String productCode = StringUtils.isNotBlank(sourceData.getProductCode()) ? sourceData.getProductCode() : getMaxProductCode();

        SysWare sysWare = new SysWare();
        sysWare.setWaretype(productTypeId);
        sysWare.setWareCode(productCode);
        sysWare.setWareNm(sourceData.getProductName());
        sysWare.setPy(sourceData.getProductName());

        Double conversionProportion = MathUtils.divideByScale(StringUtils.toBigDecimal(sourceData.getSmallUnitScale()),
                StringUtils.toBigDecimal(sourceData.getBigUnitScale()), 2).doubleValue();

        sysWare.setWareDw(getBigUnitName(sourceData.getBigUnitName()));
        sysWare.setWareGg(getBigUnitSpec(sourceData.getBigUnitSpec()));
        sysWare.setbUnit(sourceData.getBigUnitScale());
        sysWare.setPackBarCode(sourceData.getBigBarCode());
        sysWare.setInPrice(sourceData.getBigPurchasePrice());
        sysWare.setWareDj(StringUtils.toDouble(sourceData.getBigSalePrice()));

        sysWare.setMinUnit(getSmallUnitName(sourceData.getSmallUnitName()));
        sysWare.setMinWareGg(sourceData.getSmallUnitSpec());
        sysWare.setsUnit(sourceData.getSmallUnitScale());
        sysWare.setBeBarCode(sourceData.getSmallBarCode());
        sysWare.setSunitPrice(sourceData.getSmallSalePrice() != null ? new BigDecimal(sourceData.getSmallSalePrice()) : null);

        sysWare.setHsNum(conversionProportion);

        sysWare.setQualityDays(sourceData.getExpirationDate());
        sysWare.setProviderName(sourceData.getProviderName());
        sysWare.setRemark(sourceData.getRemark());

        sysWare.setStatus("1");
        sysWare.setIsCy(1);
        sysWare.setFbtime(DateUtils.getDateTime());
        sysWare.setMaxUnitCode("B");
        sysWare.setMinUnitCode("S");

        return this.productService.addWare(sysWare, database);
    }
}
