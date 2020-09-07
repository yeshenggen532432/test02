package com.qweib.cloud.core.domain.shop;

import lombok.Data;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2019/5/5 - 16:46
 */
@Data
public class ShopMemberCompanySave {

    private Integer memberId;
    private String memberName;
    private String memberMobile;
    private Integer companyId;
    private String companyName;
}
