package com.qweib.cloud.biz.system.controller.product.excel;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.google.common.collect.Sets;
import com.qweib.biz.ruleparser.product.ProductDTO;
import com.qweib.cloud.biz.system.controller.customer.price.BaseModelExecutor;
import com.qweib.cloud.biz.system.service.company.TempProductService;
import com.qweib.cloud.biz.system.service.ruleengine.RuleEngineService;
import com.qweib.cloud.core.domain.dto.RuleUnitCandidateDetailDTO;
import com.qweib.cloud.core.domain.product.TempProductBaseDTO;
import com.qweib.cloud.core.domain.product.TempProductModel;
import com.qweib.cloud.core.domain.product.TempProductSave;
import com.qweib.cloud.core.exception.BizException;
import com.qweib.commons.Collections3;
import com.qweib.commons.StringUtils;
import com.qweib.rule.generator.domain.dto.*;
import com.qweib.rule.handler.DslLogicHandler;
import com.qweib.rule.handler.DslLogicInput;
import com.qweib.rule.handler.impl.DslLogicDefaultHandler;
import com.qweibframework.commons.MathUtils;
import com.qweibframework.commons.Reflections;
import com.qweibframework.excel.message.ErrorMessage;
import lombok.extern.slf4j.Slf4j;
import org.dozer.Mapper;

import java.lang.reflect.Field;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.Set;
import java.util.concurrent.atomic.AtomicBoolean;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2019/5/21 - 16:26
 */
@Slf4j
public class TempProductModelExecutor extends BaseModelExecutor<TempProductModel> {

    private final static String RULE_FILE_KEY = "productImport001";

    private final Integer recordId;
    private final TempProductService tempProductService;
    private final RuleEngineService ruleEngineService;
    private final Mapper mapper;

    private Map<String, Integer> productCache = Maps.newHashMap();
    private final Map<String, DslLogicHandler> sourceLogicMap = Maps.newLinkedHashMap();
    private final Map<String, DslLogicInput> logicInputMap = Maps.newHashMap();
    private final Map<String, String> unitPairMap = Maps.newHashMap();
    private final Map<String, Set<String>> unitCandidateMap = Maps.newHashMap();
    private final AtomicBoolean useRuleEngine = new AtomicBoolean(false);

    public TempProductModelExecutor(String database, Integer operatorId,
                                    Integer recordId, TempProductService tempProductService,
                                    RuleEngineService ruleEngineService,
                                    Mapper mapper) {
        super(database, operatorId);
        this.recordId = recordId;
        this.tempProductService = tempProductService;
        this.ruleEngineService = ruleEngineService;
        this.mapper = mapper;

        this.initialData();
    }

    @Override
    public List<ErrorMessage> execute(List<TempProductModel> models) {
        List<ErrorMessage> errors = Lists.newArrayList();
        List<TempProductSave> dataList = Lists.newArrayListWithCapacity(models.size());

        for (TempProductModel model : models) {
            try {
                Optional<TempProductSave> optional = convertTo(model);
                if (optional.isPresent()) {
                    TempProductSave input = optional.get();
                    input.setUpdatedBy(operatorId);
                    input.setRecordId(recordId);
                    dataList.add(input);
                }
            } catch (Exception e) {
                errors.add(new ErrorMessage(model.getRowNum(), e.getMessage()));
            }
        }

        try {
            if (Collections3.isNotEmpty(dataList)) {
                this.repeatCount += this.tempProductService.saveBatch(dataList, database);
            }
        } catch (Exception e) {
            log.error("temp product import error", e);
        }

        return errors;
    }

