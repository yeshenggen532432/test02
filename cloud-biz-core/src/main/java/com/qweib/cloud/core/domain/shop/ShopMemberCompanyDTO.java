package com.qweib.cloud.core.domain.shop;

import lombok.Data;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2019/5/5 - 16:33
 */
@Data
public class ShopMemberCompanyDTO {

    private Integer id;
    private Integer memberId;
    private String memberName;
    private Integer companyId;
    private String companyName;
}
