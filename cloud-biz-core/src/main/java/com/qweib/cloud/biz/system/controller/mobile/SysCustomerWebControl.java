package com.qweib.cloud.biz.system.controller.mobile;


import com.alibaba.fastjson.JSON;
import com.qweib.cloud.biz.common.CnlifeConstants;
import com.qweib.cloud.biz.system.BaseWebService;
import com.qweib.cloud.biz.system.TokenServer;
import com.qweib.cloud.biz.system.UserContext;
import com.qweib.cloud.biz.system.jpush.JpushClassifies;
import com.qweib.cloud.biz.system.jpush.JpushClassifies2;
import com.qweib.cloud.biz.system.service.SysConfigService;
import com.qweib.cloud.biz.system.service.SysCustomerService;
import com.qweib.cloud.biz.system.service.ws.*;
import com.qweib.cloud.core.domain.*;
import com.qweib.cloud.utils.*;
import com.qweib.im.api.dto.User;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.*;

@Controller
@RequestMapping("/web")
public class SysCustomerWebControl extends BaseWebService {
    @Resource
    private SysCustomerWebService customerWebService;
    @Resource
    private SysCustomerService customerService;
    @Resource
    private SysMemberWebService memberWebService;
    @Resource
    private SysBfxsxjWebService bfxsxjWebService;
    @Resource
    private SysChatMsgService chatMsgService;
    @Resource
    private JpushClassifies jpushClassifies;
    @Resource
    private JpushClassifies2 jpushClassifies2;
    @Resource
    private SysConfigService configService;
    @Resource
    private BscPlanxlDetailWebService planxlDetailWebService;

    /**
     * 说明：分页查询客户周边S
     *
     * @创建：作者:llp 创建时间：2016-2-19
     * @修改历史： [序号](llp 2016 - 2 - 19)<修改说明>
     */
    @RequestMapping("queryCustomerWebZb")
    public void queryCustomerWebZb(HttpServletResponse response, String token, Double longitude, Double latitude, Integer pageNo, Integer pageSize,
                                   String khNm, String mids, String pxtp, String regionIds) {
        SysLoginInfo loginInfo = UserContext.getLoginInfo();
        if (pageSize == null) {
            pageSize = 10;
        }
        Page p = this.customerWebService.queryCustomerWebZb(loginInfo, 2, longitude, latitude, pageNo, pageSize, khNm, mids, pxtp, regionIds);
        JSONObject json = new JSONObject();
        json.put("state", true);
        json.put("msg", "获取客户列表成功");
        json.put("pageNo", pageNo);
        json.put("pageSize", pageSize);
        json.put("total", p.getTotal());
        json.put("totalPage", p.getTotalPage());
        json.put("rows", p.getRows());
        this.sendJsonResponse(response, json.toString());
    }

    /**
     * 说明：分页查询我的客户
     *
     * @创建：作者:llp 创建时间：2016-2-19
     * @修改历史： [序号](llp 2016 - 2 - 19)<修改说明>
     */
    @RequestMapping("queryCustomerWeb")
    public void queryCustomerWeb(HttpServletResponse response, String token, Integer pageNo, Integer pageSize, String khNm,
                                 Double longitude, Double latitude, String qdtpNms, String khdjNms, Integer xlId,
                                 @RequestParam(defaultValue = "3") String dataTp, String mids, String pxtp, String regionIds) {
        SysLoginInfo loginInfo = UserContext.getLoginInfo();
        String database = loginInfo.getDatasource();
        Integer memberId = loginInfo.getIdKey();
        if (pageSize == null) {
            pageSize = 10;
        }
        Page p = this.customerWebService.queryCustomerWeb(loginInfo, 2, dataTp, pageNo, pageSize, khNm, longitude, latitude, qdtpNms, khdjNms, xlId, mids, pxtp, regionIds);
        List<SysCustomerWeb> vlist = (List<SysCustomerWeb>) p.getRows();
        for (SysCustomerWeb customerWeb : vlist) {
            SysBfxsxj bfxsxj = this.bfxsxjWebService.queryBfxsxjOneSc(database, memberId, customerWeb.getId());
            if (!StrUtil.isNull(bfxsxj) && !StrUtil.isNull(bfxsxj.getXjdate())) {
                int count = this.bfxsxjWebService.queryBfxsxjByCount(database, memberId, customerWeb.getId(), bfxsxj.getXjdate());
                if (count > 0) {
                    customerWeb.setXxzt("临期");
                } else {
                    customerWeb.setXxzt("正常");
                }
            } else {
                customerWeb.setXxzt("正常");
            }
        }
        JSONObject json = new JSONObject();
        json.put("state", true);
        json.put("msg", "获取下属客户列表成功");
        json.put("pageNo", pageNo);
        json.put("pageSize", pageSize);
        json.put("total", p.getTotal());
        json.put("totalPage", p.getTotalPage());
        json.put("rows", p.getRows());
        this.sendJsonResponse(response, json.toString());
    }

