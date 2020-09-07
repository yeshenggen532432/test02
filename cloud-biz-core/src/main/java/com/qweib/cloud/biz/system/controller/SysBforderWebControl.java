package com.qweib.cloud.biz.system.controller;


import com.qweib.cloud.biz.system.BaseWebService;
import com.qweib.cloud.biz.system.MobileButtonAuthUtil;
import com.qweib.cloud.biz.system.TokenServer;
import com.qweib.cloud.biz.system.UserContext;
import com.qweib.cloud.biz.system.service.*;
import com.qweib.cloud.biz.system.service.plat.SysCompanyRoleService;
import com.qweib.cloud.biz.system.service.ws.SysBforderWebService;
import com.qweib.cloud.core.domain.*;
import com.qweib.cloud.core.domain.vo.OrderPayType;
import com.qweib.cloud.core.domain.vo.OrderState;
import com.qweib.cloud.core.exception.BizException;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.SpringBeanReflectUtil;
import com.qweib.cloud.utils.StrUtil;
import com.qweibframework.commons.redis.token.TokenCheckTag;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.lang.reflect.Method;
import java.text.SimpleDateFormat;
import java.util.*;

import static com.qweib.cloud.utils.DateTimeUtil.getDateToStr;

@Controller
@RequestMapping("/web")
public class SysBforderWebControl extends BaseWebService {
    @Resource
    private SysBforderWebService bforderWebService;
    @Resource
    private SysBforderService bforderService;
    @Resource
    private SysBforderMsgService orderMsgService;
    @Resource
    private SysWaresService sysWaresService;
    @Resource
    private SysConfigService configService;
    @Resource
    private SysCompanyRoleService sysCompanyRoleService;
    @Resource
    private SysCustomerService sysCustomerService;

    @TokenCheckTag
    @ResponseBody
    @RequestMapping("addBforderWeb")
    public Map<String, Object> addBforderWeb(HttpServletRequest request, String token, Integer cid, String shr,
                                             String tel, String address, String remo, Double zje, Double zdzk, Double cjje, String orderTp, String shTime, String pszd, String orderxx, String date) throws Exception {
        if (StrUtil.isNull(date)) {
            date = new SimpleDateFormat("yyyy-MM-dd").format(new Date());
        }
        OnlineMessage message = TokenServer.tokenCheck(token);
        if (message.isSuccess() == false) {
            throw new BizException(message.getMessage());
        }
        if (StrUtil.isNull(pszd)) {
            throw new BizException("派送指定不能为空");
        } else {
            if (pszd.equals("转二批配送")) {
                if (StrUtil.isNull(remo)) {
                    throw new BizException("派送指定为转二批配送时，备注不能为空!");
                }
            }
        }
        OnlineUser onlineUser = message.getOnlineMember();
        List<SysBforderDetail> detail = new ArrayList<SysBforderDetail>();
        SysBforder bforder = new SysBforder();
        net.sf.json.JSONArray jsonarray = net.sf.json.JSONArray.fromObject(orderxx);
        int len = jsonarray.size();
        Double totalAmt = 0.0;
        if (!StrUtil.isNull(orderxx)) {
            if (len > 0) {
                for (int j = 0; j < len; j++) {
                    net.sf.json.JSONObject json = (net.sf.json.JSONObject) jsonarray.get(j);
                    SysBforderDetail bforderDetail = new SysBforderDetail();
                    bforderDetail.setWareDj(Double.valueOf(json.get("wareDj").toString()));
                    bforderDetail.setWareId(Integer.valueOf(json.get("wareId").toString()));
                    bforderDetail.setWareNum(Double.valueOf(json.get("wareNum").toString()));
                    //bforderDetail.setWareZj(Double.valueOf(json.get("wareZj").toString()));
                    Double zj = 0.0;
                    if (!StrUtil.isNull(json.get("wareDj").toString()) && !StrUtil.isNull(json.get("wareNum").toString())) {
                        zj = Double.valueOf(json.get("wareDj").toString()) * Double.valueOf(json.get("wareNum").toString());
                    }
                    bforderDetail.setWareZj(zj);
                    if (json.containsKey("xsTp")) {
                        bforderDetail.setXsTp(json.get("xsTp").toString());
                        if ("其他".equals(json.get("xsTp").toString())) {
                            bforderDetail.setXsTp("其他销售");
                        }
                    }
                    if (json.containsKey("remark")) {
                        bforderDetail.setRemark(json.get("remark").toString());
                    }
                    if (json.containsKey("wareDw")) {
                        bforderDetail.setWareDw(json.get("wareDw").toString());
                    }
                    if (json.containsKey("wareGg")) {
                        bforderDetail.setWareGg(json.get("wareGg").toString());
                    }
                    if (json.containsKey("hsNum")) {
                        if (!StrUtil.isNull(json.get("hsNum"))) {
                            bforderDetail.setHsNum(Double.valueOf(json.get("hsNum").toString()));
                        }
                    }
                    if (json.containsKey("beUnit")) {
                        bforderDetail.setBeUnit(json.get("beUnit").toString());
                        if (StrUtil.isNull(bforderDetail.getBeUnit())) {
                            SysWare ware = sysWaresService.queryWareById(bforderDetail.getWareId(), onlineUser.getDatabase());
                            if (ware.getWareDw().equals(bforderDetail.getWareDw())) {
                                bforderDetail.setBeUnit("B");
                            } else {
                                bforderDetail.setBeUnit("S");
                            }
                        }
                    }
                    totalAmt = totalAmt + zj;
                    detail.add(bforderDetail);
                }
            }
        }
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyMMdd_HHmmssSSS");
        String orderNo = "T" + dateFormat.format(new Date());
        bforder.setAddress(address);
        bforder.setCid(cid);
        bforder.setCjje(cjje);
        bforder.setMid(onlineUser.getMemId());
        bforder.setOddate(date);
        bforder.setOrderNo(orderNo);
        bforder.setRemo(remo);
        bforder.setShr(shr);
        bforder.setTel(tel);
        if (zdzk == null) zdzk = (double) 0;
        bforder.setZdzk(zdzk);
        //bforder.setZje(zje);
        //Double amt = zje - zdzk;
        bforder.setZje(totalAmt);
        Double amt = totalAmt - zdzk;
        bforder.setCjje(amt);
        bforder.setOrderTp(orderTp);
        bforder.setShTime(shTime);
        try {
            bforder.setOdtime(getDateToStr(new Date(), "HH:mm:ss"));
        } catch (Exception e) {
            e.printStackTrace();
        }
        bforder.setPszd(pszd);
        bforder.setProType(2);
        bforder.setEmpType(1);
        String stkId = request.getParameter("stkId");
        if (!StrUtil.isNull(stkId)) {
            bforder.setStkId(Integer.valueOf(stkId));
        }

        Integer orderId = this.bforderWebService.addBforder(bforder, detail, onlineUser.getDatabase());
        bforder.setId(orderId);
        SysBforderMsg orderMsg = new SysBforderMsg();
        orderMsg.setOrderNo(orderNo);
        orderMsg.setCid(cid);
        orderMsg.setMid(onlineUser.getMemId());
        orderMsg.setMsgtime(getDateToStr(new Date(), "yyyy-MM-dd HH:mm:ss"));
        orderMsg.setIsRead(2);
        this.orderMsgService.addBforderMsg(orderMsg, onlineUser.getDatabase());
        if ("公司直送".equals(bforder.getPszd())) {
            SysConfig config = this.configService.querySysConfigByCode("CONFIG_ORDER_AUTO_CREATE_XSFP", onlineUser.getDatabase());
            if (config != null && "1".equals(config.getStatus())) {
                bforder.setList(detail);
                bforderWebService.saveAutoCreateOrderToSale(onlineUser.getDatabase(), bforder, onlineUser.getMemberNm());
                autoAuditSaleBill(onlineUser, orderId);
            }
        }
        Map<String, Object> map = new HashMap<>();
        map.put("state", true);
        map.put("msg", "添加订单成功");
        return map;
    }

