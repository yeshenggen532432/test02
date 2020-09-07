package com.qweib.cloud.repository.mall;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.ShopMemberCompany;
import com.qweib.cloud.core.domain.shop.*;
import com.qweib.cloud.repository.utils.HttpResponseUtils;
import com.qweib.cloud.service.member.domain.member.shop.ShopMemberCompanyRequest;
import com.qweib.cloud.service.member.retrofit.ShopMemberCompanyRetrofitApi;
import com.qweib.cloud.utils.Constants;
import com.qweib.commons.Collections3;
import com.qweib.commons.DateUtils;
import com.qweib.commons.StringUtils;
import com.qweib.commons.mapper.BeanMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2019/5/6 - 10:22
 */
@Repository
public class ShopMemberCertifyDao {

    @Resource(name = "daoTemplate")
    private JdbcDaoTemplate daoTemplate;
    //@Autowired
    //private ShopMemberCompanyRetrofitApi shopMemberCompanyRetrofitApi;

    public ShopMemberDTO getShopMember(ShopMemberQuery query, String database) {
        final StringBuilder sql = new StringBuilder(64);
        sql.append("SELECT * FROM ").append(database).append(".shop_member WHERE 1=1");
        List<Object> values = Lists.newArrayList();
        if (StringUtils.isNotBlank(query.getMobile())) {
            sql.append(" AND mobile=?");
            values.add(query.getMobile());
        }
        if (StringUtils.isNotBlank(query.getOpenId())) {
            sql.append(" AND open_id=?");
            values.add(query.getOpenId());
        }
        if (query.getMemId() != null) {
            sql.append(" AND mem_id=?");
            values.add(query.getMemId());
        }
        if (query.getId() != null) {
            sql.append(" AND id=?");
            values.add(query.getId());
        }

        List<ShopMemberDTO> memberDTOS;
        if (Collections3.isNotEmpty(values)) {
            memberDTOS = this.daoTemplate.query(sql.toString(), values.toArray(new Object[values.size()]),
                    new ShopMemberRowMapper());
        } else {
            memberDTOS = this.daoTemplate.query(sql.toString(), new ShopMemberRowMapper());
        }

        return Collections3.isNotEmpty(memberDTOS) ? memberDTOS.get(0) : null;
    }

    public Integer saveShopMember(ShopMemberSave input, String database) {
        Map<String, Object> valueMap = Maps.newHashMap();
        valueMap.put("name", input.getName());
        valueMap.put("mobile", input.getMobile());
        valueMap.put("mem_id", input.getMemberId());
        valueMap.put("reg_date", DateUtils.formatDate(Constants.DATE_FORMAT_MINUTE));
        valueMap.put("active_date", valueMap.get("reg_date"));
        valueMap.put("status", input.getStatus().getState());
        valueMap.put("shop_no", input.getShopNo());
        valueMap.put("source", input.getSource());
        valueMap.put("hy_source", input.getHySource());

        return this.daoTemplate.saveEntityAndGetKey(database, "shop_member", valueMap);
    }

    public int updateShopMember(ShopMemberUpdate input, String database) {
        Map<String, Object> setMap = Maps.newHashMap();
        setMap.put("name", input.getName());
        setMap.put("mobile", input.getMobile());
        setMap.put("mem_id", input.getMemberId());
        setMap.put("active_date", DateUtils.getDateTime());
        setMap.put("status", input.getStatus().getState());
        setMap.put("customer_id", input.getCustomerId());
        setMap.put("customer_name", input.getCustomerName());
        setMap.put("shop_no", input.getShopNo());
        setMap.put("source", input.getSource());
        setMap.put("hy_source", input.getHySource());

        Map<String, Object> whereMap = Maps.newHashMap();
        whereMap.put("id", input.getId());
        return this.daoTemplate.updateEntity(database, "shop_member", setMap, whereMap);
    }

    private static class ShopMemberRowMapper implements RowMapper<ShopMemberDTO> {

        @Override
        public ShopMemberDTO mapRow(ResultSet rs, int rowNum) throws SQLException {
            ShopMemberDTO memberDTO = new ShopMemberDTO();
            memberDTO.setId(rs.getInt("id"));
            memberDTO.setName(rs.getString("name"));
            memberDTO.setMobile(rs.getString("mobile"));
            memberDTO.setMemberId(rs.getInt("mem_id"));
            memberDTO.setRegisterDate(rs.getString("reg_date"));
            memberDTO.setActiveDate(rs.getString("active_date"));
            memberDTO.setStatus(ShopMemberStatusEnum.getByState(rs.getInt("status")));
            memberDTO.setCustomerId(rs.getInt("customer_id"));
            memberDTO.setCustomerName(rs.getString("customer_name"));
            memberDTO.setShopNo(rs.getString("shop_no"));
            memberDTO.setSource(rs.getString("source"));
            memberDTO.setHySource(rs.getString("hy_source"));
            return memberDTO;
        }
    }

    public ShopMemberCompany getShopMemberCompany(Integer memberId, Integer companyId) {

        String sql = "select * from publicplat.sys_member_company where member_id=" + memberId + " and company_id=" + companyId;
        List<ShopMemberCompany> list = this.daoTemplate.queryForLists(sql,ShopMemberCompany.class);
        if(list.size() > 0)return list.get(0);
        return null;
//        com.qweib.cloud.service.member.domain.member.shop.ShopMemberCompanyDTO response = HttpResponseUtils.convertResponseNull(shopMemberCompanyRetrofitApi.getByMemberId(memberId, companyId));
//        if (response == null) {
//            return null;
//        }
//        ShopMemberCompanyDTO shopMemberCompanyDTO = BeanMapper.map(response, ShopMemberCompanyDTO.class);
//        return shopMemberCompanyDTO;
    }

    public Integer saveShopMemberCompany(ShopMemberCompanySave input) {
        //ShopMemberCompanyRequest request = BeanMapper.map(input, ShopMemberCompanyRequest.class);
        //return HttpResponseUtils.convertResponse(shopMemberCompanyRetrofitApi.save(request));
        return 1;
    }

    public Integer updateShopMemberCompany(ShopMemberCompanyUpdate input) {
        //ShopMemberCompanyRequest request = BeanMapper.map(input, ShopMemberCompanyRequest.class);
        //return HttpResponseUtils.convertResponse(shopMemberCompanyRetrofitApi.save(request));
        return 1;

    }
}
