package com.qweib.cloud.core.domain.shop;

import lombok.Data;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2019/5/5 - 14:52
 */
@Data
public class ShopMemberUpdate extends ShopMemberSave {

    private Integer id;
    /**
     * 客户关联表 id
     */
    private Integer customerId;
    /**
     * 客户关联表 名称
     */
    private String customerName;
}
