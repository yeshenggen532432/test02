package com.qweib.cloud.biz.salesman.pojo.input;

import lombok.Data;

import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.NotNull;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2019/7/18 - 15:18
 */
@Data
public abstract class BaseSalesmanQuery {

    @NotNull
    private PushMoneyTypeEnum type;

    /**
     * 起始日期
     */
    @NotEmpty
    private String beginDate;
    /**
     * 结束日期
     */
    @NotEmpty
    private String endDate;
    /**
     * 商品类型 id
     */
    private Integer wareTypeId;

    /**
     * 单据类型
     */
    private String billType;
}
