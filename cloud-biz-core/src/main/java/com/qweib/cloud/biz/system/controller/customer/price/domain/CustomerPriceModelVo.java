package com.qweib.cloud.biz.system.controller.customer.price.domain;

import com.qweib.cloud.biz.system.controller.plat.vo.importVo.DownCustomerPriceVo;
import lombok.Data;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2019/4/22 - 17:59
 */
@Data
public class CustomerPriceModelVo extends DownCustomerPriceVo {

    private Integer waretype;//分类ID
}