    @TokenCheckTag
    @ResponseBody
    @RequestMapping("updateBforderWeb")
    public Map<String, Object> updateBforderWeb(HttpServletRequest request, String token, Integer id, Integer cid, String shr,
                                                String tel, String address, String remo, Double zje, Double zdzk, Double cjje, String orderTp, String shTime, String pszd, String orderxx) {
        OnlineMessage message = TokenServer.tokenCheck(token);
        if (message.isSuccess() == false) {
            throw new BizException(message.getMessage());
        }
        if (StrUtil.isNull(pszd)) {
            throw new BizException("派送指定不能为空");
        } else {
            if (pszd.equals("转二批配送")) {
                if (StrUtil.isNull(remo)) {
                    throw new BizException("派送指定为转二批配送时，备注不能为空!");
                }
            }
        }
        OnlineUser onlineUser = message.getOnlineMember();
        List<SysBforderDetail> detail = new ArrayList<SysBforderDetail>();
        SysBforder bforder = new SysBforder();
        net.sf.json.JSONArray jsonarray = net.sf.json.JSONArray.fromObject(orderxx);
        Double totalAmt = 0.0;
        int len = jsonarray.size();
        if (len > 0) {
            for (int j = 0; j < len; j++) {
                net.sf.json.JSONObject json = (net.sf.json.JSONObject) jsonarray.get(j);
                SysBforderDetail bforderDetail = new SysBforderDetail();
                bforderDetail.setWareDj(Double.valueOf(json.get("wareDj").toString()));
                bforderDetail.setWareId(Integer.valueOf(json.get("wareId").toString()));
                bforderDetail.setWareNum(Double.valueOf(json.get("wareNum").toString()));
                //bforderDetail.setWareZj(Double.valueOf(json.get("wareZj").toString()));
                Double zj = 0.0;
                if (!StrUtil.isNull(json.get("wareDj").toString()) && !StrUtil.isNull(json.get("wareNum").toString())) {
                    zj = Double.valueOf(json.get("wareDj").toString()) * Double.valueOf(json.get("wareNum").toString());
                }
                bforderDetail.setWareZj(zj);
                if (json.containsKey("xsTp")) {
                    bforderDetail.setXsTp(json.get("xsTp").toString());
                }
                if (json.containsKey("remark")) {
                    bforderDetail.setRemark(json.get("remark").toString());
                }
                if (json.containsKey("wareDw")) {
                    bforderDetail.setWareDw(json.get("wareDw").toString());
                }
                if (json.containsKey("wareGg")) {
                    bforderDetail.setWareGg(json.get("wareGg").toString());
                }
                if (json.containsKey("hsNum")) {
                    if (!StrUtil.isNull(json.get("hsNum"))) {
                        bforderDetail.setHsNum(Double.valueOf(json.get("hsNum").toString()));
                    }
                }
                if (json.containsKey("beUnit")) {
                    bforderDetail.setBeUnit(json.get("beUnit").toString());
                    if (StrUtil.isNull(bforderDetail.getBeUnit())) {
                        SysWare ware = sysWaresService.queryWareById(bforderDetail.getWareId(), onlineUser.getDatabase());
                        if (ware.getWareDw().equals(bforderDetail.getWareDw())) {
                            bforderDetail.setBeUnit("B");
                        } else {
                            bforderDetail.setBeUnit("S");
                        }
                    }
                }
                totalAmt = totalAmt + zj;
                detail.add(bforderDetail);
            }
        }
        SysBforder order1 = this.bforderWebService.queryBforderOne2(onlineUser.getDatabase(), id);
        if (Objects.equals("审核", order1.getOrderZt()) || Objects.equals("已作废", order1.getOrderZt())) {
            throw new BizException("该单据" + order1.getOrderZt() + "，不能进行修改");
        }
        bforder.setId(id);
        bforder.setAddress(address);
        bforder.setCid(order1.getCid());
        bforder.setCjje(cjje);
        bforder.setMid(onlineUser.getMemId());
        bforder.setRemo(remo);
        bforder.setShr(shr);
        bforder.setTel(tel);
        if (zdzk == null) zdzk = (double) 0;
        bforder.setZdzk(zdzk);
        //bforder.setZje(zje);
        //double amt = zje - zdzk;
        double amt = totalAmt - zdzk;
        bforder.setZje(totalAmt);
        bforder.setCjje(amt);
        bforder.setOrderTp(orderTp);
        bforder.setShTime(shTime);
        bforder.setOrderLb("拜访单");
        bforder.setOrderZt("未审核");
        bforder.setPszd(pszd);
        bforder.setProType(2);
        bforder.setEmpType(1);
        String stkId = request.getParameter("stkId");//仓库
        if (!StrUtil.isNull(stkId)) {
            bforder.setStkId(Integer.valueOf(stkId));
        }
        int k = 0;
        if ("公司直送".equals(bforder.getPszd())) {
            SysConfig config = this.configService.querySysConfigByCode("CONFIG_ORDER_AUTO_CREATE_XSFP", onlineUser.getDatabase());
            if (config != null && "1".equals(config.getStatus())) {
                bforder.setList(detail);
                k = bforderWebService.updateAutoCreateOrderToSale(onlineUser.getDatabase(), bforder);
                //autoAuditSaleBill(onlineUser,orderId);
            }
        }
        if (k == -1) {
            throw new BizException("修改订单失败，该订单已不允许修改！");
        } else {
            this.bforderWebService.updateBforder(bforder, detail, onlineUser.getDatabase());
            return sendSuccess("修改订单成功");
        }
    }

