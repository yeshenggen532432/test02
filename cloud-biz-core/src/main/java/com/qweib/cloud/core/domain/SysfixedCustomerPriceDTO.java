package com.qweib.cloud.core.domain;

import com.qweib.cloud.utils.Page;

import java.util.ArrayList;
import java.util.List;

public class SysfixedCustomerPriceDTO extends Page {
    private List<SysFixedCustomerPriceSumVo> sysFixedCustomerPriceSumVos = new ArrayList<>();

    public List<SysFixedCustomerPriceSumVo> getSysFixedCustomerPriceSumVos() {
        return sysFixedCustomerPriceSumVos;
    }

    public void setSysFixedCustomerPriceSumVos(List<SysFixedCustomerPriceSumVo> sysFixedCustomerPriceSumVos) {
        this.sysFixedCustomerPriceSumVos = sysFixedCustomerPriceSumVos;
    }
}
