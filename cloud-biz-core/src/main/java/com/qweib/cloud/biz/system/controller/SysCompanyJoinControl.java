package com.qweib.cloud.biz.system.controller;

import com.qweib.cloud.biz.common.CnlifeConstants;
import com.qweib.cloud.biz.common.GeneralControl;
import com.qweib.cloud.biz.common.MapGjTool;
import com.qweib.cloud.biz.system.TokenServer;
import com.qweib.cloud.biz.system.jpush.JpushClassifies;
import com.qweib.cloud.biz.system.jpush.JpushClassifies2;
import com.qweib.cloud.biz.system.service.*;
import com.qweib.cloud.biz.system.service.plat.SysCorporationService;
import com.qweib.cloud.biz.system.service.plat.SysMemberCompanyService;
import com.qweib.cloud.biz.system.service.plat.SysMemberService;
import com.qweib.cloud.biz.system.service.ws.PublicMsgWebService;
import com.qweib.cloud.biz.system.service.ws.SysDepartService;
import com.qweib.cloud.biz.system.service.ws.SysMemberWebService;
import com.qweib.cloud.core.domain.*;
import com.qweib.cloud.utils.DateTimeUtil;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import com.qweib.commons.DateUtils;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Objects;

@Controller
@RequestMapping("/manager/company")
public class SysCompanyJoinControl extends GeneralControl {

    @Resource
    private SysCompanyJoinService companyJoinService;
    @Resource
    private SysCorporationService corporationService;
    @Resource
    private SysMemberWebService memberWebService;
    @Resource
    private SysMemberService memberService;
    @Resource
    private SysDepartService departService;
    @Resource
    private SysMemberCompanyService memberCompanyService;
    @Resource
    private PublicMsgWebService publicMsgWebService;
    @Resource
    private JpushClassifies jpushClassifies;
    @Resource
    private JpushClassifies2 jpushClassifies2;

