package com.qweib.cloud.biz.system.controller.vo;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.qweib.cloud.biz.common.Response;
import lombok.Builder;
import lombok.Data;

import java.util.List;

/**
 * @author jimmy.lin
 * create at 2020/4/24 9:26
 */
@Data
@Builder
public class MobileLoginResponse extends Response {
    private String token;
    private String jwt;
    @JsonProperty("companys")
    private String companyListStr;
    private List<CompanyVO> companies;
    @JsonProperty("isUnitmng")
    private String isUnitMng;
    private String tpNm;
    private String msgmodel;
    private String memberNm;
    private String memberHead;
    private Integer rzState;
    private String memberMobile;
    private Integer memId;
    private Integer cid;
    private String datasource;
    private Integer companyId;
    private String domain;

    public MobileLoginResponse state(boolean state){
        super.setState(state);
        return this;
    }

    public MobileLoginResponse msg(String msg){
        super.setMsg(msg);
        return this;
    }
}
