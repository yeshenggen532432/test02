package com.qweib.cloud.biz.system.controller.plat.vo;

import lombok.Data;

import java.util.List;

@Data
public class MemberForm {
    private Integer memberId;
    private String memberNm;
    private String memberMobile;
    private String memberJob;
    private String memberTrade;
    private String isLead;
    private List<Integer> roleIds;
    private Integer branchId;
    private String memberHometown;
    private String memberDesc;
    private String memberPwd;
    private String memberUse;
    private String oldisLead;
    private Integer memberType;
    private String empNo;

}
