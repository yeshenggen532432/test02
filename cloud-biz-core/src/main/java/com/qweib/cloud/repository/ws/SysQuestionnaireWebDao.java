package com.qweib.cloud.repository.ws;


import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.SysQuestionnaire;
import com.qweib.cloud.core.domain.SysQuestionnaireDetail;
import com.qweib.cloud.core.domain.SysQuestionnaireVote;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.Page;
import org.springframework.jdbc.core.BatchPreparedStatementSetter;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

@Repository
public class SysQuestionnaireWebDao {
    @Resource(name = "daoTemplate")
    private JdbcDaoTemplate daoTemplate;

    /**
     * 查询最新问卷
     *
     * @param database
     * @param memId
     * @return
     */
    public SysQuestionnaire queryNewQuestionnaire(String database) {
        String sql = "select * from " + database + ".sys_questionnaire where NOW()<etime order by qid desc limit 0,1";
        try {
            return this.daoTemplate.queryForObj(sql, SysQuestionnaire.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 查询最新问卷
     *
     * @param database
     * @param memId
     * @return
     */
    public List<SysQuestionnaireDetail> queryByQuestId(Integer mid, Integer qid, String database) {
        String sql = "select *,(select count(*) from " + database + ".sys_questionnaire_vote vote where vote.option_id = detail.id and vote.member_id = " + mid + " ) is_check from " + database + ".sys_questionnaire_detail detail where qid = ? order by no asc";
        try {
            return this.daoTemplate.queryForLists(sql, SysQuestionnaireDetail.class, qid);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 根据用户ID 以及问卷ID 获取已选择答案
     *
     * @param database
     * @param memId
     * @return
     */
    public Map<String, Object> queryByVoteId(Integer qid, Integer memId, String database) {
        String sql = "select group_concat(detail.`no`) ops from " + database + ".sys_questionnaire_vote vote" +
                " join sys_questionnaire_detail detail on vote.option_id = detail.id" +
                " where problem_id =" + qid + " and member_id = " + memId;
        try {
            return this.daoTemplate.queryForMap(sql);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 批量添加答案成功
     *
     * @param database
     * @param vote
     * @return
     */
    public int[] addVote(String database, final List<SysQuestionnaireVote> vote) {
        String sql = "insert into " + database + ".sys_questionnaire_vote(option_id,member_id,problem_id,add_time) values (?,?,?,?)";
        try {
            BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter() {

                @Override
                public void setValues(PreparedStatement pre, int num) throws SQLException {
                    pre.setInt(1, vote.get(num).getOptionId());
                    pre.setInt(2, vote.get(num).getMemberId());
                    pre.setInt(3, vote.get(num).getProblemId());
                    pre.setString(4, vote.get(num).getAddTime());
                }

                @Override
                public int getBatchSize() {
                    return vote.size();
                }
            };
            return this.daoTemplate.batchUpdate(sql.toUpperCase(), setter);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 根据问卷ID获取比率
     *
     * @param database
     * @param vote
     * @return
     */
    public List<SysQuestionnaireDetail> queryByRatio(Integer qid, String database) {
        try {
            StringBuffer sql = new StringBuffer();
            sql.append(" select no,content,ROUND(((select count(*) from " + database + ".sys_questionnaire_vote v1 where v1.option_id = detail.id)/");
            sql.append(" (select count(*) from " + database + ".sys_questionnaire_vote v2 where v2.problem_id = detail.qid))*100,1) ratio");
            sql.append(" from " + database + ".sys_questionnaire_detail detail where detail.qid=?");
            return this.daoTemplate.queryForLists(sql.toString(), SysQuestionnaireDetail.class, qid);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 分页查询问卷
     *
     * @param database
     * @param memId
     * @return
     */
    public Page queryAllPage(Integer pageNo, Integer pageSize, String database, Integer branchId, Integer memId) {
        try {
            StringBuffer sql = new StringBuffer(" select a.* from " + database + ".sys_questionnaire a where  a.branch_id in(" + branchId + ",0) ");
            sql.append(" and DATE_FORMAT(a.etime,'%Y-%m-%d') >= DATE_FORMAT(NOW(),'%Y-%m-%d') ");
            sql.append(" and a.qid not in(select distinct qv.problem_id from " + database + ".sys_questionnaire_vote qv left join " + database + ".sys_questionnaire q on qv.problem_id=q.qid ");
            sql.append(" where qv.member_id=" + memId + " and (q.branch_id=" + branchId + " or branch_id=0) and DATE_FORMAT(q.etime,'%Y-%m-%d') >= DATE_FORMAT(NOW(),'%Y-%m-%d')) ");
            sql.append(" order by a.qid asc ");
            return daoTemplate.queryForPageByMySql(sql.toString(), pageNo, pageSize, SysQuestionnaire.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 根据问卷ID删除已选的选项
     *
     * @param database
     * @param problemId
     */
    public void deleteByQid(String database, Integer problemId, Integer mid) {
        try {
            String sql = "delete from " + database + ".sys_questionnaire_vote where member_id = ? and problem_id =? ";
            this.daoTemplate.update(sql, mid, problemId);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 根据用户删除选项ID
     *
     * @param database
     * @param problemId
     * @param memId
     * @param id
     */
    public void deleteById(String database, Integer problemId, Integer memId,
                           Integer uid) {
        try {
            String sql = "delete from " + database + ".sys_questionnaire_vote where member_id = ? and problem_id =? and option_id=?";
            this.daoTemplate.update(sql, memId, problemId, uid);
        } catch (Exception e) {
            throw new DaoException(e);
        }

    }

    public Map<String, Object> queryCheckAll(String database, Integer memId, Integer problemId) {
        try {
            String sql = "select GROUP_CONCAT(no) no from " + database + ".sys_questionnaire_vote vote join " + database + ".sys_questionnaire_detail detail on detail.id = vote.option_id where  problem_id=? and member_id=? order by no asc";
            return this.daoTemplate.queryForMap(sql, problemId, memId);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    //查询是否全部投过票
    public List<Map<String, Object>> queryCountByMemId(Integer memId, Integer branchId, String datasource) {
        StringBuffer sql = new StringBuffer("select (case when ((select count(*) from " + datasource + ".sys_questionnaire a where (a.branch_id=" + branchId);
        sql.append(" or branch_id=0) and DATE_FORMAT(a.etime,'%Y-%m-%d %H:%i') >= DATE_FORMAT(NOW(),'%Y-%m-%d %H:%i') ");
        sql.append(" )>(select count(*) from (select distinct q.qid from " + datasource + ".sys_questionnaire_vote qv left join " + datasource + ".sys_questionnaire q on qv.problem_id=q.qid where qv.member_id=" + memId);
        sql.append(" and (q.branch_id=" + branchId + " or q.branch_id=0) and DATE_FORMAT(q.etime,'%Y-%m-%d %H:%i') >= DATE_FORMAT(NOW(),'%Y-%m-%d %H:%i') ");
        sql.append(") t)) then 1 else 0 end) as count,(select count(*) from " + datasource + ".sys_questionnaire a where (a.branch_id=" + branchId + " or a.branch_id=0) and DATE_FORMAT(a.etime,'%Y-%m-%d %H:%i') >= DATE_FORMAT(NOW(),'%Y-%m-%d %H:%i')) as tmcount");
        try {
            return daoTemplate.queryForList(sql.toString());
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 查询结果列表页面
     */
    public Page queryResultPage(Integer pageNo, Integer pageSize,
                                String database, Integer branchId, Integer memId) {
        StringBuffer sql = new StringBuffer("select distinct q.qid,q.member_id,q.title,q.content from " + database + ".sys_questionnaire q ");
        sql.append(" left join " + database + ".sys_questionnaire_vote qv on q.qid=qv.problem_id where (q.branch_id=" + branchId);
        sql.append(" or q.branch_id=0) and qv.member_id=" + memId);
        try {
            return daoTemplate.queryForPageByMySql(sql.toString(), pageNo, pageSize, SysQuestionnaire.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }
}
