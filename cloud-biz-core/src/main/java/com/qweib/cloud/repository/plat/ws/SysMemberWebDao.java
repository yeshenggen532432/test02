package com.qweib.cloud.repository.plat.ws;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.dao.JdbcDaoTemplatePlud;
import com.qweib.cloud.core.domain.SysMemDTO;
import com.qweib.cloud.core.domain.SysMember;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.repository.utils.HttpResponseUtils;
import com.qweib.cloud.repository.utils.MemberUtils;
import com.qweib.cloud.service.member.common.CertifyStateEnum;
import com.qweib.cloud.service.member.common.MemberUpdatePropertyEnum;
import com.qweib.cloud.service.member.common.MemberUseEnum;
import com.qweib.cloud.service.member.domain.corporation.SysCorporationDTO;
import com.qweib.cloud.service.member.domain.member.*;
import com.qweib.cloud.service.member.retrofit.SysCorporationRequest;
import com.qweib.cloud.service.member.retrofit.SysMemberCompanyRequest;
import com.qweib.cloud.service.member.retrofit.SysMemberRequest;
import com.qweib.cloud.utils.Collections3;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import com.qweib.commons.MathUtils;
import com.qweib.commons.StringUtils;
import com.qweibframework.commons.http.ResponseUtils;
import org.dozer.Mapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.text.SimpleDateFormat;
import java.util.*;

@Repository
public class SysMemberWebDao {

    @Resource(name = "pdaoTemplate")
    private JdbcDaoTemplatePlud daoTemplate;
    @Resource(name = "daoTemplate")
    private JdbcDaoTemplate daoTemplate1;

    @Autowired
    private Mapper mapper;

    public SysMember queryMemberByMobile(String mobile) {
        String sql = "select member_id,member_nm,member_mobile,member_pwd,member_use,member_head,cid,is_unitmng,msgmodel,un_id,unit_id,member_company,rz_state,(select datasource from sys_corporation where dept_id=m.unit_id ) as datasource from sys_member m where (member_mobile=? or member_name=?)";
        try {
            return daoTemplate.queryForObj(sql, SysMember.class, mobile,mobile);
        } catch (Exception e) {
            throw new DaoException(e);
        }

    }

    public SysMember queryMemberByunId(String unId) {
        String sql = "select member_id,member_nm,member_mobile,member_pwd,member_use,member_head,is_unitmng,msgmodel,un_id,(select datasource from sys_corporation where dept_id=m.unit_id ) as datasource from sys_member m where un_id=?";
        try {
            return daoTemplate.queryForObj(sql, SysMember.class, unId);
        } catch (Exception e) {
            throw new DaoException(e);
        }

    }

    /**
     * 查询用户信息
     *
     * @param memberId
     * @return
     * @创建：作者:YYP 创建时间：2015-1-29
     * @see
     */
    public SysMember queryMemById(Integer memberId) {
        String sql = "select member_id,member_nm,member_mobile,member_head,member_blacklist,member_attentions,sex,member_hometown,member_desc,member_company,member_job,member_trade,member_name,unit_id,email from sys_member where member_id=?";
        try {
            return daoTemplate.queryForObj(sql.toString(), SysMember.class, memberId);
        } catch (Exception e) {
            throw new DaoException(e);
        }

    }

    /**
     * 查询用户所有信息
     */
    public SysMember queryAllById(Integer memberId) {
        String sql = "select * from sys_member where member_id=?";
        try {
            return daoTemplate.queryForObj(sql.toString(), SysMember.class, memberId);
        } catch (Exception e) {
            throw new DaoException(e);
        }


    }

