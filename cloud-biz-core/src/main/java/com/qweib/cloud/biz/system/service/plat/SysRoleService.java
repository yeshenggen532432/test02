package com.qweib.cloud.biz.system.service.plat;

import com.qweib.cloud.core.domain.SysMenu;
import com.qweib.cloud.core.domain.SysRole;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.repository.company.SysCompanyRoleDao;
import com.qweib.cloud.repository.plat.RoleMenus;
import com.qweib.cloud.repository.plat.SysMenuDao;
import com.qweib.cloud.repository.plat.SysRoleDao;
import com.qweib.cloud.service.member.common.RoleValueEnum;
import com.qweib.commons.StringUtils;
import com.qweib.commons.exceptions.BizException;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Optional;

@Service
public class SysRoleService {
    @Resource
    private SysRoleDao roleDao;        //角色数据库操作类
    @Resource
    private SysMenuDao menuDao;        //菜单数据库操作类
    @Resource
    private SysCompanyRoleDao companyRoleDao;

    /**
     * 摘要：
     *
     * @param role
     * @说明：添加角色
     * @创建：作者:yxy 创建时间：2012-3-19
     * @修改历史： [序号](yxy 2012 - 3 - 19)<修改说明>
     */
    public int addRole(SysRole role, String datasource) {
        try {
            int i = this.roleDao.addRole(role, datasource);
//			if(i!=1){
//				throw new ServiceException("添加出错");
//			}
            return i;
        } catch (Exception ex) {
            throw new ServiceException(ex);
        }
    }

    /**
     * 摘要：
     *
     * @param role
     * @说明：修改角色
     * @创建：作者:yxy 创建时间：2012-3-19
     * @修改历史： [序号](yxy 2012 - 3 - 19)<修改说明>
     */
    public int updateRole(SysRole role, String datasource) {
        hasImmutableRole(role.getIdKey(), datasource, "不可修改!");
        int i = this.roleDao.updateRole(role, datasource);
        if (i != 1) {
            throw new ServiceException("添加出错");
        }
        return i;
    }

    private void hasImmutableRole(Integer roleId, String datasource, String message) {
        SysRole sysRole = queryRoleById(roleId, datasource);
        Optional.ofNullable(sysRole.getRoleCd())
                .filter(roleValue -> RoleValueEnum.isAdmin(roleValue) || RoleValueEnum.isSalesman(roleValue) ||
                        RoleValueEnum.isCreator(roleValue) || RoleValueEnum.isGeneralStaff(roleValue) || RoleValueEnum.isCoreManager(roleValue))
                .ifPresent(roleValue -> {
                    throw new BizException(sysRole.getRoleNm() + message);
                });
    }

    public int updateRoleStatus(Integer idKey, Integer status, String datasource) {
        hasImmutableRole(idKey, datasource, "不可停用!");
        if (Objects.equals(2, status)) {
            //删除角色关联的用户
            companyRoleDao.deleteMemberByRole(idKey, datasource);
        }
        return companyRoleDao.updateRoleStatus(idKey, status, datasource);
    }
//	/**
//	 *
//	 *摘要：
//	 *@说明：分页查询角色
//	 *@创建：作者:yxy		创建时间：2012-3-19
//	 *@param role
//	 *@param page
//	 *@return
//	 *@修改历史：
//	 *		[序号](yxy	2012-3-19)<修改说明>
//	 */
//	public Page queryRole(SysRole role,int page,int limit){
//		try{
//			return this.roleDao.queryRole(role, page,limit);
//		}catch(Exception ex){
//			throw new ServiceException(ex);
//		}
//	}

    /**
     * 摘要：
     *
     * @param roleIds
     * @说明：批量删除角色
     * @创建：作者:yxy 创建时间：2012-3-19
     * @修改历史： [序号](yxy 2012 - 3 - 19)<修改说明>
     */
    public void deleteRoles(String datasource, Integer... roleIds) {
        for (Integer roleId : roleIds) {
            SysRole sysRole = this.roleDao.queryRoleById(roleId, datasource);
            if (StringUtils.isNotBlank(sysRole.getRoleCd()) && RoleValueEnum.hasAnyOne(sysRole.getRoleCd())) {
                throw new BizException("系统角色不允许删除");
            }
        }
        //删除角色对应用户
        this.roleDao.deleteRoleUsrs(datasource, roleIds);
        //删除角色对应菜单
        this.roleDao.deleteRoleMenus(datasource, roleIds);
        //删除角色
        this.roleDao.deleteRoles(datasource, roleIds);
//            installRoleMenus();
    }

