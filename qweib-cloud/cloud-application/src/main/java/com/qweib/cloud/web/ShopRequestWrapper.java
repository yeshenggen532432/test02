package com.qweib.cloud.web;

import com.qweib.commons.StringUtils;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletRequestWrapper;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpServletResponseWrapper;
import java.io.IOException;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;
import java.util.Vector;

//@WebFilter(filterName = "paramFilter", urlPatterns = "/*")//过滤器拦截所有请求
//@Order(100)//括号中的数字越大，在多个过滤器的执行顺序越靠前
public class ShopRequestWrapper implements Filter {

    private String[] queryParams = {"token", "companyId"};

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {

    }

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
        HttpServletRequest wrapper = new RequestWrapper((HttpServletRequest) servletRequest);//定义一个新的request（名称是wrapper），
        //HttpServletResponseWrapper wrapper = new HttpServletResponseWrapper((HttpServletResponse) servletResponse);//定义一个新的request（名称是wrapper），
        String url = ((HttpServletRequest) servletRequest).getRequestURI();
        //if(url.indexOf("/web/") > 0)return;
        filterChain.doFilter(wrapper, servletResponse);//将修改过的request（wrapper）放回
    }

    @Override
    public void destroy() {

    }

    public class RequestWrapper extends HttpServletRequestWrapper {
        private Map<String, String[]> parameterMap; // 所有参数的Map集合

        public RequestWrapper(HttpServletRequest request) {
            super(request);
            parameterMap = new HashMap<>(request.getParameterMap());

            for (String queryParam : queryParams) {
                String data = getParameter(queryParam);
                if (StringUtils.isEmpty(data)) {
                    data = request.getHeader(queryParam);
                    if (StringUtils.isNotEmpty(data)) {
                        parameterMap.put(queryParam, new String[]{data});
                    }
                }
            }
        }

        // 重写几个HttpServletRequestWrapper中的方法

        /**
         * 获取所有参数名
         *
         * @return 返回所有参数名
         */
        @Override
        public Enumeration<String> getParameterNames() {
            Vector<String> vector = new Vector<String>(parameterMap.keySet());
            return vector.elements();
        }

        /**
         * 获取指定参数名的值，如果有重复的参数名，则返回第一个的值 接收一般变量 ，如text类型
         *
         * @param name 指定参数名
         * @return 指定参数名的值
         */
        @Override
        public String getParameter(String name) {
            String[] results = parameterMap.get(name);
            if (results == null) return null;
            return results[0];
        }


        /**
         * 获取指定参数名的所有值的数组，如：checkbox的所有数据
         * 接收数组变量 ，如checkobx类型
         */
        @Override
        public String[] getParameterValues(String name) {
            return parameterMap.get(name);
        }

        @Override
        public Map<String, String[]> getParameterMap() {
            return parameterMap;
        }

        public void setParameterMap(Map<String, String[]> parameterMap) {
            this.parameterMap = parameterMap;
        }
    }
}