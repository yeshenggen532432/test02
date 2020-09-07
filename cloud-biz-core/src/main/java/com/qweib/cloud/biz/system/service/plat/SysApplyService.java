package com.qweib.cloud.biz.system.service.plat;

import com.google.common.collect.Maps;
import com.qweib.cloud.biz.common.CompanyRoleEnum;
import com.qweib.cloud.biz.system.MenuConverter;
import com.qweib.cloud.biz.system.utils.MenuUtils;
import com.qweib.cloud.core.domain.SysApplyDTO;
import com.qweib.cloud.core.domain.SysApplyShowDTO;
import com.qweib.cloud.core.domain.SysMenu;
import com.qweib.cloud.core.domain.SysRole;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.repository.SysSalesmanDao;
import com.qweib.cloud.repository.company.SysCompanyRoleDao;
import com.qweib.cloud.repository.plat.SysApplyDao;
import com.qweib.cloud.repository.plat.SysMenuDao;
import com.qweib.cloud.service.basedata.common.FuncSpecificTagEnum;
import com.qweib.cloud.utils.Collections3;
import com.qweib.cloud.utils.StrUtil;
import com.qweib.cloud.utils.TreeMode;
import com.qweib.commons.StringUtils;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.*;

@Service
public class SysApplyService {
    @Resource
    private SysApplyDao sysApplyDao;
    @Resource
    private SysMenuDao menuDao;
//    @Resource
//    private SysMemberDao memberDao;
    @Resource
    private SysCompanyRoleDao companyRoleDao;
    @Resource
    private SysSalesmanDao salesmanDao;

    /**
     * 根据id查询应用信息
     *
     * @param idKey
     * @return
     */
    public SysApplyDTO queryApplyById(Integer idKey) {
        try {
            SysApplyDTO applyDTO = sysApplyDao.queryApplyById(idKey);
            if (!StrUtil.isNull(applyDTO.getMenuId())) {//菜单id不为空s
                SysMenu menu = menuDao.queryMenuById(applyDTO.getMenuId());
                applyDTO.setMenuNm(menu.getMenuNm());
            }
            return applyDTO;
        } catch (Exception ex) {
            throw new ServiceException(ex);
        }
    }

