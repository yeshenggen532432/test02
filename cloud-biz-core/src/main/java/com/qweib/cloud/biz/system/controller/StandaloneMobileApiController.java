package com.qweib.cloud.biz.system.controller;

import com.google.common.collect.Lists;
import com.qweib.cloud.biz.common.Response;
import com.qweib.cloud.biz.system.TokenServer;
import com.qweib.cloud.biz.system.UserContext;
import com.qweib.cloud.biz.system.auth.JwtPayload;
import com.qweib.cloud.biz.system.auth.JwtUtils;
import com.qweib.cloud.biz.system.controller.vo.CompanyVO;
import com.qweib.cloud.biz.system.controller.vo.JwtRequest;
import com.qweib.cloud.biz.system.controller.vo.MobileLoginResponse;
import com.qweib.cloud.biz.system.controller.vo.SwitchCompanyRequest;
import com.qweib.cloud.biz.system.service.plat.*;
import com.qweib.cloud.biz.system.service.ws.SysMemWebService;
import com.qweib.cloud.biz.system.service.ws.SysMemberWebService;
import com.qweib.cloud.biz.system.utils.MemberUtils;
import com.qweib.cloud.core.dao.DynamicDataSourceTemplate;
import com.qweib.cloud.core.domain.*;
import com.qweib.cloud.repository.utils.HttpResponseUtils;
import com.qweib.cloud.service.member.domain.corporation.CorporationStandaloneDTO;
import com.qweib.cloud.service.member.domain.member.SysMemberCompanyDTO;
import com.qweib.cloud.service.member.domain.member.SysMemberCompanyQuery;
import com.qweib.cloud.service.member.retrofit.corporation.CorporationStandaloneRetrofitApi;
import com.qweib.cloud.utils.Collections3;
import com.qweib.cloud.utils.StrUtil;
import com.qweib.commons.StringUtils;
import com.qweib.commons.exceptions.BizException;
import com.qweib.commons.mapper.BeanMapper;
import com.qweib.commons.mapper.JsonMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;
import javax.validation.Valid;
import java.util.*;

import static com.qweib.cloud.biz.system.support.DevicePresenceHelper.DEVICE_MOBILE;

/**
 * @author jimmy.lin
 * create at 2020/4/24 10:58
 */
@RestController
@RequestMapping("web")
public class StandaloneMobileApiController {
    @Value("${company.license}")
    private String secret;
    @Autowired
    private SysCorporationService corporationService;
    @Autowired
    private SysLoginService loginService;
    @Autowired
    private SysCompanyRoleService companyRoleService;
    @Resource
    private SysMemberCompanyService memberCompanyService;
    @Resource
    private SysMemberWebService memberWebService;
    @Resource
    private SysMemWebService sysMemWebService;
//    @Autowired
//    private CorporationStandaloneRetrofitApi companyExtApi;
    @Autowired
    private DynamicDataSourceTemplate dataSourceTemplate;
    @Resource
    private SysMemberService memberService;

