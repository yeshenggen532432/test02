package com.qweib.cloud.biz.system.controller.plat.vo;

import lombok.Data;
import org.hibernate.validator.constraints.Length;

import javax.validation.constraints.NotNull;
import javax.validation.constraints.Pattern;

/**
 * @author: jimmy.lin
 * @time: 2019/9/2 15:10
 * @description:
 */
@Data
public class MobileRequest {
    @NotNull
    @Pattern(regexp = "1[0-9]{10}")
    private String mobile;
    @Length(min = 4)
    @NotNull
    private String captcha;
}
