package com.qweib.cloud.biz.system.service.plat;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.qweib.cloud.biz.common.CompanyRoleEnum;
import com.qweib.cloud.biz.system.MenuConverter;
import com.qweib.cloud.biz.system.controller.dto.SalesmanMenuDTO;
import com.qweib.cloud.biz.system.controller.dto.SalesmanMenusSave;
import com.qweib.cloud.biz.system.utils.MenuUtils;
import com.qweib.cloud.core.domain.*;
import com.qweib.cloud.core.domain.dto.SysMenuDTO;
import com.qweib.cloud.core.domain.dto.SysRoleMemberDTO;
import com.qweib.cloud.core.domain.vo.RoleMenuListModel;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.repository.SysSalesmanDao;
import com.qweib.cloud.repository.company.SysCompanyRoleDao;
import com.qweib.cloud.repository.plat.SysApplyDao;
import com.qweib.cloud.repository.plat.SysMenuDao;
import com.qweib.cloud.repository.plat.SysRoleDao;
import com.qweib.cloud.repository.utils.MemberUtils;
import com.qweib.cloud.service.basedata.common.FuncSpecificTagEnum;
import com.qweib.cloud.service.initial.domain.DbConstant;
import com.qweib.cloud.service.member.common.RoleValueEnum;
import com.qweib.cloud.service.member.domain.corporation.CorporationActionDTO;
import com.qweib.cloud.service.member.retrofit.corporation.CorporationActionRetrofitApi;
import com.qweib.cloud.utils.Collections3;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import com.qweib.commons.exceptions.BizException;
import com.qweibframework.commons.MathUtils;
import com.qweibframework.commons.StringUtils;
import com.qweibframework.commons.http.ResponseUtils;
import org.apache.commons.lang3.ArrayUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Flux;

