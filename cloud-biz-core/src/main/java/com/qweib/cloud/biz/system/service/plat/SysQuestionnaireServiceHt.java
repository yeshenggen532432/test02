package com.qweib.cloud.biz.system.service.plat;


import com.qweib.cloud.core.domain.SysQuestionnaire;
import com.qweib.cloud.core.domain.SysQuestionnaireDetail;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.repository.company.SysQuestionnaireDaoHt;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service
public class SysQuestionnaireServiceHt {
    @Resource
    private SysQuestionnaireDaoHt questionnaireDao;

    /**
     * 摘要：
     *
     * @说明：分页查询问卷信息
     * @创建：作者:llp 创建时间：2015-2-9
     * @修改历史： [序号](llp 2015 - 2 - 9)<修改说明>
     */
    public Page queryQuestionnaire(SysQuestionnaire questionnaire, String database, int page, int limit) {
        try {
            return this.questionnaireDao.queryQuestionnaire(questionnaire, database, page, limit);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 摘要：
     *
     * @说明：添加问卷信息
     * @创建：作者:llp 创建时间：2015-2-9
     * @修改历史：
     */
    public void addQuestionnaire(SysQuestionnaire questionnaire, String database, List<SysQuestionnaireDetail> details) {
        try {
            //添加问卷信息
            this.questionnaireDao.addQuestionnaire(questionnaire, database);
            int qid = this.questionnaireDao.queryAutoId();
            for (SysQuestionnaireDetail detail : details) {
                detail.setQid(qid);
            }
            //添加问卷信息对应的选项
            if (details.size() > 0) {
                if (!StrUtil.isNull(details.get(0).getNo())) {
                    this.questionnaireDao.addQuestionnaireDetaills(details, database);
                }
            }
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 摘要：
     *
     * @说明：修改问卷信息
     * @创建：作者:llp 创建时间：2015-2-11
     * @修改历史：
     */
    public void updateQuestionnaire(SysQuestionnaire questionnaire, String database, List<SysQuestionnaireDetail> details) {
        try {
            //修改问卷信息
            this.questionnaireDao.updateQuestionnaire(questionnaire, database);
            //删除问卷对应的选项
            this.questionnaireDao.deleteQuestionnaireDetailById(questionnaire.getQid(), database);
            for (SysQuestionnaireDetail detail : details) {
                detail.setQid(questionnaire.getQid());
            }
            //添加问卷对应的选项
            if (details.size() > 0) {
                if (!StrUtil.isNull(details.get(0).getNo())) {
                    this.questionnaireDao.addQuestionnaireDetaills(details, database);
                }
            }
        } catch (Exception e) {
            throw new ServiceException(e);
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
            return this.questionnaireDao.queryQuestionnaireById(qid, database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 摘要：
     *
     * @说明：删除问卷信息
     * @创建：作者:llp 创建时间：2015-2-9
     * @修改历史：
     */
    public void deleteQuestionnaire(Integer qid, String database) {
        try {
            //删除问卷信息对应的选项
            this.questionnaireDao.deleteQuestionnaireDetailById(qid, database);
            //添加问卷信息
            this.questionnaireDao.deleteQuestionnaire(qid, database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * @说明：根据问卷ID查询对应的选项
     * @创建：作者:llp 创建时间：2015-2-9
     * @修改历史： [序号](llp 2015 - 2 - 9)<修改说明>
     */
    public List<SysQuestionnaireDetail> queryQuestionnaireDetail(Integer qid, String database) {
        try {
            return this.questionnaireDao.queryQuestionnaireDetail(qid, database);
        } catch (Exception e) {
            throw new ServiceException(e);
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
            return this.questionnaireDao.queryByRatio(qid, database);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }
}
