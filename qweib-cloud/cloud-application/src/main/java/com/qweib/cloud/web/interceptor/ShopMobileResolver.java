package com.qweib.cloud.web.interceptor;

import com.qweib.cloud.biz.mall.model.ShopMember;
import com.qweib.cloud.biz.mall.util.ShopCommonUtil;
import com.qweib.cloud.biz.mall.vo.ShopResult;
import com.qweib.cloud.biz.system.TokenServer;
import com.qweib.cloud.core.domain.OnlineMessage;
import com.qweib.cloud.core.domain.OnlineUser;
import com.qweib.cloud.core.domain.SysConfig;
import com.qweib.cloud.utils.HttpUtils;
import com.qweib.cloud.utils.JsonUtil;
import com.qweib.commons.StringUtils;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * 手机端登陆验证
 */
public class ShopMobileResolver extends HandlerInterceptorAdapter {
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        String token = request.getParameter("token");
        if (StringUtils.isEmpty(token))
            return super.preHandle(request, response, handler);
        OnlineMessage message = TokenServer.tokenCheck(token);
        if (message.isSuccess() == false) {
            return write(request, response, handler, ShopResult.error(message.getMessage()));
        }
        OnlineUser onlineUser = message.getOnlineMember();
        ShopResult ret = null;
        try {

            if (onlineUser == null || onlineUser.getShopMemberId() == null) {
                ret = ShopResult.error("请登陆", ShopResult.CODE_REGISTER);
            }

        }
        catch(Exception e)
        {
            e.printStackTrace();
        }

        return write(request, response, handler, ret);
    }

    private boolean write(HttpServletRequest request, HttpServletResponse response, Object handler, ShopResult shopResult) throws Exception {
        if (shopResult != null) {
            //HttpUtils.isAjax(request) &&
            if (shopResult != null) {
                ShopCommonUtil.sendJsonResponse(response, JsonUtil.toJson(shopResult));
            } else {//页面跳转

            }
            return false;
        }
        return super.preHandle(request, response, handler);
    }
}
