package com.qweib.cloud.memberEvent;

import com.qweib.cloud.core.domain.SysLoginInfo;
import com.qweib.cloud.core.domain.SysMember;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.context.ApplicationEventPublisherAware;
import org.springframework.stereotype.Component;

import java.util.Objects;

@Component
public class MemberPublisher implements ApplicationEventPublisherAware {
    private ApplicationEventPublisher applicationEventPublisher;

    @Override
    public void setApplicationEventPublisher(ApplicationEventPublisher applicationEventPublisher) {
        this.applicationEventPublisher = applicationEventPublisher;
    }

    /**
     * 客户认证手机号码修改时
     *
     * @param origMobile   原手机号
     * @param newMobile    新认证手机号
     * @param customerId   客户ID
     * @param customerName 客户名称
     * @param info         登陆信息
     */
    public void customerRzMobileChange(String origMobile, String newMobile, Integer customerId, String customerName, SysLoginInfo info) {
        if (Objects.equals(origMobile, newMobile)) return;
        applicationEventPublisher.publishEvent(new MemberEvent(MemberEvent.Type.customerAuthMobile, origMobile, newMobile, customerId, customerName, info.getDatasource(), info.getFdCompanyId()));
    }

    /**
     * 客户倒闭时调用
     *
     * @param customerId 客户ID
     * @param isDb       是否倒闭（1是；2否）
     * @param info       登陆信息
     */
    public void customerIsDbChange(Integer customerId, Integer isDb, SysLoginInfo info) {
        if (customerId == null) return;
        applicationEventPublisher.publishEvent(new MemberEvent(MemberEvent.Type.customerIsDb, customerId, isDb, info.getDatasource(), info.getFdCompanyId()));
    }

    /**
     * 员工状态修改时
     *
     * @param mobile    手机号
     * @param memberUse 使用状态 1:使用2：禁用
     * @param database  数据库
     * @param companyId 公司ID
     */
    public void staffUpdate(SysMember sysMember, String database, String companyId) {
        MemberEvent event = new MemberEvent(MemberEvent.Type.staffUseChange, sysMember.getMemberMobile(), null, null, sysMember.getMemberNm(), database, companyId);
        event.setState(("1".equals(sysMember.getMemberUse()) ? 1 : 2));
        event.setMemberType(sysMember.getMemberType());
        applicationEventPublisher.publishEvent(event);
    }

    /**
     * 增加员工时
     *
     * @param mobile
     * @param memberName
     * @param database
     * @param companyId
     */
    public void staffAdd(SysMember sysMember, String database, String companyId) {
        MemberEvent memberEvent = new MemberEvent(MemberEvent.Type.staffAdd, null, sysMember.getMemberMobile(), null, sysMember.getMemberNm(), database, companyId);
        memberEvent.setMemberType(sysMember.getMemberType());
        memberEvent.setMemId(sysMember.getMemberId());
        applicationEventPublisher.publishEvent(memberEvent);
    }
}
