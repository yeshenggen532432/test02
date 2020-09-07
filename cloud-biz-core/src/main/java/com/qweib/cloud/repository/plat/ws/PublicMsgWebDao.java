package com.qweib.cloud.repository.plat.ws;

import com.google.common.collect.Lists;
import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.dao.JdbcDaoTemplatePlud;
import com.qweib.cloud.core.domain.BscEmpGroupMsg;
import com.qweib.cloud.core.domain.SysChatMsg;
import com.qweib.cloud.core.domain.SysMemberMsg;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.repository.utils.HttpResponseUtils;
import com.qweib.cloud.service.member.domain.member.SysMemberDTO;
import com.qweib.cloud.service.member.domain.msg.SysChatMsgDTO;
import com.qweib.cloud.service.member.retrofit.SysChatMsgRetrofitApi;
import com.qweib.cloud.service.member.retrofit.SysMemberRequest;
import com.qweib.cloud.utils.Collections3;
import com.qweib.cloud.utils.StrUtil;
import com.qweib.commons.MathUtils;
import com.qweib.commons.mapper.BeanMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.List;

@Repository
public class PublicMsgWebDao {
    @Resource(name = "pdaoTemplate")
    private JdbcDaoTemplatePlud pdaoTemplate;
    @Resource(name = "daoTemplate")
    private JdbcDaoTemplate daoTemplate;
//    @Qualifier("memberRequest")
//    @Autowired
//    private SysMemberRequest memberRequest;
//    @Autowired
//    private SysChatMsgRetrofitApi chatMsgApi;

    public int addMemerMsg(SysMemberMsg msg) {
        try {
            /*****用于更改id生成方式 by guojr******/
            return pdaoTemplate.addByObject("sys_member_msg", msg);
            //return pdaoTemplate.getAutoIdForIntByMySql();
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public int addChatMsg(SysChatMsg scm) {
        /*try {
         *//*****用于更改id生成方式 by guojr******//*

            return this.pdaoTemplate.addByObject("sys_chat_msg", scm);
            //return pdaoTemplate.getAutoIdForIntByMySql();
        } catch (Exception e) {
            throw new DaoException(e);
        }*/
        //return HttpResponseUtils.convertResponse(chatMsgApi.add(BeanMapper.map(scm, SysChatMsgDTO.class)));
        return 1;
    }

    public int getIdentity() {
        try {
            return this.pdaoTemplate.getAutoIdForIntByMySql();
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @param pId
     * @param memId
     * @param id
     * @param tp
     * @return
     * @创建：作者:YYP 创建时间：2015-4-1
     * @see
     */
    public List queryLetterMsg(Integer pId, Integer memId,
                               Integer id, String tp, String datasource) {
        StringBuilder sql = new StringBuilder("SELECT cm.msg_id,cm.member_id,cm.addtime,cm.msg_tp,cm.msg,cm.voice_time,cm.longitude,cm.latitude");
        if ("1".equals(tp)) {//员工圈
            sql.append(",m.member_head,m.member_nm FROM " + datasource + ".bsc_empgroup_msg cm left join " + datasource + ".sys_mem m on cm.member_id=m.member_id where cm.group_id=").append(pId);
        } else if ("4".equals(tp)) {
            sql.append(" FROM sys_member_msg cm where (");
            sql.append("(cm.receive_id=").append(memId).append(" AND cm.member_id=").append(pId).append(") ");
            sql.append(" OR (cm.receive_id=").append(pId).append(" AND cm.member_id=").append(memId).append("))");
        }
        if (StrUtil.isNull(id) || 0 == id) {
            sql.append(" ORDER BY cm.addtime DESC LIMIT 0,20");
        } else {
            sql.append(" AND cm.msg_id < ").append(id).append(" ORDER BY cm.addtime DESC LIMIT 20");
        }
        try {
            List result = new ArrayList();
//            if ("1".equals(tp)) {
//                result = daoTemplate.queryForLists(sql.toString(), BscEmpGroupMsg.class);
//            } else if ("4".equals(tp)) {
//                result = pdaoTemplate.queryForLists(sql.toString(), SysMemberMsg.class);
//                if (Collections3.isNotEmpty(result)) {
//                    for (Object tmp : result) {
//                        SysMemberMsg memberMsg = (SysMemberMsg) tmp;
//                        if (MathUtils.valid(memberMsg.getMemberId())) {
//                            SysMemberDTO memberDTO = HttpResponseUtils.convertResponse(memberRequest.get(memberMsg.getMemberId()));
//                            if (memberDTO != null) {
//                                memberMsg.setMemberHead(memberDTO.getHead());
//                                memberMsg.setMemberNm(memberDTO.getName());
//                            }
//                        }
//                    }
//                }
//            }
            return result;
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }


    /**
     * 查询公共平台上的未读消息
     *
     * @param memId
     * @return
     * @创建：作者:YYP 创建时间：2015-2-15
     */
    public List<SysChatMsg> queryMsg(Integer memId) {
        List<SysChatMsg> list = new ArrayList<>();// new ArrayList<>();//HttpResponseUtils.convertResponseNull(chatMsgApi.queryByReceiveId(memId));
//        try {
//            List<SysChatMsg> msgs = Lists.newArrayList();
//            if (Collections3.isNotEmpty(list)) {
//                for (SysChatMsgDTO publicMsg : list) {
//                    SysChatMsg msg = BeanMapper.map(publicMsg, SysChatMsg.class);
//                    if (publicMsg.getMemberId() != null) {
//                        SysMemberDTO memberDTO = HttpResponseUtils.convertResponse(memberRequest.get(publicMsg.getMemberId()));
//                        if (memberDTO != null) {
//                            msg.setMemberHead(memberDTO.getHead());
//                            msg.setMemberNm(memberDTO.getName());
//                        }
//                    }
//                    msgs.add(msg);
//                }
//            }
//            return msgs;
        return list;
//        } catch (Exception e) {
//            throw new DaoException(e);
//        }
    }

    /**
     * 删除公共平台上未读
     *
     * @param memId
     * @创建：作者:YYP 创建时间：2015-2-15
     */
    public void deleteMsg(Integer memId) {
        String sql = "delete from sys_chat_msg where receive_id=" + memId;
        try {
            pdaoTemplate.update(sql);
        } catch (Exception e) {
            throw new DaoException(e);
        }
//        try {
//            chatMsgApi.removeByReceiveId(memId).execute().body();
//        } catch (Exception e) {
//            throw new DaoException(e);
//        }
    }


}
