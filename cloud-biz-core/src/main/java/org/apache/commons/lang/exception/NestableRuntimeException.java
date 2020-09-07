//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by Fernflower decompiler)
//

package org.apache.commons.lang.exception;

import net.logstash.logback.encoder.org.apache.commons.lang.exception.Nestable;
import net.logstash.logback.encoder.org.apache.commons.lang.exception.NestableDelegate;

import java.io.PrintStream;
import java.io.PrintWriter;

public class NestableRuntimeException extends RuntimeException implements Nestable {
    private static final long serialVersionUID = 1L;
    protected NestableDelegate delegate = new NestableDelegate(this);
    private Throwable cause = null;

    public NestableRuntimeException() {
    }

    public NestableRuntimeException(String msg) {
        super(msg);
    }

    public NestableRuntimeException(Throwable cause) {
        this.cause = cause;
    }

    public NestableRuntimeException(String msg, Throwable cause) {
        super(msg);
        this.cause = cause;
    }

    public Throwable getCause() {
        return this.cause;
    }

    public String getMessage() {
        if (super.getMessage() != null) {
            return super.getMessage();
        } else {
            return this.cause != null ? this.cause.toString() : null;
        }
    }

    public String getMessage(int index) {
        return index == 0 ? super.getMessage() : this.delegate.getMessage(index);
    }

    public String[] getMessages() {
        return this.delegate.getMessages();
    }

    public Throwable getThrowable(int index) {
        return this.delegate.getThrowable(index);
    }

    public int getThrowableCount() {
        return this.delegate.getThrowableCount();
    }

    public Throwable[] getThrowables() {
        return this.delegate.getThrowables();
    }

    public int indexOfThrowable(Class type) {
        return this.delegate.indexOfThrowable(type, 0);
    }

    public int indexOfThrowable(Class type, int fromIndex) {
        return this.delegate.indexOfThrowable(type, fromIndex);
    }

    public void printStackTrace() {
        this.delegate.printStackTrace();
    }

    public void printStackTrace(PrintStream out) {
        this.delegate.printStackTrace(out);
    }

    public void printStackTrace(PrintWriter out) {
        this.delegate.printStackTrace(out);
    }

    public final void printPartialStackTrace(PrintWriter out) {
        super.printStackTrace(out);
    }
}

