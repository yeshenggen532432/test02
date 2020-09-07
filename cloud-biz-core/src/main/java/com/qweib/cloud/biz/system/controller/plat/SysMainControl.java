package com.qweib.cloud.biz.system.controller.plat;

import com.google.common.collect.Lists;
import com.qweib.cloud.biz.common.CnlifeConstants;
import com.qweib.cloud.biz.common.GeneralControl;
import com.qweib.cloud.biz.common.JavaSmsApi;
import com.qweib.cloud.biz.common.Response;
import com.qweib.cloud.biz.system.UserContext;
import com.qweib.cloud.biz.system.ViewContext;
import com.qweib.cloud.biz.system.auth.AuthManager;
import com.qweib.cloud.biz.system.controller.plat.vo.MenuHelper;
import com.qweib.cloud.biz.system.controller.plat.vo.MenuItem;
import com.qweib.cloud.biz.system.controller.plat.vo.SmsMessage;
import com.qweib.cloud.biz.system.service.plat.SysCompanyRoleService;
import com.qweib.cloud.biz.system.service.plat.SysLoginService;
import com.qweib.cloud.biz.system.service.plat.SysMemberService;
import com.qweib.cloud.core.domain.SysLoginInfo;
import com.qweib.cloud.core.domain.SysRole;
import com.qweib.cloud.service.member.common.CertifyStateEnum;
import com.qweib.cloud.utils.Collections3;
import com.qweib.cloud.utils.StrUtil;
import com.qweib.commons.StringUtils;
import com.qweibframework.commons.mapper.JsonMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.stream.Collectors;

@Controller
public class SysMainControl extends GeneralControl {
    @Resource
    private SysLoginService loginService;
    @Resource
    private SysCompanyRoleService sysCompanyRoleService;
    @Autowired
    private SysMemberService memberService;
    @GetMapping("manager/dashboard")
    public String dashboard() {
        return "main/dashboard";
    }

    @GetMapping("manager/switch")
    public String switchVersion() {
        return "redirect:/";
    }
    @Autowired
    private AuthManager authManager;

    /**
     * 摘要：
     *
     * @return
     * @说明：去首页
     * @创建：作者:yxy 创建时间：2013-4-8
     * @修改历史： [序号](yxy 2013 - 4 - 8)<修改说明>
     */
    @RequestMapping(value = {"/", "/manager/index"})
    public String toMainIndex(Model model, HttpServletRequest request, Integer pId, @RequestParam(value = "optype", defaultValue = "1") String optype) {
        SysLoginInfo info = this.getLoginInfo(request);
        if (!info.getCertifyState().hasCertified()) {
            model.addAttribute("memberName", info.getUsrNm());
            model.addAttribute("memberMobile", info.getFdMemberMobile());
            // 未认证，跳转到认证页面
            return "main/member_certify";
        }

/*        final Integer companyId = StringUtils.toInteger(info.getFdCompanyId());
        if (MathUtils.valid(companyId)) {
            final SysCorporation companyDTO = this.corporationService.queryCorporationById(companyId);
            final ClusterNodeDTO nodeDTO = this.nodeRedisHandler.getCurrentNode(companyDTO.getNodeId());
            if (nodeDTO != null) {
                String redirectUrl = ClusterNodeRedisHandler.getRedirectUrl(nodeDTO.getDomainName());
                if (!StringUtils.startsWith(request.getRequestURL(), redirectUrl)) {
                    String key = this.nodeRedisHandler.putNodeKey(info);
                    return "redirect:" + redirectUrl + "node_redirect?key=" + key;
                }
            }
        }*/

        //根据登录的角色获取所有菜单
        List<Map<String, Object>> menus = new ArrayList<>();
        List<Integer> roles = new ArrayList<>();
        if (Collections3.isNotEmpty(info.getUsrRoleIds())) {
            roles.addAll(info.getUsrRoleIds());
        }

        if ("1".equals(optype)) {//公司内角色
            getMenusByRole(menus, roles, info);
        }
        if(Collections3.isNotEmpty(menus)){
            List<String> menuList = menus.stream()
                    .filter(m -> StringUtils.isNotEmpty((String) m.get("menu_url")))
                    .map(m -> (String) m.get("menu_url"))
                    .collect(Collectors.toList());
            authManager.getUserPermissionHex(menuList, info.getDatasource(), info.getIdKey());
        }

        List<MenuItem> items = MenuHelper.build(menus);
        model.addAttribute("menuItems", items);
        model.addAttribute("optype", optype);
        //父级菜单
        analysisMenus(model, pId, optype, menus);
        ViewContext.setVersion("v2");
        return "main/index";
    }

