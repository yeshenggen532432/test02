package com.qweib.cloud.biz.common;

import org.springframework.session.ExpiringSession;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpSessionContext;
import java.util.Collections;
import java.util.Enumeration;
import java.util.Set;

/**
 * @author: jimmy.lin
 * @time: 2019/10/18 15:43
 * @description:
 */
public class MockSession implements HttpSession {

    private ExpiringSession session;

    public MockSession(ExpiringSession session) {
        this.session = session;
    }

    @Override
    public long getCreationTime() {
        return this.session.getCreationTime();
    }

    @Override
    public String getId() {
        return this.session.getId();
    }

    @Override
    public long getLastAccessedTime() {
        return this.session.getLastAccessedTime();
    }

    @Override
    public ServletContext getServletContext() {
        return null;
    }

    @Override
    public void setMaxInactiveInterval(int interval) {
        this.session.setMaxInactiveIntervalInSeconds(interval);
    }

    @Override
    public int getMaxInactiveInterval() {
        return this.session.getMaxInactiveIntervalInSeconds();
    }

    @Override
    public HttpSessionContext getSessionContext() {
        return null;
    }

    @Override
    public Object getAttribute(String name) {
        return this.session.getAttribute(name);
    }

    @Override
    public Object getValue(String name) {
        return this.session.getAttribute(name);
    }

    @Override
    public Enumeration<String> getAttributeNames() {
        return Collections.enumeration(this.session.getAttributeNames());
    }

    @Override
    public String[] getValueNames() {
        Set<String> attrs = this.session.getAttributeNames();
        return attrs.toArray(new String[0]);
    }

    @Override
    public void setAttribute(String name, Object value) {
        this.session.setAttribute(name, value);
    }

    @Override
    public void putValue(String name, Object value) {
        setAttribute(name, value);
    }

    @Override
    public void removeAttribute(String name) {
        this.session.removeAttribute(name);
    }

    @Override
    public void removeValue(String name) {
        removeAttribute(name);
    }

    @Override
    public void invalidate() {

    }

    @Override
    public boolean isNew() {
        return false;
    }
}
