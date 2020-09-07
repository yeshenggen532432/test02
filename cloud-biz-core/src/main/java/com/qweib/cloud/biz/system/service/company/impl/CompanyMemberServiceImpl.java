package com.qweib.cloud.biz.system.service.company.impl;

import com.google.common.collect.Lists;
import com.qweib.cloud.biz.common.CompanyRoleEnum;
import com.qweib.cloud.biz.system.service.company.CompanyMemberService;
import com.qweib.cloud.biz.system.service.plat.SysCompanyRoleService;
import com.qweib.cloud.biz.system.service.plat.SysMemberCompanyService;
import com.qweib.cloud.biz.system.utils.MemberUtils;
import com.qweib.cloud.core.domain.*;
import com.qweib.cloud.core.domain.dto.SysRoleMemberDTO;
import com.qweib.cloud.repository.company.SysCompanyRoleDao;
import com.qweib.cloud.repository.company.SysMemDao;
import com.qweib.cloud.repository.plat.SysCorporationDao;
import com.qweib.cloud.repository.plat.SysMemberDao;
import com.qweib.cloud.repository.ws.BscEmpGroupWebDao;
import com.qweib.cloud.service.member.domain.corporation.SysCorporationDTO;
import com.qweib.cloud.service.member.domain.member.SysMemberCompanyRemoveAdmin;
import com.qweib.cloud.service.member.domain.member.SysMemberCompanyTransferAdmin;
import com.qweib.cloud.service.member.domain.member.SysMemberDTO;
import com.qweib.cloud.service.member.retrofit.SysCorporationRequest;
import com.qweib.cloud.service.member.retrofit.SysMemberCompanyRequest;
import com.qweib.cloud.utils.Collections3;
import com.qweib.commons.exceptions.BizException;
import com.qweibframework.commons.MathUtils;
import com.qweibframework.commons.http.ResponseUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import java.util.Optional;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2019/4/15 - 9:30
 */
@Service
public class CompanyMemberServiceImpl implements CompanyMemberService {

    @Autowired
    private SysMemDao companyMemberDao;
    @Autowired
    private SysCompanyRoleDao companyRoleDao;
    @Autowired
    private SysCompanyRoleService companyRoleService;
    @Autowired
    private SysMemberDao platMemberDao;
    @Autowired
    private SysMemberCompanyService memberCompanyService;
    @Autowired
    private BscEmpGroupWebDao empGroupDao;

    @Autowired
    private SysCorporationDao sysCorporationDao;
//    @Autowired
//    private SysMemberCompanyRequest memberCompanyRequest;
//    @Autowired
//    private SysCorporationRequest companyRequest;

    @Override
    public void updateMemberCreator(String database, Integer creatorRoleId, Integer sourceMemberId, Integer targetMemberId) {
        List<SysRoleMemberDTO> roleMemberDTOS = companyRoleDao.queryRoleMemberByRoleId(database, creatorRoleId);
        if (Collections3.isEmpty(roleMemberDTOS)) {
            throw new BizException("该企业暂无创建者");
        }

        if (roleMemberDTOS.size() > 1) {
            throw new BizException("该企业有超过一个创建者，请先移除一个创建者");
        }

        Integer creatorMemberId = roleMemberDTOS.get(0).getMemberId();
        if (!Objects.equals(creatorMemberId, sourceMemberId)) {
            throw new BizException("您不是企业创建者，不能执行此操作");
        }

        companyRoleDao.deleteCustomRoleByMemberId(database, creatorRoleId, sourceMemberId);
        // 检查是否无其他角色
        companyRoleService.updateByMemberIsNoRole(Lists.newArrayList(sourceMemberId), Lists.newArrayListWithCapacity(0), database);

        SysRoleMember roleMember = new SysRoleMember();
        roleMember.setRoleId(creatorRoleId);
        roleMember.setMemberId(targetMemberId);
        companyRoleDao.addCompanyRolemember(roleMember, database);
    }

    @Override
    public Integer updateAssignAdmin(String database, Integer companyId, Integer sourceMemberId, Integer targetMemberId) {
        List<SysRoleMemberDTO> roleMemberDTOS = companyRoleDao.queryRoleMemberByMemberId(database, sourceMemberId);

        Optional<SysRoleMemberDTO> existOptional = roleMemberDTOS.stream()
                .filter(e -> CompanyRoleEnum.hasCreatorOrAdmin(e.getRoleCode()))
                .findFirst();

        if (!existOptional.isPresent()) {
            throw new BizException("只有公司创建者或管理员才能执行此操作");
        }

        SysRole adminRole = Optional.ofNullable(companyRoleDao.queryRoleByRolecd(CompanyRoleEnum.COMPANY_ADMIN.getRole(), database))
                .orElseThrow(() -> new BizException("没有管理员角色，不能进行操作"));
        final Integer adminRoleId = adminRole.getIdKey();

        Integer countAdmin = companyRoleDao.countCustomRole(database, adminRoleId);
        if (countAdmin > 1) {
            throw new BizException("已有多名管理员，不能转移管理员，请先移除其他管理员");
        }

        Boolean hasAdmin = companyRoleDao.hasCustomRoleByMemberId(database, adminRoleId, sourceMemberId);
        if (!hasAdmin && countAdmin > 0) {
            throw new BizException("只有管理员才能转移管理员");
        }

        companyRoleDao.deleteCustomRoleByMemberId(database, adminRoleId, sourceMemberId);
        // 检查是否无其他角色
        companyRoleService.updateByMemberIsNoRole(Lists.newArrayList(sourceMemberId), Lists.newArrayListWithCapacity(0), database);

        companyMemberDao.updateMemberAdminStatus(database, null, "0");
        companyMemberDao.updateMemberAdminStatus(database, targetMemberId, "1");

        SysRoleMember roleMember = new SysRoleMember();
        roleMember.setRoleId(adminRoleId);
        roleMember.setMemberId(targetMemberId);
        companyRoleDao.addCompanyRolemember(roleMember, database);

        // 同步平台管理员记录
        SysMemberCompanyTransferAdmin transferAdmin = new SysMemberCompanyTransferAdmin();
        transferAdmin.setCompanyId(companyId);
        transferAdmin.setSourceMemberId(sourceMemberId);
        transferAdmin.setTargetMemberId(targetMemberId);
        //ResponseUtils.convertResponse(memberCompanyRequest.transferAdmin(transferAdmin));

        return adminRoleId;
    }

