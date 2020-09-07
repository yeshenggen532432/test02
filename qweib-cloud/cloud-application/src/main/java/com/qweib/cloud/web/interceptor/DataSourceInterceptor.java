
package com.qweib.cloud.web.interceptor;

import com.qweib.cloud.biz.system.utils.JiaMiCodeUtil;
import com.qweib.commons.StringUtils;
import com.qweibframework.boot.datasource.DataSourceContextAllocator;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * @author zzx
 * @version 1.1 2019/12/23
 * @description:
 */

@Slf4j
public class DataSourceInterceptor extends HandlerInterceptorAdapter {
    @Autowired
    private DataSourceContextAllocator allocator;

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        String wid = request.getParameter("wid");
        String companyId = request.getParameter("companyId");
        if (StringUtils.isNotEmpty(wid) || StringUtils.isNotEmpty(companyId)) {
            wid = StringUtils.isNotEmpty(wid) ? wid : companyId;
            wid = JiaMiCodeUtil.decode(wid);
            allocator.alloc(null, wid);
        }
        return super.preHandle(request, response, handler);
    }

    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception {
        allocator.release();
        super.afterCompletion(request, response, handler, ex);
    }
}

