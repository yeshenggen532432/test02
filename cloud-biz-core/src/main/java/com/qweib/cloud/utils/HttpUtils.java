package com.qweib.cloud.utils;

import javax.servlet.http.HttpServletRequest;

/**
 * @author: jimmy.lin
 * @time: 2019/4/29 14:20
 * @description:
 */
public class HttpUtils {
    private HttpUtils(){}

    public static boolean isAjax(HttpServletRequest request) {
        String requestedWithHeader = request.getHeader("X-Requested-With");
        return "XMLHttpRequest".equals(requestedWithHeader);
    }
}
