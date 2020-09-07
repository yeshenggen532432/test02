package com.qweib.cloud.biz.system.controller.plat;

import com.qweib.cloud.biz.common.JavaSmsApi;
import com.qweib.cloud.biz.system.ViewContext;
import com.qweib.cloud.biz.system.controller.plat.vo.MobileRequest;
import com.qweib.cloud.biz.system.controller.plat.vo.ResetPwdRequest;
import com.qweib.cloud.biz.system.controller.plat.vo.SmsMessage;
import com.qweib.cloud.biz.system.security.Platform;
import com.qweib.cloud.biz.system.security.SecurityManager;
import com.qweib.cloud.biz.system.service.plat.SysLoginService;
import com.qweib.cloud.biz.system.service.plat.SysMemberService;
import com.qweib.cloud.core.domain.SysLoginInfo;
import com.qweib.commons.exceptions.BizException;
import com.qweib.commons.mapper.JsonMapper;
import com.qweibframework.commons.StringUtils;
import com.qweibframework.commons.web.BaseController;
import com.qweibframework.commons.web.dto.Response;
import com.wf.captcha.utils.CaptchaUtil;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.RandomUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;
import java.util.concurrent.TimeUnit;

/**
 * @author: jimmy.lin
 * @time: 2019/9/2 15:08
 * @description:
 */
@Slf4j
@RequestMapping("forget")
@Controller
public class ForgetController extends BaseController {
    private static final String FORGET_SMS_CODE = "forget_sms_code:";
    @Autowired
    private SecurityManager securityManager;
    @Autowired
    @Qualifier("stringRedisTemplate")
    private StringRedisTemplate redisTemplate;
    @Autowired
    private SysMemberService memberService;
    @Autowired
    private SysLoginService loginService;

    @GetMapping()
    public String page(HttpServletRequest request) {
        SysLoginInfo info = (SysLoginInfo) request.getSession().getAttribute("usr");
        if (info != null) {
            //已登录回到首页
            return "redirect:/";
        }
        ViewContext.setSticky("v2");
        return "main/forget";
    }

    @PostMapping("code")
    @ResponseBody
    public Response sendCode(@Valid @RequestBody MobileRequest request, HttpServletRequest httpServletRequest) {

        if (!CaptchaUtil.ver(request.getCaptcha(), httpServletRequest)) {
            return response().code(400).message("验证码错误");
        }

        Long expire = redisTemplate.getExpire(FORGET_SMS_CODE + request.getMobile(), TimeUnit.MINUTES);
        if (expire > 14) {
            return response().code(400).message("验证码已发送，请稍后再试");
        }
        final int random = RandomUtils.nextInt(1000, 9999);
        final String sms = "【驰用T3】您的验证码是" + random;
        log.debug("sending forget sms: [{}] {}", request.getMobile(), sms);
        try {
            String result = JavaSmsApi.sendSms(sms, request.getMobile());
            SmsMessage message = JsonMapper.fromJsonString(result, SmsMessage.class);
            if (message.isSuccess()) {
                redisTemplate.opsForValue().set(FORGET_SMS_CODE + request.getMobile(), String.valueOf(random), 15, TimeUnit.MINUTES);
                return success().message("验证码发送成功");
            } else {
                CaptchaUtil.clear(httpServletRequest);
                return response("验证码发送失败").code(500);
            }
        } catch (Exception e) {
            CaptchaUtil.clear(httpServletRequest);
            log.error("发送验证码失败", e);
            return response().code(500).message("验证码发送失败，请稍后再试");
        }
    }

    @ResponseBody
    @PostMapping("reset")
    public Response reset(@Valid @RequestBody ResetPwdRequest pwd, HttpServletRequest request) {
        if (!CaptchaUtil.ver(pwd.getCaptcha(), request)) {
            CaptchaUtil.clear(request);
            throw new BizException("验证码错误");
        }
        String code = redisTemplate.opsForValue().get(FORGET_SMS_CODE + pwd.getMobile());
        if (!StringUtils.equals(code, pwd.getCode())) {
            CaptchaUtil.clear(request);
            throw new BizException("手机验证码错误");
        }

        SysLoginInfo info = loginService.queryLoginInfo(pwd.getMobile());
        if (info == null) {
            CaptchaUtil.clear(request);
            throw new BizException("用户不存在");
        }
        Boolean ret = memberService.updateSysMemberPassword(info.getIdKey(), pwd.getPassword());
        if (!ret) {
            CaptchaUtil.clear(request);
            throw new BizException("操作失败，请稍后再试");
        }
        securityManager.reset(pwd.getMobile(), Platform.PC);
        CaptchaUtil.clear(request);
        return success().message("密码重置成功！");
    }


}
