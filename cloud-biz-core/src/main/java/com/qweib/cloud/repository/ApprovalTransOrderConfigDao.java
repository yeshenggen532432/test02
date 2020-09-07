package com.qweib.cloud.repository;


import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.ApprovalTransOrderConfig;
import com.qweib.cloud.core.domain.approval.ApprovalTypeEnum;
import com.qweib.cloud.core.domain.approval.StatusEnum;
import com.qweib.cloud.core.domain.approval.dto.TransOrderConfigDTO;
import com.qweib.cloud.core.domain.approval.dto.TransOrderConfigDetailDTO;
import com.qweib.cloud.service.basedata.common.TransferOrderEnum;
import com.qweib.cloud.utils.Collections3;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2019/1/9 - 14:42
 */
@Repository
public class ApprovalTransOrderConfigDao {

    @Qualifier("daoTemplate")
    @Autowired
    private JdbcDaoTemplate daoTemplate;

    public boolean save(String database, ApprovalTransOrderConfig entity) {
        StringBuilder sql = new StringBuilder(128);
        sql.append("INSERT INTO ").append(database).append(".approval_transfer_order_config")
                .append(" (id,no,approval_type,transfer_order_type,status,system_approval,approval_id,")
                .append("account_subject_type,account_subject_item,payment_account,created_by,created_time,updated_by,updated_time)")
                .append(" VALUES (").append(StringUtils.repeat("?", ",", 14)).append(");");

        List<Object> values = new ArrayList<Object>();
        values.add(entity.getId());
        values.add(entity.getNo());
        values.add(entity.getApprovalType().getType());
        values.add(entity.getTransferOrder().getType());
        values.add(entity.getStatus().getStatus());
        values.add(entity.getSystemApproval());
        values.add(entity.getApprovalId());
        values.add(entity.getAccountSubjectType());
        values.add(entity.getAccountSubjectItem());
        values.add(entity.getPaymentAccount());
        values.add(entity.getCreatedBy());
        values.add(entity.getCreatedTime());
        values.add(entity.getUpdatedBy());
        values.add(entity.getUpdatedTime());

        int count = this.daoTemplate.update(sql.toString(), values.toArray(new Object[values.size()]));
        return count > 0;
    }

    public boolean deleteByApprovalId(String database, String approvalId){
        int count = this.daoTemplate.update("delete from " + database + ".approval_transfer_order_config" + " where approval_id = ?",
                new Object[]{approvalId});
        return count > 0;
    }

    public boolean update(String database, ApprovalTransOrderConfig entity) {
        StringBuilder sql = new StringBuilder(128);
        sql.append("UPDATE ").append(database).append(".approval_transfer_order_config SET")
                .append(" transfer_order_type = ?,")
                .append("account_subject_type = ?,account_subject_item = ?,payment_account = ?,updated_by = ?,updated_time = ?")
                .append(" WHERE id = ?");

        List<Object> values = new ArrayList<Object>();
        values.add(entity.getTransferOrder().getType());
        values.add(entity.getAccountSubjectType());
        values.add(entity.getAccountSubjectItem());
        values.add(entity.getPaymentAccount());
        values.add(entity.getUpdatedBy());
        values.add(entity.getUpdatedTime());
        values.add(entity.getId());

        int count = this.daoTemplate.update(sql.toString(), values.toArray(new Object[values.size()]));
        return count > 0;
    }

    public boolean updateStatus(String database, ApprovalTransOrderConfig entity) {
        StringBuilder sql = new StringBuilder(64);
        sql.append("UPDATE ").append(database).append(".approval_transfer_order_config SET")
                .append(" status = ?,updated_by = ?,updated_time = ? WHERE id = ?");

        List<Object> values = new ArrayList<Object>();
        values.add(entity.getStatus().getStatus());
        values.add(entity.getUpdatedBy());
        values.add(entity.getUpdatedTime());
        values.add(entity.getId());

        int count = this.daoTemplate.update(sql.toString(), values.toArray(new Object[values.size()]));
        return count > 0;
    }

