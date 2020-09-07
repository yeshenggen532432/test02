package com.qweib.cloud.biz.system.controller.plat;

import com.google.common.collect.Maps;
import com.qweib.cloud.biz.common.GeneralControl;
import com.qweib.cloud.biz.common.Response;
import com.qweib.cloud.biz.system.UserContext;
import com.qweib.cloud.biz.system.auth.event.Topics;
import com.qweib.cloud.biz.system.controller.plat.vo.Node;
import com.qweib.cloud.biz.system.service.company.CompanyMemberService;
import com.qweib.cloud.biz.system.service.plat.SysCompanyRoleService;
import com.qweib.cloud.biz.system.service.plat.SysCorporationService;
import com.qweib.cloud.biz.system.service.plat.SysRoleService;
import com.qweib.cloud.biz.system.service.ws.SysDepartService;
import com.qweib.cloud.core.domain.*;
import com.qweib.cloud.core.domain.vo.SysRoleVO;
import com.qweib.cloud.service.member.common.RoleValueEnum;
import com.qweib.cloud.service.member.domain.corporation.SysCorporationDTO;
import com.qweib.cloud.utils.Collections3;
import com.qweib.cloud.utils.DateTimeUtil;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import com.qweib.commons.MathUtils;
import com.qweib.commons.StringUtils;
import com.qweib.commons.exceptions.BizException;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.*;
import java.util.stream.Collectors;

/**
 * 说明：角色Control
 *
 * @创建：作者:yxy 创建时间：2013-4-7
 * @修改历史： [序号](yxy 2013 - 4 - 7)<修改说明>
 */
@Controller
@RequestMapping("/manager")
public class SysRoleControl extends GeneralControl {
    @Resource
    private SysRoleService roleService;
    @Resource
    private SysCompanyRoleService companyRoleService;
    @Resource
    private SysDepartService departService;
    @Autowired
    private CompanyMemberService companyMemberService;
    @Autowired
    private SysCorporationService corporationService;
    @Autowired
    @Qualifier("stringRedisTemplate")
    private StringRedisTemplate redisTemplate;

    /**
     * 摘要：
     *
     * @return
     * @说明：角色主页
     * @创建：作者:yxy 创建时间：2013-4-11
     * @修改历史：
     */
    @RequestMapping("/queryrole")
    public String queryrole() {
        return "";
        //return "system/role/role";
    }

    @RequestMapping("/queryrole_company")
    public String queryrole_company(HttpServletRequest request, Model model) {
        SysLoginInfo currentUser = this.getLoginInfo(request);
        Integer allocPortCount = companyRoleService.getCompanyAllocPortCount(StringUtils.toInteger(currentUser.getFdCompanyId()));
        if (Objects.nonNull(allocPortCount) && !Objects.equals(allocPortCount, -1)) {
            Integer usedPortCount = companyRoleService.getCompanyUsedPortCount(currentUser.getDatasource());
            model.addAttribute("allocPortCount", allocPortCount);
            model.addAttribute("usedPortCount", usedPortCount);
        }
        model.addAttribute("companyCreator", companyMemberService.getCompanyCreator(currentUser.getDatasource(), StringUtils.toInteger(currentUser.getFdCompanyId())));
        return "/companyPlat/role/role";
    }

    /**
     * 摘要：
     *
     * @说明：角色分页
     * @创建：作者:yxy 创建时间：2013-4-11
     * @修改历史：
     */
    @RequestMapping("rolepages_company")
    public void rolepages_company(HttpServletResponse response, HttpServletRequest request, SysRole role, Integer page, Integer rows) {
        try {
            SysLoginInfo info = this.getLoginInfo(request);
            Page p = this.companyRoleService.queryRole(role, page, rows, info.getDatasource());
            List<SysRoleVO> list = p.getRows();
            list = list.stream()
                    .filter(e -> !RoleValueEnum.isSalesman(e.getRoleCd()))
                    .collect(Collectors.toList());
            JSONObject json = new JSONObject();
            json.put("total", p.getTotal());
            json.put("rows", list);
            this.sendJsonResponse(response, json.toString());
            p = null;
        } catch (Exception e) {
            log.error("角色分页出错：", e);
        }
    }

