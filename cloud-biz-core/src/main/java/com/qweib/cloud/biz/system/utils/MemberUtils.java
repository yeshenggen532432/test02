package com.qweib.cloud.biz.system.utils;

import com.google.common.collect.Maps;
import com.qweib.cloud.core.domain.SysMember;
import com.qweib.cloud.core.domain.SysMemberCompany;
import com.qweib.cloud.repository.ws.BscEmpGroupWebDao;
import com.qweib.cloud.service.member.domain.member.SysMemberCompanyDTO;
import com.qweib.cloud.utils.Collections3;
import com.qweib.commons.DateUtils;
import com.qweibframework.commons.StringUtils;

import java.util.List;
import java.util.Map;
import java.util.Optional;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2019/4/9 - 15:49
 */
public class MemberUtils {

    /**
     * 是否领导：是
     */
    public static final String LEAD_YES = "1";

    /**
     * 转换员工企业关联信息，关查找当前企业是否存在
     *
     * @param companies
     * @param memberCompanies 员工企业关联列表
     * @param selectCompanyId 当前企业
     * @return 当前企业是否存在
     */
    public static boolean transferMemberCompanies(List<Map<String, Object>> companies, List<SysMemberCompanyDTO> memberCompanies, String selectCompanyId) {
        if (Collections3.isEmpty(memberCompanies)) {
            return false;
        }

        boolean currentIsNotNull = StringUtils.isNotBlank(selectCompanyId);
        boolean selectFind = false;
        for (SysMemberCompanyDTO memberCompany : memberCompanies) {
            Map<String, Object> item = Maps.newHashMap();
            item.put("companyId", memberCompany.getCompanyId());
            item.put("companyName", memberCompany.getCompanyName());
            companies.add(item);
            if (currentIsNotNull &&
                    selectCompanyId.equals(Optional.ofNullable(memberCompany.getCompanyId()).orElse(0).toString())) {
                selectFind = true;
            }
        }

        return selectFind;
    }

    public static boolean transferMemberCompanies1(List<Map<String, Object>> companies, List<SysMemberCompany> memberCompanies, String selectCompanyId) {
        if (Collections3.isEmpty(memberCompanies)) {
            return false;
        }
        companies.clear();
        boolean currentIsNotNull = StringUtils.isNotBlank(selectCompanyId);
        boolean selectFind = false;
        for (SysMemberCompany memberCompany : memberCompanies) {
            Map<String, Object> item = Maps.newHashMap();
            item.put("companyId", memberCompany.getCompanyId());
            item.put("companyName", memberCompany.getMemberCompany());
            companies.add(item);
            if (currentIsNotNull &&
                    selectCompanyId.equals(Optional.ofNullable(memberCompany.getCompanyId()).orElse(0).toString())) {
                selectFind = true;
            }
        }

        return selectFind;
    }

    public static void copyMemberProperties(SysMember platMember, SysMember companyMember,
                                            Integer companyId, String companyName, String database) {
        platMember.setIsLead(companyMember.getIsLead());
        platMember.setCid(companyMember.getCid());
        platMember.setEmail(companyMember.getEmail());
        platMember.setIsUnitmng(companyMember.getIsUnitmng());
        platMember.setMemberGraduated(companyMember.getMemberGraduated());
        platMember.setMemberJob(companyMember.getMemberJob());
        platMember.setMemberNm(companyMember.getMemberNm());
        platMember.setUnitId(companyId);
        platMember.setMemberCompany(companyName);
        platMember.setDatasource(database);
        platMember.setUnId(companyMember.getUnId());
        platMember.setBranchId(companyMember.getBranchId());
        platMember.setBranchName(companyMember.getBranchName());
    }

    /**
     * 生成会员企业关联实体
     *
     * @param input
     * @param companyId
     * @param memberId
     * @return
     */
    public static SysMemberCompany createBySysMember(SysMember input, Integer companyId, Integer memberId) {
        SysMemberCompany memberCompany = new SysMemberCompany();
        memberCompany.setCompanyId(companyId);
        memberCompany.setMemberMobile(input.getMemberMobile());
        memberCompany.setMemberCompany(input.getMemberCompany());
        memberCompany.setEmail(input.getEmail());
        memberCompany.setMemberGraduated(input.getMemberGraduated());
        memberCompany.setInTime(DateUtils.getDate());
        memberCompany.setMemberId(memberId);
        memberCompany.setMemberJob(input.getMemberJob());
        memberCompany.setMemberNm(input.getMemberNm());
        memberCompany.setMemberTrade(input.getMemberTrade());

        return memberCompany;
    }

    public static void setLeadGroup(BscEmpGroupWebDao empGroupDao, String isLead, Integer memberId, String datasource) {
        if ("1".equals(isLead)) {//设置领导
            String dateTime = DateUtils.getDateTime();
            //加入vip权限圈
            Map<String, Object> groups = empGroupDao.queryGroupIds(memberId, datasource);//查询不在圈内且vip开放的员工圈ids
            if (null != groups.get("ids")) {//加入vip权限圈
                String[] ids = groups.get("ids").toString().split(",");
                empGroupDao.addOpenGroupMems(ids, memberId, "4", dateTime, datasource);
            }
            //加入公开圈
            Map<String, Object> openGroups = empGroupDao.queryOpenGroups(datasource);//查询公开圈
            if (null != openGroups.get("ids")) {//加入公开圈
                String[] groupIds = openGroups.get("ids").toString().split(",");
                empGroupDao.addOpenGroupMems(groupIds, memberId, "3", dateTime, datasource);
            }
        }
    }
}
