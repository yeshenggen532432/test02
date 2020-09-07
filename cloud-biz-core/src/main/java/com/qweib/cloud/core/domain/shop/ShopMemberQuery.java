package com.qweib.cloud.core.domain.shop;

import lombok.Data;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2019/5/5 - 14:29
 */
@Data
public class ShopMemberQuery {

    private Integer id;
    private String mobile;
    private String openId;
    private Integer memId;
}
