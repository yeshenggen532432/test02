package com.qweib.cloud.memberEvent;

import lombok.Data;
import org.springframework.context.ApplicationEvent;

@Data
public class MemberEvent extends ApplicationEvent {

    private Type type;
    private String origMobile;//原手机号
    private String newMobile;//新手机号
    private Integer customerId;//客户ID
    private String name;//客户名称或会员名称
    private Integer state;//状态

    private String database;
    private String companyId;//公司ID
    private Integer memberType;//员工类型
    private Integer memId;//会员平台ID


    public MemberEvent(Type type, Integer customerId, Integer state, String database, String companyId) {
        super(MemberEvent.class);
        this.type = type;
        this.customerId = customerId;
        this.state = state;
        this.database = database;
        this.companyId = companyId;
    }


    public MemberEvent(Type type, String origMobile, String newMobile, Integer customerId, String name, String database, String companyId) {
        super(MemberEvent.class);
        this.type = type;
        this.origMobile = origMobile;
        this.newMobile = newMobile;
        this.customerId = customerId;
        this.name = name;
        this.database = database;
        this.companyId = companyId;
    }


    public enum Type {
        //客户商城手机认证，员工增加，客户倒闭,员工离职或恢复在职
        customerAuthMobile, staffAdd, customerIsDb, staffUseChange,staff,customerRzMobile
    }

    public String getOrigMobile() {
        return origMobile;
    }

    public String getNewMobile() {
        return newMobile;
    }


    public String getDatabase() {
        return database;
    }
}