    /**
     * 摘要：
     *
     * @param idKey
     * @return
     * @说明：根据id获取角色
     * @创建：作者:yxy 创建时间：2012-3-19
     * @修改历史： [序号](yxy 2012 - 3 - 19)<修改说明>
     */
    public SysRole queryRoleById(Integer idKey, String datasource) {
        try {
            return this.roleDao.queryRoleById(idKey, datasource);
        } catch (Exception ex) {
            throw new ServiceException(ex);
        }
    }

    /**
     * 摘要：
     *
     * @param roleId
     * @return
     * @说明：查询用户用于分配用户
     * @创建：作者:yxy 创建时间：2012-3-22
     * @修改历史： [序号](yxy 2012 - 3 - 22)<修改说明>
     */
    public List<Map<String, Object>> queryUsrForRole(Integer roleId, String datasource) {
        try {
            return this.roleDao.queryUsrForRole(roleId, datasource);
        } catch (Exception ex) {
            throw new ServiceException(ex);
        }
    }

    /**
     * 摘要：
     *
     * @param roleId
     * @return
     * @说明：查询用户用于分配用户2
     * @创建：作者:llp 创建时间：2017-7-19
     * @修改历史： [序号](llp 2017 - 7 - 19)<修改说明>
     */
    public List<Map<String, Object>> queryUsrForRole2(Integer roleId, Integer cdid, String mids, String datasource) {
        try {
            return this.roleDao.queryUsrForRole2(roleId, cdid, mids, datasource);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 摘要：
     *
     * @param usrIds
     * @param roleId
     * @说明：批量添加角色分配人员表
     * @创建：作者:yxy 创建时间：2012-3-22
     * @修改历史： [序号](yxy 2012 - 3 - 22)<修改说明>
     */
    public void updateRoleUsr(Long[] usrIds, Integer roleId) {
        try {
            //删除角色分配用户表
            this.roleDao.deleteRoleUsrs(null, roleId);
            //批量添加角色分配人员表
            if (null != usrIds && usrIds.length > 0) {
                this.roleDao.saveRoleUsr(usrIds, roleId);
            }
        } catch (Exception ex) {
            throw new ServiceException(ex);
        }
    }

    /**
     * 摘要：
     *
     * @param menuIds
     * @param roleId
     * @说明：批量添加角色分配权限
     * @创建：作者:yxy 创建时间：2012-3-22
     * @修改历史： [序号](yxy 2012 - 3 - 22)<修改说明>
     */
    public void updateRoleMenu(Integer[] menuIds, Integer roleId) {
        try {
            //删除角色分配权限
            this.roleDao.deleteRoleMenus(null, roleId);
            //批量添加角色分配权限
            if (null != menuIds && menuIds.length > 0) {
                this.roleDao.saveRoleMenu(menuIds, roleId);
            }
            installRoleMenus();
        } catch (Exception ex) {
            throw new ServiceException(ex);
        }
    }

    /**
     * 摘要：
     *
     * @param roleId
     * @return
     * @说明：根据父id查询菜单
     * @创建：作者:yxy 创建时间：2012-3-23
     * @修改历史： [序号](yxy 2012 - 3 - 23)<修改说明>
     */
    public List<SysMenu> queryMenuByPidForRole(Integer roleId) {
        try {
            return this.menuDao.queryMenuByPidForRole(roleId);
        } catch (Exception ex) {
            throw new ServiceException(ex);
        }
    }

    /**
     * 摘要：
     *
     * @说明：设置角色权限
     * @创建：作者:yxy 创建时间：2011-6-29
     * @修改历史： [序号](yxy 2011 - 6 - 29)<修改说明>
     */
    private void installRoleMenus() {
        List<SysRole> roles = this.roleDao.queryRoleAll();
        RoleMenus.roleMenus.clear();
        for (SysRole role : roles) {
            List<Map<String, Object>> menus = this.menuDao.querySysMenuByRoleId(role.getIdKey());
            RoleMenus.roleMenus.put(role.getIdKey(), menus);
        }
    }
//	//根据角色名称查询角色id
//	public Integer queryIdByRoleNm(String commonMem) {
//		try{
//			return this.menuDao.queryIdByRoleNm(commonMem);
//		}catch(Exception ex){
//			throw new ServiceException(ex);
//		}
//	}
}
