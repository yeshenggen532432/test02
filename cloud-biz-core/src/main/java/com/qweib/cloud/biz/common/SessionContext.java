package com.qweib.cloud.biz.common;

import com.qweib.cloud.utils.SpringContextHolder;
import org.springframework.session.ExpiringSession;
import org.springframework.session.SessionRepository;

import javax.servlet.http.HttpSession;
import java.util.HashMap;

/**
 * SessionContext.java类文件描述说明.
 *
 * @author lhq
 * @see
 * @since JDK 1.6
 */
@SuppressWarnings("unchecked")
public class SessionContext {

    private static SessionContext sessionContext;
    private HashMap sessionMap;

    private SessionContext() {
        sessionMap = new HashMap();
    }

    public static SessionContext getInstance() {
        if (sessionContext == null) {
            sessionContext = new SessionContext();
        }
        return sessionContext;
    }

    public synchronized void AddSession(HttpSession session) {
        if (session != null) {
            sessionMap.put(session.getId(), session);
        }
    }

    public synchronized void DelSession(HttpSession session) {
        if (session != null) {
            sessionMap.remove(session.getId());
        }
    }

    public synchronized HttpSession getSession(String sessionId) {
        if (sessionId == null) {
            return null;
        }
        SessionRepository<ExpiringSession> sessionRepository = SpringContextHolder.getBean(SessionRepository.class);
        if (sessionRepository != null) {
            ExpiringSession session = sessionRepository.getSession(sessionId);
            return new MockSession(session);
        }
        return null;
    }

}