    /**
     * 添加会员
     */
    public int addMember(SysMember sysmember) {
        try {
            sysmember.setMemberCreatime(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()));
            sysmember.setMemberActivate("1");//激活状态 1：激活 2：未激活
            sysmember.setMemberUse("1");//使用状态 1:启用2：禁用
            return this.daoTemplate.addByObject("publicplat.sys_member", sysmember);
            /*****用于更改id生成方式 by guojr******/
//

        } catch (Exception ex) {
            throw new DaoException(ex);
        }
    }

    /**
     * 修改会员
     */
    public int updateMember(SysMember sysmember) {
      try {
            Map<String, Object> whereParam = new HashMap<String, Object>();
            whereParam.put("member_id", sysmember.getMemberId());
            return this.daoTemplate.updateByObject("sys_member", sysmember, whereParam, "member_id");
        } catch (Exception ex) {
            throw new DaoException(ex);
        }


    }

    /**
     * 说明：根据手机号码判断有没有被公司邀请
     *
     * @创建：作者:llp 创建时间：2015-2-5
     * @修改历史： [序号](llp 2015 - 2 - 5)<修改说明>
     */
    public int querySysMemberByTel(String tel) {
        String sql = " select count(1) from sys_member where (unit_id is not null or unit_id=0) and member_mobile=? ";
        try {
            return this.daoTemplate.queryForObject(sql, new Object[]{tel}, Integer.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }

    }

    /**
     * 说明：根据成员id判断有没有加入部门
     *
     * @创建：作者:llp 创建时间：2015-2-5
     * @修改历史： [序号](llp 2015 - 2 - 5)<修改说明>
     */
    public int queryMemberByBmAndId(Integer mbId) {
        String sql = " select count(1) from sys_member where (branch_id is not null or branch_id=0) and member_id=? ";
        try {
            return this.daoTemplate.queryForObject(sql, new Object[]{mbId}, Integer.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }

    }

    /**
     * 说明：根据手机号码查找信息
     *
     * @创建：作者:llp 创建时间：2015-2-5
     * @修改历史： [序号](llp 2015 - 2 - 5)<修改说明>
     */
    public SysMember queryMemberByTel(String tel) {
        String sql = "select * from sys_member where member_mobile=?";
        try {
            return daoTemplate.queryForObj(sql.toString(), SysMember.class, tel);
        } catch (Exception e) {
            throw new DaoException(e);
        }

    }

    /**
     * 说明：根据id修改公司名称,公司id
     *
     * @创建：作者:llp 创建时间：2015-2-5
     * @修改历史： [序号](llp 2015 - 2 - 5)<修改说明>
     */
    public void updateMemberBycompany(String company, Integer unitid, Integer branchId, Integer memberid, String isUnitmng) {
        String sql = "update sys_member set ";
        if (null != unitid && null != branchId) {
            sql = sql + "member_company='" + company + "' ,unit_id=" + unitid + ",branch_id=" + branchId;
        } else if (null != unitid && null == branchId) {
            sql = sql + "member_company='" + company + "' ,unit_id=" + unitid;
        } else if (null == unitid && null != branchId) {
            if (0 != branchId) {
                sql = sql + "branch_id=" + branchId;
            } else {
                sql = sql + "branch_id=NULL ";
            }
        } else if (null == company && null == unitid && null == branchId && null == isUnitmng) {
            sql = sql + "member_company=NULL,unit_id=NULL,branch_id=NULL,is_unitmng=0";
        }
        if (null != isUnitmng) {
            sql = sql + " ,is_unitmng=" + isUnitmng;
        }
        sql = sql + " where member_id=? ";
        try {
            this.daoTemplate.update(sql, memberid);
        } catch (Exception e) {
            throw new DaoException(e);
        }


    }

    /**
     * 清除平台会员关联企业信息
     * @param memberId
     */
    public void clearPlatMemberCompanyData(Integer companyId, Integer memberId) {
        String sql = "update sys_member set ";
        sql = sql + "member_company=null,unit_id=null,branch_id=null,is_unitmng=0";
        sql = sql + " where member_id=? and unit_id=? ";
        try {
            this.daoTemplate.update(sql, memberId, companyId);
        } catch (Exception e) {
            throw new DaoException(e);
        }


    }

    public void updateCompanyMember(Integer companyId, Integer memberId, String leaveTime) {
        SysMemberCompanyLeaveTime input = new SysMemberCompanyLeaveTime();
        input.setCompanyId(companyId);
        input.setMemberId(memberId);
        input.setLeaveTime(leaveTime);
        String sql = "update sys_member_company set ";
        sql = sql + " out_time = null ";
        sql = sql + " where member_id=? and company_id=? ";
        try {
            this.daoTemplate.update(sql, memberId, companyId);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：根据id修改公司名称,公司id,部门id
     *
     * @创建：作者:llp 创建时间：2015-2-5
     * @修改历史： [序号](llp 2015 - 2 - 5)<修改说明>
     */
    public int updateMemBycompanyAndBm(String company, Long unitid, Integer branchId, Integer memberid) {
        String sql = "update sys_member set member_company=?,unit_id=?,branch_id=? where member_id=? ";
        try {
            return this.daoTemplate.update(sql, company, unitid, branchId, memberid);
        } catch (Exception e) {
            throw new DaoException(e);
        }

    }

    /**
     * 说明：根据id修改公司名称,公司id,部门id
     *
     * @创建：作者:llp 创建时间：2015-2-5
     * @修改历史： [序号](llp 2015 - 2 - 5)<修改说明>
     */
    public int updateMemBycompanyAndBm1(String company, Long unitid, Integer branchId, Integer memberid, String datasource) {
        String sql = "update " + datasource + ".sys_mem set member_company=?,unit_id=?,branch_id=? where member_id=? ";
        try {
            return this.daoTemplate1.update(sql, company, unitid, branchId, memberid);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：根据id修改公司名称,公司id
     *
     * @创建：作者:llp 创建时间：2015-2-5
     * @修改历史： [序号](llp 2015 - 2 - 5)<修改说明>
     */
    public int updateMemberBycompany1(String company, Long unitid, Integer memberid, String datasource) {
        String sql = "update " + datasource + ".sys_mem set member_company=?,unit_id=? where member_id=? ";
        try {
            return this.daoTemplate1.update(sql, company, unitid, memberid);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 根据id查询用户信息
     *
     * @param memId
     * @return
     * @创建：作者:YYP 创建时间：2015-2-10
     */
    public SysMemDTO queryMemByMemId(Integer memId) {
        StringBuffer sql = new StringBuffer("select m.member_id,m.member_mobile,c.datasource from sys_member m left join sys_corporation c on m.unit_id= c.dept_id where m.member_id=");
        sql.append(memId);
        try {
            return daoTemplate.queryForObj(sql.toString(), SysMemDTO.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }


    }

    /**
     * 查询是否为好友
     *
     * @param memberId
     * @param memId
     * @return
     * @创建：作者:YYP 创建时间：2015-2-10
     */
    public Map<String, Object> queryIsFriend(Integer memberId, Integer memId) {
        StringBuffer sql = new StringBuffer("select count(1)as count from sys_mem_bind where (member_id=").append(memberId).append(" and bind_member_id=").append(memId).append(") or (member_id=").append(memId).append(" and bind_member_id=").append(memberId).append(")");
        try {
            return daoTemplate.queryForMap(sql.toString());
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 根据条件查询用户
     */
    @SuppressWarnings("unchecked")
    public SysMember queryMember(Class cls, Integer memberId, String mobile) {
        StringBuffer sql = new StringBuffer("select s.* from sys_member s where 1=1");
        if (memberId != null) {
            sql.append(" and s.member_id = ").append(memberId);
        } else if (StringUtils.isNotBlank(mobile)) {
            sql.append(" and s.member_mobile = ").append(mobile);
        }
        sql.append("  and s.member_use='1'");
        try {
            return daoTemplate.queryForObj(sql.toString(), cls);
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
    public void updatePhoto(String fileName, String fileBg, Integer memberId) {
        String sql = null;
        if (!StrUtil.isNull(fileName)) {
            sql = " update sys_member set member_head='" + fileName + "' where member_id=?";
        } else if (!StrUtil.isNull(fileBg)) {
            sql = " update sys_member set member_graduated='" + fileBg + "' where member_id=?";
        }
        try {
            daoTemplate.update(sql, memberId);
        } catch (Exception e) {
            throw new DaoException(e);
        }

    }

    /**
     * 根据用户查询名单
     */
    public Page queryBlacklistByMid(Integer memId, Integer pageNo, Integer pageSize) {
        try {
            String sql = "select bind.bind_member_id AS member_id from sys_mem_bind bind" +
                    " where bind.bind_tp=2 and bind.member_id=" + memId;
            Page page = daoTemplate.queryForPageByMySql(sql, pageNo, pageSize, SysMember.class);
            List<SysMember> rows = page.getRows();

            return page;
        } catch (Exception ex) {
            throw new DaoException(ex);
        }
    }

    /**
     * 根据黑名单用户ID移除黑名单
     */
    public int deleteBlacklist(Integer memId, Integer bindId) {
        try {
            String sql = "delete from sys_mem_bind where member_id=? and bind_member_id = ? and bind_tp=2";
            return this.daoTemplate.update(sql, memId, bindId);
        } catch (Exception ex) {
            throw new DaoException(ex);
        }
    }

    /**
     * 修改黑名单数 扣除
     *
     * @param memId
     * @return
     */
    public void updateMemberBlacklist(Integer memId) {
        try {
            String sql = "update sys_member set member_blacklist=member_blacklist-1 where member_id = ?";
            this.daoTemplate.update(sql, memId);
        } catch (Exception e) {
            throw new DaoException(e);
        }

    }

//    /**
//     * 查询是否消息屏蔽
//     * @param str
//     * @param state
//     * @return
//     * @创建：作者:YYP 创建时间：2015-3-11
//     */
//    public Map<String, Object> querySetting(String str, String state) {
//        try {
//            String sql = "select group_concat(member_mobile) as str from sys_member where state=" + state + " and member_mobile in (" + str + ") ";
//            return daoTemplate.queryForMap(sql);
//        } catch (Exception e) {
//            throw new DaoException(e);
//        }
//    }

    /**
     * 根据id查询成员信息
     *
     * @param memId
     * @return
     * @创建：作者:YYP 创建时间：2015-3-13
     */
    public SysMember queryMemberById(Integer memId) {
        String sql = "select * from sys_member where member_id = " + memId;
        try {
            return daoTemplate.queryForObj(sql, SysMember.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }

    }

    public SysMember querymemCompany(Integer memId) {
        String sql = "select m.member_id,m.member_nm,m.unit_id,c.dept_nm as branchName,m.branch_id from sys_member m left join sys_corporation c on m.unit_id=c.dept_id where m.member_id = " + memId;
        try {
            return daoTemplate.queryForObj(sql, SysMember.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }

    }

    /**
     * 通过id查询会员信息和部门名称
     */
    public SysMember queryMemAndDeptById(String database, Integer memberId) {
        try {
            if (!StrUtil.isNull(database)) {
                StringBuffer sql = new StringBuffer("select m.member_id,m.member_nm,m.member_mobile,m.member_head,m.member_blacklist,m.member_attentions,m.sex");
                sql.append(",m.member_hometown,m.member_desc,m.member_company,m.member_job,m.member_name,m.unit_id,m.email,d.branch_name from " + database + ".sys_mem m");
                sql.append(" LEFT JOIN " + database + ".sys_depart d ON d.branch_id = m.branch_id  where member_id=?");
                //StringBuffer sql = new StringBuffer("select m.*,d.branch_name from " + database + ".sys_mem m");
                //sql.append(" LEFT JOIN " + database + ".sys_depart d ON d.branch_id = m.branch_id  where member_id=?");
                return daoTemplate1.queryForObj(sql.toString(), SysMember.class, memberId);
            } else {
                return null;
//                String sql = "select member_id,member_nm,member_mobile,member_head,member_blacklist,member_attentions,sex,member_hometown,member_desc,member_company,member_job,member_name,unit_id,email from sys_member where member_id=?";
//                return daoTemplate.queryForObj(sql, SysMember.class, memberId);
                //return HttpResponseUtils.convertToEntity(memberRequest.get(memberId), SysMember.class, mapper);
            }
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 删除部门时更新成员部门信息
     *
     * @param unitId
     * @param deptId
     * @创建：作者:YYP 创建时间：2015-5-25
     */
    public void updateMemberBranchId(Integer unitId, Integer deptId) {
        String sql = "update sys_member set branch_id=NULL,unit_id=NULL where unit_id=" + unitId + " and branch_id=" + deptId;
        try {
            daoTemplate.update(sql);
        } catch (Exception e) {
            throw new DaoException(e);
        }


    }

    //修改公共平台成员密码
    public Integer updateMemberPwd(Integer memberId, String newpwd) {
        String sql = "update sys_member set member_pwd='" + newpwd + "' where member_id=" + memberId;
        try {
            return daoTemplate.update(sql);
        } catch (Exception e) {
            throw new DaoException(e);
        }

    }

    //修改唯一码
    public void updateunId(String database, String unId, Integer memberId) {
        String sql1 = "update sys_member set un_id='" + unId + "' where member_id=" + memberId;
        String sql2 = "update " + database + ".sys_mem set un_id='" + unId + "' where member_id=" + memberId;
        try {
            daoTemplate.update(sql1);

            daoTemplate1.update(sql2);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    //获取公司所有人数
    public int queryMemCount(String database) {
        String sql = " select count(1) from " + database + ".sys_mem ";
        try {
            return this.daoTemplate1.queryForObject(sql, Integer.class);
        } catch (DaoException e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：获取部门下的用户id
     *
     * @创建：作者:llp 创建时间：2016-7-28
     * @修改历史： [序号](llp 2016 - 7 - 28)<修改说明>
     */
    public Map<String, Object> queryMidStr(String database, Integer branchId) {
        try {
            String sql = "select group_concat(CAST(a.member_id as char)) as str from " + database + ".sys_mem a where a.branch_id in (select branch_id from " + database + ".sys_depart where branch_path like '%-" + branchId + "-%')";
            return daoTemplate.queryForMap(sql);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：根据手机号修改密码
     *
     * @创建：作者:llp 创建时间：2017-11-7
     * @修改历史： [序号](llp 2017 - 11 - 7)<修改说明>
     */
    public void updateUerPwd(String database, String memberPwd, String memberMobile) {
        try {
            String sql1 = "update sys_member set member_pwd='" + memberPwd + "' where member_mobile='" + memberMobile + "'";
            daoTemplate.update(sql1);

            if (!StrUtil.isNull(database)) {
                String sql2 = "update " + database + ".sys_mem set member_pwd='" + memberPwd + "' where member_mobile='" + memberMobile + "'";
                daoTemplate1.update(sql2);
            }
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /*public List<ShopMemberCompany> queryShopMemberCompanyList(ShopMemberCompany member) {
        try {
            String sql = "select a.* from shop_member_company a where 1=1 ";
            if (member != null) {
                if (!StrUtil.isNull(member.getMemberId())) {
                    sql = sql + " and a.member_id=" + member.getMemberId();
                }
                if (!StrUtil.isNull(member.getCompanyId())) {
                    sql = sql + " and a.company_id=" + member.getCompanyId();
                }
                if (!StrUtil.isNull(member.getMemberMobile())) {
                    sql = sql + " and a.member_mobile='" + member.getMemberMobile() + "'";
                }
                if (!StrUtil.isNull(member.getOutTime())) {
                    sql = sql + " and (a.out_time is null or a.out_time ='')";
                }
            }
            List<ShopMemberCompany> list = this.daoTemplate1.queryForLists(sql, ShopMemberCompany.class);
            return list;
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }*/
}
