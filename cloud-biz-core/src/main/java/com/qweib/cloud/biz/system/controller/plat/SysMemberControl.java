package com.qweib.cloud.biz.system.controller.plat;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.qweib.cloud.biz.common.CompanyRoleEnum;
import com.qweib.cloud.biz.common.GeneralControl;
import com.qweib.cloud.biz.common.Response;
import com.qweib.cloud.biz.system.TokenServer;
import com.qweib.cloud.biz.system.UserContext;
import com.qweib.cloud.biz.system.auth.event.Topics;
import com.qweib.cloud.biz.system.controller.plat.vo.MemberForm;
import com.qweib.cloud.biz.system.controller.plat.vo.ModifyPwdRequest;
import com.qweib.cloud.biz.system.controller.plat.vo.importVo.ImportSysMemberVo;
import com.qweib.cloud.biz.system.service.SysCustomerService;
import com.qweib.cloud.biz.system.service.SysInportTempService;
import com.qweib.cloud.biz.system.service.SysMemberImportMainService;
import com.qweib.cloud.biz.system.service.member.MemberLoginService;
import com.qweib.cloud.biz.system.service.plat.*;
import com.qweib.cloud.biz.system.service.ws.SysDepartService;
import com.qweib.cloud.biz.system.utils.RoleUtils;
import com.qweib.cloud.core.domain.*;
import com.qweib.cloud.core.domain.dto.MemberLoginShowDTO;
import com.qweib.cloud.core.domain.dto.SysRoleMemberDTO;
import com.qweib.cloud.core.domain.vo.SysMemberTypeEnum;
import com.qweib.cloud.memberEvent.MemberPublisher;
import com.qweib.cloud.service.member.domain.member.SysMemberCompanyDTO;
import com.qweib.cloud.service.member.domain.member.SysMemberCompanyLeaveTime;
import com.qweib.cloud.service.member.domain.member.SysMemberCompanyQuery;
import com.qweib.cloud.service.member.domain.member.login.MemberLoginQuery;
import com.qweib.cloud.utils.*;
import com.qweib.commons.DateUtils;
import com.qweib.commons.MathUtils;
import com.qweib.commons.StringUtils;
import com.qweib.commons.exceptions.BizException;
import com.qweib.commons.mapper.BeanMapper;
import com.qweibframework.async.handler.AsyncProcessHandler;
import org.apache.commons.lang3.BooleanUtils;
import org.apache.poi.hssf.usermodel.*;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.data.domain.Pageable;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.data.web.PageableDefault;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import reactor.core.publisher.Flux;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.Valid;
import java.io.IOException;
import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.function.Function;
import java.util.stream.Collectors;


@Controller
@RequestMapping("/manager")
public class SysMemberControl extends GeneralControl {
    @Resource
    private SysMemberService memberService;
    @Resource
    private SysMemberCompanyService memberCompanyService;
    @Resource
    private SysCorporationService corporationService;
    @Resource
    private SysDepartService departService;
    @Resource
    private SysMemService sysMemService;
    @Resource
    private SysCustomerService customerService;
    @Resource
    private SysCompanyRoleService companyRoleService;
    @Resource
    private SysMemberImportMainService sysMemberImportMainService;
    @Resource
    private SysInportTempService sysInportTempService;
    @Resource
    private AsyncProcessHandler asyncProcessHandler;
    @Autowired
    private MemberPublisher memberPublisher;
    @Autowired
    @Qualifier("stringRedisTemplate")
    private StringRedisTemplate redisTemplate;
    @Autowired
    private MemberLoginService memberLoginService;

    /**
     * 摘要：
     *
     * @说明：成员主页
     * @创建：作者:llp 创建时间：2015-2-3
     * @修改历史： [序号](llp 2015 - 2 - 3)<修改说明>
     */
    @RequestMapping("/querymember")
    public String querymember(HttpServletRequest request, Model model, String dataTp, @RequestParam(required = false) Integer memberType, @RequestParam(required = false) Integer editFlag) {
        String roles = "";
        SysLoginInfo info = this.getLoginInfo(request);
        model.addAttribute("info", info);
        //查询成员角色，以最小的id作为值
        if (!StrUtil.isNull(info.getDatasource())) {
            roles = companyRoleService.checkHasAdminRole(info.getIdKey(), info.getDatasource());
        }
        String []str = info.getUsrNo().split("@");
        String accNo = str[0];
        model.addAttribute("isUnitmng", roles);
        model.addAttribute("dataTp", dataTp);
        memberType = Objects.nonNull(memberType) ? memberType : SysMemberTypeEnum.general.getType();
        model.addAttribute("memberType", memberType);
        model.addAttribute("editFlag", editFlag);
        model.addAttribute("accNo",accNo);
        if (!Objects.equals(memberType, SysMemberTypeEnum.general.getType())) return "/shop/member/sys_member";
        return "/publicplat/member/member";
    }

    /**
     * 判断是否可以修改员工资料
     *
     * @param memberId 员工 id
     * @param request
     * @return
     */
    @ResponseBody
    @GetMapping("member/can_edit")
    public Response<Boolean> canEditMember(@RequestParam("member_id") Integer memberId,
                                           HttpServletRequest request) {
        SysLoginInfo loginUser = this.getLoginInfo(request);
        final String database = loginUser.getDatasource();
        if (loginUser.getIdKey().equals(memberId)) {
            return Response.createSuccess(true);
        }

        List<SysRoleMemberDTO> roleMemberDTOS = companyRoleService.getRoleMemberByMemberId(database, memberId);
        List<String> roleCodes = roleMemberDTOS.stream()
                .map(sysRoleMemberDTO -> sysRoleMemberDTO.getRoleCode()).filter(e -> e != null)
                .collect(Collectors.toList());

        if (!roleCodes.contains(CompanyRoleEnum.COMPANY_CREATOR.getRole()) &&
                !roleCodes.contains(CompanyRoleEnum.COMPANY_ADMIN.getRole())) {
            return Response.createSuccess(true);
        }

        boolean hasAdmin = RoleUtils.hasCompanyAdmin(loginUser.getUsrRoleIds(), companyRoleService, database);
        if (hasAdmin) {
            return Response.createSuccess(true);
        } else {
            return Response.createError("只有管理员才能执行此操作");
        }
    }

    /**
     * 判断是否管理员
     *
     * @param request
     * @return
     */
    @ResponseBody
    @GetMapping("member/has_admin")
    public Response<Boolean> hasAdmin(HttpServletRequest request) {
        SysLoginInfo loginUser = this.getLoginInfo(request);
        final String database = loginUser.getDatasource();

        boolean hasAdmin = RoleUtils.hasCompanyAdmin(loginUser.getUsrRoleIds(), companyRoleService, database);
        if (hasAdmin) {
            return Response.createSuccess(true);
        } else {
            return Response.createError("只有管理员才能执行此操作");
        }
    }

