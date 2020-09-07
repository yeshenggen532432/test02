package com.qweib.cloud.biz.system.controller;

import com.alibaba.fastjson.JSON;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.qweib.cloud.biz.common.GeneralControl;
import com.qweib.cloud.biz.system.UploadFile;
import com.qweib.cloud.biz.system.UserContext;
import com.qweib.cloud.biz.system.controller.plat.vo.importVo.ImportSysCustomerVo;
import com.qweib.cloud.biz.system.service.*;
import com.qweib.cloud.biz.system.service.plat.SysMemberService;
import com.qweib.cloud.biz.system.service.ws.SysDepartService;
import com.qweib.cloud.biz.system.utils.RegionExecutor;
import com.qweib.cloud.core.domain.*;
import com.qweib.cloud.core.domain.vo.ColdShopMember;
import com.qweib.cloud.core.exception.BizException;
import com.qweib.cloud.memberEvent.MemberPublisher;
import com.qweib.cloud.repository.shop.CloudShopMemberDao;
import com.qweib.cloud.repository.utils.HttpResponseUtils;
import com.qweib.cloud.repository.utils.HttpUrlUtils;
import com.qweib.cloud.utils.*;
import com.qweib.commons.MathUtils;
import com.qweib.commons.StringUtils;
import com.qweib.im.api.dto.User;
import com.qweibframework.async.handler.AsyncProcessHandler;
import com.qweibframework.commons.DateUtils;
import net.sf.json.JSONArray;
import org.apache.poi.hssf.usermodel.*;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.text.SimpleDateFormat;
import java.util.*;

@Controller
@RequestMapping("/manager")
public class SysCustomerControl extends GeneralControl {
    @Resource
    private SysCustomerService customerService;
    @Resource
    private SysKhgxsxService khgxsxService;
    @Resource
    private SysDepartService departService;
    @Resource
    private SysMemberService memberService;

    @Resource
    private SysCustomerHzfsService hzfsService;

    @Resource
    private SysCustomerImportMainService sysCustomerImportMainService;
    @Resource
    private SysInportTempService sysInportTempService;
    @Autowired
    private MemberPublisher memberPublisher;
    @Autowired
    private CloudShopMemberDao cloudShopMemberDao;
    @Resource
    private AsyncProcessHandler asyncProcessHandler;
    @Resource
    private SysRegionService sysRegionService;

    @RequestMapping("toCustomerAutoPricePage")
    public String toCustomerAutoPricePage(Model model, HttpServletRequest request) {
        try {
            SysLoginInfo info = this.getLoginInfo(request);
        } catch (Exception e) {
            log.error("", e);
        }
        return "/uglcw/customer/customer_autoprice_page";
    }

    /**
     * 摘要：
     *
     * @说明：经销商主页
     * @创建：作者:llp 创建时间：2016-2-17
     * @修改历史： [序号](llp 2016 - 2 - 17)<修改说明>
     */
    @RequestMapping("/querycustomer1")
    public String querycustomer1(HttpServletRequest request, Model model, String dataTp) {
        SysLoginInfo info = this.getLoginInfo(request);
        model.addAttribute("datasource", info.getDatasource());
        model.addAttribute("dataTp", dataTp);
        return "/uglcw/customer/customer1";
    }

    /**
     * 摘要：
     *
     * @说明：客户主页
     * @创建：作者:llp 创建时间：2016-2-17
     * @修改历史： [序号](llp 2016 - 2 - 17)<修改说明>
     */
    @RequestMapping("/querycustomer2")
    public String querycustomer2(HttpServletRequest request, Model model, @RequestParam(defaultValue = "1") String dataTp, Integer page) {
        SysLoginInfo info = this.getLoginInfo(request);
        List<SysKhlevel> list = this.khgxsxService.queryKhlevells(null, info.getDatasource());
        model.addAttribute("list", list);
        model.addAttribute("datasource", info.getDatasource());
        model.addAttribute("dataTp", dataTp);
        if (page == null) page = 1;
        model.addAttribute("page", page);
        List<SysCustomerHzfs> hzfsls = this.hzfsService.queryHzfsList(info.getDatasource());
        model.addAttribute("hzfsls", hzfsls);
        return "/uglcw/customer/customer2";
    }

    /**
     * 摘要：
     *
     * @说明：分页查询客户
     * @创建：作者:llp 创建时间：2016-2-17
     * @修改历史： [序号](llp 2016 - 2 - 17)<修改说明>
     */
    @RequestMapping("/customerPage")
    public void logisticsPage(HttpServletRequest request, HttpServletResponse response, SysCustomer customer, @RequestParam(defaultValue = "1") String dataTp,
                              Integer page, Integer rows) {
        try {
            SysLoginInfo info = this.getLoginInfo(request);
            customer.setDatabase(info.getDatasource());
//            SysMember member1 = this.memberService.querySysMemberById(info.getIdKey());
//			if(member1.getIsUnitmng().equals("3")){
//				customer.setMemberIds(this.memberService.queryBmMemberIds(member1.getBranchId(), info.getDatasource()).getMemberIds());
//			}
            Page p = this.customerService.queryCustomer(customer, dataTp, info, page, rows);
            JSONObject json = new JSONObject();
            json.put("total", p.getTotal());
            json.put("rows", p.getRows());
            this.sendJsonResponse(response, json.toString());
            p = null;
        } catch (Exception e) {
            log.error("分页查询客户出错", e);
        }
    }

