package com.qweib.cloud.biz.system.service.register;


import com.qweib.cloud.biz.system.service.register.dto.CompanyRegisterInput;

import java.util.concurrent.ExecutionException;

/**
 * @author: jimmy.lin
 * @time: 2019/11/6 14:56
 * @description:
 */
public interface RegisterService {

    void register(CompanyRegisterInput company) throws Exception;

    String sendCode(String mobile);

}
