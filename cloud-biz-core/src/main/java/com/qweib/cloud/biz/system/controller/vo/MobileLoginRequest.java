package com.qweib.cloud.biz.system.controller.vo;

import lombok.Data;

import javax.validation.constraints.NotNull;

/**
 * @author jimmy.lin
 * create at 2020/4/24 10:13
 */
@Data
public class MobileLoginRequest {
    @NotNull(message = "请输入手机号")
    private String mobile;
    @NotNull(message = "请输入密码")
    private String pwd;
    private String unId;
    private Integer device;
}
