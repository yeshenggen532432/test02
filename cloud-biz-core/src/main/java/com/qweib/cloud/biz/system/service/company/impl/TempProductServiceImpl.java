package com.qweib.cloud.biz.system.service.company.impl;

import com.qweib.cloud.biz.system.service.company.TempProductService;
import com.qweib.cloud.core.domain.product.*;
import com.qweib.cloud.repository.company.TempProductDao;
import com.qweib.commons.MathUtils;
import com.qweib.commons.StringUtils;
import com.qweib.commons.page.Page;
import com.qweib.commons.page.PageRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2019/5/21 - 16:06
 */
@Service
public class TempProductServiceImpl implements TempProductService {

    @Autowired
    private TempProductDao productDao;

    @Override
    public Integer saveBatch(List<TempProductSave> inputs, String database) {
        int repeatCount = 0;
        for (TempProductSave input : inputs) {
            if (MathUtils.valid(input.getId())) {
                updateCoverData(input, database);
                this.update(input, database);
            } else {
                productDao.save(input, database);
            }
        }

        return repeatCount;
    }

    private void updateCoverData(TempProductSave input, String database) {
        TempProductDTO productDTO = this.get(input.getId(), database);
        if (StringUtils.isBlank(input.getProductCode())) {
            input.setProductCode(productDTO.getProductCode());
        }
        if (StringUtils.isBlank(input.getProductName())) {
            input.setProductName(productDTO.getProductName());
        }
        if (StringUtils.isBlank(input.getBigUnitName())) {
            input.setBigUnitName(productDTO.getBigUnitName());
        }
        if (StringUtils.isBlank(input.getBigUnitSpec())) {
            input.setBigUnitSpec(productDTO.getBigUnitSpec());
        }
        if (input.getBigUnitScale() == null) {
            input.setBigUnitScale(productDTO.getBigUnitScale());
        }
        if (StringUtils.isBlank(input.getBigBarCode())) {
            input.setBigBarCode(productDTO.getBigBarCode());
        }
        if (input.getBigPurchasePrice() == null) {
            input.setBigPurchasePrice(productDTO.getBigPurchasePrice());
        }
        if (input.getBigSalePrice() == null) {
            input.setBigSalePrice(productDTO.getBigSalePrice());
        }
        if (StringUtils.isBlank(input.getSmallUnitName())) {
            input.setSmallUnitName(productDTO.getSmallUnitName());
        }
        if (StringUtils.isBlank(input.getSmallUnitSpec())) {
            input.setSmallUnitSpec(productDTO.getSmallUnitSpec());
        }
        if (input.getSmallUnitScale() == null) {
            input.setSmallUnitScale(productDTO.getSmallUnitScale());
        }
        if (StringUtils.isBlank(input.getSmallBarCode())) {
            input.setSmallBarCode(productDTO.getSmallBarCode());
        }
        if (input.getSmallSalePrice() == null) {
            input.setSmallSalePrice(productDTO.getSmallSalePrice());
        }
        if (StringUtils.isBlank(input.getExpirationDate())) {
            input.setExpirationDate(productDTO.getExpirationDate());
        }
    }

    @Override
    public Page<TempProductDTO> page(TempProductQuery query, PageRequest pageRequest, String database) {
        return productDao.page(query, pageRequest, database);
    }

    @Override
    public TempProductDTO get(Integer id, String database) {
        return productDao.get(id, database);
    }

    @Override
    public List<TempProductBaseDTO> getAllBaseProduct(Integer recordId, String database) {
        return productDao.getAllBaseProduct(recordId, database);
    }

    @Override
    public boolean update(TempProductUpdate input, String database) {
        int updateRow = productDao.update(input, database);
        return updateRow == 1;
    }

    @Override
    public void delete(List<Integer> ids, String database) {
        productDao.delete(ids, database);
    }
}
