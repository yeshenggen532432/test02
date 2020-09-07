package com.qweib.cloud.core.domain.dto;

import com.qweib.rule.generator.domain.dto.RuleUnitCandidateDTO;
import lombok.Data;

/**
 * Description: 规则引擎--单元候选文本
 *
 * @author zeng.gui
 * Created on 2019/6/10 - 11:56
 */
@Data
public class RuleUnitCandidateDetailDTO extends RuleUnitCandidateDTO {

    private String unitId;
}
