package com.qweib.cloud.biz.system.service.plat;


import com.google.common.collect.Lists;
import com.qweib.cloud.biz.common.CompanyRoleEnum;
import com.qweib.cloud.biz.system.utils.RoleUtils;
import com.qweib.cloud.core.domain.SysMemDTO;
import com.qweib.cloud.core.domain.SysMember;
import com.qweib.cloud.core.domain.SysRole;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.repository.SysSalesmanDao;
import com.qweib.cloud.repository.company.SysCompanyRoleDao;
import com.qweib.cloud.repository.company.SysMemDao;
import com.qweib.cloud.repository.plat.ws.SysMemberWebDao;
import com.qweib.cloud.service.member.common.RoleValueEnum;
import com.qweib.cloud.utils.Collections3;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.PropertiesUtils;
import com.qweib.commons.DateUtils;
import com.qweib.commons.StringUtils;
import com.qweib.commons.exceptions.BizException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class SysMemService {
    @Resource
    private SysMemDao memDao;
    @Resource
    private SysMemberWebDao memberWebDao;
    @Autowired
    private SysCompanyRoleService companyRoleService;
    @Resource
    private SysCompanyRoleDao companyRoleDao;
    @Autowired
    private SysSalesmanDao salesmanDao;
    //	@Resource
//	private SysCorporationDao corporationDao;

    private static String outUrl = PropertiesUtils.readProperties("/properties/jdbc.properties", "OURURL");

    /**
     * @param Id
     * @return
     * @创建：作者:llp 创建时间：2015-1-29
     * @see 查询用户信息
     */
    public SysMember queryMemById(Integer Id, String datasource) {
        try {
            return memDao.queryMemById(Id, datasource);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * @param wallId
     * @return
     * @说明： 根据照片墙ID查询用户--只需要手机号码--
     * @创建者： 作者：YJP 创建时间:2014-5-15
     */
    public SysMember findMemberByPhotoWall(Integer wallId, String datasource) {
        try {
            return memDao.findMemberByPhotoWall(wallId, datasource);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * @param memberId   成员ID
     * @param datasource 手机号码
     * @return sysmember
     * @说明：根据条件查看用户
     * @创建者： 作者：YJP 创建时间：2014-4-20
     * @修改历史： [序号](yjp 2014 - 4 - 28) 之前为单个查询变成多条件查询,增加 memberId
     */

    public SysMember queryDailyMember(Integer memberId, String datasource) {
        try {
            return memDao.queryDailyMember(SysMember.class, memberId, null, datasource);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 分页查询
     */
    public Page queryForPage(SysMember mem, int page, int limit, String database) {
        try {
            return this.memDao.queryForPage(mem, page, limit, database);
        } catch (Exception ex) {
            throw new ServiceException(ex);
        }
    }

    /**
     * 通过pid查找会员信息
     */
    public SysMember queryMemByPid(Integer pid, String datasource) {
        try {
            return memDao.queryMemByPid(pid, datasource);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 修改会员
     */
    public int updateMember(SysMember sysmem, String database) {
        try {
            return memDao.updateMember(sysmem, database);
        } catch (Exception ex) {
            throw new ServiceException(ex);
        }
    }

    /**
     * 获取会员名称
     */
    public List<SysMemDTO> querycMems(String database) {
        try {
            return this.memDao.querycMems(database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 根据公司角色查询所有成员
     *
     * @param companyroleId
     * @param datasource
     * @return
     */
    public List<SysMemDTO> queryCompanyRoleMem(Integer companyroleId,
                                               String datasource) {
        try {
            return this.memDao.queryCompanyRoleMem(companyroleId, datasource);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 根据公司角色s查询所有成员
     *
     * @param roleCodes
     * @param datasource
     * @return
     */
    public List<SysMemDTO> queryCompanyMemByRoleCodes(List<String> roleCodes,
                                                      String datasource) {
        try {
            return this.memDao.queryCompanyMemByRoleCodes(roleCodes, datasource);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }
//	/**
//	 * 删除
//	 */
//	public int[] deletememberbak(Integer[] ids,String database){
//		try {
//			for(int i =0;i<ids.length;i++){
//				//修改公共平台上成员信息
//				memberWebDao.updateMemberBycompany(null,null, null, ids[i], null);
//				//SysMember member=memDao.queryMemById(ids[i], database);
//				//SysCorporation corporation=this.corporationDao.queryCorporationBydata(database);
//				/*
//				String reqJsonStr="{\"company_id\":\""+corporation.getPlatformCompanyId()+"\",\"mobile\":\""+member.getMemberMobile()+"\"}";
//				//String js=MapGjTool.postqq("http://openapi.uglcw.datasir.com/company/deleteEmployee", reqJsonStr);
//				String js=MapGjTool.postqq("http://" + outUrl + "/company/deleteEmployee", reqJsonStr);
//				JSONObject dataJson=new JSONObject(js);
//				if(dataJson.getInt("code")!=0){
//					System.out.println(dataJson.getInt("msg"));
//				}*/
//			}
//			this.memDao.deletememberGj(ids,database);
//			return this.memDao.deletemember(ids,database);
//		} catch (Exception e) {
//			throw new ServiceException(e);
//		}
//	}

    public int[] deletemember(Integer[] ids, String database, Integer companyId) {
        final String leaveTime = DateUtils.getDateTime();
        SysRole salesmanRole = companyRoleDao.queryRoleByRolecd(RoleValueEnum.BUSINESS_PEOPLE.getCode(), database);
        Optional<Integer> salesmanRoleId = Optional.ofNullable(salesmanRole).map(role -> role.getIdKey());
        for (int i = 0; i < ids.length; i++) {
            //修改公共平台上成员信息
            final Integer memberId = ids[i];
            //根据成员查询角色
            String roleIdstr = companyRoleService.queryRoleByMemid(memberId, database);
            String[] rids = StringUtils.split(roleIdstr, ",");
            if (rids != null) {
                List<Integer> roleIds = Lists.newArrayList(rids).stream().map(rid -> Integer.valueOf(rid)).collect(Collectors.toList());//List<String> 转 List<Integer>
                // 判断角色里是否包含"创建者"或"管理员"
                if (Collections3.isNotEmpty(roleIds)) {
                    boolean hasRole = RoleUtils.hasCompanyRoles(roleIds, new CompanyRoleEnum[]{CompanyRoleEnum.COMPANY_CREATOR, CompanyRoleEnum.COMPANY_ADMIN},
                            companyRoleService, database);
                    if (hasRole) {
                        throw new BizException("无法删除创建者或管理员");
                    }
                }
            }
            memberWebDao.clearPlatMemberCompanyData(companyId, memberId);
//            memberWebDao.updateCompanyMember(companyId, memberId, leaveTime);

            salesmanRoleId.ifPresent(roleId -> {
                this.companyRoleDao.deleteCompanyRoleMember(salesmanRole.getIdKey(), memberId, database);
                this.salesmanDao.removeBindMember(memberId, database);
            });
        }
        this.memDao.deletememberGj(ids, database);
        return this.memDao.deletemember(ids, database, companyId);

    }

/*    public int updateMemberIsDel(Integer[] ids,String database){
        return this.memDao.updateMemberIsDel(ids,database);
    }*/
    /**
     *@see 查询公司管理员
     *@param database
     *@return
     *@创建：作者:YYP 创建时间：2015-5-23
     */
	/*public List<SysMemDTO> queryCompanyAdmins(String database) {
		try{
			return memDao.queryCompanyAdmins(database);
		}catch (Exception e) {
			throw new ServiceException(e);
		}
	}*/
}
