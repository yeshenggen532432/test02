package com.qweib.cloud.biz.common;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonValue;
import com.google.gson.annotations.SerializedName;
import com.qweib.commons.Collections3;
import com.qweib.commons.StringUtils;

import java.util.EnumSet;
import java.util.List;
import java.util.Objects;
import java.util.Optional;

/**
 * Description: 公司角色类型
 *
 * @author zeng.gui
 * Created on 2019/4/12 - 16:17
 */
public enum CompanyRoleEnum {

    @SerializedName("company_creator")
    COMPANY_CREATOR("company_creator", "1", "公司创建者"),
    @SerializedName("company_admin")
    COMPANY_ADMIN("company_admin", "2", "公司管理员"),
    @SerializedName("depart_manager")
    DEPART_MANAGER("depart_manager", "3", "部门主管"),
    @SerializedName("business_people")
    BUSINESS_PEOPLE("business_people", "4", "业务人员"),
    @SerializedName("executive_office")
    EXECUTIVE_OFFICE("executive_office", "5", "行政办公"),
    @SerializedName("ptyg")
    GENERAL_STAFF("ptyg", "6", "普通员工"),
    @SerializedName("gscjz")
    OLD_CREATOR("gscjz", "3", "旧的公司创建者"),
    @SerializedName("gsgly")
    OLD_ADMIN("gsgly", "3", "旧的公司管理员"),
    @SerializedName("bmgly")
    OLD_DEPART_MANAGER("bmgly", "3", "旧的部门管理员"),
    @SerializedName("ptcy")
    NORMAL_PERSON("ptcy", "6", "旧的普通员工"),
    @SerializedName("pick_shop_manager")
    PICK_SHOP_MANAGER("pick_shop_manager", "16", "自提店长"),
    @SerializedName("star_shop_manager")
    STAR_SHOP_MANAGER("star_shop_manager", "15", "星链店长");

    private final String role;
    private final String memberRole;
    private final String message;

    CompanyRoleEnum(String role, String memberRole, String message) {
        this.role = role;
        this.memberRole = memberRole;
        this.message = message;
    }

    /**
     * 是否自提店长
     * @param role
     * @return
     */
    public static boolean hasPick(String role) {
        return roleEqual(role, CompanyRoleEnum.PICK_SHOP_MANAGER);
    }

    /**
     * 是否星链店长
     * @param role
     * @return
     */
    public static boolean hasStar(String role) {
        return roleEqual(role, CompanyRoleEnum.STAR_SHOP_MANAGER);
    }

    @JsonValue
    public String getRole() {
        return role;
    }

    public String getMemberRole() {
        return memberRole;
    }

    public String getMessage() {
        return message;
    }

    @JsonCreator
    public static CompanyRoleEnum getByRole(String role) {
        if (StringUtils.isBlank(role)) {
            return null;
        }

        return EnumSet.allOf(CompanyRoleEnum.class)
                .stream()
                .filter(e -> e.getRole().equals(role))
                .findFirst()
                .orElseThrow(() -> new IllegalArgumentException("Unknown role:" + role));
    }

    public static CompanyRoleEnum getByMemberRole(String memberRole) {
        if (StringUtils.isBlank(memberRole)) {
            return null;
        }

        Optional<CompanyRoleEnum> optional = EnumSet.allOf(CompanyRoleEnum.class)
                .stream()
                .filter(e -> e.getMemberRole().equals(memberRole))
                .findFirst();

        if (optional.isPresent()) {
            return optional.get();
        } else {
            return null;
        }
    }

    public static boolean hasCreatorOrAdmin(String role) {
        return hasCreator(role) || hasAdmin(role);
    }

    /**
     * 是否公司创建者
     *
     * @param role
     * @return
     */
    public static boolean hasCreator(String role) {
        return roleEqual(role, CompanyRoleEnum.COMPANY_CREATOR);
    }

    /**
     * 是否包含公司创建者
     *
     * @param roles
     * @return
     */
    public static boolean containsCreator(List<String> roles) {
        if (Collections3.isEmpty(roles)) {
            return false;
        }

        for (String role : roles) {
            if (hasCreator(role)) {
                return true;
            }
        }

        return false;
    }

    /**
     * 是否公司管理员
     *
     * @param role
     * @return
     */
    public static boolean hasAdmin(String role) {
        return roleEqual(role, CompanyRoleEnum.COMPANY_ADMIN);
    }

    /**
     * 是否包含管理员角色
     *
     * @param roles
     * @return
     */
    public static boolean containsAdmin(List<String> roles) {
        if (Collections3.isEmpty(roles)) {
            return false;
        }

        for (String role : roles) {
            if (hasAdmin(role)) {
                return true;
            }
        }

        return false;
    }

    /**
     * 比较两个角色是否相等
     *
     * @param role
     * @param equalRole
     * @return
     */
    public static boolean roleEqual(String role, CompanyRoleEnum equalRole) {
        try {
            Optional<CompanyRoleEnum> optional = Optional.ofNullable(getByRole(role));

            return optional.isPresent() ? Objects.equals(optional.get(), equalRole) : false;
        } catch (Exception e) {
            return false;
        }
    }
}