    /**
     * 跳转设置管理员界面
     *
     * @return
     */
    @GetMapping("manager/admin/setting")
    public String gotoSettingAdmin(HttpServletRequest request, Model model) {
        SysLoginInfo info = this.getLoginInfo(request);
        model.addAttribute("memberId", info.getIdKey());
        return "main/setting_admin";
    }

    /**
     * 获取指定角色的菜单列表
     *
     * @param menus
     * @param roles
     * @param info
     */
    private void getMenusByRole(List<Map<String, Object>> menus, List<Integer> roles, SysLoginInfo info) {
        if (Collections3.isEmpty(roles)) {
            return;
        }

        String datasource = info.getDatasource();
        SysRole role = null;
        try {
            // 获取公司管理员角色
            role = sysCompanyRoleService.queryRoleByRolecd(CnlifeConstants.ROLE_GSCJZ, datasource);
        } catch (Exception e) {
        }
        if (role != null) {
            List<Map<String, Object>> tmpMenus;
            if (roles.contains(role.getIdKey())) {
                // 公司管理员
                tmpMenus = sysCompanyRoleService.queryRoleForCompanyAdmin(datasource);
            } else {
                tmpMenus = sysCompanyRoleService.queryRoleMenus(info.getIdKey(), null, datasource);
            }

            if (Collections3.isNotEmpty(tmpMenus)) {
                menus.addAll(tmpMenus);
            }
        }

//        List<Map<String, Object>> creatorMenus = MenuUtils.getCompanyCreatorMenuMap(datasource, roles, sysCompanyRoleService);
//        if (Collections3.isNotEmpty(creatorMenus)) {
//            menus.addAll(creatorMenus);
//        }
    }

    @GetMapping("manager/menus")
    @ResponseBody
    public Response getMenus(Integer pid, String optype) {
        List<Map<String, Object>> menus = new ArrayList<Map<String, Object>>();
        List<Integer> roles = new ArrayList<Integer>();
        SysLoginInfo info = UserContext.getLoginInfo();
        if (Collections3.isNotEmpty(info.getUsrRoleIds())) {
            roles.addAll(info.getUsrRoleIds());
        }

//        if ("1".equals(optype)) {//公司内角色
            getMenusByRole(menus, roles, info);
//        } else {//平台角色
//            for (Integer integer : roles) {
//                List<Map<String, Object>> temps = RoleMenus.roleMenus.get(integer);
//                if (Collections3.isNotEmpty(temps)) {
//                    menus.addAll(temps);
//                }
//            }
//        }
        //analysisMenus(model, pId, optype, menus);
        return Response.createSuccess(MenuHelper.build(menus));
    }


    @RequestMapping("manager/getNewMunus")
    public String getNewMunus(Model model, HttpServletResponse response, HttpServletRequest request, Integer pId, String optype) {
        //根据登录的角色获取所有菜单
        List<Map<String, Object>> menus = new ArrayList<Map<String, Object>>();
        List<Integer> roles = new ArrayList<Integer>();
        SysLoginInfo info = this.getLoginInfo(request);
        if (Collections3.isNotEmpty(info.getUsrRoleIds())) {
            roles.addAll(info.getUsrRoleIds());
        }

//        if ("1".equals(optype)) {//公司内角色
            getMenusByRole(menus, roles, info);
//        } else {//平台角色
//            for (Integer integer : roles) {
//                List<Map<String, Object>> temps = RoleMenus.roleMenus.get(integer);
//                if (Collections3.isNotEmpty(temps)) {
//                    menus.addAll(temps);
//                }
//            }
//        }
        analysisMenus(model, pId, optype, menus);

        return "main/left";
    }

