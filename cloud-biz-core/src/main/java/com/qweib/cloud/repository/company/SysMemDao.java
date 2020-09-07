package com.qweib.cloud.repository.company;


import com.google.common.collect.Lists;
import com.qweib.cloud.biz.customer.duplicate.DuplicateInvoker;
import com.qweib.cloud.biz.customer.duplicate.dto.CustomerDTO;
import com.qweib.cloud.biz.customer.duplicate.dto.CustomerTypeEnum;
import com.qweib.cloud.biz.customer.duplicate.dto.ResultDTO;
import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.SysMemDTO;
import com.qweib.cloud.core.domain.SysMember;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.memberEvent.MemberPublisher;
import com.qweib.cloud.service.member.domain.member.SysMemberDTO;
import com.qweib.cloud.utils.Collections3;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import com.qweib.commons.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BatchPreparedStatementSetter;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


@Repository
public class SysMemDao {
    @Resource(name = "daoTemplate")
    private JdbcDaoTemplate daoTemplate;
    @Autowired
    private DuplicateInvoker duplicateInvoker;
    @Autowired
    private MemberPublisher memberPublisher;

    /**
     * @param Id
     * @return
     * @创建：作者:llp 创建时间：2015-1-29
     * 查询用户信息
     */
    public SysMember queryMemById(Integer Id, String datasource) {
        StringBuffer sql = new StringBuffer("select * from " + datasource + ".sys_mem where member_id=").append(Id);
        try {
            return daoTemplate.queryForObj(sql.toString(), SysMember.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @param wallId
     * @return
     * @说明： 根据照片墙ID查询用户--只需要手机号码--
     * @创建者： 作者：YJP 创建时间:2014-5-15
     */
    public SysMember findMemberByPhotoWall(Integer wallId, String datasource) {
        StringBuffer sql = new StringBuffer("select member_mobile,member_id from " + datasource + ".sys_mem where member_id = (select member_id from " + datasource + ".bsc_photo_wall where wall_id = ?)");
        try {
            return this.daoTemplate.queryForObj(sql.toString(), SysMember.class, wallId);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @param memberId 成员ID
     * @param mobile   手机号码
     * @return sysmember
     * @说明：根据条件查看用户
     * @创建者： 作者：YJP 创建时间：2014-4-20
     * @修改历史： [序号](yjp 2014 - 4 - 28) 之前为单个查询变成多条件查询,增加 memberId
     */
    @SuppressWarnings("unchecked")
    public SysMember queryDailyMember(Class cls, Integer memberId, String mobile, String datasource) {
        StringBuffer sql = new StringBuffer("select s.* from " + datasource + ".sys_mem s where 1=1");
        if (memberId != null) {
            sql.append(" and s.member_id = ").append(memberId);
        }
        if (mobile != null) {
            sql.append(" and s.member_mobile = ").append(mobile);
        }
        sql.append("  and member_use='1'");
        try {
            return daoTemplate.queryForObj(sql.toString(), cls);
        } catch (Exception ex) {
            throw new DaoException(ex);
        }
    }

    /**
     * 分页查询
     */
    public Page queryForPage(SysMember mem, int page, int limit, String database) {
        try {
            StringBuffer sql = new StringBuffer();
            sql.append(" select member_id,member_nm,member_head from " + database + ".sys_mem where 1=1");
            return daoTemplate.queryForPageByMySql(sql.toString(), page, limit, SysMember.class);
        } catch (Exception ex) {
            throw new DaoException(ex);
        }
    }

    /**
     * 通过pid查找会员信息
     */
    public SysMember queryMemByPid(Integer pid, String datasource) {
        StringBuffer sql = new StringBuffer("select * from " + datasource + ".sys_mem where pid=").append(pid);
        try {
            return daoTemplate.queryForObj(sql.toString(), SysMember.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 修改会员
     */
    public int updateMember(SysMember sysmem, String database) {
        try {
            ResultDTO resultDTO = this.duplicateInvoker.invoke(database, new CustomerDTO(sysmem.getMemberId(), CustomerTypeEnum.SysMem, sysmem.getMemberNm()));
            if (resultDTO.isFound()) {
                sysmem.setMemberNm(resultDTO.getSuggestName());
            }
            Map<String, Object> whereParam = new HashMap<String, Object>();
            whereParam.put("member_id", sysmem.getMemberId());
            return this.daoTemplate.updateByObject("" + database + ".sys_mem", sysmem, whereParam, "member_id");
        } catch (Exception ex) {
            throw new DaoException(ex);
        }
    }

    /**
     * 获取会员信息(List)
     */
    public List<SysMemDTO> querycMems(String database) {
        String sql = "select member_id,member_mobile,member_nm,member_head from " + database + ".sys_mem";
        try {
            return this.daoTemplate.queryForLists(sql, SysMemDTO.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }

    }

    /**
     * 根据公司角色查询所有成员
     *
     * @param companyroleId
     * @param datasource
     * @return
     */
    public List<SysMemDTO> queryCompanyRoleMem(Integer companyroleId,
                                               String datasource) {
        StringBuffer sql = new StringBuffer("");
        sql.append("SELECT m.member_id,m.member_mobile FROM " + datasource + ".sys_mem m," + datasource + ".sys_role_member rm ");
        sql.append(" WHERE m.member_id=rm.member_id AND rm.role_id=? ");
        try {
            return this.daoTemplate.queryForLists(sql.toString(), SysMemDTO.class, companyroleId);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 根据公司角色s查询所有成员
     *
     * @param roleCodes
     * @param datasource
     * @return
     */
    public List<SysMemDTO> queryCompanyMemByRoleCodes(List<String> roleCodes,
                                                      String datasource) {
        StringBuilder sql = new StringBuilder(64);
        sql.append("SELECT DISTINCT m.member_id,m.member_mobile,m.member_nm FROM ").append(datasource).append(".sys_mem m")
                .append(" LEFT JOIN ").append(datasource).append(".sys_role_member rm ON rm.member_id = m.member_id")
                .append(" LEFT JOIN ").append(datasource).append(".sys_role r ON r.id_key = rm.role_id");
        sql.append(" WHERE r.role_cd in (");
        sql.append(StringUtils.repeat("?", ",", roleCodes.size())).append(")");
        try {
            return this.daoTemplate.queryForLists(sql.toString(), SysMemDTO.class, roleCodes.toArray(new Object[roleCodes.size()]));
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 删除
     */
    public int[] deletemember(final Integer[] ids, String database, Integer companyId) {
        try {
            StringBuffer ss = new StringBuffer();
            for (Integer id : ids) {
                if (id == null) continue;
                if (ss.length() > 0) ss.append(",");
                ss.append(id);
            }
            //离职通知商城会员改为普通会员
            String sql1 = "select member_mobile from " + database + ".sys_mem where member_id in(" + ss + ")";
            List<SysMember> list = daoTemplate.queryForLists(sql1, SysMember.class);
            list.forEach(item -> {
                item.setMemberUse("3");
                memberPublisher.staffUpdate(item, database, companyId.toString());
            });

            String sql = "update " + database + ".sys_mem set member_use=3 where member_id=?";
            BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter() {
                @Override
                public int getBatchSize() {
                    return ids.length;
                }

                @Override
                public void setValues(PreparedStatement pre, int num)
                        throws SQLException {
                    pre.setInt(1, ids[num]);
                }
            };
            return this.daoTemplate.batchUpdate(sql, setter);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }



 /*   public int[] updateMemberIsDel(final Integer[] ids, String database) {
        try {
            String sql = "update " + database + ".sys_mem set is_del=1  where member_id=?";
            BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter() {
                @Override
                public int getBatchSize() {
                    return ids.length;
                }

                @Override
                public void setValues(PreparedStatement pre, int num)
                        throws SQLException {
                    pre.setInt(1, ids[num]);
                }
            };
            return this.daoTemplate.batchUpdate(sql, setter);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }*/

    /**
     * 删除
     */
    public int[] deletememberGj(final Integer[] ids, String database) {
        try {
            String sql = "delete from " + database + ".sys_zcusr where cusr_id=? or zusr_id=?";
            BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter() {
                @Override
                public int getBatchSize() {
                    return ids.length;
                }

                @Override
                public void setValues(PreparedStatement pre, int num)
                        throws SQLException {
                    pre.setInt(1, ids[num]);
                    pre.setInt(2, ids[num]);
                }
            };
            return this.daoTemplate.batchUpdate(sql, setter);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 更新会员超级管理员状态
     *
     * @param database
     * @param memberId
     * @param status
     * @return
     */
    public int updateMemberAdminStatus(String database, Integer memberId, String status) {
        StringBuilder sql = new StringBuilder(64);
        sql.append("UPDATE ").append(database).append(".sys_mem SET is_admin=?");

        List<Object> values = Lists.newArrayList();
        values.add(status);

        if (memberId != null) {
            sql.append(" WHERE member_id=?");
            values.add(memberId);
        }

        return this.daoTemplate.update(sql.toString(), values.toArray(new Object[values.size()]));
    }

    public Boolean existMobile(String database, String mobile) {
        StringBuilder sql = new StringBuilder(64);
        sql.append("SELECT COUNT(1) FROM ").append(database).append(".sys_mem")
                .append(" WHERE member_mobile = ?");

        Integer count = this.daoTemplate.queryForInt(sql.toString(), new Object[]{database});
        return count > 0;
    }

    public SysMemberDTO getCompanyMember(String database, Integer memberId) {
        StringBuilder sql = new StringBuilder(64);
        sql.append("SELECT a.* FROM ").append(database).append(".sys_mem a")
                .append(" WHERE a.member_id = ?");

        List<SysMemberDTO> list = this.daoTemplate.query(sql.toString(), new Object[]{memberId}, new RowMapper<SysMemberDTO>() {
            @Override
            public SysMemberDTO mapRow(ResultSet rs, int rowNum) throws SQLException {
                SysMemberDTO memberDTO = new SysMemberDTO();
                memberDTO.setId(rs.getInt("member_id"));
                memberDTO.setName(rs.getString("member_nm"));
                memberDTO.setMobile(rs.getString("member_mobile"));

                return memberDTO;
            }
        });

        return Collections3.isNotEmpty(list) ? list.get(0) : null;
    }


    /**
     * 获取对应角色标记会员列表
     *
     * @param database
     * @param roleCode
     * @return
     */
    public List<SysMember> queryMenByroleCd(String database, String roleCode) {
        final StringBuilder sql = new StringBuilder();
        sql.append("SELECT sm.* FROM ").append(database).append(".sys_role_member m")
                .append(" LEFT JOIN ").append(database).append(".sys_role r ON m.role_id=r.id_key")
                .append(" LEFT JOIN ").append(database).append(".sys_mem sm ON sm.member_id=m.member_id")
                .append(" WHERE r.role_cd = ?");
        return this.daoTemplate.queryForLists(sql.toString(), SysMember.class, roleCode);
    }

    /**
     * 标记会员IDS获取列表
     *
     * @param database
     * @param memberIds
     * @return
     */
    public List<SysMember> queryCompanyMemberByIds(String database, String memberIds) {
        if (StrUtil.isNull(memberIds)) {
            return new ArrayList<>();
        }
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT a.* FROM ").append(database).append(".sys_mem a WHERE a.member_id in(" + memberIds + ")");
        return this.daoTemplate.queryForLists(sql.toString(), SysMember.class);
    }
}
