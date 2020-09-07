package com.qweib.cloud.biz.system.service.ruleengine;

import com.qweib.cloud.core.domain.dto.RuleUnitCandidateDetailDTO;
import com.qweib.cloud.repository.company.RuleEngineDao;
import com.qweib.rule.generator.domain.dto.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2019/5/31 - 15:55
 */
@Service
public class RuleEngineServiceImpl implements RuleEngineService {

    @Autowired
    private RuleEngineDao engineDao;

    @Override
    public RuleGroupDetailDTO getGroup(String ruleFileKey) {
        return this.engineDao.getGroup(ruleFileKey);
    }

    @Override
    public List<RuleSourceDTO> querySource(String groupId) {
        return this.engineDao.querySource(groupId);
    }

    @Override
    public List<RuleLogicSourceDTO> queryLogicSource(String groupId) {
        return this.engineDao.queryLogicSource(groupId);
    }

    @Override
    public List<RuleDslDTO> queryDsl(String groupId) {
        return this.engineDao.queryDsl(groupId);
    }

    @Override
    public List<RuleUnitDetailDTO> queryUnit(String groupId) {
        return this.engineDao.queryUnit(groupId);
    }

    @Override
    public List<RuleUnitPairDTO> queryUnitPair(String groupId) {
        return this.engineDao.queryUnitPair(groupId);
    }

    @Override
    public List<RuleUnitCandidateDetailDTO> queryUnitCandidate(String groupId) {
        return this.engineDao.queryUnitCandidate(groupId);
    }

    @Override
    public List<RuleDslUnitDTO> queryDslUnit(String dslId) {
        return this.engineDao.queryDslUnit(dslId);
    }
}
