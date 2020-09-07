package com.qweib.cloud.repository.plat.ws;

import com.google.common.collect.Lists;
import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.dao.JdbcDaoTemplatePlud;
import com.qweib.cloud.core.domain.SearchModel;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.repository.utils.HttpResponseUtils;
import com.qweib.cloud.service.member.common.CorporationSelectQueryEnum;
import com.qweib.cloud.service.member.common.MemberSelectQueryEnum;
import com.qweib.cloud.service.member.domain.corporation.SysCorporationDTO;
import com.qweib.cloud.service.member.domain.corporation.SysCorporationSelectedDTO;
import com.qweib.cloud.service.member.domain.corporation.SysCorporationSelectedQuery;
import com.qweib.cloud.service.member.domain.member.SysMemberSelectDTO;
import com.qweib.cloud.service.member.domain.member.SysMemberSelectQuery;
import com.qweib.cloud.service.member.retrofit.SysCorporationRequest;
import com.qweib.cloud.service.member.retrofit.SysMemberRequest;
import com.qweib.cloud.utils.Collections3;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;
import reactor.core.publisher.Flux;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.List;

@Repository
public class SearchWebDao {

    @Resource(name = "pdaoTemplate")
    private JdbcDaoTemplatePlud pdaoTemplate;
    @Resource(name = "daoTemplate")
    private JdbcDaoTemplate daoTemplate;
//    @Qualifier("memberRequest")
//    @Autowired
//    private SysMemberRequest memberRequest;
//    @Qualifier("corporationRequest")
//    @Autowired
//    private SysCorporationRequest corporationRequest;

