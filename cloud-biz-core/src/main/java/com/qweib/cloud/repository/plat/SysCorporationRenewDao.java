package com.qweib.cloud.repository.plat;

import com.qweib.cloud.core.dao.JdbcDaoTemplatePlud;
import com.qweib.cloud.core.domain.SysCorporationRenew;
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
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.List;
import java.util.StringJoiner;

@Deprecated
@Repository
public class SysCorporationRenewDao {

    @Resource(name = "pdaoTemplate")
    private JdbcDaoTemplatePlud pdaoTemplate;


    /**
     * 说明：分页查询公司续费记录
     *
     * @创建：作者:llp 创建时间：2016-7-20
     * @修改历史： [序号](llp 2016 - 7 - 20)<修改说明>
     */
    public Page queryCorporationRenew(SysCorporationRenew corporationRenew, Integer pageNo, Integer limit) {
        StringBuilder sql = new StringBuilder();
        sql.append(" select a.* from sys_corporation_renew a where 1=1 ");
        if (null != corporationRenew) {
            if (!StrUtil.isNull(corporationRenew.getDeptNm())) {
//                SysCorporationSelectedQuery query = new SysCorporationSelectedQuery();
//                query.setQueryType(CorporationSelectQueryEnum.NAME);
//                query.setName(corporationRenew.getDeptNm());
//                List<SysCorporationSelectedDTO> selectedDTOS = HttpResponseUtils.convertResponse(corporationRequest.select(query));
//                if (com.qweib.commons.Collections3.isEmpty(selectedDTOS)) {
//                    return new Page();
//                }
//                StringJoiner whereSql = new StringJoiner(",", "(", ")");
//                for (SysCorporationSelectedDTO selectedDTO : selectedDTOS) {
//                    whereSql.add(selectedDTO.getId().toString());
//                }
                //sql.append(" and a.depts_id IN ").append(whereSql.toString());
            }
            if (!StrUtil.isNull(corporationRenew.getRenewTime())) {
                sql.append(" and a.renew_time='" + corporationRenew.getRenewTime() + "' ");
            }
        }
        sql.append(" order by a.id desc ");
        try {
            Page page = this.pdaoTemplate.queryForPageByMySql(sql.toString(), pageNo, limit, SysCorporationRenew.class);
//            List<SysCorporationRenew> rows = page.getRows();
//            if (Collections3.isNotEmpty(rows)) {
//                for (SysCorporationRenew row : rows) {
//                    if (row.getMemberId() != null) {
//                        SysMemberDTO memberDTO = HttpResponseUtils.convertResponseNull(memberRequest.get(row.getMemberId()));
//                        if (memberDTO != null) {
//                            row.setMemberNm(memberDTO.getName());
//                        }
//                    }
//                    if (row.getDeptsId() != null) {
//                        SysCorporationDTO corporationDTO = HttpResponseUtils.convertResponseNull(corporationRequest.get(row.getDeptsId()));
//                        if (corporationDTO != null) {
//                            row.setDeptNm(corporationDTO.getName());
//                        }
//                    }
//                }
//            }

            return page;
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明： 添加公司续费记录
     *
     * @创建：作者:llp 创建时间：2016-7-20
     * @修改历史： [序号](llp 2016 - 7 - 20)<修改说明>
     */
    public Integer addCompanyRenew(SysCorporationRenew corporationRenew) {
        try {
            return pdaoTemplate.addByObject("sys_corporation_renew", corporationRenew);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }
}
