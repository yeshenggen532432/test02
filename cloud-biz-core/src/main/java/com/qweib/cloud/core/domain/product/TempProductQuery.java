package com.qweib.cloud.core.domain.product;

import lombok.Data;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2019/5/21 - 12:13
 */
@Data
public class TempProductQuery {

    /**
     * 记录 id
     */
    private Integer recordId;
    /**
     * 产品名称
     */
    private String productName;
}
