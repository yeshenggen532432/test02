package com.qweib.cloud.web.interceptor;

import com.qweib.commons.StringUtils;
import org.springframework.core.MethodParameter;
import org.springframework.web.bind.support.WebDataBinderFactory;
import org.springframework.web.context.request.NativeWebRequest;
import org.springframework.web.method.support.HandlerMethodArgumentResolver;
import org.springframework.web.method.support.ModelAndViewContainer;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;

public class TokenArgumentResolver implements HandlerMethodArgumentResolver {
    @Override
    public boolean supportsParameter(MethodParameter parameter) {

        return StringUtils.equals(parameter.getParameterName(), "token");
    }

    @Override
    public Object resolveArgument(MethodParameter parameter, ModelAndViewContainer mavContainer, NativeWebRequest webRequest, WebDataBinderFactory binderFactory) throws Exception {
        HttpServletRequest request = webRequest.getNativeRequest(HttpServletRequest.class);
        String token = request.getHeader("token");
        if (StringUtils.isEmpty(token)) {
            //token = getToken(request.getCookies());
        }
        return StringUtils.isEmpty(token) ? request.getParameter("token") : token;
    }

    private String getToken(Cookie[] cookies) {
        if (cookies == null) {
            return null;
        }
        for (Cookie cookie : cookies) {
            if (StringUtils.equals("QWEIB_TOKEN", cookie.getName())) {
                return cookie.getValue();
            }
        }
        return null;
    }
}
