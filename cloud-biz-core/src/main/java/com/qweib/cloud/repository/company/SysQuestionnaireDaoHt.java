package com.qweib.cloud.repository.company;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.SysQuestionnaire;
import com.qweib.cloud.core.domain.SysQuestionnaireDetail;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.jdbc.core.BatchPreparedStatementSetter;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
public class SysQuestionnaireDaoHt {
    @Resource(name = "daoTemplate")
    private JdbcDaoTemplate daoTemplate;

    /**
     * 摘要：
     *
     * @说明：分页查询问卷信息
     * @创建：作者:llp 创建时间：2015-2-9
     * @修改历史： [序号](llp 2015 - 2 - 9)<修改说明>
     */
    public Page queryQuestionnaire(SysQuestionnaire questionnaire, String database, int page, int limit) {
        StringBuilder sql = new StringBuilder();
        sql.append(" select a.*,b.member_nm as memberNm,(case when d.branch_id is NULL then '公司本级' else d.branch_name end) as branchName from " + database + ".sys_questionnaire a left join  " + database + ".sys_mem b on b.member_id=a.member_id");
        sql.append(" LEFT JOIN " + database + ".sys_depart d ON a.branch_id=d.branch_id where 1=1");
        if (null != questionnaire) {
            if (!StrUtil.isNull(questionnaire.getTitle())) {
                sql.append(" and a.title like '%" + questionnaire.getTitle() + "%' ");
            }
        }
        sql.append(" order by a.qid desc ");
        try {
            return this.daoTemplate.queryForPageByMySql(sql.toString(), page, limit, SysQuestionnaire.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 摘要：
     *
     * @说明：添加问卷信息
     * @创建：作者:llp 创建时间：2015-2-9
     * @修改历史：
     */
    public int addQuestionnaire(SysQuestionnaire questionnaire, String database) {
        try {
            return this.daoTemplate.addByObject("" + database + ".sys_questionnaire", questionnaire);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 摘要：
     *
     * @说明：修改问卷信息
     * @创建：作者:llp 创建时间：2015-2-11
     * @修改历史：
     */
    public int updateQuestionnaire(SysQuestionnaire questionnaire, String database) {
        try {
            Map<String, Object> whereParam = new HashMap<String, Object>();
            whereParam.put("qid", questionnaire.getQid());
            return this.daoTemplate.updateByObject("" + database + ".sys_questionnaire", questionnaire, whereParam, "qid");
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 摘要：
     *
     * @说明：根据id获取问卷信息
     * @创建：作者:llp 创建时间：2015-2-9
     * @修改历史：
     */
    public SysQuestionnaire queryQuestionnaireById(Integer qid, String database) {
        try {
            String sql = "select q.*,(case when d.branch_id is NULL then '公司本级' else d.branch_name end) as branchName from " + database + ".sys_questionnaire q left join " + database + ".sys_depart d ON d.branch_id=q.branch_id where qid=? ";
            return this.daoTemplate.queryForObj(sql, SysQuestionnaire.class, qid);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 摘要：
     *
     * @说明：删除问卷信息
     * @创建：作者:llp 创建时间：2015-2-9
     * @修改历史：
     */
    public int deleteQuestionnaire(Integer qid, String database) {
        try {
            int[] i = this.daoTemplate.deletes("delete from " + database + ".sys_questionnaire where qid=?", qid);
            return i[0];
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 摘要：
     *
     * @说明：获取自增id
     * @创建：作者:llp 创建时间：2015-2-9
     * @修改历史： [序号](llp 2015 - 2 - 9)<修改说明>
     */
    public int queryAutoId() {
        try {
            return this.daoTemplate.getAutoIdForIntByMySql();
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }
    /////////////////////////////////////问卷对应的选项（方法）/////////////////////////////////////////

    /**
     * @说明：根据问卷ID查询对应的选项
     * @创建：作者:llp 创建时间：2015-2-9
     * @修改历史： [序号](llp 2015 - 2 - 9)<修改说明>
     */
    public List<SysQuestionnaireDetail> queryQuestionnaireDetail(Integer qid, String database) {
        String sql = " select a.* from " + database + ".sys_questionnaire_detail a join " + database + ".sys_questionnaire b on a.qid=b.qid where a.qid=?  ";
        try {
            return this.daoTemplate.queryForLists(sql, SysQuestionnaireDetail.class, qid);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @说明：添加问卷对应的选项
     * @创建：作者:llp 创建时间：2015-2-9
     * @修改历史： [序号](llp 2015 - 2 - 9)<修改说明>
     */
    public void addQuestionnaireDetaills(final List<SysQuestionnaireDetail> questionnaireDetaills, final String database) {
        String sql = " insert into " + database + ".sys_questionnaire_detail(qid,no,content) values(?,?,?) ";
        try {
            BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter() {
                public int getBatchSize() {
                    return questionnaireDetaills.size();
                }

                public void setValues(PreparedStatement arg0, int arg1) throws SQLException {
                    arg0.setInt(1, questionnaireDetaills.get(arg1).getQid());
                    arg0.setString(2, questionnaireDetaills.get(arg1).getNo());
                    arg0.setString(3, questionnaireDetaills.get(arg1).getContent());
                }
            };
            this.daoTemplate.batchUpdate(sql, setter);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @说明：删除问卷对应的选项
     * @创建：作者:llp 创建时间：2015-2-9
     * @修改历史： [序号](llp 2015 - 2 - 9)<修改说明>
     */
    public void deleteQuestionnaireDetailById(Integer qid, String database) {
        String sql = " delete from " + database + ".sys_questionnaire_detail where qid=? ";
        try {
            this.daoTemplate.update(sql, qid);
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
            sql.append(" select no,(select count(*) from " + database + ".sys_questionnaire_vote v1 where v1.option_id = detail.id) ratio");
            sql.append(" from " + database + ".sys_questionnaire_detail detail where detail.qid=?");
            return this.daoTemplate.queryForLists(sql.toString(), SysQuestionnaireDetail.class, qid);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }
}