    public Optional<TempProductSave> convertTo(TempProductModel model) {
        final String productName = model.getProductName();
        if (StringUtils.isBlank(productName)) {
            return Optional.empty();
        }

        final Integer productId = this.productCache.get(productName);
        if (productId != null) {
            this.repeatCount++;
        }

        if (useRuleEngine.get()) {
            ProductDTO productDTO = handleRule(model);
            setUnitData(productDTO, model);
        }

        TempProductSave input = mapper.map(model, TempProductSave.class);
        input.setId(productId);
        if (!MathUtils.valid(input.getBigUnitScale())) {
            input.setBigUnitScale(1D);
        }
        if (!MathUtils.valid(input.getSmallUnitScale())) {
            input.setSmallUnitScale(1D);
        }

        return Optional.of(input);
    }

    private ProductDTO handleRule(TempProductModel model) {
        ProductDTO productDTO = new ProductDTO();
        for (Map.Entry<String, DslLogicHandler> entry : sourceLogicMap.entrySet()) {
            final String sourceField = entry.getKey();
            Field field = Reflections.getAccessibleField(model, sourceField);
            if (field.getType() != String.class) {
                continue;
            }
            String fieldValue = (String) Reflections.getFieldValue(model, sourceField);
            if (StringUtils.isBlank(fieldValue)) {
                continue;
            }

            Map<String, String> resultMap = entry.getValue().handle(fieldValue);
            if (Collections3.isNotEmpty(resultMap)) {
                checkUnitPair(resultMap);
                setProductProperties(productDTO, resultMap);
            }
        }

        return productDTO;
    }

    /**
     * 检查配对数据是否需要调换
     *
     * @param resultMap
     */
    private void checkUnitPair(Map<String, String> resultMap) {
        if (Collections3.isEmpty(unitPairMap) || Collections3.isEmpty(unitCandidateMap)) {
            return;
        }

        final Set<String> matchedField = Sets.newHashSet();

        resultMap.keySet().stream()
                .filter(key -> !matchedField.contains(key) && Optional.ofNullable(unitPairMap.get(key)).isPresent())
                .forEach(key -> {
                    final String value = resultMap.get(key);

                    Set<String> candidateSet = unitCandidateMap.get(key);
                    final String pairField = unitPairMap.get(key);
                    final String pairFieldValue = resultMap.get(pairField);
                    if (Collections3.isNotEmpty(candidateSet) && StringUtils.isNotBlank(pairFieldValue)
                            && candidateSet.contains(pairFieldValue)) {
                        resultMap.put(key, pairFieldValue);
                        resultMap.put(pairField, value);
                        matchedField.add(key);
                        matchedField.add(pairField);
                    }
                });
    }

    private Map<String, Field> productFields = Maps.newHashMap();

    private void setProductProperties(final ProductDTO productDTO, final Map<String, String> resultMap) {
        resultMap.forEach((key, value) -> {
            Field field = getProductField(productDTO, key);
            Object fieldValue = convert(field, value);
            Reflections.setFieldValue(productDTO, key, fieldValue);
        });
    }

    private Object convert(Field field, String value) {
        if (Float.class.equals(field.getType())) {
            return StringUtils.toFloat(value);
        }
        if (Integer.class.equals(field.getType()) || int.class.equals(field.getType())) {
            return StringUtils.toInteger(value);
        }
        if (Double.class.equals(field.getType()) || double.class.equals(field.getType())) {
            return StringUtils.toDouble(value);
        }
        if (Boolean.class.equals(field.getType()) || boolean.class.equals(field.getType())) {
            return StringUtils.toBoolean(value);
        }
        if (Long.class.equals(field.getType()) || long.class.equals(field.getType())) {
            return StringUtils.toLong(value);
        }

        return value;
    }

    private Field getProductField(final ProductDTO productDTO, final String fieldName) {
        Field field = productFields.get(fieldName);
        if (field == null) {
            field = Reflections.getAccessibleField(productDTO, fieldName);
            productFields.put(fieldName, field);
        }

        return field;
    }

