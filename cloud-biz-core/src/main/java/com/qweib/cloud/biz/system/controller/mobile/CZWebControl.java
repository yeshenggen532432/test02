package com.qweib.cloud.biz.system.controller.mobile;


import com.qweib.cloud.biz.common.CnlifeConstants;
import com.qweib.cloud.biz.common.GpsUtils;
import com.qweib.cloud.biz.common.JavaSmsApi;
import com.qweib.cloud.biz.common.MapGjTool;
import com.qweib.cloud.biz.system.BaseWebService;
import com.qweib.cloud.biz.system.QiniuControl;
import com.qweib.cloud.biz.system.jpush.JpushClassifies;
import com.qweib.cloud.biz.system.jpush.JpushClassifies2;
import com.qweib.cloud.biz.system.service.plat.*;
import com.qweib.cloud.biz.system.service.ws.SysChatMsgService;
import com.qweib.cloud.biz.system.service.ws.SysMemberWebService;
import com.qweib.cloud.core.domain.*;
import com.qweib.cloud.utils.DateTimeUtil;
import com.qweib.cloud.utils.StrUtil;
import com.qweib.cloud.utils.pinyingTool;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Controller
@RequestMapping("/web")
public class CZWebControl extends BaseWebService {
    @Resource
    private SysCorporationService corporationService;
    @Resource
    private SysMemberWebService memberWebService;
    @Resource
    private SysMenuApplyService sysMenuApplyService;
    @Resource
    private JpushClassifies jpushClassifies;
    @Resource
    private JpushClassifies2 jpushClassifies2;
    @Resource
    private SysMemService sysMemService;
    @Resource
    private SysChatMsgService sysChatMsgWebService;
    @Resource
    private SysMemberService sysMemberService;
    @Resource
    private SysPublicNoticeService sysPublicNoticeService;

