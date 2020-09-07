package com.qweib.cloud.repository.plat;

import com.google.common.collect.Lists;
import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.dao.JdbcDaoTemplatePlud;
import com.qweib.cloud.core.domain.SysCorporation;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.repository.utils.HttpResponseUtils;
import com.qweib.cloud.service.member.common.CorporationSelectQueryEnum;
import com.qweib.cloud.service.member.common.CorporationUpdatePropertyEnum;
import com.qweib.cloud.service.member.domain.corporation.*;
import com.qweib.cloud.service.member.retrofit.SysCorporationRequest;
import com.qweib.cloud.service.member.retrofit.SysMemberRequest;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import com.qweib.commons.Collections3;
import com.qweibframework.commons.StringUtils;
import org.dozer.Mapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Repository
public class SysCorporationDao {
    @Resource(name = "daoTemplate")
    private JdbcDaoTemplate daoTemplate;

    @Resource(name = "pdaoTemplate")
    private JdbcDaoTemplatePlud pdaoTemplate;


//    @Qualifier("memberRequest")
//    @Autowired
//    private SysMemberRequest memberRequest;
//    @Qualifier("corporationRequest")
//    @Autowired
//    private SysCorporationRequest corporationRequest;

    @Autowired
    private Mapper mapper;

    /**
     * 说明：分页查询公司
     *
     * @创建：作者:llp 创建时间：2015-2-5
     * @修改历史： [序号](llp 2015 - 2 - 5)<修改说明>
     */
    public Page queryCorporation(SysCorporation corporation, Integer pageNo, Integer limit) {
        StringBuilder sql = new StringBuilder();
        sql.append(" select c.dept_id,c.dept_nm,c.dept_num,c.dept_addr,c.dept_phone,c.datasource,c.dept_trade,c.add_time,c.member_id,c.end_date,c.tp_nm,m.member_nm from sys_corporation c left join sys_member m on c.member_id=m.member_id where 1=1 ");
        if (null != corporation) {
            if (!StrUtil.isNull(corporation.getDeptNm())) {
                sql.append(" and dept_nm like '%" + corporation.getDeptNm() + "%' ");
            }
        }
        sql.append(" order by dept_id desc ");
        try {
            return this.pdaoTemplate.queryForPageByMySql(sql.toString(), pageNo, limit, SysCorporation.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }

//        try {
//            SysCorporationQuery query = new SysCorporationQuery();
//            if (corporation != null) {
//                if (StringUtils.isNotBlank(corporation.getDeptNm()))
//                    query.setName(corporation.getDeptNm());
//                if (corporation.getExcludeMemberId() != null)
//                    query.setExcludeMemberId(corporation.getExcludeMemberId());
//                if (corporation.getShopOpen() != null)
//                    query.setShopOpen(corporation.getShopOpen());
//
//            }
//            com.qweibframework.commons.page.Page<SysCorporationDTO> httpPage = HttpResponseUtils.convertResponse(this.corporationRequest.page(query, pageNo - 1, limit));
//            final Page page = new Page();
//            page.setPageSize(limit);
//            page.setCurPage(httpPage.getPage() + 1);
//            final List<SysCorporation> dataList = Lists.newArrayList();
//            if (Collections3.isNotEmpty(httpPage.getData())) {
//                for (SysCorporationDTO corporationDTO : httpPage.getData()) {
//                    SysCorporation sysCorporation = mapper.map(corporationDTO, SysCorporation.class);
//                    dataList.add(sysCorporation);
//                }
//            }
//            page.setRows(dataList);
//            page.setTotal((int) httpPage.getTotalCount());
//
//            return page;
//        } catch (Exception e) {
//            throw new ServiceException(e);
//        }
    }

    /**
     * 说明：获取公司
     *
     * @创建：作者:llp 创建时间：2015-2-2
     * @修改历史： [序号](llp 2015 - 2 - 2)<修改说明>
     */
    public SysCorporation queryCorporationById(Integer id) {
		try{
			String sql = "select * from sys_corporation where dept_id=? ";
			return this.pdaoTemplate.queryForObj(sql, SysCorporation.class,id);
		} catch (Exception e) {
			throw new DaoException(e);
		}

//        try {
//            SysCorporationDTO corporationDTO = HttpResponseUtils.convertResponse(this.corporationRequest.get(id));
//            return mapper.map(corporationDTO, SysCorporation.class);
//        } catch (Exception e) {
//            throw new ServiceException(e);
//        }
    }

    public SysCorporation get(Integer id) {
        String sql = "select * from publicplat.sys_corporation where deptId=" + id.toString();
        List<SysCorporation> list = this.daoTemplate.queryForLists(sql,SysCorporation.class);
        if(list.size() > 0)return list.get(0);
        return null;
    }

//    public Optional<SysCorporationDTO> getCompany(Integer id) {
//        return Optional.ofNullable(HttpResponseUtils.convertResponseNull(this.corporationRequest.get(id)));
//    }

    /**
     * 说明：根据数据库查公司
     *
     * @创建：作者:llp 创建时间：2015-2-5
     * @修改历史： [序号](llp 2015 - 2 - 5)<修改说明>
     */
    public SysCorporation queryCorporationBydata(String datasource) {
		try{
			String sql = "select * from sys_corporation where datasource=?";
			return this.pdaoTemplate.queryForObj(sql, SysCorporation.class,datasource);
		} catch (Exception e) {
			throw new DaoException(e);
		}

//        try {
//            SysCorporationDTO corporationDTO = HttpResponseUtils.convertResponse(corporationRequest.getByDatabase(datasource));
//            return mapper.map(corporationDTO, SysCorporation.class);
//        } catch (Exception e) {
//            throw new ServiceException(e);
//        }
    }

    /**
     * 说明：查询所有公司
     *
     * @创建：作者:zrp 创建时间：2015-2-5
     * @修改历史： [序号](zrp 2015 - 2 - 5)<修改说明>
     */
    public List<String> queryCorpAll() {
		try{
			String sql = "select * from sys_corporation";
			return this.pdaoTemplate.queryForLists(sql, SysCorporation.class);
		} catch (Exception e) {
			throw new DaoException(e);
		}

        //return HttpResponseUtils.convertResponse(corporationRequest.findAllDatabase());
    }

    /**
     * 创建公司
     *
     * @param company
     * @创建：作者:YYP 创建时间：2015-3-13
     */
    public Integer addCompany(SysCorporation company) {
        try {
            return pdaoTemplate.addByObject("sys_corporation", company);

        } catch (Exception e) {
            throw new DaoException(e);
        }

        //SysCorporationSave corporationSave = mapper.map(company, SysCorporationSave.class);
        //return HttpResponseUtils.convertResponse(corporationRequest.save(corporationSave));
    }
//	public Integer getAutoId() {
//		try{
//			return pdaoTemplate.getAutoIdForIntByMySql();
//		} catch (Exception e) {
//			throw new DaoException(e);
//		}
//	}

    /**
     * 删除公司
     *
     * @param deptId
     * @创建：作者:YYP 创建时间：2015-3-18
     */
    public Integer deleteCorporation(Integer deptId) {
		String sql = "delete from sys_corporation where dept_id="+deptId;
		try{
			return pdaoTemplate.update(sql);
		} catch (Exception e) {
			throw new DaoException(e);
		}

        //Boolean result = HttpResponseUtils.convertResponse(corporationRequest.delete(deptId));
        //return result ? 1 : 0;
    }

    /**
     * 删除数据库
     *
     * @param datasource
     * @创建：作者:YYP 创建时间：2015-3-18
     */
    public void deleteDB(String datasource) {
        String sql = "drop database " + datasource;
        try {
            daoTemplate.update(sql);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 查询公司是否已经出现
     *
     * @param deptNm
     * @return
     * @创建：作者:YYP 创建时间：2015-3-19
     */
    public Integer queryIsExit(String deptNm) {
        String sql = "select count(1) from sys_corporation where dept_nm='" + deptNm + "' ";
        try {
            return pdaoTemplate.queryForObject(sql, Integer.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }

//        try {
//            SysCorporationDTO corporationDTO = HttpResponseUtils.convertResponseNull(corporationRequest.getByName(deptNm));
//            return corporationDTO != null ? 1 : 0;
//        } catch (Exception e) {
//            throw new ServiceException(e);
//        }
    }
//	/**
//	 * 查询成员对应的公司信息
//	  *@param memId
//	  *@return
//	  *@创建：作者:YYP		创建时间：2015-3-20
//	 */
	public SysCorporation queryMemCompany(Integer memId) {
		String sql = "select c.dept_id,c.dept_nm,m.member_nm from sys_corporation c left join sys_member m on c.dept_id=m.unit_id where member_id="+memId;
		try{
			return pdaoTemplate.queryForObj(sql,SysCorporation.class);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	public void updateCompany(String dataSource, Integer id) {
		String sql = "update sys_corporation set datasource='"+dataSource+"' where dept_id="+id;
		try{
			pdaoTemplate.update(sql);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}

    /**
     * 根据会员id查询数据库名称
     *
     * @param memberId
     * @author guojp
     */
    public SysCorporation queryDatabaseByMid(Integer memberId) {
        String sql = "select c.datasource from sys_corporation c LEFT JOIN sys_member m ON m.unit_id=c.dept_id where m.member_id=?";
        try {
            return pdaoTemplate.queryForObj(sql, SysCorporation.class, memberId);
        } catch (DaoException e) {
            throw new DaoException(e);
        }
    }

    //修改公司名称
    public void updateCompanyNm(String companyNm, Integer companyId) {
        String sql = "update sys_corporation set dept_nm='" + companyNm + "' where dept_id=" + companyId;
        try {
             pdaoTemplate.update(sql);
        } catch (DaoException e) {
            throw new DaoException(e);
        }

        //HttpResponseUtils.convertResponse(corporationRequest.updateName(companyId, companyNm));
    }

    //修改公共平台上的公司名
    public void updateMemCompanyNm2(Integer companyId, String companyNm) {
        String sql = "update sys_member set member_company='" + companyNm + "' where unit_id=" + companyId;
        try {
            pdaoTemplate.update(sql);
        } catch (Exception e) {
            throw new DaoException(e);
        }
        //HttpResponseUtils.convertResponse(memberRequest.updateCompany(companyId, companyNm));
    }

    //修改企业平台上的公司名
    public void updateMemCompanyNm(Integer companyId, String companyNm,
                                   String datasource) {
        String sql = "update " + datasource + ".sys_mem set member_company='" + companyNm + "' where unit_id=" + companyId;
        try {
            daoTemplate.update(sql);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 模糊查询公司
     *
     * @param searchNm
     * @创建：作者:YYP 创建时间：2015-5-23
     */
    public List<SysCorporation> queryLikeCompanyNm(String searchNm) {
        String sql = "select dept_id,dept_nm from sys_corporation where dept_nm like '%" + searchNm + "%' ";
        try {
            return pdaoTemplate.queryForLists(sql, SysCorporation.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
//        SysCorporationSelectedQuery query = new SysCorporationSelectedQuery();
//        query.setQueryType(CorporationSelectQueryEnum.NAME);
//        query.setName(searchNm);
//        List<SysCorporationSelectedDTO> list = HttpResponseUtils.convertResponse(corporationRequest.select(query));
//        List<SysCorporation> result = Lists.newArrayList();
//        if (Collections3.isNotEmpty(list)) {
//            for (SysCorporationSelectedDTO corporationSelectedDTO : list) {
//                SysCorporation corporation = new SysCorporation();
//                corporation.setDeptId(corporationSelectedDTO.getId().longValue());
//                corporation.setDeptNm(corporationSelectedDTO.getName());
//                result.add(corporation);
//            }
//        }
//
//        return result;
    }

    /**
     * 修改公司续费时间
     *
     * @param deptId
     * @创建：作者:llp 创建时间：2016-7-20
     */
    public void updateCorporationEt(Integer deptId, String endDate) {
//        SysCorporationUpdateProperties properties = new SysCorporationUpdateProperties();
//        properties.setPropertyType(CorporationUpdatePropertyEnum.END_DATE);
//        properties.setId(deptId);
//        properties.setEndDate(endDate);
//        HttpResponseUtils.convertResponse(corporationRequest.updateProperties(properties));
        String sql = "update sys_corporation set end_date='" + endDate + "' where dept_id=" + deptId;
        try {
             pdaoTemplate.update(sql);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public int updateCorporateion(SysCorporation bo)
    {
        try {
            Map<String,Object> whereParam = new HashMap<String, Object>();
            whereParam.put("dept_id", bo.getDeptId());
            return this.daoTemplate.updateByObject("publicplat.sys_corporation", bo, whereParam, "dept_id");
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }



}
