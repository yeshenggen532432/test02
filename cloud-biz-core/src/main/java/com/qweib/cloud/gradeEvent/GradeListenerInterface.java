package com.qweib.cloud.gradeEvent;

public interface GradeListenerInterface {

    /**
     * 监听对象
     *
     * @return
     */
    GradeEvent.Type monitorType();

    int saveNotice(GradeEventBean gradeEventBean);

    int updateNotice(GradeEventBean gradeEventBean);

    int deleteNotice(GradeEventBean gradeEventBean);
}
