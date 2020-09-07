package com.qweib.cloud.biz.system.controller.vo;

import lombok.Data;

import javax.validation.constraints.NotNull;

/**
 * @author jimmy.lin
 * create at 2020/4/24 10:08
 */
@Data
public class JwtRequest {
    @NotNull
    private String jwt;
    private String unId;
    private Integer device;
}
