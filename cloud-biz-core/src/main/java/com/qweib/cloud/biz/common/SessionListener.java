package com.qweib.cloud.biz.common;

import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;
import java.util.HashMap;
import java.util.Map;

/**
 * SessionListener.java类文件描述说明.
 * 
 * @author lhq
 * @since JDK 1.6
 * @see
 */
@SuppressWarnings("unchecked")
public class SessionListener implements HttpSessionListener {

    public static Map sessionMap = new HashMap();
    private SessionContext sessionContext = SessionContext.getInstance();

    public void sessionCreated(HttpSessionEvent httpSessionEvent) {
        sessionContext.AddSession(httpSessionEvent.getSession());
    }

    public void sessionDestroyed(HttpSessionEvent httpSessionEvent) {
        HttpSession session = httpSessionEvent.getSession();
        sessionContext.DelSession(session);
    }

}
