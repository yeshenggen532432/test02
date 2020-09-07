package com.qweib.cloud.repository.company;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.dto.RuleUnitCandidateDetailDTO;
import com.qweib.rule.generator.domain.common.RuleGroupType;
import com.qweib.rule.generator.domain.dto.*;
import com.qweibframework.commons.Collections3;
import com.qweibframework.commons.domain.DelFlagEnum;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2019/5/31 - 15:56
 */
@Repository
public class RuleEngineDao extends BaseDao {

    private static final String DB_NAME = "qweib_rule_engine";

    @Qualifier("daoTemplate")
    @Autowired
    private JdbcDaoTemplate daoTemplate;

    public RuleGroupDetailDTO getGroup(String ruleFileKey) {
        StringBuilder sql = new StringBuilder(64);
        sql.append("SELECT * FROM `").append(DB_NAME).append("`.`rule_group` WHERE rule_file_key_=? AND del_flag_=?");

        List<RuleGroupDetailDTO> list = this.daoTemplate.query(sql.toString(), new Object[]{ruleFileKey, DelFlagEnum.NORMAL.getType()}, (rs, rowNum) -> {
            RuleGroupDetailDTO groupDTO = new RuleGroupDetailDTO();

            groupDTO.setId(rs.getString("id_"));
            groupDTO.setName(rs.getString("group_name_"));
            groupDTO.setRuleFileKey(rs.getString("rule_file_key_"));
            groupDTO.setType(RuleGroupType.getByType(rs.getString("group_type_")));

            return groupDTO;
        });

        return Collections3.isNotEmpty(list) ? list.get(0) : null;
    }

    public List<RuleSourceDTO> querySource(String groupId) {
        StringBuilder sql = new StringBuilder(64);
        sql.append("SELECT * FROM `").append(DB_NAME).append("`.`rule_source` WHERE rule_group_id_=? AND del_flag_=? ORDER BY sort_ ASC");

        return daoTemplate.query(sql.toString(), new Object[]{groupId, DelFlagEnum.NORMAL.getType()}, (rs, rowNum) -> {
            RuleSourceDTO sourceDTO = new RuleSourceDTO();

            sourceDTO.setId(rs.getString("id_"));
            sourceDTO.setName(rs.getString("source_name_"));
            sourceDTO.setValue(rs.getString("source_value_"));
            sourceDTO.setRemark(rs.getString("remark_"));

            return sourceDTO;
        });
    }

    public List<RuleLogicSourceDTO> queryLogicSource(String groupId) {
        StringBuilder sql = new StringBuilder(64);
        sql.append("SELECT a.* FROM `").append(DB_NAME).append("`.`rule_logic_source` a");
        sql.append(" LEFT JOIN `").append(DB_NAME).append("`.`rule_source` s ON a.rule_source_id_ = s.id_");
        sql.append(" LEFT JOIN `").append(DB_NAME).append("`.`rule_logic` l ON a.rule_logic_id_ = l.id_");
        sql.append(" WHERE a.rule_group_id_=? ORDER BY s.sort_ ASC, l.sort_ ASC");

        return daoTemplate.query(sql.toString(), new Object[]{groupId}, (rs, rowNum) -> {
            RuleLogicSourceDTO logicSourceDTO = new RuleLogicSourceDTO();

            logicSourceDTO.setLogicId(rs.getString("rule_logic_id_"));
            logicSourceDTO.setSourceId(rs.getString("rule_source_id_"));
            return logicSourceDTO;
        });
    }

    public List<RuleDslDTO> queryDsl(String groupId) {
        StringBuilder sql = new StringBuilder(64);
        sql.append("SELECT * FROM `").append(DB_NAME).append("`.`rule_dsl` WHERE rule_group_id_=? ORDER BY sort_ ASC");

        return daoTemplate.query(sql.toString(), new Object[]{groupId}, (rs, rowNum) -> {
            RuleDslDTO dslDTO = new RuleDslDTO();

            dslDTO.setId(rs.getString("id_"));
            dslDTO.setName(rs.getString("rule_name_"));
            dslDTO.setContent(rs.getString("content_"));
            dslDTO.setInterrupt(rs.getBoolean("interrupt_state_"));
            dslDTO.setNestCount(rs.getInt("nest_count_"));
            dslDTO.setLogicId(rs.getString("rule_logic_id_"));

            return dslDTO;
        });
    }

    public List<RuleDslUnitDTO> queryDslUnit(String dslId) {
        StringBuilder sql = new StringBuilder(64);
        sql.append("SELECT * FROM `").append(DB_NAME).append("`.`rule_dsl_unit` WHERE rule_dsl_id_=? ORDER BY sort_ ASC");

        return daoTemplate.query(sql.toString(), new Object[]{dslId}, (rs, rowNum) -> {
            RuleDslUnitDTO dslUnitDTO = new RuleDslUnitDTO();

            dslUnitDTO.setId(rs.getString("id_"));
            dslUnitDTO.setTargetField(rs.getString("target_field_"));
            dslUnitDTO.setStartIndex(rs.getInt("start_index_"));

            return dslUnitDTO;
        });
    }

    public List<RuleUnitDetailDTO> queryUnit(String groupId) {
        StringBuilder sql = new StringBuilder(32);
        sql.append("SELECT * FROM `").append(DB_NAME).append("`.`rule_unit` WHERE rule_group_id_=?");

        return this.daoTemplate.query(sql.toString(), new Object[]{groupId}, (rs, rowNum) -> {
            RuleUnitDetailDTO unitDTO = new RuleUnitDetailDTO();
            unitDTO.setId(rs.getString("id_"));
            unitDTO.setTargetField(rs.getString("target_field_"));

            return unitDTO;
        });
    }

    public List<RuleUnitPairDTO> queryUnitPair(String groupId) {
        StringBuilder sql = new StringBuilder(32);
        sql.append("SELECT * FROM `").append(DB_NAME).append("`.`rule_unit_pair` WHERE rule_group_id_=?");

        return daoTemplate.query(sql.toString(), new Object[]{groupId}, (rs, rowNum) -> {
            RuleUnitPairDTO unitPairDTO = new RuleUnitPairDTO();

            unitPairDTO.setLeftUnitId(rs.getString("left_unit_id_"));
            unitPairDTO.setRightUnitId(rs.getString("right_unit_id_"));

            return unitPairDTO;
        });
    }

    public List<RuleUnitCandidateDetailDTO> queryUnitCandidate(String groupId) {
        StringBuilder sql = new StringBuilder(32);
        sql.append("SELECT * FROM `").append(DB_NAME).append("`.`rule_unit_candidate` WHERE rule_group_id_=?");

        return daoTemplate.query(sql.toString(), new Object[]{groupId}, (rs, rowNum) -> {
            RuleUnitCandidateDetailDTO candidateDTO = new RuleUnitCandidateDetailDTO();
            candidateDTO.setUnitId(rs.getString("rule_unit_id_"));
            candidateDTO.setContent(rs.getString("content_"));

            return candidateDTO;
        });
    }
}
