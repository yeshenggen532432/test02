package com.qweib.cloud.biz.system.controller.plat.vo;

import lombok.Data;

import javax.validation.constraints.NotNull;

/**
 * @author: jimmy.lin
 * @time: 2019/5/7 14:24
 * @description:
 */
@Data
public class ModifyPwdRequest {
    @NotNull(message = "请输入原名密码")
    private String oldPassword;
    @NotNull(message = "请输入新密码")
    private String newPassword;
}
