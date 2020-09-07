package com.qweib.cloud.biz.system.controller.dto;

import lombok.Data;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2019/10/25 - 11:05
 */
@Data
public class SalesmanMenuDTO {

    private Integer authorityId;
    private Integer menuId;
    private Integer authorityType;
    private String ifChecked;//是否选中
}
