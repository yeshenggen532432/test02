package com.qweib.cloud.biz.system.controller.plat;

import com.google.common.collect.Lists;
import com.qweib.cloud.biz.common.CnlifeConstants;
import com.qweib.cloud.biz.common.CompanyRoleEnum;
import com.qweib.cloud.biz.common.GeneralControl;
import com.qweib.cloud.biz.common.Response;
import com.qweib.cloud.biz.system.UserContext;
import com.qweib.cloud.biz.system.auth.event.Topics;
import com.qweib.cloud.biz.system.jpush.JpushClassifies;
import com.qweib.cloud.biz.system.jpush.JpushClassifies2;
import com.qweib.cloud.biz.system.service.company.CompanyMemberService;
import com.qweib.cloud.biz.system.service.plat.SysCompanyRoleService;
import com.qweib.cloud.biz.system.service.plat.SysCorporationService;
import com.qweib.cloud.biz.system.service.plat.SysMemService;
import com.qweib.cloud.biz.system.service.plat.SysRoleService;
import com.qweib.cloud.biz.system.service.ws.SysChatMsgService;
import com.qweib.cloud.biz.system.utils.RoleUtils;
import com.qweib.cloud.biz.system.utils.TreeBuilder;
import com.qweib.cloud.biz.system.utils.TreeNode;
import com.qweib.cloud.core.domain.*;
import com.qweib.cloud.core.domain.dto.SysRoleMemberDTO;
import com.qweib.cloud.core.domain.vo.RoleMenuListModel;
import com.qweib.cloud.service.member.common.RoleValueEnum;
import com.qweib.cloud.service.member.domain.corporation.SysCorporationDTO;
import com.qweib.cloud.utils.Collections3;
import com.qweib.cloud.utils.DateTimeUtil;
import com.qweib.cloud.utils.MemberConstants;
import com.qweib.cloud.utils.pinyingTool;
import com.qweib.commons.DateUtils;
import com.qweib.commons.StringUtils;
import com.qweib.commons.exceptions.BizException;
import org.apache.commons.lang3.ArrayUtils;
import org.json.JSONArray;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.*;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/manager")
public class SysCompanyRoleControl extends GeneralControl {
    @Resource
    private SysCompanyRoleService companyRoleService;
    @Resource
    private JpushClassifies jpushClassifies;
    @Resource
    private JpushClassifies2 jpushClassifies2;
    @Resource
    private SysMemService sysMemService;
    @Resource
    private SysChatMsgService sysChatMsgWebService;
    @Autowired
    private CompanyMemberService companyMemberService;
    @Autowired
    private SysRoleService roleService;
    @Autowired
    private SysCorporationService corporationService;
    @Autowired
    @Qualifier("stringRedisTemplate")
    private StringRedisTemplate redisTemplate;

    /**
     * 查询角色菜单应用树
     *
     * @param
     * @param request
     * @param roleId
     * @param tp
     */
    @ResponseBody
    @RequestMapping("companyRoletree")
    public List companyRoletree(HttpServletRequest request, Integer roleId, String tp) {
        SysLoginInfo info = getInfo(request);
        final String database = info.getDatasource();
        if (RoleUtils.hasCompanyAdmin(Lists.newArrayList(roleId), companyRoleService, database)) {
            return this.companyRoleService.queryMenuApplyByCreatorOrAdmin(database, tp, CompanyRoleEnum.COMPANY_ADMIN);
        } else if (RoleUtils.hasCompanyCreator(Lists.newArrayList(roleId), companyRoleService, database)) {
            return this.companyRoleService.queryMenuApplyByCreatorOrAdmin(database, tp, CompanyRoleEnum.COMPANY_CREATOR);
        } else {
            return this.companyRoleService.queryMenuAopplyForRole(roleId, tp, database);
        }
    }

