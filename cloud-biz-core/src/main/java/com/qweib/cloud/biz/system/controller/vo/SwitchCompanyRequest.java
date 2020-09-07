package com.qweib.cloud.biz.system.controller.vo;

import lombok.Data;

import javax.validation.constraints.NotNull;

/**
 * @author jimmy.lin
 * create at 2020/4/24 15:06
 */
@Data
public class SwitchCompanyRequest {
    @NotNull
    private String jwt;
    @NotNull
    private Integer from;
    @NotNull
    private Integer to;
    @NotNull
    private String token;
}