import javax.annotation.Resource;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class SysCompanyRoleService {
    @Resource
    private SysCompanyRoleDao companyRoleDao;
    @Resource
    private SysMenuDao menuDao;
    @Resource
    private SysApplyDao applyDao;
    @Resource
    private SysSalesmanDao salesmanDao;
    @Resource
    private SysApplyDao sysApplyDao;
    @Resource
    private SysRoleDao roleDao;


    public Page queryRole(SysRole role, Integer page, Integer rows,
                          String datasource) {
        return companyRoleDao.queryRole(role, page, rows, datasource);
    }

    /**
     * 查询菜单应用树
     *
     * @param roleId
     * @param tp
     * @return
     */
    public List<SysApplyDTO> queryMenuAopplyForRole(Integer roleId, String tp, String datasource) {
        return companyRoleDao.queryMenuAopplyForRole(roleId, tp, datasource);
    }

    public List<SysApplyDTO> queryMenuApplyByCreatorOrAdmin(String database, String tp, CompanyRoleEnum roleEnum) {
        return companyRoleDao.queryAllMenuApply(database, roleEnum.getRole(), tp);
    }

    /**
     * 保存角色的菜单应用关系s
     *
     * @param companyroleId
     * @param menuid
     * @param menuapplytype
     * @param datasource
     */
    String pIds = "";

    public Boolean updateRoleMenuApply(Integer companyroleId, String menuapplytype, RoleMenuListModel roleMenu, String datasource) {
        Boolean rst = Boolean.FALSE;
        try {
            //删除已分配的菜单应用
            String ids = "";
            Map<String, Object> map = companyRoleDao.queryRoleBindIds(datasource, companyroleId, menuapplytype);
            if (!StrUtil.isNull(map.get("ids"))) {//不为空
                ids = (String) map.get("ids");
            }
            this.companyRoleDao.deleteRoleMenuApplys(datasource, companyroleId, menuapplytype, ids);
            //批量添加公司菜单应用/
            /****************************获取选中的角色菜单信息********************/
            List<SysRoleMenu> roleMenuList = roleMenu.getRoleMenu();//全部菜单的信息
            List<SysRoleMenu> checkedRolemenuList = new ArrayList<SysRoleMenu>();//选中的菜单信息
            String tp = "1".equals(menuapplytype) ? "2" : "1";
            List<SysRoleMenu> applys = new ArrayList<SysRoleMenu>();//绑定的父id
            if (Collections3.isNotEmpty(roleMenuList)) {
                for (SysRoleMenu rm : roleMenuList) {//抽取选中的菜单
                    if ("true".equals(rm.getIfChecked())) {//包含在选中里面
                        checkedRolemenuList.add(rm);
                        if (!StrUtil.isNull(rm.getBindId()) && rm.getBindId() != 0) {//有绑定的菜单或者应用信息
                            SysRoleMenu rMenu = new SysRoleMenu();
                            rMenu.setMenuId(rm.getBindId());
                            rMenu.setDataTp(rm.getDataTp());//关联的数据查询范围同绑定
                            rMenu.setTp(tp);
                            rMenu.setSgtjz(rm.getSgtjz());
                            checkedRolemenuList.add(rMenu);//添加绑定的菜单或应用
                            ///////////////绑定的父id
                            applys = getPid(rm.getBindId(), applys, tp, datasource);
                            ///////////////绑定的父id
                        }
                    }
                }
            }
            ///////////////绑定的父id
            checkedRolemenuList.addAll(applys);
            pIds = "";
            ///////////////绑定的父id
            /****************************获取选中的角色菜单信息********************/
            //批量添加角色的菜单或应用信息(包括绑定的菜单或应用)
            this.companyRoleDao.saveRoleMenuApply(companyroleId, checkedRolemenuList, datasource);
            rst = Boolean.TRUE;
        } catch (Exception ex) {
            throw new ServiceException(ex);
        }
        return rst;
    }

    //递归查询父id
    private List<SysRoleMenu> getPid(Integer id, List<SysRoleMenu> applys, String tp, String datasource) {
        if ("1".equals(tp)) {//菜单
            SysMenu menu = menuDao.queryMenuById(id);//查询菜单信息
            if (menu.getPId() != 0) {
                if (!pIds.contains(menu.getPId() + ",")) {
                    pIds += menu.getPId() + ",";
                    SysRoleMenu sysRm = new SysRoleMenu();
                    sysRm.setMenuId(menu.getPId());
                    sysRm.setDataTp(null);//默认
                    sysRm.setTp(tp);
                    applys.add(sysRm);
                }
                getPid(menu.getPId(), applys, tp, datasource);
            }
        } else {//应用
            SysApplyDTO applyDTO = applyDao.queryApplyById(id);
            if (applyDTO.getPId() != 0) {
                if (!pIds.contains(applyDTO.getPId() + ",")) {
                    pIds += applyDTO.getPId() + ",";
                    SysRoleMenu sysRm = new SysRoleMenu();
                    sysRm.setMenuId(applyDTO.getPId());
                    sysRm.setDataTp(null);//默认
                    sysRm.setTp(tp);
                    applys.add(sysRm);
                }
                getPid(applyDTO.getPId(), applys, tp, datasource);
            }
        }
        return applys;
    }

    public void updateCompanyRoleUsr(Integer[] usrid, Integer roleid,
                                     String datasource, Integer companyId) {
        List<Integer> oldMemberIds = companyRoleDao.queryByRoleId(roleid, datasource)
                .stream()
                .map(roleMember -> roleMember.getMemberId())
                .collect(Collectors.toList());
        companyRoleDao.deleteCompanyRoleUsr(roleid, datasource);
        if (ArrayUtils.isNotEmpty(usrid)) {
            companyRoleDao.addCompanyRoleUsr(usrid, roleid, datasource);
        }

        if (checkPortCountExceedLimit(roleid, datasource, companyId)) {
            throw new BizException("对不起，您已超出端口上限，请先增加端口数");
        }


        List<Integer> newMemberIds = Arrays.asList(usrid);
        updateByMemberIsNoRole(oldMemberIds, newMemberIds, datasource);
    }

    /**
     * 检查是否有端口数超出限制
     * @param roleId
     * @param database
     * @param companyId
     * @param addMemberIds 要新增的会员 id 列表
     * @return
     */
    public Boolean checkPortCountExceedLimit(Integer roleId, String database, Integer companyId, List<Integer> addMemberIds) {
        SysRole roleEntity = companyRoleDao.queryRoleById(database, roleId);
        return false;
//        if (MemberUtils.needPortLimit(roleEntity.getRoleCd())) {
//            CorporationActionDTO actionDTO = ResponseUtils.convertResponse(corporationActionRetrofitApi.get(companyId));
//            if (Objects.nonNull(actionDTO.getPortCount()) && !Objects.equals(actionDTO.getPortCount(), -1)) {
//                List<Integer> memberIds = companyRoleDao.queryCompanyPortMember(database);
//                memberIds.removeAll(addMemberIds);
//                memberIds.addAll(addMemberIds);
//                return memberIds.size() > actionDTO.getPortCount().intValue();
//            }
//        }

        // 该角色不需要计算端口数，或者平台没有控制端口数
        //return null;
    }

    /**
     * 检查是否有端口数超出限制
     * @param roleIds 角色 id 列表
     * @param database
     * @param companyId
     * @param addMemberIds 要新增的会员 id 列表
     * @return
     */
    public boolean checkPortCountExceedLimit(List<Integer> roleIds, String database, Integer companyId, List<Integer> addMemberIds) {
        if (Collections3.isEmpty(roleIds)) {
            return false;
        }

        for (Integer roleId : roleIds) {
            Boolean result = checkPortCountExceedLimit(roleId, database, companyId, addMemberIds);
            if (Objects.nonNull(result)) {
                return result;
            }
        }

        return false;
    }

    public boolean checkPortCountExceedLimit(List<SysRoleMemberDTO> roleList, String database, Integer companyId, Integer addMemberId) {
//        for (SysRoleMemberDTO roleEntity : roleList) {
//            if (MemberUtils.needPortLimit(roleEntity.getRoleCode())) {
//                CorporationActionDTO actionDTO = ResponseUtils.convertResponse(corporationActionRetrofitApi.get(companyId));
//                if (Objects.nonNull(actionDTO.getPortCount()) && !Objects.equals(actionDTO.getPortCount(), -1)) {
//                    List<Integer> memberIds = companyRoleDao.queryCompanyPortMember(database);
//                    memberIds.remove(addMemberId);
//                    memberIds.add(addMemberId);
//                    return memberIds.size() > actionDTO.getPortCount().intValue();
//                }
//            }
//        }

        // 该角色不需要计算端口数，或者平台没有控制端口数
        return true;
    }

    /**
     * 检测端口数是否有超出限制
     *
     * @param roleId    角色 id
     * @param database
     * @param companyId
     * @return
     */
    public boolean checkPortCountExceedLimit(Integer roleId, String database, Integer companyId) {
//        SysRole roleEntity = companyRoleDao.queryRoleById(database, roleId);
//        if (MemberUtils.needPortLimit(roleEntity.getRoleCd())) {
//            CorporationActionDTO actionDTO = ResponseUtils.convertResponse(corporationActionRetrofitApi.get(companyId));
//            if (Objects.nonNull(actionDTO.getPortCount()) && !Objects.equals(actionDTO.getPortCount(), -1)) {
//                List<Integer> memberIds = companyRoleDao.queryCompanyPortMember(database);
//                return memberIds.size() > actionDTO.getPortCount().intValue();
//            }
//        }

        return true;
    }

    public boolean checkPortCountExceedLimit(List<Integer> roleIds, String database, Integer companyId) {
        boolean result = false;
        if (Collections3.isEmpty(roleIds)) {
            return result;
        }

        for (Integer roleId : roleIds) {
            result = checkPortCountExceedLimit(roleId, database, companyId);
            if (result) {
                break;
            }
        }

        return result;
    }

    /**
     * 检查会员是否没有任何角色，增加一个普通员工角色
     *
     * @param oldMemberIds
     * @param newMemberIds
     * @param datasource
     */
    public void updateByMemberIsNoRole(List<Integer> oldMemberIds, List<Integer> newMemberIds, String datasource) {
        if (Collections3.isEmpty(oldMemberIds)) {
            return;
        }

        oldMemberIds.removeAll(newMemberIds);
        if (Collections3.isEmpty(oldMemberIds)) {
            return;
        }

        SysRole sysRole = roleDao.queryByRoleCode(RoleValueEnum.GENERAL_STAFF.getCode(), datasource);
        if (Objects.isNull(sysRole)) {
            return;
        }

        List<Integer> addMemberIds = Lists.newArrayList();
        for (Integer memberId : oldMemberIds) {
            Long count = companyRoleDao.countMemberRoles(memberId, datasource);
            if (count < 1) {
                // 添加普通员工角色
                addMemberIds.add(memberId);
            }
        }

        if (Collections3.isNotEmpty(addMemberIds)) {
            companyRoleDao.addCompanyRoleUsr(addMemberIds.toArray(new Integer[addMemberIds.size()]), sysRole.getIdKey(), datasource);
        }
    }

    public void updateSalesmanRoleMember(Integer roleId, Integer[] memberIds, List<SysMember> members, String datasource, Integer companyId) {
        updateCompanyRoleUsr(memberIds, roleId, datasource, companyId);
        salesmanDao.cleanBindMember(datasource);
        SysSalesman query = new SysSalesman();
        query.setStatus(1);
        List<SysSalesman> salesmanList = salesmanDao.queryList(query, datasource);
        Iterator<SysSalesman> salesmanIter = salesmanList.iterator();
        Iterator<SysMember> memberIter = members.iterator();
        while (salesmanIter.hasNext() && memberIter.hasNext()) {
            SysSalesman salesman = salesmanIter.next();
            SysMember member = memberIter.next();
            salesmanDao.updateMemberId(salesman.getId(), member.getMemberMobile(), member.getMemberId(), datasource);
        }
    }

    /**
     * 根据多个角色查询对应的菜单信息
     *
     * @param memberId
     * @param datasource
     * @return
     */
    public List<Map<String, Object>> queryRoleMenus(Integer memberId, Integer pId, String datasource) {
        List<Map<String, Object>> list = companyRoleDao.queryRoleMenus(datasource, memberId, pId, null);

        if (salesmanDao.hasEnabledSalesman(memberId, datasource)) {
            List<Map<String, Object>> salesmanMenus = querySpecificTagMenus(datasource, memberId, pId, DbConstant.MENU_TYPE_1, FuncSpecificTagEnum.SALESMAN);
            if (Collections3.isNotEmpty(salesmanMenus)) {
                completionMenus(datasource, list, salesmanMenus);
            }
        }

        return list;
    }

    /**
     * 补全缺失上级
     */
    private void completionMenus(String database, List<Map<String, Object>> originList, List<Map<String, Object>> specificList) {
        Map<String, byte[]> menuIdCache = Maps.newHashMap();
        for (Map<String, Object> menu : originList) {
            menuIdCache.put(menu.get("id_key").toString(), SysCompanyRoleDao.TAG);
        }

        for (Map<String, Object> menu : specificList) {
            menuIdCache.put(menu.get("id_key").toString(), SysCompanyRoleDao.TAG);
        }
        originList.addAll(specificList);

        MenuConverter converter = (MenuConverter<Map<String, Object>>) menuDTO -> {
            Map<String, Object> data = Maps.newHashMap();
            data.put("id_key", menuDTO.getId());
            data.put("menu_nm", menuDTO.getName());
            data.put("menu_url", menuDTO.getLink());
            data.put("p_id", menuDTO.getParentId());
            data.put("menu_cd", menuDTO.getCode());
            data.put("menu_cls", menuDTO.getIcon());
            data.put("menu_tp", menuDTO.getMenuType());
            data.put("data_tp", 1);
            data.put("apply_no", menuDTO.getSort());

            return data;
        };

        final String type = "1";

        for (Map<String, Object> menu : specificList) {
            Integer parentId = (Integer) menu.get("p_id");
            companyRoleDao.getParentMenu(database, parentId, type, menuIdCache, originList, converter);
        }
    }


    public List<Map<String, Object>> querySpecificTagMenus(String database, Integer memberId, Integer parentId, String type, FuncSpecificTagEnum specificTag) {
        return companyRoleDao.querySpecificMenus(database, memberId, parentId, type, specificTag);
    }

    public SysMenuDTO getMenu(String database, Integer menuId, String type) {
        return this.companyRoleDao.getMenu(database, menuId, type);
    }

    public List<SysApplyDTO> queryAdminRoleMenus(String database, String menuType) {
        final SysRole adminRole = companyRoleDao.queryRoleByRolecd(CompanyRoleEnum.COMPANY_ADMIN.getRole(), database);
        final List<SysApplyDTO> sysApplyDTOS = companyRoleDao.queryAdminRoleMenus(database, menuType);

        final List<SysRoleMenu> roleMenuList = companyRoleDao.queryAdminRoleMenuRelative(database, adminRole.getIdKey(), menuType);
        Map<Integer, SysRoleMenu> roleMenuCache = Maps.newHashMap();
        if (Collections3.isNotEmpty(roleMenuList)) {
            for (SysRoleMenu sysRoleMenu : roleMenuList) {
                roleMenuCache.put(sysRoleMenu.getMenuId(), sysRoleMenu);
            }
        }

        for (SysApplyDTO sysApplyDTO : sysApplyDTOS) {
            final Integer menuId = sysApplyDTO.getId();
            Optional.ofNullable(roleMenuCache.get(menuId))
                    .ifPresent(roleMenu -> {
                        sysApplyDTO.setSgtjz(roleMenu.getSgtjz());
                        sysApplyDTO.setMids(roleMenu.getMids());
                        sysApplyDTO.setDataTp(roleMenu.getDataTp());
                    });

            if (StringUtils.isBlank(sysApplyDTO.getDataTp())) {
                sysApplyDTO.setDataTp("1");
            }
            if (!MathUtils.valid(sysApplyDTO.getMenuId())) {
                sysApplyDTO.setMenuId(0);
            }
        }

        return sysApplyDTOS;
    }

    public List<SysApplyDTO> queryRoleMenus(String database, Integer memberId, String menuType) {
        List<SysApplyDTO> resultList = companyRoleDao.queryRoleMenus(database, memberId, menuType);
        if (salesmanDao.hasEnabledSalesman(memberId, database)) {
            List<SysApplyShowDTO> salesmanApplyList = sysApplyDao.querySpecificApply(memberId, FuncSpecificTagEnum.SALESMAN, database, menuType);
            if (Collections3.isNotEmpty(salesmanApplyList)) {
                completionApplyMenus(database, resultList, salesmanApplyList);
            }
        }

        MenuUtils.filterMenuDataAuthority(resultList);

        MenuUtils.sortMenus(resultList);

        return resultList;
    }

    private void completionApplyMenus(String database, List<SysApplyDTO> originList, List<SysApplyShowDTO> specificList) {
        Map<String, byte[]> menuIdCache = Maps.newHashMap();
        for (SysApplyDTO menu : originList) {
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

    public List<Map<String, Object>> queryAdminButtonByCodes(String datasource, String btnCodes) {
        return companyRoleDao.queryAdminMenuByCodes(datasource, btnCodes, "1");
    }

    public List<Map<String, Object>> queryAdminAppButtonByCodes(String datasource, String btnCodes) {
        return companyRoleDao.queryAdminAppByCodes(datasource, btnCodes, "1");
    }


    public List<Map<String, Object>> queryRoleButtonByCodes(String datasource, List<Integer> roles, String btnCodes) {
        if (Collections3.isEmpty(roles)) {
            return null;
        }
        String roleIds = StringUtils.join(roles.toArray(), ",");
        return companyRoleDao.queryRoleMenuByCodes(datasource, roleIds, btnCodes, "1");
    }

    public List<Map<String, Object>> queryRoleAppButtonByCodes(String datasource, List<Integer> roles, String btnCodes) {
        if (Collections3.isEmpty(roles)) {
            return null;
        }
        String roleIds = StringUtils.join(roles.toArray(), ",");
        return companyRoleDao.queryRoleAppByCodes(datasource, roleIds, btnCodes, "1");
    }

    public List<Map<String, Object>> queryAdminMenuByCodes(String datasource, String menuCodes) {
        return companyRoleDao.queryAdminMenuByCodes(datasource, menuCodes, "0");
    }

    public List<Map<String, Object>> queryRoleMenuByCodes(String datasource, List<Integer> roles, String menuCodes) {
        if (Collections3.isEmpty(roles)) {
            return null;
        }
        String roleIds = StringUtils.join(roles.toArray(), ",");
        return companyRoleDao.queryRoleMenuByCodes(datasource, roleIds, menuCodes, "0");
    }

    public List<Map<String, Object>> queryRoleMenusByNms(List<Integer> roles, String nms,
                                                         String datasource) {
        if (Collections3.isEmpty(roles)) {
            return null;
        }
        String roleIds = StringUtils.join(roles.toArray(), ",");
        return companyRoleDao.queryRoleMenusByNms(datasource, roleIds, nms);
    }

    /**
     * 根据父菜单id查询创建者的下级菜单
     *
     * @param pId
     * @param datasource
     * @return
     */
    public List<Map<String, Object>> queryRoleMenusForCreator(Integer pId, String datasource) {
        return companyRoleDao.queryRoleMenusForCreator(datasource, pId);
    }

    /**
     * 查询公司角色列表
     *
     * @param datasource
     * @return
     */
    public List<SysRole> queryRoleList(String datasource) {
        return companyRoleDao.queryRoleList(datasource);
    }

    /**
     * 根据成员查询角色
     *
     * @param memId
     * @param datasource
     * @return
     */
    public String queryRoleByMemid(Integer memId, String datasource) {
        String str = "";
        Map<String, Object> roles = companyRoleDao.queryRoleByMemid(memId, datasource);
        if (!StrUtil.isNull(roles.get("roleIds"))) {
            str = (String) roles.get("roleIds");
        }
        return str;
    }

    /**
     * 根据成员查询角色，以最小id作为角色
     *
     * @param memId
     * @param datasource
     * @return
     */
    public String queryRoleByMemidForMin(Integer memId, String datasource) {
        return checkHasAdminRole(memId, datasource);
    }

    /**
     * 根据成员查询角色，以最小id作为角色
     *
     * @param memId
     * @param datasource
     * @return
     */
    public String checkHasAdminRole(Integer memId, String datasource) {
        List<SysRoleMemberDTO> roleMemberDTOS = companyRoleDao.queryRoleMemberByMemberId(datasource, memId);
        if (Collections3.isEmpty(roleMemberDTOS)) {
            return StringUtils.EMPTY;
        }
        for (SysRoleMemberDTO roleMemberDTO : roleMemberDTOS) {
            if (CompanyRoleEnum.hasAdmin(roleMemberDTO.getRoleCode())) {
                return CompanyRoleEnum.COMPANY_ADMIN.getMemberRole();
            }
        }

        return StringUtils.EMPTY;
    }

    public List<SysRoleMemberDTO> getRoleMemberByMemberId(String database, Integer memberId) {
        return companyRoleDao.queryRoleMemberByMemberId(database, memberId);
    }

    public SysRole queryById(final String database, Integer id) {
        return companyRoleDao.queryRoleById(database, id);
    }

    /**
     * 检查是否有设置过管理员
     *
     * @param database
     * @return
     */
    public Boolean hasSettingAdmin(String database) {
        return companyRoleDao.hasSettingAdmin(database, CompanyRoleEnum.COMPANY_ADMIN.getRole());
    }

    /**
     * 能否编辑角色
     *
     * @param database
     * @param memberId
     * @param roleIds
     * @return
     */
    public boolean canEditCreatorAndAdmin(String database, Integer memberId, List<Integer> roleIds) {
        SysRole creatorRole = companyRoleDao.queryRoleByRolecd(CompanyRoleEnum.COMPANY_CREATOR.getRole(), database);
        final Integer creatorRoleId = creatorRole.getIdKey();
        SysRole adminRole = companyRoleDao.queryRoleByRolecd(CompanyRoleEnum.COMPANY_ADMIN.getRole(), database);
        final Integer adminRoleId = adminRole.getIdKey();

        boolean hasAdmin = roleIds.contains(adminRoleId);
        boolean hasCreator = roleIds.contains(creatorRoleId);

        if ( !hasCreator) {
            return true;
        }

        List<SysRoleMemberDTO> roleMemberDTOS = companyRoleDao.queryRoleMemberByMemberId(database, memberId);
        if (( hasCreator) && Collections3.isEmpty(roleMemberDTOS)) {
            return false;
        }

        List<Integer> memberRoleIds = Flux.fromIterable(roleMemberDTOS)
                .map(roleMemberDTO -> roleMemberDTO.getRoleId())
                .toStream()
                .collect(Collectors.toList());

        if (hasAdmin && !memberRoleIds.contains(adminRoleId)) {
            return false;
        }

        if (hasCreator && !memberRoleIds.contains(creatorRoleId)) {
            return false;
        }

        return true;
    }

    /**
     * 创建成员角色
     *
     * @param datasource
     * @param memId
     */
    public void addRolemember(String datasource, Integer memId, String roleCd) {
        SysRole role = companyRoleDao.queryRoleByRolecd(roleCd, datasource);
        SysRoleMember roleMember = new SysRoleMember();
        roleMember.setMemberId(memId);
        roleMember.setRoleId(role.getIdKey());
        try {
            companyRoleDao.addCompanyRolemember(roleMember, datasource);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 查询公司创建者的菜单权限（全部menu菜单）
     *
     * @param datasource
     * @return
     */
    public List<Map<String, Object>> queryRoleForCompanyAdmin(
            String datasource) {
        try {
            return companyRoleDao.queryRoleForCompanyAdmin(datasource);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    public List<Map<String, Object>> queryRoleForCompanyAdminByNms(
            String datasource, String nms) {
        try {
            return companyRoleDao.queryRoleForCompanyAdminByNms(datasource, nms);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 根据角色编号查询角色信息
     *
     * @param roleCd
     * @param datasource
     * @return
     */
    public SysRole queryRoleByRolecd(String roleCd, String datasource) {
        return companyRoleDao.queryRoleByRolecd(roleCd, datasource);
    }

    public void addTo(SysRoleMember roleMember, String datasource) {
        companyRoleDao.addCompanyRolemember(roleMember, datasource);
    }

    /**
     * 根据角色，菜单修改用户
     *
     * @param roleid
     * @param datasource
     */
    public void updateUsrByjc(Integer roleid, Integer cdid, String mids, String datasource) {
        try {
            this.companyRoleDao.updateUsrByjc(roleid, cdid, mids, datasource);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    public void updateMemberAuthority(SalesmanMenusSave input, String database) {
        List<SalesmanMenuDTO> menus = input.getMenus();
        if (Collections3.isEmpty(menus)) {
            return;
        }

        Integer memberId = input.getMemberId();
        Integer menuType = input.getType();
        menus.stream()
                .filter(menu -> Objects.nonNull(menu.getAuthorityType()))
                .forEach(menu -> companyRoleDao.updateMemberAuthority(menu.getAuthorityId(), memberId, menuType, menu.getMenuId(), menu.getAuthorityType(), menu.getIfChecked(), database));
    }

    public List<Integer> queryCompanyPortMember(final String database) {
        return companyRoleDao.queryCompanyPortMember(database);
    }

    /**
     * 获取平台分配的端口数
     *
     * @param companyId
     * @return
     */
    public Integer getCompanyAllocPortCount(Integer companyId) {
        return 10;
//        CorporationActionDTO corporationActionDTO = ResponseUtils.convertResponse(corporationActionRetrofitApi.get(companyId));
//        return corporationActionDTO.getPortCount();
    }

    /**
     * 获取企业已使用的端口数
     *
     * @param database
     * @return
     */
    public Integer getCompanyUsedPortCount(final String database) {
        List<Integer> memberIds = companyRoleDao.queryCompanyPortMember(database);
        return Collections3.isNotEmpty(memberIds) ? memberIds.size() : 0;
    }
}