    @Override
    public void deleteCompanyCreator(String database, Integer sourceMemberId, List<Integer> memberIds) {
        memberIds.remove(sourceMemberId);
        if (Collections3.isEmpty(memberIds)) {
            throw new BizException("不能只移除自己");
        }

        SysRole creatorRole = Optional.ofNullable(companyRoleDao.queryRoleByRolecd(CompanyRoleEnum.COMPANY_CREATOR.getRole(), database))
                .orElseThrow(() -> new BizException("没有创建者角色，不能进行操作"));
        final Integer creatorRoleId = creatorRole.getIdKey();
        Boolean hasCreator = companyRoleDao.hasCustomRoleByMemberId(database, creatorRoleId, sourceMemberId);
        if (!hasCreator) {
            throw new BizException("只有创建者才能执行此操作");
        }

        for (Integer memberId : memberIds) {
            companyRoleDao.deleteCustomRoleByMemberId(database, creatorRoleId, memberId);
        }
    }

    @Override
    public void deleteCompanyAdmin(String database, Integer companyId, Integer sourceMemberId, List<Integer> memberIds) {
        memberIds.remove(sourceMemberId);
        if (Collections3.isEmpty(memberIds)) {
            throw new BizException("不能只移除自己");
        }

        SysRole adminRole = Optional.ofNullable(companyRoleDao.queryRoleByRolecd(CompanyRoleEnum.COMPANY_ADMIN.getRole(), database))
                .orElseThrow(() -> new BizException("没有管理员角色，不能进行操作"));
        final Integer adminRoleId = adminRole.getIdKey();
        Boolean hasAdmin = companyRoleDao.hasCustomRoleByMemberId(database, adminRoleId, sourceMemberId);
        if (!hasAdmin) {
            throw new BizException("只有管理员才能执行此操作");
        }

        for (Integer memberId : memberIds) {
            companyRoleDao.deleteCustomRoleByMemberId(database, adminRoleId, memberId);
        }
        companyRoleService.updateByMemberIsNoRole(memberIds, new ArrayList<>(0), database);

        SysMemberCompanyRemoveAdmin removeAdmin = new SysMemberCompanyRemoveAdmin();
        removeAdmin.setCompanyId(companyId);
        removeAdmin.setMemberIds(memberIds);
        //Boolean result = ResponseUtils.convertResponse(this.memberCompanyRequest.removeAdmin(removeAdmin));
//        if (!result) {
//            throw new BizException("移除管理员出错");
//        }
    }

    @Override
    public SysMemberDTO getCompanyCreator(String database, Integer companyId) {
        SysCorporation companyDTO = this.sysCorporationDao.queryCorporationById(companyId); //ResponseUtils.convertResponse(this.companyRequest.get(companyId));
        if (companyDTO == null || !MathUtils.valid(companyDTO.getMemberId())) {
            return null;
        }
        return companyMemberDao.getCompanyMember(database, companyDTO.getMemberId());
    }

    @Override
    public Boolean existMobile(String database, String mobile) {
        return companyMemberDao.existMobile(database, mobile);
    }

    @Override
    public void saveAdminMember(SysMember memberInput) {
        final String database = memberInput.getDatasource();
        memberInput.setIsAdmin("1");
        SysMember platMember = this.platMemberDao.queryPlatSysMemberbyTel(memberInput.getMemberMobile());
        Integer memberId;
        if (platMember == null) {
            memberId = platMemberDao.addSysMember(memberInput);
        } else {
            memberId = platMember.getMemberId();
        }
        memberInput.setMemberId(memberId);

        SysMemberCompany platMemberCompany = MemberUtils.createBySysMember(memberInput, memberInput.getUnitId(), memberId);
        this.memberCompanyService.addSysMemberCompany(platMemberCompany);

        MemberUtils.setLeadGroup(empGroupDao, memberInput.getIsLead(), memberId, database);

        SysRole adminRole = Optional.ofNullable(companyRoleDao.queryRoleByRolecd(CompanyRoleEnum.COMPANY_ADMIN.getRole(), database))
                .orElseThrow(() -> new BizException("没有管理员角色，不能进行操作"));
        final Integer adminRoleId = adminRole.getIdKey();
        SysRoleMember roleMember = new SysRoleMember();
        roleMember.setRoleId(adminRoleId);
        roleMember.setMemberId(memberId);
        companyRoleDao.addCompanyRolemember(roleMember, database);
    }

    /**
     * 获取对应角色标记会员列表
     *
     * @param database
     * @param roleCode
     * @return
     */
    @Override
    public List<SysMember> queryMenByroleCd(String database, String roleCode) {
        return companyMemberDao.queryMenByroleCd(database, roleCode);
    }

    /**
     * 标记会员IDS获取列表
     *
     * @param database
     * @param memberIds
     * @return
     */
    @Override
    public List<SysMember> queryCompanyMemberByIds(String database, String memberIds) {
        return companyMemberDao.queryCompanyMemberByIds(database, memberIds);
    }

}
