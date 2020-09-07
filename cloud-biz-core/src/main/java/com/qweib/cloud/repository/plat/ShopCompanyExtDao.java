package com.qweib.cloud.repository.plat;

import com.qweib.cloud.core.dao.JdbcDaoTemplatePlud;
import com.qweib.cloud.core.domain.SysCompanyShopExt;
import com.qweib.cloud.core.domain.SysCorporation;
import com.qweib.cloud.repository.utils.HttpResponseUtils;
import com.qweib.cloud.service.member.domain.corporation.shop.CompanyShopExtDTO;
import com.qweib.cloud.service.member.domain.corporation.shop.CompanyShopExtQuery;
import com.qweib.cloud.service.member.retrofit.CompanyShopExtRetrofitApi;
import com.qweib.cloud.utils.Page;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.List;

@Repository
public class ShopCompanyExtDao {
    @Resource(name = "pdaoTemplate")
    private JdbcDaoTemplatePlud daoTemplate1;
//    @Resource
//    private CompanyShopExtRetrofitApi companyShopExtRetrofitApi;

    /**
     * 商城列表
     *
     * @param corporation
     * @param pageNo
     * @param limit
     * @return
     */
    public Page queryCorporationShopExt(SysCorporation corporation, Integer pageNo, Integer limit) {
        String sql = "select * from publicplat.sys_company_shop_ext where is_show=1 ";
        return this.daoTemplate1.queryForPageByMySql(sql,pageNo,limit,CompanyShopExtDTO.class);
//        CompanyShopExtQuery query = new CompanyShopExtQuery();
//        query.setExcludeMemberId(corporation.getExcludeMemberId());
//        query.setShopName(corporation.getDeptNm());
//        com.qweibframework.commons.page.Page<CompanyShopExtDTO> httpPage = HttpResponseUtils.convertResponse(companyShopExtRetrofitApi.query(pageNo - 1, limit, query));
//        final Page page = new Page();
//        page.setPageSize(limit);
//        page.setCurPage(httpPage.getPage() + 1);
//        page.setRows(httpPage.getData());
//        page.setTotal((int) httpPage.getTotalCount());
//        return page;
        //return null;
    }

    public Page queryCorporationShopExt1(SysCorporation corporation, Integer pageNo, Integer limit) {
        String sql = "select * from publicplat.sys_company_shop_ext where is_show=1 ";
        return this.daoTemplate1.queryForPageByMySql(sql,pageNo,limit, SysCompanyShopExt.class);
//        CompanyShopExtQuery query = new CompanyShopExtQuery();
//        query.setExcludeMemberId(corporation.getExcludeMemberId());
//        query.setShopName(corporation.getDeptNm());
//        com.qweibframework.commons.page.Page<CompanyShopExtDTO> httpPage = HttpResponseUtils.convertResponse(companyShopExtRetrofitApi.query(pageNo - 1, limit, query));
//        final Page page = new Page();
//        page.setPageSize(limit);
//        page.setCurPage(httpPage.getPage() + 1);
//        page.setRows(httpPage.getData());
//        page.setTotal((int) httpPage.getTotalCount());
//        return page;
        //return null;
    }



    /**
     * 用户所属企业列表
     *
     * @param memberId
     * @return
     */
    public List<CompanyShopExtDTO> queryMySysCompany(Integer memberId) {
        String sql = "select * from publicplat.sys_company_shop_ext ";
        return this.daoTemplate1.queryForLists(sql,CompanyShopExtDTO.class);
//        List<CompanyShopExtDTO> resultList = HttpResponseUtils.convertResponse(companyShopExtRetrofitApi.queryMySysCompany(memberId));
//        return resultList;

    }

    /**
     * 用户所属企业列表
     *
     * @param companyId
     * @return
     */
    public CompanyShopExtDTO get(Integer companyId) {
        String sql = "select * from publicplat.sys_company_shop_ext where company_id=" + companyId;
        List<CompanyShopExtDTO> list = this.daoTemplate1.queryForLists(sql,CompanyShopExtDTO.class);
        if(list.size() > 0)return list.get(0);
        return null;
        //return HttpResponseUtils.convertResponse(companyShopExtRetrofitApi.getOne(companyId));

    }
}

