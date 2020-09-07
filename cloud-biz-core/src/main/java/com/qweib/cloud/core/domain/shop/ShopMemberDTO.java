package com.qweib.cloud.core.domain.shop;

import lombok.Data;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2019/5/5 - 10:12
 */
@Data
public class ShopMemberDTO {

    /**
     * 会员ID
     */
    private Integer id;
    /**
     * 姓名
     */
    private String name;
    /**
     * 手机号码
     */
    private String mobile;
    /**
     * 平台会员 id
     */
    private Integer memberId;
    /**
     * 注册日期
     */
    private String registerDate;
    /**
     * 激活日期
     */
    private String activeDate;
    /**
     * 状态
     */
    private ShopMemberStatusEnum status;
    /**
     * 客户关联表 id
     */
    private Integer customerId;
    /**
     * 客户关联表 名称
     */
    private String customerName;
    /**
     * 店号，除了门店外，其他根据来源来处理(客户：9996，app：9997，员工：9998，微信：9999)
     */
    private String shopNo;
    /**
     * 会员来源：1普通，2员工，3进销存客户，4门店
     */
    private String source;
    /**
     * 会员来源 app：微信，门店，员工管理，客户管理等等
     */
    private String hySource;
}
