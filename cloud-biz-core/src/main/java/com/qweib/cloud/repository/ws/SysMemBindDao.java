package com.qweib.cloud.repository.ws;

import com.qweib.cloud.core.dao.JdbcDaoTemplatePlud;
import com.qweib.cloud.core.domain.SysMemBind;
import com.qweib.cloud.core.domain.SysMember;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.repository.utils.HttpResponseUtils;
import com.qweib.cloud.service.member.domain.member.SysMemberDTO;
import com.qweib.cloud.service.member.retrofit.SysMemberRequest;
import com.qweib.cloud.utils.Collections3;
import com.qweib.cloud.utils.Page;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

/**
 * @说明：成员关系
 * @创建者： 作者：YJP 创建时间：2014-4-23
 */
@Repository
public class SysMemBindDao {

    @Resource(name = "pdaoTemplate")
    private JdbcDaoTemplatePlud daoTemplate;
//    @Qualifier("memberRequest")
//    @Autowired
//    private SysMemberRequest memberRequest;

    /**
     * 摘要：查询我的粉丝
     *
     * @param @param  memberId
     * @param @return
     * @说明：
     * @创建：作者:YYP 创建时间：2014-9-14
     * @修改历史： [序号](YYP 2014 - 9 - 14)<修改说明>
     */
    public List<SysMember> queryMyfs(Integer memberId, String datasource) {
        StringBuffer sql = new StringBuffer(" select s.member_id,s.member_nm,s.member_mobile,s.member_head ,s.first_char from " + datasource + ".sys_mem s ");
        sql.append(" inner join " + datasource + ".sys_mem_bind b on s.member_id = b.member_id where bind_member_id=").append(memberId);
        sql.append(" and bind_tp=1 ");
        try {
            return this.daoTemplate.queryForLists(sql.toString(), SysMember.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @return
     * @说明：1我的好友/2常用好友/3黑名单
     * @创建者： 作者： llp  创建时间：2015-2-6
     */
    public Page queryMyMember(Integer pageNo, Integer pageSize, Integer memberId, String tp) {
        try {
            StringBuilder sql = new StringBuilder(64).append("SELECT b.* FROM sys_mem_bind b WHERE 1=1");
            if (tp.equals("1")) {
                sql.append(" AND b.bind_tp=1 ");
                sql.append(" AND b.member_id=" + memberId);
            } else if (tp.equals("2")) {
                sql.append(" AND b.is_used=1 AND b.bind_tp=1");
                sql.append(" AND b.member_id=" + memberId);
            } else {
                sql.append(" AND b.bind_tp=2");
                sql.append(" AND b.member_id=" + memberId);
            }
            Page page = this.daoTemplate.queryForPageByMySql(sql.toString(), pageNo, pageSize, SysMemBind.class);
            List<SysMemBind> rows = page.getRows();
            convertSysMemBind(rows);
            return page;
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    private void convertSysMemBind(List<SysMemBind> list) {
//        if (Collections3.isNotEmpty(list)) {
//            for (SysMemBind bind : list) {
//                Integer memberId = bind.getBindMemberId();
//                if (memberId != null && memberId > 0) {
//                    SysMemberDTO memberDTO = HttpResponseUtils.convertResponseNull(memberRequest.get(memberId));
//                    if (memberDTO != null) {
//                        bind.setMemberNm(memberDTO.getName());
//                        bind.setMemberMobile(memberDTO.getMobile());
//                        bind.setFirstChar(memberDTO.getFirstChar());
//                        bind.setMemberHead(memberDTO.getHead());
//                    }
//                }
//            }
//        }
    }

    /**
     * 查询常用好友
     */
    public List<SysMemBind> queryCy(Integer memberid) {
        try {
            String sql = "select b.member_id as memberId,b.bind_member_id as bindMemberId from sys_mem_bind b where 1=1 and b.is_used=1 and b.bind_tp=1 and b.member_id=" + memberid;
            List<SysMemBind> list = this.daoTemplate.queryForLists(sql, SysMemBind.class);
            convertSysMemBind(list);
            return list;
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    //常用联系人的id
    public List<Map<String, Object>> queryoftenMems(Integer memberid) {
        try {
            String sql = "select (group_concat(CAST(b.bind_member_id as char(20)))) as mems from sys_mem_bind b where 1=1 and b.is_used=1 and b.bind_tp=1 and b.member_id=" + memberid;
            return this.daoTemplate.queryForList(sql);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @return
     * @说明：设置好友常用状态
     * @创建者： 作者： llp  创建时间：2015-2-9
     */
    public int updateMemberbindByused(String tp, Integer memberId, Integer memberBindId) {
        try {
            String sql = "update sys_mem_bind set is_used=? where member_id=? and bind_member_id=? ";
            return this.daoTemplate.update(sql, tp, memberId, memberBindId);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @return
     * @说明：设置好友关系状态
     * @创建者： 作者： llp  创建时间：2015-2-11
     */
    public int updateMemberbindByzt(String tp, Integer memberId, Integer memberBindId) {
        try {
            String sql = "update sys_mem_bind set bind_tp=? where member_id=? and bind_member_id=? ";
            return this.daoTemplate.update(sql, tp, memberId, memberBindId);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @return int
     * @说明：删除我的好友
     * @创建者： 作者： llp  创建时间：2015-2-11
     */
    public int deleteMemberAttention(Integer memberId, Integer memberBindId) {
        try {
            StringBuffer sql = new StringBuffer("delete from sys_mem_bind where member_id =").append(memberId).append(" and bind_member_id = ").append(memberBindId);
            return this.daoTemplate.update(sql.toString());
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @说明：添加好友
     * @创建者： 作者： llp  创建时间：2015-2-11
     */
    public int addMemberAttention(SysMemBind sb) {
        try {
            return this.daoTemplate.addByObject("sys_mem_bind", sb);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @说明：判断该成员是否已成为好友
     * @创建者： 作者:llp  创建时间：2015-2-11
     */
    public int queryIsMyFriends(Integer memberId, Integer bindId, Integer bindTp) {
        try {
            //TODO
            StringBuffer sql = new StringBuffer("select count(1) as count from sys_mem_bind where 1=1 and member_id = " + memberId);
            sql.append(" and bind_member_id =" + bindId).append(" and bind_tp =" + bindTp);
            Map<String, Object> obj = this.daoTemplate.queryForMap(sql.toString());
            return Integer.valueOf(obj.get("count").toString());
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }
}
