package com.qweib.cloud.web;

import com.qweib.cloud.biz.system.ViewContext;
import com.qweib.commons.StringUtils;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.web.servlet.view.AbstractUrlBasedView;
import org.springframework.web.servlet.view.InternalResourceViewResolver;

import java.util.Locale;

/**
 * @author: jimmy.lin
 * @time: 2019/2/2 13:38
 * @description:
 */
@Slf4j
public class MultiVersionViewResolver extends InternalResourceViewResolver {

    @Override
    protected String getPrefix() {
        String sticky = ViewContext.getSticky();
        String version = sticky;
        if (StringUtils.isEmpty(sticky)) {
            version = ViewContext.getVersion();
        }
        if (StringUtils.equals("v2", version)) {
            return "/WEB-INF/view/v2/";
        }
        return super.getPrefix();
    }

    @Override
    protected Object getCacheKey(String viewName, Locale locale) {
        String sticky = ViewContext.getSticky();
        String version = sticky;
        if (StringUtils.isEmpty(sticky)) {
            version = ViewContext.getVersion();
        }
        return version + viewName;
    }

    @Override
    protected AbstractUrlBasedView buildView(String viewName) throws Exception {
        AbstractUrlBasedView view = (AbstractUrlBasedView) BeanUtils.instantiateClass(getViewClass());
        String url = this.getPrefix() + viewName + getSuffix();
        view.setUrl(url);
        String contentType = getContentType();
        if (contentType != null) {
            view.setContentType(contentType);
        }

        view.setRequestContextAttribute(getRequestContextAttribute());
        view.setAttributesMap(getAttributesMap());

        Boolean exposePathVariables = getExposePathVariables();
        if (exposePathVariables != null) {
            view.setExposePathVariables(exposePathVariables);
        }
        Boolean exposeContextBeansAsAttributes = getExposeContextBeansAsAttributes();
        if (exposeContextBeansAsAttributes != null) {
            view.setExposeContextBeansAsAttributes(exposeContextBeansAsAttributes);
        }
        String[] exposedContextBeanNames = getExposedContextBeanNames();
        if (exposedContextBeanNames != null) {
            view.setExposedContextBeanNames(exposedContextBeanNames);
        }
        return view;
    }


}
