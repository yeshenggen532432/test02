package com.qweib.cloud.web;

import com.qweib.cloud.biz.common.Response;
import com.qweibframework.commons.redis.token.TokenGenerator;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2019/12/4 - 11:24
 */
@RequestMapping({"/page/token","web/page/token"})
@RestController
public class PageTokenController {

    @Autowired
    private TokenGenerator tokenGenerator;

    @GetMapping("generate")
    public Response generate(String path) {
        String token = this.tokenGenerator.setToken(path);

        return Response.createSuccess(token);
    }
}
