package com.qweib.cloud.repository.ws;


import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.dao.JdbcDaoTemplatePlud;
import com.qweib.cloud.core.domain.SysMemDTO;
import com.qweib.cloud.core.domain.SysMember;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.repository.utils.HttpResponseUtils;
import com.qweib.cloud.service.member.retrofit.SysMemberRequest;
import com.qweib.cloud.utils.StrUtil;
import org.dozer.Mapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
public class SysMemWebDao {

    @Resource(name = "pdaoTemplate")
    private JdbcDaoTemplatePlud daoTemplate;
    @Resource(name = "daoTemplate")
    private JdbcDaoTemplate daoTemplate2;

    @Autowired
    private Mapper mapper;

    /**
     * 根据公共平台id(pId)查找企业会员记录
     */
    public SysMember queryMemBypid(Integer pid, String database) {
        try {
            String sql = " select * from " + database + ".sys_mem where member_id =?";
            return this.daoTemplate.queryForObj(sql, SysMember.class, pid);
        } catch (DaoException e) {
            throw new DaoException(e);
        }
    }

    /**
     * 修改企业平台会员
     */
    public int updateMem(SysMember sysMem, String database) {
        try {
            Map<String, Object> whereParam = new HashMap<String, Object>();
            whereParam.put("member_id", sysMem.getMemberId());
            return this.daoTemplate2.updateByObject(database + ".sys_mem", sysMem, whereParam, "member_id");
        } catch (Exception ex) {
            throw new DaoException(ex);
        }
    }

