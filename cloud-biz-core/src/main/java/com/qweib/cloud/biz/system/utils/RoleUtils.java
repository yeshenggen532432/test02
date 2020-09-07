package com.qweib.cloud.biz.system.utils;

import com.qweib.cloud.biz.common.CompanyRoleEnum;
import com.qweib.cloud.biz.system.service.plat.SysCompanyRoleService;
import com.qweib.cloud.core.domain.SysRole;
import com.qweib.cloud.utils.Collections3;

import java.util.List;
import java.util.Optional;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2019/4/13 - 15:09
 */
public class RoleUtils {

    /**
     * 检查是否公司创建者
     *
     * @param roleIds            当前员工角色 id 列表
     * @param companyRoleService
     * @param database
     * @return
     */
    public static boolean hasCompanyCreator(List<Integer> roleIds, SysCompanyRoleService companyRoleService, String database) {
        return hasCompanyCustomRole(roleIds, CompanyRoleEnum.COMPANY_CREATOR.getRole(), companyRoleService, database);
    }

    /**
     * 检查是否公司管理员
     *
     * @param roleIds            当前员工角色 id 列表
     * @param companyRoleService
     * @param database
     * @return
     */
    public static boolean hasCompanyAdmin(List<Integer> roleIds, SysCompanyRoleService companyRoleService, String database) {
        return hasCompanyCustomRole(roleIds, CompanyRoleEnum.COMPANY_ADMIN.getRole(), companyRoleService, database);
    }

    public static boolean hasCompanyRoles(List<Integer> roleIds, CompanyRoleEnum[] roleCodes, SysCompanyRoleService companyRoleService, String database) {
        for (CompanyRoleEnum roleCode : roleCodes) {
            boolean result = hasCompanyCustomRole(roleIds, roleCode.getRole(), companyRoleService, database);
            if (result) {
                return true;
            }
        }

        return false;
    }

    /**
     * 检查是否包含指定角色
     *
     * @param roleIds            当前员工角色 id 列表
     * @param customRoleCode     指定角色 code
     * @param companyRoleService
     * @param database
     * @return
     */
    public static boolean hasCompanyCustomRole(List<Integer> roleIds, String customRoleCode, SysCompanyRoleService companyRoleService, String database) {
        if (Collections3.isEmpty(roleIds)) {
            return false;
        }
        Optional<SysRole> creatorRoleOptional = Optional.ofNullable(companyRoleService.queryRoleByRolecd(customRoleCode, database));
        if (!creatorRoleOptional.isPresent()) {
            return false;
        }

        Integer creatorRoleId = creatorRoleOptional.get().getIdKey();

        if (roleIds.contains(creatorRoleId)) {
            return true;
        } else {
            return false;
        }
    }
}