    private void analysisMenus(Model model, Integer pId, String optype, List<Map<String, Object>> menus) {
        //父级菜单
        List<Map<String, Object>> childrenMenu = new ArrayList<>();
        //导航菜单
        List<Map<String, Object>> topMenus = new ArrayList<>();
        if (Collections3.isNotEmpty(menus)) {
            if (null == pId) {
                //无导航栏父id，默认使用第一个
                for (Map<String, Object> map : menus) {
                    int p_id = StrUtil.convertInt(map.get("p_id"));
                    if (p_id == 0) {
                        pId = StrUtil.convertInt(map.get("id_key"));
                        break;
                    }
                }
            }
            for (Map<String, Object> map : menus) {
                int p_id = StrUtil.convertInt(map.get("p_id"));
                if (p_id == 0) {
                    topMenus.add(map);
                }
                if (p_id == pId) {
                    childrenMenu.add(map);
                }
            }
            if (childrenMenu.size() > 0) {
                model.addAttribute("pmenus", childrenMenu);
            }
            if (topMenus.size() > 0) {
                model.addAttribute("topmenus", topMenus);
            }
            model.addAttribute("pId", pId);
        }
        model.addAttribute("optype", optype);
    }


    /**
     * 获取出纳菜单
     *
     * @author guojr
     */
    @RequestMapping("/manager/getChuNaMunus")
    public String getChuNaMunus(Model model, HttpServletResponse response, HttpServletRequest request, String nms, String optype) {
        //根据登录的角色获取所有菜单
        List<Map<String, Object>> menus = new ArrayList<Map<String, Object>>();
        SysLoginInfo info = this.getLoginInfo(request);
        List<Integer> roles = getRoleIds(info.getUsrRoleIds());
        if ("1".equals(optype)) {//公司内角色
            String datasource = info.getDatasource();
            SysRole role = sysCompanyRoleService.queryRoleByRolecd(CnlifeConstants.ROLE_GSCJZ, datasource);
            if (roles.contains(role.getIdKey())) {//公司管理员
                menus = sysCompanyRoleService.queryRoleForCompanyAdminByNms(datasource, nms);
            } else {
                menus = sysCompanyRoleService.queryRoleMenusByNms(roles, nms, datasource);
            }
        } else {//平台角色
			/*
			for (Integer integer : roles) {
				List<Map<String,Object>> temps = RoleMenus.roleMenus.get(integer);
				menus.addAll(temps);
			}*/
        }
        int len = 0;
        if (menus != null && menus.size() > 0) {
            len = 1;
        }
        model.addAttribute("cnmenus", menus);
        model.addAttribute("len", len);
        return "main/left";
    }

    @RequestMapping("/manager/checkChuNaMunus")
    public void checkChuNaMunus(Model model, HttpServletResponse response, HttpServletRequest request, String nms, String optype) {
        //根据登录的角色获取所有菜单
        List<Map<String, Object>> menus = new ArrayList<Map<String, Object>>();
        List<Integer> roles = new ArrayList<Integer>();
        SysLoginInfo info = this.getLoginInfo(request);
        if (Collections3.isNotEmpty(info.getUsrRoleIds())) {
            roles.addAll(info.getUsrRoleIds());
        }

        if ("1".equals(optype)) {
            //公司内角色
            getMenusByRole(menus, roles, info);
        }

        int len = 0;
        if (menus != null && menus.size() > 0) {
            len = 1;
        }
        model.addAttribute("len", len);
        this.sendJsonResponse(response, len + "");
    }