    /**
     * 说明：添加经销商
     *
     * @创建：作者:llp 创建时间：2016-2-19
     * @修改历史： [序号](llp 2016 - 2 - 19)<修改说明>
     */
    @RequestMapping("addCustomerWeb1")
    public void addCustomerWeb1(HttpServletResponse response, String token, String khNm, String jxsflNm, String jxsztNm,
                                String jxsjbNm, String bfpcNm, String fgqy, String linkman, String mobile, String tel, String mobileCx,
                                String province, String city, String area, String address, String longitude, String latitude,
                                String qq, String wxCode, String fman, String ftel, String openDate, String remo) throws Exception {
        SysLoginInfo loginInfo = UserContext.getLoginInfo();
        String database = loginInfo.getDatasource();
        Integer memberId = loginInfo.getIdKey();
        int count = this.customerService.queryIskhNm(database, khNm, city);
        if (count >= 1) {
            sendWarm(response, "该经销商名称已存在");
            return;
        }
        SysMember member = this.memberWebService.queryCompanySysMemberById(database, memberId);
        SysCustomer customer = new SysCustomer();
        customer.setKhNm(khNm);
        customer.setJxsflNm(jxsflNm);
        customer.setJxsztNm(jxsztNm);
        customer.setJxsjbNm(jxsjbNm);
        customer.setBfpcNm(bfpcNm);
        customer.setFgqy(fgqy);
        customer.setLinkman(linkman);
        customer.setMobile(mobile);
        customer.setTel(tel);
        customer.setMobileCx(mobileCx);
        customer.setProvince(province);
        customer.setCity(city);
        customer.setArea(area);
        customer.setAddress(address);
        customer.setLongitude(longitude);
        customer.setLatitude(latitude);
        customer.setQq(qq);
        customer.setWxCode(wxCode);
        customer.setFman(fman);
        customer.setFtel(ftel);
        customer.setOpenDate(openDate);
        customer.setRemo(remo);
        customer.setIsYx("1");
        customer.setIsOpen("1");
        customer.setKhTp(1);
        customer.setMemId(memberId);
        customer.setOrgEmpId(memberId);
        customer.setOrgEmpNm(loginInfo.getUsrNm());
        customer.setBranchId(member.getBranchId());
        customer.setCreateTime(DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd HH:mm:ss"));
        customer.setShZt("待审核");
        this.customerService.addCustomer(customer, database);
        JSONObject json = new JSONObject();
        json.put("state", true);
        json.put("msg", "添加经销商成功");
        this.sendJsonResponse(response, json.toString());

    }

    /**
     * 说明：修改经销商
     *
     * @创建：作者:llp 创建时间：2016-3-10
     * @修改历史： [序号](llp 2016 - 3 - 10)<修改说明>
     */
    @RequestMapping("updateCustomerSj1")
    public void updateCustomerSj1(HttpServletResponse response, String token, Integer id, String khNm, String jxsflNm, String jxsztNm,
                                  String jxsjbNm, String bfpcNm, String fgqy, String linkman, String mobile, String tel, String mobileCx,
                                  String province, String city, String area, String address, String longitude, String latitude,
                                  String qq, String wxCode, String fman, String ftel, String openDate, String remo) {
        SysLoginInfo loginInfo = UserContext.getLoginInfo();
        String database = loginInfo.getDatasource();
        int count = this.customerService.queryIskhNm(database, khNm, city);
        if (count >= 1) {
            SysCustomer customer = this.customerService.queryCustomerById(database, id);
            if (!khNm.equals(customer.getKhNm())) {
                sendWarm(response, "该经销商名称已存在");
                return;
            }
        }
        this.customerWebService.updateCustomerSj1(database, id, khNm, jxsflNm, jxsztNm, jxsjbNm, bfpcNm, fgqy, linkman, mobile, tel, mobileCx, province, city, area, address, longitude, latitude, qq, wxCode, fman, ftel, openDate, remo);
        JSONObject json = new JSONObject();
        json.put("state", true);
        json.put("msg", "修改经销商成功");
        this.sendJsonResponse(response, json.toString());

    }

    /**
     * 说明：添加客户
     *
     * @创建：作者:llp 创建时间：2016-2-19
     * @修改历史： [序号](llp 2016 - 2 - 19)<修改说明>
     */
    @RequestMapping("addCustomerWeb2")
    public void addCustomerWeb2(HttpServletResponse response, String token, String khNm, String linkman, String mobile, String tel,
                                String province, String city, String area, String address, String longitude, String latitude,
                                String qdtpNm, String khdjNm,Integer qdtypeId, Integer khlevelId, String xsjdNm, String bfpcNm,
                                String qq, String wxCode, Integer khPid, String fgqy, String openDate, String remo, String hzfsNm, Integer regionId) throws Exception {
        SysLoginInfo loginInfo = UserContext.getLoginInfo();
        String database = loginInfo.getDatasource();
        int count = this.customerService.queryIskhNm(database, khNm, city);
        if (count >= 1) {
            sendWarm(response, "该客户名称已存在");
            return;
        }
        SysMember member = this.memberWebService.queryCompanySysMemberById(database, loginInfo.getIdKey());
        SysCustomer customer = new SysCustomer();
        customer.setKhNm(khNm);
        customer.setFgqy(fgqy);
        customer.setLinkman(linkman);
        customer.setMobile(mobile);
        customer.setTel(tel);
        customer.setProvince(province);
        customer.setCity(city);
        customer.setArea(area);
        customer.setAddress(address);
        customer.setLongitude(longitude);
        customer.setLatitude(latitude);
        customer.setQdtpNm(qdtpNm);
        customer.setKhdjNm(khdjNm);
        customer.setQdtypeId(qdtypeId);
        customer.setKhlevelId(khlevelId);
        customer.setXsjdNm(xsjdNm);
        customer.setBfpcNm(bfpcNm);
        customer.setQq(qq);
        customer.setWxCode(wxCode);
        customer.setOpenDate(openDate);
        customer.setRemo(remo);
        customer.setIsYx("1");
        customer.setIsOpen("1");
        customer.setKhTp(2);
        customer.setMemId(loginInfo.getIdKey());
        customer.setBranchId(member.getBranchId());
        customer.setOrgEmpId(loginInfo.getIdKey());
        customer.setOrgEmpNm(loginInfo.getUsrNm());
        customer.setCreateTime(DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd HH:mm:ss"));
        customer.setShZt("待审核");
        customer.setHzfsNm(hzfsNm);
        customer.setRegionId(regionId);
        this.customerService.addCustomer(customer, database);
        JSONObject json = new JSONObject();
        json.put("state", true);
        json.put("msg", "添加客户成功");
        this.sendJsonResponse(response, json.toString());

    }

    /**
     * 说明：修改客户
     *
     * @创建：作者:llp 创建时间：2016-3-10
     * @修改历史： [序号](llp 2016 - 3 - 10)<修改说明>
     */
    @RequestMapping("updateCustomerSj2")
    public void updateCustomerSj2(HttpServletResponse response, String token, Integer id, String khNm, String linkman, String mobile, String tel,
                                  String province, String city, String area, String address, String longitude, String latitude,
                                  String qdtpNm, String khdjNm,Integer qdtypeId, Integer khlevelId, String xsjdNm, String bfpcNm,
                                  String qq, String wxCode, Integer khPid, String fgqy, String openDate, String remo, String hzfsNm, Integer regionId) {
        SysLoginInfo loginInfo = UserContext.getLoginInfo();
        String database = loginInfo.getDatasource();
        int count = this.customerService.queryIskhNm(database, khNm, city);
        if (count >= 1) {
            SysCustomer customer = this.customerService.queryCustomerById(database, id);
            if (!khNm.equals(customer.getKhNm())) {
                sendWarm(response, "该客户名称已存在");
                return;
            }
        }
        this.customerWebService.updateCustomerSj2(database, id, khNm, linkman, mobile, tel, province, city, area, address, longitude, latitude, qdtpNm, khdjNm,qdtypeId,khlevelId, xsjdNm, bfpcNm, qq, wxCode, khPid, fgqy, openDate, remo, hzfsNm, regionId);
        JSONObject json = new JSONObject();
        json.put("state", true);
        json.put("msg", "修改客户成功");
        this.sendJsonResponse(response, json.toString());

    }

    /**
     * 说明：获取客户信息
     */
    @RequestMapping("queryCustomerOneWeb")
    public void queryCustomerOneWeb(HttpServletResponse response, String token, Integer Id) {
        SysLoginInfo loginInfo = UserContext.getLoginInfo();
        String database = loginInfo.getDatasource();
        SysCustomer customer = this.customerService.queryCustomerById(database, Id);
        JSONObject json = new JSONObject();

        SysConfig config = this.configService.querySysConfigByCode("CONFIG_SALER_UPDATE_CUSTOMER", database);
        if (config != null && "1".equals(config.getStatus())) {
            if ("审核通过".equals(customer.getShZt())) {
                customer.setShZt("待审核");
            }
        }

        json.put("customer", new JSONObject(customer));
        json.put("state", true);
        json.put("msg", "获取客户信息息成功");
        sendJsonResponse(response, json.toString());

    }

    /**
     * 说明：获取经销商列表
     */
    @RequestMapping("queryCustomerls1")
    public void queryCustomerls1(HttpServletResponse response, String token) {
        SysLoginInfo loginInfo = UserContext.getLoginInfo();
        String database = loginInfo.getDatasource();
        List<SysCustomerWeb> customerls = this.customerWebService.queryCustomerls1(database);
        JSONObject json = new JSONObject();
        json.put("state", true);
        json.put("msg", "获取经销商列表成功");
        json.put("customerls", customerls);
        this.sendJsonResponse(response, json.toString());

    }

    /**
     * 说明：获取客户分布图链接
     */
    @RequestMapping("querycmapwebjk")
    public void querycmapwebjk(HttpServletResponse response, String token, String memIds) {
        SysLoginInfo loginInfo = UserContext.getLoginInfo();
        String database = loginInfo.getDatasource();
        if (StrUtil.isNull(memIds)) {
            memIds = loginInfo.getIdKey().toString();
        }
        JSONObject json = new JSONObject();
        json.put("state", true);
        json.put("msg", "获取客户分布图链接成功");
        json.put("url", StrUtil.weburl + "querycmapweb?datasource=" + database + "&memIds=" + memIds);
        this.sendJsonResponse(response, json.toString());

    }

    /**
     * @说明： 客户地图
     */
    @RequestMapping("/querycmapweb")
    public String querycmap(HttpServletRequest request, Model model, String datasource, String memIds) {
        List<SysCustomer> list = this.customerService.querycustomerWebMap(datasource, memIds);
        StringBuilder markerArr = new StringBuilder("[");
        for (int i = 0; i < list.size(); i++) {
            String jwd = list.get(i).getLongitude() + "&" + list.get(i).getLatitude();
            if (i == list.size() - 1) {
                markerArr.append("[ khNm: " + list.get(i).getKhNm() + ", point: " + jwd + ", address: " + list.get(i).getAddress() + ", tel: " + list.get(i).getTel() + ", linkman: " + list.get(i).getLinkman() + " , mobile: " + list.get(i).getMobile() + " , memberNm: " + list.get(i).getMemberNm() + " , branchName: " + list.get(i).getBranchName() + " , remo: " + list.get(i).getRemo() + ", scbfDate: " + list.get(i).getScbfDate() + "]");
            } else {
                markerArr.append("[ khNm: " + list.get(i).getKhNm() + ", point: " + jwd + ", address: " + list.get(i).getAddress() + ", tel: " + list.get(i).getTel() + ", linkman: " + list.get(i).getLinkman() + " , mobile: " + list.get(i).getMobile() + " , memberNm: " + list.get(i).getMemberNm() + " , branchName: " + list.get(i).getBranchName() + " , remo: " + list.get(i).getRemo() + ", scbfDate: " + list.get(i).getScbfDate() + "],");
            }
        }
        markerArr.append("]");
        model.addAttribute("markerArr", markerArr.toString());
        return "/uglcw/customer/customermapweb2";
    }

    /**
     * 说明：删除客户
     */
    @RequestMapping("deleteCustomerWeb")
    public void deleteCustomerWeb(HttpServletRequest request, HttpServletResponse response, String token, Integer id) {
        SysLoginInfo loginInfo = UserContext.getLoginInfo();
        String database = loginInfo.getDatasource();
        SysCustomer customer = this.customerService.queryCustomerById(database, id);
        if (!loginInfo.getIdKey().equals(customer.getMemId())) {
            this.sendWarm(response, "该客户不是自己的，不能删除");
            return;
        }
        this.customerService.updatekhIsdb(database, 3, id, loginInfo);
        JSONObject json = new JSONObject();
        json.put("state", true);
        json.put("msg", "删除客户成功");
        this.sendJsonResponse(response, json.toString());
    }

    /**
     * 说明：转让客户
     */
    @RequestMapping("zrCustomerWeb")
    public void zrCustomerWeb(HttpServletResponse response, String token, Integer id, Integer mid) throws Exception {
        SysLoginInfo loginInfo = UserContext.getLoginInfo();
        String database = loginInfo.getDatasource();
        Integer memberId = loginInfo.getIdKey();
        SysCustomer customer = this.customerService.queryCustomerById(database, id);
        if (!loginInfo.getIdKey().equals(customer.getMemId())) {
            this.sendWarm(response, "该客户不是自己的，不能转让");
            return;
        }
        SysChatMsg chatMsg2 = this.chatMsgService.getMyMessageByBUid2(memberId, mid, id, database);
        if (!StrUtil.isNull(chatMsg2)) {
            SysChatMsg chatMsg = this.chatMsgService.getMyMessageByBUid(memberId, id, database);
            if (StrUtil.isNull(chatMsg)) {
                this.sendWarm(response, "该客户还在转让中，不能再转让");
                return;
            }
        }
        SysChatMsg scm = new SysChatMsg();
        scm.setAddtime(DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd HH:mm:ss"));
        scm.setMemberId(memberId);
        scm.setReceiveId(mid);
        scm.setBelongId(id);
        scm.setBelongNm("系统消息");
        scm.setBelongMsg("转让客户");
        scm.setTp("41");//转让客户
        scm.setMsg(loginInfo.getUsrNm() + "转让了客户:" + customer.getKhNm() + "给您！");
        chatMsgService.addChatMsg(scm, database);
        //保存起来的
        SysChatMsg scm2 = new SysChatMsg();
        scm2.setAddtime(DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd HH:mm:ss"));
        scm2.setMemberId(memberId);
        scm2.setReceiveId(mid);
        scm2.setBelongId(id);
        scm2.setBelongNm("系统消息");
        scm2.setBelongMsg("转让客户");
        scm2.setTp("41-1");//转让客户
        scm2.setMsg(loginInfo.getUsrNm() + "转让了客户:" + customer.getKhNm() + "给您！");
        chatMsgService.addChatMsg(scm2, database);
        SysMemDTO mem = memberWebService.queryMemByMemId(mid);
        jpushClassifies.toJpush(mem.getMemberMobile(), "转让客户通知", CnlifeConstants.NEWMSG, null, null, "转让客户", null);
        jpushClassifies2.toJpush(mem.getMemberMobile(), "转让客户通知", CnlifeConstants.NEWMSG, null, null, "转让客户", null);
        JSONObject json = new JSONObject();
        json.put("state", true);
        json.put("msg", "转让客户成功");
        this.sendJsonResponse(response, json.toString());
    }

    /**
     * 说明：同不同意转让客户
     */
    @RequestMapping("zrCustomerCzWeb")
    public void zrCustomerCzWeb(HttpServletResponse response, String token, Integer belongId, Integer memberId, Integer tp, Integer msgId) throws Exception {
        SysLoginInfo loginInfo = UserContext.getLoginInfo();
        String database = loginInfo.getDatasource();
        SysCustomer customer = this.customerService.queryCustomerById(database, belongId);
        SysChatMsg scm = new SysChatMsg();
        scm.setAddtime(DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd HH:mm:ss"));
        scm.setMemberId(loginInfo.getIdKey());
        scm.setReceiveId(memberId);
        scm.setBelongId(belongId);
        scm.setBelongNm("系统消息");
        scm.setBelongMsg("转让客户");
        scm.setTp("42");//同不同意转让客户
        scm.setMsgId(msgId);
        if (tp == 1) {
            scm.setMsg(loginInfo.getUsrNm() + "同意了转让客户:" + customer.getKhNm());
            Integer[] s = {belongId};
            this.customerService.updateZryd(database, loginInfo.getIdKey(), s);
        } else {
            scm.setMsg(loginInfo.getUsrNm() + "拒绝了转让客户:" + customer.getKhNm());
        }
        chatMsgService.addChatMsg(scm, database);
        //保存起来的
        SysChatMsg scm2 = new SysChatMsg();
        scm2.setAddtime(DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd HH:mm:ss"));
        scm2.setMemberId(loginInfo.getIdKey());
        scm2.setReceiveId(memberId);
        scm2.setBelongId(belongId);
        scm2.setBelongNm("系统消息");
        scm2.setBelongMsg("转让客户");
        scm2.setTp("42-1");//同不同意转让客户
        scm2.setMsgId(msgId);
        if (tp == 1) {
            scm2.setMsg(loginInfo.getUsrNm() + "同意了转让客户:" + customer.getKhNm());
            Integer[] s = {belongId};
            this.customerService.updateZryd(database, loginInfo.getIdKey(), s);
        } else {
            scm2.setMsg(loginInfo.getUsrNm() + "拒绝了转让客户:" + customer.getKhNm());
        }
        chatMsgService.addChatMsg(scm2, database);
        SysMemDTO mem = memberWebService.queryMemByMemId(memberId);
        jpushClassifies.toJpush(mem.getMemberMobile(), "确认转让客户通知", CnlifeConstants.NEWMSG, null, null, "确认转让客户", null);
        jpushClassifies2.toJpush(mem.getMemberMobile(), "确认转让客户通知", CnlifeConstants.NEWMSG, null, null, "确认转让客户", null);
        JSONObject json = new JSONObject();
        json.put("state", true);
        json.put("msg", "转让客户操作成功");
        this.sendJsonResponse(response, json.toString());
    }

    /**
     * 说明：分页查询供应商
     */
    @ResponseBody
    @RequestMapping("queryProviderPage")
    public Map<String, Object> queryProviderPage(String token, Integer pageNo, Integer pageSize, String proName) {
        SysLoginInfo loginInfo = UserContext.getLoginInfo();
        if (pageNo == null) {
            pageNo = 1;
        }
        if (pageSize == null) {
            pageSize = 10;
        }
        Page p = this.customerWebService.queryProviderPage(proName, pageNo, pageSize, loginInfo.getDatasource());
        Map<String, Object> map = new HashMap<>();
        map.put("state", true);
        map.put("msg", "分页查询供应商成功");
        map.put("list", p.getRows());
        return map;
    }


    /**
     *
     */
    @ResponseBody
    @RequestMapping("queryNearCustomerListByLatLng")
    public Map<String, Object> queryNearCustomerListByLatLng(String customerJson, String dataTp, String customerType){
        SysLoginInfo loginInfo = UserContext.getLoginInfo();

        List<SysCustomer> customerList = JSON.parseArray(customerJson, SysCustomer.class);
        //记录：已添加的客户id
        Map<Integer, Boolean> customerIdMap = new HashMap<>();
        //记录：距离超过1公里的点集合
        List<Location> locationList = new ArrayList<>();

        if(Collections3.isNotEmpty(customerList)){
            Location location = null;
            for (SysCustomer customer: customerList) {
                String latitude = customer.getLatitude();
                String longitude = customer.getLongitude();
                if (StrUtil.isNotNull(latitude) && !latitude.equals("0") &&  !latitude.equals("4.9E-324")){
                    if (location == null){
                        Location location1 = new Location();
                        location1.setLatitude(latitude);
                        location1.setLongitude(longitude);
                        locationList.add(location1);
                        location = location1;
                    }else{
                        Double distance = DistanceUtil.getDistanceFromTwoPoints(Double.valueOf(location.getLatitude()),Double.valueOf(location.getLongitude()), Double.valueOf(latitude), Double.valueOf(longitude));
                        if(distance > 1000){
                            Location location2 = new Location();
                            location2.setLatitude(latitude);
                            location2.setLongitude(longitude);
                            locationList.add(location2);
                            location = location2;
                        }
                    }
                }
                //过滤线路的客户
                customerIdMap.put(customer.getId(), true);
            }
        }

        //
        List<SysCustomer> resultList = new ArrayList<>();
        if (Collections3.isNotEmpty(locationList)){
            for (Location location : locationList) {
                List<SysCustomer> nearCustomerList = this.customerWebService.queryNearCustomerListByLatLng(loginInfo.getDatasource(), loginInfo.getIdKey(), location.getLatitude(), location.getLongitude(),dataTp, customerType);
                if (Collections3.isNotEmpty(nearCustomerList)){
                    for (SysCustomer customer : nearCustomerList) {
                        Boolean flag = customerIdMap.get(customer.getId());
                        if (flag == null || !flag){
                            customerIdMap.put(customer.getId(), true);
                            resultList.add(customer);
                        }
                    }
                }
            }
        }

        return sendSuccess("查询成功", resultList);
    }

    @RequestMapping("queryCustomer2")
    public void queryCustomer2(HttpServletResponse response, HttpServletRequest request, String token, SysCustomer vo,Integer pageNo,Integer pageSize){
        try{
            if(!checkParam(response, token)){
                return;
            }
            OnlineMessage message = TokenServer.tokenCheck(token);
            if(message.isSuccess()==false){
                sendWarm(response, message.getMessage());
                return;
            }
            OnlineUser onlineUser = message.getOnlineMember();
            vo.setDatabase(onlineUser.getDatabase());
            JSONObject json = new JSONObject();
            Page p  = this.customerService.queryCustomer2(vo,pageNo,pageSize);
            json.put("state", true);
            json.put("total", p.getTotal());
            json.put("rows", p.getRows());

            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            e.printStackTrace();
            this.sendWarm(response, "获取客户失败");
        }
    }



    @RequestMapping("queryCustomerPos")
    public void queryCustomerPos(HttpServletResponse response, String token, Integer pageNo, Integer pageSize, SysCustomer customer) {
        SysLoginInfo loginInfo = UserContext.getLoginInfo();
        String database = loginInfo.getDatasource();
        Integer memberId = loginInfo.getIdKey();
        if (pageSize == null) {
            pageSize = 10;
        }
        Page p = this.customerWebService.queryCustomerPageEx(customer,pageNo,pageSize,loginInfo.getDatasource());

        JSONObject json = new JSONObject();
        json.put("state", true);
        json.put("msg", "获取客户列表成功");
        json.put("pageNo", pageNo);
        json.put("pageSize", pageSize);
        json.put("total", p.getTotal());
        json.put("totalPage", p.getTotalPage());
        json.put("rows", p.getRows());
        this.sendJsonResponse(response, json.toString());
    }

}
