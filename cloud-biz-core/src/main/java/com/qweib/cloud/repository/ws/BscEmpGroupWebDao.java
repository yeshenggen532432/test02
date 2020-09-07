package com.qweib.cloud.repository.ws;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.*;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.jdbc.core.BatchPreparedStatementSetter;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

@Repository
public class BscEmpGroupWebDao {
    @Resource(name = "daoTemplate")
    private JdbcDaoTemplate daoTemplate;

    /**
     * @param empGroup
     * @创建：作者:YYP 创建时间：2015-1-29
     * @see 创建员工圈
     */
    public Integer addGroup(BscEmpgroup empGroup, String database) {
        try {
            /*****用于更改id生成方式 by guojr******/
            return daoTemplate.addByObject(database + ".bsc_empgroup", empGroup);
            //return daoTemplate.getAutoIdForIntByMySql();
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @param database
     * @return
     * @创建：作者:YYP 创建时间：2015-1-29
     * @see 获取当前用户所在员工圈
     */
    public Page queryAllGroup(Integer memId, String database, Integer pageNo, Integer pageSize) {
        StringBuffer sql = new StringBuffer("select m.member_id,m.member_head,e.group_id,e.group_head,e.group_nm,e.group_desc,e.creatime,e.is_open,e.lead_shield,em.remind_flag,em.top_flag,em.role,");
        sql.append("(select count(*) from " + database + ".bsc_empgroup_member tt where tt.group_id=e.group_id and tt.role!=4)as groupNum from ");
        sql.append(database + ".bsc_empgroup e left join " + database + ".sys_mem m on m.member_id=e.member_id left join " + database + ".bsc_empgroup_member em on em.group_id=e.group_id where em.member_id=").append(memId);
        sql.append(" order by top_flag desc,top_time desc,creatime desc ");
        try {
            return daoTemplate.queryForPageByMySql(sql.toString(), pageNo, pageSize, BscEmpgroupDTO.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @param memId
     * @param database
     * @param pageNo
     * @param pageSize
     * @return
     * @创建：作者:YYP 创建时间：2015-5-21
     * @see 知识库员工圈列表
     */
    public Page queryGroupKnowledge(Integer memId, String database, String searchContent,
                                    Integer pageNo, Integer pageSize) {
        StringBuffer sql = new StringBuffer("select distinct e.group_id,e.group_nm,em.role ");
        sql.append(" from " + database + ".bsc_empgroup e left join " + database + ".bsc_empgroup_member em on e.group_id=em.group_id ");
        sql.append(" left join " + database + ".bsc_sort s on e.group_id=s.group_id ");
        sql.append(" where em.member_id=" + memId + " and sort_id is not null");
        if (null != searchContent) {
            sql.append(" and e.group_nm like '%").append(searchContent).append("%' ");
        }
        sql.append(" order by em.top_flag desc,em.top_time desc,e.creatime desc ");
        try {
            return daoTemplate.queryForPageByMySql(sql.toString(), pageNo, pageSize, BscEmpgroupDTO.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @param tpId
     * @param database
     * @return
     * @创建：作者:YYP 创建时间：2015-2-2
     * @see 查找员工圈所有成员id
     */
    public List<SysMemDTO> querymIds(Integer tpId, String database) {
        StringBuffer sql = new StringBuffer("select em.member_id,em.remind_flag,m.member_mobile from " + database + ".bsc_empgroup_member em ");
        sql.append(" left join " + database + ".sys_mem m on em.member_id=m.member_id left join " + database + ".bsc_empgroup e on em.group_id=e.group_id where em.group_id=").append(tpId);
        try {
            return daoTemplate.queryForLists(sql.toString(), SysMemDTO.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @param groupId
     * @param database
     * @return
     * @创建：作者:YYP 创建时间：2015-2-3
     * @see 查询圈信息
     */
    public BscEmpgroupDTO queryGroupDetail(Integer groupId, Integer memId, String database) {
        String inGroup = " (select count(1) from " + database + ".bsc_empgroup_member where group_id=" + groupId + " and member_id=" + memId + " ) ";
        StringBuffer sql = new StringBuffer("select em.group_id,em.group_head,em.group_nm,em.group_desc,em.creatime,m.member_id,m.member_nm,m.member_head,");
        sql.append(" em.lead_shield,").append(inGroup).append("as inGroup from ");
        sql.append(database + ".bsc_empgroup em left join " + database + ".sys_mem m on em.member_id=m.member_id where em.group_id=").append(groupId);
        try {
            return daoTemplate.queryForObj(sql.toString(), BscEmpgroupDTO.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @param groupId
     * @param database
     * @return
     * @创建：作者:YYP 创建时间：2015-2-3
     * @see 根据角色查询圈人员
     */
    public List<BscEmpGroupMember> queryGroupMems(Integer groupId, String role, String database) {
        StringBuffer sql = new StringBuffer("select m.member_id,m.member_head from " + database + ".bsc_empgroup_member em ");
        sql.append(" left join " + database + ".sys_mem m on em.member_id=m.member_id where em.group_id=").append(groupId);
        sql.append(" and em.role='").append(role).append("'");
        try {
            return daoTemplate.queryForLists(sql.toString(), BscEmpGroupMember.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    //删除圈成员
    public Integer deleteGroup(Integer groupId, Integer memId, String database) {
        try {
            StringBuffer sql = new StringBuffer("delete from " + database + ".bsc_empgroup_member where group_id = ? and member_id = ?");
            return daoTemplate.update(sql.toString(), groupId, memId);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @param memId
     * @param groupId
     * @param database
     * @return
     * @创建：作者:YYP 创建时间：2015-2-4
     * @see 根据id查找圈成员信息
     */
    public BscEmpGroupMember queryGroupMem(Integer memId, Integer groupId, String database) {
        StringBuffer sql = new StringBuffer("select group_id,member_id,role,remind_flag,top_flag from " + database + ".bsc_empgroup_member ");
        sql.append(" where member_id=").append(memId);
//		if(StrUtil.isNull(groupId)){
//			sql.append(" and group_id=(select e.group_id");
//			sql.append(" from "+database+".bsc_empgroup_member em,"+database+".bsc_empgroup e ");
//			sql.append(" where em.group_id=e.group_id and em.member_id="+memId);
//			sql.append(" order by e.creatime limit 1 )");
//		}else {
        sql.append(" and group_id=").append(groupId);
//		}
        try {
            return daoTemplate.queryForObj(sql.toString(), BscEmpGroupMember.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @param groupId
     * @param database
     * @return
     * @创建：作者:YYP 创建时间：2015-2-4
     * @see 查询不在圈内的企业成员（去除vip人员和自己）
     */
    public Page queryNotInMems(Integer groupId, Integer memId, Integer pageNo, Integer pageSize, String searchContent, String datasource, String ids) {
        StringBuffer sql = new StringBuffer("select m.member_id,member_head,member_nm,first_char from ");
        sql.append(datasource + ".sys_mem m where m.is_lead!=1 and m.member_use='1' ");
        if (null != groupId) {
            sql.append(" and (member_id not in (select member_id from " + datasource + ".bsc_empgroup_member where group_id=").append(groupId).append(")) ");
        }
        if (!StrUtil.isNull(searchContent)) {
            sql.append(" and (m.member_nm like '%").append(searchContent).append("%' or member_mobile like '%").append(searchContent).append("%') ");
        }
        sql.append(" and member_id!=" + memId);
        if (!StrUtil.isNull(ids)) {
            sql.append(" and member_id not in (" + ids + ") ");
        }
        sql.append(" order by first_char,member_nm asc ");
        try {
            return daoTemplate.queryForPageByMySql(sql.toString(), pageNo, pageSize, SysMemDTO.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    //公开圈的添加管理员列表
    public Page queryOpenNotInMems(Integer groupId, Integer pageNo,
                                   Integer pageSize, String datasource) {
        StringBuffer sql = new StringBuffer("select m.member_id,member_head,member_nm,first_char from ");
        sql.append(datasource + ".bsc_empgroup_member em left join " + datasource + ".sys_mem m on em.member_id=m.member_id ");
        sql.append(" where em.group_id=" + groupId + " and m.member_use='1' and em.role=3");
        try {
            return daoTemplate.queryForPageByMySql(sql.toString(), pageNo, pageSize, SysMemDTO.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @param groupMem
     * @param database
     * @return
     * @创建：作者:YYP 创建时间：2015-2-4
     * @see 添加圈成员
     */
    public Integer addGroupMem(BscEmpGroupMember groupMem, String database) {
        try {
            /*****用于更改id生成方式 by guojr******/
            return daoTemplate.addByObject(database + ".bsc_empgroup_member", groupMem);
            //return daoTemplate.getAutoIdForIntByMySql();
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @param groupId
     * @param isTop
     * @param database
     * @创建：作者:YYP 创建时间：2015-2-4
     * @see 员工圈置顶或取消置顶
     */
    public void updateGroupTop(Integer groupId, Integer memId, String isTop, String datasource) {
        StringBuffer sql = new StringBuffer(" update " + datasource + ".bsc_empgroup_member set top_flag=").append(isTop);
        if ("1".equals(isTop)) {//取消置顶
            sql.append(" ,top_time=NULL ");
        } else {
            sql.append(" ,top_time=(now()) ");
        }
        sql.append(" where group_id=").append(groupId).append(" and member_id=").append(memId);
        try {
            daoTemplate.update(sql.toString());
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @param groupId
     * @param database
     * @return
     * @创建：作者:YYP 创建时间：2015-2-6
     * @see 根据id查询员工圈
     */
    public BscEmpgroup queryGroupById(Integer groupId, String database) {
        StringBuffer sql = new StringBuffer("select group_id,group_nm,group_head,is_open from " + database + ".bsc_empgroup where group_id=").append(groupId);
        try {
            return daoTemplate.queryForObj(sql.toString(), BscEmpgroup.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @param groupId
     * @param database
     * @return
     * @创建：作者:YYP 创建时间：2015-2-6
     * @see 查找圈群主
     */
    public SysMemDTO queryAdmins(Integer groupId, String database) {
        StringBuffer sql = new StringBuffer("select m.member_id,m.member_mobile from " + database + ".bsc_empgroup em left join ");
        sql.append(database + ".sys_mem m on em.member_id=m.member_id where em.group_id=").append(groupId);
        try {
            return daoTemplate.queryForObj(sql.toString(), SysMemDTO.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @param groupId
     * @param remindFlag
     * @param database
     * @创建：作者:YYP 创建时间：2015-2-8
     * @see 免打扰设置
     */
    public void updateGroupRemind(Integer groupId, Integer memId, String remindFlag, String datasource) {
        StringBuffer sql = new StringBuffer(" update " + datasource + ".bsc_empgroup_member set remind_flag=").append(remindFlag);
        sql.append(" where group_id=").append(groupId).append(" and member_id=").append(memId);
        try {
            daoTemplate.update(sql.toString());
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }


    /**
     * @param groupId
     * @param groupNm
     * @param groupDesc
     * @param database
     * @创建：作者:YYP 创建时间：2015-2-10
     * @see 修改圈信息
     */
    public void updateGroup(Integer groupId, String groupNm,
                            String groupDesc, String groupHead, String datasource) {
        StringBuffer sql = new StringBuffer(" update " + datasource + ".bsc_empgroup ");
        if (!StrUtil.isNull(groupNm)) {//圈名称不为空
            sql.append(" set group_nm='").append(groupNm).append("'");
        }
        if (!StrUtil.isNull(groupDesc)) {//圈描述不为空
            sql.append(" set group_desc='").append(groupDesc).append("'");
        }
        if (!StrUtil.isNull(groupHead)) {
            sql.append(" set group_head='").append(groupHead).append("'");
        }
        sql.append(" where group_id=").append(groupId);
        try {
            daoTemplate.update(sql.toString());
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @param groupId
     * @param database
     * @return
     * @创建：作者:YYP 创建时间：2015-2-11
     * @see 查询圈成员(Vip不查)
     */
    public List<SysMemDTO> queryGroupAllMem(Integer groupId, String datasource) {
        StringBuffer sql = new StringBuffer("select m.member_id,m.member_head,m.member_nm,em.role from " + datasource + ".bsc_empgroup_member em left join ")
                .append(datasource + ".sys_mem m on em.member_id=m.member_id where em.role!=4 and em.group_id=").append(groupId);
        sql.append(" order by em.role asc ");
        try {
            return daoTemplate.queryForLists(sql.toString(), SysMemDTO.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    //公开圈查询圈成员
    public List<SysMemDTO> queryOpenGroupAllMem(Integer groupId,
                                                String datasource) {
        StringBuffer sql = new StringBuffer("select m.member_id,m.member_head,m.member_nm,em.role from " + datasource + ".bsc_empgroup_member em left join ")
                .append(datasource + ".sys_mem m on em.member_id=m.member_id where (em.role=1 or em.role=2) and em.group_id=").append(groupId);
        sql.append(" order by em.role asc ");
        try {
            return daoTemplate.queryForLists(sql.toString(), SysMemDTO.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @param memIds
     * @param memId
     * @param time
     * @param database
     * @创建：作者:YYP 创建时间：2015-3-3
     * @see 批量添加员工圈成员
     */
    public int[] addGroupMems(final String[] memIds, final Integer groupId, final String role,
                              final String time, String database) {
        String sql = "insert into " + database + ".bsc_empgroup_member(group_id,member_id,role,addtime) values (?,?,?,?)";
        try {
            BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter() {
                public void setValues(PreparedStatement pre, int num) throws SQLException {
                    pre.setInt(1, groupId);
                    pre.setInt(2, Integer.valueOf(memIds[num]));
                    pre.setString(3, role);
                    pre.setString(4, time);
                }

                public int getBatchSize() {
                    return memIds.length;
                }
            };
            return daoTemplate.batchUpdate(sql, setter);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    //添加公开圈的成员
    public int[] addOpenGroupMems(final String[] groupIds, final Integer memberId,
                                  final String role, final String dateTime, String database) {
        String sql = "insert into " + database + ".bsc_empgroup_member(group_id,member_id,role,addtime) values (?,?,?,?)";
        try {
            BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter() {
                public void setValues(PreparedStatement pre, int num) throws SQLException {
                    pre.setInt(1, Integer.valueOf(groupIds[num]));
                    pre.setInt(2, memberId);
                    pre.setString(3, role);
                    pre.setString(4, dateTime);
                }

                public int getBatchSize() {
                    return groupIds.length;
                }
            };
            return daoTemplate.batchUpdate(sql, setter);
        } catch (Exception e) {
            throw new DaoException(e);
        }

    }

    //公开圈更改角色
    public int[] updateMemRoleBatch(final String[] memIds, final Integer groupId,
                                    final String role, final String time, String datasource) {
        String sql = "update " + datasource + ".bsc_empgroup_member set role=" + role + ",addtime='" + time + "' where group_id=" + groupId + " and member_id=? ";
        try {
            BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter() {
                public void setValues(PreparedStatement pre, int num) throws SQLException {
                    pre.setInt(1, Integer.parseInt(memIds[num]));
                }

                public int getBatchSize() {
                    return memIds.length;
                }
            };
            return daoTemplate.batchUpdate(sql, setter);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    //删除vip的圈成员（多个）
    public void deleteGroupMems(Integer groupId, String database) {
        String sql = "delete from " + database + ".bsc_empgroup_member where group_id=" + groupId + " and role=4 ";
        daoTemplate.update(sql);
    }

    //设置领导屏蔽 1 屏蔽 2 不屏蔽
    public void updateGroupShield(Integer groupId,
                                  String leadShield, String database) {
        try {
            String sql = "update " + database + ".bsc_empgroup set lead_shield=" + leadShield + " where group_id=" + groupId;
            daoTemplate.update(sql);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @param searchContent
     * @return
     * @创建：作者:YYP 创建时间：2015-4-2
     * @see 查询员工圈
     */
    public List<SearchModel> querySearch(String searchContent, Integer memId, String datasource) {
        try {
            StringBuffer sql = new StringBuffer("select e.group_id as belongId,e.group_nm as nm,e.group_head as headUrl,4 as tp,(case when (select count(1) from "
                    + datasource + ".bsc_empgroup et left join " + datasource + ".bsc_empgroup_member emt on et.group_id=emt.group_id where et.group_id=e.group_id and emt.member_id=" + memId +
                    ")>0 then (select b.role from " + datasource + ".bsc_empgroup a left join " + datasource + ".bsc_empgroup_member b on a.group_id=b.group_id where a.group_id=e.group_id and b.member_id="
                    + memId + ") else 0 end) as whetherIn,e.is_open as datasource from " + datasource + ".bsc_empgroup e left join " + datasource + ".sys_mem m on e.member_id=m.member_id ");
            sql.append(" where e.group_nm like '%" + searchContent + "%' ");
            return daoTemplate.queryForLists(sql.toString(), SearchModel.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @param groupId
     * @param memId
     * @return
     * @创建：作者:YYP 创建时间：2015-4-3
     * @see 查询是否在圈里面
     */
    public Integer queryIsInGroup(Integer groupId, Integer memId, String datasource) {
        String sql = "select count(1) from " + datasource + ".bsc_empgroup_member where group_id=" + groupId + " and member_id=" + memId;
        try {
            return daoTemplate.queryForObject(sql, Integer.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @param groupId
     * @param tp
     * @param datasource
     * @return
     * @创建：作者:YYP 创建时间：2015-5-18
     * @see 查询群主+管理员
     */
    public List<SysMemDTO> queryAdminsAll(Integer groupId, String tp,
                                          String datasource) {
        StringBuffer sql = new StringBuffer("select m.member_id,m.member_nm,m.member_mobile from " + datasource + ".bsc_empgroup_member em left join " + datasource + ".sys_mem m on m.member_id=em.member_id where ");
        if ("1".equals(tp)) {
            sql.append(" (em.role=1 or em.role=2)  and em.group_id=" + groupId);
        }
        try {
            return daoTemplate.queryForLists(sql.toString(), SysMemDTO.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @param database
     * @return
     * @创建：作者:YYP 创建时间：2015-6-1
     * @see 查询所在公司的公开圈
     */
    public Map<String, Object> queryOpenGroups(String database) {
        String sql = "select group_concat(cast(group_id as char(20))) ids from " + database + ".bsc_empgroup where is_open='1' ";
        try {
            return daoTemplate.queryForMap(sql);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @param memId
     * @param datasource
     * @return
     * @创建：作者:YYP 创建时间：2015-6-12
     * @see 查询不在圈内且vip开放的员工圈ids
     */
    public Map<String, Object> queryGroupIds(Integer memId, String datasource) {
        StringBuilder sql = new StringBuilder(128)
                .append("select group_concat(cast(e.group_id as char(20))) ids from ").append(datasource).append(".bsc_empgroup e ");
        sql.append(" where e.group_id not in (select group_id from ").append(datasource).append(".bsc_empgroup_member em where em.member_id=").append(memId).append(") ");
        sql.append(" and e.is_open!='1'  and e.lead_shield!=1 ");
        try {
            return daoTemplate.queryForMap(sql.toString());
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @param memberId
     * @param datasource
     * @return
     * @创建：作者:YYP 创建时间：2015-6-15
     * @see 查询vip的角色圈ids
     */
    public Map<String, Object> queryvipGroupIds(Integer memberId,
                                                String datasource) {
        StringBuffer sql = new StringBuffer("select group_concat(cast(e.group_id as char(20))) ids from " + datasource + ".bsc_empgroup e ");
        sql.append(" left join " + datasource + ".bsc_empgroup_member em on e.group_id =em.group_id ");
        sql.append(" where em.role=4 and em.member_id=" + memberId);
        try {
            return daoTemplate.queryForMap(sql.toString());
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @param ids
     * @param datasource
     * @创建：作者:YYP 创建时间：2015-6-15
     * @see 批量删除圈成员
     */
    public int[] deleteGroupMems(final String[] ids, final Integer memberId, String datasource) {
        String sql = "delete from " + datasource + ".bsc_empgroup_member where group_id=? and member_id=?";
        try {
            BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter() {

                @Override
                public void setValues(PreparedStatement pre, int num) throws SQLException {
                    pre.setInt(1, Integer.parseInt(ids[num]));
                    pre.setInt(2, memberId);
                }

                @Override
                public int getBatchSize() {
                    return ids.length;
                }
            };
            return daoTemplate.batchUpdate(sql, setter);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    //创建公司时修改默认信息s
    public void updateGroupMess(Integer mId, String nowTime, String datasource) {
        String sql = "update " + datasource + ".bsc_empgroup set member_id=" + mId + ",creatime='" + nowTime + "'";
        daoTemplate.update(sql);
    }

    //创建公司时修改员工圈成员表默认信息
    public void updategMemMess(Integer mId, String nowTime, String datasource) {
        String sql = "update " + datasource + ".bsc_empgroup_member set member_id=" + mId + ",addtime='" + nowTime + "' ";
        daoTemplate.update(sql);
    }

    /**
     * @param memId
     * @param groupId
     * @param datasource
     * @return
     * @创建：作者:YYP 创建时间：Aug 26, 2015
     * @see @功能查询圈成员
     */
    public Page queryAitaMemPage(Integer memId, Integer groupId,
                                 String datasource, Integer pageNo, Integer pageSize, String search) {
        StringBuffer sql = new StringBuffer("select m.member_id,m.member_head,m.member_nm,m.first_char,m.member_mobile ");
        sql.append(" from " + datasource + ".bsc_empgroup_member em," + datasource + ".sys_mem m ");
        sql.append(" where m.member_use=1 and em.member_id=m.member_id and em.member_id!=" + memId + " and em.group_id=" + groupId);
        sql.append(" and em.role!='4' ");
        if (!StrUtil.isNull(search)) {
            sql.append(" and m.member_nm like '%" + search + "%' ");
        }
        sql.append("order by m.first_char asc,em.role asc");
        try {
            return daoTemplate.queryForPageByMySql(sql.toString(), pageNo, pageSize, SysMemDTO.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @param sortId
     * @param datasource
     * @return
     * @创建：作者:YYP 创建时间：Aug 26, 2015
     * @see 根据分类id查询圈成员信息
     */
    public BscEmpGroupMember queryGroupBySortid(Integer memId, Integer sortId,
                                                String datasource) {
        StringBuffer sql = new StringBuffer("select em.role,em.group_id ");
        sql.append(" from " + datasource + ".bsc_empgroup_member em," + datasource + ".bsc_sort s ");
        sql.append(" where em.group_id=s.group_id and em.member_id=" + memId + " and s.sort_id=" + sortId);
        try {
            return daoTemplate.queryForObj(sql.toString(), BscEmpGroupMember.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }
}
