package com.qweib.cloud.core.domain.vo;

import lombok.Data;

@Data
public class ColdShopMember {
    private Integer id;
    private Integer memId;//平台会员ID
    private String source;//会员来源1：普通；2：员工；3：进销存客户 4：门店
    private String hySource;//会员来源app,微信，门店，员工管理，客户管理等等
    private String name;//会员名称
    private Integer customerId;//客户ID
    private String customerName;//客户名称

    private String mobile;//手机号
}
