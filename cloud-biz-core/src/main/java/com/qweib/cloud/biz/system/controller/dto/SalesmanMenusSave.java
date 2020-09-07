package com.qweib.cloud.biz.system.controller.dto;

import lombok.Data;

import java.util.List;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2019/10/25 - 11:04
 */
@Data
public class SalesmanMenusSave {

    private Integer memberId;
    private Integer type;

    private List<SalesmanMenuDTO> menus;
}