    /**
     * 摘要：
     *
     * @return
     * @说明：获取下级菜单
     * @创建：作者:yxy 创建时间：2013-5-6
     * @修改历史： [序号](yxy 2013 - 5 - 6)<修改说明>
     */
    @RequestMapping("/manager/nextmenu")
    public String nextmenu(Model model, @RequestParam("id") int parentId, HttpServletRequest request, String optype) {
        //根据登录的角色获取所有菜单
        List<Map<String, Object>> menus = new ArrayList<>();
        SysLoginInfo info = this.getLoginInfo(request);
        List<Integer> roles = getRoleIds(info.getUsrRoleIds());
//        if ("1".equals(optype)) {//公司下的角色配置
            String datasource = info.getDatasource();
            SysRole role = sysCompanyRoleService.queryRoleByRolecd(CnlifeConstants.ROLE_GSCJZ, datasource);
            if (roles.contains(role.getIdKey())) {//公司管理员
                menus = sysCompanyRoleService.queryRoleMenusForCreator(parentId, datasource);
            } else {
                menus = sysCompanyRoleService.queryRoleMenus(info.getIdKey(), parentId, datasource);
            }
            model.addAttribute("menus", menus);
//        } else {
//            if (info.getTpNm().equals("卖场")) {
//                for (Integer roleId : roles) {
//                    List<Map<String, Object>> temps = RoleMenus.roleMenusMc.get(roleId);
//                    menus.addAll(temps);
//                }
//            } else {
//                for (Integer integer : roles) {
//                    List<Map<String, Object>> temps = RoleMenus.roleMenus.get(integer);
//                    menus.addAll(temps);
//                }
//            }
//            //父级菜单
//            List<Map<String, Object>> nextmenus = new ArrayList<Map<String, Object>>();
//            if (menus.size() > 0) {
//                for (Map<String, Object> map : menus) {
//                    int p_id = StrUtil.convertInt(map.get("p_id"));
//                    if (p_id == parentId) {
//                        nextmenus.add(map);
//                    }
//                }
//                if (nextmenus.size() > 0) {
//                    model.addAttribute("menus", nextmenus);
//                }
//            }
//        }
        return "main/menu";
    }

    /**
     * 摘要：
     *
     * @return
     * @说明：首页
     * @创建：作者:yxy 创建时间：2013-4-8
     * @修改历史： [序号](yxy 2013 - 4 - 8)<修改说明>
     */
    @RequestMapping("/manager/main")
    public String toMain() {
        return "main/main";
    }

//    /**
//     * 摘要：
//     *
//     * @说明：获取当前登录人的菜单
//     * @创建：作者:yxy 创建时间：2013-4-8
//     * @修改历史： [序号](yxy 2013 - 4 - 8)<修改说明>
//     */
//    @RequestMapping("/manager/menus")
//    public void queryMyMenus(HttpServletResponse response, String id, HttpServletRequest request) {
//        int pid = 0;
//        if (!StrUtil.isNull(id)) {
//            pid = StrUtil.convertInt(id);
//        }
//        List<Map<String, Object>> menus = new ArrayList<>();
//
//        SysLoginInfo info = this.getLoginInfo(request);
//        List<Integer> roles = getRoleIds(info.getUsrRoleIds());
//        for (Integer roleId : roles) {
//            List<Map<String, Object>> temps = RoleMenus.roleMenus.get(roleId);
//            menus.addAll(temps);
//        }
//        StringBuilder str = new StringBuilder();
//        if (null != menus && menus.size() > 0) {
//            str.append("[");
//            String sp = "";
//            for (Map<String, Object> map : menus) {
//                String menuTp = StrUtil.convertStr(map.get("menu_tp"));
//                if ("0".equals(menuTp)) {
//                    Integer p_id = StrUtil.convertInt(map.get("p_id"));
//                    if (pid == p_id) {
//                        Integer menuId = StrUtil.convertInt(map.get("id_key"));
//                        String menuLeaf = StrUtil.convertStr(map.get("menu_leaf"));
//                        String menuUrl = StrUtil.convertStr2(map.get("menu_url"));
//                        String state = "open";
//                        if ("0".equals(menuLeaf)) {
//                            state = "closed";
//                        }
//                        String menuNm = StrUtil.convertStr(map.get("menu_nm"));
//                        str.append(sp).append("{\"id\":").append(menuId).append(",\"text\":\"")
//                                .append(menuNm).append("\",\"state\":\"").append(state).append("\",\"attributes\":{\"url\":\"")
//                                .append(menuUrl).append("\"}}");
//                        sp = ",";
//                    }
//                }
//            }
//            str.append("]");
//            this.sendJsonResponse(response, str.toString());
//        }
//    }