    /**
     * 申请加入公司界面
     */
    @RequestMapping("/tojoincompany")
    public String tojoincompany(HttpServletRequest request, Model model) throws Exception {
        //结束时间默认当天
        model.addAttribute("edate", DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd"));
        return "/uglcw/company/join_company";
    }


    /**
     * 查询：申请加入公司
     */
    @RequestMapping("/queryCompanyJoinPage")
    public void queryCompanyJoinPage(HttpServletRequest request, HttpServletResponse response, SysCompanyJoin companyJoin, Integer page, Integer rows) {
        try {
            SysLoginInfo info = getLoginInfo(request);
            Page p = this.companyJoinService.queryCompanyJoinPage(companyJoin, info.getDatasource(), page, rows);
            JSONObject json = new JSONObject();
            json.put("total", p.getTotal());
            json.put("rows", p.getRows());
            sendJsonResponse(response, json.toString());

        } catch (Exception e) {
            e.printStackTrace();
            log.error("分页查询订单出错", e);
        }
    }


    /**
     * agree 1 同意 2 不同意
     * 同意或不同意成员申请加入公司请求(加入部门或公司)
     */
    @RequestMapping("updateStatusCompanyJoin")
    public void updateStatusCompanyJoin(HttpServletRequest request, HttpServletResponse response, String agree, Integer memId, Integer id, String roleIds, Integer branchId) {
        try {
            String msg = null;
            Integer jude = 1;
            SysLoginInfo info = getLoginInfo(request);
            SysCorporation corporation = this.corporationService.queryCorporationBydata(info.getDatasource());
            SysMember member = this.memberWebService.queryAllById(memId);//公共平台上用户信息
            //判断是否已加入该公司
            SysMember member2 = memberService.querySysMemberById1(corporation.getDatasource(), member.getMemberId());
            if (member2 != null) {
                this.sendHtmlResponse(response, "2");
                return;
            }
            if ("1".equals(agree)) {//同意
                member.setUnitId(corporation.getDeptId().intValue());
                member.setMemberCompany(corporation.getDeptNm());
                member.setBranchId(branchId);
                member.setRoleIds(roleIds);
//                jude = departService.addMemCompany(member, corporation.getDatasource(), 0, memId, null, "1");
                List<Integer> roleArr = new ArrayList<>();
                if (!StrUtil.isNull(roleIds)) {
                    String[] split = roleIds.split(",");
                    for (String s : split) {
                        roleArr.add(Integer.valueOf(s));
                    }
                }
                jude = Integer.valueOf(memberService.saveMember(info.getDatasource(), member, roleArr, corporation.getDeptId().intValue(), info.getFdCompanyNm(), info.getIdKey()));
                msg = "接受您加入[" + corporation.getDeptNm() + "]公司的邀请,并加入公司本级下";

                if (Objects.equals(jude, 1)) {
                    //平台添加该企业的会员信息
                    SysMemberCompany newSmc = new SysMemberCompany();
                    newSmc.setCompanyId(Integer.valueOf(info.getFdCompanyId()));
                    newSmc.setMemberCompany(info.getFdCompanyNm());

                    newSmc.setMemberMobile(member.getMemberMobile());
                    newSmc.setEmail(member.getEmail());
                    newSmc.setMemberGraduated(member.getMemberGraduated());
                    newSmc.setInTime(DateUtils.getDate());
                    newSmc.setMemberId(memId);
                    newSmc.setMemberNm(member.getMemberNm());
                    this.memberCompanyService.addSysMemberCompany(newSmc);
                }
            } else {//不同意
                msg = "拒绝您加入[" + corporation.getDeptNm() + "]公司的邀请";
                jude = 1;
            }
            //回推
            if (Objects.equals(jude, 1)) {
                SysChatMsg scm = new SysChatMsg();
                scm.setAddtime(DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd HH:mm:ss"));
                scm.setMemberId(info.getIdKey());
                scm.setMsg(msg);
                scm.setReceiveId(memId);
                scm.setTp("27");
                scm.setBelongNm(info.getDatasource());
                publicMsgWebService.addpublicMsg(scm);
                SysMemDTO mem = this.memberWebService.queryMemByMemId(memId);
                jpushClassifies.toJpush(mem.getMemberMobile(), CnlifeConstants.MODE6, CnlifeConstants.NEWMSG, null, null, "同意或不同意加入公司申请推送", null);
                jpushClassifies2.toJpush(mem.getMemberMobile(), CnlifeConstants.MODE6, CnlifeConstants.NEWMSG, null, null, "同意或不同意加入公司申请推送", null);
            }
            //修改对方的token信息
            TokenServer.updateDatasource(info.getDatasource(), memId);
            //修改轨迹员工信息
            String urls = "http://api.map.baidu.com/trace/v2/entity/update";
            String parameters = "ak=gIzggYvrqG7zD5MCsFwSjKOkU8yv8SsC&service_id=117170&entity_name=" + memId + "&entitydatabase=" + info.getDatasource() + "";
            MapGjTool.postMapGjurl(urls, parameters);

            //修改sys_company_join是否同意状态
            companyJoinService.updateStatusCompanyJoin(info.getDatasource(), id, agree, info.getIdKey());

            this.sendHtmlResponse(response, jude.toString());
        } catch (Exception e) {
            log.error("同意或不同意加入公司出错", e);
            this.sendHtmlResponse(response, "-1");
        }
    }


    /**
     * 删除:申请加入公司
     */
    @RequestMapping("/deleteCompanyJoin")
    public void deleteCompanyJoin(HttpServletResponse response, HttpServletRequest request, String ids) {
        try {
            SysLoginInfo info = this.getLoginInfo(request);
            companyJoinService.deleteCompanyJoin(info.getDatasource(), ids);
            this.sendJsonResponse(response, "1");
        } catch (Exception e) {
            log.error("删除:申请加入公司出错：", e);
            this.sendHtmlResponse(response, "-1");
        }
    }


}
