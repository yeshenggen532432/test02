package com.qweib.cloud.core.domain.product;

import lombok.Data;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2019/5/21 - 16:35
 */
@Data
public class TempProductBaseDTO {

    private Integer id;
    /**
     * 商品名称
     * ware_nm
     */
    private String productName;
}