    @RequestMapping("queryBforderWeb")
    public void queryBforderWeb(HttpServletResponse response, HttpServletRequest request, String token, Integer cid, String date) {
        try {
            if (!checkParam(response, token, cid)) {
                return;
            }
            if (StrUtil.isNull(date)) {
                date = new SimpleDateFormat("yyyy-MM-dd").format(new Date());
            }
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            OnlineUser onlineUser = message.getOnlineMember();
            SysBforder bforder = this.bforderWebService.queryBforderOne(onlineUser.getDatabase(), onlineUser.getMemId(), cid, date);
            if (StrUtil.isNull(bforder.getStkId())) {
                date = new SimpleDateFormat("yyyy-MM-dd").format(new Date());
            }
            JSONObject json = new JSONObject();
            if (!StrUtil.isNull(bforder)) {
                List<SysBforderDetail> list = this.bforderWebService.queryBforderDetail(onlineUser.getDatabase(), bforder.getId());
                json.put("state", true);
                json.put("msg", "获取订单信息成功");
                json.put("id", bforder.getId());
                json.put("cid", bforder.getCid());
                json.put("shr", bforder.getShr());
                json.put("tel", bforder.getTel());
                json.put("address", bforder.getAddress());
                json.put("remo", bforder.getRemo());
                json.put("zje", bforder.getZje());
                json.put("zdzk", bforder.getZdzk());
                json.put("cjje", bforder.getCjje());
                json.put("shTime", bforder.getShTime());
                json.put("pszd", bforder.getPszd());
                json.put("orderZt", bforder.getOrderZt());
                json.put("stkId", bforder.getStkId());
                json.put("stkName", bforder.getStkName());
                json.put("list", list);
            } else {
                json.put("state", false);
                json.put("msg", "暂无记录");
            }
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            log.error("获取订单信息失败", e);
            e.printStackTrace();
            this.sendWarm(response, "获取订单信息失败");
        }
    }
    //------------------------------------------订货下单-------------------------------------------------------

    /**
     * 获取客户商品历史价格
     */
    @RequestMapping("queryCustomerHisWarePrice")
    public void queryCustomerHisWarePrice(HttpServletResponse response, HttpServletRequest request, String token, Integer cid, Integer wareId) {
        try {
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            OnlineUser onlineUser = message.getOnlineMember();
            SysConfig config = this.configService.querySysConfigByCode("CONFIG_XSFP_AUTO_SET_HIS_PRICE", onlineUser.getDatabase());
            JSONObject json = new JSONObject();
            //0.执行价；1.历史价
            if (config != null && "0".equals(config.getStatus())) {
                json.put("autoPrice", "0");
            } else {
                json.put("autoPrice", "1");
            }
            List<SysBforderDetail> list = new ArrayList<SysBforderDetail>();
            SysWare sysWare = sysWaresService.queryWareById(wareId, onlineUser.getDatabase());
            if (sysWare != null) {
                SysLoginInfo info = new SysLoginInfo();
                info.setDatasource(onlineUser.getDatabase());
                sysCustomerService.loadCustomerPrice(sysWare, info, cid + "");
                json.put("state", true);
                json.put("msg", "获取信息成功");
                SysBforderDetail od = new SysBforderDetail();
                od.setOrgPrice(sysWare.getWareDj());
                od.setWareDj(sysWare.getMaxHisPfPrice());
                od.setMinHisPrice(sysWare.getMinHisPfPrice());
                list = new ArrayList<>();
                list.add(od);
                json.put("list", list);
            } else {
                json.put("state", false);
                json.put("msg", "暂无记录");
            }
//            List<SysBforderDetail> list = this.bforderWebService.queryCustomerHisWarePrice(onlineUser.getDatabase(), cid, wareId);
//            if (list != null && list.size() > 0) {
//                SysBforderDetail od = list.get(0);
//                String beUnit = od.getBeUnit();
//                if ("S".equals(beUnit)) {
//                    SysWare sysWare = sysWaresService.queryWareById(wareId, onlineUser.getDatabase());
//                    Double hsNum = 1d;
//                    if (!StrUtil.isNull(sysWare.getHsNum())) {
//                        hsNum = sysWare.getHsNum();
//                    }
//                    Double price = 0.0;
//                    if (!StrUtil.isNull(od.getWareDj())) {
//                        price = od.getWareDj();
//                    }
//                    price = price * hsNum;
//                    od.setWareDj(price);
//                }
//                json.put("state", true);
//                json.put("msg", "获取信息成功");
//                json.put("list", list);
//            } else {
//                SysWare sysWare = sysWaresService.queryWareById(wareId, onlineUser.getDatabase());
//                if (sysWare != null) {
//                    json.put("state", true);
//                    json.put("msg", "获取信息成功");
//                    SysBforderDetail od = new SysBforderDetail();
//                    od.setOrgPrice(sysWare.getWareDj());
//                    od.setWareDj(null);
//                    list = new ArrayList<>();
//                    list.add(od);
//                    json.put("list", list);
//                } else {
//                    json.put("state", false);
//                    json.put("msg", "暂无记录");
//                }
//            }
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            log.error("获取客户商品历史价格失败", e);
            e.printStackTrace();
            this.sendWarm(response, "获取客户商品历史价格失败");
        }
    }