    @GetMapping("member/authority")
    public void getMemberAuthority(HttpServletRequest request, HttpServletResponse response,
                                   @RequestParam("member_id") Integer memberId, @RequestParam("menu_type") String menuType) {
        try {
            SysLoginInfo currentUser = getInfo(request);
            final String database = currentUser.getDatasource();
            List<SysRoleMemberDTO> roleMemberDTOS = companyRoleService.getRoleMemberByMemberId(database, memberId);
            Boolean hasAdmin = roleMemberDTOS.stream()
                    .filter(e -> StringUtils.isNotBlank(e.getRoleCode()))
                    .map(roleMemberDTO -> CompanyRoleEnum.hasAdmin(roleMemberDTO.getRoleCode()))
                    .filter(e -> e)
                    .findFirst()
                    .orElse(false);
            List<SysApplyDTO> applyDTOS;
            // 如果有包含管理员角色，默认获得所有权限
            if (hasAdmin) {
                applyDTOS = this.companyRoleService.queryAdminRoleMenus(database, menuType);
            } else {
                applyDTOS = this.companyRoleService.queryRoleMenus(database, memberId, menuType);
            }
            JSONArray json = new JSONArray(applyDTOS);
            this.sendJsonResponse(response, json.toString());
        } catch (Exception ex) {
            log.error("查询公司角色菜单应用树出错:", ex);
        }
    }

    @GetMapping("member/quickauthority")
    public void getMemberQuickAuthority(HttpServletRequest request, HttpServletResponse response,
                                        @RequestParam("member_id") Integer memberId, @RequestParam("menu_type") String menuType) {
        try {
            SysLoginInfo currentUser = getInfo(request);
            final String database = currentUser.getDatasource();
            List<SysRoleMemberDTO> roleMemberDTOS = companyRoleService.getRoleMemberByMemberId(database, memberId);
            Boolean hasAdmin = roleMemberDTOS.stream()
                    .filter(e -> StringUtils.isNotBlank(e.getRoleCode()))
                    .map(roleMemberDTO -> CompanyRoleEnum.hasAdmin(roleMemberDTO.getRoleCode()))
                    .filter(e -> e)
                    .findFirst()
                    .orElse(false);
            List<SysApplyDTO> applyDTOS;
            // 如果有包含管理员角色，默认获得所有权限
            if (hasAdmin) {
                applyDTOS = this.companyRoleService.queryAdminRoleMenus(database, menuType);
            } else {
                applyDTOS = this.companyRoleService.queryRoleMenus(database, memberId, menuType);
            }
            List<SysApplyDTO> tempApplyDTOS = new ArrayList<SysApplyDTO>();
            if (applyDTOS != null && applyDTOS.size() > 0) {
                for (int i = 0; i < applyDTOS.size(); i++) {
                    SysApplyDTO dto = applyDTOS.get(i);
                    if ("1".equals(dto.getMenuTp())) {
                        continue;
                    }
                    tempApplyDTOS.add(dto);
                }
            }
            JSONArray json = new JSONArray(tempApplyDTOS);
            this.sendJsonResponse(response, json.toString());
        } catch (Exception ex) {
            log.error("查询公司角色菜单应用树出错:", ex);
        }
    }

