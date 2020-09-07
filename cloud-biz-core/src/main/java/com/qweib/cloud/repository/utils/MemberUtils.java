package com.qweib.cloud.repository.utils;

import com.qweib.cloud.biz.common.CompanyRoleEnum;
import com.qweib.cloud.core.domain.SysMemDTO;
import com.qweib.cloud.core.domain.SysMember;
import com.qweib.cloud.core.domain.vo.SysMemberTypeEnum;
import com.qweib.cloud.service.member.common.MemberUnitmngEnum;
import com.qweib.cloud.service.member.common.MemberUpdatePropertyEnum;
import com.qweib.cloud.service.member.common.RoleValueEnum;
import com.qweib.cloud.service.member.domain.corporation.SysCorporationDTO;
import com.qweib.cloud.service.member.domain.member.SysMemberDTO;
import com.qweib.cloud.service.member.domain.member.SysMemberUpdateProperties;
import com.qweib.cloud.service.member.retrofit.SysCorporationRequest;
import com.qweib.cloud.service.member.retrofit.SysMemberRequest;
import com.qweib.commons.MathUtils;
import com.qweib.commons.StringUtils;
import org.dozer.Mapper;
import reactor.core.publisher.Mono;

import java.util.Objects;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2019/3/2 - 11:13
 */
public class MemberUtils {

    public static SysMemberDTO getMemberData(SysMemberRequest memberRequest, SysCorporationRequest corporationRequest, Mapper mapper, Integer memberId) {
        SysMemberDTO memberDTO = new SysMemberDTO();
        Mono.just(memberId)
                .map(id -> HttpResponseUtils.convertResponse(memberRequest.get(id)))
                .map(sysMemberDTO -> {
                    if (sysMemberDTO != null && sysMemberDTO.getCompanyId() != null && sysMemberDTO.getCompanyId() > 0) {
                        SysCorporationDTO corporationDTO = HttpResponseUtils.convertResponse(corporationRequest.get(sysMemberDTO.getCompanyId()));
                        if (corporationDTO != null) {
                            sysMemberDTO.setDatabase(corporationDTO.getDatabase());
                        }
                    }

                    return sysMemberDTO;
                }).subscribe(sysMemberDTO -> mapper.map(sysMemberDTO, memberDTO));

        return memberDTO;
    }

    public static SysMemDTO getSysMemDTO(SysMemberRequest memberRequest, SysCorporationRequest corporationRequest, Mapper mapper, Integer memberId) {
        SysMemberDTO memberData = getMemberData(memberRequest, corporationRequest, mapper, memberId);
        if (Objects.nonNull(memberData)) {
            return mapper.map(memberData, SysMemDTO.class);
        } else {
            return null;
        }
    }

    public static SysMember getSysMemberJoinCompany(SysMemberRequest memberRequest, SysCorporationRequest corporationRequest, Mapper mapper, Integer memberId) {
        SysMember sysMember = HttpResponseUtils.convertToEntity(memberRequest.get(memberId), SysMember.class, mapper);
        if (sysMember != null) {
            if (sysMember.getUnitId() != null && sysMember.getUnitId() > 0) {
                SysCorporationDTO corporationDTO = HttpResponseUtils.convertResponse(corporationRequest.get(sysMember.getUnitId()));
                if (corporationDTO != null) {
                    sysMember.setBranchName(corporationDTO.getName());
                }
            }
            return sysMember;
        } else {
            return null;
        }
    }

    /**
     * 更新公司信息
     *
     * @param memberRequest
     * @param companyName
     * @param companyId
     * @param branchId
     * @param memberId
     * @param isUnitmng
     */
    public static void updateMemberCompany(SysMemberRequest memberRequest, String companyName, Integer companyId, Integer branchId, Integer memberId, String isUnitmng) {
        SysMemberUpdateProperties properties = new SysMemberUpdateProperties();
        properties.setPropertyType(MemberUpdatePropertyEnum.COMPANY);
        properties.setCompanyName(companyName);
        properties.setCompanyId(companyId);
        properties.setBranchId(branchId);
        properties.setId(memberId);
        properties.setIsUnitmng(MemberUnitmngEnum.getByType(isUnitmng));

        HttpResponseUtils.convertResponse(memberRequest.updateProperties(properties));
    }

    /**
     * 清空公司信息
     *
     * @param memberRequest
     */
    public static void clearMemberCompany(SysMemberRequest memberRequest, Integer memberId, Integer companyId) {
        SysMemberUpdateProperties properties = new SysMemberUpdateProperties();
        properties.setPropertyType(MemberUpdatePropertyEnum.CLEAR_COMPANY);
        properties.setId(memberId);
        properties.setCompanyId(companyId);

        HttpResponseUtils.convertResponse(memberRequest.updateProperties(properties));
    }

    public static SysMemberDTO getByMobile(SysMemberRequest memberRequest, SysCorporationRequest corporationRequest, String mobile) {
        SysMemberDTO memberDTO = HttpResponseUtils.convertResponseNull(memberRequest.getByMobile(mobile));
        if (memberDTO == null) {
            return null;
        }

        if (MathUtils.valid(memberDTO.getCompanyId())) {
            SysCorporationDTO corporationDTO = HttpResponseUtils.convertResponseNull(corporationRequest.get(memberDTO.getCompanyId()));
            memberDTO.setCompany(corporationDTO.getName());
            memberDTO.setDatabase(corporationDTO.getDatabase());
        }

        return memberDTO;
    }

    /**
     * 是否需要检测端口限制
     *
     * @param roleCode
     * @return
     */
    public static boolean needPortLimit(String roleCode) {
        if (StringUtils.isBlank(roleCode)) {
            return true;
        }

        boolean isSystemRole = RoleValueEnum.isAdmin(roleCode)
                || RoleValueEnum.isCreator(roleCode)
                || RoleValueEnum.isSalesman(roleCode)
                || RoleValueEnum.isGeneralStaff(roleCode)
                || RoleValueEnum.isExecutiveStaff(roleCode)
                || CompanyRoleEnum.hasPick(roleCode)
                || CompanyRoleEnum.hasStar(roleCode);

        return !isSystemRole;
    }

    /**
     * 默认的会员类型
     *
     * @param pix
     * @return
     */
    public static String defMemberType(String pix) {
        return " and (" + pix + ".member_type & " + SysMemberTypeEnum.general.getType() + "=" + SysMemberTypeEnum.general.getType() + " or " + pix + ".member_type is null) ";
    }
}