    public boolean clear(String database, ApprovalTransOrderConfig entity) {
        StringBuilder sql = new StringBuilder(128);
        sql.append("UPDATE ").append(database).append(".approval_transfer_order_config SET")
                .append(" transfer_order_type = ?,")
                .append("account_subject_type = ?,account_subject_item = ?,payment_account = ?,updated_by = ?,updated_time = ?,status = ?")
                .append(" WHERE id = ?");

        List<Object> values = new ArrayList<Object>();
        values.add(entity.getTransferOrder().getType());
        values.add(entity.getAccountSubjectType());
        values.add(entity.getAccountSubjectItem());
        values.add(entity.getPaymentAccount());
        values.add(entity.getUpdatedBy());
        values.add(entity.getUpdatedTime());
        values.add(entity.getStatus().getStatus());
        values.add(entity.getId());

        int count = this.daoTemplate.update(sql.toString(), values.toArray(new Object[values.size()]));
        return count > 0;
    }

    public List<TransOrderConfigDTO> list(String database) {
        StringBuilder sql = new StringBuilder(128);
        sql.append("SELECT a.*,b.member_nm FROM ").append(database).append(".approval_transfer_order_config a")
                .append(" LEFT JOIN ").append(database).append(".sys_mem b ON a.updated_by = b.member_id");

        return this.daoTemplate.query(sql.toString(), new TransOrderConfigRowMapper());
    }

    public TransOrderConfigDetailDTO get(String database, String id) {
        StringBuilder sql = new StringBuilder(128);
        sql.append("SELECT a.*,z.zdy_nm AS approval_name,b.member_nm AS updated_name,c.member_nm AS created_name FROM ")
                .append(database).append(".approval_transfer_order_config a")
                .append(" LEFT JOIN ").append(database).append(".bsc_audit_zdy z ON a.approval_type = ? AND a.approval_id = z.id")
                .append(" LEFT JOIN ").append(database).append(".sys_mem c ON a.created_by = c.member_id")
                .append(" LEFT JOIN ").append(database).append(".sys_mem b ON a.updated_by = b.member_id")
                .append(" WHERE a.id = ?");

        List<TransOrderConfigDetailDTO> list = this.daoTemplate.query(sql.toString(), new Object[]{ApprovalTypeEnum.CUSTOM.getType(), id},
                new TransOrderConfigDetailRowMapper());
        return Collections3.isNotEmpty(list) ? list.get(0) : null;
    }

    public ApprovalTransOrderConfig getByApprovalId(String database, String approvalType, String approvalId) {
        StringBuilder sql = new StringBuilder(128);
        sql.append("SELECT * FROM ").append(database).append(".approval_transfer_order_config")
                .append(" WHERE approval_type = ? AND approval_id = ?");

        List<ApprovalTransOrderConfig> list = this.daoTemplate.query(sql.toString(), new Object[]{approvalType, approvalId},
                new TransOrderConfigDORowMapper());
        return Collections3.isNotEmpty(list) ? list.get(0) : null;
    }

    public ApprovalTransOrderConfig getByApprovalId(String database, String approvalId) {
        StringBuilder sql = new StringBuilder(128);
        sql.append("SELECT * FROM ").append(database).append(".approval_transfer_order_config")
                .append(" WHERE approval_id = ?");

        List<ApprovalTransOrderConfig> list = this.daoTemplate.query(sql.toString(), new Object[]{approvalId},
                new TransOrderConfigDORowMapper());
        return Collections3.isNotEmpty(list) ? list.get(0) : null;
    }

    public String getMaxNo(String database, ApprovalTypeEnum approvalType) {
        final StringBuilder sql = new StringBuilder(64)
                .append("SELECT MAX(no) AS maxNo FROM ").append(database).append(".approval_transfer_order_config")
                .append(" WHERE approval_type = ?");

        List<Map<String, Object>> dataList = daoTemplate.queryForList(sql.toString(), new Object[]{approvalType.getType()});

        return Collections3.isNotEmpty(dataList) ? (String) dataList.get(0).get("maxNo") : null;
    }

