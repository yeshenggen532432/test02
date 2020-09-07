package com.qweib.cloud.core.domain.dto;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2019/4/15 - 16:07
 */
public class SysRoleMemberDTO {

    private Integer roleId;
    private String roleName;
    /**
     * 角色 code
     */
    private String roleCode;
    private Integer memberId;

    public Integer getRoleId() {
        return roleId;
    }

    public void setRoleId(Integer roleId) {
        this.roleId = roleId;
    }

    public String getRoleName() {
        return roleName;
    }

    public void setRoleName(String roleName) {
        this.roleName = roleName;
    }

    public String getRoleCode() {
        return roleCode;
    }

    public void setRoleCode(String roleCode) {
        this.roleCode = roleCode;
    }

    public Integer getMemberId() {
        return memberId;
    }

    public void setMemberId(Integer memberId) {
        this.memberId = memberId;
    }
}
