package com.qweib.cloud.biz.system.controller.common;

import com.qweibframework.commons.web.BaseController;
import com.qweibframework.commons.web.dto.Response;
import com.qweibframework.commons.web.utils.Servlets;
import com.wf.captcha.SpecCaptcha;
import com.wf.captcha.base.Captcha;
import com.wf.captcha.utils.CaptchaUtil;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.awt.*;
import java.io.IOException;

import static com.wf.captcha.base.Captcha.TYPE_ONLY_NUMBER;

/**
 * @author: jimmy.lin
 * @time: 2019/9/2 11:18
 * @description:
 */
@Controller
public class CaptchaController extends BaseController {

    @GetMapping("captcha")
    public void captcha(HttpServletRequest request, HttpServletResponse response, Integer w, Integer h) throws IOException, FontFormatException {
        Servlets.setNoCacheHeader(response);
        response.setContentType("image/gif");
        int width = 130, height = 48;
        if (w != null && !w.equals(0)) {
            width = w;
        }
        if (h != null && !h.equals(0)) {
            height = h;
        }

        SpecCaptcha captcha = new SpecCaptcha(width, height, 4);
        captcha.setFont(Captcha.FONT_1);
        captcha.setCharType(TYPE_ONLY_NUMBER);
        CaptchaUtil.out(captcha, request, response);
    }

    @PostMapping("captcha")
    @ResponseBody
    public Response validate(HttpServletRequest request, String code) {
        return success(CaptchaUtil.ver(code, request));
    }

}
