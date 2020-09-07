package com.qweib.cloud.repository.ws;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.BscDeptMsg;
import com.qweib.cloud.core.domain.BscTrueMsg;
import com.qweib.cloud.core.domain.SysChatMsg;
import com.qweib.cloud.core.exception.DaoException;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.List;

@Repository
public class BscMsgWebDao {
    @Resource(name = "daoTemplate")
    private JdbcDaoTemplate daoTemplate;


    /**
     * @param memId
     * @param database
     * @return
     * @创建：作者:YYP 创建时间：2015-2-15
     * @see 查询企业平台上的未读消息
     */
    public List<SysChatMsg> queryChatMsg(Integer memId, String database) {
        StringBuffer sql = new StringBuffer(" select cm.id,m.member_id,m.member_head,m.member_nm,cm.msg_id,cm.addtime,cm.msg_tp,cm.msg,cm.voice_time,cm.longitude,cm.latitude,cm.tp,cm.belong_id,cm.belong_nm,cm.belong_msg from ");
        sql.append(database).append(".sys_chat_msg cm left join ");
        sql.append(database).append(".sys_mem m on cm.member_id=m.member_id where cm.tp!='41-1' and cm.tp!='42-1' and cm.receive_id=").append(memId);
        sql.append(" order by cm.addtime desc ");
        try {
            return daoTemplate.queryForLists(sql.toString(), SysChatMsg.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public List<SysChatMsg> queryChatMsg2(Integer memId, String database) {
        StringBuffer sql = new StringBuffer(" select cm.id,m.member_id,m.member_head,m.member_nm,cm.msg_id,cm.addtime,cm.msg_tp,cm.msg,cm.voice_time,cm.longitude,cm.latitude,cm.tp,cm.belong_id,cm.belong_nm,cm.belong_msg,cm.receive_id from ");
        sql.append(database).append(".sys_chat_msg cm left join ");
        sql.append(database).append(".sys_mem m on cm.member_id=m.member_id where (cm.tp='41-1' or cm.tp='42-1') and cm.receive_id=").append(memId);
        sql.append(" order by cm.addtime desc ");
        try {
            return daoTemplate.queryForLists(sql.toString(), SysChatMsg.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

//    public SysChatMsg queryChatMsgByMRB(Integer memberId, Integer receiveId, Integer belongId, String database) {
//        String sql = "select * from " + database + ".sys_chat_msg where member_id=? and receive_id=? and belong_id=? and tp='42-1'";
//        try {
//            return this.daoTemplate.queryForObj(sql, SysChatMsg.class, memberId, receiveId, belongId);
//        } catch (Exception e) {
//            throw new DaoException(e);
//        }
//    }

    public SysChatMsg queryChatMsgByMsgId(Integer msgId, String database) {
        String sql = "select * from " + database + ".sys_chat_msg where msg_id=? and tp='42-1'";
        try {
            return this.daoTemplate.queryForObj(sql, SysChatMsg.class, msgId);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @param memId
     * @param database
     * @创建：作者:YYP 创建时间：2015-2-15
     * @see 删除企业平台上未读
     */
    public void deleteChatMsg(Integer memId, String database) {
        StringBuffer sql = new StringBuffer("delete from ").append(database).append(".sys_chat_msg where tp!='41-1' and tp!='42-1' and receive_id=").append(memId);
        try {
            daoTemplate.update(sql.toString());
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @param deptMsg
     * @param database
     * @return
     * @创建：作者:YYP 创建时间：2015-3-10
     * @see 添加部门消息
     */
    public int addDeptMsg(BscDeptMsg deptMsg, String database) {
        try {
            /*****用于更改id生成方式 by guojr******/
            return daoTemplate.addByObject(database + ".bsc_dept_msg", deptMsg);
            //return daoTemplate.getAutoIdForIntByMySql();
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }


    /**
     * @param trueMsg
     * @param database
     * @return
     * @创建：作者:YYP 创建时间：2015-3-17
     * @see 添加真心话聊天信息
     */
    public int addTrueMsg(BscTrueMsg trueMsg, String database) {
        try {
            /*****用于更改id生成方式 by guojr******/
            return daoTemplate.addByObject(database + ".bsc_true_msg", trueMsg);
            //return daoTemplate.getAutoIdForIntByMySql();
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @param pId
     * @param id
     * @param database
     * @return
     * @创建：作者:YYP 创建时间：2015-3-17
     * @see 查询聊天记录
     */
    public List queryNextMsg(Integer pId, Integer msgId, String tp,
                             String database) {
        StringBuffer sql = new StringBuffer(" select em.msg_id,m.member_id,m.member_head,m.member_nm,em.addtime,em.msg_tp,em.msg,em.voice_time,em.longitude,em.latitude from ").append(database);
        if ("2".equals(tp)) {
            sql.append(".bsc_dept_msg em left join ").append(database).append(".sys_mem m on em.member_id=m.member_id where em.dept_id=").append(pId);
        } else if ("3".equals(tp)) {
            sql.append(".bsc_true_msg em left join ").append(database).append(".sys_mem m on em.member_id=m.member_id where 1=1 ");
        }
        if (null == msgId || 0 == msgId) {
            sql.append(" order by em.addtime desc limit 0,20 ");
        } else {
            sql.append(" and em.msg_id<").append(msgId);
            ;
            sql.append(" order by em.addtime desc limit 20 ");
        }
        try {
            List result = new ArrayList();
            if ("2".equals(tp)) {
                result = daoTemplate.queryForLists(sql.toString(), BscDeptMsg.class);
            } else if ("3".equals(tp)) {
                result = daoTemplate.queryForLists(sql.toString(), BscTrueMsg.class);
            }
            return result;
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }


}