    private void setUnitData(ProductDTO productDTO, TempProductModel input) {
        if (StringUtils.isNotBlank(productDTO.getBigUnit())) {
            input.setBigUnitName(productDTO.getBigUnit());
        }
        if (productDTO.getBigUnitScale() != null && input.getBigUnitScale() == null) {
            input.setBigUnitScale(productDTO.getBigUnitScale());
        }

        if (StringUtils.isNotBlank(productDTO.getSmallUnit())) {
            input.setSmallUnitName(productDTO.getSmallUnit());
        }
        if (productDTO.getSmallUnitScale() != null && input.getSmallUnitScale() == null) {
            input.setSmallUnitScale(productDTO.getSmallUnitScale());
        }
    }

//    private boolean checkData(TempProductSave input) {
//        if (StringUtils.isBlank(input.getBigUnitName())
//                || input.getBigUnitScale() == null
//                || StringUtils.isBlank(input.getSmallUnitName())
//                || input.getSmallUnitScale() == null) {
//            return false;
//        } else {
//            return true;
//        }
//    }
//
//    private void analysisBigUnit(TempProductSave input) {
//        final String bigUnitName = input.getBigUnitName();
//        if (StringUtils.isBlank(bigUnitName)) {
//            return;
//        }
//
//        ProductParser parser = getParser(bigUnitName);
//        ProductVisitorImpl visitor = new ProductVisitorImpl();
//        visitor.visit(parser.bigUnitStatement());
//        ProductDTO productDTO = visitor.getProductDTO();
//
//        setUnitData(productDTO, input);
//    }
//
//    private void analysisSmallUnit(TempProductSave input) {
//        final String smallUnitName = input.getSmallUnitName();
//        if (StringUtils.isBlank(smallUnitName)) {
//            return;
//        }
//
//        ProductParser parser = getParser(smallUnitName);
//        ProductVisitorImpl visitor = new ProductVisitorImpl();
//        visitor.visit(parser.smallUnitStatement());
//        ProductDTO productDTO = visitor.getProductDTO();
//
//        setUnitData(productDTO, input);
//    }
//
//    private void analysisProporation(TempProductSave input) {
//        final String bigUnitSpec = input.getBigUnitSpec();
//        if (StringUtils.isBlank(bigUnitSpec)) {
//            return;
//        }
//
//        ProductParser parser = getParser(bigUnitSpec);
//        ProductVisitorImpl visitor = new ProductVisitorImpl();
//        visitor.visit(parser.proportionStatement());
//        ProductDTO productDTO = visitor.getProductDTO();
//
//        setUnitData(productDTO, input);
//    }

//    private ProductParser getParser(String source) {
//        CodePointCharStream input = CharStreams.fromString(source);
//        ProductLexer lexer = new ProductLexer(input);
//        CommonTokenStream tokenStream = new CommonTokenStream(lexer);
//
//        return new ProductParser(tokenStream);
//    }