    /**
     * 判断是否创建者
     *
     * @param request
     * @return
     */
    @ResponseBody
    @GetMapping("member/has_creator")
    public Response<Boolean> hasCreator(HttpServletRequest request) {
        SysLoginInfo loginUser = this.getLoginInfo(request);
        final String database = loginUser.getDatasource();

        boolean hasCreator = RoleUtils.hasCompanyCreator(loginUser.getUsrRoleIds(), companyRoleService, database);
        if (hasCreator) {
            return Response.createSuccess(true);
        } else {
            return Response.createError("只有创建者才能执行此操作");
        }
    }

    /**
     *
     */
    @RequestMapping("/queryMemberList")
    public void queryMemberList(HttpServletRequest request, HttpServletResponse response, String memberUse) {
        try {
            SysLoginInfo info = this.getLoginInfo(request);
            SysMember member = new SysMember();
            member.setMemberUse(memberUse);
            List<SysMember> memberList = this.memberService.queryMemberAllByDatabase(info.getDatasource(), member);
            JSONArray json = new JSONArray(memberList);
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            e.printStackTrace();
            log.error("分页查询成员出错", e);
        }
    }

    /**
     * 摘要：
     *
     * @说明：分页查询成员
     * @创建：作者:llp 创建时间：2015-2-3
     * @修改历史： [序号](llp 2015 - 2 - 3)<修改说明>
     */
    @RequestMapping("/memberPage")
    public void memberPage(HttpServletRequest request, HttpServletResponse response, SysMember query, Integer page, Integer rows,
                           String dataTp) {
        try {
            SysLoginInfo info = this.getLoginInfo(request);
            query.setUnitId(StringUtils.toInteger(info.getFdCompanyId()));
            final String database = info.getDatasource();
            query.setDatasource(database);
//            SysMember member1 = this.memberService.querySysMemberById(info.getIdKey());
//            if (MathUtils.valid(member1.getUnitId())) {
//                member.setUnitId(member1.getUnitId());
//                member.setDatasource(info.getDatasource());
//            }
//			if(member1.getIsUnitmng().equals("3")){
//				member.setMemberIds(this.memberService.queryBmMemberIds(member1.getBranchId(), info.getDatasource()).getMemberIds());
//			}
            Page p = this.memberService.querySysMember(query, page, rows, dataTp, info);
            List dataList = p.getRows();
            if (Collections3.isNotEmpty(dataList)) {
                for (Object data : dataList) {
                    SysMember member = (SysMember) data;
                    member.setMemberPwd(null);
                    getRoleNames(member, database);
                }
            }
            JSONObject json = new JSONObject();
            json.put("total", p.getTotal());
            json.put("rows", dataList);
            json.put("dataTp", dataTp);
            this.sendJsonResponse(response, json.toString());
            p = null;
        } catch (Exception e) {
            e.printStackTrace();
            log.error("分页查询成员出错", e);
        }
    }

    @RequestMapping("/dialogShopMemberPage")
    public void dialogShopMemberPage(SysMember sysMember, int page, int rows, Integer branchId, Integer type, HttpServletRequest request, HttpServletResponse response) {
        try {
            SysLoginInfo info = this.getLoginInfo(request);
            Page p = this.memberService.dialogShopMemberPage(sysMember, page, rows, branchId, type, info.getDatasource());
            JSONObject json = new JSONObject();
            json.put("total", p.getTotal());
            json.put("rows", p.getRows());
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            e.printStackTrace();
            log.error("分页查询成员出错", e);
        }
    }

    @RequestMapping("/batchUpdateMemberDepartment")
    public void batchUpdateMemberDepartment(String ids, Integer branchId, HttpServletResponse response, HttpServletRequest request) {
        try {
            SysLoginInfo info = this.getLoginInfo(request);
            if (branchId != null && branchId.equals(0)) {
                branchId = null;
            }
            int m = this.memberService.batchUpdateMemberDepartment(ids, branchId, info.getDatasource());

            if (m > 0) {
                this.sendHtmlResponse(response, "1");
            } else {
                this.sendHtmlResponse(response, "-1");
            }
        } catch (Exception e) {
            e.printStackTrace();
            log.error("批量更新成员部门失败", e);
            this.sendHtmlResponse(response, "-1");
        }
    }

    private String getRoleNames(SysMember member, String database) {
        StringBuilder str = new StringBuilder(16);
        List<Integer> ids = Lists.newArrayList();
        List<SysRoleMemberDTO> roles = this.companyRoleService.getRoleMemberByMemberId(database, member.getMemberId());
        boolean find = false;
        for (SysRoleMemberDTO role : roles) {
            if (find) {
                str.append(",");
            } else {
                find = true;
            }
            str.append(role.getRoleName());
            ids.add(role.getRoleId());
        }
        member.setRoleNames(str.toString());
        member.setRoleIds(StringUtils.join(ids, ","));
        return str.toString();
    }

    /**
     * @说明：添加/修改成员页面
     * @创建：作者:llp 创建时间：2015-2-3
     * @修改历史： [序号](llp 2015 - 2 - 3)<修改说明>
     */
    @RequestMapping("toopermember")
    public String toopermember(HttpServletRequest request, Model model, Integer Id, String branchName) {
        SysLoginInfo info = this.getLoginInfo(request);
        if (null != Id) {
            SysMember member = this.memberService.querySysMemberById1(info.getDatasource(), Id);
            model.addAttribute("member", member);
            try {
                SysDepart dept = departService.queryDepartByid(member.getBranchId(), info.getDatasource());
                if (null != dept) {
                    model.addAttribute("branchName", dept.getBranchName());
                }
            } catch (Exception ex) {

            }
            //查询已有角色
            String roleIds = companyRoleService.queryRoleByMemid(Id, info.getDatasource());
            model.addAttribute("roleIds", roleIds);
            if (member != null && MathUtils.valid(member.getCid())) {
                SysCustomer customer = this.customerService.queryCustomerById(info.getDatasource(), member.getCid());
                if (!StrUtil.isNull(customer)) {
                    model.addAttribute("khNm", customer.getKhNm());
                }
            }
        }
		/*if(!StrUtil.isNull(info.getDatasource())){
			List<SysDepart> departls=this.departService.queryDepartLsall(info.getDatasource());
			model.addAttribute("departls", departls);
		}*/
        model.addAttribute("tpNm", info.getTpNm());
        return "/publicplat/member/memberoper";
    }

    @RequestMapping("getMemberInfo")
    public void getMemberInfo(HttpServletRequest request, HttpServletResponse response, Model model, Integer memberId) {
        SysLoginInfo info = this.getLoginInfo(request);
        try {
            if (null != memberId) {
                SysMember member = this.memberService.querySysMemberById1(info.getDatasource(), memberId);
                JSONObject json = new JSONObject();
                if (member != null) {
                    json.put("state", true);
                    json.put("member", new JSONObject(member));
                } else {
                    json.put("state", false);
                }
                this.sendJsonResponse(response, json.toString());
            }
        } catch (Exception e) {
            log.error("获取员工信息失败：", e);
        }
    }

