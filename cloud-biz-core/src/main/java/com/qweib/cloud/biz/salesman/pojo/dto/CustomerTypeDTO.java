package com.qweib.cloud.biz.salesman.pojo.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * Description: 客户类型
 *
 * @author zeng.gui
 * Created on 2019/7/16 - 11:06
 */
@AllArgsConstructor
@Getter
public class CustomerTypeDTO {

    private final Integer id;
    private final String name;
    private final String code;
}
