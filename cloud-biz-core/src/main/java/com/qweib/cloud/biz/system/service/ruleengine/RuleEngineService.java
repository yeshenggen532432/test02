package com.qweib.cloud.biz.system.service.ruleengine;

import com.qweib.cloud.core.domain.dto.RuleUnitCandidateDetailDTO;
import com.qweib.rule.generator.domain.dto.*;

import java.util.List;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2019/5/31 - 15:44
 */
public interface RuleEngineService {

    RuleGroupDetailDTO getGroup(String ruleFileKey);

    List<RuleSourceDTO> querySource(String groupId);

    List<RuleLogicSourceDTO> queryLogicSource(String groupId);

    List<RuleDslDTO> queryDsl(String groupId);

    List<RuleUnitDetailDTO> queryUnit(String groupId);

    List<RuleUnitPairDTO> queryUnitPair(String groupId);

    List<RuleUnitCandidateDetailDTO> queryUnitCandidate(String groupId);

    List<RuleDslUnitDTO> queryDslUnit(String dslId);
}
