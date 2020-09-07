package com.qweib.cloud.web.interceptor;

import com.qweib.cloud.biz.system.ViewContext;
import com.qweib.commons.CookieUtils;
import com.qweib.commons.StringUtils;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;
import org.springframework.web.util.UriComponents;
import org.springframework.web.util.UriComponentsBuilder;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * @author: jimmy.lin
 * @time: 2019/2/2 13:35
 * @description:
 */
@Slf4j
public class ViewResolverInterceptor extends HandlerInterceptorAdapter {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        String sticky = request.getParameter("_sticky");
        if (StringUtils.isEmpty(sticky)) {
            sticky = getStickyFromReferer(request);
        }
        String version = request.getParameter("v");
        if (StringUtils.isEmpty(version)) {
            version = StringUtils.trimToEmpty(CookieUtils.getCookie(request, "X-qweib-version"));
        }
        String p = (String) request.getSession().getAttribute("p");
        ViewContext.setPrevious(p);
        ViewContext.setSticky(sticky);
        ViewContext.setVersion(version);
        request.setAttribute("base", request.getContextPath());
        return super.preHandle(request, response, handler);
    }

    private String getStickyFromReferer(HttpServletRequest request) {
        String referer = request.getHeader("referer");
        if (StringUtils.isEmpty(referer)) {
            return null;
        }
        UriComponents uriComponents = UriComponentsBuilder.fromHttpUrl(referer).build();
        return uriComponents.getQueryParams().getFirst("_sticky");
    }

    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {
        request.getSession().setAttribute("p", ViewContext.getVersion());
        request.setAttribute("_sticky", ViewContext.getSticky());
        request.setAttribute("_v", ViewContext.getVersion());
        Cookie cookie = new Cookie("X-qweib-version", ViewContext.getVersion());
        cookie.setPath("/");

        response.addCookie(cookie);

        super.postHandle(request, response, handler, modelAndView);
    }

    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception {
        super.afterCompletion(request, response, handler, ex);
        ViewContext.clear();
    }
}
