package com.qweib.cloud.core.domain.vo;

/**
 * @author zzx
 * @version 1.1 2020/5/6
 * @description:员工类型:1员工,2站长,4联盟商家
 */
public enum SysMemberTypeEnum {
    general(1, "员工"), pick_shop_manager(2, "自提站长"), star_shop_manager(4, "联盟商家");

    private int type;

    private String memo;

    SysMemberTypeEnum(int type, String memo) {
        this.type = type;
        this.memo = memo;
    }

    public int getType() {
        return type;
    }
}
