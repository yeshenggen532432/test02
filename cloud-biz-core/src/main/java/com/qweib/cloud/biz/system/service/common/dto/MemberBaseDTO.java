package com.qweib.cloud.biz.system.service.common.dto;

import lombok.Data;

/**
 * @author zzx
 * @version 1.1 2019/11/9
 * @description:会员基础资料
 */
@Data
public class MemberBaseDTO {

    /**
     * 会员ID，可能是商城会员ID或员工会员ID
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


    public MemberBaseDTO() {

    }

    public MemberBaseDTO(Integer id, Integer memberId, String name, String mobile) {
        this.id = id;
        this.memberId = memberId;
        this.name = name;
        this.mobile = mobile;
    }

}