    @RequestMapping("/rolepages")
    public void rolepages(HttpServletResponse response, HttpServletRequest request, SysRole role, Integer page, Integer rows) {
        queryRolePage(response, request, role, page, rows, null);
    }

    private void queryRolePage(HttpServletResponse response, HttpServletRequest request, SysRole role,
                               Integer page, Integer rows, String optype) {
        try {
            SysLoginInfo info = this.getLoginInfo(request);
            Page p = this.companyRoleService.queryRole(role, page, rows, info.getDatasource());
            JSONObject json = new JSONObject();
            json.put("total", p.getTotal());
            json.put("rows", p.getRows());
            this.sendJsonResponse(response, json.toString());
            p = null;
        } catch (Exception e) {
            log.error("角色分页出错：", e);
        }
    }

    @ResponseBody
    @RequestMapping("updateRoleStatus")
    public Response updateRoleStatus(Integer idKey, Integer status) {
        SysLoginInfo info = UserContext.getLoginInfo();
        roleService.updateRoleStatus(idKey, status, info.getDatasource());
        redisTemplate.convertAndSend(Topics.EVICT_USER_PERMISSION, info.getDatasource());
        return Response.createSuccess();

    }

    /**
     * 摘要：
     *
     * @说明：操作角色
     * @创建：作者:yxy 创建时间：2013-4-12
     * @修改历史： [序号](yxy 2013 - 4 - 12)<修改说明>
     */
    @RequestMapping("operCompanyrole_company")
    public void operCompanyrole_company(SysRole role, HttpServletResponse response, HttpServletRequest request) {
        toOperrole(role, response, request, "1");
    }

    @RequestMapping("/operrole")
    public void operrole(SysRole role, HttpServletResponse response, HttpServletRequest request) {
        toOperrole(role, response, request, null);
    }

    private void toOperrole(SysRole role, HttpServletResponse response,
                            HttpServletRequest request, String optype) {
        if (null != role) {
            try {
                SysLoginInfo info = this.getLoginInfo(request);
                String datasource = "";
                if ("1".equals(optype)) {//公司角色
                    datasource = info.getDatasource();
                }
                if (null == role.getIdKey()) {
                    String createDt = DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd");
                    role.setCreateDt(createDt);
                    role.setCreateId(info.getIdKey());
                    this.roleService.addRole(role, datasource);
                    this.sendHtmlResponse(response, "1");
                } else {
                    this.roleService.updateRole(role, datasource);
                    this.sendHtmlResponse(response, "2");
                }
            } catch (Exception e) {

                if (e instanceof BizException) {  //捕获抛出的异常
                    this.sendHtmlResponse(response, "3");
                    return;
                }
                log.error("操作角色出错：", e);
                this.sendHtmlResponse(response, "4");
            }
        }
    }

    /**
     * 摘要：
     *
     * @param id
     * @param response
     * @说明：获取角色对象
     * @创建：作者:yxy 创建时间：2013-4-12
     * @修改历史： [序号](yxy 2013 - 4 - 12)<修改说明>
     */
    @RequestMapping("getrole_company")
    public void getrole_company(Integer id, HttpServletResponse response, HttpServletRequest request) {
        getroleById(id, response, request, "1");
    }

    @RequestMapping("/getrole")
    public void getrole(Integer id, HttpServletResponse response, HttpServletRequest request) {
        getroleById(id, response, request, null);
    }

    private void getroleById(Integer id, HttpServletResponse response, HttpServletRequest request, String optype) {
        try {
            String datasource = "";
            SysLoginInfo info = this.getLoginInfo(request);
            if ("1".equals(optype)) {//公司角色
                datasource = info.getDatasource();
            }
            SysRole role = this.roleService.queryRoleById(id, datasource);
            JSONObject json = new JSONObject(role);
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            log.error("获取角色对象出错：", e);
        }
    }

