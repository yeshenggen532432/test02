package com.qweib.cloud.biz.salesman.common;

import com.qweib.cloud.biz.salesman.pojo.dto.BaseResultDTO;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2019/7/18 - 15:07
 */
public class PushMoneyUtils {

    public static void copyResultData(BaseResultDTO sourceDTO, BaseResultDTO targetDTO) {
        targetDTO.setBillNo(sourceDTO.getBillNo());
        targetDTO.setBillType(sourceDTO.getBillType());
        targetDTO.setSalesmanId(sourceDTO.getSalesmanId());
        targetDTO.setSalesmanName(sourceDTO.getSalesmanName());
        targetDTO.setCustomerId(sourceDTO.getCustomerId());
        targetDTO.setCustomerName(sourceDTO.getCustomerName());
        targetDTO.setWareId(sourceDTO.getWareId());
        targetDTO.setWareName(sourceDTO.getWareName());
        targetDTO.setUnitName(sourceDTO.getUnitName());
    }
}