    @RequestMapping("/updateCustomer")
    public void updateCustomer(HttpServletResponse response, HttpServletRequest request, Integer id, String field, String val) {
        SysLoginInfo info = this.getLoginInfo(request);
        try {
            SysCustomer customer = this.customerService.queryCustomerById(info.getDatasource(), id);
            if ("khNm".equals(field)) {
                customer.setKhNm(val);
            } else if ("linkman".equals(field)) {
                customer.setLinkman(val);
            } else if ("tel".equals(field)) {
                customer.setTel(val);
            } else if ("mobile".equals(field)) {
                customer.setMobile(val);
            } else if ("address".equals(field)) {
                customer.setAddress(val);
            } else if ("bfpcNm".equals(field)) {
                customer.setBfpcNm(val);
            }
            this.customerService.updateCustomer(customer, info.getDatasource(), "", info);
            this.sendJsonResponse(response, "1");
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    @ResponseBody
    @RequestMapping("/changeRzMobile")
    public Map<String, Object> changeRzMobile(HttpServletResponse response, HttpServletRequest request, @RequestParam(required = true, value = "id") Integer id, String mobile) {
        SysLoginInfo info = this.getLoginInfo(request);
        Map<String, Object> map = new HashMap<>();
        map.put("state", false);
        try {
            if (StringUtils.isNotEmpty(mobile) && customerService.querySysCustomerByRzMobile(mobile, info.getDatasource()) != null) {
                map.put("msg", "认证手机号码已存在!");
                return map;
            }

            //如果手机认证手机号不为空时,需要验证用户是否已存在
            if (StringUtils.isNotEmpty(mobile)) {
               /* if (!ValidatorUtil.isMobile(mobile)) {
                    map.put("msg", "手机号格式错误!");
                    return map;
                }*/
                ColdShopMember coldShopMember = cloudShopMemberDao.queryByMobile(mobile, info.getDatasource());
                //如果是已认证并是进销存会员时，需要提示用户是否修改
                if (coldShopMember != null && "3".equals(coldShopMember.getSource()) && MathUtils.valid(coldShopMember.getMemId())) {
                    if (StringUtils.isEmpty(request.getParameter("again"))) {
                        map.put("msg", "会员已绑定客户\"" + coldShopMember.getCustomerName() + "\"是否修改!");
                        map.put("code", 200);
                        return map;
                    }
                }
            }
            this.customerService.updateRzShopMobile(mobile, id, info);
            map.put("state", true);
        } catch (Exception e) {
            e.printStackTrace();
            map.put("msg", "出现错误" + e.getMessage());
        }
        return map;
    }

    /**
     * 查询没有等级的当前类型客户
     *
     * @param sysCustomer
     * @param page
     * @param rows
     * @param qdId
     * @param response
     * @param request
     */
    @RequestMapping("/queryNoneGradeCustomer")
    public void queryNoneGradeCustomer(SysCustomer sysCustomer, int page, int rows, int qdId, HttpServletResponse response, HttpServletRequest request) {
        SysLoginInfo info = this.getLoginInfo(request);
        try {
            Page p = this.customerService.queryNoneGradeCustomer(sysCustomer, page, rows, qdId, info.getDatasource());
            JSONObject json = new JSONObject();
            json.put("total", p.getTotal());
            json.put("rows", p.getRows());
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 查询当前等级和当前类型的客户（移除，查看）
     *
     * @param sysCustomer
     * @param page
     * @param rows
     * @param id
     * @param qdId
     * @param response
     * @param request
     */
    @RequestMapping("/queryCustomerByKhlevelId")
    public void queryCustomerByKhlevelId(SysCustomer sysCustomer, int page, int rows, int id, int qdId, HttpServletResponse response, HttpServletRequest request) {
        SysLoginInfo info = this.getLoginInfo(request);
        try {
            Page p = this.customerService.queryCustomerByKhlevelId(sysCustomer, page, rows, id, qdId, info.getDatasource());
            JSONObject json = new JSONObject();
            json.put("total", p.getTotal());
            json.put("rows", p.getRows());
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 添加客户等级
     *
     * @param ids
     * @param id
     * @param response
     * @param request
     */
    @RequestMapping("/batchAddCustomerGrade")
    public void batchAddCustomerGrade(String ids, Integer id, HttpServletResponse response, HttpServletRequest request) {
        SysLoginInfo loginInfo = this.getLoginInfo(request);
        try {
            if (id != null) {
                int i = this.customerService.batchAddCustomerGrade(ids, id, loginInfo.getDatasource());
                if (i > 0) {
                    this.sendHtmlResponse(response, "1");
                } else {
                    this.sendHtmlResponse(response, "-1");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            this.log.error("批量添加客户等级出错：");
            this.sendHtmlResponse(response, "-1");
        }
    }

    /**
     * 移除客户等级
     *
     * @param ids
     * @param response
     * @param request
     */
    @RequestMapping("/batchRemoveCustomerGrade")
    public void batchRemoveCustomerGrade(String ids, HttpServletResponse response, HttpServletRequest request) {
        SysLoginInfo loginInfo = this.getLoginInfo(request);
        try {
            int i = this.customerService.batchRemoveCustomerGrade(ids, loginInfo.getDatasource());
            if (i > 0) {
                this.sendHtmlResponse(response, "1");
            } else {
                this.sendHtmlResponse(response, "-1");
            }

        } catch (Exception e) {
            e.printStackTrace();
            this.log.error("批量移除等级出错：");
            this.sendHtmlResponse(response, "-1");
        }
    }
  /*  @RequestMapping({"dialogShopCustomerGradePage"})
    public void dialogShopCustomerGradePage(SysCustomer customer, int page, int rows, HttpServletResponse response, HttpServletRequest request, String qdtpNm, String khdjNm, Integer type) {
        try {
            SysLoginInfo info = this.getLoginInfo(request);
            Page p = this.customerService.customerGradePage(customer, page, rows, info.getDatasource(), qdtpNm, khdjNm, type);
            JSONObject json = new JSONObject();
            json.put("total", p.getTotal());
            json.put("rows", p.getRows());
            this.sendJsonResponse(response, json.toString());
        } catch (Exception var12) {
            var12.printStackTrace();
            this.log.error("查询会员出错：", var12);
        }

    }
*/
  /*  @RequestMapping({"/batchUpdateShopCustomerGrade"})
    public void batchUpdateShopCustomerGrade(String ids, String qdtpNm, String khdjNm, HttpServletResponse response, HttpServletRequest request) {
        SysLoginInfo info = this.getLoginInfo(request);

        try {
            if (StrUtil.isNull(qdtpNm)) {
                qdtpNm = null;
            }
            if (StrUtil.isNull(khdjNm)) {
                khdjNm = null;
            }
            int i = this.customerService.batchUpdateShopCustomerGrade(ids, qdtpNm, khdjNm, info.getDatasource());
            if (i > 0) {
                this.sendHtmlResponse(response, "1");
            } else {
                this.sendHtmlResponse(response, "-1");
            }
        } catch (Exception var7) {
            var7.printStackTrace();
            this.log.error("批量更新客户等级出错：", var7);
            this.sendHtmlResponse(response, "-1");
        }

    }*/

    /**
     * 查询没有类型的客户
     *
     * @param rows
     * @param response
     * @param request
     */
    @RequestMapping("/queryNoneTypedCustomer")
    public void queryCustomerType(SysCustomer sysCustomer, int page, int rows, HttpServletResponse response, HttpServletRequest request) {
        SysLoginInfo info = this.getLoginInfo(request);
        try {
            Page p = this.customerService.queryNoneTypedCustomer(sysCustomer, page, rows, info.getDatasource());
            JSONObject json = new JSONObject();
            json.put("total", p.getTotal());
            json.put("rows", p.getRows());
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 查询当前类型的客户（移除/查看）
     *
     * @param page
     * @param rows
     * @param id
     * @param response
     * @param request
     */
    @RequestMapping("/queryCustomerByQdtypeId")
    public void queryCustomerByQdtypeId(SysCustomer sysCustomer, int page, int rows, int id, HttpServletResponse response, HttpServletRequest request) {
        SysLoginInfo info = this.getLoginInfo(request);
        try {
            Page p = this.customerService.queryCustomerByQdtypeId(sysCustomer, page, rows, id, info.getDatasource());
            JSONObject json = new JSONObject();
            json.put("total", p.getTotal());
            json.put("rows", p.getRows());
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 添加客户类型
     *
     * @param ids
     * @param id
     * @param request
     * @param response
     */
    @RequestMapping("/batchUAddCustomer")
    public void batchUAddCustomer(String ids, Integer id, HttpServletRequest request, HttpServletResponse response) {
        SysLoginInfo loginInfo = this.getLoginInfo(request);
        try {
            if (id != null) {
                int i = this.customerService.batchUAddCustomer(ids, id, loginInfo.getDatasource());
                if (i > 0) {
                    this.sendHtmlResponse(response, "1");
                } else {
                    this.sendHtmlResponse(response, "-1");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            this.log.error("批量添加客户类型出错：");
            this.sendHtmlResponse(response, "-1");
        }
    }

    /**
     * 移除客户类型
     *
     * @param ids
     * @param request
     * @param response
     */
    @RequestMapping("/batchRemoveCustomerType")
    public void batchRemoveCustomerType(String ids, HttpServletRequest request, HttpServletResponse response) {
        SysLoginInfo loginInfo = this.getLoginInfo(request);
        try {
            int i = this.customerService.batchRemoveCustomerType(ids, loginInfo.getDatasource());
            if (i > 0) {
                this.sendHtmlResponse(response, "1");
            } else {
                this.sendHtmlResponse(response, "-1");
            }

        } catch (Exception e) {
            e.printStackTrace();
            this.log.error("批量移除类型出错：");
            this.sendHtmlResponse(response, "-1");
        }
    }

    @RequestMapping({"dialogShopCustomerPage"})
    public void dialogShopMemberPage2(SysCustomer customer, int page, int rows,
                                      String qdtpNm, Integer type, Integer[] regionId,
                                      HttpServletResponse response, HttpServletRequest request) {
        try {
            SysLoginInfo info = this.getLoginInfo(request);
            Page p = this.customerService.page2(customer, page, rows, info.getDatasource(), qdtpNm, type, regionId);
            JSONObject json = new JSONObject();
            json.put("total", p.getTotal());
            json.put("rows", p.getRows());
            this.sendJsonResponse(response, json.toString());
        } catch (Exception var12) {
            var12.printStackTrace();
            this.log.error("查询客户所属区域出错：", var12);
        }

    }


    @RequestMapping({"/batchUpdateShopCustomerType"})
    public void batchUpdateShopCustomerType(String ids, String qdtpNm, String khdjNm, Integer regionId, HttpServletResponse response, HttpServletRequest request) {
        SysLoginInfo info = this.getLoginInfo(request);

        try {
            if (StrUtil.isNull(qdtpNm)) {
                qdtpNm = null;
            }

            int i = this.customerService.batchUpdateShopCustomerType(ids, qdtpNm, khdjNm, regionId, info.getDatasource());
            if (i > 0) {
                this.sendHtmlResponse(response, "1");
            } else {
                this.sendHtmlResponse(response, "-1");
            }
        } catch (Exception var7) {
            var7.printStackTrace();
            this.log.error("批量更新客户所属区域信息出错：", var7);
            this.sendHtmlResponse(response, "-1");
        }

    }


    @RequestMapping("/getCustomerJsonById")
    public void getCustomerJsonById(HttpServletRequest request, HttpServletResponse response, Integer id) {
        try {
            SysLoginInfo info = this.getLoginInfo(request);
            SysCustomer customer = this.customerService.queryCustomerById(info.getDatasource(), id);
            JSONObject json = new JSONObject();
            json.put("customer", new JSONObject(customer));
            json.put("state", true);
            json.put("msg", "获取客户信息息成功");
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            log.error("根据ID查询客户ID出错", e);
        }
    }

    /**
     * @说明：添加/修改客户页面
     * @创建：作者:llp 创建时间：2016-2-17
     * @修改历史： [序号](llp 2016 - 2 - 17)<修改说明>
     */
    @RequestMapping("toopercustomer")
    public String toopercustomer(HttpServletRequest request, Model model, Integer Id, Integer khTp, Integer page) {
        try {
            SysLoginInfo info = this.getLoginInfo(request);
            if (null != Id) {
                try {
                    SysCustomer customer = this.customerService.queryCustomerById(info.getDatasource(), Id);
                    model.addAttribute("customer", customer);
                } catch (Exception e) {
                    log.error("获取客户出错：", e);
                }
            }
            if (page == null) page = 1;
            List<SysBfpc> bfpcls = this.khgxsxService.queryBfpcls();
            List<SysGhtype> ghtypels = this.khgxsxService.queryGhtypels();
            List<SysJxsfl> jxsflls = this.khgxsxService.queryJxsflls(info.getDatasource());
            List<SysJxsjb> jxsjbls = this.khgxsxService.queryJxsjbls(info.getDatasource());
            List<SysJxszt> jxsztls = this.khgxsxService.queryJxsztls(info.getDatasource());
            List<SysKhlevel> khlevells = this.khgxsxService.queryKhlevells(null, info.getDatasource());
            List<SysSctype> sctypels = this.khgxsxService.querySctypels();
            List<SysXsphase> xsphasels = this.khgxsxService.queryXsphasels();
            List<SysCustomerHzfs> hzfsls = this.hzfsService.queryHzfsList(info.getDatasource());
            model.addAttribute("bfpcls", bfpcls);
            model.addAttribute("ghtypels", ghtypels);
            model.addAttribute("jxsflls", jxsflls);
            model.addAttribute("jxsjbls", jxsjbls);
            model.addAttribute("jxsztls", jxsztls);
            model.addAttribute("khlevells", khlevells);
            model.addAttribute("sctypels", sctypels);
            model.addAttribute("xsphasels", xsphasels);
            model.addAttribute("page", page);
            model.addAttribute("hzfsls", hzfsls);
        } catch (Exception e) {
            e.printStackTrace();
        }
        if (khTp == 1) {
            return "/uglcw/customer/customeroper1";
        } else {
            return "/uglcw/customer/customeroper2";
        }

    }

    /**
     * @说明：添加/修改客户
     * @创建：作者:llp 创建时间：2016-2-17
     * @修改历史： [序号](llp 2016 - 2 - 17)<修改说明>
     */
    @RequestMapping("opercustomer")
    public void opercustomer(HttpServletResponse response, HttpServletRequest request, SysCustomer customer, String delPicIds) {
        try {
            SysLoginInfo info = this.getLoginInfo(request);
            int count = this.customerService.queryIskhCode(info.getDatasource(), customer.getKhCode());
            int count2 = this.customerService.queryIskhNm(info.getDatasource(), customer.getKhNm(), customer.getCity());
            if (null == customer.getId()) {
                if (count >= 1) {
                    this.sendHtmlResponse(response, "-2");
                    return;
                }
                if (count2 >= 1) {
                    this.sendHtmlResponse(response, "-3");
                    return;
                }
                customer.setCreateTime(DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd HH:mm:ss"));
                customer.setShZt("待审核");
                customer.setOrgEmpId(customer.getMemId());
                if (!StrUtil.isNull(customer.getMemId())) {
                    SysMember member = this.memberService.querySysMemberById1(info.getDatasource(), customer.getMemId());
                    customer.setOrgEmpNm(member.getMemberNm());
                }

                Map<String, Object> map = UploadFile.updatePhotos(request, info.getDatasource(), "customer/pic", 1);
                List<SysCustomerPic> customerPicList = new ArrayList<SysCustomerPic>();
                if ("1".equals(map.get("state"))) {
                    if ("1".equals(map.get("ifImg"))) {//是否有图片
                        SysCustomerPic scp = new SysCustomerPic();
                        List<String> pic = (List<String>) map.get("fileNames");
                        List<String> picMini = (List<String>) map.get("smallFile");
                        for (int i = 0; i < pic.size(); i++) {
                            scp = new SysCustomerPic();
                            scp.setPicMini(picMini.get(i));
                            scp.setPic(pic.get(i));
                            customerPicList.add(scp);
                        }
                        customer.setCustomerPicList(customerPicList);
                    }
                }

                this.customerService.addCustomer(customer, info.getDatasource());
                this.sendHtmlResponse(response, "1");
            } else {
                SysCustomer customer1 = this.customerService.queryCustomerById(info.getDatasource(), customer.getId());
                if (count >= 1) {
                    if (!customer1.getKhCode().equals(customer.getKhCode())) {
                        this.sendHtmlResponse(response, "-2");
                        return;
                    }
                }
                if (count2 >= 1) {
                    if (!customer1.getKhNm().equals(customer.getKhNm())) {
                        this.sendHtmlResponse(response, "-3");
                        return;
                    }
                }
                Map<String, Object> map = UploadFile.updatePhotos(request, info.getDatasource(), "customer/pic", 1);
                List<SysCustomerPic> customerPicList = new ArrayList<SysCustomerPic>();
                if ("1".equals(map.get("state"))) {
                    if ("1".equals(map.get("ifImg"))) {//是否有图片
                        SysCustomerPic swp = new SysCustomerPic();
                        List<String> pic = (List<String>) map.get("fileNames");
                        List<String> picMini = (List<String>) map.get("smallFile");
                        for (int i = 0; i < pic.size(); i++) {
                            swp = new SysCustomerPic();
                            swp.setPicMini(picMini.get(i));
                            swp.setPic(pic.get(i));
                            customerPicList.add(swp);
                        }
                        customer.setCustomerPicList(customerPicList);
                    }
                }
                this.customerService.updateCustomer(customer, info.getDatasource(), delPicIds, info);
                this.sendHtmlResponse(response, "2");
            }
        } catch (Exception e) {
            e.printStackTrace();
            log.error("添加/修改客户出错：", e);
            if (e instanceof BizException) {
                this.sendHtmlResponse(response, "-1");
            }
        }
    }

    /**
     * @说明：删除客户
     * @创建：作者:llp 创建时间：2016-2-17
     * @修改历史： [序号](llp 2016 - 2 - 17)<修改说明>
     */
    @RequestMapping("delcustomer")
    public void delcustomer(HttpServletRequest request, HttpServletResponse response, Integer[] ids) {
        try {
            SysLoginInfo info = getInfo(request);
            this.customerService.deleteCustomer(ids, info);
            this.sendHtmlResponse(response, "1");
        } catch (Exception e) {
            log.error("删除客户出错：", e);
            this.sendHtmlResponse(response, "-1");
        }
    }

    /**
     * 说明：修改客户种类
     *
     * @创建：作者:llp 创建时间：2016-2-17
     * @修改历史： [序号](llp 2016 - 2 - 17)<修改说明>
     */
    @RequestMapping("updatekhTp")
    public void updatekhTp(HttpServletRequest request, HttpServletResponse response, Integer khTp, Integer[] ids) {
        try {
            SysLoginInfo info = getInfo(request);
            this.customerService.updatekhTp(info.getDatasource(), khTp, ids);
            this.sendHtmlResponse(response, "1");
        } catch (Exception e) {
            log.error("修改客户种类出错：", e);
            this.sendHtmlResponse(response, "-1");
        }
    }

    /**
     * 说明：审核操作
     *
     * @创建：作者:llp 创建时间：2016-2-19
     * @修改历史： [序号](llp 2016 - 2 - 18)<修改说明>
     */
    @RequestMapping("updateShZt")
    public void updateShZt(HttpServletRequest request, HttpServletResponse response, String shZt, Integer[] ids) {
        try {
            SysLoginInfo info = getInfo(request);
            this.customerService.updateShZt(info.getDatasource(), shZt, info.getIdKey(), DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd HH:mm:ss"), ids);
            this.sendHtmlResponse(response, "1");
        } catch (Exception e) {
            log.error("修改客户种类出错：", e);
            this.sendHtmlResponse(response, "-1");
        }
    }

    /**
     * 摘要：
     *
     * @说明：选择经销商
     * @创建：作者:llp 创建时间：2016-2-17
     * @修改历史： [序号](llp 2016 - 2 - 17)<修改说明>
     */
    @RequestMapping("/choicecustomer1")
    public String choicecustomer1() {
        return "/uglcw/customer/choicecustomer1";
    }

    /**
     * 摘要：
     *
     * @说明：选择客户
     * @创建：作者:llp 创建时间：2016-2-17
     * @修改历史： [序号](llp 2016 - 2 - 17)<修改说明>
     */
    @RequestMapping("/choicecustomer2")
    public String choicecustomer2() {
        return "/uglcw/customer/choicecustomer2";
    }

    @RequestMapping("/choiceEpCustomer")
    public String choiceEpCustomer() {
        return "/uglcw/customer/choiceEpCustomer";
    }

    /**
     * 摘要：
     *
     * @说明： 客户地图
     * @创建：作者:llp 创建时间：2016-4-5
     * @修改历史： [序号](llp 2016 - 4 - 5)<修改说明>
     */
    @RequestMapping("/querycmap")
    public String querycmap(HttpServletRequest request, Model model, String khNm, String memberNm, String dataTp) {
        SysLoginInfo info = getInfo(request);
        try {
//			SysMember member1=this.memberService.querySysMemberById(info.getIdKey());
//			String memberIds="";
//			if(member1.getIsUnitmng().equals("3")){
//				memberIds=this.memberService.queryBmMemberIds(member1.getBranchId(), info.getDatasource()).getMemberIds();
//			}
            List<SysCustomer> list = this.customerService.querycustomerMap(info, khNm, memberNm, dataTp);

            StringBuilder markerArr = new StringBuilder("[");

            JSONArray ja = new JSONArray();
            for (int i = 0; i < list.size(); i++) {
                String jwd = list.get(i).getLongitude() + "&" + list.get(i).getLatitude();

//				if(i==list.size()-1){
//					markerArr.append("['khNm':'"+list.get(i).getKhNm()+"','point':'"+jwd+"','address':'"+list.get(i).getAddress()+"', 'tel': '"+list.get(i).getTel()+"', 'linkman':'"+list.get(i).getLinkman()+"' , 'mobile':'"+list.get(i).getMobile()+"', 'memberNm':'"+list.get(i).getMemberNm()+"' , 'branchName':'"+list.get(i).getBranchName()+"',remo:'"+list.get(i).getRemo()+"',scbfDate:'"+list.get(i).getScbfDate()+"']");
//				}else{
//					markerArr.append("['khNm':'"+list.get(i).getKhNm()+"', 'point':'"+jwd+"','address': '"+list.get(i).getAddress()+"', 'tel': '"+list.get(i).getTel()+"', 'linkman':'"+list.get(i).getLinkman()+"' , 'mobile':'"+list.get(i).getMobile()+"', 'memberNm':'"+list.get(i).getMemberNm()+"' , 'branchName:'"+list.get(i).getBranchName()+"',remo:'"+list.get(i).getRemo()+"',scbfDate:'"+list.get(i).getScbfDate()+"'],");
//				}
                net.sf.json.JSONObject json = new net.sf.json.JSONObject();
                json.put("khNm", list.get(i).getKhNm());
                json.put("point", jwd);
                json.put("address", list.get(i).getAddress());
                json.put("tel", list.get(i).getTel());
                json.put("linkman", list.get(i).getLinkman());
                json.put("mobile", list.get(i).getMemberNm());
                json.put("branchName", list.get(i).getBranchName());
                json.put("remo", list.get(i).getRemo());
                json.put("scbfDate", list.get(i).getScbfDate());
                ja.add(json);
            }
            markerArr.append("]");
            //model.addAttribute("markerArr", markerArr.toString());
            model.addAttribute("markerArr", ja.toString());
        } catch (Exception e) {
            log.error("查询客户地图出错：", e);
        }
        return "/uglcw/customer/customermap2";
    }

    /**
     * 摘要：
     *
     * @说明： 获取所有一级（渠道）
     * @创建：作者:llp 创建时间：2016-4-13
     * @修改历史： [序号](llp 2016 - 4 - 13)<修改说明>
     */
    @RequestMapping("/queryarealist1")
    public void queryarealist1(HttpServletResponse response, HttpServletRequest reques) {
        try {
            SysLoginInfo info = getInfo(reques);
            SysQdKhLs qdKhLs = new SysQdKhLs();
            List<SysQdtype> list = this.khgxsxService.queryQdtypls(info.getDatasource());
            qdKhLs.setList1(list);
            JSONObject json = new JSONObject(qdKhLs);
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            log.error("获取所有一级（渠道）：", e);
        }

    }

    /**
     * 摘要：
     *
     * @说明：获取所有二级（客户等级）
     * @创建：作者:llp 创建时间：2016-4-13
     * @修改历史： [序号](llp 2016 - 4 - 13)<修改说明>
     */
    @RequestMapping("/queryarealist2")
    public void queryarealist2(HttpServletResponse response, HttpServletRequest reques, String qdtpNm, Integer qdtypeId) {
        try {
            SysLoginInfo info = getInfo(reques);
            SysQdKhLs qdKhLs = new SysQdKhLs();
            List<SysKhlevel> list = Lists.newArrayList();
            if (qdtypeId != null) {
                list = this.khgxsxService.queryKhlevells(qdtypeId, info.getDatasource());
            } else {
                if (!StrUtil.isNull(qdtpNm)) {
                    SysQdtype qdtype = this.khgxsxService.queryQdtypone(qdtpNm, info.getDatasource());
                    list = this.khgxsxService.queryKhlevells(qdtype.getId(), info.getDatasource());

                }
            }
            qdKhLs.setList2(list);
            JSONObject json = new JSONObject(qdKhLs);
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            log.error("获取所有二级（客户等级）出错：", e);
        }

    }

    @RequestMapping("/selectCustomerList")
    public void selectCustomerList(HttpServletRequest request, HttpServletResponse response) {
        try {
            SysLoginInfo info = this.getLoginInfo(request);
            SysCustomer customer = new SysCustomer();
            customer.setIsDb(2);
            List<SysCustomer> list = this.customerService.queryCustomerList(customer, info.getDatasource());
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("rows", list);
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            log.error("", e);
        }
    }


    /**
     * 说明：修改客户是否倒闭
     *
     * @创建：作者:llp 创建时间：2016-7-20
     * @修改历史： [序号](llp 2016 - 7 - 20)<修改说明>
     */
    @RequestMapping("updatekhIsdb")
    public void updatekhIsdb(HttpServletRequest request, HttpServletResponse response, Integer isDb, Integer id) {
        try {
            SysLoginInfo info = getInfo(request);
            this.customerService.updatekhIsdb(info.getDatasource(), isDb, id, info);

            //-------------------------更新商城会员表的信息：start---------------------------------
            /*SysCustomer oldCustomer = this.customerService.queryCustomerById(info.getDatasource(), id);
            String rzMobile = oldCustomer.getRzMobile();
            if (!StrUtil.isNull(rzMobile)) {
                Map<String, Object> shopMemberMap = this.memberService.queryShopMemberByOpenId(null, rzMobile, info.getDatasource());
                if (!(shopMemberMap == null || shopMemberMap.isEmpty())) {
                    if (1 == isDb) {
                        //转为“倒闭客户”
                        if ("3".equals(shopMemberMap.get("source"))) {
                            shopMemberMap.put("source", 1);//(来源：：普通1；员工2；客户3)
                            shopMemberMap.put("customer_id", null);
                            shopMemberMap.put("customer_name", null);
                        }
                    } else if (2 == isDb) {
                        //转为“正常客户”
                        if ("1".equals(shopMemberMap.get("source"))) {
                            shopMemberMap.put("source", 3);//(来源：：普通1；员工2；客户3)
                            shopMemberMap.put("customer_id", oldCustomer.getId());
                            shopMemberMap.put("customer_name", oldCustomer.getKhNm());
                        }
                    }
                    this.memberService.updateShopMember(shopMemberMap, info.getDatasource());
                }
            }*/


            //-------------------------更新商城会员表的信息：end---------------------------------
            this.sendHtmlResponse(response, "1");
        } catch (Exception e) {
            log.error("修改客户是否倒闭出错：", e);
            this.sendHtmlResponse(response, "-1");
        }
    }

    /**
     * 摘要：下载excel模板(上传成员模板)
     *
     * @param @param request
     * @param @param response
     * @说明：
     * @创建：作者:HSL 创建时间：2016-9-9
     * @修改历史： [序号](YYP 2014 - 7 - 2)<修改说明>
     */
    @RequestMapping("/toCustomerModel")
    public void toLoadModel(HttpServletRequest request, HttpServletResponse response) {
        try {
//			String path = request.getSession().getServletContext().getRealPath("/exefile");
//			File excelFile = new File(path+"//kehubiaoge.xlsx");
//	        //打开指定文件的流信息
//			FileInputStream fs = new FileInputStream(new File(path+"//kehubiaoge.xlsx"));
//			//设置响应头和保存文件名
//			// 设置输出的格式
//            response.reset();
//			response.setContentType("APPLICATION/OCTET-STREAM");
//			response.setHeader("Content-Disposition", "attachment; filename=\"" + "kehubiaoge.xlsx" + "\"");
            //写出流信息
//			int b = 0;
//			ServletOutputStream out = response.getOutputStream();
//			while((b=fs.read())!=-1) {
//				out.write(b);
//			}
//			out.flush();
//			out.close();
//			fs.close();
            SysLoginInfo info = getLoginInfo(request);

            String fname = ""
                    + "kehutemplate";// Excel文件名
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
            cteateCell(wb, row, (short) 0, "客户名称", cellstyle);
            cteateCell(wb, row, (short) 1, "负责人", cellstyle);
            cteateCell(wb, row, (short) 2, "负责人电话", cellstyle);
            cteateCell(wb, row, (short) 3, "负责人手机", cellstyle);
            cteateCell(wb, row, (short) 4, "业务员", cellstyle);
            cteateCell(wb, row, (short) 5, "地址", cellstyle);
            //List<SysCustomer> list = this.customerService.queryCustomerList(null, null, info);
            List<SysCustomer> list = new ArrayList<SysCustomer>();
            if (list == null && list.size() == 0) {
                int rowIndex = 1;
                HSSFRow nrow = sheet.createRow((short) rowIndex);
                cteateCell(wb, nrow, (short) 0, "某客户", cellstyle);
                cteateCell(wb, nrow, (short) 1, "某某某", cellstyle);
                cteateCell(wb, nrow, (short) 2, "18866660000", cellstyle);
                cteateCell(wb, nrow, (short) 3, "1866662334", cellstyle);
                cteateCell(wb, nrow, (short) 4, "某某某", cellstyle);
                cteateCell(wb, nrow, (short) 5, "福建省厦门市思明区某某路", cellstyle);
            } else {
                for (int i = 0; i < list.size(); i++) {
                    int rowIndex = i + 1;
                    SysCustomer customer = list.get(i);
                    HSSFRow nrow = sheet.createRow((short) rowIndex);
                    cteateCell(wb, nrow, (short) 0, customer.getKhNm(), cellstyle);
                    cteateCell(wb, nrow, (short) 1, customer.getLinkman(), cellstyle);
                    cteateCell(wb, nrow, (short) 2, customer.getTel(), cellstyle);
                    cteateCell(wb, nrow, (short) 3, customer.getMobile(), cellstyle);
                    cteateCell(wb, nrow, (short) 4, customer.getMemberNm(), cellstyle);
                    cteateCell(wb, nrow, (short) 5, customer.getAddress(), cellstyle);
                }
            }
            wb.write(os);
            os.flush();
            os.close();
            System.out.println("文件生成");
        } catch (Exception e) {
            e.printStackTrace();
            log.error("下载excel模板失败", e);
        }
    }

    /**
     * 下载编辑后数据zzx
     *
     * @param request
     * @param response
     * @return
     */
    @ResponseBody
    @RequestMapping("/downCustomerToImportTemp")
    public Map<String, Object> downCustomerToImportTemp(HttpServletRequest request, HttpServletResponse response) {
        Map<String, Object> map = new HashMap<>();
        map.put("state", false);
        map.put("msg", "操作失败");
        try {
            SysLoginInfo info = this.getLoginInfo(request);
            List<SysCustomer> list = customerService.queryCustomerListByIds(request.getParameter("ids"), info.getDatasource());
            RegionExecutor regionExecutor = new RegionExecutor(info.getDatasource(), sysRegionService);
            if (Collections3.isNotEmpty(list)) {
                List<ImportSysCustomerVo> volist = new ArrayList<>(list.size());
                ImportSysCustomerVo vo = null;
                for (SysCustomer sysCustomer : list) {
                    vo = new ImportSysCustomerVo();
                    BeanCopy.copyBeanProperties(vo, sysCustomer);
                    vo.setMemberNm(sysCustomer.getMemberNm());//业务员
                    vo.setRegionStr(regionExecutor.getRegiionStr(sysCustomer.getRegionId()));
                    volist.add(vo);
                }
                if (StringUtils.isNotEmpty(request.getParameter("downExcel"))) {
                    sysInportTempService.downDataToExcel(response, SysImportTemp.TypeEnum.type_sys_customer, volist, "客户信息");
                    return null;
                }
                int importId = sysInportTempService.save(volist, SysImportTemp.TypeEnum.type_sys_customer.getCode(), info, SysImportTemp.InputDownEnum.down.getCode());
                map.put("importId", importId);
                map.put("state", true);
                map.put("msg", "操作成功，导出数量" + list.size());
            }
        } catch (Exception e) {
            log.error("上传客户失败", e);
            map.put("msg", "操作出现错误" + e.getMessage());
        }
        return map;
    }

    /**
     * 上传编辑后数据zzx
     *
     * @param request
     * @param response
     * @return
     */
    @ResponseBody
    @RequestMapping("/toUpCustomerExcelNew")
    public Map<String, Object> toUpExcel1(HttpServletRequest request, HttpServletResponse response) {
        Map<String, Object> map = new HashMap<>();
        map.put("state", false);
        map.put("msg", "操作失败");
        try {
            SysLoginInfo info = this.getLoginInfo(request);
            List<ImportSysCustomerVo> list = sysInportTempService.queryItemList(request, info.getDatasource());
            if (Collections3.isNotEmpty(list)) {
                String taskId = asyncProcessHandler.createTask();
                map.put("taskId", taskId);
                this.customerService.addSysCustomerlsImport(list, info, taskId, Maps.newHashMap(request.getParameterMap()));
                map.put("state", true);
                map.put("msg", "已提交后台处理");
            } else {
                map.put("msg", "暂无有效数据可导入");
            }
        } catch (Exception e) {
            log.error("上传客户失败", e);
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
     * @创建：作者:HSL 创建时间：2016-9-12
     * @修改历史： [序号](YYP 2014 - 5 - 30)<修改说明>
     */
    @RequestMapping("toUpCustomerExcel")
    public void toUpCustomerExcel(HttpServletRequest request, HttpServletResponse response) {
        try {
            SysLoginInfo info = this.getLoginInfo(request);
            MultipartHttpServletRequest multiRequest = (MultipartHttpServletRequest) request;
            MultipartFile upFile = multiRequest.getFile("upFile");
            Workbook workbook = null;
            try {
                workbook = new XSSFWorkbook(upFile.getInputStream());//2007
            } catch (Exception ex) {
                workbook = new HSSFWorkbook(upFile.getInputStream());//2003
            }
            //第一个工作表
            Sheet sheet = workbook.getSheetAt(0);
            //验证头部
            int inform = checkHeader(sheet);
            if (inform == -1) {
                this.sendHtmlResponse(response, "表头列名格式非法，请按照模板填写客户信息！");
                return;
            }
            List<SysCustomer> customers = new ArrayList<SysCustomer>();
            List<SysCustomerImportSub> importSubs = new ArrayList<SysCustomerImportSub>();
            Set<String> sett = new HashSet<String>();
            for (int j = 1; j <= sheet.getLastRowNum(); j++) {
                Row row = sheet.getRow(j);
                if (StrUtil.isNull(row)) {//表格下某行不存在数据情况
                    continue;
                }
                //Integer tmpn = j;
                //String tmp = " row " + tmpn;
                //System.out.print(tmp + "\n");
                this.setCellType(row, 6);//设置单元格格式

                //row.getCell(2).setCellStyle(arg0);
                String name = row.getCell(0) == null ? "" : row.getCell(0).getStringCellValue().trim();
                String fman = row.getCell(1) == null ? "" : row.getCell(1).getStringCellValue().trim();
                String ftel = row.getCell(2) == null ? "" : row.getCell(2).getStringCellValue().trim();
                String mobile = row.getCell(3) == null ? "" : row.getCell(3).getStringCellValue().trim();
                String Salesman = row.getCell(4) == null ? "" : row.getCell(4).getStringCellValue().trim();
                String dz = row.getCell(5) == null ? "" : row.getCell(5).getStringCellValue().trim();
                if ("".equals(name) && "".equals(fman) && "".equals(ftel) && "".equals(mobile)) {//整行为空跳过(excel清空内容情况)
                    continue;
                }
                if ("".equals(name)) {
                    continue;
                    //this.sendHtmlResponse(response, "第"+(j+1)+"行客户名称不能为空!");//客户名称不能为空
                    //return;
                }
                if (!sett.add(name)) {//set不重复加入则表格中存在重复客户
                    //this.sendHtmlResponse(response,"第"+(j+1)+"行“"+name+"”客户名称重复，请修改!");
                    //return;
                    continue;
                }
                //int a = this.customerService.querySysCustomerByTel(info.getDatasource(),name);
                SysCustomer customer = this.customerService.querySysCustomerByName(info.getDatasource(), name);
                SysCustomerImportSub importSub = new SysCustomerImportSub();
                if (customer != null) {
                    //this.sendHtmlResponse(response, "第"+(j+1)+"行“"+name+"”客户已注册,请检查");//存在已注册客户,请检查
                    customer.setTel(ftel);
                    customer.setMobile(mobile);
                    customer.setKhNm(name);
                    customer.setLinkman(fman);
                    customer.setCreateTime(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()));
                    customer.setOpenDate(new SimpleDateFormat("yyyy-MM-dd").format(new Date()));

                    customer.setAddress(dz);
                    if (!StrUtil.isNull(Salesman)) {
                        SysMember member = this.memberService.querySysDepartByNm(Salesman, info.getDatasource());
                        if (member == null) {
                            this.sendHtmlResponse(response, "第" + (j + 1) + "行输入的的业务员名称“" + Salesman + "”不存在,请重新输入");
                        }
                        customer.setMemId(member.getMemberId());
                        customer.setOrgEmpId(member.getMemberId());
                        customer.setOrgEmpNm(member.getMemberNm());
                        customer.setBranchId(member.getBranchId());
                    }
                    if (StrUtil.isNull(customer.getLatitude())) {
                        customer.setLatitude("0");
                    }
                    if (StrUtil.isNull(customer.getLongitude())) {
                        customer.setLongitude("0");
                    }
                    BeanCopy.copyBeanProperties(importSub, customer);
                    importSub.setId(null);
                    importSub.setCstId(customer.getId());
                    this.customerService.updateCustomer(customer, info.getDatasource(), "", info);
                } else {
                    SysCustomer cus = null;
                    if (StrUtil.isNull(Salesman)) {
                        cus = memSetValues(info, name, fman, ftel, mobile, null, null, null, dz);
                    } else {
                        SysMember member = this.memberService.querySysDepartByNm(Salesman, info.getDatasource());
                        if (null == member) {
                            this.sendHtmlResponse(response, "第" + (j + 1) + "行输入的的业务员名称“" + Salesman + "”不存在,请重新输入");
                            return;
                        } else {
                            cus = memSetValues(info, name, fman, ftel, mobile, member.getMemberId(), member.getBranchId(), member.getMemberNm(), dz);
                        }
                    }
                    cus.setLatitude("0");
                    cus.setLongitude("0");
                    cus.setKhTp(2);
                    cus.setIsYx("1");
                    cus.setIsOpen("1");
                    cus.setIsDb(2);
                    cus.setPy(ChineseCharToEnUtil.getFirstSpell(cus.getKhNm()));
                    customers.add(cus);
                    BeanCopy.copyBeanProperties(importSub, cus);
                    importSub.setId(null);
                    importSub.setCstId(cus.getId());
                }
                importSubs.add(importSub);
            }
            this.customerService.addSysCustomerls(customers, info);
            try {
                SysCustomerImportMain main = new SysCustomerImportMain();
                main.setOperId(info.getIdKey());
                main.setOperName(info.getUsrNm());
                main.setImportTime(new Date());
                main.setList(importSubs);
                main.setTitle(DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd HH:mm") + "客户信息导入");
                this.sysCustomerImportMainService.add(main, info.getDatasource());
            } catch (Exception ex) {
                ex.printStackTrace();
                log.error("客户保存导入记录错误", ex);
            }

            this.sendHtmlResponse(response, "1");
        } catch (Exception e) {
            // TODO: handle exception
            log.error("上传客户失败", e);
            this.sendHtmlResponse(response, "上传失败,请检查客户信息！");
        }
    }

    //	设置member值
    private SysCustomer memSetValues(SysLoginInfo info, String name, String fman,
                                     String ftel, String mobile, Integer MemberId, Integer branchId, String memberNm, String dz) {
        // TODO Auto-generated method stub
        SysCustomer customer = new SysCustomer();
        customer.setTel(ftel);
        customer.setMobile(mobile);
        customer.setKhNm(name);
        customer.setLinkman(fman);
        customer.setCreateTime(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()));
        customer.setMemId(MemberId);
        customer.setOpenDate(new SimpleDateFormat("yyyy-MM-dd").format(new Date()));
        customer.setBranchId(branchId);
        customer.setOrgEmpNm(memberNm);
        customer.setAddress(dz);
        customer.setOrgEmpId(MemberId);
        return customer;
    }

    private void setCellType(Row row, int cellCount) {
        // TODO Auto-generated method stub
        for (int i = 0; i < cellCount; i++) {
            Cell nameCell = row.getCell(i);
            if (nameCell != null) {
                nameCell.setCellType(Cell.CELL_TYPE_STRING);
            }
        }

    }

    /**
     * 校验表头
     *
     * @param sheet
     * @return
     */
    private int checkHeader(Sheet sheet) {
        //获得行数  第一行
        Row header = sheet.getRow(0);
        setCellType(header, 5);
        String headerName = header.getCell(0).getStringCellValue().trim();
        String headerfman = header.getCell(1).getStringCellValue().trim();
        String headerftel = header.getCell(2).getStringCellValue().trim();
        String headermobile = header.getCell(3).getStringCellValue().trim();
        String Salesman = header.getCell(4).getStringCellValue().trim();
        if (!headerName.equals("客户名称") || !headerfman.equals("负责人") || !headerftel.equals("负责人电话") || !headermobile.equals("负责人手机") || !Salesman.equals("业务员")) {
            return -1;    //表头列名格式非法，请按照模板填写成员信息！
        }
        return 1;
    }

    /**
     * 说明：转让业代
     *
     * @创建：作者:llp 创建时间：2016-10-11
     * @修改历史： [序号](llp 2016 - 10 - 11)<修改说明>
     */
    @RequestMapping("updateZryd")
    public void updateZryd(HttpServletRequest request, HttpServletResponse response, Integer Mid, Integer[] ids) {
        try {
            SysLoginInfo info = getInfo(request);
            this.customerService.updateZryd(info.getDatasource(), Mid, ids);
            this.sendHtmlResponse(response, "1");
        } catch (Exception e) {
            log.error("转让业代出错：", e);
            this.sendHtmlResponse(response, "-1");
        }
    }

    @RequestMapping("/customerwaretype")
    public String customerwaretype(HttpServletRequest request, Model model, String dataTp) {
        SysLoginInfo info = this.getLoginInfo(request);
        model.addAttribute("datasource", info.getDatasource());
        model.addAttribute("dataTp", dataTp);

        //新ui-商品分类和grid同一个页面
        String customerId = request.getParameter("customerId");
        String op = request.getParameter("op");
        if (!StrUtil.isNull(customerId)) {
            List<SysCustomerWarePrice> list = this.customerService.listSysCustomerWarePrice(info.getDatasource(), Integer.valueOf(customerId));
            JSONArray warePrice = JSONArray.fromObject(list);
            model.addAttribute("warePrice", warePrice.toString());
            List<SysCustomerSalePrice> list1 = this.customerService.listSysCustomerSalePrice(info.getDatasource(), Integer.valueOf(customerId));
            JSONArray salePrice = JSONArray.fromObject(list1);
            model.addAttribute("salePrice", salePrice.toString());

            List<SysCustomerPrice> list2 = this.customerService.listSysCustomerPrice(info.getDatasource(), Integer.valueOf(customerId));
            JSONArray customerPrice = JSONArray.fromObject(list2);
            model.addAttribute("customerPrice", customerPrice.toString());
            model.addAttribute("customerId", customerId);
            model.addAttribute("op", op);
        }

        return "/uglcw/customer/customerwaretype";
    }

    @RequestMapping("/customerwarepage")
    public String customerwarepage(HttpServletRequest request, Model model, Integer wtype, String dataTp, Integer
            customerId) {
        SysLoginInfo info = this.getLoginInfo(request);
        model.addAttribute("wtype", wtype);
        model.addAttribute("tpNm", info.getTpNm());
        List<SysCustomerWarePrice> list = this.customerService.listSysCustomerWarePrice(info.getDatasource(), customerId);
        JSONArray warePrice = JSONArray.fromObject(list);
        //System.out.println(warePrice.toString());
        model.addAttribute("warePrice", warePrice.toString());
        List<SysCustomerSalePrice> list1 = this.customerService.listSysCustomerSalePrice(info.getDatasource(), customerId);
        JSONArray salePrice = JSONArray.fromObject(list1);
        model.addAttribute("salePrice", salePrice.toString());

        List<SysCustomerPrice> list2 = this.customerService.listSysCustomerPrice(info.getDatasource(), customerId);
        JSONArray customerPrice = JSONArray.fromObject(list2);
        model.addAttribute("customerPrice", customerPrice.toString());

        return "/uglcw/customer/customerwarepage";
    }

    @RequestMapping("/updateSysCustomerWarePrice")
    public void updateSysCustomerWarePrice(HttpServletResponse response, HttpServletRequest
            request, SysCustomerWarePrice model) {
        SysLoginInfo info = this.getLoginInfo(request);
        try {
            int i = this.customerService.updateSysCustomerWarePrice(info.getDatasource(), model);
            this.sendJsonResponse(response, "" + i);
        } catch (Exception e) {
        }
    }

    @RequestMapping("/updateCustomerPy")
    public void updateCustomerPy(HttpServletResponse response, HttpServletRequest request) {
        SysLoginInfo info = this.getLoginInfo(request);
        try {
            this.customerService.updateAllPy(info.getDatasource());
            this.sendJsonResponse(response, "1");
        } catch (Exception e) {
        }
    }

    @RequestMapping("/customersaletype")
    public String customersaletype(HttpServletRequest request, Model model, String dataTp) {
        SysLoginInfo info = this.getLoginInfo(request);
        model.addAttribute("datasource", info.getDatasource());
        model.addAttribute("dataTp", dataTp);
        return "/uglcw/customer/customersaletype";
    }

    @RequestMapping("/customersalepage")
    public String customersalepage(HttpServletRequest request, Model model, Integer wtype, String dataTp, Integer
            customerId) {
        SysLoginInfo info = this.getLoginInfo(request);
        model.addAttribute("wtype", wtype);
        model.addAttribute("tpNm", info.getTpNm());
        List<SysCustomerSalePrice> list = this.customerService.listSysCustomerSalePrice(info.getDatasource(), customerId);
        JSONArray salePrice = JSONArray.fromObject(list);
        model.addAttribute("salePrice", salePrice.toString());
        return "/uglcw/customer/customersalepage";
    }

    @RequestMapping("/updateSysCustomerSalePrice")
    public void updateSysCustomerSalePrice(HttpServletResponse response, HttpServletRequest
            request, SysCustomerSalePrice model) {
        SysLoginInfo info = this.getLoginInfo(request);
        try {
            int i = this.customerService.updateSysCustomerSalePrice(info.getDatasource(), model);
            this.sendJsonResponse(response, "" + i);
        } catch (Exception e) {
        }
    }

    @RequestMapping("/listSysCustomerWarePrice")
    public void listSysCustomerWarePrice(HttpServletResponse response, HttpServletRequest request, Integer clientId) {
        try {
            SysLoginInfo info = this.getLoginInfo(request);
            List<SysCustomerWarePrice> list = this.customerService.listSysCustomerWarePrice(info.getDatasource(), clientId);
            JSONArray jsonArray = JSONArray.fromObject(list);
            this.sendJsonResponse(response, jsonArray.toString());
        } catch (Exception e) {
            log.error("：获取客户商品运输价格失败", e);
        }

    }

    @SuppressWarnings("deprecation")
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

    @RequestMapping("/updateSysCustomerPrice")
    public void updateSysCustomerPrice(HttpServletResponse response, HttpServletRequest request, SysCustomerPrice
            model) {
        SysLoginInfo info = this.getLoginInfo(request);
        try {
            int i = this.customerService.updateSysCustomerPrice(info.getDatasource(), model);
            this.sendJsonResponse(response, "" + i);
        } catch (Exception e) {
        }
    }

    @RequestMapping("/batchUpdateCustomerType")
    public void batchUpdateCustomerType(String ids, String customerType, String hzfsNm, Integer isDb, String
            khdjNm, HttpServletResponse response, HttpServletRequest request) {
        SysLoginInfo info = this.getLoginInfo(request);
        try {

            String regionId = request.getParameter("regionId");
            int i = this.customerService.updateBatchCustomer(ids, customerType, hzfsNm, isDb, khdjNm, regionId, info);
            if (i > 0) {
                this.sendHtmlResponse(response, "2");
            } else {
                this.sendHtmlResponse(response, "1");
            }
        } catch (Exception e) {
            e.printStackTrace();
            log.error("删除更改客户类别出错：", e);
            this.sendHtmlResponse(response, "-1");
        }
    }

    @RequestMapping("getCustomerById")
    public void getCustomerById(HttpServletResponse response, HttpServletRequest request, Integer customerId) {
        try {
            SysLoginInfo info = this.getLoginInfo(request);
            SysCustomer sysCustomer = this.customerService.queryCustomerById(info.getDatasource(), customerId);
            JSONObject json = new JSONObject();
            if (!StrUtil.isNull(sysCustomer)) {
                json.put("state", true);
                json.put("customer", new JSONObject(sysCustomer));
            } else {
                json.put("state", false);
                json.put("msg", "暂无记录");
            }
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            this.sendJsonResponse(response, "{state:false}");
        }
    }


    /**
     * 认证员工手机号
     */
    @RequestMapping("updateCustomerByRzMobile")
    public void updateCustomerByRzMobile(Model model, HttpServletRequest request, HttpServletResponse
            response, SysCustomer customer, String oldMobile) {
        //1.认证成功；2.该手机号已认证过；3.该手机号已在客户管理中认证过
       /* try {
            SysLoginInfo info = this.getLoginInfo(request);
            String rzMobile = customer.getRzMobile();
            String res = "";
            if (!StrUtil.isNull(rzMobile) && rzMobile.length() == 11) {
                res = this.customerService.updateCustomerByRzMobile(info.getDatasource(), rzMobile, customer.getId(), oldMobile);
                this.sendHtmlResponse(response, res);
            }
        } catch (Exception e) {
            log.error("认证经销存客户手机号出错：", e);
            this.sendHtmlResponse(response, "出现错误" + e.getMessage());
        }*/
        this.sendHtmlResponse(response, "接口不使用");
    }

    @RequestMapping("/toDialogCustomer")
    public String toDialogCustomer(HttpServletRequest request, Model model, String dataTp) {
        SysLoginInfo info = this.getLoginInfo(request);
        model.addAttribute("datasource", info.getDatasource());
        model.addAttribute("dataTp", dataTp);
        return "/stk/dialog/dialogCustomer";
    }

    /**
     * 查询没有加盟连锁店的客户
     *
     * @param sysCustomer
     * @param page
     * @param rows
     * @param response
     * @param request
     */
    @RequestMapping("/queryNoneChainStoreCustomer")
    public void queryNoneChainStoreCustomer(SysCustomer sysCustomer, int page, int rows, HttpServletResponse response, HttpServletRequest request) {
        SysLoginInfo info = this.getLoginInfo(request);
        try {
            Page p = this.customerService.queryNoneChainStoreCustomer(sysCustomer, page, rows, info.getDatasource());
            JSONObject json = new JSONObject();
            json.put("total", p.getTotal());
            json.put("rows", p.getRows());
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 查询当前连锁店的客户（移除/查看）
     *
     * @param sysCustomer
     * @param shopId
     * @param page
     * @param rows
     * @param response
     * @param request
     */
    @RequestMapping("/queryChainStoreCustomer")
    public void queryChainStoreCustomer(SysCustomer sysCustomer, int shopId, int page, int rows, HttpServletResponse response, HttpServletRequest request) {
        SysLoginInfo info = this.getLoginInfo(request);
        try {
            Page p = this.customerService.queryChainStoreCustomer(sysCustomer, shopId, page, rows, info.getDatasource());
            JSONObject json = new JSONObject();
            json.put("total", p.getTotal());
            json.put("rows", p.getRows());
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 批量添加连锁店
     *
     * @param ids
     * @param id
     * @param request
     * @param response
     */
    @RequestMapping("/batchUAddChainStoreCustomer")
    public void batchUAddChainStoreCustomer(String ids, Integer id, HttpServletRequest request, HttpServletResponse response) {
        SysLoginInfo info = this.getLoginInfo(request);
        try {
            if (null != id) {
                int i = this.customerService.batchUAddChainStoreCustomer(ids, id, info.getDatasource());
                if (i > 0) {
                    this.sendHtmlResponse(response, "1");
                } else {
                    this.sendHtmlResponse(response, "-1");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            this.log.error("批量添加连锁店出错：");
            this.sendHtmlResponse(response, "-1");
        }

    }


    /**
     * 批量移除
     */
    @RequestMapping("/batchRemoveChainStoreCustomer")
    public void batchRemoveChainStoreCustomer(String ids, HttpServletResponse response, HttpServletRequest request) {
        SysLoginInfo info = this.getLoginInfo(request);
        try {
            int i = this.customerService.batchRemoveChainStoreCustomer(ids, info.getDatasource());
            if (i > 0) {
                this.sendHtmlResponse(response, "1");
            } else {
                this.sendHtmlResponse(response, "-1");
            }
        } catch (Exception e) {
            e.printStackTrace();
            this.log.error("批量删除连锁店出错：");
            this.sendHtmlResponse(response, "-1");
        }
    }


    /**
     * 批量移除
     */
    @RequestMapping("/reverse_geocoding")
    public void reverse() {
        SysLoginInfo info = UserContext.getLoginInfo();
//        String latitude = "24.441989019901825";
//        String longitude = "118.12288899999997";
//        String address = "在厦门轮渡民宿附近";
//        String url = "http://api.map.baidu.com/geocoder/v2/?ak=gIzggYvrqG7zD5MCsFwSjKOkU8yv8SsC&output=json&coordtype=wgs84ll&location="+ latitude +"," + longitude;
//        String url = "http://api.map.baidu.com/geocoder/v2/?address="+address+"&output=json&ak=gIzggYvrqG7zD5MCsFwSjKOkU8yv8SsC";
//        String result = HttpUrlUtils.convertResponse(url);
//        System.out.println(result);
        System.out.println(DateTimeUtil.getDateToStr(new Date()));
//        List<SysCustomer> list = this.customerService.queryCustomerListByHasAddressNoLatLng(info.getDatasource());
//        if (Collections3.isNotEmpty(list)){
//            for (SysCustomer customer: list) {
//                String url = "http://api.map.baidu.com/geocoder/v2/?address="+customer.getAddress()+"&output=json&ak=gIzggYvrqG7zD5MCsFwSjKOkU8yv8SsC";
//                String result = HttpUrlUtils.convertResponse(url);
//                AddressToLatLng addressToLatLng = JSON.parseObject(result, AddressToLatLng.class);
//                if (0 == addressToLatLng.getStatus()){
//                    AddressToLatLng.Result.Location location = addressToLatLng.getResult().getLocation();
//                    customer.setLatitude(location.getLat());
//                    customer.setLongitude(location.getLng());
//                    this.customerService.updateCustomer(customer,info.getDatasource(),null, info);
//                }
//            }
//        }

        List<SysCustomer> list2 = this.customerService.queryCustomerListByHasLatLngNoAddress(info.getDatasource());
        if (Collections3.isNotEmpty(list2)) {
            for (SysCustomer customer : list2) {
                String url = "http://api.map.baidu.com/geocoder/v2/?ak=gIzggYvrqG7zD5MCsFwSjKOkU8yv8SsC&output=json&coordtype=wgs84ll&location="+ customer.getLatitude() +"," + customer.getLongitude();
                String result = HttpUrlUtils.convertResponse(url);
                System.out.println(result);
                LatLngToAddress bean = JSON.parseObject(result, LatLngToAddress.class);
                if (0 == bean.getStatus()) {
                    LatLngToAddress.Result result1 = bean.getResult();
                    String formatAddress = result1.getFormatted_address();
                    LatLngToAddress.Result.AddressComponent addressComponent = result1.getAddressComponent();
                    if (StrUtil.isNull(customer.getAddress())){
                        customer.setAddress(formatAddress);
                    }
                    customer.setProvince(addressComponent.getProvince());
                    customer.setCity(addressComponent.getCity());
                    customer.setArea(addressComponent.getDistrict());
                    this.customerService.updateCustomer(customer, info.getDatasource(), null, info);
                }
            }
        }
        System.out.println(DateTimeUtil.getDateToStr(new Date()));
    }



}



