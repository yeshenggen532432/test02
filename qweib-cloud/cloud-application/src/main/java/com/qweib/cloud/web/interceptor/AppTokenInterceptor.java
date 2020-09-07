package com.qweib.cloud.web.interceptor;

import com.qweib.cloud.biz.common.TokenContext;
import com.qweib.cloud.biz.system.TokenServer;
import com.qweib.cloud.core.domain.OnlineMessage;
import com.qweib.cloud.core.exception.AuthException;
import com.qweib.commons.StringUtils;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class AppTokenInterceptor extends HandlerInterceptorAdapter {

    private static final String TOKEN_KEY = "QWEIB_TOKEN";

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        Cookie[] cookies = request.getCookies();
        String token = getToken(cookies);
        token = StringUtils.isEmpty(token) ? request.getParameter("token") : token;
        if (StringUtils.isEmpty(token)) {
            throw new AuthException();
        }
        OnlineMessage onlineMessage = TokenServer.tokenCheck(token);
        if (!onlineMessage.isSuccess()) {
            throw new AuthException(onlineMessage.getMessage());
        }
        TokenContext.setToken(onlineMessage);
        return super.preHandle(request, response, handler);
    }


    private String getToken(Cookie[] cookies) {
        if (cookies == null) {
            return null;
        }
        for (Cookie cookie : cookies) {
            if (StringUtils.equals(TOKEN_KEY, cookie.getName())) {
                return cookie.getValue();
            }
        }
        return null;
    }


    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {
        super.postHandle(request, response, handler, modelAndView);
    }
}
