package com.qweib.cloud.gradeEvent;

import com.qweib.cloud.core.domain.SysLoginInfo;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.context.ApplicationEventPublisherAware;
import org.springframework.stereotype.Component;

/**
 * 事件发送
 */
@Component
public class GradePulisher implements ApplicationEventPublisherAware {

    private ApplicationEventPublisher applicationEventPublisher;

    @Override
    public void setApplicationEventPublisher(ApplicationEventPublisher applicationEventPublisher) {
        this.applicationEventPublisher = applicationEventPublisher;
    }

    public void setShopEventPublisher(GradeEvent.Option option, Integer id, String name, SysLoginInfo info) {
        applicationEventPublisher.publishEvent(new GradeEvent(GradeEvent.Type.shop, option, new GradeEventBean(id, name, info.getDatasource(), info.getFdCompanyId())));
    }


    public void setPosEventPublisher(GradeEvent.Option option, Integer id, String name, SysLoginInfo info) {
        applicationEventPublisher.publishEvent(new GradeEvent(GradeEvent.Type.pos, option, new GradeEventBean(id, name, info.getDatasource(), info.getFdCompanyId())));
    }
}
