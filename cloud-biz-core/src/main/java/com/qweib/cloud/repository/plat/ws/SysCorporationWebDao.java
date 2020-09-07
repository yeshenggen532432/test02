package com.qweib.cloud.repository.plat.ws;

import com.google.common.collect.Lists;
import com.qweib.cloud.core.dao.JdbcDaoTemplatePlud;
import com.qweib.cloud.core.domain.SysCorporation;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.repository.utils.HttpResponseUtils;
import com.qweib.cloud.service.member.common.CorporationSelectQueryEnum;
import com.qweib.cloud.service.member.domain.corporation.SysCorporationDTO;
import com.qweib.cloud.service.member.domain.corporation.SysCorporationSelectedDTO;
import com.qweib.cloud.service.member.domain.corporation.SysCorporationSelectedQuery;
import com.qweib.cloud.service.member.domain.member.SysMemberDTO;
import com.qweib.cloud.service.member.retrofit.SysCorporationRequest;
import com.qweib.cloud.service.member.retrofit.SysMemberRequest;
import com.qweib.cloud.utils.Collections3;
import org.dozer.Mapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.List;

@Repository
public class SysCorporationWebDao {

    @Resource(name = "pdaoTemplate")
    private JdbcDaoTemplatePlud daoTemplate;

    @Autowired
    private Mapper mapper;

    /**
     * 根据id查询公司所有信息
     */
    public SysCorporation queryCorporationById(Integer memberId) {
        String sql = "select c.* from sys_corporation c where c.dept_id=(select m.unit_id from sys_member m where m.member_id=?)";
        try {
            return daoTemplate.queryForObj(sql, SysCorporation.class, memberId);
        } catch (Exception e) {
            throw new DaoException(e);
        }

//        SysMemberDTO memberDTO = HttpResponseUtils.convertResponse(memberRequest.get(memberId));
//        if (memberDTO == null || memberDTO.getCompanyId() == null) {
//            return null;
//        }
//        SysCorporationDTO corporationDTO = HttpResponseUtils.convertResponse(corporationRequest.get(memberDTO.getCompanyId()));
//        if (corporationDTO == null) {
//            return null;
//        }
//
//        return mapper.map(corporationDTO, SysCorporation.class);
    }

    //模糊查询公司
    public List<SysCorporation> queryCorporationByLikeNm(String content) {
        String sql = "select dept_id,dept_nm,datasource,dept_head from sys_corporation where dept_nm like '%" + content + "%' ";
        try {
            return daoTemplate.queryForLists(sql, SysCorporation.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }

//        List<SysCorporation> result = Lists.newArrayList();
//        SysCorporationSelectedQuery query = new SysCorporationSelectedQuery();
//        query.setQueryType(CorporationSelectQueryEnum.NAME);
//        query.setName(content);
//        List<SysCorporationSelectedDTO> selectedDTOS = HttpResponseUtils.convertResponse(corporationRequest.select(query));
//        if (Collections3.isNotEmpty(selectedDTOS)) {
//            for (SysCorporationSelectedDTO selectedDTO : selectedDTOS) {
//                SysCorporation corporation = new SysCorporation();
//                corporation.setDeptId(selectedDTO.getId().longValue());
//                corporation.setDeptNm(selectedDTO.getName());
//                corporation.setDeptHead(selectedDTO.getHead());
//                corporation.setDatasource(selectedDTO.getDatabase());
//                result.add(corporation);
//            }
//        }
//
//        return result;
    }

    /**
     * 根据datasource查询公司信息
     *
     * @param datasource
     * @return
     * @创建：作者:YYP 创建时间：2015-5-25
     */
    public SysCorporation queryCompanyByDatasource(String datasource) {
        String sql = "select * from sys_corporation where datasource='" + datasource + "' ";
        try {
            return daoTemplate.queryForObj(sql, SysCorporation.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }

        //return HttpResponseUtils.convertToEntity(corporationRequest.getByDatabase(datasource), SysCorporation.class, mapper);
    }
}