    @RequestMapping("queryDhorder")
    public void queryDhorder(HttpServletRequest request, HttpServletResponse response, String token, Integer pageNo, Integer pageSize,
                             String kmNm, String sdate, String edate, @RequestParam(defaultValue = "3") String dataTp, String mids) {
        try {
            if (!checkParam(response, token))
                return;
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            if (pageSize == null) {
                pageSize = 10;
            }
            OnlineUser onlineUser = message.getOnlineMember();
            if (!StrUtil.isNull(mids)) {
                mids = mids + "," + onlineUser.getMemId();
            }
            String customerId = request.getParameter("customerId");

            SysBforder order = new SysBforder();
            order.setKhNm(kmNm);
            order.setSdate(sdate);
            order.setEdate(edate);
            order.setMids(mids);
            if (!StrUtil.isNull(customerId)) {
                order.setCustomerId(Integer.valueOf(customerId));
            }

            String orderZt = request.getParameter("orderZt");
            String orderNo = request.getParameter("orderNo");
            String orderTpFlag = request.getParameter("orderTpFlag");
            if (!StrUtil.isNull(orderZt)) {
                order.setOrderZt(orderZt);
            }
            if (!StrUtil.isNull(orderNo)) {
                order.setOrderNo(orderNo);
            }
            if (!StrUtil.isNull(orderTpFlag)) {
                order.setOrderTp("客户下单");
            }

            Page p = this.bforderWebService.queryDhorder(onlineUser, dataTp, pageNo, pageSize, order);
            List<SysBforder> vlist = (List<SysBforder>) p.getRows();
            for (SysBforder bforder : vlist) {
                bforder.setDdNum(this.bforderWebService.queryOrderDetailCount(onlineUser.getDatabase(), bforder.getId()));
                if (bforder.getMid().equals(onlineUser.getMemId())) {
                    bforder.setIsMe(1);
                } else {
                    bforder.setIsMe(2);
                }
            }
            Map<String, Object> rtnMap = new HashMap<String, Object>();
            String btnCode = "erp.saleorder.btn.audit";//审批权限
            Boolean bool = MobileButtonAuthUtil.checkUserButtonPdm(btnCode, sysCompanyRoleService, onlineUser);
            rtnMap.put(btnCode, bool);

            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "获取订货下单列表成功");
            json.put("pageNo", pageNo);
            json.put("pageSize", pageSize);
            json.put("total", p.getTotal());
            json.put("totalPage", p.getTotalPage());
            json.put("rows", p.getRows());
            json.put("rtnMap", rtnMap);
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            log.error("获取订货下单列表失败", e);
            e.printStackTrace();
            this.sendWarm(response, "获取订货下单列表失败");
        }
    }


    @RequestMapping("/auditOrder")
    public void auditOrder(HttpServletResponse response, HttpServletRequest request, String token, Integer id) {
        JSONObject json = new JSONObject();
        try {
            if (!checkParam(response, token))
                return;
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            OnlineUser onlineUser = message.getOnlineMember();
            this.bforderService.updateOrderSh(onlineUser.getDatabase(), id, "审核");
            SysBforder order = this.bforderService.queryBforderByid(onlineUser.getDatabase(), id);
            this.orderMsgService.updateBforderMsgisRead2(onlineUser.getDatabase(), order.getOrderNo());

            SysConfig config = this.configService.querySysConfigByCode("CONFIG_SHOP_ORDER_TO_SALE", onlineUser.getDatabase());
            if (config != null && "1".equals(config.getStatus()) && "客户下单".equals(order.getOrderTp())) {
                List<SysBforderDetail> detail = this.bforderService.queryBforderDetail(onlineUser.getDatabase(), id);
                order.setList(detail);
                try {
                    bforderWebService.saveAutoCreateOrderToSale(onlineUser.getDatabase(), order, onlineUser.getMemberNm());
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
            //如果是商城线下支付订单审核时修改订单状态
            if ("客户下单".equals(order.getOrderTp()) && order.getPayType() == OrderPayType.offline.getCode().intValue()) {
                bforderService.updateShopBforderState(id, OrderState.sendWait, onlineUser.getDatabase());
            }

            json.put("state", true);
            json.put("msg", "审核成功");
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            log.error("修改订单审核出错：", e);
            json.put("state", false);
            json.put("msg", "审核失败");
            this.sendJsonResponse(response, json.toString());
        }
    }

    @TokenCheckTag
    @ResponseBody
    @RequestMapping("addDhorderWeb")
    public Map<String, Object> addDhorderWeb(HttpServletRequest request, String token, Integer cid, String shr,
                                             String tel, String address, String remo, Double zje, Double zdzk, Double cjje, String orderTp, String shTime, String pszd, String orderxx) throws Exception {
        OnlineMessage message = TokenServer.tokenCheck(token);
        if (message.isSuccess() == false) {
            throw new BizException(message.getMessage());
        }
        if (StrUtil.isNull(pszd)) {
            throw new BizException("派送指定不能为空");
        } else {
            if (pszd.equals("转二批配送")) {
                if (StrUtil.isNull(remo)) {
                    throw new BizException("派送指定为转二批配送时，备注不能为空!");
                }
            }
        }
        OnlineUser onlineUser = message.getOnlineMember();
        List<SysBforderDetail> detail = new ArrayList<SysBforderDetail>();
        SysBforder bforder = new SysBforder();
        net.sf.json.JSONArray jsonarray = net.sf.json.JSONArray.fromObject(orderxx);
        int len = jsonarray.size();
        Double totalAmt = 0.0;
        if (!StrUtil.isNull(orderxx)) {
            if (len > 0) {
                for (int j = 0; j < len; j++) {
                    net.sf.json.JSONObject json = (net.sf.json.JSONObject) jsonarray.get(j);
                    SysBforderDetail bforderDetail = new SysBforderDetail();
                    bforderDetail.setWareDj(Double.valueOf(json.get("wareDj").toString()));
                    bforderDetail.setWareId(Integer.valueOf(json.get("wareId").toString()));
                    bforderDetail.setWareNum(Double.valueOf(json.get("wareNum").toString()));
                    //bforderDetail.setWareZj(Double.valueOf(json.get("wareZj").toString()));
                    Double zj = 0.0;
                    if (!StrUtil.isNull(json.get("wareDj").toString()) && !StrUtil.isNull(json.get("wareNum").toString())) {
                        zj = Double.valueOf(json.get("wareDj").toString()) * Double.valueOf(json.get("wareNum").toString());
                    }
                    bforderDetail.setWareZj(zj);
                    if (json.containsKey("xsTp")) {
                        bforderDetail.setXsTp(json.get("xsTp").toString());
                    }
                    if ("其他".equals(json.get("xsTp").toString())) {
                        bforderDetail.setXsTp("其他销售");
                    }
                    if (json.containsKey("wareDw")) {
                        bforderDetail.setWareDw(json.get("wareDw").toString());
                    }
                    if (json.containsKey("wareGg")) {
                        bforderDetail.setWareGg(json.get("wareGg").toString());
                    }
                    if (json.containsKey("hsNum")) {
                        if (StrUtil.isNull(json.get("hsNum"))) {
                            bforderDetail.setHsNum(Double.valueOf(json.get("hsNum").toString()));
                        }
                    }
                    if (json.containsKey("beUnit")) {
                        bforderDetail.setBeUnit(json.get("beUnit").toString());
                    }
                    if (json.containsKey("remark")) {
                        bforderDetail.setRemark(json.get("remark").toString());
                    }
                    totalAmt = totalAmt + zj;
                    detail.add(bforderDetail);
                }
            }
        }
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyMMdd_HHmmssSSS");
        String orderNo = "T" + dateFormat.format(new Date());
        bforder.setAddress(address);
        bforder.setCid(cid);
        bforder.setCjje(cjje);
        bforder.setMid(onlineUser.getMemId());
        bforder.setOddate(getDateToStr(new Date(), "yyyy-MM-dd"));
        bforder.setOrderNo(orderNo);
        bforder.setRemo(remo);
        bforder.setShr(shr);
        bforder.setTel(tel);
        if (zdzk == null) zdzk = (double) 0;
        bforder.setZdzk(zdzk);
        //bforder.setZje(zje);
        //double amt = zje - zdzk;
        double amt = totalAmt - zdzk;
        bforder.setZje(totalAmt);
        bforder.setCjje(amt);
        bforder.setOrderTp(orderTp);
        bforder.setShTime(shTime);
        bforder.setOdtime(getDateToStr(new Date(), "HH:mm:ss"));
        bforder.setPszd(pszd);
        bforder.setOrderLb("电话单");
        String stkId = request.getParameter("stkId");
        if (!StrUtil.isNull(stkId)) {
            bforder.setStkId(Integer.valueOf(stkId));
        }
        bforder.setProType(2);
        bforder.setEmpType(1);
        Integer orderId = this.bforderWebService.addBforder(bforder, detail, onlineUser.getDatabase());
        bforder.setId(orderId);
        SysBforderMsg orderMsg = new SysBforderMsg();
        orderMsg.setOrderNo(orderNo);

        orderMsg.setCid(cid);
        orderMsg.setMid(onlineUser.getMemId());
        orderMsg.setMsgtime(getDateToStr(new Date(), "yyyy-MM-dd HH:mm:ss"));
        orderMsg.setIsRead(2);
        this.orderMsgService.addBforderMsg(orderMsg, onlineUser.getDatabase());
        if ("公司直送".equals(bforder.getPszd())) {
            try {
                SysConfig config = this.configService.querySysConfigByCode("CONFIG_ORDER_AUTO_CREATE_XSFP", onlineUser.getDatabase());
                if (config != null && "1".equals(config.getStatus())) {
                    bforder.setList(detail);
                    bforderWebService.saveAutoCreateOrderToSale(onlineUser.getDatabase(), bforder, onlineUser.getMemberNm());
                    autoAuditSaleBill(onlineUser, orderId);
                }
            } catch (Exception ex) {

            }
        }
        return sendSuccess("添加订单成功");
    }

    @RequestMapping("queryDhorderWeb")
    public void queryDhorderWeb(HttpServletResponse response, HttpServletRequest request, String token, Integer id) {
        try {
            if (!checkParam(response, token, id)) {
                return;
            }
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            OnlineUser onlineUser = message.getOnlineMember();
            SysBforder bforder = this.bforderWebService.queryBforderOne2(onlineUser.getDatabase(), id);
            JSONObject json = new JSONObject();
            if (!StrUtil.isNull(bforder)) {
                List<SysBforderDetail> list = this.bforderWebService.queryBforderDetail(onlineUser.getDatabase(), bforder.getId());
                json.put("state", true);
                json.put("msg", "获取订单信息成功");
                json.put("id", bforder.getId());
                json.put("khNm", bforder.getKhNm());
                json.put("cid", bforder.getCid());
                json.put("shr", bforder.getShr());
                json.put("tel", bforder.getTel());
                json.put("address", bforder.getAddress());
                json.put("remo", bforder.getRemo());
                json.put("zje", bforder.getZje());
                json.put("zdzk", bforder.getZdzk());
                json.put("cjje", bforder.getCjje());
                json.put("shTime", bforder.getShTime());
                json.put("pszd", bforder.getPszd());
                json.put("orderZt", bforder.getOrderZt());
                json.put("stkId", bforder.getStkId());
                json.put("stkName", bforder.getStkName());
                json.put("list", list);
            } else {
                json.put("state", false);
                json.put("msg", "暂无记录");
            }
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            log.error("获取订单信息失败", e);
            e.printStackTrace();
            this.sendWarm(response, "获取订单信息失败");
        }
    }

    @TokenCheckTag
    @ResponseBody
    @RequestMapping("updateDhorderWeb")
    public Map<String, Object> updateDhorderWeb(HttpServletRequest request, String token, Integer id, Integer cid, String shr,
                                                String tel, String address, String remo, Double zje, Double zdzk, Double cjje, String orderTp, String shTime, String pszd, String orderxx) {
        OnlineMessage message = TokenServer.tokenCheck(token);
        if (message.isSuccess() == false) {
            throw new BizException(message.getMessage());
        }
        if (StrUtil.isNull(pszd)) {
            throw new BizException("派送指定不能为空");
        } else {
            if (pszd.equals("转二批配送")) {
                if (StrUtil.isNull(remo)) {
                    throw new BizException("派送指定为转二批配送时，备注不能为空!");
                }
            }
        }
        OnlineUser onlineUser = message.getOnlineMember();
        SysBforder bforder2 = this.bforderWebService.queryBforderOne2(onlineUser.getDatabase(), id);
        List<SysBforderDetail> detail = new ArrayList<SysBforderDetail>();
        SysBforder bforder = new SysBforder();
        net.sf.json.JSONArray jsonarray = net.sf.json.JSONArray.fromObject(orderxx);
        int len = jsonarray.size();
        Double totalAmt = 0.0;
        if (len > 0) {
            for (int j = 0; j < len; j++) {
                net.sf.json.JSONObject json = (net.sf.json.JSONObject) jsonarray.get(j);
                SysBforderDetail bforderDetail = new SysBforderDetail();
                bforderDetail.setWareDj(Double.valueOf(json.get("wareDj").toString()));
                bforderDetail.setWareId(Integer.valueOf(json.get("wareId").toString()));
                bforderDetail.setWareNum(Double.valueOf(json.get("wareNum").toString()));
                Double zj = 0.0;
                if (!StrUtil.isNull(json.get("wareDj").toString()) && !StrUtil.isNull(json.get("wareNum").toString())) {
                    zj = Double.valueOf(json.get("wareDj").toString()) * Double.valueOf(json.get("wareNum").toString());
                }
                bforderDetail.setWareZj(zj);
                if (json.containsKey("xsTp")) {
                    bforderDetail.setXsTp(json.get("xsTp").toString());
                }
                if (json.containsKey("wareDw")) {
                    bforderDetail.setWareDw(json.get("wareDw").toString());
                }
                if (json.containsKey("wareGg")) {
                    bforderDetail.setWareGg(json.get("wareGg").toString());
                }
                if (json.containsKey("hsNum")) {
                    if (!StrUtil.isNull(json.get("hsNum"))) {
                        bforderDetail.setHsNum(Double.valueOf(json.get("hsNum").toString()));
                    }
                }
                if (json.containsKey("beUnit")) {
                    bforderDetail.setBeUnit(json.get("beUnit").toString());
                }
                if (json.containsKey("remark")) {
                    bforderDetail.setRemark(json.get("remark").toString());
                }
                totalAmt = totalAmt + zj;
                detail.add(bforderDetail);
            }
        }
        SysBforder order1 = this.bforderWebService.queryBforderOne2(onlineUser.getDatabase(), id);
        if (Objects.equals("审核", order1.getOrderZt()) || Objects.equals("已作废", order1.getOrderZt())) {
            throw new BizException("该单据" + order1.getOrderZt() + "，不能进行修改");
        }
        bforder.setId(id);
        bforder.setAddress(address);
        bforder.setCid(order1.getCid());
        bforder.setCjje(cjje);
        bforder.setMid(onlineUser.getMemId());
        bforder.setRemo(remo);
        bforder.setShr(shr);
        bforder.setTel(tel);
        if (zdzk == null) zdzk = (double) 0;
        bforder.setZdzk(zdzk);
        //bforder.setZje(zje);
        //double amt = zje - zdzk;
        double amt = totalAmt - zdzk;
        bforder.setZje(totalAmt);
        bforder.setCjje(amt);
        bforder.setOrderTp(orderTp);
        bforder.setShTime(shTime);
        bforder.setOrderLb(bforder2.getOrderLb());
        bforder.setOrderZt("未审核");
        bforder.setPszd(pszd);
        bforder.setProType(2);
        bforder.setEmpType(1);
        String stkId = request.getParameter("stkId");//仓库
        if (!StrUtil.isNull(stkId)) {
            bforder.setStkId(Integer.valueOf(stkId));
        }
        int k = 0;
        if ("公司直送".equals(bforder.getPszd())) {
            SysConfig config = this.configService.querySysConfigByCode("CONFIG_ORDER_AUTO_CREATE_XSFP", onlineUser.getDatabase());
            if (config != null && "1".equals(config.getStatus())) {
                bforder.setList(detail);
                k = bforderWebService.updateAutoCreateOrderToSale(onlineUser.getDatabase(), bforder);
                //autoAuditSaleBill(onlineUser,bforder.getId());
            }
        }
        if (k == -1) {
            throw new BizException("修改订单失败，该订单已不允许修改！");
        } else {
            this.bforderWebService.updateBforder(bforder, detail, onlineUser.getDatabase());
            return sendSuccess("修改订单成功");
        }
    }

    //============================车销单：开始===================================

    /**
     * 说明：车销单：添加
     */
    @TokenCheckTag
    @ResponseBody
    @RequestMapping("addCarOorderWeb")
    public Map<String, Object> addCarOorderWeb(HttpServletRequest request, String token, Integer cid, String shr,
                                               String tel, String address, String remo, Double zje, Double zdzk, Double cjje, String orderTp, String shTime, String pszd, String orderxx) throws Exception {
        OnlineMessage message = TokenServer.tokenCheck(token);
        if (message.isSuccess() == false) {
            throw new BizException(message.getMessage());
        }
        OnlineUser onlineUser = message.getOnlineMember();

        List<SysBforderDetail> detail = new ArrayList<SysBforderDetail>();
        SysBforder bforder = new SysBforder();
        net.sf.json.JSONArray jsonarray = net.sf.json.JSONArray.fromObject(orderxx);
        int len = jsonarray.size();
        if (!StrUtil.isNull(orderxx)) {
            if (len > 0) {
                for (int j = 0; j < len; j++) {
                    net.sf.json.JSONObject json = (net.sf.json.JSONObject) jsonarray.get(j);
                    SysBforderDetail bforderDetail = new SysBforderDetail();
                    bforderDetail.setWareDj(Double.valueOf(json.get("wareDj").toString()));
                    bforderDetail.setWareId(Integer.valueOf(json.get("wareId").toString()));
                    bforderDetail.setWareNum(Double.valueOf(json.get("wareNum").toString()));
                    bforderDetail.setWareZj(Double.valueOf(json.get("wareZj").toString()));
                    if (json.containsKey("xsTp")) {
                        bforderDetail.setXsTp(json.get("xsTp").toString());
                        if ("其他".equals(json.get("xsTp").toString())) {
                            bforderDetail.setXsTp("其他销售");
                        }
                    }
                    if (json.containsKey("wareDw")) {
                        bforderDetail.setWareDw(json.get("wareDw").toString());
                    }
                    if (json.containsKey("wareGg")) {
                        bforderDetail.setWareGg(json.get("wareGg").toString());
                    }
                    if (json.containsKey("hsNum")) {
                        if (StrUtil.isNull(json.get("hsNum"))) {
                            bforderDetail.setHsNum(Double.valueOf(json.get("hsNum").toString()));
                        }
                    }
                    if (json.containsKey("beUnit")) {
                        bforderDetail.setBeUnit(json.get("beUnit").toString());
                    }
                    if (json.containsKey("remark")) {
                        bforderDetail.setRemark(json.get("remark").toString());
                    }
                    detail.add(bforderDetail);
                }
            }
        }
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyMMdd_HHmmssSSS");
        String orderNo = "T" + dateFormat.format(new Date());
        bforder.setAddress(address);
        bforder.setCid(cid);
        bforder.setCjje(cjje);
        bforder.setMid(onlineUser.getMemId());
        bforder.setOddate(getDateToStr(new Date(), "yyyy-MM-dd"));
        bforder.setOrderNo(orderNo);
        bforder.setRemo(remo);
        bforder.setShr(shr);
        bforder.setTel(tel);
        if (zdzk == null) zdzk = (double) 0;
        bforder.setZdzk(zdzk);
        bforder.setZje(zje);
        double amt = zje - zdzk;
        bforder.setCjje(amt);
        bforder.setOrderTp(orderTp);
        bforder.setShTime(shTime);
        bforder.setProType(2);
        bforder.setEmpType(1);
        bforder.setOdtime(getDateToStr(new Date(), "HH:mm:ss"));
        bforder.setPszd("公司直送");
        bforder.setOrderLb("车销单");
        String stkId = request.getParameter("stkId");
        if (!StrUtil.isNull(stkId)) {
            bforder.setStkId(Integer.valueOf(stkId));
        }
        Integer orderId = this.bforderWebService.addBforder(bforder, detail, onlineUser.getDatabase());
        bforder.setId(orderId);
        SysBforderMsg orderMsg = new SysBforderMsg();
        orderMsg.setOrderNo(orderNo);
        orderMsg.setCid(cid);
        orderMsg.setMid(onlineUser.getMemId());
        orderMsg.setMsgtime(getDateToStr(new Date(), "yyyy-MM-dd HH:mm:ss"));
        orderMsg.setIsRead(2);
        this.orderMsgService.addBforderMsg(orderMsg, onlineUser.getDatabase());
        if ("公司直送".equals(bforder.getPszd())) {
            SysConfig config = this.configService.querySysConfigByCode("CONFIG_ORDER_AUTO_CREATE_XSFP", onlineUser.getDatabase());
            if (config != null && "1".equals(config.getStatus())) {
                bforder.setList(detail);
                bforderWebService.saveAutoCreateOrderToSale(onlineUser.getDatabase(), bforder, onlineUser.getMemberNm());
                //autoAuditSaleBill(onlineUser,orderId);
            }
        }
        return sendSuccess("添加车销订单成功");
    }


    /**
     * 说明：分页查询车销单
     */
    @RequestMapping("queryCarOrder")
    public void queryCarOrder(HttpServletRequest request, HttpServletResponse response, String token, Integer pageNo, Integer pageSize,
                              String kmNm, String sdate, String edate, @RequestParam(defaultValue = "3") String dataTp, String mids) {
        try {
            if (!checkParam(response, token))
                return;
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            if (pageSize == null) {
                pageSize = 10;
            }
            OnlineUser onlineUser = message.getOnlineMember();
            if (!StrUtil.isNull(mids)) {
                mids = mids + "," + onlineUser.getMemId();
            }
            String stkId = request.getParameter("stkId");
            String customerId = request.getParameter("customerId");
            Page p = null;
            if (StrUtil.isNull(stkId)) {
                p = this.bforderWebService.queryCarOrder(onlineUser, dataTp, pageNo, pageSize, kmNm, sdate, edate, mids, customerId, 0);
            } else {
                p = this.bforderWebService.queryCarOrder(onlineUser, dataTp, pageNo, pageSize, kmNm, sdate, edate, mids, customerId, Integer.valueOf(stkId));
            }
            //查询是否是我的单子
            List<SysBforder> vlist = (List<SysBforder>) p.getRows();
            for (SysBforder bforder : vlist) {
                bforder.setDdNum(this.bforderWebService.queryOrderDetailCount(onlineUser.getDatabase(), bforder.getId()));
                if (bforder.getMid().equals(onlineUser.getMemId())) {
                    bforder.setIsMe(1);
                } else {
                    bforder.setIsMe(2);
                }
            }

            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "获取车销单列表成功");
            json.put("pageNo", pageNo);
            json.put("pageSize", pageSize);
            json.put("total", p.getTotal());
            json.put("totalPage", p.getTotalPage());
            json.put("rows", p.getRows());
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            log.error("获取车销单列表失败", e);
            e.printStackTrace();
            this.sendWarm(response, "获取车销单列表失败");
        }
    }


    /**
     * 说明：修改车销单
     */
    @TokenCheckTag
    @ResponseBody
    @RequestMapping("updateCarOrderWeb")
    public Map<String, Object> updateCarOrderWeb(HttpServletRequest request, String token, Integer id, Integer cid, String shr,
                                                 String tel, String address, String remo, Double zje, Double zdzk, Double cjje, String orderTp, String shTime, String pszd, String orderxx) {
        OnlineMessage message = TokenServer.tokenCheck(token);
        if (message.isSuccess() == false) {
            throw new BizException(message.getMessage());
        }
        OnlineUser onlineUser = message.getOnlineMember();

        SysBforder bforder2 = this.bforderWebService.queryBforderOne2(onlineUser.getDatabase(), id);
        if (Objects.equals("审核", bforder2.getOrderZt()) || Objects.equals("审批", bforder2.getOrderZt()) || Objects.equals("已作废", bforder2.getOrderZt())) {
            throw new BizException("该单据" + bforder2.getOrderZt() + "，不能进行修改");
        }
        List<SysBforderDetail> detail = new ArrayList<SysBforderDetail>();
        SysBforder bforder = new SysBforder();
        net.sf.json.JSONArray jsonarray = net.sf.json.JSONArray.fromObject(orderxx);
        int len = jsonarray.size();
        if (len > 0) {
            for (int j = 0; j < len; j++) {
                net.sf.json.JSONObject json = (net.sf.json.JSONObject) jsonarray.get(j);
                SysBforderDetail bforderDetail = new SysBforderDetail();
                bforderDetail.setWareDj(Double.valueOf(json.get("wareDj").toString()));
                bforderDetail.setWareId(Integer.valueOf(json.get("wareId").toString()));
                bforderDetail.setWareNum(Double.valueOf(json.get("wareNum").toString()));
                bforderDetail.setWareZj(Double.valueOf(json.get("wareZj").toString()));
                if (json.containsKey("xsTp")) {
                    bforderDetail.setXsTp(json.get("xsTp").toString());
                }
                if (json.containsKey("wareDw")) {
                    bforderDetail.setWareDw(json.get("wareDw").toString());
                }
                if (json.containsKey("wareGg")) {
                    bforderDetail.setWareGg(json.get("wareGg").toString());
                }
                if (json.containsKey("hsNum")) {
                    if (!StrUtil.isNull(json.get("hsNum"))) {
                        bforderDetail.setHsNum(Double.valueOf(json.get("hsNum").toString()));
                    }
                }
                if (json.containsKey("beUnit")) {
                    bforderDetail.setBeUnit(json.get("beUnit").toString());
                    if (StrUtil.isNull(bforderDetail.getBeUnit())) {
                        SysWare ware = sysWaresService.queryWareById(bforderDetail.getWareId(), onlineUser.getDatabase());
                        if (ware.getWareDw().equals(bforderDetail.getWareDw())) {
                            bforderDetail.setBeUnit("B");
                        } else {
                            bforderDetail.setBeUnit("S");
                        }
                    }
                }
                if (json.containsKey("remark")) {
                    bforderDetail.setRemark(json.get("remark").toString());
                }
                detail.add(bforderDetail);
            }
        }

        bforder.setId(id);
        bforder.setAddress(address);
        bforder.setCid(bforder2.getCid());
        bforder.setCjje(cjje);
        bforder.setMid(onlineUser.getMemId());
        bforder.setRemo(remo);
        bforder.setShr(shr);
        bforder.setTel(tel);
        if (zdzk == null) zdzk = (double) 0;
        bforder.setZdzk(zdzk);
        bforder.setZje(zje);
        double amt = zje - zdzk;
        bforder.setCjje(amt);
        bforder.setOrderTp(orderTp);
        bforder.setShTime(shTime);
        bforder.setOrderLb(bforder2.getOrderLb());
        bforder.setProType(2);
        bforder.setEmpType(1);
        bforder.setOrderZt("未审核");
        bforder.setPszd("公司直送");
        String stkId = request.getParameter("stkId");//仓库
        if (!StrUtil.isNull(stkId)) {
            bforder.setStkId(Integer.valueOf(stkId));
        }
        int k = 0;
        if ("公司直送".equals(bforder.getPszd())) {
            SysConfig config = this.configService.querySysConfigByCode("CONFIG_ORDER_AUTO_CREATE_XSFP", onlineUser.getDatabase());
            if (config != null && "1".equals(config.getStatus())) {
                bforder.setList(detail);
                k = bforderWebService.updateAutoCreateOrderToSale(onlineUser.getDatabase(), bforder);
                //autoAuditSaleBill(onlineUser,orderId);
            }
        }
        if (k == -1) {
            throw new BizException("修改订单失败，该订单已不允许修改！");
        } else {
            this.bforderWebService.updateBforder(bforder, detail, onlineUser.getDatabase());
            return sendSuccess("修改车销单成功");
        }
    }

    private void autoAuditSaleBill(OnlineUser onlineUser, Integer orderId) {
        try {
            SysLoginInfo info = new SysLoginInfo();
            info.setDatasource(onlineUser.getDatabase());
            info.setUsrNm(onlineUser.getMemberNm());
            info.setIdKey(onlineUser.getMemId());
            SpringBeanReflectUtil.springInvokeMethod("stkOutService", "auditSaleBill", new Object[]{orderId, info});
//
//        Class<?> clz = Class.forName("com.qweib.cloud.biz.erp.service.StkOutService");
//        Object o = clz.newInstance();
//        Method m = clz.getDeclaredMethod("auditSaleBill", Integer.class,SysLoginInfo.class);
//
//        m.invoke(o,orderId,info);
        } catch (Exception ex) {

        }
    }


    /**
     * 获取手机端下单配置（拜访下单，订货下单）
     * 1.是历史价还是执行价
     * 2.价格是否可以编辑
     */
    @ResponseBody
    @RequestMapping("queryOrderConfigWeb")
    public Map<String, Object> queryOrderConfigWeb() {
        SysLoginInfo loginInfo = UserContext.getLoginInfo();
        SysConfig config = this.configService.querySysConfigByCode("CONFIG_XSFP_AUTO_SET_HIS_PRICE", loginInfo.getDatasource());
        String autoPrice = "1";//0.执行价；1.历史价
        if (config != null && "0".equals(config.getStatus())) {
            autoPrice = "0";
        }
        boolean editPrice = true;
        SysConfig config2 = this.configService.querySysConfigByCode("CONFIG_SALER_MODIFY_PRICE", loginInfo.getDatasource());
        if (config2 != null && "1".equals(config2.getStatus())) {
            editPrice = false;
        }
        SysBfOrderConfig orderConfig = new SysBfOrderConfig();
        orderConfig.setAutoPrice(autoPrice);
        orderConfig.setEditPrice(editPrice);
        return sendSuccess("获取手机端下单配置成功", orderConfig);
    }


}
