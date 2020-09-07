package com.qweib.cloud.biz.system.service.register.dto;

import com.qweib.cloud.service.initial.domain.company.event.RegisterDeviceEnum;
import lombok.Data;

import javax.validation.constraints.Email;
import javax.validation.constraints.NotNull;

/**
 * @author: jimmy.lin
 * @time: 2019/11/6 14:56
 * @description:
 */
@Data
public class CompanyRegisterInput {
    @NotNull
    private String name;
    private String industryId;
    private String categoryId;
    private String brand;
    private String leader;
    @Email
    private String email;
    private String tel;
    @NotNull
    private String mobile;
    @NotNull
    private String smsToken;
    @NotNull
    private String code;
    private Integer employeeCount;
    private String bizLicenseNumber;
    private String bizLicensePic;
    /**
     * 业务员姓名
     */
    private String salesman;
    /**
     * 业务员 id
     */
    private Integer salesmanId;
    /**
     * 注册设备
     */
    private RegisterDeviceEnum device;
}
