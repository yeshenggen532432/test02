package com.qweib.cloud.biz.system.service;


import com.qweib.business.code.CodeRuleGenerator;
import com.qweib.business.code.CodeRuleRepository;
import com.qweib.business.code.model.BillCodeModel;
import com.qweib.cloud.core.domain.ApprovalTransOrderConfig;
import com.qweib.cloud.core.domain.approval.*;
import com.qweib.cloud.core.domain.approval.dto.TransOrderConfigDTO;
import com.qweib.cloud.core.domain.approval.dto.TransOrderConfigDetailDTO;
import com.qweib.cloud.repository.ApprovalTransOrderConfigDao;
import com.qweib.cloud.service.basedata.common.TransferOrderEnum;
import com.qweib.cloud.utils.DateTimeUtil;
import com.qweib.cloud.utils.IdGen;
import com.qweib.commons.exceptions.BizException;
import com.qweibframework.commons.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2019/1/9 - 16:30
 */
@Service
public class ApprovalTransOrderConfigService {

    @Autowired
    private ApprovalTransOrderConfigDao transOrderConfigDao;
    @Qualifier("billCodeRuleGenerator")
    @Autowired
    private CodeRuleGenerator billCodeRuleGenerator;

    public void saveTransOrderConfig(final String database, final TransOrderConfigSave config) {
        ApprovalTransOrderConfig entity = new ApprovalTransOrderConfig();
        entity.setId(IdGen.uuid());

        String no;
        if (config.getApprovalType() == ApprovalTypeEnum.CUSTOM) {
            BillCodeModel codeModel = new BillCodeModel.Builder()
                    .setNumStart(6)
                    .setNumLength(5)
                    .build();

            no = billCodeRuleGenerator.getCode("approval:transorder:config", codeModel, new CodeRuleRepository() {
                @Override
                public String getMaxNo() {
                    return transOrderConfigDao.getMaxNo(database, config.getApprovalType());
                }
            });
        } else {
            no = StringUtils.leftPad(config.getApprovalType().getType(), 5, '0');
        }

        entity.setNo(no);
        entity.setApprovalType(config.getApprovalType());
        entity.setTransferOrder(config.getTransferOrder());
        entity.setStatus(StatusEnum.CONFIGURED);
        entity.setSystemApproval(!config.getApprovalType().equals(ApprovalTypeEnum.CUSTOM));
        if (!entity.getSystemApproval()) {
            entity.setApprovalId(config.getApprovalId());
        } else {
            entity.setApprovalId(config.getApprovalType().getDefaultId());
        }
        entity.setAccountSubjectType(config.getAccountSubjectType());
        entity.setAccountSubjectItem(config.getAccountSubjectItem());
        entity.setPaymentAccount(config.getPaymentAccount());
        entity.setCreatedBy(config.getOperatorId());
        entity.setCreatedTime(DateTimeUtil.getTimestamp());
        entity.setUpdatedBy(entity.getCreatedBy());
        entity.setUpdatedTime(entity.getCreatedTime());

        this.transOrderConfigDao.save(database, entity);
    }

    public List<TransOrderConfigDTO> listTransOrderConfigs(String database) {
        return this.transOrderConfigDao.list(database);
    }

    public TransOrderConfigDetailDTO getTransOrderConfig(String database, String id) {
        return this.transOrderConfigDao.get(database, id);
    }

    public void updateTransOrderConfig(String database, TransOrderConfigUpdate config) {
        TransOrderConfigDetailDTO oldConfig = getTransOrderConfig(database, config.getId());
        if (oldConfig == null) {
            throw new BizException("请先进行初始配置");
        }
        ApprovalTransOrderConfig entity = new ApprovalTransOrderConfig();
        entity.setId(config.getId());

        entity.setTransferOrder(config.getTransferOrder());
        entity.setAccountSubjectType(config.getAccountSubjectType());
        entity.setAccountSubjectItem(config.getAccountSubjectItem());
        entity.setPaymentAccount(config.getPaymentAccount());
        entity.setUpdatedBy(config.getOperatorId());
        entity.setUpdatedTime(DateTimeUtil.getTimestamp());

        this.transOrderConfigDao.update(database, entity);
    }

    public void updateStatus(String database, TransOrderConfigStatus config) {
        TransOrderConfigDetailDTO oldConfig = getTransOrderConfig(database, config.getId());
        if (oldConfig == null) {
            throw new BizException("请先进行初始配置");
        }
        if (oldConfig.getStatus().equals(config.getStatus())) {
            throw new BizException("该配置已经是该状态，不需要修改");
        }

        ApprovalTransOrderConfig entity = new ApprovalTransOrderConfig();
        entity.setId(config.getId());
        entity.setStatus(config.getStatus());
        entity.setUpdatedBy(config.getOperatorId());
        entity.setUpdatedTime(DateTimeUtil.getTimestamp());

        this.transOrderConfigDao.updateStatus(database, entity);
    }

    public void clearTransOrderConfig(String database,String approvalId, Integer operatorId) {
        ApprovalTransOrderConfig oldConfig = transOrderConfigDao.getByApprovalId(database, approvalId);
        if (oldConfig == null) {
            return;
        }
        ApprovalTransOrderConfig entity = new ApprovalTransOrderConfig();
        entity.setId(oldConfig.getId());
        entity.setTransferOrder(TransferOrderEnum.REIMBURSE);
        entity.setAccountSubjectType("");
        entity.setAccountSubjectItem("");
        entity.setUpdatedBy(operatorId);
        entity.setUpdatedTime(DateTimeUtil.getTimestamp());
        entity.setStatus(StatusEnum.UNCONFIGURED);
        this.transOrderConfigDao.clear(database, entity);
    }

    public void deleteByApprovalId(String database,String approvalId){
        ApprovalTransOrderConfig oldConfig = transOrderConfigDao.getByApprovalId(database, approvalId);
        if (oldConfig == null) {
            return;
        }
        this.transOrderConfigDao.deleteByApprovalId(database, approvalId);
    }

    public ApprovalTransOrderConfig getByApprovalId(String database, String approvalId) {
        ApprovalTransOrderConfig config = transOrderConfigDao.getByApprovalId(database, approvalId);
        return config;
    }

}
