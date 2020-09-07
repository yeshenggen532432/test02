package com.qweib.cloud.biz.attendance.service;

import com.qweib.cloud.biz.attendance.dao.KqRuleDao;
import com.qweib.cloud.biz.attendance.model.KqRule;
import com.qweib.cloud.biz.attendance.model.KqRuleDetail;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.utils.Page;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.List;

@Service
public class KqRuleService {
    @Resource
    private KqRuleDao ruleDao;

    public int addRule(KqRule ruleRec, String database) {
        ruleRec.setStatus(1);
        List<KqRuleDetail> subList = ruleRec.getSubList();
        int ret = this.ruleDao.addRule(ruleRec, database);
        if (ret == 0) {
            return 0;
        }
        int seqNo = 1;
        for (KqRuleDetail sub : subList) {
            sub.setRuleId(ret);
            sub.setSeqNo(seqNo);
            seqNo++;
            if (this.ruleDao.addDetail(sub, database) == 0) {
                throw new ServiceException("保存失败");
            }
        }
        return ret;
    }

    public int updateRule(KqRule ruleRec, String database) {
        List<KqRuleDetail> subList = ruleRec.getSubList();
        int ret = this.ruleDao.updateRule(ruleRec, database);
        if (ret == 0) return 0;
        this.ruleDao.deleteDetail(ruleRec.getId(), database);
        int seqNo = 1;
        for (KqRuleDetail sub : subList) {
            sub.setRuleId(ruleRec.getId());
            sub.setSeqNo(seqNo);
            seqNo++;
            if (this.ruleDao.addDetail(sub, database) == 0) {
                throw new ServiceException("保存失败");
            }
        }
        return ret;
    }

    public Page queryKqRulePage(KqRule ruleRec, String database, Integer page, Integer limit) {
        Page p = this.ruleDao.queryKqRulePage(ruleRec, database, page, limit);
        List<KqRule> list = p.getRows();
        if (list.size() == 0) return p;
        String ids = "";
        for (KqRule rule : list) {
            if (ids.length() == 0) ids = rule.getId().toString();
            else ids = ids + "," + rule.getId().toString();
        }
        List<KqRuleDetail> subList = this.ruleDao.queryDetailList(ids, database);
        for (KqRule rule : list) {
            List<KqRuleDetail> subList1 = new ArrayList<KqRuleDetail>();
            for (KqRuleDetail sub : subList) {
                if (rule.getId().intValue() == sub.getRuleId().intValue()) {
                    if (sub.getBcId().intValue() == 0) sub.setBcName("休");
                    if (rule.getRuleUnit().intValue() == 1)//周
                    {
                        sub.setDayName(getWeekName(sub.getSeqNo()));
                    } else {
                        sub.setDayName(sub.getSeqNo().toString());
                    }
                    subList1.add(sub);
                }
            }
            rule.setSubList(subList1);

        }
        return p;
    }

    private String getWeekName(Integer seqNo) {
        String weekName = "";
        switch (seqNo) {
            case 1:
                weekName = "星期一";
                break;
            case 2:
                weekName = "星期二";
                break;
            case 3:
                weekName = "星期三";
                break;
            case 4:
                weekName = "星期四";
                break;
            case 5:
                weekName = "星期五";
                break;
            case 6:
                weekName = "星期六";
                break;
            case 7:
                weekName = "星期天";
                break;


        }
        return weekName;
    }

    public int updateRuleStatus(Integer id, Integer status, String database) {
        return this.ruleDao.updateRuleStatus(id, status, database);
    }

    public int deleteRule(Integer id, String database) {
        this.ruleDao.deleteDetail(id, database);
        this.ruleDao.deleteRule(id, database);
        return 1;
    }

    public KqRule getRuleById(Integer ruleId, String database) {
        KqRule rule = this.ruleDao.getRuleById(ruleId, database);
        if (rule == null) return null;
        List<KqRuleDetail> subList = this.ruleDao.queryDetailList(rule.getId().toString(), database);
        rule.setSubList(subList);
        return rule;
    }

}
