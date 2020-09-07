package com.qweib.cloud.biz.api;

import com.qweib.cloud.biz.system.service.register.RegisterService;
import com.qweib.cloud.biz.system.service.register.dto.CompanyRegisterInput;
import com.qweib.cloud.service.initial.domain.company.event.RegisterDeviceEnum;
import com.qweib.cloud.service.member.domain.member.salesman.SysSalesmanDTO;
import com.qweib.cloud.service.member.retrofit.SysSalesmanRequest;
import com.qweibframework.commons.http.ResponseUtils;
import com.qweibframework.commons.web.BaseController;
import com.qweibframework.commons.web.dto.Response;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.ArrayList;
import java.util.List;

/**
 * @author: jimmy.lin
 * @time: 2019/10/31 12:04
 * @description:
 */
@Slf4j
@RestController
@RequestMapping({"api/company/register", "web/company/register"})
public class CompanyRegisterApiController extends BaseController {
    @Autowired
    private RegisterService registerService;
//    @Autowired
//    private SysSalesmanRequest salesmanApi;

    @PostMapping("code")
    public Response sendCode(@RequestParam("mobile") String mobile) {
        return success(registerService.sendCode(mobile));
    }

    @PostMapping
    public Response register(@Valid CompanyRegisterInput company) throws Exception {
        company.setDevice(RegisterDeviceEnum.MOBILE);
        registerService.register(company);
        return success().message("注册成功");
    }

    @GetMapping("salesman")
    public Response<List<SysSalesmanDTO>> getSysSalesmanList() {
        List<SysSalesmanDTO> salesmanList = new ArrayList();// ResponseUtils.convertResponse(salesmanApi.list());
        return success(salesmanList);
    }
}
