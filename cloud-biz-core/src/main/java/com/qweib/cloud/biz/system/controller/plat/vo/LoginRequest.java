package com.qweib.cloud.biz.system.controller.plat.vo;

import lombok.Data;

import javax.validation.constraints.NotNull;

/**
 * @author: jimmy.lin
 * @time: 2019/4/29 16:58
 * @description:
 */
@Data
public class LoginRequest {
    @NotNull
    private String company;
    @NotNull(message = "请输入用户名")
    private String username;
    @NotNull(message = "请输入密码")
    private String password;
}