    @PostMapping("login/standalone")
    public Response jwtLogin(@Valid JwtRequest jwt) {
        JwtPayload payload = JwtUtils.decode(jwt.getJwt(), secret);
        SysMember sysMember = memberWebService.queryMemberByMobile(payload.getMobile());
        if (sysMember == null) {
            throw new BizException("用户名不存在");
        }

        SysCorporation corporation = this.corporationService.queryCorporationById(payload.getCompanyId());
        String datasource = corporation.getDatasource();
        String tpNm = corporation.getTpNm();
        OnlineUser onlineUser = new OnlineUser(sysMember.getMemberId(), sysMember.getMemberNm(), sysMember.getMemberMobile(), datasource, tpNm, sysMember.getCid());
        if (!StrUtil.isNull(sysMember.getUnitId())) {
            onlineUser.setFdCompanyId(sysMember.getUnitId() + "");
        }
        String token = StrUtil.string2MD5(onlineUser.getTel() + onlineUser.getMemberNm() + new Date());
        onlineUser.setToken(token);
        onlineUser.setFdCompanyNm(sysMember.getMemberCompany());
        String roles = "";

        //查询角色
        List<Integer> roleIds = this.loginService.queryRoleIdByUsr(sysMember.getMemberId(), datasource);
        onlineUser.setUsrRoleIds(roleIds);
        TokenServer.checkLoginState(sysMember.getMemberId());//是否重复登录操作
        if (!StrUtil.isNull(datasource)) {
            roles = companyRoleService.checkHasAdminRole(onlineUser.getMemId(), datasource);
        }


        //===========加载该会员有几家公司 begin================
        SysMemberCompany query = new SysMemberCompany();
        query.setMemberMobile(sysMember.getMemberMobile());
        query.setDimission(false);
        //TODO RPC
        List<SysMemberCompany> smcList = this.memberCompanyService.querySysMemberCompanyList(query);
        List<Map<String, Object>> companyList = Lists.newArrayList();
        boolean selectFind = MemberUtils.transferMemberCompanies1(companyList, smcList, onlineUser.getFdCompanyId());

        if (Collections3.isNotEmpty(companyList)) {
            onlineUser.setCompanys(JsonMapper.getInstance().toJson(companyList));
        }
        //===========加载该会员有几家公司 end================

      /*  if (!selectFind) {//默认登录的公司可能被禁用或者删除了该用户
            roles = "";
            onlineUser.setFdCompanyId("");
            onlineUser.setFdCompanyNm("");
            onlineUser.setDatabase("");
            sysMember.setUnId("");

            //=============================重新定位公司 begin=================================
            if (Collections3.isNotEmpty(companyList)) {
                Map<String, Object> map = companyList.get(0);
                Integer reCompanyId = StringUtils.toInteger(map.get("companyId"));
                final SysCorporation companyDTO = this.corporationService.queryCorporationById(reCompanyId);
                datasource = companyDTO.getDatasource();
                if (StringUtils.isNotBlank(datasource)) {

                    List<Integer> roleIds = this.loginService.queryRoleIdByUsr(sysMember.getMemberId(), datasource);
                    onlineUser.setUsrRoleIds(roleIds);
                    roles = "";
                    if (!StrUtil.isNull(datasource)) {
                        roles = companyRoleService.checkHasAdminRole(onlineUser.getMemId(), datasource);
                    }
                    onlineUser.setDatabase(companyDTO.getDatasource());
                    onlineUser.setFdCompanyId(reCompanyId + "");
                    onlineUser.setFdCompanyNm(companyDTO.getDeptNm());
                    sysMember.setUnitId(reCompanyId);
                    SysMember companyMember = this.loginService.querySysMemberById1(datasource, onlineUser.getMemId());
                    sysMember.setUnId(companyMember.getUnId());

                }
            }
            //=============================重新定位公司 end=================================
        }*/

        //==============设备绑定开始=======================
        if (!StrUtil.isNull(jwt.getUnId()) && !StrUtil.isNull(sysMember.getUnitId()) && sysMember.getUnitId() != 0) {
            //根据手机号，设备识别码--查询公司员工

            SysMember sysMem = sysMemWebService.queryMemByMobile(sysMember.getMemberMobile(), datasource);
            SysMember sysMem2 = sysMemWebService.queryMemByUnid(sysMember.getMemberMobile(), datasource);
            if (!StrUtil.isNull(sysMem2)) {
                if (!StringUtils.equals(sysMember.getMemberMobile(), sysMem2.getMemberMobile())) {
                    throw new com.qweib.cloud.core.exception.BizException("此设备已绑定" + sysMem2.getMemberMobile() + "账号，不能使用其他账号");
                }
            }
            if (!StrUtil.isNull(sysMem.getUnId())) {
                if (!sysMem.getUnId().equals("1")) {
                    if (!Objects.equals(jwt.getUnId(), sysMem.getUnId())) {
                        //sendWarm(response, "此账号已绑定其他设备，不能在此设备登录");
                        // return;
                    }
                } else {
                    memberWebService.updateunId(sysMember.getDatasource(), jwt.getUnId(), sysMember.getMemberId());
                }
            }
        }
        //==============设备绑定结束=======================

        if (!StrUtil.isNull(roles)) {
            String r[] = roles.split(",");
            List<Integer> roleList = new ArrayList<Integer>();
            for (int i = 0; i < r.length; i++) {
                roleList.add(Integer.valueOf(r[i]));
            }
            onlineUser.setUsrRoleIds(roleList);
        }


        //获取企业个人信息覆盖平台的信息
        SysMember companyMember = this.loginService.querySysMemberById1(datasource, onlineUser.getMemId());
        sysMember.setMemberNm(companyMember.getMemberNm());
        sysMember.setMemberHead(companyMember.getMemberHead());
        sysMember.setMsgmodel(companyMember.getMsgmodel());
        sysMember.setUnitId(companyMember.getUnitId());
        sysMember.setUnId(companyMember.getUnId());


        MobileLoginResponse.MobileLoginResponseBuilder builder = MobileLoginResponse.builder()
                .memId(onlineUser.getMemId())
                .memberNm(sysMember.getMemberNm())
                .memberHead(sysMember.getMemberHead())
                .memberMobile(sysMember.getMemberMobile())
                .isUnitMng(roles)
                .datasource(datasource)
                .msgmodel(sysMember.getMsgmodel())
                .tpNm(tpNm)
                .cid(sysMember.getCid())
                .companyId(sysMember.getUnitId());
        if (!StrUtil.isNull(onlineUser.getCompanys())) {
            builder.companyListStr(onlineUser.getCompanys());
            builder.companies(BeanMapper.mapList(companyList, CompanyVO.class));
        }
        builder.token(token)
                .rzState(sysMember.getRzState());
        TokenServer.tokenCreated(onlineUser, DEVICE_MOBILE);
        return builder.build().state(true).msg("登录成功");
    }


