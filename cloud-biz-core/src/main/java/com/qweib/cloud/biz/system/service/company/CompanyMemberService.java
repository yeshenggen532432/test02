package com.qweib.cloud.biz.system.service.company;

import com.qweib.cloud.core.domain.SysMember;
import com.qweib.cloud.service.member.domain.member.SysMemberDTO;

import java.util.List;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2019/4/15 - 9:29
 */
public interface CompanyMemberService {

    /**
     * 转换创建者角色
     *
     * @param database      数据库
     * @param creatorRoleId 角色 id
     * @return
     */
    void updateMemberCreator(String database, Integer creatorRoleId, Integer sourceMemberId, Integer targetMemberId);

    Integer updateAssignAdmin(String database, Integer companyId, Integer sourceMemberId, Integer targetMemberId);

    /**
     * 移除创建者角色会员
     *
     * @param database
     * @param sourceMemberId
     * @param memberIds      要移除的会员 id 列表
     */
    void deleteCompanyCreator(String database, Integer sourceMemberId, List<Integer> memberIds);

    /**
     * 移除管理员角色会员
     *
     * @param database
     * @param sourceMemberId
     * @param memberIds
     */
    void deleteCompanyAdmin(String database, Integer companyId, Integer sourceMemberId, List<Integer> memberIds);

    SysMemberDTO getCompanyCreator(String database, Integer companyId);

    Boolean existMobile(String database, String mobile);

    void saveAdminMember(SysMember memberInput);
    /**
     * 获取对应角色标记会员列表
     *
     * @param database
     * @param roleCode
     * @return
     */
    List<SysMember> queryMenByroleCd(String database, String roleCode);

    /**
     * 标记会员IDS获取列表
     *
     * @param database
     * @param memberIds
     * @return
     */
    List<SysMember> queryCompanyMemberByIds(String database, String memberIds);
}
