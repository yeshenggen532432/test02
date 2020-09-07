package com.qweib.cloud.biz.system;


import com.qweibframework.commons.StringUtils;

/**
 * @author: jimmy.lin
 * @time: 2019/2/2 13:35
 * @description:
 */
public class ViewContext {

    private static ThreadLocal<String> VERSION = new ThreadLocal<>();
    private static ThreadLocal<String> PREVIOUS = new ThreadLocal<>();
    private static ThreadLocal<String> STICKY = new ThreadLocal<>();

    public static void setPrevious(String previous) {
        PREVIOUS.set(previous);
    }

    public static void setVersion(String version) {
        VERSION.set(version);
    }

    public static void setSticky(String sticky) {
        STICKY.set(sticky);
    }

    public static String getVersion() {
        return VERSION.get();
    }

    public static String getPrevious() {
        return PREVIOUS.get();
    }

    public static String getSticky() {
        return STICKY.get();
    }

    public static boolean changed() {
        return !StringUtils.equals(getVersion(), getPrevious());
    }

    public static void clear() {
        VERSION.remove();
        PREVIOUS.remove();
        STICKY.remove();
    }
}