    private List<Integer> getRoleIds(List<Integer> userRoleIds) {
        if (Collections3.isNotEmpty(userRoleIds)) {
            return userRoleIds;
        } else {
//            Integer roleId = roleService.queryIdByRoleNm(CnlifeConstants.COMMONMEM);
            return Lists.newArrayListWithCapacity(0);
        }
    }

    /**
     * 摘要：
     *
     * @return
     * @说明：修改密码
     * @创建：作者:yxy 创建时间：2013-4-14
     * @修改历史： [序号](yxy 2013 - 4 - 14)<修改说明>
     */
    @RequestMapping("/manager/toupdateusrpwd")
    public String toupdateusrpwd() {
        return "main/updatepwd";
    }

    /**
     * 摘要：
     *
     * @param usrPwd
     * @param newPwd
     * @param confirmPwd
     * @param request
     * @说明：修改密码
     * @创建：作者:yxy 创建时间：2013-4-14
     * @修改历史： [序号](yxy 2013 - 4 - 14)<修改说明>
     */
    @RequestMapping("/manager/updateusrpwd")
    public void updateusrpwd(String usrPwd, String newPwd, String confirmPwd, HttpServletRequest request, HttpServletResponse response) {
        try {
            SysLoginInfo info = this.getLoginInfo(request);
            Boolean result = this.loginService.updatePwd(info.getIdKey(), usrPwd, newPwd);
            if (result) {
                this.sendHtmlResponse(response, "14");
            } else {
                this.sendHtmlResponse(response, "13");
            }
        } catch (Exception e) {
            log.error("修改密码出错：", e);
            this.sendHtmlResponse(response, "4");
        }
    }

    @ResponseBody
    @GetMapping("/manager/member/certify/code")
    public Response<String> getCertifyCode(HttpServletRequest request) {
        SysLoginInfo currentUser = this.getLoginInfo(request);

        final String code = StringUtils.randomNumber(6);
        final String text = "【驰用T3】您的验证码是" + code;
        try {
            String result = JavaSmsApi.sendSms(text, currentUser.getFdMemberMobile());
            SmsMessage message = JsonMapper.getInstance().fromJson(result, SmsMessage.class);
            if (message.isSuccess()) {
                request.getSession().setAttribute(MEMBER_CERTIFY_CODE, code);
                return Response.createSuccess().setMessage("获取验证码成功");
            } else {
                return Response.createError("获取验证码失败");
            }
        } catch (Exception e) {
            return Response.createError("获取验证码失败");
        }
    }

    private static final String MEMBER_CERTIFY_CODE = "manager_member_certify_code";

    @ResponseBody
    @PostMapping("/manager/member/certify")
    public Response<String> memberCertify(@RequestParam String code, HttpServletRequest request, Model model) {
        try {
            SysLoginInfo currentUser = this.getLoginInfo(request);
            String validateCode = (String) request.getSession().getAttribute(MEMBER_CERTIFY_CODE);
            if (StringUtils.isBlank(validateCode)) {
                return Response.createError("请先获取验证码");
            }

            if (!Objects.equals(validateCode, code)) {
                return Response.createError("验证码输入有误");
            }

            this.memberService.updateMemberCertify(currentUser.getIdKey());
            currentUser.setCertifyState(CertifyStateEnum.CERTIFIED);
            setLoginInfo(request, currentUser);
            return Response.createSuccess().setMessage("认证成功");
        } catch (Exception e) {
            log.error("认证失败", e);
        }
        return Response.createError("认证失败");
    }
}