    @GetMapping("jwt")
    public Response getJwtToken() {
        SysLoginInfo loginInfo = UserContext.getLoginInfo();
        if(loginInfo == null){
            throw new BizException("请登录");
        }
        JwtPayload payload = JwtPayload.builder()
                .mobile(loginInfo.getFdMemberMobile())
                .companyId(loginInfo.getFdCompanyId() != null ? Integer.valueOf(loginInfo.getFdCompanyId()) : null)
                .userId(loginInfo.getIdKey())
                .build();
        return Response.createSuccess(JwtUtils.gen(payload, secret));
    }

    @PostMapping("switch/company")
    public Response switchCompany(@Valid SwitchCompanyRequest request) {
//        CorporationStandaloneDTO standalone = HttpResponseUtils.convertResponseNull(companyExtApi.get(request.getFrom()));
//        if (standalone == null) {
//            throw new BizException("非独立服务器用户");
//        }
        //JwtPayload payload = JwtUtils.decode(request.getJwt(), standalone.getAppSecret());
        return  new Response();
//        SysCorporation company = this.corporationService.queryCorporationById(request.getTo());
//        CorporationStandaloneDTO target = HttpResponseUtils.convertResponseNull(companyExtApi.get(request.getTo()));
//        if (target != null) {
//            String customDomain = target.getCustomDomain();
//            if (StringUtils.isNotBlank(customDomain)) {
//                return MobileLoginResponse.builder()
//                        .jwt(JwtUtils.gen(payload, target.getAppSecret()))
//                        .domain(customDomain)
//                        .build();
//            }
//        }
//        MobileLoginResponse response = dataSourceTemplate.execute(String.valueOf(request.getTo()), database -> {
//            SysMember sysMember = memberService.queryCompanySysMemberById(database, payload.getUserId());
//            //获取当前用户的平台信息；
//            SysMember platMember = this.memberService.querySysMemberById(payload.getUserId());
//            MemberUtils.copyMemberProperties(platMember, sysMember, request.getTo(), company.getDeptNm(), database);
//            //TODO 暂时不让切换至本地
//            //this.memberService.updatePlatSysMember(platMember);
//
//            OnlineUser principal = new OnlineUser();
//            principal.setTpNm(company.getTpNm());
//            principal.setTel(sysMember.getMemberMobile());
//            principal.setMemId(payload.getUserId());
//            principal.setMemberNm(sysMember.getMemberNm());
//            principal.setFdCompanyId(String.valueOf(request.getTo()));
//            principal.setFdCompanyNm(company.getDeptNm());
//            principal.setDatabase(database);
//            principal.setCid(sysMember.getCid());
//
//            String roles = companyRoleService.checkHasAdminRole(payload.getUserId(), database);
//            MobileLoginResponse.MobileLoginResponseBuilder builder = MobileLoginResponse.builder()
//                    .memId(principal.getMemId())
//                    .memberNm(principal.getMemberNm())
//                    .memberHead(platMember.getMemberHead())
//                    .datasource(database)
//                    .memberMobile(principal.getTel())
//                    .isUnitMng(roles)
//                    .tpNm(principal.getTpNm())
//                    .companyId(request.getTo())
//                    .msgmodel(sysMember.getMsgmodel())
//                    .token(request.getToken());
//
//            List<CompanyVO> companies = getCompanyList(payload.getMobile(), request.getTo());
//            if (Collections3.isNotEmpty(companies)) {
//                builder.companyListStr(JsonMapper.toJsonString(companies))
//                        .companies(companies);
//            }
//            return builder.build();
//        });
//        return response;
    }


    private List<CompanyVO> getCompanyList(String mobile, Integer companyId) {
        //===========加载该会员有几家公司 begin================
        SysMemberCompany query = new SysMemberCompany();
        query.setMemberMobile(mobile);
        query.setDimission(false);
        List<SysMemberCompany> smcList = this.memberCompanyService.querySysMemberCompanyList(query);
        List<Map<String, Object>> companyList = Lists.newArrayList();
        boolean selectFind = MemberUtils.transferMemberCompanies1(companyList, smcList, String.valueOf(companyId));

        if (Collections3.isNotEmpty(companyList)) {
            return BeanMapper.mapList(companyList, CompanyVO.class);
        }
        return null;
    }

}