    @PostMapping("member")
    @ResponseBody
    public Response member(@RequestBody @Valid MemberForm input) {
        SysLoginInfo info = UserContext.getLoginInfo();
        final String datasource = info.getDatasource();
        final Integer companyId = StringUtils.toInteger(info.getFdCompanyId());
        // 没有公司 id
        if (!MathUtils.valid(companyId)) {
            return Response.createError("无法指定公司");
        }
        String []Str = info.getUsrNo().split("@");
        String result;
        if (input.getMemberId() != null) {
            SysMember dbMember = this.memberService.querySysMemberById1(info.getDatasource(), input.getMemberId());
            BeanMapper.copy(input, dbMember);
            dbMember.setRoleIds(StringUtils.join(input.getRoleIds(), ","));
            dbMember.setMemberName(Str[0] + "@" + dbMember.getEmpNo());
            result = memberService.updateMember(datasource, dbMember, input.getRoleIds(), companyId, input.getOldisLead());
            redisTemplate.convertAndSend(Topics.EVICT_USER_PERMISSION, datasource);
        } else {
            SysMember newMember = BeanMapper.map(input, SysMember.class);
            newMember.setRoleIds(StringUtils.join(input.getRoleIds(), ","));
            newMember.setMemberName(Str[0] + "@" + newMember.getEmpNo());
            result = memberService.saveMember(datasource, newMember, input.getRoleIds(), companyId, info.getFdCompanyNm(), info.getIdKey());
        }
        return Response.createSuccess(result).setMessage("保存成功");
    }

    /**
     * @说明：添加/修改成员
     * @创建：作者:llp 创建时间：2015-1-27
     * @修改历史： [序号](llp 2015 - 1 - 27)<修改说明>
     */
    @RequestMapping("opermember")
    public void opermember(HttpServletResponse response, HttpServletRequest request, @ModelAttribute("sysMember") SysMember input, String oldisLead) {
        try {
            SysLoginInfo currentMember = this.getLoginInfo(request);
            final String database = currentMember.getDatasource();

            List<Integer> roleIds = null;
            if (StringUtils.isNotBlank(input.getRoleIds())) {
                roleIds = Flux.fromArray(input.getRoleIds().split(","))
                        .map(id -> StringUtils.toInteger(id))
                        .filter(e -> e.intValue() > 0)
                        .toStream()
                        .collect(Collectors.toList());
            }

            final Integer companyId = StringUtils.toInteger(currentMember.getFdCompanyId());
            // 没有公司 id
            if (!MathUtils.valid(companyId)) {
                this.sendHtmlResponse(response, "4");
                return;
            }

            String result;
            if (!MathUtils.valid(input.getMemberId())) {
                result = this.memberService.saveMember(database, input, roleIds, companyId, currentMember.getFdCompanyNm(), currentMember.getIdKey());
            } else {
                result = this.memberService.updateMember(database, input, roleIds, companyId, oldisLead);
            }
            this.sendHtmlResponse(response, result);

//            // 查找平台是否有注册该手机号
//            int count = this.memberService.querySysMemberByTel(input.getMemberMobile());
//
//            // 如果大于表示平台上已经注册了该用户，what a shame? count 什么情况下大于 1
//            if (count > 1) {
//                if (!input.getMemberMobile().equals(input.getOldtel())) {
//                    this.sendHtmlResponse(response, "3");
//                    return;
//                }
//            }
//
//            List<Integer> roleIds = null;
//            if (StringUtils.isNotBlank(input.getRoleIds())) {
//                roleIds = Flux.fromArray(input.getRoleIds().split(","))
//                        .map(id -> StringUtils.toInteger(id))
//                        .filter(e -> e.intValue() > 0)
//                        .toStream()
//                        .collect(Collectors.toList());
//            }
//
//            input.setFirstChar(pinyingTool.getFirstLetter(input.getMemberNm()).toUpperCase());
//            // 修改公共平台上成员信息
//            if (StrUtil.isNull(input.getMemberId())) {//添加
//                if (Collections3.isNotEmpty(roleIds)) {
//                    boolean hasRole = RoleUtils.hasCompanyRoles(roleIds, new CompanyRoleEnum[]{CompanyRoleEnum.COMPANY_CREATOR, CompanyRoleEnum.COMPANY_ADMIN},
//                            companyRoleService, database);
//                    if (hasRole) {
//                        this.sendHtmlResponse(response, "4");
//                        return;
//                    }
//                }
//
//                input.setMemberCreatime(DateUtils.getDateTime());
//                input.setMemberCompany(currentMember.getFdCompanyNm());
//                if (!StrUtil.isNull(currentMember.getFdCompanyId())) {
//                    input.setUnitId(Integer.valueOf(currentMember.getFdCompanyId()));
//                }
//                input.setMemberCreator(currentMember.getIdKey());
//                input.setDatasource(database);
//                input.setMemberActivate("1");
//                input.setMemberUse("1");
//                input.setState("2");
//                if (count < 1) {//表示平台不存在该会员，那么在平台和企业都要添加该会员
//                    input.setMemberPwd("e10adc3949ba59abbe56e057f20f883e");
//                    this.memberService.addSysMember(input, database);
//
//                    SysMemberCompany newSmc = MemberUtils.createBySysMember(input, StringUtils.toInteger(currentMember.getFdCompanyId()),
//                            input.getMemberId());
//                    this.memberCompanyService.addSysMemberCompany(newSmc);
//                } else {//表示平台已经存在该用户， 则需要在当前企业中添加该用户
//                    /*如果存在该会员，且在相应企业中不存在该员工，则添加到相应企业中，在平台也添加相应的企业纪录*/
//                    SysMember platMember = this.memberService.queryPlatSysMemberbyTel(input.getMemberMobile());
//                    SysMemberCompanyQuery query = new SysMemberCompanyQuery();
//                    query.setMobile(input.getMemberMobile());
//                    query.setCompanyId(StringUtils.toInteger(currentMember.getFdCompanyId()));
//                    List<SysMemberCompanyDTO> smcList = memberCompanyService.querySysMemberCompanyList(query);
//                    if (Collections3.isNotEmpty(smcList)) {//存在
//                        SysMember member1 = this.memberService.queryCompanySysMemberById(database, platMember.getMemberId());
//                        if (member1 != null) {
//                            this.sendHtmlResponse(response, "3");
//                            return;
//                        } else {
//                            //企业添加用户
//                            input.setMemberId(platMember.getMemberId());
//                            this.memberService.addCompanySysMember(input, database);
//                            //平台添加该企业的会员信息
//                            SysMemberCompanyDTO newSmc = smcList.get(0);
//                            SysMemberCompanyLeaveTime memberCompanyQuery = new SysMemberCompanyLeaveTime();
//                            memberCompanyQuery.setId(newSmc.getId());
//                            this.memberCompanyService.updateSysMemberCompany(memberCompanyQuery);
//                        }
//                    } else {//不存在
//                        //企业添加用户
//                        input.setMemberId(platMember.getMemberId());
//                        this.memberService.addCompanySysMember(input, database);
//                        //平台添加该企业的会员信息
//                        SysMemberCompany newSmc = MemberUtils.createBySysMember(input, StringUtils.toInteger(currentMember.getFdCompanyId()),
//                                platMember.getMemberId());
//                        this.memberCompanyService.addSysMemberCompany(newSmc);
//                    }
//                }
//                this.sendHtmlResponse(response, "1");
//            } else {//修改
//                boolean canEditRole = companyRoleService.canEditCreatorAndAdmin(database, input.getMemberId(), roleIds);
//                if (!canEditRole) {
//                    this.sendHtmlResponse(response, "4");
//                    return;
//                }
//                SysMember member1 = this.memberService.queryCompanySysMemberById(database, input.getMemberId());
//                if (StringUtils.isNotBlank(currentMember.getFdCompanyId())) {
//                    input.setDatasource(database);
//                    input.setScore(member1.getScore());
//                    //修改客户的业务员部门id
//                    if (!StrUtil.isNull(member1.getBranchId())) {
//                        if (!member1.getBranchId().equals(input.getBranchId())) {
//                            this.memberService.updateCMBid(database, input.getMemberId(), input.getBranchId());
//                        }
//                    } else {
//                        if (!StrUtil.isNull(input.getBranchId())) {
//                            this.memberService.updateCMBid(database, input.getMemberId(), input.getBranchId());
//                        }
//                    }
//                }
//                this.memberService.updateCompanySysMember(input, oldisLead);
//                this.sendHtmlResponse(response, "2");
//            }
        } catch (Exception e) {
            log.error("修改成员出错：", e);
        }
    }

