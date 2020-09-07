package com.qweib.cloud.gradeEvent;

import org.springframework.context.ApplicationEvent;

public class GradeEvent extends ApplicationEvent {

    /**
     * 操作数据
     */
    public final GradeEventBean gradeEventBean;

    /**
     * 操作方式
     */
    private Option option = null;

    /**
     * 来源类型
     */
    private Type sourceType = null;


    public GradeEvent(Type sourceType, Option option, GradeEventBean gradeEventBean) {
        super(GradeEvent.class);
        this.option = option;
        this.gradeEventBean = gradeEventBean;
        this.sourceType = sourceType;
    }


    public Option getOption() {
        return option;
    }

    public Type getSourceType() {
        return sourceType;
    }

    public enum Option {
        save, update, del
    }

    public enum Type {
        pos, shop
    }

}
