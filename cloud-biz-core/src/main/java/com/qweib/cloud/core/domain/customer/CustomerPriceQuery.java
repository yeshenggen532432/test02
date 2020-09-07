package com.qweib.cloud.core.domain.customer;

import com.qweib.cloud.core.domain.BaseQuery;
import lombok.Data;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2019/4/23 - 14:43
 */
@Data
public class CustomerPriceQuery extends BaseQuery {

    private Integer customerId;
    private Integer productId;
}