    /**
     * 摘要：
     *
     * @param id
     * @说明：删除角色
     * @创建：作者:yxy 创建时间：2013-4-12
     * @修改历史： [序号](yxy 2013 - 4 - 12)<修改说明>
     */
    @ResponseBody
    @RequestMapping("/delrole_company")
    public Response delCompanyRole(Integer id, HttpServletRequest request) {
        return toDelrole(id, request);
    }

//    @RequestMapping("/delrole")
//    public void delrole(Integer id, HttpServletResponse response, HttpServletRequest request) {
//        toDelrole(id, response, request, null);
//    }

    private Response toDelrole(Integer id, HttpServletRequest request) {
        try {
            SysLoginInfo info = getInfo(request);
            this.roleService.deleteRoles(info.getDatasource(), id);
            return Response.createSuccess().setMessage("删除成功");
        } catch (BizException e) {
            return Response.createError(e.getMessage());
        } catch (Exception e) {
            log.error("删除角色对象出错：", e);

            return Response.createError("删除出错");
        }
    }

    /**
     * 摘要：
     *
     * @param id
     * @param response
     * @说明：查询权限树
     * @创建：作者:yxy 创建时间：2013-4-13
     * @修改历史： [序号](yxy 2013 - 4 - 13)<修改说明>
     */
    @RequestMapping("/menutree")
    public void menutree(Integer id, HttpServletResponse response) {
        try {
            List<SysMenu> menus = this.roleService.queryMenuByPidForRole(id);
            JSONArray json = new JSONArray(menus);
            this.sendJsonResponse(response, json.toString());
            menus = null;
        } catch (Exception ex) {
            log.error("查询权限树出错:" + ex);
        }
    }

    /**
     * 摘要：添加角色与用户权限
     *
     * @return
     * @说明：
     * @创建：作者:yxy 创建时间：2011-6-13
     * @修改历史： [序号](yxy 2011 - 6 - 13)<修改说明>
     */
    @RequestMapping("/saverolemenu")
    public void saverolemenu(Integer roleid, Integer[] menuid, HttpServletResponse response) {
        try {
            this.roleService.updateRoleMenu(menuid, roleid);
            this.sendHtmlResponse(response, "2");
        } catch (Exception ex) {
            log.error("添加角色与菜单对应表出错:" + ex);
            this.sendHtmlResponse(response, "4");
        }
    }

    /**
     * 摘要：
     *
     * @param id
     * @param response
     * @说明：查询用户树
     * @创建：作者:yxy 创建时间：2013-4-13
     * @修改历史： [序号](yxy 2013 - 4 - 13)<修改说明>
     */
    @RequestMapping("/usrtree_company")
    public void usrtree_company(Integer id, HttpServletResponse response, HttpServletRequest request) {
        toUsrtree(request, response, id, "1");
    }

    @RequestMapping("/usrtree")
    public void usrtree(Integer id, HttpServletResponse response, HttpServletRequest request) {
        toUsrtree(request, response, id, null);
    }

    private void toUsrtree(HttpServletRequest request, HttpServletResponse response, Integer id, String optype) {
        try {
            SysLoginInfo info = getInfo(request);
            String datasource = "";
            if ("1".equals(optype)) {//公司角色
                datasource = info.getDatasource();
            }
            List<Map<String, Object>> usrs = this.roleService.queryUsrForRole(id, datasource);
            StringBuilder str = new StringBuilder();
            if (null != usrs && usrs.size() > 0) {
                str.append("[");
                String sp = "";
                for (Map<String, Object> map : usrs) {
                    str.append(sp).append("{\"usrid\":").append(map.get("member_id"));
                    str.append(",\"usrnm\":\"").append(map.get("member_nm"));
                    Integer owner = StringUtils.toInteger(map.get("owner"));
                    owner = owner > 0 ? 1 : 0;
                    str.append("\",\"isuse\":").append(owner).append("}");
                    sp = ",";
                }
                str.append("]");
                this.sendJsonResponse(response, str.toString());
            }
        } catch (Exception e) {
            log.error("查询用户树出错:", e);
        }
    }