    /**
     * 查询公共平台上人员和公司
     *
     * @param searchContent
     * @return
     * @创建：作者:YYP 创建时间：2015-3-9
     */
    public List<SearchModel> queryMemOrCompany(String searchContent, Integer memId) {
        StringBuilder sql = new StringBuilder(256);
        sql.append("SELECT m.member_id as belongId,m.member_nm as nm,m.member_head as headUrl,1 as tp,c.datasource as datasource,")
                .append(" (CASE WHEN ")
                .append("(SELECT count(1) FROM sys_mem_bind mb")
                .append(" WHERE (mb.member_id=").append(memId).append(" AND mb.bind_member_id=m.member_id)")
                .append(" OR ")
                .append("(mb.member_id=m.member_id AND mb.bind_member_id=").append(memId).append("))>0")
                .append(" THEN 1 ELSE 2 END) AS whetherIn ");
        sql.append(" FROM sys_member m")
                .append(" LEFT JOIN sys_corporation c ON m.unit_id=c.dept_id")
                .append(" WHERE m.member_mobile like '%").append(searchContent).append("%'")
                .append(" OR m.member_nm like'%").append(searchContent).append("%'")
                .append(" OR m.member_name like '%").append(searchContent).append("%'");
        sql.append(" UNION ALL ");
        sql.append("SELECT dept_id as belongId,dept_nm as nm,dept_head as headUrl,2 as tp,null as whetherIn,null as datasource FROM sys_corporation")
                .append(" WHERE dept_nm like '%").append(searchContent).append("%' AND dept_pid=0");
        try {
            return pdaoTemplate.queryForLists(sql.toString(), SearchModel.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }

//        List<SearchModel> list = new ArrayList<SearchModel>();
//        SysMemberSelectQuery memberQuery = new SysMemberSelectQuery();
//        memberQuery.setQueryType(MemberSelectQueryEnum.KEYWORD);
//        memberQuery.setKeyword(searchContent);
//        List<SysMemberSelectDTO> memberSelectDTOS = HttpResponseUtils.convertResponse(memberRequest.select(memberQuery));
//
//        if (Collections3.isNotEmpty(memberSelectDTOS)) {
//            Flux.fromIterable(memberSelectDTOS)
//                    .map(memberSelectDTO -> {
//                        SearchModel searchModel = new SearchModel();
//                        searchModel.setBelongId(memberSelectDTO.getId());
//                        searchModel.setNm(memberSelectDTO.getName());
//                        searchModel.setHeadUrl(memberSelectDTO.getHead());
//                        searchModel.setTp("1");
//
//                        if (memberSelectDTO.getCompanyId() != null) {
//                            SysCorporationDTO corporationDTO = HttpResponseUtils.convertResponse(corporationRequest.get(memberSelectDTO.getCompanyId()));
//                            if (corporationDTO != null) {
//                                searchModel.setDatasource(corporationDTO.getDatabase());
//                            }
//                        }
//
//                        return searchModel;
//                    })
//                    .map(searchModel -> {
//                        Integer whetherIn = queryMemOrCompany(memId, searchModel.getBelongId());
//                        searchModel.setWhetherIn(whetherIn);
//                        return searchModel;
//                    }).subscribe(searchModel -> list.add(searchModel));
//        }
//
//        SysCorporationSelectedQuery companyQuery = new SysCorporationSelectedQuery();
//        companyQuery.setQueryType(CorporationSelectQueryEnum.KEYWORD);
//        companyQuery.setKeyword(searchContent);
//
//        List<SysCorporationSelectedDTO> companySelectDTOS = HttpResponseUtils.convertResponse(corporationRequest.select(companyQuery));
//        if (Collections3.isNotEmpty(companySelectDTOS)) {
//            Flux.fromIterable(companySelectDTOS)
//                    .map(selectedDTO -> {
//                        SearchModel searchModel = new SearchModel();
//                        searchModel.setBelongId(selectedDTO.getId());
//                        searchModel.setNm(selectedDTO.getName());
//                        searchModel.setHeadUrl(selectedDTO.getHead());
//                        searchModel.setTp("2");
//                        searchModel.setDatasource(selectedDTO.getDatabase());
//                        return searchModel;
//                    })
//                    .subscribe(searchModel -> list.add(searchModel));
//        }
//
//        return list;
    }

    public Integer queryMemOrCompany(Integer memId, Integer memberId) {
        Integer count = pdaoTemplate.queryForObject("SELECT count(1) FROM sys_mem_bind mb" +
                " WHERE (mb.member_id=" + memId + " AND mb.bind_member_id = " + memberId
                + ") OR ("
                + "mb.member_id=" + memberId + " AND mb.bind_member_id=" + memId + ")", Integer.class);
        return count > 0 ? 1 : 2;
    }

    /**
     * 查询公共平台上人员
     *
     * @param searchContent
     * @param memId
     * @return
     * @创建：作者:YYP 创建时间：2015-3-16
     */
    public List querypMem(String searchContent, Integer memId) {
        StringBuilder sql = new StringBuilder(128)
                .append("SELECT m.member_id as belongId,m.member_nm as nm,m.member_head as headUrl,1 as tp,c.datasource as datasource, ")
                .append("(case when (select count(1) from sys_mem_bind mb where (mb.member_id=").append(memId).append(" and mb.bind_member_id=m.member_id) ")
                .append(" )>0 then 1 else 2 end)as whetherIn ");
        sql.append(" FROM sys_member m LEFT JOIN sys_corporation c ON m.unit_id=c.dept_id")
                .append(" WHERE m.member_mobile like '%").append(searchContent).append("%' or m.member_nm like'%")
                .append(searchContent).append("%' or m.member_name like '%").append(searchContent).append("%' order by m.member_creatime desc ");
        try {
            return pdaoTemplate.queryForLists(sql.toString(), SearchModel.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
//        SysMemberSelectQuery query = new SysMemberSelectQuery();
//        query.setQueryType(MemberSelectQueryEnum.KEYWORD);
//        query.setKeyword(searchContent);
//        List<SysMemberSelectDTO> memberDTOS = HttpResponseUtils.convertResponse(memberRequest.select(query));
//        List<SearchModel> memList = Lists.newArrayList();
//        if (Collections3.isNotEmpty(memberDTOS)) {
//            Flux.fromIterable(memberDTOS)
//                    .map(memberDTO -> {
//                        SearchModel searchModel = new SearchModel();
//                        searchModel.setBelongId(memberDTO.getId());
//                        searchModel.setNm(memberDTO.getName());
//                        searchModel.setHeadUrl(memberDTO.getHead());
//                        searchModel.setTp("1");
//
//                        if (memberDTO.getCompanyId() != null) {
//                            SysCorporationDTO corporationDTO = HttpResponseUtils.convertResponse(corporationRequest.get(memberDTO.getCompanyId()));
//                            if (corporationDTO != null) {
//                                searchModel.setDatasource(corporationDTO.getDatabase());
//                            }
//                        }
//
//                        return searchModel;
//                    })
//                    .map(searchModel -> {
//                        Integer whetherIn = querypMem(memId, searchModel.getBelongId());
//                        searchModel.setWhetherIn(whetherIn);
//                        return searchModel;
//                    })
//                    .subscribe(searchModel -> memList.add(searchModel));
//        }
//
//        return memList;
    }

    public Integer querypMem(Integer memId, Integer memberId) {
        Integer count = pdaoTemplate.queryForObject("select count(1) from sys_mem_bind mb where (mb.member_id=" + memId + " and mb.bind_member_id=" + memberId, Integer.class);
        return count > 0 ? 1 : 2;
    }

    /**
     * 查询企业平台上的部门
     *
     * @param searchContent
     * @param database
     * @return
     * @创建：作者:YYP 创建时间：2015-3-16
     */
    public List<SearchModel> querycDept(String searchContent,
                                        String database) {
        StringBuffer sql = new StringBuffer(" select wd.branch_id as belongId,wd.branch_name as nm,wd.branch_path as headUrl,3 as tp,null as datasource from ")
                .append(database).append(".sys_depart wd where wd.branch_name like '%").append(searchContent).append("%' order by belongId desc ");
        try {
            return daoTemplate.queryForLists(sql.toString(), SearchModel.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 查询是否部门下成员
     *
     * @param branchPath
     * @param memId
     * @param database
     * @return
     * @创建：作者:YYP 创建时间：2015-3-19
     */
    public Integer queryIfIndept(String branchPath,
                                 Integer memId, String database) {
        StringBuffer sql = new StringBuffer("select (case when count(1)>0 then 1 else 2 end) as count from ").append(database).append(".sys_mem m ");
        sql.append(" left join ").append(database).append(".sys_depart b on m.branch_id=b.branch_id where b.branch_path like '").append(branchPath).append("%' and m.member_id=").append(memId);
        try {
            return daoTemplate.queryForObject(sql.toString(), Integer.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }
}
