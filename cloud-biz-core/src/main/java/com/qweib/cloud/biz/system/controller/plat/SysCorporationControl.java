package com.qweib.cloud.biz.system.controller.plat;


import com.qweib.cloud.biz.common.GeneralControl;
import com.qweib.cloud.biz.common.GpsUtils;
import com.qweib.cloud.biz.common.MapGjTool;
import com.qweib.cloud.biz.system.QiniuControl;
import com.qweib.cloud.biz.system.service.plat.SysCorporationService;
import com.qweib.cloud.biz.system.service.ws.SysCorporationtpService;
import com.qweib.cloud.biz.system.service.ws.SysMemberWebService;
import com.qweib.cloud.core.domain.*;
import com.qweib.cloud.utils.DateTimeUtil;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.pinyingTool;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@Controller
@RequestMapping("/manager")
public class SysCorporationControl extends GeneralControl {
    @Resource
    private SysCorporationService corporationService;
    @Resource
    private SysMemberWebService memberWebService;
    @Resource
    private SysCorporationtpService corporationtpService;

    /**
     * 摘要：
     *
     * @说明：公司主页
     * @创建：作者:llp 创建时间：2015-2-5
     * @修改历史： [序号](llp 2015 - 2 - 5)<修改说明>
     */
    @RequestMapping("/querycorporation")
    public String querycorporation(Model model) {
        List<SysCorporationtp> list = this.corporationtpService.queryGsTpLs();
        model.addAttribute("list", list);
        return "/publicplat/corporation/corporation";
    }

    /**
     * 摘要：
     *
     * @说明：分页查询公司
     * @创建：作者:llp 创建时间：2015-2-5
     * @修改历史： [序号](llp 2015 - 2 - 5)<修改说明>
     */
    @RequestMapping("/corporationPage")
    public void corporationPage(HttpServletRequest request, HttpServletResponse response, SysCorporation corporation, Integer page, Integer rows) {
        try {
            Page p = this.corporationService.queryCorporation(corporation, page, rows);
            JSONObject json = new JSONObject();
            json.put("total", 0);
            json.put("rows", "");
            this.sendJsonResponse(response, json.toString());
            p = null;
        } catch (Exception e) {
            log.error("分页查询公司出错", e);
        }
    }

//    /**
//     * @param request
//     * @param response
//     * @param id         公司id
//     * @param datasource
//     * @创建：作者:YYP 创建时间：2015-3-18
//     * @see 删除公司
//     */
//    @RequestMapping("deleteCorporation")
//    public void delCorporation(HttpServletRequest request, HttpServletResponse response, Integer id, String datasource) {
//        try {
//            Integer info = corporationService.deleteCorporation(id, datasource);
//            if (info > 0) {
//                corporationService.deleteDB(datasource);//删除数据库
//                this.sendHtmlResponse(response, "1");
//            } else {
//                this.sendHtmlResponse(response, "-1");
//            }
//        } catch (Exception e) {
//            log.error("分页查询公司出错", e);
//            this.sendHtmlResponse(response, "-1");
//        }
//    }

    /**
     * @param response
     * @param request
     * @param company
     * @创建：作者:YYP 创建时间：2015-3-20
     * @see 创建公司
     */
    @RequestMapping("addCorporation")
    public void addCorporation(HttpServletResponse response, HttpServletRequest request, SysCorporation company) {
        try {
            String endDate = DateTimeUtil.dateTimeAddToStr(DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd"), 2, 1, "yyyy-MM-dd");
            SysMember sysMember = memberWebService.queryMemberByMobile(company.getMobile());
            if (null != sysMember) {
                this.sendHtmlResponse(response, "-2");
                return;
            }
            SysMember sys = new SysMember();
            sys.setMemberMobile(company.getMobile());
            sys.setMemberNm(company.getMemberNm());
            sys.setFirstChar(pinyingTool.getFirstLetter(company.getMemberNm()).toUpperCase());
            sys.setMemberPwd("e10adc3949ba59abbe56e057f20f883e");
            sys.setMemberCreatime(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()));
            sys.setMemberActivate("1");//激活状态 1：激活 2：未激活
            sys.setMemberUse("1");//使用状态 1:启用2：禁用
            int i = memberWebService.addMember(sys,"addCorporation");
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
                    company.setAddTime(DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd HH:mm:ss"));
                    company.setMemberId(i);
                    company.setEndDate(endDate);
                    info = corporationService.addCompany(company, spellNm, company.getDeptNm(), i, "1", path);//添加公司
                    final String gpsUrl = QiniuControl.GPS_SERVICE_URL + "/User/postLocation";
                    if (info > 0) {
                        //创建轨迹员工2
                        GpsUtils.createGpsMember(gpsUrl, info, i);
                        this.sendHtmlResponse(response, "1");
                    }
                } else {
                    this.sendHtmlResponse(response, "-3");
                    return;
                }
            } else {
                this.sendHtmlResponse(response, "-1");
            }
        } catch (Exception e) {
            log.error("创建公司出错", e);
            this.sendHtmlResponse(response, "-1");
        }
    }

    /**
     * @创建：作者:llp 创建时间：2016-7-20
     * @see 添加公司续费记录
     */
   /* @RequestMapping("addCorporationRenew")
    public void addCorporationRenew(HttpServletResponse response, HttpServletRequest request, SysCorporationRenew corporationRenew) {
        try {
            SysLoginInfo info = this.getLoginInfo(request);
            corporationRenew.setMemberId(info.getIdKey());
            this.corporationService.addCorporationRenew(corporationRenew);
            this.sendHtmlResponse(response, "1");
        } catch (Exception e) {
            log.error("添加公司续费记录出错", e);
            this.sendHtmlResponse(response, "-1");
        }
    }*/

    /**
     * 查询公司菜单树
     *
     * @param deptId
     * @param response
     */
    @RequestMapping("companyMenutree")
    public void companyMenutree(Integer deptId, HttpServletResponse response) {
        try {
            List<SysMenu> menus = this.corporationService.queryMenuByPidForDeptId(deptId);
            JSONArray json = new JSONArray(menus);
            this.sendJsonResponse(response, json.toString());
            menus = null;
        } catch (Exception ex) {
            ex.printStackTrace();
            log.error("查询公司菜单树出错:" + ex);
        }
    }

    /**
     * 查询公司应用树
     *
     * @param deptId
     * @param response
     */
    @RequestMapping("companyApplytree")
    public void companyApplytree(Integer deptId, HttpServletResponse response) {
        try {
            List<SysMenu> applyList = this.corporationService.queryApplyByPidForDeptId(deptId);
            JSONArray json = new JSONArray(applyList);
            this.sendJsonResponse(response, json.toString());
            applyList = null;
        } catch (Exception ex) {
            log.error("查询公司应用树出错:" + ex);
        }
    }
}
