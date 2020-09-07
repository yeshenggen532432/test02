package com.qweib.cloud.biz.system.controller.plat.vo;

import lombok.Data;

import javax.validation.constraints.NotNull;

/**
 * @author: jimmy.lin
 * @time: 2019/9/2 15:32
 * @description:
 */
@Data
public class ResetPwdRequest extends MobileRequest {
    @NotNull
    private String password;
    @NotNull
    private String code;
}
