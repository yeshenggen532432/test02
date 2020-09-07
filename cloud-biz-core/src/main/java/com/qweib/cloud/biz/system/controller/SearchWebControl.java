package com.qweib.cloud.biz.system.controller;


import com.qweib.cloud.biz.common.MapGjTool;
import com.qweib.cloud.biz.system.BaseWebService;
import com.qweib.cloud.biz.system.TokenServer;
import com.qweib.cloud.biz.system.service.plat.SysCorporationService;
import com.qweib.cloud.biz.system.service.plat.SysMemberCompanyService;
import com.qweib.cloud.biz.system.service.ws.SearchWebService;
import com.qweib.cloud.core.domain.*;
import com.qweib.cloud.utils.DateTimeUtil;
import com.qweib.cloud.utils.PropertiesUtils;
import com.qweib.cloud.utils.pinyingTool;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Controller
@RequestMapping("/web")
public class SearchWebControl extends BaseWebService {
    @Resource
    private SearchWebService searchWebService;
    @Resource
    private SysCorporationService corporationService;
    @Resource
    private SysMemberCompanyService memberCompanyService;
    private static String outUrl = PropertiesUtils.readProperties("/properties/jdbc.properties", "OURURL");

    /**
     * @param request
     * @param response
     * @param token
     * @param searchContent
     * @创建：作者:YYP 创建时间：2015-3-9
     */
    @RequestMapping("search")
    public void search(HttpServletRequest request, HttpServletResponse response, String token, String searchContent) {
//		String tp = "";// 1当前用户无所属企业  2 有企业
        List<SearchModel> lists = new ArrayList<SearchModel>();
        if (!checkParam(response, token, searchContent))
            return;
        try {
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            OnlineUser onlineUser = message.getOnlineMember();
            if ("".equals(onlineUser.getDatabase()) || null == onlineUser.getDatabase()) {//公共平台人员
                lists = searchWebService.queryMemOrCompany(searchContent, onlineUser.getMemId());
//				tp="1";
            } else {//企业内部人员
                lists = searchWebService.querySearch(onlineUser.getDatabase(), searchContent, onlineUser.getMemId());
//				tp="2";
            }
            JSONObject json = new JSONObject();
            json.put("lists", lists);
//			json.put("tp",tp);
            json.put("state", true);
            json.put("msg", "查询内容成功");
            sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            sendException(response, e);
        }
    }