    @RequestMapping("opermemberbak")
    public void opermemberbak(HttpServletResponse response, HttpServletRequest request, SysMember member, String oldisLead) {
        try {
            SysLoginInfo info = this.getLoginInfo(request);
            int count = this.memberService.querySysMemberByTel(member.getMemberMobile());
            if (count >= 1) {
                if (!member.getMemberMobile().equals(member.getOldtel())) {
                    this.sendHtmlResponse(response, "3");
                    return;
                }
            }
            member.setFirstChar(pinyingTool.getFirstLetter(member.getMemberNm()).toUpperCase());
            //修改公共平台上成员信息
            if (StrUtil.isNull(member.getMemberId())) {//添加
                SysMember member1 = this.memberService.querySysMemberById(info.getIdKey());
                member.setUnitId(member1.getUnitId());
                member.setMemberCreatime(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()));
                member.setMemberCompany(member1.getMemberCompany());
                member.setMemberCreator(info.getIdKey());
                member.setDatasource(info.getDatasource());
//				    member.setMemberPwd("e10adc3949ba59abbe56e057f20f883e");
                member.setMemberActivate("1");
                member.setMemberUse("1");
                member.setState("2");
                this.memberService.addSysMember(member, info.getDatasource());
                this.sendHtmlResponse(response, "1");
            } else {//修改
                SysMember member1 = this.memberService.querySysMemberById(member.getMemberId());
                if (!StrUtil.isNull(member1.getUnitId())) {
                    if (member1.getUnitId() != 0) {
                        SysCorporation corporation = this.corporationService.queryCorporationById(member1.getUnitId());
                        member.setDatasource(corporation.getDatasource());
                        SysMember member2 = this.memberService.querySysMemberById1(corporation.getDatasource(), member.getMemberId());
                        member.setScore(member2.getScore());
                        //修改客户的业务员部门id
                        if (!StrUtil.isNull(member1.getBranchId())) {
                            if (!member1.getBranchId().equals(member.getBranchId())) {
                                this.memberService.updateCMBid(corporation.getDatasource(), member.getMemberId(), member.getBranchId());
                            }
                        } else {
                            if (!StrUtil.isNull(member.getBranchId())) {
                                this.memberService.updateCMBid(corporation.getDatasource(), member.getMemberId(), member.getBranchId());
                            }
                        }
                    }
                }
                this.sendHtmlResponse(response, "2");
            }
        } catch (Exception e) {
            log.error("修改成员出错：", e);
        }
    }

    /**
     * 新版修改当前用户密码
     *
     * @param request
     * @return
     */
    @ResponseBody
    @PostMapping("account/password")
    public Response password(@RequestBody @Valid ModifyPwdRequest request) {
        SysLoginInfo ctx = UserContext.getLoginInfo();
        SysMember member = memberService.querySysMemberById(ctx.getIdKey());
        if (!StringUtils.equals(member.getMemberPwd(), request.getOldPassword())) {
            throw new BizException("原密码不正确");
        }
        Boolean success = memberService.updateSysMemberPassword(ctx.getIdKey(), request.getNewPassword());
        if (!success) {
            throw new BizException("修改密码失败");
        }
        return Response.createSuccess().setMessage("修改成功");
    }

    /**
     * 修改平台用户密码
     */
    @RequestMapping("operAdmin")
    public void operAdmin(Model model, HttpServletRequest request, HttpServletResponse response, SysMember member) {
        try {
            if (!StrUtil.isNull(member.getMemberPwd())) {
                Boolean result = memberService.updateSysMemberPassword(member.getMemberId(), member.getMemberPwd());
                if (BooleanUtils.isTrue(result)) {
                    sendHtmlResponse(response, "1");
                }
            }
        } catch (Exception e) {
            log.error("修用户密码错误：", e);
        }
        sendHtmlResponse(response, "-1");
    }

