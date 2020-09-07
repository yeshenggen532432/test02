package com.qweib.cloud.gradeEvent;

import com.qweibframework.boot.datasource.DataSourceContextAllocator;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationListener;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Component;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 监听操作,然后转发对应事件处理
 */
@Slf4j
@Component
public class GradeListener implements ApplicationListener<GradeEvent> {

    private Map<GradeEvent.Type, GradeListenerInterface> interfaceMap;
    @Autowired
    private DataSourceContextAllocator allocator;

    public GradeListener(List<GradeListenerInterface> gradeChangeInterface) {
        if (interfaceMap == null)
            interfaceMap = new HashMap<>(gradeChangeInterface.size());
        gradeChangeInterface.forEach(item -> {
            interfaceMap.put(item.monitorType(), item);
        });
    }

    @Async
    @Override
    public void onApplicationEvent(GradeEvent gradeBaseEvent) {
        try {
            //动态数据源
            allocator.alloc(gradeBaseEvent.gradeEventBean.getDatabase(), gradeBaseEvent.gradeEventBean.getCompanyId());
            log.info("等级监听器发现" + gradeBaseEvent.getSourceType() + "等级操作" + gradeBaseEvent.getOption());
            GradeListenerInterface changeInterface = interfaceMap.get(gradeBaseEvent.getSourceType());
            if (changeInterface == null) return;
            if (gradeBaseEvent.getOption() == GradeEvent.Option.save)
                changeInterface.saveNotice(gradeBaseEvent.gradeEventBean);

            if (gradeBaseEvent.getOption() == GradeEvent.Option.update)
                changeInterface.updateNotice(gradeBaseEvent.gradeEventBean);

            if (gradeBaseEvent.getOption() == GradeEvent.Option.del)
                changeInterface.deleteNotice(gradeBaseEvent.gradeEventBean);
        } finally {
            allocator.release();
        }
    }
}
