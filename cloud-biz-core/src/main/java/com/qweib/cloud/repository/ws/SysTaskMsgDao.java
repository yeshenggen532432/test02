package com.qweib.cloud.repository.ws;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.SysTaskMsg;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.jdbc.core.BatchPreparedStatementSetter;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.List;

@Repository
public class SysTaskMsgDao {
    @Resource(name = "daoTemplate")
    private JdbcDaoTemplate daoTemplate;

    /**
     * 说明：添加催办消息
     *
     * @创建：作者:llp 创建时间：2015-2-5
     * @修改历史： [序号](llp 2015 - 2 - 5)<修改说明>
     */
    public int addSysTaskMsg(SysTaskMsg taskMsg, String database) {
        try {
            return this.daoTemplate.addByObject("" + database + ".sys_task_msg", taskMsg);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public int getAotoId() {
        try {
            return this.daoTemplate.getAutoIdForIntByMySql();
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：根据手机号查被邀请信息
     *
     * @创建：作者:llp 创建时间：2015-2-5
     * @修改历史： [序号](llp 2015 - 2 - 5)<修改说明>
     */
    public SysTaskMsg queryTaskMsgByTel(String tel, String database) {
        try {
            String sql = "select * from " + database + ".sys_task_msg where recieve_mobile=? ";
            return this.daoTemplate.queryForObj(sql, SysTaskMsg.class, tel);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @param tMsgs
     * @param database
     * @创建：作者:YYP 创建时间：2015-2-6
     * @see 批量添加消息表
     */
    public int[] addTaskMsgs(final List<SysTaskMsg> tMsgs, String database) {
        String sql = " insert into sys_task_msg(mem_id,psn_id,recieve_mobile,tp,content,remind_time) values(?,?,?,?,?,?) ";
        try {
            BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter() {
                public int getBatchSize() {
                    return tMsgs.size();
                }

                public void setValues(PreparedStatement pre, int num)
                        throws SQLException {
                    pre.setInt(1, tMsgs.get(num).getMemId());
                    pre.setInt(2, tMsgs.get(num).getPsnId());
                    if (!StrUtil.isNull(tMsgs.get(num).getRecieveMobile())) {
                        pre.setString(3, tMsgs.get(num).getRecieveMobile());
                    } else {
                        pre.setString(3, null);
                    }
                    pre.setString(4, tMsgs.get(num).getTp());
                    pre.setString(5, tMsgs.get(num).getContent());
                    pre.setString(6, tMsgs.get(num).getRemindTime());
                }
            };
            return daoTemplate.batchUpdate(sql.toUpperCase(), setter);
        } catch (Exception ex) {
            ex.printStackTrace();
            throw new DaoException(ex);
        }
    }
}
