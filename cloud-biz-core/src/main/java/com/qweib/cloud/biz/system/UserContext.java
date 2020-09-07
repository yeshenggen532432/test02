package com.qweib.cloud.biz.system;

import com.qweib.cloud.core.domain.SysLoginInfo;
import org.springframework.core.NamedInheritableThreadLocal;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2019/1/10 - 9:59
 */
public class UserContext {

    private static final ThreadLocal<SysLoginInfo> CONTEXT_USER_ID = new NamedInheritableThreadLocal("login_info");

    private static final ThreadLocal<String> DATASOURCE = new InheritableThreadLocal<>();

    public static void setDataSourceKey(String key) {
        DATASOURCE.set(key);
    }

    public static String getDataSourceKey() {
        return DATASOURCE.get();
    }


    public static void setLoginInfo(SysLoginInfo loginInfo) {
        CONTEXT_USER_ID.set(loginInfo);
    }

    public static SysLoginInfo getLoginInfo() {
        return CONTEXT_USER_ID.get();
    }

    public static void clearLoginInfo() {
        CONTEXT_USER_ID.remove();
    }

    public static void clearDataSourceKey() {
        DATASOURCE.remove();
    }

    public static String datasource() {
        SysLoginInfo principal = getLoginInfo();
        return principal != null ? principal.getDatasource() : null;
    }
}