    /**
     * 说明：获取成员(企业)
     */
    public SysMember queryCompanySysMemberById(String datasource, Integer Id) {
        try {
            String sql = "select * from " + datasource + ".sys_mem where member_id=? ";
            return this.daoTemplate2.queryForObj(sql, SysMember.class, Id);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 摘要：
     *
     * @param
     * @return
     * @说明：根据一批次手机号码查找用户
     * @创建：作者:yxy 创建时间：2012-1-12
     * @修改历史： [序号](yxy 2012 - 1 - 12)<修改说明>
     */
    public List<SysMember> queryLoginInfo(String[] atMobiles, String database) {
        StringBuffer sql = new StringBuffer("select member_id,member_mobile from ").append(database);
        sql.append(".sys_mem where member_mobile in (?) and member_activate='1' and member_use='1' ");
        try {
            String mobiles = Arrays.toString(atMobiles);
            String temple = mobiles.substring(1, mobiles.length() - 1);
            return daoTemplate2.queryForLists(sql.toString(), SysMember.class, temple);
        } catch (Exception ex) {
            throw new DaoException(ex);
        }
    }

    /*
     * 根据id查询员工信息
     */
    public SysMemDTO queryMemByMemId(Integer memId) {
        StringBuffer sql = new StringBuffer("select member_mobile,member_id from sys_member where member_id=").append(memId);
        try {
            return daoTemplate.queryForObj(sql.toString(), SysMemDTO.class);
        } catch (Exception ex) {
            throw new DaoException(ex);
        }
        //return HttpResponseUtils.convertToEntity(memberRequest.get(memId), SysMemDTO.class, mapper);
    }

    /**
     * 通过会员id查找会员(名称,介绍,头像)
     */
    public SysMember queryMemByMid(Integer memId, String database) {
        String sql = "select member_id,member_nm,member_desc,member_head from " + database + ".sys_mem where member_id=?";
        try {
            return daoTemplate2.queryForObj(sql.toString(), SysMember.class, memId);
        } catch (DaoException e) {
            throw new DaoException(e);
        }
    }

    /**
     * 通过会员id查找会员(名称,介绍,头像)
     */
    public List<SysMember> queryMemberList(String database) {
        String sql = "select member_id,member_nm,member_desc,member_head from " + database + ".sys_mem";
        try {
            return daoTemplate2.queryForLists(sql.toString(), SysMember.class);
        } catch (DaoException e) {
            throw new DaoException(e);
        }
    }

    /**
     * 根据条件查询用户
     */
    @SuppressWarnings("unchecked")
    public SysMember queryMember(Class cls, Integer memberId, String mobile, String database) {
        StringBuffer sql = new StringBuffer("select s.* from " + database + ".sys_mem s where 1=1");
        if (memberId != null) {
            sql.append(" and s.member_id = ").append(memberId);
        }
        if (mobile != null) {
            sql.append(" and s.member_mobile = ").append(mobile);
        }
        sql.append("  and s.member_use='1'");
        try {
            return daoTemplate2.queryForObj(sql.toString(), cls);
        } catch (Exception ex) {
            throw new DaoException(ex);
        }
    }

    /**
     * 按memberId更新头像文件名称
     *
     * @param fileName
     * @param memberId
     */
    public void updatePhoto(String fileName, String fileBg, Integer memberId, String database) {
        String sql = null;
        if (!StrUtil.isNull(fileName)) {
            sql = " update " + database + ".sys_mem set member_head='" + fileName + "' where member_id=?";
        } else if (!StrUtil.isNull(fileBg)) {
            sql = " update " + database + ".sys_mem set member_graduated='" + fileBg + "' where member_id=?";
        }
        try {
            daoTemplate2.update(sql, memberId);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 根据ids查询成员
     *
     * @param ids
     * @param database
     * @return
     * @创建：作者:YYP 创建时间：2015-3-3
     */
    public List<SysMemDTO> queryMemByIds(String ids, String database) {
        StringBuffer sql = new StringBuffer("select member_id,member_mobile from ").append(database).append(".sys_mem");
        sql.append(" where member_id in (").append(ids).append(") ");
        try {
            return daoTemplate2.queryForLists(sql.toString(), SysMemDTO.class);
        } catch (Exception ex) {
            throw new DaoException(ex);
        }
    }

    /**
     * @param database
     * @return
     * @创建：作者:YYP 创建时间：2015-3-6
     * @see
     */
    public List<Map<String, Object>> queryLeadMemIds(String database, Integer memberId, String memIds, String adminIds) {
        String sql = "select group_concat(CAST(member_id as char(20))) as mems from " + database + ".sys_mem where is_lead=1 and member_id!=" + memberId;
        if (!StrUtil.isNull(memIds)) {
            sql += " and member_id not in (" + memIds + ") ";
        }
        if (!StrUtil.isNull(adminIds)) {
            sql += " and member_id not in (" + adminIds + ") ";
        }
        try {
            return daoTemplate2.queryForList(sql);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    //查询不在圈内的领导ids
    public List<Map<String, Object>> queryLmemIds(String datasource,
                                                  Integer memberId, Integer groupId) {
        StringBuffer sql = new StringBuffer("select group_concat(CAST(member_id as char(20))) as mems from " + datasource + ".sys_mem");
        sql.append(" where is_lead=1 and member_id not in (select group_concat(cast(member_id as char(20))) from " + datasource + ".bsc_empgroup_member where group_id=" + groupId + ") ");
        try {
            return daoTemplate2.queryForList(sql.toString());
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * @param
     * @param database
     * @return
     * @创建：作者:YYP 创建时间：2015-3-12
     * @see （包括子部门）下的所有成员
     */
    public List<SysMemDTO> queryDeptMids(String branchPath, String database) {
        StringBuffer sql = new StringBuffer("select m.member_id,m.member_mobile from ").append(database).append(".sys_mem m ");
        sql.append(" left join ").append(database).append(".sys_depart b on m.branch_id=b.branch_id where b.branch_path like '").append(branchPath).append("%' ");
        try {
            return daoTemplate2.queryForLists(sql.toString(), SysMemDTO.class);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * @param database
     * @return
     * @创建：作者:YYP 创建时间：2015-3-17
     * @see
     */
    public List<SysMemDTO> queryDeptMids(String database) {
        String sql = "select member_id,member_mobile from " + database + ".sys_mem ";
        try {
            return daoTemplate2.queryForLists(sql, SysMemDTO.class);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * @param belongId
     * @param database
     * @创建：作者:YYP 创建时间：2015-3-21
     * @see //修改成员所属部门
     */
    public void updateMemberBranchId(Integer belongId, Integer memId, String database) {
        StringBuffer sql = new StringBuffer("update " + database + ".sys_mem ");
        if (0 != belongId) {
            sql.append("set branch_id=" + belongId);
        } else {
            sql.append("set branch_id=NULL ");
        }
        sql.append(" where member_id=" + memId);
        try {
            daoTemplate2.update(sql.toString());
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * @param memId
     * @param database
     * @创建：作者:YYP 创建时间：2015-4-8
     * @see //删除成员
     */
    public void deleteMemById(Integer memId, String database) {
        String sql = "delete from " + database + ".sys_mem where member_id=" + memId;
        try {
            daoTemplate2.update(sql);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * @param memId
     * @param database
     * @创建：作者:YYP 创建时间：2015-4-8
     * @see //删除成员轨迹关联
     */
    public void deleteMemGjById(Integer memId, String database) {
        String sql = "delete from " + database + ".sys_zcusr where cusr_id=" + memId + " or zusr_id=" + memId;
        try {
            daoTemplate2.update(sql);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * @param bindMemberId
     * @param datasource
     * @return
     * @创建：作者:YYP 创建时间：2015-4-17
     * @see //查询是否同一个公司
     */
    public Integer queryIsSameCompany(Integer bindMemberId, String datasource) {
        String sql = "select count(1) from " + datasource + ".sys_mem where member_id=" + bindMemberId;
        try {
            return daoTemplate2.queryForObject(sql, Integer.class);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * @param memberId
     * @param //database
     * @return
     * @创建：作者:YYP 创建时间：2015-5-22
     * @see //查询除成员外的其他成员ids
     */
    public List<Map<String, Object>> queryMemIdOutId(Integer memberId, String memIds, String adminIds, String datasource) {
        String sql = "select group_concat(CAST(member_id as char(20))) as mids from " + datasource + ".sys_mem where member_id!=" + memberId;
        if (!StrUtil.isNull(memIds)) {
            sql += " and member_id not in (" + memIds + ") ";
        }
        if (!StrUtil.isNull(adminIds)) {
            sql += " and member_id not in (" + adminIds + ") ";
        }
        try {
            return daoTemplate2.queryForList(sql.toString());
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * @param deptId
     * @param datasource
     * @创建：作者:YYP 创建时间：2015-5-23
     * @see //删除部门时更新成员部门信息
     */
    public void updateMemBranchId(Integer deptId, String datasource) {
        String sql = "update " + datasource + ".sys_mem set branch_id=null where branch_id=" + deptId;
        try {
            daoTemplate2.update(sql);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 修改成员密码
     *
     * @param datasource
     * @param memberId
     * @param newpwd
     */
    public void updateMemPwd(String datasource, Integer memberId, String newpwd) {
        String sql = "update " + datasource + ".sys_mem set member_pwd='" + newpwd + "' where member_id=" + memberId;
        try {
            daoTemplate2.update(sql);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 摘要：
     *
     * @说明：根据用户组id获取用户信息
     * @创建：作者:llp 创建时间：2017-1-21
     * @修改历史： [序号](llp 2017 - 1 - 21)<修改说明>
     */
    public List<SysMember> queryMemByMemIds(String memIds, String database) {
        StringBuffer sql = new StringBuffer("select member_id,member_nm,member_head from ").append(database);
        sql.append(".sys_mem where member_id in (" + memIds + ") ");
        try {

            return daoTemplate2.queryForLists(sql.toString(), SysMember.class);
        } catch (Exception ex) {
            throw new DaoException(ex);
        }
    }

    /**
     * 根据设备唯一识别号--查找企业会员记录
     */
    public SysMember queryMemByUnid(String unId, String database) {
        try {
            String sql = " select * from " + database + ".sys_mem where un_id =?";
            return this.daoTemplate.queryForObj(sql.toString(), SysMember.class, unId);
        } catch (DaoException e) {
            throw new DaoException(e);
        }
    }

    /**
     * 根据手机号--查找企业会员记录
     */
    public SysMember queryMemByMobile(String mobile, String database) {
        try {
            String sql = " select * from " + database + ".sys_mem where member_mobile =?";
            return this.daoTemplate.queryForObj(sql.toString(), SysMember.class, mobile);
        } catch (DaoException e) {
            throw new DaoException(e);
        }
    }
}
