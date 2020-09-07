package com.qweib.cloud.biz.salesman.pojo.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2019/7/16 - 11:08
 */
@AllArgsConstructor
@Getter
public class WareTypeDTO {

    private final Integer id;
    private final Integer parentId;
    private final String name;
}