    private void initialData() {
        Optional<List<TempProductBaseDTO>> productOptional = Optional.ofNullable(this.tempProductService.getAllBaseProduct(this.recordId, database));
        if (productOptional.isPresent()) {
            productOptional.get()
                    .forEach(product -> productCache.put(product.getProductName(), product.getId()));
        }

        RuleGroupDetailDTO groupDTO = this.ruleEngineService.getGroup(RULE_FILE_KEY);
        if (groupDTO == null) {
            return;
        }

        useRuleEngine.set(true);
        final String groupId = groupDTO.getId();

        List<RuleDslDTO> dslDTOS = this.ruleEngineService.queryDsl(groupId);
        if (Collections3.isEmpty(dslDTOS)) {
            throw new BizException("查找不到DSL规则");
        }

        List<RuleSourceDTO> sourceDTOS = this.ruleEngineService.querySource(groupId);
        if (Collections3.isEmpty(sourceDTOS)) {
            throw new BizException("未设置数据源");
        }
        final Map<String, RuleSourceDTO> sourceMap = Maps.newHashMapWithExpectedSize(sourceDTOS.size());
        for (RuleSourceDTO sourceDTO : sourceDTOS) {
            sourceMap.put(sourceDTO.getId(), sourceDTO);
        }

        List<RuleLogicSourceDTO> logicSourceDTOS = this.ruleEngineService.queryLogicSource(groupId);
        if (Collections3.isEmpty(logicSourceDTOS)) {
            throw new BizException("查找不到规则数据源");
        }

        for (RuleDslDTO dslDTO : dslDTOS) {
            List<RuleDslUnitDTO> dslUnitDTOS = this.ruleEngineService.queryDslUnit(dslDTO.getId());
            if (Collections3.isEmpty(dslUnitDTOS)) {
                continue;
            }

            DslLogicInput logicInput = new DslLogicInput();
            logicInput.setRegex(dslDTO.getContent());
            logicInput.setNestCount(dslDTO.getNestCount());
            logicInput.setUnitList(dslUnitDTOS);

            logicInputMap.put(dslDTO.getLogicId(), logicInput);
        }

        for (RuleLogicSourceDTO logicSourceDTO : logicSourceDTOS) {
            final String logicId = logicSourceDTO.getLogicId();
            final DslLogicInput logicInput = logicInputMap.get(logicId);
            if (logicInput == null) {
                continue;
            }

            RuleSourceDTO sourceDTO = sourceMap.get(logicSourceDTO.getSourceId());
            if (sourceDTO == null) {
                continue;
            }

            final String sourceField = sourceDTO.getValue();
            DslLogicHandler logicHandler = sourceLogicMap.get(sourceField);
            if (logicHandler == null) {
                logicHandler = new DslLogicDefaultHandler(logicInput);
                sourceLogicMap.put(sourceField, logicHandler);
            } else {
                logicHandler.setNextHandler(new DslLogicDefaultHandler(logicInput));
            }
        }

        List<RuleUnitPairDTO> unitPairDTOS = this.ruleEngineService.queryUnitPair(groupId);
        if (Collections3.isEmpty(unitPairDTOS)) {
            return;
        }

        List<RuleUnitDetailDTO> unitDTOS = this.ruleEngineService.queryUnit(groupId);
        Map<String, RuleUnitDetailDTO> unitCache = Maps.newHashMapWithExpectedSize(unitDTOS.size());
        for (RuleUnitDetailDTO unitDTO : unitDTOS) {
            unitCache.put(unitDTO.getId(), unitDTO);
        }

        for (RuleUnitPairDTO unitPairDTO : unitPairDTOS) {
            String leftUnitId = unitPairDTO.getLeftUnitId();
            String rightUnitId = unitPairDTO.getRightUnitId();

            Optional<RuleUnitDetailDTO> leftUnitOptional = Optional.ofNullable(unitCache.get(leftUnitId));
            Optional<RuleUnitDetailDTO> rightUnitOptional = Optional.ofNullable(unitCache.get(rightUnitId));

            if (!leftUnitOptional.isPresent() || !rightUnitOptional.isPresent()) {
                continue;
            }

            final String leftField = leftUnitOptional.get().getTargetField();
            final String rightField = rightUnitOptional.get().getTargetField();

            unitPairMap.put(leftField, rightField);
            unitPairMap.put(rightField, leftField);
        }

        List<RuleUnitCandidateDetailDTO> unitCandidateDTOS = this.ruleEngineService.queryUnitCandidate(groupId);
        if (Collections3.isEmpty(unitCandidateDTOS)) {
            return;
        }

        for (RuleUnitCandidateDetailDTO unitCandidateDTO : unitCandidateDTOS) {
            Optional<RuleUnitDetailDTO> unitOptional = Optional.ofNullable(unitCache.get(unitCandidateDTO.getUnitId()));
            if (!unitOptional.isPresent()) {
                continue;
            }

            final String targetField = unitOptional.get().getTargetField();
            Set<String> candidates = unitCandidateMap.get(targetField);
            if (candidates == null) {
                candidates = Sets.newHashSet();
                unitCandidateMap.put(targetField, candidates);
            }

            candidates.add(unitCandidateDTO.getContent());
        }
    }
}