//    /**
//     * 摘要：下载excel模板(上传成员模板)
//     *
//     * @param @param request
//     * @param @param response
//     * @说明：
//     * @创建：作者:YYP 创建时间：2014-7-2
//     * @修改历史： [序号](YYP 2014 - 7 - 2)<修改说明>
//     */
//    @RequestMapping("/toLoadModel")
//    public void toLoadModel(HttpServletRequest request, HttpServletResponse response) {
//        try {
//            String path = request.getSession().getServletContext().getRealPath("/exefile");
//            //打开指定文件的流信息
//            FileInputStream fs = new FileInputStream(new File(path + "\\memberModel.xls"));
//            //设置响应头和保存文件名
//            // 设置输出的格式
//            response.reset();
//            response.setContentType("APPLICATION/OCTET-STREAM");
//            response.setHeader("Content-Disposition", "attachment; filename=\"" + "memberModel.xls" + "\"");
//            //写出流信息
//            int b = 0;
//            ServletOutputStream out = response.getOutputStream();
//            while ((b = fs.read()) != -1) {
//                out.write(b);
//            }
//            out.flush();
//            out.close();
//            fs.close();
//        } catch (Exception e) {
//            log.error("下载excel模板失败", e);
//        }
//    }


    /**
     * 摘要：下载excel模板(上传成员模板)
     */
    @RequestMapping("/toLoadModel")
    public void toLoadModel(HttpServletRequest request, HttpServletResponse response) {
        try {
            SysLoginInfo info = getLoginInfo(request);
            String fname = ""
                    + "membertemplate";// Excel文件名
            OutputStream os = response.getOutputStream();// 取得输出流
            response.reset();// 清空输出流
            response.setHeader("Content-disposition", "attachment; filename="
                    + fname + ".xls"); // 设定输出文件头,该方法有两个参数，分别表示应答头的名字和值。
            response.setContentType("application/msexcel");
            HSSFWorkbook wb = new HSSFWorkbook();
            // 在工作薄上建一张工作表
            HSSFSheet sheet = wb.createSheet();
            HSSFRow row = sheet.createRow((short) 0);
            sheet.createFreezePane(0, 1);
            HSSFCellStyle cellstyle = wb.createCellStyle();
            cellstyle.setAlignment(HSSFCellStyle.ALIGN_CENTER_SELECTION);
            cteateCell(wb, row, (short) 0, "姓名", cellstyle);
            cteateCell(wb, row, (short) 1, "手机号码(不能重复)", cellstyle);
            cteateCell(wb, row, (short) 2, "职位", cellstyle);
            cteateCell(wb, row, (short) 3, "行业", cellstyle);
            cteateCell(wb, row, (short) 4, "毕业院校", cellstyle);
            cteateCell(wb, row, (short) 5, "家乡", cellstyle);
            cteateCell(wb, row, (short) 6, "部门", cellstyle);
            int rowIndex = 1;
            HSSFRow nrow = sheet.createRow((short) rowIndex);
            cteateCell(wb, nrow, (short) 0, "张欣", cellstyle);
            cteateCell(wb, nrow, (short) 1, "18866660000", cellstyle);
            cteateCell(wb, nrow, (short) 2, "出纳", cellstyle);
            cteateCell(wb, nrow, (short) 3, "互联网", cellstyle);
            cteateCell(wb, nrow, (short) 4, "五道口", cellstyle);
            cteateCell(wb, nrow, (short) 5, "山西", cellstyle);
            cteateCell(wb, nrow, (short) 6, "信息部", cellstyle);
            wb.write(os);
            os.flush();
            os.close();
            System.out.println("文件生成");
        } catch (Exception e) {
            e.printStackTrace();
            log.error("下载excel模板失败", e);
        }
    }

    private void cteateCell(HSSFWorkbook wb, HSSFRow row, short col,
                            Object val, HSSFCellStyle cellstyle) {
        HSSFCell cell = row.createCell(col);
        String cv = "";
        if (!StrUtil.isNull(val)) {
            cv = val + "";
        } else {
            cv = "  ";
        }
        cell.setCellValue(cv);
        //  HSSFCellStyle cellstyle = wb.createCellStyle();
        // cellstyle.setAlignment(HSSFCellStyle.ALIGN_CENTER_SELECTION);
        cell.setCellStyle(cellstyle);
    }

    /**
     * 摘要：上传成员excel
     *
     * @param @param request
     * @param @param response
     * @说明：
     * @创建：作者:zzx 创建时间：2019-8-15
     * @修改历史： [序号](YYP 2014 - 5 - 30)<修改说明>
     */
    @ResponseBody
    @RequestMapping("/sysMember/downSysMemberToImportTemp")
    public Map<String, Object> downSysMemberToImportTemp(HttpServletRequest request, HttpServletResponse response) {
        Map<String, Object> map = new HashMap<>();
        map.put("state", false);
        map.put("msg", "操作失败");
        try {
            SysLoginInfo info = this.getLoginInfo(request);
            SysMember query = new SysMember();
            query.setDatasource(info.getDatasource());
            Page page = memberService.querySysMember(query, 1, Integer.MAX_VALUE, null, info);
            List<SysMember> list = page.getRows();
            if (Collections3.isNotEmpty(list)) {
                ImportSysMemberVo vo = null;
                List<ImportSysMemberVo> voList = new ArrayList<>(list.size());
                for (SysMember member : list) {
                    vo = new ImportSysMemberVo();
                    BeanCopy.copyBeanProperties(vo, member);
                    voList.add(vo);
                }
                int importId = sysInportTempService.save(voList, SysImportTemp.TypeEnum.type_sys_member.getCode(), info, SysImportTemp.InputDownEnum.down.getCode());
                map.put("importId", importId);
                map.put("state", true);
                map.put("msg", "操作成功，导出数量" + list.size());
            }
        } catch (Exception e) {
            log.error("保存员工导入信息出现错误", e);
            map.put("msg", "操作出现错误" + e.getMessage());
        }
        return map;
    }


    /**
     * 员工导入新方法zzx
     *
     * @param request
     * @param response
     * @return
     */
    @ResponseBody
    @RequestMapping("/sysMember/toUpExcel")
    public Map<String, Object> toUpExcel1(HttpServletRequest request, HttpServletResponse response) {
        Map<String, Object> map = new HashMap<>();
        map.put("state", false);
        map.put("msg", "操作失败");
        try {
            SysLoginInfo info = this.getLoginInfo(request);
            List<ImportSysMemberVo> list = sysInportTempService.queryItemList(request, info.getDatasource());
            if (Collections3.isNotEmpty(list)) {
                String taskId = asyncProcessHandler.createTask();
                map.put("taskId", taskId);
                this.memberService.addSysMemberlImport(list, info, taskId, Maps.newHashMap(request.getParameterMap()));
                map.put("state", true);
                map.put("msg", "已提交后台处理");
            } else {
                map.put("msg", "暂无有效数据可导入");
            }
        } catch (Exception e) {
            log.error("保存员工导入信息出现错误", e);
            map.put("msg", "操作出现错误" + e.getMessage());
        }
        return map;
    }


    /**
     * 摘要：上传成员excel
     *
     * @param @param request
     * @param @param response
     * @说明：
     * @创建：作者:YYP 创建时间：2014-5-30
     * @修改历史： [序号](YYP 2014 - 5 - 30)<修改说明>
     */
    @SuppressWarnings("unchecked")
    @RequestMapping("toUpExcel")
    public void toUpExcel(HttpServletRequest request, HttpServletResponse response) {
        try {
            SysLoginInfo info = this.getLoginInfo(request);
            MultipartHttpServletRequest multiRequest = (MultipartHttpServletRequest) request;
            MultipartFile upFile = multiRequest.getFile("upFile");
            Workbook workBook = null;
            try {
                workBook = new XSSFWorkbook(upFile.getInputStream());//2007
            } catch (Exception ex) {
                workBook = new HSSFWorkbook(upFile.getInputStream());//2003
            }
            //第一个工作表
            Sheet sheet = workBook.getSheetAt(0);

            int inform = checkHeader(sheet);//验证头部
            if (inform == -1) {
                this.sendHtmlResponse(response, "表头列名格式非法，请按照模板填写成员信息！");
                return;
            }
            List<SysMember> memberls = new ArrayList<SysMember>();
            String tStr = "";
            Set<String> sett = new HashSet<String>();

            for (int j = 1; j <= sheet.getLastRowNum(); j++) {
                Row row = sheet.getRow(j);
                if (StrUtil.isNull(row)) {//表格下某行不存在数据情况
                    continue;
                }
                this.setCellType(row, 7);//设置单元格格式
                String name = row.getCell(0) == null ? "" : row.getCell(0).getStringCellValue().trim();
                String tel = row.getCell(1) == null ? "" : row.getCell(1).getStringCellValue().trim();
                String zhiy = row.getCell(2) == null ? "" : row.getCell(2).getStringCellValue().trim();
                String hangy = row.getCell(3) == null ? "" : row.getCell(3).getStringCellValue().trim();
                String byyx = row.getCell(4) == null ? "" : row.getCell(4).getStringCellValue().trim();
                String jiax = row.getCell(5) == null ? "" : row.getCell(5).getStringCellValue().trim();
                String bumen = row.getCell(6) == null ? "" : row.getCell(6).getStringCellValue().trim();


                if ("".equals(tel) && "".equals(name) && "".equals(zhiy) && "".equals(hangy) && "".equals(byyx) && "".equals(jiax)) {//整行为空跳过(excel清空内容情况)
                    continue;
                }
                if ("".equals(tel)) {
                    this.sendHtmlResponse(response, "第" + (j + 1) + "行号码不能为空!");//号码不能为空
                    return;
                }
                if (!sett.add(tel)) {//set不重复加入则表格中存在重复号码
                    this.sendHtmlResponse(response, "第" + (j + 1) + "行号码与其他行号码重复，请修改!");
                    return;
                }
                if ("".equals(name)) {
                    this.sendHtmlResponse(response, "第" + (j + 1) + "行姓名不能为空!");//姓名不能为空
                    return;
                }
                int a = this.memberService.querySysMemberByTel(tel);
                if (a >= 1) {
                    this.sendHtmlResponse(response, "第" + (j + 1) + "行号码已注册,请检查");//存在已注册号码,请检查
                    return;
                } else if (a < 1) {
                    SysMember mem = null;
                    if ("".equals(bumen)) {
                        mem = memSetValues(info, name, tel, zhiy, hangy, byyx, jiax, null);
                    } else {
                        SysDepart depart = this.departService.querySysDepartByNm(bumen, info.getDatasource());
                        if (null == depart) {
                            this.sendHtmlResponse(response, "第" + (j + 1) + "行的部门名称不存在,请检查");
                            return;
                        } else {
                            mem = memSetValues(info, name, tel, zhiy, hangy, byyx, jiax, depart.getBranchId());
                        }
                    }
                    memberls.add(mem);
                    tStr = tStr + tel + ",";//加入公开圈内
                }
            }
            this.memberService.addSysMemberls(memberls, info, tStr, null);

            List<SysMemberImportSub> importSubs = new ArrayList<SysMemberImportSub>();
            try {
                if (memberls != null && memberls.size() > 0) {
                    for (int i = 0; i < memberls.size(); i++) {
                        SysMember member = memberls.get(i);
                        SysMemberImportSub importSub = new SysMemberImportSub();
                        BeanCopy.copyBeanProperties(importSub, member);
                        importSubs.add(importSub);
                    }
                    try {
                        SysMemberImportMain main = new SysMemberImportMain();
                        main.setOperId(info.getIdKey());
                        main.setOperName(info.getUsrNm());
                        main.setImportTime(new Date());
                        main.setList(importSubs);
                        main.setTitle(DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd HH:mm") + "员工信息导入");
                        this.sysMemberImportMainService.add(main, info.getDatasource());
                    } catch (Exception ex) {
                        log.error("员工导入记录错误", ex);
                    }
                }
            } catch (Exception ex) {

            }
            this.sendHtmlResponse(response, "1");
        } catch (Exception e) {
            log.error("上传成员失败", e);
            this.sendHtmlResponse(response, "上传失败,请检查成员信息！");
        }
    }

    @Deprecated//没有发现使用地址
    @PostMapping("member/import")
    @ResponseBody
    public Response importFromExcel(HttpServletRequest request, @RequestParam("file") MultipartFile file) throws IOException {
        SysLoginInfo info = UserContext.getLoginInfo();
        Workbook workBook = null;
        try {
            workBook = new XSSFWorkbook(file.getInputStream());//2007
        } catch (Exception ex) {
            workBook = new HSSFWorkbook(file.getInputStream());//2003
        }
        //第一个工作表
        Sheet sheet = workBook.getSheetAt(0);

        int inform = checkHeader(sheet);//验证头部
        if (inform == -1) {
            return Response.createError("表头列名格式非法，请按照模板填写成员信息");
        }
        List<SysMember> memberls = new ArrayList<SysMember>();
        String tStr = "";
        Set<String> sett = new HashSet<String>();
        for (int j = 1; j <= sheet.getLastRowNum(); j++) {
            Row row = sheet.getRow(j);
            if (StrUtil.isNull(row)) {//表格下某行不存在数据情况
                continue;
            }
            this.setCellType(row, 7);//设置单元格格式
            String name = row.getCell(0) == null ? "" : row.getCell(0).getStringCellValue().trim();
            String tel = row.getCell(1) == null ? "" : row.getCell(1).getStringCellValue().trim();
            String zhiy = row.getCell(2) == null ? "" : row.getCell(2).getStringCellValue().trim();
            String hangy = row.getCell(3) == null ? "" : row.getCell(3).getStringCellValue().trim();
            String byyx = row.getCell(4) == null ? "" : row.getCell(4).getStringCellValue().trim();
            String jiax = row.getCell(5) == null ? "" : row.getCell(5).getStringCellValue().trim();
            String bumen = row.getCell(6) == null ? "" : row.getCell(6).getStringCellValue().trim();


            if ("".equals(tel) && "".equals(name) && "".equals(zhiy) && "".equals(hangy) && "".equals(byyx) && "".equals(jiax)) {//整行为空跳过(excel清空内容情况)
                continue;
            }
            if ("".equals(tel)) {
                return Response.createError("第" + (j + 1) + "行号码不能为空!");
            }
            if (!sett.add(tel)) {//set不重复加入则表格中存在重复号码
                return Response.createError("第" + (j + 1) + "行号码与其他行号码重复，请修改!");
            }
            if ("".equals(name)) {
                return Response.createError("第" + (j + 1) + "行姓名不能为空!");
            }
            int a = this.memberService.querySysMemberByTel(tel);
            if (a >= 1) {
                return Response.createError("第" + (j + 1) + "行号码已注册,请检查");
            } else if (a < 1) {
                SysMember mem = null;
                if ("".equals(bumen)) {
                    mem = memSetValues(info, name, tel, zhiy, hangy, byyx, jiax, null);
                } else {
                    SysDepart depart = this.departService.querySysDepartByNm(bumen, info.getDatasource());
                    if (null == depart) {
                        return Response.createError("第" + (j + 1) + "行的部门名称不存在,请检查");
                    } else {
                        mem = memSetValues(info, name, tel, zhiy, hangy, byyx, jiax, depart.getBranchId());
                    }
                }
                memberls.add(mem);
                tStr = tStr + tel + ",";//加入公开圈内
            }
        }
        this.memberService.addSysMemberls(memberls, info, tStr, null);
        return Response.createSuccess().setMessage("导入成功");
    }

    //	设置member值
    private SysMember memSetValues(SysLoginInfo info, String name, String tel,
                                   String zhiy, String hangy, String byyx, String jiax, Integer branchId) {
        SysMember member = new SysMember();
        setMemberBase(member, info);
        member.setMemberNm(name);
        member.setMemberMobile(tel);
        member.setMemberJob(zhiy);
        member.setMemberTrade(hangy);
        member.setMemberGraduated(byyx);
        member.setMemberHometown(jiax);
        member.setBranchId(branchId);
        return member;
    }

    //	设置member值
    private void setMemberBase(SysMember member, SysLoginInfo info) {
        SysMember member1 = this.memberService.querySysMemberById(info.getIdKey());
        SysCorporation corporation = this.corporationService.queryCorporationById(member1.getUnitId());
        member.setUnitId(member1.getUnitId());
        member.setMemberCreatime(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()));
        member.setMemberCompany(member1.getMemberCompany());
        member.setMemberPwd("e10adc3949ba59abbe56e057f20f883e");
        member.setPlatformCompanyId(corporation.getPlatformCompanyId());
        member.setMemberCreator(info.getIdKey());
        member.setDatasource(info.getDatasource());
    }

    /**
     * 校验表头
     *
     * @param sheet
     */
    private int checkHeader(Sheet sheet) {
        //获得行数  第一行
        Row header = sheet.getRow(0);

        setCellType(header, 7);

        String headerName = header.getCell(0).getStringCellValue().trim();
        String headerTel = header.getCell(1).getStringCellValue().trim();
        String headerZhiy = header.getCell(2).getStringCellValue().trim();
        String headerHangy = header.getCell(3).getStringCellValue().trim();
        String headerByyx = header.getCell(4).getStringCellValue().trim();
        String jiax = header.getCell(5).getStringCellValue().trim();
        String bumen = header.getCell(6).getStringCellValue().trim();
        if (!headerName.equals("姓名") || !headerTel.equals("手机号码(不能重复)") || !headerZhiy.equals("职位") || !headerHangy.equals("行业") || !headerByyx.equals("毕业院校") || !jiax.equals("家乡") || !bumen.equals("部门")) {
            return -1;//表头列名格式非法，请按照模板填写成员信息！
        }
        return 1;
    }

    /**
     * 设置单元格格式
     */
    private void setCellType(Row row, int cellCount) {
        //手机号，姓名，部门名称，职务
        for (int i = 0; i < cellCount; i++) {
            Cell nameCell = row.getCell(i);
            if (nameCell != null) {
                nameCell.setCellType(HSSFCell.CELL_TYPE_STRING);
            }
        }
    }

    /**
     * 批量删除会员
     *
     * @param ids
     */
    @RequestMapping("delMember")
    public void deleteMember(HttpServletRequest request, HttpServletResponse response, Integer[] ids) {
        try {
            SysLoginInfo info = this.getLoginInfo(request);
            for (int i = 0; i < ids.length; i++) {
                if (info.getIdKey().equals(ids[i])) {
                    this.sendHtmlResponse(response, "-2");
                    return;
                }
            }
			/*if("".equals(info.getDatasource()) || null==info.getDatasource()){//超级管理员
				int[] result1= this.memberService.deletemember(ids);
			}else{
				int[] result2 = this.sysMemService.deletemember(ids, info.getDatasource());
			}*/
            int[] result2 = this.sysMemService.deletemember(ids, info.getDatasource(), Integer.valueOf(info.getFdCompanyId()));

            for (int i = 0; i < ids.length; i++) {
                if (info.getIdKey().equals(ids[i])) {
                    break;
                }
                SysMemberCompany query = new SysMemberCompany();
                query.setCompanyId(StringUtils.toInteger(info.getFdCompanyId()));
                query.setMemberId(ids[i]);
                List<SysMemberCompany> smcList = memberCompanyService.querySysMemberCompanyList(query);
                if (Collections3.isNotEmpty(smcList)) {//存在
                    //平台添加该企业的会员信息
                    SysMemberCompany newSmc = smcList.get(0);

                    SysMemberCompanyLeaveTime input = new SysMemberCompanyLeaveTime();
                    input.setId(newSmc.getFdId());
                    input.setLeaveTime(DateUtils.getDate());
                    this.memberCompanyService.updateMemberCompanyLeaveTime(input);
                    //如果停用的在会员列中存在，则更新平台会员信息；
                    SysMember platMember = this.memberService.querySysMemberById(ids[i]);
                    if (platMember != null) {
                        if (info.getFdCompanyId().equals(platMember.getUnitId())) {
                            platMember.setBranchId(null);
                            platMember.setBranchName("");
                            platMember.setMemberGraduated("");
                            this.memberService.updatePlatSysMember(platMember);
                        }
                    }
                }
            }

            //删除：清空token
            for (int i = 0; i < ids.length; i++) {
                if (!info.getIdKey().equals(ids[i])) {
                    TokenServer.tokenDestroyed(ids[i]);
                }
            }

            this.sendHtmlResponse(response, "1");
        } catch (Exception e) {

            if (e instanceof BizException) {  //捕获抛出的异常
                this.sendHtmlResponse(response, "-3");
                return;
            }

            log.error("删除会员记录出错：", e);
            this.sendHtmlResponse(response, "-1");
        }
    }

    /**
     * 摘要：
     *
     * @说明：选择业务员
     * @创建：作者:llp 创建时间：2016-2-17
     * @修改历史： [序号](llp 2016 - 2 - 17)<修改说明>
     */
    @RequestMapping("/querychoicemember")
    public String querychoicemember(HttpServletRequest request, Model model) {
        return "/publicplat/member/choicemember";
    }

    @RequestMapping("/selectmember")
    public String selectmember(HttpServletRequest request, Model model) {
        return "/publicplat/member/selectmember";
    }

    /**
     * @说明：修改停用
     * @创建：作者:llp 创建时间：2016-5-9
     * @修改历史： [序号](llp 2016 - 5 - 9)<修改说明>
     */
    @ResponseBody
    @RequestMapping("/updateIsTy")
    public Response updateIsTy(HttpServletRequest request, @RequestParam Integer id, @RequestParam Integer isTy) {
        SysLoginInfo info = this.getLoginInfo(request);
        try {
            //this.memberService.updateIsTy(id, isTy, datasource);
            List<SysRoleMemberDTO> roleMemberDTOS = this.companyRoleService.getRoleMemberByMemberId(info.getDatasource(), id);
            List<String> memberRoleIds = roleMemberDTOS.stream()
                    .filter(e -> StringUtils.isNotBlank(e.getRoleCode()))
                    .map(new Function<SysRoleMemberDTO, String>() {
                        @Override
                        public String apply(SysRoleMemberDTO roleMemberDTO) {
                            return roleMemberDTO.getRoleCode();
                        }
                    })
                    .filter(e -> CompanyRoleEnum.hasCreatorOrAdmin(e))
                    .collect(Collectors.toList());
            if (Collections3.isNotEmpty(memberRoleIds)) {
                return Response.createError("创建人与管理员不能直接离职，请先进行转移操作");
            }
            String message = this.memberService.updateCompanyIsTy(id, isTy, info);
            /*如果存在该会员，且在相应企业中不存在该员工，则添加到相应企业中，在平台也添加相应的企业纪录*/
            SysMemberCompany query = new SysMemberCompany();
            query.setCompanyId(StringUtils.toInteger(info.getFdCompanyId()));
            query.setMemberId(id);
            List<SysMemberCompany> smcList = this.memberCompanyService.querySysMemberCompanyList(query);
            if (Collections3.isNotEmpty(smcList)) {//入离职
                SysMemberCompany upSmc = smcList.get(0);

                SysMemberCompanyLeaveTime input = new SysMemberCompanyLeaveTime();
                input.setId(upSmc.getFdId());
                if (isTy != 1) {
                    input.setLeaveTime(DateUtils.getDate());
                }
                this.memberCompanyService.updateMemberCompanyLeaveTime(input);
            }
            //如果停用的在会员列中存在，则更新平台会员信息；
            SysMember platMember = this.memberService.querySysMemberById(id);
            if (platMember != null) {
                if (info.getFdCompanyId().equals(platMember.getUnitId())) {
                    platMember.setBranchId(null);
                    platMember.setBranchName("");
                    platMember.setMemberGraduated("");
                    this.memberService.updatePlatSysMember(platMember);
                }
            }
            //离职：要清掉token
            if (2 == isTy) {
                TokenServer.tokenDestroyed(id);
            }
            //-------------------------更新商城会员表的信息：start---------------------------------
           /* SysMember oldMember = this.memberService.querySysMemberById1(info.getDatasource(), id);
            if (oldMember != null && !StrUtil.isNull(oldMember.getRzMobile())) {
                String rzMobile = oldMember.getRzMobile();
                Map<String, Object> shopMemberMap = this.memberService.queryShopMemberByOpenId(null, rzMobile, info.getDatasource());
                if (!(shopMemberMap == null || shopMemberMap.isEmpty())) {
                    if (1 == isTy) {
                        //转为“在职”
                        if ("1".equals(shopMemberMap.get("source"))) {
                            shopMemberMap.put("source", 2);//(来源：：普通1；员工2；客户3)
                            shopMemberMap.put("customer_id", null);
                            shopMemberMap.put("customer_name", null);
                        }
                    } else if (2 == isTy) {
                        //转为“离职”
                        if ("2".equals(shopMemberMap.get("source"))) {
                            shopMemberMap.put("source", 1);//(来源：：普通1；员工2；客户3)
                            shopMemberMap.put("customer_id", null);
                            shopMemberMap.put("customer_name", null);
                        }
                    }
                    this.memberService.updateShopMember(shopMemberMap, info.getDatasource());
                }
            }*/
            //-------------------------更新商城会员表的信息：end---------------------------------
            return Response.createSuccess().setMessage(Objects.nonNull(message) ? message : "操作成功");
        } catch (Exception e) {
            log.error("修改停用出错：", e);
            return Response.createError("操作失败");
        }
    }

    @ResponseBody
    @RequestMapping("member/recoverIsTy")
    public Response recoverIsTy(@RequestParam Integer memberId, @RequestParam Integer type) {
        SysLoginInfo info = UserContext.getLoginInfo();
        String message = memberService.updateCompanyIsTy(memberId, type, info);
        return Response.createSuccess().setMessage(Objects.nonNull(message) ? message : "操作成功");
    }

    /**
     * @说明：解绑设备
     * @创建：作者:llp 创建时间：2016-5-10
     * @修改历史： [序号](llp 2016 - 5 - 10)<修改说明>
     */
    @RequestMapping("/updateUnId")
    public void updateUnId(HttpServletRequest request, HttpServletResponse response, Integer id, Integer isTy) {
        SysLoginInfo info = this.getLoginInfo(request);
        try {
            this.memberService.updateUnId(id, info.getDatasource(), isTy);
//			    this.memberService.updateCompanyUnId(id, info.getDatasource(), isTy);
            if (isTy == 2) {
                this.sendJsonResponse(response, "1");
            } else {
                this.sendJsonResponse(response, "2");
            }
        } catch (Exception e) {
            log.error("解绑设备出错：", e);
            this.sendHtmlResponse(response, "-1");
        }
    }

    /**
     * @说明：转让客户，从业务员 mid1，转让到 mid2 身上
     * @创建：作者:llp 创建时间：2016-5-11
     * @修改历史： [序号](llp 2016 - 5 - 11)<修改说明>
     */
    @RequestMapping("/updateZrKh")
    public void updateZrKh(HttpServletRequest request, HttpServletResponse response, Integer mid1, Integer mid2) {
        SysLoginInfo info = this.getLoginInfo(request);
        try {
            this.memberService.updateZrKh(mid1, mid2, info.getDatasource());
            this.sendJsonResponse(response, "1");
        } catch (Exception e) {
            log.error("转让客户出错：", e);
            this.sendHtmlResponse(response, "-1");
        }
    }

    /**
     * 摘要：
     *
     * @说明：选择业务员(转让)
     * @创建：作者:llp 创建时间：2016-2-17
     * @修改历史： [序号](llp 2016 - 2 - 17)<修改说明>
     */
    @RequestMapping("/querychoicememberzr")
    public String querychoicememberzr(HttpServletRequest request, Model model, Integer mid1) {
        model.addAttribute("mid1", mid1);
        return "/publicplat/member/choicememberzr";
    }

    /**
     * 摘要：
     *
     * @说明：选择业务员(转让)2
     * @创建：作者:llp 创建时间：2016-10-11
     * @修改历史： [序号](llp 2016 - 10 - 11)<修改说明>
     */
    @RequestMapping("/querychoicememberzr2")
    public String querychoicememberzr2(HttpServletRequest request, Model model, Integer[] ids) {
        model.addAttribute("ids", ids);
        return "/publicplat/member/choicememberzr2";
    }

    /**
     * 更新软件狗
     *
     * @param model
     * @param request
     * @param response
     * @param useDog
     * @param memberId
     */
    @RequestMapping("updateUseDog")
    public void updateUseDog(Model model, HttpServletRequest request, HttpServletResponse response, Integer useDog, Integer memberId, String idKey) {
        SysLoginInfo info = this.getLoginInfo(request);
        try {
            memberService.updateUseDog(memberId, useDog, idKey, info.getDatasource());
            sendHtmlResponse(response, "1");
        } catch (Exception e) {
            log.error("修改加密锁信息出错：", e);
            sendHtmlResponse(response, "-1");
        }
    }

    /**
     * 认证员工手机号
     */
    @RequestMapping("updateByRzMobile")
    public void updateByRzMobile(Model model, HttpServletRequest request, HttpServletResponse response, SysMember member) {
        //1.认证成功；2.该手机号已认证过；3.该手机号已在客户管理中认证过
        try {
            SysLoginInfo info = this.getLoginInfo(request);
            String rzMobile = member.getRzMobile();
            String res = "";
            if (!StrUtil.isNull(rzMobile) && rzMobile.length() == 11) {
                res = this.memberService.updateByRzMobile(info.getDatasource(), rzMobile, member.getMemberId(), info);
                //1.认证成功；2.该手机号已认证过；3.该手机号已在客户管理中认证过
                this.sendHtmlResponse(response, res);
            }
        } catch (Exception e) {
            log.error("认证员工手机号出错：", e);
            this.sendHtmlResponse(response, "-1");
        }
    }

    @ResponseBody
    @GetMapping("member/login/page")
    public Response memberLoginPage(MemberLoginQuery query, @PageableDefault(size = 20) Pageable pageable) {
        final SysLoginInfo loginUser = UserContext.getLoginInfo();
        query.setMemberId(loginUser.getIdKey());
        com.qweibframework.commons.page.Page<MemberLoginShowDTO> page = this.memberLoginService.page(query, pageable.getPageNumber(), pageable.getPageSize());

        return Response.createSuccess(page);
    }
}
