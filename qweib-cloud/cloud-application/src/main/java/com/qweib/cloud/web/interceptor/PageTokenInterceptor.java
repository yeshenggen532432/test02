package com.qweib.cloud.web.interceptor;

import com.qweib.commons.exceptions.BizException;
import com.qweibframework.commons.StringUtils;
import com.qweibframework.commons.redis.token.TokenCheckTag;
import com.qweibframework.commons.redis.token.TokenCreateTag;
import com.qweibframework.commons.redis.token.TokenGenerator;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.annotation.AnnotatedElementUtils;
import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.lang.reflect.Method;
import java.util.Objects;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2019/12/4 - 10:15
 */
public class PageTokenInterceptor extends HandlerInterceptorAdapter {

    private static final String TOKEN_NAME = "page_token";

    @Autowired
    private TokenGenerator tokenGenerator;

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        if (!(handler instanceof HandlerMethod)) {
            return true;
        }

        HandlerMethod handlerMethod = (HandlerMethod) handler;
        Method method = handlerMethod.getMethod();
        TokenCheckTag tokenCheckTag = AnnotatedElementUtils.findMergedAnnotation(method, TokenCheckTag.class);
        if (Objects.nonNull(tokenCheckTag)) {
            checkToken(request, tokenCheckTag);
        }

        return true;
    }

    private void checkToken(HttpServletRequest request, TokenCheckTag tokenCheckTag) {
        String token = request.getParameter(TOKEN_NAME);
        if (StringUtils.isBlank(token)) {
            return;
        }

        boolean result = this.tokenGenerator.checkToken(tokenCheckTag.path(), token);
        if (!result) {
            throw new BizException(410, "不允许重复提交");
        } else {
            PageTokenContext.setPageToken(token);
        }
    }

    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {
        if (!(handler instanceof HandlerMethod)) {
            return;
        }

        HandlerMethod handlerMethod = (HandlerMethod) handler;
        Method method = handlerMethod.getMethod();
        TokenCreateTag tokenCheckTag = AnnotatedElementUtils.findMergedAnnotation(method, TokenCreateTag.class);
        if (Objects.nonNull(tokenCheckTag)) {
            String token = this.tokenGenerator.setToken(tokenCheckTag.path());
            request.setAttribute(TOKEN_NAME, token);
        }
    }

    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception {
        if (Objects.nonNull(ex)) {
            if (!(handler instanceof HandlerMethod)) {
                return;
            }

            String pageToken = PageTokenContext.getPageToken();
            if (StringUtils.isNotBlank(pageToken)) {
                HandlerMethod handlerMethod = (HandlerMethod) handler;
                Method method = handlerMethod.getMethod();
                TokenCheckTag tokenCheckTag = AnnotatedElementUtils.findMergedAnnotation(method, TokenCheckTag.class);

                this.tokenGenerator.setToken(tokenCheckTag.path(), pageToken);
            }
        } else {
            PageTokenContext.clear();
        }
    }
}