    /**
     * 保存角色的菜单应用关系
     *
     * @param response
     * @param request
     * @param companyroleId
     * @param menuapplytype
     */
    @RequestMapping("saveRoleMenuApply")
    public void saveRoleMenuApply(HttpServletResponse response, HttpServletRequest request, Integer companyroleId, String menuapplytype,
                                  RoleMenuListModel roleMenu) {
        try {
            SysLoginInfo info = getInfo(request);
            String datasource = info.getDatasource();
            if (Collections3.isNotEmpty(roleMenu.getRoleMenu())) {
                for (SysRoleMenu menu : roleMenu.getRoleMenu()) {
                    if (!Objects.equals("4", menu.getDataTp())) {
                        menu.setMids(StringUtils.EMPTY);
                    }
                }
            }
            SysRole sysRole = companyRoleService.queryById(datasource, companyroleId);
            final String roleCode = sysRole.getRoleCd();
            if (RoleValueEnum.isAdmin(roleCode) ||
                    RoleValueEnum.isCreator(roleCode) ||
                    RoleValueEnum.isSalesman(roleCode) ||
                    RoleValueEnum.isGeneralStaff(roleCode) ||
                    RoleValueEnum.isExecutiveStaff(roleCode)) {
                this.sendHtmlResponse(response, "系统角色不允许修改");
                return;
            }
            Boolean rst = companyRoleService.updateRoleMenuApply(companyroleId, menuapplytype, roleMenu, datasource);
            if (rst && "2".equals(menuapplytype)) {//公司角色分配应用成功,通知移动端
                List<SysChatMsg> sys = new ArrayList<SysChatMsg>();
                StringBuffer str = new StringBuffer();
                //根据角色id查询角色下的全部成员
                List<SysMemDTO> memList = this.sysMemService.queryCompanyRoleMem(companyroleId, datasource);
                //推送消息
                if (memList.size() > 0) {
                    for (SysMemDTO memberDTO : memList) {
                        SysChatMsg scm = new SysChatMsg();
                        scm.setAddtime(DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd HH:mm:ss"));
                        scm.setMemberId(info.getIdKey());
                        scm.setReceiveId(memberDTO.getMemberId());
                        scm.setMsg("角色应用菜单变更，请重新登录");
                        scm.setTp("35");
                        scm.setMsgTp("1");// 发表类型1.文字2.图片3.语音;
                        sys.add(scm);
                        str.append(memberDTO.getMemberMobile() + ",");
                    }
                    this.sysChatMsgWebService.addChatMsg(sys, datasource);
                    String remind = str.substring(0, str.length() - 1);
                    //jpushClassifies.toJpush(remind, CnlifeConstants.MODE6, CnlifeConstants.NEWMSG, null, null, "角色应用菜单变更推送", "2");//不屏蔽
                    //jpushClassifies2.toJpush(remind, CnlifeConstants.MODE6, CnlifeConstants.NEWMSG, null, null, "角色应用菜单变更推送", "2");//不屏蔽
                }
            }
            redisTemplate.convertAndSend(Topics.EVICT_USER_PERMISSION, info.getDatasource());
            this.sendHtmlResponse(response, "2");
        } catch (Exception e) {
            log.error("保存角色的菜单应用关系出错:", e);
        }
    }

    /**
     * 保存公司成员角色关系
     *
     * @param request
     * @param roleid
     * @param usrid
     */
    @ResponseBody
    @RequestMapping("saveCompanyroleusr")
    public Response saveCompanyroleusr(HttpServletRequest request, Integer roleid, Integer[] usrid) {
        try {
            SysLoginInfo info = getInfo(request);
            final String database = info.getDatasource();
            final Integer companyId = StringUtils.toInteger(info.getFdCompanyId());
            SysRole roleInfo = roleService.queryRoleById(roleid, database);
            // 如果要分配的角色是创建者
            if (RoleValueEnum.isCreator(roleInfo.getRoleCd())) {
                if (ArrayUtils.isEmpty(usrid) || usrid.length > 1) {
                    return Response.createError("只能分配一个创建者");
                }

                final int targetMemberId = usrid[0];
                if (targetMemberId == info.getIdKey()) {
                    return Response.createError("自己已分配该角色");
                }

                companyMemberService.updateMemberCreator(database, roleid, info.getIdKey(), targetMemberId);

                info.getUsrRoleIds().remove(roleid);
                setLoginInfo(request, info);
            } else if (RoleValueEnum.isAdmin(roleInfo.getRoleCd())) {
                // 如果要分配的角色是管理员
                if (ArrayUtils.isEmpty(usrid) || usrid.length > 1) {
                    return Response.createError("只能分配一个管理员");
                }

                this.companyMemberService.updateAssignAdmin(database, StringUtils.toInteger(info.getFdCompanyId()), info.getIdKey(), usrid[0]);
                info.getUsrRoleIds().remove(roleid);
                setLoginInfo(request, info);
            } else if (RoleValueEnum.isSalesman(roleInfo.getRoleCd())) {
                // 如果是业务员
                SysCorporation corporationDTO = corporationService.get(StringUtils.toInteger(info.getFdCompanyId()));
                Integer salesmanCount = 100;//StringUtils.toInteger(corporationDTO.getSalesmanCount());
                if (usrid.length > salesmanCount) {
                    return Response.createError("分配失败，已超过可分配的业务员人数");
                }

                List<SysMember> members = Arrays.stream(usrid).map(memberId -> sysMemService.queryMemById(memberId, database))
                        .collect(Collectors.toList());
                this.companyRoleService.updateSalesmanRoleMember(roleid, usrid, members, database, companyId);
            } else {
                this.companyRoleService.updateCompanyRoleUsr(usrid, roleid, database, companyId);
            }
            return Response.createSuccess().setMessage("操作成功");
        } catch (BizException ex) {
            return Response.createError(ex.getMessage());
        } catch (Exception ex) {
            log.error("添加公司角色与用户对应表出错:", ex);
            return Response.createError("分配失败");
        }
    }

    /**
     * 查询公司角色列表
     *
     * @param response
     * @param request
     */
    @RequestMapping("queryRoleList")
    public void queryRoleList(HttpServletResponse response, HttpServletRequest request) {
        try {
            SysLoginInfo info = getInfo(request);
            List<SysRole> roleList = this.companyRoleService.queryRoleList(info.getDatasource());
            JSONArray json = new JSONArray(roleList);
            this.sendJsonResponse(response, json.toString());
        } catch (Exception ex) {
            log.error("查询公司角色列表出错:", ex);
        }
    }

    /**
     * 说明：根据角色，菜单修改用户
     *
     * @创建：作者:llp 创建时间：2017-7-19
     * @修改历史： [序号](llp 2017 - 7 - 19)<修改说明>
     */
    @RequestMapping("updateUsrByjc")
    public void updateUsrByjc(HttpServletResponse response, HttpServletRequest request, Integer roleid2, Integer cdid, String usrid2) {
        try {
            SysLoginInfo info = getInfo(request);
            this.companyRoleService.updateUsrByjc(roleid2, cdid, usrid2, info.getDatasource());
            this.sendHtmlResponse(response, roleid2.toString());
        } catch (Exception ex) {
            log.error("根据角色，菜单修改用户出错:", ex);
            this.sendHtmlResponse(response, "-1");
        }
    }


    /**
     * 转移创建者
     *
     * @return
     */
//    @ResponseBody
//    @PostMapping("company/role/creator/change")
//    public Response<String> changeCreator(@RequestParam("member_id") Integer memberId, HttpServletRequest request) {
//        SysLoginInfo loginUser = getLoginInfo(request);
//        if (Objects.equals(loginUser.getIdKey(), memberId)) {
//            return Response.createError("自己已经是创建者，不需要转换");
//        }
//        final String database = loginUser.getDatasource();
//        SysRole creatorRole = Optional.ofNullable(companyRoleService.queryRoleByRolecd(CompanyRoleEnum.COMPANY_CREATOR.getRole(), database))
//                .orElseThrow(() -> new BizException("没有创建者角色，不能进行操作"));
//
//        companyMemberService.updateMemberCreator(database, creatorRole.getIdKey(), loginUser.getIdKey(), memberId);
//        loginUser.getUsrRoleIds().remove(creatorRole.getIdKey());
//        setLoginInfo(request, loginUser);
//
//        return Response.createSuccess().setMessage("转移成功");
//    }

    /**
     * 移除创建者会员
     *
     * @param memberIds
     * @return
     */
    @ResponseBody
    @PostMapping("company/role/creator/delete")
    public Response<String> deleteCompanyCreator(@RequestParam("usrid") Integer[] memberIds) {
        SysLoginInfo loginUser = UserContext.getLoginInfo();
        final String database = loginUser.getDatasource();

        try {
            companyMemberService.deleteCompanyCreator(database, loginUser.getIdKey(), Lists.newArrayList(memberIds));
            return Response.createSuccess().setMessage("操作成功");
        } catch (BizException e) {
            return Response.createError(e.getMessage());
        }
    }

    /**
     * 转移管理员
     *
     * @param memberId
     * @return
     */
    @ResponseBody
    @PostMapping("company/role/admin/assign")
    public Response<String> assignAdmin(@RequestParam("usrid") Integer memberId,
                                        HttpServletRequest request) {
        SysLoginInfo loginUser = UserContext.getLoginInfo();
        final String database = loginUser.getDatasource();
        if (RoleUtils.hasCompanyRoles(loginUser.getUsrRoleIds(),
                new CompanyRoleEnum[]{CompanyRoleEnum.COMPANY_CREATOR, CompanyRoleEnum.COMPANY_ADMIN},
                companyRoleService, database)) {
            // 公司管理员 或公司创建者才能执行
            Integer adminRoleId = this.companyMemberService.updateAssignAdmin(database, StringUtils.toInteger(loginUser.getFdCompanyId()), loginUser.getIdKey(), memberId);
            if (!Objects.equals(loginUser.getIdKey(), memberId)) {
                loginUser.getUsrRoleIds().remove(adminRoleId);
                setLoginInfo(request, loginUser);
            }
            return Response.createSuccess().setMessage("转移成功");
        } else {
            return Response.createError("只有创建者与管理员才能指定管理员");
        }
    }

    /**
     * 转移系统管理员
     *
     * @param memberInput
     * @return
     */
    @ResponseBody
    @PostMapping("company/role/admin/save")
    public Response<String> settingAdmin(SysMember memberInput) {
        SysLoginInfo loginUser = UserContext.getLoginInfo();
        final String database = loginUser.getDatasource();

        Boolean existMobile = companyMemberService.existMobile(database, memberInput.getMemberMobile());
        if (existMobile) {
            return Response.createError("该手机号已存在，不能进行注册");
        }

        memberInput.setFirstChar(pinyingTool.getFirstLetter(memberInput.getMemberNm()).toUpperCase());
        memberInput.setMemberCreatime(DateUtils.getDateTime());
        memberInput.setMemberCompany(loginUser.getFdCompanyNm());
        memberInput.setUnitId(Integer.valueOf(loginUser.getFdCompanyId()));
        memberInput.setMemberCreator(loginUser.getIdKey());
        memberInput.setDatasource(database);
        memberInput.setMemberActivate("1");
        memberInput.setMemberUse("1");
        memberInput.setState("2");
        memberInput.setRegisterSource(MemberConstants.REGISTER_SOURCE_TRANSFER_ADMIN);

        this.companyMemberService.saveAdminMember(memberInput);

        return Response.createSuccess().setMessage("转移成功");
    }

    /**
     * 移除管理员
     *
     * @param memberIds
     * @return
     */
    @ResponseBody
    @PostMapping("company/role/admin/delete")
    public Response<String> deleteCompanyAdmin(@RequestParam("usrid") Integer[] memberIds) {
        SysLoginInfo loginUser = UserContext.getLoginInfo();
        final String database = loginUser.getDatasource();

        try {
            companyMemberService.deleteCompanyAdmin(database, StringUtils.toInteger(loginUser.getFdCompanyId()), loginUser.getIdKey(), Lists.newArrayList(memberIds));
            return Response.createSuccess().setMessage("操作成功");
        } catch (BizException e) {
            return Response.createError(e.getMessage());
        }
    }

    /**
     * 打开指定管理员页面
     *
     * @param response
     * @param request
     */
    @RequestMapping("company/role/admin/setCreator")
    public String setCreator(HttpServletResponse response, HttpServletRequest request) {
        return "publicplat/creator/setCreator";
    }

//    /**
//     * 查询角色菜单应用树
//     */
//    @RequestMapping("companyRoletree")
//    public void companyRoletree(HttpServletResponse response, HttpServletRequest request, Integer roleId, String tp) {
//        try {
//            SysLoginInfo info = getInfo(request);
//            List<SysApplyDTO> menuApplys;
//            final String database = info.getDatasource();
//            if (RoleUtils.hasCompanyAdmin(Lists.newArrayList(roleId), companyRoleService, database)) {
//                menuApplys = this.companyRoleService.queryMenuApplyByCreatorOrAdmin(database, tp, CompanyRoleEnum.COMPANY_ADMIN);
//            } else if (RoleUtils.hasCompanyCreator(Lists.newArrayList(roleId), companyRoleService, database)) {
//                menuApplys = this.companyRoleService.queryMenuApplyByCreatorOrAdmin(database, tp, CompanyRoleEnum.COMPANY_CREATOR);
//            } else {
//                menuApplys = this.companyRoleService.queryMenuAopplyForRole(roleId, tp, database);
//            }
//            JSONArray json = new JSONArray(menuApplys);
//            this.sendJsonResponse(response, json.toString());
//        } catch (Exception ex) {
//            log.error("查询公司角色菜单应用树出错:", ex);
//        }
//    }

    /**
     * 查询角色菜单应用树
     *
     * @param response
     * @param request
     * @param roleId
     * @param tp
     */
    @RequestMapping("companyRoletree_new")
    public void companyRoletree_new(HttpServletResponse response, HttpServletRequest request, Integer roleId, String tp) {
        try {
            SysLoginInfo info = getInfo(request);
            List<SysApplyDTO> menuApplys;
            if (RoleUtils.hasCompanyAdmin(Lists.newArrayList(roleId), companyRoleService, info.getDatasource())) {
                menuApplys = this.companyRoleService.queryMenuApplyByCreatorOrAdmin(info.getDatasource(), tp, CompanyRoleEnum.COMPANY_ADMIN);
            } else if (RoleUtils.hasCompanyCreator(Lists.newArrayList(roleId), companyRoleService, info.getDatasource())) {
                menuApplys = this.companyRoleService.queryMenuApplyByCreatorOrAdmin(info.getDatasource(), tp, CompanyRoleEnum.COMPANY_CREATOR);
            } else {
                menuApplys = this.companyRoleService.queryMenuAopplyForRole(roleId, tp, info.getDatasource());
            }
            if (null != menuApplys && menuApplys.size() > 0) {
                List<TreeNode> nodeList = new ArrayList<>();
                //默认添加"根节点"（全选）:备注要加不然数据出不来
                TreeNode rootNode = new TreeNode();
                rootNode.setId("0");
                rootNode.setpId("-1");
                rootNode.setText("根节点");
                nodeList.add(rootNode);
                for (SysApplyDTO apply : menuApplys) {
                    TreeNode node = new TreeNode();
                    int pid = apply.getPId();
                    Integer id = apply.getId();
                    String applyName = apply.getApplyName();
                    int applyNo = apply.getApplyNo();
                    Integer menuId = apply.getMenuId();
                    String menuTp = apply.getMenuTp();
                    String menuLeaf = apply.getMenuLeaf();
                    String sgtjz = apply.getSgtjz();
                    String mids = apply.getMids();

                    node.setId(String.valueOf(id));
                    node.setpId(String.valueOf(pid));
                    node.setText(applyName);
                    node.setMenuId(String.valueOf(menuId));
                    node.setMenuTp(menuTp);
                    node.setMenuLeaf(menuLeaf);
                    node.setSgtjz(sgtjz);
                    node.setMids(mids);
                    if (applyNo == 0) {
                        node.setChecked(false);
                    } else {
                        node.setChecked(true);
                    }
                    nodeList.add(node);
                }
                List<TreeNode> trees = TreeBuilder.bulid(nodeList);
                this.sendJsonResponse(response, trees.toString());
            }
        } catch (Exception ex) {
            log.error("查询公司角色菜单应用树出错:", ex);
        }
    }


}
