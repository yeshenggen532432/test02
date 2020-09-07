package com.qweib.cloud.repository.plat;

import com.google.common.collect.Lists;
import com.qweib.cloud.core.dao.JdbcDaoTemplatePlud;
import com.qweib.cloud.core.domain.ShopMemberCompany;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.repository.utils.HttpResponseUtils;
import com.qweib.cloud.service.member.domain.member.shop.ShopMemberCompanyDTO;
import com.qweib.cloud.service.member.domain.member.shop.ShopMemberCompanyFullRequest;
import com.qweib.cloud.service.member.domain.member.shop.ShopMemberCompanyPageQuery;
import com.qweib.cloud.service.member.retrofit.ShopMemberCompanyRetrofitApi;
import com.qweib.cloud.utils.Collections3;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import com.qweib.commons.mapper.BeanMapper;
import com.qweibframework.commons.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Repository
public class ShopMemberCompanyDao {
    @Resource(name = "pdaoTemplate")
    private JdbcDaoTemplatePlud daoTemplate1;
//    @Autowired
//    private ShopMemberCompanyRetrofitApi shopMemberCompanyRetrofitApi;


    public Page queryShopMemberCompany(ShopMemberCompany member, Integer page, Integer limit) {

        String sql="select a.*,b.shop_logo,b.shop_name from publicplat.shop_member_company a join publicplat.sys_company_shop_ext b on a.company_id=b.company_id  where 1 = 1 ";
        if(member!= null)
        {
            if(member.getMemberId()!= null)sql += " and a.member_id=" + member.getMemberId();
            if(member.getCompanyId()!= null)sql += " and a.company_id=" + member.getCompanyId();
            if(!StrUtil.isNull(member.getMemberCompany()))sql += " and a.member_company like '%" + member.getMemberCompany() + "%'";
        }
        return this.daoTemplate1.queryForPageByMySql(sql,page,limit,ShopMemberCompany.class);

//        ShopMemberCompanyPageQuery query = new ShopMemberCompanyPageQuery();
//        query.setCompany(member.getMemberCompany());
//        query.setMember(member.getMemberNm());
//        query.setCompanyId(member.getCompanyId());
//        query.setMemberId(member.getMemberId());
//        query.setExcludeOut(StringUtils.isNotEmpty(member.getOutTime()));
//        query.setMobile(member.getMemberMobile());
//        com.qweibframework.commons.page.Page<ShopMemberCompanyDTO> pageResult = HttpResponseUtils.convertResponseNull(shopMemberCompanyRetrofitApi.query(page, limit, query));
//        Page pageDTO = new Page();
//        pageDTO.setCurPage(page);
//        pageDTO.setPageSize(limit);
//        if (pageResult != null) {
//            List<ShopMemberCompanyDTO> data = pageResult.getData();
//            if (Collections3.isNotEmpty(data)) {
//                List<ShopMemberCompany> list = data.stream().map(item ->
//                        {
//                            ShopMemberCompany smc = BeanMapper.map(item, ShopMemberCompany.class);
//                            smc.setFdId(item.getId());
//                            smc.setMemberNm(item.getMemberName());
//                            return smc;
//                        }
//                ).collect(Collectors.toList());
//                pageDTO.setRows(list);
//            }
//            pageDTO.setTotalPage(pageResult.getTotalPages());
//            pageDTO.setTotal((int) pageResult.getTotalCount());
//        }
//        return pageDTO;

    }

    public Integer addShopMemberCompany(ShopMemberCompany member) {
        try {
//            ShopMemberCompanyFullRequest request = BeanMapper.map(member, ShopMemberCompanyFullRequest.class);
//            request.setMemberName(member.getMemberNm());
//            request.setId(member.getFdId());
//            return HttpResponseUtils.convertResponse(shopMemberCompanyRetrofitApi.save(request));

            Integer memId = this.daoTemplate1.addByObject("publicplat.shop_member_company", member);
            return memId;
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public void updateShopMemberCompany(ShopMemberCompany member) {
        try {
            Map<String, Object> whereParam = new HashMap<String, Object>();
            whereParam.put("fd_id", member.getFdId());
            this.daoTemplate1.updateByObject("shop_member_company", member, whereParam, "fd_id");
//            ShopMemberCompanyFullRequest request = BeanMapper.map(member, ShopMemberCompanyFullRequest.class);
//            request.setId(member.getFdId());
//            request.setMemberName(member.getMemberNm());
//            request.setId(member.getFdId());
//            HttpResponseUtils.convertResponse(shopMemberCompanyRetrofitApi.save(request));
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public ShopMemberCompany queryShopMemberCompanyById(Integer id) {
        String sql = "select * from publicplat.sys_member_company where fd_id=" + id;
        List<ShopMemberCompany> list = this.daoTemplate1.queryForLists(sql,ShopMemberCompany.class);
        if(list.size() > 0)return list.get(0);
        return null;
//        ShopMemberCompanyDTO dto = HttpResponseUtils.convertResponse(shopMemberCompanyRetrofitApi.getById(id));
//        ShopMemberCompany smc = BeanMapper.map(dto, ShopMemberCompany.class);
//        smc.setFdId(dto.getId());
//        smc.setMemberNm(dto.getMemberName());
//        return smc;
    }

    public List<ShopMemberCompany> queryShopMemberCompanyList(ShopMemberCompany member) {
        try {
            String sql = "select a.* from shop_member_company a where 1=1 ";
            if (member != null) {
                if (!StrUtil.isNull(member.getMemberId())) {
                    sql = sql + " and a.member_id=" + member.getMemberId();
                }
                if (!StrUtil.isNull(member.getCompanyId())) {
                    sql = sql + " and a.company_id=" + member.getCompanyId();
                }
                if (!StrUtil.isNull(member.getMemberMobile())) {
                    sql = sql + " and a.member_mobile='" + member.getMemberMobile() + "'";
                }
                if (!StrUtil.isNull(member.getOutTime())) {
                    sql = sql + " and (a.out_time is null or a.out_time ='')";
                }
            }
//            List<ShopMemberCompanyDTO> result = HttpResponseUtils.convertResponse(shopMemberCompanyRetrofitApi.listAll(member.getMemberId(),
//                    member.getCompanyId(), member.getMemberMobile(),
//                    StringUtils.isNotEmpty(member.getOutTime()) ? true : null));
//            if (Collections3.isNotEmpty(result)) {
//                return result.stream().map(dto -> {
//                    ShopMemberCompany smc = BeanMapper.map(dto, ShopMemberCompany.class);
//                    smc.setMemberNm(dto.getMemberName());
//                    smc.setFdId(dto.getId());
//                    return smc;
//                }).collect(Collectors.toList());
//            }
//            return Lists.newArrayList();
            List<ShopMemberCompany> list = this.daoTemplate1.queryForLists(sql, ShopMemberCompany.class);
            return list;
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }


    public int queryShopMemberCompanyByTel(String tel) {
        String sql = " select count(1) from shop_member_company where member_mobile=? ";
        try {
            return this.daoTemplate1.queryForObject(sql, new Object[]{tel}, Integer.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

}

