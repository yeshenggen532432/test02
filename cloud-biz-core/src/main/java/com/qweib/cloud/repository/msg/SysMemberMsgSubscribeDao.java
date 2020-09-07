package com.qweib.cloud.repository.msg;

import com.google.common.collect.Lists;
import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.SysMember;
import com.qweib.cloud.core.domain.msg.SysMemberMsgSubscribe;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.repository.utils.HttpResponseUtils;
import com.qweib.cloud.service.member.domain.basedata.SysSubjectMsgDTO;
import com.qweib.cloud.service.member.retrofit.SysSubjectMsgRetrofitApi;
import com.qweib.cloud.utils.Page;
import com.qweib.commons.StringUtils;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.List;

/**
 * 会员消息订阅
 */
@Repository
public class SysMemberMsgSubscribeDao {

    @Resource(name = "daoTemplate")
    private JdbcDaoTemplate daoTemplate;
//    @Resource
//    private SysSubjectMsgRetrofitApi api;

    /**
     * 增加会员订阅
     *
     * @param database
     * @param list
     * @return
     */
    public int add(List<SysMemberMsgSubscribe> list, String database) {
        try {
            for (SysMemberMsgSubscribe sysMemberMsgSubscribe : list) {
                add(sysMemberMsgSubscribe, database);
            }
        } catch (Exception e) {
            throw new DaoException(e);
        }
        return 1;
    }

    /**
     * 增加会员订阅
     *
     * @param database
     * @param sysMemberMsgSubscribe
     * @return
     */
    public int add(SysMemberMsgSubscribe sysMemberMsgSubscribe, String database) {
        return this.daoTemplate.addByObject(database + ".sys_member_msg_subscribe", sysMemberMsgSubscribe);
    }

    /**
     * 根据会员查询所有订阅
     *
     * @param memberId
     * @param database
     * @return
     */
    public List<SysMemberMsgSubscribe> findAllByMemberId(int memberId, String database) {
        try {
            String sql = "select * from " + database + ".sys_member_msg_subscribe where member_id=" + memberId;
            return this.daoTemplate.queryForLists(sql, SysMemberMsgSubscribe.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }


    /**
     * 根据获取标记得到订阅会员
     *
     * @param sign     获取标记
     * @param database
     * @return
     */
   /* public List<SysMemberMsgSubscribe> findAllBySign(String sign, String database) {
        try {
            SysSubjectMsgDTO dto = HttpResponseUtils.convertResponseNull(api.findBySign(sign));
            Map<Integer, SysSubjectMsgDTO> subjectCache = Maps.newHashMap();
            String sql = "select mms.* from " + database + ".sys_member_msg_subscribe mms";
            List<SysMemberMsgSubscribe> subscribeList = this.daoTemplate.queryForLists(sql, SysMemberMsgSubscribe.class);
            if (Collections3.isNotEmpty(subscribeList)) {
                return subscribeList.stream().filter(subscribe -> {
                    Integer subjectId = subscribe.getSysSubjectId();
                    SysSubjectMsgDTO subject;
                    if (subjectCache.containsKey(subjectId)) {
                        subject = subjectCache.get(subjectId);
                    } else {
                        subject = HttpResponseUtils.convertResponseNull(api.getById(subjectId));
                        if (subject == null) {
                            return false;
                        }
                        subjectCache.put(subjectId, subject);
                    }
                    return StringUtils.equals(subject.getSign(), sign) && subject.getState() != null && subject.getState().equals(1);
                }).collect(Collectors.toList());
            }
            return Lists.newArrayList();
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }*/


    /**
     * 根据获取标记得到订阅会员
     *
     * @param sign     获取标记
     * @param database
     * @return
     */
    public List<SysMemberMsgSubscribe> findAllBySign(String sign, String database) {
        try {
            SysSubjectMsgDTO dto = new SysSubjectMsgDTO();// HttpResponseUtils.convertResponseNull(api.findBySign(sign));
            if (dto != null && dto.getState() != null && dto.getState() == 1) {
                String sql = "select mms.* from " + database + ".sys_member_msg_subscribe mms where mms.sys_subject_id=" + dto.getId();
                return this.daoTemplate.queryForLists(sql, SysMemberMsgSubscribe.class);
            } else {
                return Lists.newArrayList();
            }
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 删除会员订阅所有
     *
     * @param memberId
     * @param database
     * @return
     */
    public int del(int memberId, String database) {
        try {
            return this.daoTemplate.update("delete from " + database + ".sys_member_msg_subscribe where member_id=?", memberId);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 删除会员订阅所有
     *
     * @param memberId
     * @param database
     * @return
     */
    public int del(int memberId, int sysSubjectId, String database) {
        try {
            return this.daoTemplate.update("delete from " + database + ".sys_member_msg_subscribe where member_id=? and sys_subject_id=?", memberId, sysSubjectId);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }


    /**
     * 根据消息ID获取订阅会员
     *
     * @param sysSubjectId
     * @param pageNo
     * @param limit
     * @param database
     * @return
     */
    public Page querySubscribeMemberPage(Integer sysSubjectId, String memberNm, Integer pageNo, Integer limit, String database) {
        String sql = "select sm.* from " + database + ".sys_member_msg_subscribe mms left join  " + database + ".sys_mem sm on mms.member_id=sm.member_id where mms.sys_subject_id=" + sysSubjectId;
        if (StringUtils.isNotBlank(memberNm))
            sql += " and sm.member_nm like '%" + memberNm + "%'";
        return this.daoTemplate.queryForPageByMySql(sql.toString(), pageNo, limit, SysMember.class);
    }


    /**
     * 根据消息ID获取未订阅会员
     *
     * @param sysSubjectId
     * @param pageNo
     * @param limit
     * @param database
     * @return
     */
    public Page queryNotSubscribeMemberPage(Integer sysSubjectId, String memberNm, Integer pageNo, Integer limit, String database) {
        String sql = "select sm.* from  " + database + ".sys_mem sm where sm.member_use=1  and member_id not in (select member_id from  " + database + ".sys_member_msg_subscribe mms where mms.sys_subject_id=" + sysSubjectId + ")";
        if (StringUtils.isNotBlank(memberNm))
            sql += " and sm.member_nm like '%" + memberNm + "%'";
        return this.daoTemplate.queryForPageByMySql(sql.toString(), pageNo, limit, SysMember.class);
    }

}