    private static class TransOrderConfigRowMapper implements RowMapper<TransOrderConfigDTO> {

        @Override
        public TransOrderConfigDTO mapRow(ResultSet rs, int rowNum) throws SQLException {
            TransOrderConfigDTO configDTO = new TransOrderConfigDTO();

            configDTO.setId(rs.getString("id"));
            configDTO.setNo(rs.getString("no"));
            configDTO.setApprovalType(ApprovalTypeEnum.getByType(rs.getString("approval_type")));
            configDTO.setTransferOrder(TransferOrderEnum.createByType(rs.getString("transfer_order_type")));
            configDTO.setStatus(StatusEnum.getByStatus(rs.getString("status")));
            configDTO.setSystemApproval(rs.getBoolean("system_approval"));
            configDTO.setApprovalId(rs.getString("approval_id"));
            configDTO.setAccountSubjectType(rs.getString("account_subject_type"));
            configDTO.setAccountSubjectItem(rs.getString("account_subject_item"));
            configDTO.setPaymentAccount(rs.getString("payment_account"));
            configDTO.setUpdatedName(rs.getString("member_nm"));
            configDTO.setUpdatedTime(rs.getTimestamp("updated_time"));

            return configDTO;
        }
    }

    private static class TransOrderConfigDetailRowMapper implements RowMapper<TransOrderConfigDetailDTO> {

        @Override
        public TransOrderConfigDetailDTO mapRow(ResultSet rs, int rowNum) throws SQLException {
            TransOrderConfigDetailDTO configDTO = new TransOrderConfigDetailDTO();

            configDTO.setId(rs.getString("id"));
            configDTO.setNo(rs.getString("no"));
            configDTO.setApprovalType(ApprovalTypeEnum.getByType(rs.getString("approval_type")));
            configDTO.setApprovalName(rs.getString("approval_name"));
            configDTO.setTransferOrder(TransferOrderEnum.createByType(rs.getString("transfer_order_type")));
            configDTO.setStatus(StatusEnum.getByStatus(rs.getString("status")));
            configDTO.setSystemApproval(rs.getBoolean("system_approval"));
            configDTO.setApprovalId(rs.getString("approval_id"));
            configDTO.setAccountSubjectType(rs.getString("account_subject_type"));
            configDTO.setAccountSubjectItem(rs.getString("account_subject_item"));
            configDTO.setPaymentAccount(rs.getString("payment_account"));
            configDTO.setCreatedName(rs.getString("created_name"));
            configDTO.setCreatedTime(rs.getTimestamp("created_time"));
            configDTO.setUpdatedName(rs.getString("updated_name"));
            configDTO.setUpdatedTime(rs.getTimestamp("updated_time"));

            return configDTO;
        }
    }

    private static class TransOrderConfigDORowMapper implements RowMapper<ApprovalTransOrderConfig> {

        @Override
        public ApprovalTransOrderConfig mapRow(ResultSet rs, int rowNum) throws SQLException {
            ApprovalTransOrderConfig configDTO = new ApprovalTransOrderConfig();

            configDTO.setId(rs.getString("id"));
            configDTO.setNo(rs.getString("no"));
            configDTO.setApprovalType(ApprovalTypeEnum.getByType(rs.getString("approval_type")));
            configDTO.setTransferOrder(TransferOrderEnum.createByType(rs.getString("transfer_order_type")));
            configDTO.setStatus(StatusEnum.getByStatus(rs.getString("status")));
            configDTO.setSystemApproval(rs.getBoolean("system_approval"));
            configDTO.setApprovalId(rs.getString("approval_id"));
            configDTO.setAccountSubjectType(rs.getString("account_subject_type"));
            configDTO.setAccountSubjectItem(rs.getString("account_subject_item"));
            configDTO.setPaymentAccount(rs.getString("payment_account"));
            configDTO.setCreatedTime(rs.getTimestamp("created_time"));
            configDTO.setUpdatedTime(rs.getTimestamp("updated_time"));

            return configDTO;
        }
    }
}