    /**
     * 摘要：
     *
     * @说明：陈总那边需要的相关接口
     * @创建：作者:llp 创建时间：2017-9-25
     * @参数：tp（1创建公司；2修改公司名称；3删除；4分配应用；5根据手机号查询公司id；6系统信息；7发送短信；8根据手机号修改密码）
     */
    @RequestMapping("correlationapi")
    public void correlationapi(HttpServletResponse response, HttpServletRequest request, Integer tp, String xgxx) {
        try {
            JSONObject json = new JSONObject();
            String msg = "";
            net.sf.json.JSONObject jsonarray = net.sf.json.JSONObject.fromObject(xgxx);
            if (tp.equals(1)) {/**创建公司*/
                SysCorporation company = new SysCorporation();
                company.setMobile(jsonarray.get("mobile").toString());
                company.setMemberNm(jsonarray.get("memberNm").toString());
                company.setDeptNm(jsonarray.get("deptNm").toString());
                company.setPlatformCompanyId(jsonarray.get("platformCompanyId").toString());
                String endDate = DateTimeUtil.dateTimeAddToStr(DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd"), 2, 1, "yyyy-MM-dd");
                SysMember sysMember = memberWebService.queryMemberByMobile(company.getMobile());
                if (null != sysMember) {
                    this.sendWarm(response, "该手机号已存在");
                    return;
                }
                SysMember sys = new SysMember();
                sys.setMemberMobile(company.getMobile());
                sys.setMemberNm(company.getMemberNm());
                sys.setFirstChar(pinyingTool.getFirstLetter(company.getMemberNm()).toUpperCase());
                sys.setMemberPwd(StrUtil.string2MD5(jsonarray.get("pwd").toString()));
                sys.setMemberCreatime(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()));
                sys.setMemberActivate("1");//激活状态 1：激活 2：未激活
                sys.setMemberUse("1");//使用状态 1:启用2：禁用
                int i = memberWebService.addMember(sys,"correlationapi");
                String spellNm = pinyingTool.getAllFirstLetter(company.getDeptNm());
                Integer info = 0;
                if (i > 0) {
                    //创建轨迹员工
                    String urls = "http://api.map.baidu.com/trace/v2/entity/add";
                    String parameters = "ak=gIzggYvrqG7zD5MCsFwSjKOkU8yv8SsC&service_id=117170&entity_name=" + i + "";
                    MapGjTool.postMapGjurl(urls, parameters);
                    //创建公司
                    Integer exit = corporationService.queryIsExit(company.getDeptNm());
                    if (0 == exit) {
                        if (!spellNm.matches("^[a-zA-Z]*")) {
                            spellNm = "sjk" + System.currentTimeMillis();
                        }
                        String path = request.getSession().getServletContext().getRealPath("/exefile") + "/cnlifebase.sql";
                        company.setDeptNm(company.getDeptNm());
                        company.setAddTime(new DateTimeUtil().getDateToStr(new Date(), "yyyy-MM-dd HH:mm:ss"));
                        company.setMemberId(i);
                        company.setEndDate(endDate);
                        info = corporationService.addCompany(company, spellNm, company.getDeptNm(), i, "1", path);//添加公司
                        final String gpsUrl = QiniuControl.GPS_SERVICE_URL + "/User/postLocation";
                        if (info > 0) {
                            //创建轨迹员工2
                            GpsUtils.createGpsMember(gpsUrl, info, i);
                            msg = "创建公司成功";
                            json.put("companyId", info);
                        }
                    } else {
                        this.sendWarm(response, "该公司已存在，不能重复创建");
                        return;
                    }
                } else {
                    this.sendWarm(response, "创建公司失败");
                    return;
                }
            } else if (tp.equals(2)) {/**修改公司名称*/
                String companyNm = jsonarray.get("deptNm").toString();
                Integer companyId = Integer.valueOf(jsonarray.get("companyId").toString());
                SysCorporation corporation = this.corporationService.queryCorporationById(companyId);
                if (!corporation.getDeptNm().equals(companyNm)) {
                    int count = this.corporationService.queryIsExit(companyNm);
                    if (count > 0) {
                        this.sendWarm(response, "该公司已存在");
                        return;
                    }
                }
                corporationService.updateCompanyNm(companyNm, companyId, corporation.getDatasource());
                msg = "修改公司名称成功";
            } else if (tp.equals(3)) {/**删除*/
//                Integer companyId = Integer.valueOf(jsonarray.get("companyId").toString());
//                SysCorporation corporation = this.corporationService.queryCorporationById(companyId);
//                Integer info = corporationService.deleteCorporation(companyId, corporation.getDatasource());
//                if (info > 0) {
//                    corporationService.deleteDB(corporation.getDatasource());//删除数据库
//                    msg = "删除公司成功";
//                } else {
                    this.sendWarm(response, "删除公司失败");
                    return;
//                }
            } else if (tp.equals(4)) {/**分配应用*/
                Integer deptId = Integer.valueOf(jsonarray.get("companyId").toString());
                String menuids = jsonarray.get("menuids").toString();
                String[] sz = menuids.split(",");
                Integer[] menuid = new Integer[sz.length];
                for (int i = 0; i < sz.length; i++) {
                    menuid[i] = Integer.parseInt(sz[i]);
                }
                String menuapplytp = "2";
                String dataSource = this.sysMenuApplyService.updateCompanyMenuApply(menuid, deptId, menuapplytp);
                if (!StrUtil.isNull(deptId) && "2".equals(menuapplytp)) {//公司分配应用成功,通知移动端
                    List<SysChatMsg> sys = new ArrayList<SysChatMsg>();
                    StringBuffer str = new StringBuffer();
                    //查询公司全部成员
                    List<SysMemDTO> memList = this.sysMemService.querycMems(dataSource);
                    //推送消息
                    if (memList.size() > 0) {
                        for (SysMemDTO memberDTO : memList) {
                            SysChatMsg scm = new SysChatMsg();
                            scm.setAddtime(DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd HH:mm:ss"));
                            scm.setMemberId(1);
                            scm.setReceiveId(memberDTO.getMemberId());
                            scm.setMsg("应用菜单变更，请重新登录");
                            scm.setTp("35");
                            scm.setMsgTp("1");// 发表类型1.文字2.图片3.语音;
                            sys.add(scm);
                            str.append(memberDTO.getMemberMobile() + ",");
                        }
                        this.sysChatMsgWebService.addChatMsg(sys, null);
                        String remind = str.substring(0, str.length() - 1);
                        jpushClassifies.toJpush(remind, CnlifeConstants.MODE6, CnlifeConstants.NEWMSG, null, null, "应用菜单变更推送", "2");//不屏蔽
                        jpushClassifies2.toJpush(remind, CnlifeConstants.MODE6, CnlifeConstants.NEWMSG, null, null, "应用菜单变更推送", "2");//不屏蔽
                    }
                }
                msg = "分配应用成功";
            } else if (tp.equals(5)) {/**根据手机号查询公司id*/
                String mobile = jsonarray.get("mobile").toString();
                SysMember member = this.memberWebService.queryMemberByMobile(mobile);
                if (StrUtil.isNull(member)) {
                    this.sendWarm(response, "该手机号不存在");
                    return;
                } else {
                    if (StrUtil.isNull(member.getUnitId())) {
                        this.sendWarm(response, "该手机号没有对应的公司id");
                        return;
                    }
                }
                json.put("companyId", member.getUnitId());
                msg = "获取公司id成功";
            } else if (tp.equals(6)) {/**系统信息*/
                String noticeTitle = jsonarray.get("noticeTitle").toString();
                String noticePic = jsonarray.get("noticePic").toString();
                String noticeTp = jsonarray.get("noticeTp").toString();
                String noticeContent = jsonarray.get("noticeContent").toString();
                String isPush = jsonarray.get("isPush").toString();
                SysNotice notice = new SysNotice();
                notice.setIsPush(isPush);
                notice.setMemberId(1);
                notice.setNoticeTime(DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd HH:mm:ss"));
                notice.setNoticeTitle(noticeTitle);
                notice.setNoticeContent(noticeContent);
                notice.setNoticeTp(noticeTp);
                notice.setNoticePic(noticePic);
                Integer id = this.sysPublicNoticeService.addNotice(notice);
                if ("1".equals(isPush)) {
                    List<SysMemDTO> memList = this.sysMemberService.querypMems();
                    List<SysChatMsg> sys = new ArrayList<SysChatMsg>();
                    String xxtp = null;
                    String belongMsg = null;
                    if ("1".equals(notice.getNoticeTp())) {
                        xxtp = "13";
                        belongMsg = "系统公告";
                    } else if ("4".equals(notice.getNoticeTp())) {
                        xxtp = "29";
                        belongMsg = "购开心公告";
                    }
                    for (SysMemDTO memberDTO : memList) {
                        SysChatMsg scm = new SysChatMsg();
                        scm.setAddtime(DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd HH:mm:ss"));
                        scm.setMemberId(1);
                        scm.setReceiveId(memberDTO.getMemberId());
                        scm.setMsg(notice.getNoticeTitle());
                        scm.setTp(xxtp);
                        scm.setBelongId(id);//公告id
                        scm.setBelongMsg(belongMsg);
                        scm.setMsgTp("1");// 发表类型1.文字2.图片3.语音;
                        sys.add(scm);
                    }
                    this.sysChatMsgWebService.addChatMsg(sys, null);
                }
                msg = "信息发送成功";
            } else if (tp.equals(7)) {/**发送短信*/
                String code = jsonarray.get("code").toString();
                String mobile = jsonarray.get("mobile").toString();
                String text = "【驰用T3】您的验证码是" + code;
                String str = JavaSmsApi.sendSms(text, mobile);
                net.sf.json.JSONObject result = net.sf.json.JSONObject.fromObject(str);
                Integer status = (Integer) result.get("code");
                if (status > 0) {//短信发送失败
                    sendWarm(response, "短信发送失败");
                    return;
                }
                msg = "短信发送成功";
            } else if (tp.equals(8)) {/**根据手机号码修改密码*/
                String pwd = jsonarray.get("pwd").toString();
                String mobile = jsonarray.get("mobile").toString();
                SysMember sysMember = memberWebService.queryMemberByMobile(mobile);
                this.memberWebService.updateUerPwd(sysMember.getDatasource(), StrUtil.string2MD5(pwd), mobile);
                msg = "密码修改成功";
            }
            json.put("state", true);
            json.put("msg", msg);
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            log.error("操作失败：", e);
            this.sendWarm(response, "操作失败");
        }
    }

    public static void main(String[] args) {
        net.sf.json.JSONObject jsonarray = net.sf.json.JSONObject.fromObject("{'companyId':'12,15,25,35'}");
        String s = jsonarray.get("companyId").toString();
        String[] sz = s.split(",");
        Integer[] menuid = new Integer[sz.length];
        for (int i = 0; i < sz.length; i++) {
            menuid[i] = Integer.parseInt(sz[i]);
        }
        for (int j = 0; j < menuid.length; j++) {
            System.out.println(menuid);
        }

    }

}