    /**
     * 摘要：
     *
     * @param roleid
     * @param response
     * @说明：查询用户树2
     * @创建：作者:llp 创建时间：2017-7-19
     * @修改历史： [序号](llp 2017 - 7 - 19)<修改说明>
     */
    @RequestMapping("/usrtree_company2")
    public void usrtree_company2(Integer roleid, Integer cdid, String mids, HttpServletResponse response, HttpServletRequest request) {
        try {
            SysLoginInfo info = getInfo(request);
            List<Map<String, Object>> usrs = this.roleService.queryUsrForRole2(roleid, cdid, mids, info.getDatasource());
            List<SysDepart> list = this.departService.queryDepartsForAllz(info.getDatasource());
            for (int i = 0; i < list.size(); i++) {
                Map<String, Object> m = new HashMap<String, Object>();
                m.put("member_id", list.get(i).getBranchId());
                m.put("member_nm", list.get(i).getBranchName());
                m.put("branch_id", 0);
                if (!StrUtil.isNull(mids)) {
                    String[] ss = mids.split(",");
                    for (int j = 0; j < ss.length; j++) {
                        if (list.get(i).getBranchId() == Integer.parseInt(ss[j])) {
                            m.put("role_use", 1);
                            break;
                        } else {
                            m.put("role_use", 0);
                        }
                    }
                } else {
                    m.put("role_use", 0);
                }
                usrs.add(m);
            }
            StringBuilder str = new StringBuilder();
            if (null != usrs && usrs.size() > 0) {
                str.append("[");
                String sp = "";
                for (Map<String, Object> map : usrs) {
                    str.append(sp).append("{\"usrid\":").append(map.get("member_id"));
                    str.append(",\"pid\":").append(map.get("branch_id"));
                    str.append(",\"usrnm\":\"").append(map.get("member_nm"));
                    str.append("\",\"isuse\":").append(map.get("role_use")).append("}");
                    sp = ",";
                }
                str.append("]");
                this.sendJsonResponse(response, str.toString());
            }
        } catch (Exception e) {
            log.error("查询用户树出错:", e);
        }
    }

    /**
     * 摘要：添加角色与用户对应表
     *
     * @return
     * @说明：
     * @创建：作者:yxy 创建时间：2011-6-13
     * @修改历史： [序号](yxy 2011 - 6 - 13)<修改说明>
     */
    @RequestMapping("/saveroleusr")
    public void saveroleusr(Integer roleid, Long[] usrid, HttpServletResponse response) {
        try {
            this.roleService.updateRoleUsr(usrid, roleid);
            this.sendHtmlResponse(response, "2");
        } catch (Exception ex) {
            log.error("添加角色与用户对应表出错:" + ex);
            this.sendHtmlResponse(response, "5");
        }
    }


    /**
     * 成员信息的tree
     */
    @ResponseBody
    @RequestMapping("usrtree_company_new")
    public Map<String, Object> queryMemberForRole(HttpServletRequest request, Integer id) {
        SysLoginInfo info = getInfo(request);
        final String datasource = info.getDatasource();

        SysRole roleInfo = this.roleService.queryRoleById(id, datasource);
        // 如果是业务员
        int limitSelected = -1;
        if (RoleValueEnum.isSalesman(roleInfo.getRoleCd())) {
            SysCorporation corporationDTO = corporationService.get(StringUtils.toInteger(info.getFdCompanyId()));
            //limitSelected = Optional.ofNullable(corporationDTO.getSalesmanCount()).orElse(0);
        }
        List<Map<String, Object>> roleUsers = this.roleService.queryUsrForRole(id, datasource);
        Map<String, Object> result = Maps.newHashMapWithExpectedSize(2);
        result.put("limitSelected", limitSelected);
        if (Collections3.isNotEmpty(roleUsers)) {
            List<Node> resultList = roleUsers.stream()
                    .map(data -> Node.builder()
                            .id((int) data.get("member_id"))
                            .text((String) data.get("member_nm"))
                            .expanded(Boolean.FALSE)
                            .checked(MathUtils.valid(StringUtils.toInteger(data.get("owner"))))
                            .build())
                    .collect(Collectors.toList());
            result.put("nodes", resultList);
        } else {
            result.put("nodes", new ArrayList<>(0));
        }

        return result;
    }

}

