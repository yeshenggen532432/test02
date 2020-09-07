package com.qweib.cloud.repository.ws;


import com.google.common.collect.Lists;
import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.dao.JdbcDaoTemplatePlud;
import com.qweib.cloud.core.domain.BscEmpGroupMsg;
import com.qweib.cloud.core.domain.SysChatMsg;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.repository.utils.HttpResponseUtils;
import com.qweib.cloud.service.member.domain.msg.SysChatMsgDTO;
import com.qweib.cloud.service.member.retrofit.SysChatMsgRetrofitApi;
import com.qweib.commons.Collections3;
import com.qweib.commons.StringUtils;
import com.qweib.commons.mapper.BeanMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BatchPreparedStatementSetter;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.List;

/**
 * @说明：系统聊天webDao
 * @创建者： 作者：YJP 创建时间：2014-5-6
 */
@Repository
public class SysChatMsgDao {

    @Resource(name = "daoTemplate")
    private JdbcDaoTemplate daoTemplate;

    @Resource(name = "pdaoTemplate")
    private JdbcDaoTemplatePlud pdaoTemplate;
//    @Autowired
//    private SysChatMsgRetrofitApi api;

    /**
     * @param scm 保存
     * @return int
     * @说明：保存系统聊天信息
     */
    public int addChatMsg(SysChatMsg scm, String datasource) {
        try {
            if (StringUtils.isBlank(datasource)) {
                return 0;
                //return HttpResponseUtils.convertResponse(api.add(BeanMapper.map(scm, SysChatMsgDTO.class)));
            } else {
                return this.daoTemplate.addByObject("" + datasource + ".sys_chat_msg", scm);
            }
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }


    //批量添加未读消息
    public int[] addBatchMsg(final List<SysChatMsg> scms, String datasource) {
        String sql = "insert into " + datasource + ".sys_chat_msg(member_id,receive_id,addtime,msg_tp,msg,voice_time,tp,belong_id,belong_nm,belong_msg,msg_id,longitude,latitude) values(?,?,?,?,?,?,?,?,?,?,?,?,?)";
        try {
            BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter() {
                public int getBatchSize() {
                    return scms.size();
                }

                public void setValues(PreparedStatement pre, int num)
                        throws SQLException {
                    pre.setObject(1, scms.get(num).getMemberId() == null ? null : scms.get(num).getMemberId());
                    pre.setInt(2, scms.get(num).getReceiveId());
                    pre.setString(3, scms.get(num).getAddtime());
                    pre.setString(4, scms.get(num).getMsgTp() == null ? null : scms.get(num).getMsgTp());
                    pre.setString(5, scms.get(num).getMsg() == null ? null : scms.get(num).getMsg());
                    Integer voiceTime = scms.get(num).getVoiceTime() == null ? null : scms.get(num).getVoiceTime();
                    pre.setObject(6, voiceTime);
                    pre.setString(7, scms.get(num).getTp() == null ? null : scms.get(num).getTp());
                    pre.setObject(8, scms.get(num).getBelongId() == null ? null : scms.get(num).getBelongId());
                    pre.setString(9, scms.get(num).getBelongNm() == null ? null : scms.get(num).getBelongNm());
                    pre.setString(10, scms.get(num).getBelongMsg() == null ? null : scms.get(num).getBelongMsg());
                    pre.setObject(11, scms.get(num).getMsgId() == null ? null : scms.get(num).getMsgId());
                    pre.setObject(12, scms.get(num).getLongitude() == null ? null : scms.get(num).getLongitude());
                    pre.setObject(13, scms.get(num).getLatitude() == null ? null : scms.get(num).getLatitude());
                }
            };
            return daoTemplate.batchUpdate(sql.toUpperCase(), setter);
        } catch (Exception ex) {
            throw new DaoException(ex);
        }
    }

    //批量添加未读消息
    public int[] addBatchpublicMsg(final List<SysChatMsg> scms) {
        /*String sql = "insert into sys_chat_msg(member_id,receive_id,addtime,msg_tp,msg,voice_time,tp,belong_id,belong_nm,belong_msg,msg_id,longitude,latitude) values(?,?,?,?,?,?,?,?,?,?,?,?,?)";
        try {
            BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter() {
                public int getBatchSize() {
                    return scms.size();
                }

                public void setValues(PreparedStatement pre, int num)
                        throws SQLException {
                    pre.setObject(1, scms.get(num).getMemberId() == null ? null : scms.get(num).getMemberId());
                    pre.setInt(2, scms.get(num).getReceiveId());
                    pre.setString(3, scms.get(num).getAddtime());
                    pre.setString(4, scms.get(num).getMsgTp() == null ? null : scms.get(num).getMsgTp());
                    pre.setString(5, scms.get(num).getMsg() == null ? null : scms.get(num).getMsg());
                    Integer voiceTime = scms.get(num).getVoiceTime() == null ? null : scms.get(num).getVoiceTime();
                    pre.setObject(6, voiceTime);
                    pre.setString(7, scms.get(num).getTp() == null ? null : scms.get(num).getTp());
                    pre.setObject(8, scms.get(num).getBelongId() == null ? null : scms.get(num).getBelongId());
                    pre.setString(9, scms.get(num).getBelongNm() == null ? null : scms.get(num).getBelongNm());
                    pre.setString(10, scms.get(num).getBelongMsg() == null ? null : scms.get(num).getBelongMsg());
                    pre.setObject(11, scms.get(num).getMsgId() == null ? null : scms.get(num).getMsgId());
                    pre.setObject(12, scms.get(num).getLongitude() == null ? null : scms.get(num).getLongitude());
                    pre.setObject(13, scms.get(num).getLatitude() == null ? null : scms.get(num).getLatitude());
                }
            };
            return pdaoTemplate.batchUpdate(sql.toUpperCase(), setter);
        } catch (Exception ex) {
            throw new DaoException(ex);
        }*/
        List<Integer> ids = Lists.newArrayList();
//        if (Collections3.isNotEmpty(scms)) {
//            for (SysChatMsg scm : scms) {
//                Integer id = HttpResponseUtils.convertResponse(api.add(BeanMapper.map(scm, SysChatMsgDTO.class)));
//                ids.add(id);
//            }
//        }
        return ids.stream().mapToInt(Integer::intValue).toArray();
    }

    /**
     * @param //scm 保存
     * @return int
     * @说明：删除系统聊天信息
     */
    public int deleteChatMsg(Integer msgId, String datasource) {
        try {
            StringBuffer sql = new StringBuffer("delete from " + datasource + ".sys_chat_msg where msg_id = ").append(msgId);
            return this.daoTemplate.update(sql.toString());
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @param memberId    成员ID
     * @param receiveId   发送人ID
     * @param receiveSide 接收方ID
     * @return 消息集合
     * @说明： 得到发给自己的信息
     */
    public List<SysChatMsg> getMyMessage(Integer receiveId, Integer memberId, Integer receiveSide, Integer isReady, String datasource) {
        try {
            StringBuffer sql = new StringBuffer("select s.* from " + datasource + ".sys_chat_msg s where  s.receive_id = ").append(receiveId);
            if (memberId != null) {
                sql.append(" and s.member_id = ").append(memberId);
            }
            if (receiveSide != null) {
                sql.append(" and s.receive_side =").append(receiveSide);
            }
            if (isReady != null) {
                sql.append(" and s.is_ready =  ").append(isReady);
            }
            //sql.append(" and s.msg_type <> 3 ");
            sql.append(" order by s.msg_id  for update");
            //sql.append(" limit 0,200 ");
            return this.daoTemplate.queryForLists(sql.toString(), SysChatMsg.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @param msgId 消息ID
     * @return 消息
     * @说明： 根据msgID 提取消息
     */
    public SysChatMsg getMyMessageByMsgId(Integer msgId, String datasource) {
        try {
            StringBuffer sql = new StringBuffer("select s.* from " + datasource + ".sys_chat_msg s where s.msg_id = ").append(msgId);
            return this.daoTemplate.queryForObj(sql.toString(), SysChatMsg.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @param //msgId 消息ID
     * @return 消息
     * @说明： 根据ID 提取消息
     */
    public SysChatMsg getMyMessageById(Integer Id, String datasource) {
        try {
            StringBuffer sql = new StringBuffer("select * from " + datasource + ".sys_chat_msg  where id = ").append(Id);
            return this.daoTemplate.queryForObj(sql.toString(), SysChatMsg.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @param //memberId 成员ID
     * @return 消息集合
     * @说明： 删除发给自己的信息
     */
    public int deltesMsg(List<Integer> msgId, String datasource) {
        try {
            int result = 0;
            StringBuffer str = new StringBuffer();
            for (int i = 0; i < msgId.size(); i++) {
                if (i != msgId.size() - 1) {
                    str.append(msgId.get(i) + ",");
                } else {
                    str.append(msgId.get(i));
                }
            }
            StringBuffer sql = new StringBuffer("delete from " + datasource + ".sys_chat_msg  where msg_id in (").append(str.toString() + ")");
            result = this.daoTemplate.update(sql.toString());
            return result;
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @param //memberId 成员ID
     * @return 消息集合
     * @说明：修改读取状态
     */
    public int updateReadMsg(List<Integer> msgId, String datasource) {
        try {
            int result = 0;
//			StringBuffer str = new StringBuffer();
            for (int i = 0; i < msgId.size(); i++) {
                StringBuffer sql = new StringBuffer("update " + datasource + ".sys_chat_msg s set s.is_ready = 1 where  msg_id = ").append(msgId.get(i));
                result = this.daoTemplate.update(sql.toString());

            }
//			StringBuffer sql = new StringBuffer("update sys_chat_msg s set s.is_ready = 1 where  msg_id in (").append(str+")");
//			result= this.daoTemplate.update(sql.toString());
            return result;
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @param memberId 成员ID
     * @return 消息集合
     * @说明： 删除发给自己的新闻信息
     * @创建者： 作者：YJP 创建时间：2014-5-22
     */
    public int deltesNewMsg(Integer memberId, String datasource) {
        try {
            StringBuffer sql = new StringBuffer("delete from " + datasource + ".sys_chat_msg  where msg_type = 3 and msg_tp = 4 and receive_id = ").append(memberId);
            return this.daoTemplate.update(sql.toString());
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @param //memberId 成员ID
     * @return 消息集合
     * @说明： 得到自增长ID
     * @创建者： 作者：YJP 创建时间：2014-5-22
     */
    public int getIdentity() {
        try {
            return this.daoTemplate.getAutoIdForIntByMySql();
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 摘要：删除当前用户所有未读聊天记录
     *
     * @param @param receiveId
     * @param @param memberId
     * @param @param isReady
     * @说明：
     * @创建：作者:YYP 创建时间：2014-8-22
     * @修改历史： [序号](YYP 2014 - 8 - 22)<修改说明>
     */
    public void deltesMsgByMem(Integer receiveId, Integer memberId, Integer isReady, String datasource) {
        StringBuffer sql = new StringBuffer("delete * from " + datasource + ".sys_chat_msg s where  s.receive_id = ").append(receiveId);
        if (memberId != null) {
            sql.append(" and s.member_id = ").append(memberId);
        }
        if (isReady != null) {
            sql.append(" and s.is_ready =  ").append(isReady);
        }
        try {
            this.daoTemplate.update(sql.toString());
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    // 删除发给自己的信息
    public int deltesMsgNotIn(List<Integer> msgId, String datasource) {
        try {
            int result = 0;
            StringBuffer str = new StringBuffer();
            for (int i = 0; i < msgId.size(); i++) {
                if (i != msgId.size() - 1) {
                    str.append(msgId.get(i) + ",");
                } else {
                    str.append(msgId.get(i));
                }
            }
            StringBuffer sql = new StringBuffer("delete * from " + datasource + ".sys_chat_msg  where msg_id not in (").append(str.toString() + ")");
            result = this.daoTemplate.update(sql.toString());
            return result;
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public int addGroupMsg(BscEmpGroupMsg empMsg, String datasource) {
        try {
            /*****用于更改id生成方式 by guojr******/
            return daoTemplate.addByObject(datasource + ".bsc_empgroup_msg", empMsg);
            //return daoTemplate.getAutoIdForIntByMySql();
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @param tp
     * @param topicId
     * @param datasource
     * @创建：作者:YYP 创建时间：2015-5-19
     * @see //删除帖子时对应的未读消息
     */
    public void deleteMsg(String tp, Integer topicId, String datasource) {
        StringBuffer sql = new StringBuffer("delete from " + datasource + ".sys_chat_msg where (tp=1 or tp=2 or tp=3) and belong_id=" + topicId);
        try {
            daoTemplate.update(sql.toString());
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @创建：作者:llp 创建时间：2016-8-23
     * @see //获取tp=32信息数
     */
    public int queryMsgJhCount(String database, String pdate) {
        try {
            StringBuilder sql = new StringBuilder();
            sql.append(" select count(1) as counts from " + database + ".sys_chat_msg where tp=32 and addtime like '" + pdate + "%'");
            return this.daoTemplate.queryForObject(sql.toString(), Integer.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @param
     * @return 消息
     * @说明： 判断信息有没有存在
     */
    public SysChatMsg getMyMessageByBUid2(Integer memberId, Integer receiveId, Integer belongId, String datasource) {
        try {
            StringBuffer sql = new StringBuffer("select * from " + datasource + ".sys_chat_msg  where member_id =" + memberId + " and receive_id=" + receiveId + " and belong_id=" + belongId + " and tp='41-1'");
            return this.daoTemplate.queryForObj(sql.toString(), SysChatMsg.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public SysChatMsg getMyMessageByBUid(Integer receiveId, Integer belongId, String datasource) {
        try {
            StringBuffer sql = new StringBuffer("select * from " + datasource + ".sys_chat_msg  where receive_id =" + receiveId + " and  belong_id=" + belongId + " and tp='42-1'");
            return this.daoTemplate.queryForObj(sql.toString(), SysChatMsg.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }
}