    /**
     * 添加移动端应用
     *
     * @param applyDTO
     * @return
     */
    public int addApply(SysApplyDTO applyDTO) {
        try {
            int count = sysApplyDao.addApply(applyDTO);
            return count;
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 根据父id查询子项个数
     *
     * @param pid
     * @return
     */
    public Integer getApplySizeByPid(Integer pid) {
        try {
            return sysApplyDao.getApplySizeByPid(pid);
        } catch (Exception ex) {
            throw new ServiceException(ex);
        }
    }

    /**
     * 更新应用
     *
     * @param applyDTO
     * @return
     */
    public Integer updateApply(SysApplyDTO applyDTO) {
        try {
            int count = this.sysApplyDao.updateApply(applyDTO);
            //调用存储过程，更新子库中的应用菜单信息
            sysApplyDao.updateApplyToProcedure(applyDTO);
            return count;
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 查询功能应用
     *
     * @param leftId
     * @return
     */
    public List<TreeMode> querySysApply(Integer leftId) {
        try {
            return this.sysApplyDao.querySysApply(leftId);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 根据用户角色查询菜单信息
     *
     * @param memId
     * @param database
     * @return
     */
    public List<SysApplyDTO> queryApplyByMemberRole(Integer memId, String applyCode,
                                                    String database) {
        List<SysApplyDTO> applyList;
        //查询成员是否为管理员
        SysRole role = companyRoleDao.queryMemberRoleByRolecd(CompanyRoleEnum.COMPANY_ADMIN.getRole(), memId, database);
        if (role != null) {
            //公司管理员
            applyList = sysApplyDao.queryApplyForCreator(applyCode, database);
            for (int i = 0; i < applyList.size(); i++) {
                if (applyList.get(i).getApplyName().equals("报表统计")) {
                    applyList.get(i).setSgtjz("1,2,3,4");
                }
            }
        } else {
            applyList = sysApplyDao.queryApplyByMemberRole(memId, applyCode, database);
        }

        return applyList;
    }

    /**
     * 比较并检查是否需要替换数据权限
     *
     * @param oldType
     * @param newType
     * @return
     */
    private boolean compareAndResetDateType(String oldType, String newType) {
        if (Objects.isNull(oldType)) {
            return true;
        }

        if (Objects.isNull(newType)) {
            return false;
        }

        if (Objects.equals(oldType, newType)) {
            return false;
        }

        Integer oldValue = StringUtils.toInteger(oldType);
        Integer newValue = StringUtils.toInteger(newType);

        return oldValue > newValue;
    }

    public List<SysApplyShowDTO> queryApplyByMemberRole(Integer memId, String database) {
        List<SysApplyShowDTO> applyList;
        //查询成员是否为管理员
        SysRole role = companyRoleDao.queryMemberRoleByRolecd(CompanyRoleEnum.COMPANY_ADMIN.getRole(), memId, database);
        if (role != null) {
            //公司管理员
            applyList = sysApplyDao.queryApplyForCreator(database);
            for (int i = 0; i < applyList.size(); i++) {
                if (applyList.get(i).getApplyName().equals("报表统计")) {
                    applyList.get(i).setSgtjz("1,2,3,4");
                }
            }
        } else {
            applyList = sysApplyDao.queryApplyByMemberRole(memId, database);
            if (salesmanDao.hasEnabledSalesman(memId, database)) {
                List<SysApplyShowDTO> salesmanApplyList = sysApplyDao.querySpecificApply(memId, FuncSpecificTagEnum.SALESMAN, database, "2");
                if (Collections3.isNotEmpty(salesmanApplyList)) {
                    completionMenus(database, applyList, salesmanApplyList);
                }
            }

            if (Collections3.isEmpty(applyList)) {
                return applyList;
            }

            MenuUtils.filterMenuDataAuthority(applyList);
        }

        return applyList;
    }


    private void completionMenus(String database, List<SysApplyShowDTO> originList, List<SysApplyShowDTO> specificList) {
        Map<String, byte[]> menuIdCache = Maps.newHashMap();
        for (SysApplyShowDTO menu : originList) {
            menuIdCache.put(menu.getId().toString(), SysCompanyRoleDao.TAG);
        }

        for (SysApplyShowDTO menu : specificList) {
            menuIdCache.put(menu.getId().toString(), SysCompanyRoleDao.TAG);
        }
        originList.addAll(specificList);

        MenuConverter converter = (MenuConverter<SysApplyShowDTO>) menuDTO -> {
            SysApplyShowDTO data = new SysApplyShowDTO();
            data.setId(menuDTO.getId());
            data.setPId(menuDTO.getParentId());
            data.setApplyName(menuDTO.getName());
            data.setApplyCode(menuDTO.getCode());
            data.setTp(menuDTO.getType());
            data.setApplyUrl(menuDTO.getLink());
            data.setMenuTp(menuDTO.getMenuType());
            data.setApplyIcon(menuDTO.getIcon());
            data.setApplyIfwap(menuDTO.getAppType());
            data.setApplyNo(menuDTO.getSort());
            data.setMenuId(menuDTO.getBindMenuId());

            return data;
        };

        final String type = "2";

        for (SysApplyShowDTO menu : specificList) {
            Integer parentId = menu.getPId();
            companyRoleDao.getParentMenu(database, parentId, type, menuIdCache, originList, converter);
        }
    }



    /**
     * 删除应用
     *
     * @param idKey
     */
    public int deleteApply(Integer idKey) {
        try {
            //删除角色菜单
            int count = sysApplyDao.deleteApply(idKey);
            return count;
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 根据id获取应用
     *
     * @param id
     * @return
     */
    public SysApplyDTO queryApplyForDel(Integer pid) {
        try {
            return sysApplyDao.queryApplyForDel(pid);
        } catch (Exception ex) {
            throw new ServiceException(ex);
        }
    }

}