    /**
     * @param request
     * @param response
     * @param token
     * @param company  deptNm,deptNum,deptTrade
     */
    @RequestMapping("addNewCompany")
    public void addNewCompany(HttpServletRequest request, HttpServletResponse response, String token, SysCorporation company) {
        JSONObject json = new JSONObject();
        if (!checkParam(response, token, company.getDeptNm()))
            return;
        try {
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            OnlineUser onlineUser = message.getOnlineMember();
            if (null != onlineUser.getDatabase() && !"".equals(onlineUser.getDatabase())) {
                sendWarm(response, "你已经有所属公司，不能创建公司");
                return;
            }
            Integer exit = corporationService.queryIsExit(company.getDeptNm());
            if (0 == exit) {
                String spellNm = pinyingTool.getAllFirstLetter(company.getDeptNm());
                if (!spellNm.matches("^[a-zA-Z]*")) {
                    spellNm = "sjk" + System.currentTimeMillis();
                }
                String path = request.getSession().getServletContext().getRealPath("/exefile") + "/cnlifebase.sql";
                company.setAddTime(DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd HH:mm:ss"));
                company.setMemberId(onlineUser.getMemId());
                Integer info = corporationService.addCompany(company, spellNm, company.getDeptNm(), onlineUser.getMemId(), "1", path);//添加公司
                //=====================增加所属公司============================//
//                SysMemberCompany newSmc = new SysMemberCompany();
//                newSmc.setCompanyId(info);
//                newSmc.setMemberMobile(onlineUser.getTel());
//                newSmc.setMemberCompany(company.getDeptNm());
//                newSmc.setInTime(DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd"));
//                newSmc.setMemberId(onlineUser.getMemId());
//                newSmc.setMemberNm(onlineUser.getMemberNm());
//                this.memberCompanyService.addSysMemberCompany(newSmc);
                //=====================增加所属公司============================//
                if (info > 0) {
                    spellNm = spellNm + info;
                    //TokenServer.updateToken(token, spellNm,null);//修改token中的database值
                    json.put("companyId", info);
                    json.put("database", spellNm);
                    json.put("state", true);
                    json.put("msg", "成功创建公司，请等待平台审核");
                    sendJsonResponse(response, json.toString());
                }
            } else {
                sendWarm(response, "该公司已存在，不能重复创建");
            }
        } catch (Exception e) {
            e.printStackTrace();
            sendException(response, e);
        }
    }

    /**
     * @param response
     * @param token
     * @param companyNm
     * @param companyId
     * @创建：作者:YYP 创建时间：2015-5-22
     */
    @RequestMapping("updateCompanyNm")
    public void updateCompanyNm(HttpServletResponse response, String token, String companyNm, Integer companyId) {
        if (!checkParam(response, token, companyNm, companyId))
            return;
        try {
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            String datasource = message.getOnlineMember().getDatabase();
            corporationService.updateCompanyNm(companyNm, companyId, datasource);
            SysCorporation corporation = this.corporationService.queryCorporationById(companyId);
            String reqJsonStr = "{\"company_id\":\"" + corporation.getPlatformCompanyId() + "\", \"company_name\":\"" + companyNm + "\"}";
            String js = MapGjTool.postqq("http://" + outUrl + "/company/update", reqJsonStr);
            JSONObject dataJson = new JSONObject(js);
            String msg = "";
            if (dataJson.getInt("code") == 0) {
                msg = "修改成功";
            } else {
                msg = "修改成功(但新平台不成功)";
            }
            sendSuccess(response, msg);
        } catch (Exception e) {
            sendException(response, e);
        }
    }

//    /**
//     * @param response
//     * @param token
//     * @param companyId
//     * @创建：作者:YYP 创建时间：2015-5-22
//     * @see 删除公司
//     */
//    @RequestMapping("delCompany")
//    public void delCompany(HttpServletResponse response, String token, Integer companyId) {
//        if (!checkParam(response, token, companyId)) {
//            return;
//        }
//
//        try {
//            OnlineMessage message = TokenServer.tokenCheck(token);
//            if (message.isSuccess() == false) {
//                sendWarm(response, message.getMessage());
//                return;
//            }
//            SysCorporation company = corporationService.queryCorporationById(companyId);
//            Integer info = corporationService.deleteCorporation(companyId, company.getDatasource());
//            if (info > 0) {
//                corporationService.deleteDB(company.getDatasource());//删除数据库
//                TokenServer.updateToken(token, "", null, null);//修改token中的数据库名
//                sendSuccess(response, "删除公司成功");
//            } else {
//                sendWarm(response, "删除公司失败");
//            }
//        } catch (Exception e) {
//            sendException(response, e);
//        }
//    }

    /**
     * 模糊查询公司
     *
     * @param response
     * @param token
     * @param searchNm
     * @创建：作者:YYP 创建时间：2015-5-23
     */
    @RequestMapping("likeCompanyNm")
    public void likeCompanyNm(HttpServletResponse response, String token, String searchNm) {
        if (!checkParam(response, token, searchNm)) {
            return;
        }
        try {
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            List<SysCorporation> companys = corporationService.queryLikeCompanyNm(searchNm);
            JSONObject json = new JSONObject();
            json.put("companys", companys);
            json.put("msg", "模糊查询公司成功");
            json.put("state", true);
            sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            e.printStackTrace();
            sendException(response, e);
        }
    }
}
