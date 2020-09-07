package com.qweib.cloud.web.interceptor;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2019/12/9 - 17:00
 */
public class PageTokenContext {

    private static ThreadLocal<String> PAGE_TOKEN = new ThreadLocal<>();

    public static void setPageToken(String token) {
        PAGE_TOKEN.set(token);
    }

    public static String getPageToken() {
        String token = PAGE_TOKEN.get();
        PAGE_TOKEN.remove();

        return token;
    }

    public static void clear() {
        PAGE_TOKEN.remove();
    }
}
