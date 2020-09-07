package com.qweib.cloud.biz.system.service.register.impl;

import com.qweib.cloud.biz.common.JavaSmsApi;
import com.qweib.cloud.biz.system.UserContext;
import com.qweib.cloud.biz.system.service.plat.SysCorporationService;
import com.qweib.cloud.biz.system.service.register.RegisterService;
import com.qweib.cloud.biz.system.service.register.dto.CompanyRegisterInput;
import com.qweib.cloud.core.domain.SysCorporation;
import com.qweib.cloud.core.domain.SysLoginInfo;
import com.qweib.cloud.core.exception.BizException;
import com.qweib.cloud.repository.utils.HttpResponseUtils;
import com.qweib.cloud.service.initial.domain.MessageResult;
import com.qweib.cloud.service.initial.retrofit.CompanyInitialRequest;
import com.qweib.cloud.service.member.domain.corporation.CompanyExtDTO;
import com.qweib.cloud.service.member.domain.corporation.SysCorporationSave;
import com.qweib.cloud.service.member.retrofit.SysCorporationRequest;
import com.qweib.commons.Identities;
import com.qweib.commons.mapper.BeanMapper;
import com.qweibframework.commons.StringUtils;
import com.qweibframework.commons.web.dto.Response;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.RandomStringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Service;
import retrofit2.Call;

import java.io.IOException;
import java.util.Objects;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;
import java.util.concurrent.TimeUnit;

/**
 * @author: jimmy.lin
 * @time: 2019/11/6 15:09
 * @description:
 */
@Service
@Slf4j
public class RegisterServiceImpl implements RegisterService {
    private static final String REGISTER_CODE_PREFIX = "code:register:";
//    @Autowired
//    private CompanyInitialRequest companyInitApi;
    @Autowired
    @Qualifier("stringRedisTemplate")
    private StringRedisTemplate redisTemplate;
    @Qualifier("confStringRedisTemplate")
    @Autowired
    private StringRedisTemplate configTemplate;
//    @Autowired
//    private SysCorporationRequest companyApi;

    @Autowired
    private SysCorporationService sysCorporationService;

    private ExecutorService executor = Executors.newCachedThreadPool();

    @Override
    public void register(CompanyRegisterInput company) throws Exception {
        SysLoginInfo principal = UserContext.getLoginInfo();
        String code = redisTemplate.opsForValue().get(REGISTER_CODE_PREFIX + company.getMobile() + ":" + company.getSmsToken());
        if (!StringUtils.equals(company.getCode(), code)) {
            throw new BizException("验证码错误");
        }
        SysCorporation request = new SysCorporation();
        request.setPageVersion(1);
        request.setDeptNm(company.getName());
        request.setTpNm("快消");
        request.setMobile(company.getMobile());
        request.setDeptHead(company.getLeader());
        request.setMemberId(principal.getIdKey());
        //request.set(company.getSalesman());
        //request.setSalesmanId(company.getSalesmanId());
//        if (Objects.isNull(request.getSalesmanId())) {
//            // 如果平台业务员为空，默认系统小白
//            request.setSalesman("系统小白");
//            request.setSalesmanId(3870);
//        }
        Integer companyId = this.sysCorporationService.addCompany(request,"","",0,"","");  //HttpResponseUtils.convertResponse(companyApi.save(request));
        if (Objects.nonNull(company.getDevice())) {
            this.configTemplate.opsForValue().set("config::register:" + companyId, String.valueOf(company.getDevice().getDevice()), 2, TimeUnit.HOURS);
        }
//        CompanyExtDTO ext = BeanMapper.map(company, CompanyExtDTO.class);
//        ext.setId(companyId);
//        Call<Response> call = companyApi.updateCompanyExt(ext);
//        call.execute().body();
//        final String taskId = HttpResponseUtils.convertResponse(companyInitApi.initial(companyId));
//        Future<MessageResult> future = executor.submit(() -> {
//            MessageResult result;
//            while (true) {
//                result = HttpResponseUtils.convertResponse(companyInitApi.getResult(taskId));
//                log.debug("task status:  {} {}", result.getMessage(), result.getStatus());
//                if (result.getStatus() == 1) {
//                    log.debug("waiting...");
//                    TimeUnit.SECONDS.sleep(2);
//                } else {
//                    log.debug("finished!");
//                    break;
//                }
//            }
//            return result;
//        });
//        //
//        MessageResult result = future.get(10, TimeUnit.MINUTES);
//        if (!Objects.equals(result.getStatus(), 2)) {
//            log.error("init failed:{}", result.getMessage());
//            throw new BizException("注册失败:" + result.getMessage());
//        }
//        //移除验证码
//        redisTemplate.delete(REGISTER_CODE_PREFIX + company.getMobile() + ":" + company.getSmsToken());
    }

    @Override
    public String sendCode(String mobile) {
        String random = RandomStringUtils.random(4, false, true);
        String token = Identities.uuid();
        redisTemplate.opsForValue().set(REGISTER_CODE_PREFIX + mobile + ":" + token, random, 15, TimeUnit.MINUTES);
        final String sms = "【驰用T3】您的验证码是" + random;
        log.debug("send sms [{}] to [{}], token:[{}]", sms, mobile, token);
        try {
            JavaSmsApi.sendSms(sms, mobile);
            return token;
        } catch (IOException e) {
            log.error("发送验证码失败", e);
            throw new BizException("验证码发送失败,请稍后再试");
        }
    }
}
