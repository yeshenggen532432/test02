package com.qweib.cloud.biz.system.controller;

import com.qweib.cloud.biz.common.GeneralControl;
import com.qweib.cloud.biz.system.service.*;
import com.qweib.cloud.biz.system.service.ws.SysBforderWebService;
import com.qweib.cloud.core.domain.*;
import com.qweib.cloud.core.domain.vo.OrderPayType;
import com.qweib.cloud.core.domain.vo.OrderState;
import com.qweib.cloud.core.exception.BizException;
import com.qweib.cloud.utils.DateTimeUtil;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.SpringBeanReflectUtil;
import com.qweib.cloud.utils.StrUtil;
import com.qweibframework.commons.MathUtils;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.lang.reflect.Method;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.*;

@Controller
@RequestMapping("/manager")
public class SysBforderControl extends GeneralControl {
    @Resource
    private SysBforderService bforderService;
    @Resource
    private SysBforderWebService bforderWebService;
    @Resource
    private SysBforderMsgService orderMsgService;

    @Resource
    private SysConfigService configService;

    @Resource
    private SysWaresService sysWaresService;
    @Resource
    private SysCustomerService sysCustomerService;

    //    @TokenCreateTag
    @RequestMapping("/addorder")
    public String addorder(HttpServletRequest request, Model model, String dataTp) {
        try {
            SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
            Calendar calendar = Calendar.getInstance();
            calendar.add(Calendar.MONTH, -1);
            SysBforder bforder = new SysBforder();
            bforder.setOddate(DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd"));
            bforder.setOrderZt("未审核");
            bforder.setShTime(DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd HH:mm"));
            model.addAttribute("bforder", bforder);
        } catch (Exception e) {
        }
        return "/uglcw/order/saleorder";
    }

    //    @TokenCreateTag
    @RequestMapping("/showorder")
    public String showorder(HttpServletRequest request, Model model, Integer id) {
        try {
            SysLoginInfo info = this.getLoginInfo(request);
            SysBforder bforder = this.bforderService.queryBforderByid(info.getDatasource(), id);
            model.addAttribute("bforder", bforder);
            List<SysBforderDetail> warelist = this.bforderService.queryBforderDetail(info.getDatasource(), id);
            model.addAttribute("warelist", warelist);
        } catch (Exception e) {
            // TODO: handle exception
        }
        return "/uglcw/order/saleorder";
    }

    //FIXME
//    @TokenCheckTag
    @RequestMapping("saveSaleorder")
    public void saveSaleorder(HttpServletResponse response, HttpServletRequest request, SysBforder bforder, String wareStr) {
        try {
            SysLoginInfo info = this.getLoginInfo(request);
            List<SysBforderDetail> detail = new ArrayList<SysBforderDetail>();
            if (bforder == null) {
                bforder = new SysBforder();
            }
            if (StrUtil.isNull(bforder.getOddate())) {
                bforder.setOddate(new SimpleDateFormat("yyyy-MM-dd").format(new Date()));
            }
            net.sf.json.JSONArray jsonarray = net.sf.json.JSONArray.fromObject(wareStr);
            int len = jsonarray.size();
            if (!StrUtil.isNull(wareStr)) {
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
                        if (json.containsKey("remark")) {
                            if (!StrUtil.isNull(json.get("remark"))) {
                                bforderDetail.setRemark(json.get("remark").toString());
                            }
                        }
                        if (json.containsKey("beUnit")) {
                            bforderDetail.setBeUnit(json.get("beUnit").toString());
                            if (StrUtil.isNull(bforderDetail.getBeUnit())) {
                                SysWare ware = sysWaresService.queryWareById(bforderDetail.getWareId(), info.getDatasource());
                                if (ware.getWareDw().equals(bforderDetail.getWareDw())) {
                                    bforderDetail.setBeUnit("B");
                                } else {
                                    bforderDetail.setBeUnit("S");
                                }
                            }
                        }
                        if (json.get("detailWareNm") != null)
                            bforderDetail.setDetailWareNm(json.get("detailWareNm").toString());
                        if (json.get("detailWareGg") != null)
                            bforderDetail.setDetailWareGg(json.get("detailWareGg").toString());
                        if (json.get("detailShopWareAlias") != null)
                            bforderDetail.setDetailShopWareAlias(json.get("detailShopWareAlias").toString());
                        if (json.get("detailWareDesc") != null)
                            bforderDetail.setDetailWareDesc(json.get("detailWareDesc").toString());

                        if (!StrUtil.isNull(json.get("wareDjOriginal")))
                            bforderDetail.setWareDjOriginal(new BigDecimal(json.get("wareDjOriginal").toString()));
                        if (!StrUtil.isNull(json.get("detailPromotionCost")))
                            bforderDetail.setDetailPromotionCost(new BigDecimal(json.get("detailPromotionCost").toString()));
                        if (!StrUtil.isNull(json.get("detailCouponCost")))
                            bforderDetail.setDetailCouponCost(new BigDecimal(json.get("detailCouponCost").toString()));
                        detail.add(bforderDetail);
                    }
                }
            }
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyMMdd_HHmmssSSS");
            String orderNo = "T" + dateFormat.format(new Date());
            if (StrUtil.isNull(bforder.getOdtime())) {
                bforder.setOdtime(DateTimeUtil.getDateToStr(new Date(), "HH:mm:ss"));
            }
            if (StrUtil.isNull(bforder.getOrderNo())) {
                bforder.setOrderNo(orderNo);
            }
            if (StrUtil.isNull(bforder.getProType())) {
                bforder.setProType(2);
            }
            if (StrUtil.isNull(bforder.getId())) {
                Integer orderId = this.bforderWebService.addBforder(bforder, detail, info.getDatasource());
                bforder.setId(orderId);
                SysBforderMsg orderMsg = new SysBforderMsg();
                orderMsg.setOrderNo(orderNo);
                orderMsg.setCid(bforder.getCid());
                orderMsg.setMid(bforder.getMid());
                orderMsg.setMsgtime(DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd HH:mm:ss"));
                orderMsg.setIsRead(2);
                this.orderMsgService.addBforderMsg(orderMsg, info.getDatasource());
                JSONObject json = new JSONObject();
                json.put("status", "未审核");
                if ("公司直送".equals(bforder.getPszd()) && !"客户下单".equals(bforder.getOrderTp())) {
                    SysConfig config = this.configService.querySysConfigByCode("CONFIG_ORDER_AUTO_CREATE_XSFP", info.getDatasource());
                    if (config != null && "1".equals(config.getStatus())) {
                        bforder.setList(detail);
                        try {
                            SysStkOut out = bforderWebService.saveAutoCreateOrderToSale(info.getDatasource(), bforder, info.getUsrNm());

                            SpringBeanReflectUtil.springInvokeMethod("stkOutService", "auditSaleBill", new Object[]{orderId, info});

                            if (MathUtils.valid(out.getId())) {
                                //this.bforderService.updateOrderSh(info.getDatasource(), bforder.getId(), "审核");
                                //this.orderMsgService.updateBforderMsgisRead2(info.getDatasource(), bforder.getOrderNo());
                                json.put("orderNo", orderNo);
                                //json.put("status", "审核");
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    }
                }
                json.put("id", orderId);
                json.put("state", true);
                json.put("msg", "添加订单成功");
                this.sendJsonResponse(response, json.toString());
            } else {
                SysBforder order = this.bforderService.queryBforderByid(info.getDatasource(), bforder.getId());
                if (Objects.equals("审核", order.getOrderZt()) || Objects.equals("已作废", order.getOrderZt())) {
                    throw new BizException("该单据" + order.getOrderZt() + "，不能进行修改");
                }
                int k = 0;
                if ("公司直送".equals(bforder.getPszd()) && !"客户下单".equals(bforder.getOrderTp())) {
                    SysConfig config = this.configService.querySysConfigByCode("CONFIG_ORDER_AUTO_CREATE_XSFP", info.getDatasource());
                    if (config != null && "1".equals(config.getStatus())) {
                        bforder.setList(detail);
                        k = bforderWebService.updateAutoCreateOrderToSale(info.getDatasource(), bforder);
                    }
                }
                JSONObject json = new JSONObject();
                json.put("status", "未审核");
                if (k == -1) {
                    json.put("state", false);
                    json.put("msg", "修改订单失败，该订单已不允许修改！");
                    this.sendJsonResponse(response, json.toString());
                } else {
                    this.bforderWebService.updateBforder(bforder, detail, info.getDatasource());
                    json.put("id", bforder.getId());
                    json.put("state", true);
                    json.put("msg", "修改订单成功");
                    this.sendJsonResponse(response, json.toString());
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            log.error("添加订单失败", e);
        }
    }

    /**
     * 说明：到订单页面
     *
     * @创建：作者:llp 创建时间：2016-4-7
     * @修改历史： [序号](llp 2016 - 4 - 7)<修改说明>
     */
    @RequestMapping("/queryBforderPage")
    public String queryBforderPage(HttpServletRequest request, Model model, String dataTp) {
        try {
            SysLoginInfo info = this.getLoginInfo(request);
            model.addAttribute("database", info.getDatasource());
            SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
            String orderNo = request.getParameter("orderNo");
            Calendar calendar = Calendar.getInstance();
            calendar.add(Calendar.MONTH, -1);
            model.addAttribute("dataTp", dataTp);
            String from = request.getParameter("from");
            if (!StrUtil.isNull(orderNo) || "home".equals(from)) {
                model.addAttribute("sdate", "");
                model.addAttribute("edate", "");
                if ("home".equals(from)) {
                    model.addAttribute("orderZt", "未审核");
                }

            } else {
                orderNo = "";
                model.addAttribute("sdate", format.format(calendar.getTime()));
                model.addAttribute("edate", DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd"));
            }
            model.addAttribute("orderNo", orderNo);
        } catch (Exception e) {
            // TODO: handle exception
        }
        return "/uglcw/order/order";
    }

    /**
     * 说明：分页查询订单
     *
     * @创建：作者:llp 创建时间：2016-4-7
     * @修改历史： [序号](llp 2016 - 4 - 7)<修改说明>
     */
    @RequestMapping("/bforderPage")
    public void bforderPage(HttpServletRequest request, HttpServletResponse response, SysBforder order, Integer page, Integer rows,
                            String jz, String dataTp) {
        try {
//            SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
            Calendar calendar = Calendar.getInstance();
            SysLoginInfo info = getLoginInfo(request);
            calendar.add(Calendar.MONTH, -1);
            if (StrUtil.isNull(order.getEdate())) {
                order.setEdate(DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd"));
            }
            order.setDatabase(info.getDatasource());
            Page p = new Page();
            if (!StrUtil.isNull(jz)) {
                p = this.bforderService.queryBforderPage(order, dataTp, info, page, rows);
                List<SysBforder> bforderList = (List<SysBforder>) p.getRows();

                bforderService.queryBforderDetailList(bforderList, order.getDatabase());
            }
            JSONObject json = new JSONObject();
            json.put("total", p.getTotal());
            json.put("rows", p.getRows());
            this.sendJsonResponse(response, json.toString());
            p = null;
        } catch (Exception e) {
            e.printStackTrace();
            log.error("分页查询订单出错", e);
        }
    }

    /**
     * 首页待审批销售订单
     *
     * @param request
     * @param response
     * @param order
     * @param page
     * @param rows
     * @param dataTp
     */
    @RequestMapping("/bforderHomePage")
    public void bforderHomePage(HttpServletRequest request, HttpServletResponse response, SysBforder order, Integer page, Integer rows, String dataTp) {
        try {
//            SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
//            Calendar calendar = Calendar.getInstance();
//            calendar.add(Calendar.MONTH, -1);
//            if (StrUtil.isNull(order.getSdate())) {
//                order.setSdate(format.format(calendar.getTime()));
//            }
//            if (StrUtil.isNull(order.getEdate())) {
//                order.setEdate(DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd"));
//            }
            Page p = new Page();
            SysLoginInfo info = getLoginInfo(request);
            order.setDatabase(info.getDatasource());
            p = this.bforderService.queryBforderPage(order, dataTp, info, page, rows);
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("total", p.getTotal());
            json.put("rows", p.getRows());
            this.sendJsonResponse(response, json.toString());
            p = null;
        } catch (Exception e) {
            log.error("分页查询订单出错", e);
        }
    }

    /**
     * 说明：到订单详情页面
     *
     * @创建：作者:llp 创建时间：2016-4-7
     * @修改历史： [序号](llp 2016 - 4 - 7)<修改说明>
     */
    @RequestMapping("/queryBforderDetailPage")
    public String queryBforderDetailPage(HttpServletRequest request, Model model, Integer orderId) {
        model.addAttribute("orderId", orderId);
        return "/uglcw/order/orderdetail";
    }

    /**
     * 说明：分页查询订单详情
     *
     * @创建：作者:llp 创建时间：2016-4-7
     * @修改历史： [序号](llp 2016 - 4 - 7)<修改说明>
     */
    @RequestMapping("/bforderDetailPage")
    public void bforderDetailPage(HttpServletRequest request, HttpServletResponse response, Integer orderId, Integer page, Integer rows) {
        try {
            SysLoginInfo info = this.getLoginInfo(request);
            Page p = this.bforderService.queryBforderDetailPage(orderId, info.getDatasource(), page, rows);
            JSONObject json = new JSONObject();
            json.put("total", p.getTotal());
            json.put("rows", p.getRows());
            this.sendJsonResponse(response, json.toString());
            p = null;
        } catch (Exception e) {
            log.error("分页查询订单详情出错", e);
        }
    }

    /**
     * @说明：修改订单审核
     * @创建：作者:llp 创建时间：2016-5-17
     * @修改历史： [序号](llp 2016 - 5 - 17)<修改说明>
     */
    @RequestMapping("/updateOrderSh")
    public void updateOrderSh(HttpServletResponse response, HttpServletRequest request, Integer id, String sh) {
        SysLoginInfo info = this.getLoginInfo(request);
        try {
            SysBforder order = this.bforderService.queryBforderByid(info.getDatasource(), id);
            if (Objects.equals("审核", order.getOrderZt()) || Objects.equals("已作废", order.getOrderZt())) {
                throw new BizException("该单据" + order.getOrderZt() + "，不能进行修改");
            }
            this.bforderService.updateOrderSh(info.getDatasource(), id, sh);
            this.orderMsgService.updateBforderMsgisRead2(info.getDatasource(), order.getOrderNo());

            SysConfig config = this.configService.querySysConfigByCode("CONFIG_SHOP_ORDER_TO_SALE", info.getDatasource());
            if (config != null && "1".equals(config.getStatus()) && "客户下单".equals(order.getOrderTp())) {
                List<SysBforderDetail> detail = this.bforderService.queryBforderDetail(info.getDatasource(), id);
                order.setList(detail);
                try {
                    bforderWebService.saveAutoCreateOrderToSale(info.getDatasource(), order, info.getUsrNm());
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
            //如果是商城线下支付订单审核时修改订单状态
            if ("客户下单".equals(order.getOrderTp()) && order.getPayType() == OrderPayType.offline.getCode().intValue()) {
                bforderService.updateShopBforderState(id, OrderState.sendWait, info.getDatasource());
            }
            this.sendJsonResponse(response, "1");
        } catch (Exception e) {
            log.error("修改订单审核出错：", e);
            this.sendHtmlResponse(response, "-1");
        }
    }

    /**
     * @说明：删除订单
     * @创建：作者:llp 创建时间：2016-5-31
     * @修改历史： [序号](llp 2016 - 5 - 31)<修改说明>
     */
    @RequestMapping("/deleteOrder")
    public void deleteOrder(HttpServletResponse response, HttpServletRequest request, Integer id) {
        SysLoginInfo info = this.getLoginInfo(request);
        try {
            this.bforderService.deleteOrder(info.getDatasource(), id);
            this.sendJsonResponse(response, "1");
        } catch (Exception e) {
            log.error("删除订单出错：", e);
            this.sendHtmlResponse(response, "-1");
        }
    }

    /**
     * @说明：作废订单
     * @创建：作者:llp 创建时间：2016-10-11
     * @修改历史： [序号](llp 2016 - 10 - 11)<修改说明>
     */
    @RequestMapping("/updateOrderZf")
    public void updateOrderZf(HttpServletResponse response, HttpServletRequest request, String ids, Integer id) {
        SysLoginInfo info = this.getLoginInfo(request);
        try {
            if (id != null) ids = id + "";
            this.bforderService.updateOrderCancel(info.getDatasource(), ids, "手动作废", false);
            this.sendJsonResponse(response, "1");
        } catch (Exception e) {
            log.error("作废订单出错：", e);
            this.sendHtmlResponse(response, "-1");
        }
    }

    @RequestMapping("queryOrderSaleCustomerHisWarePrice")
    public void queryOrderSaleCustomerHisWarePrice(HttpServletResponse response, HttpServletRequest request, Integer cid, Integer wareId) {
        try {
            SysLoginInfo info = getLoginInfo(request);
            JSONObject json = new JSONObject();
            json.put("state", true);
            SysWare sysWare = sysWaresService.queryWareById(wareId, info.getDatasource());
            json.put("orgPrice", sysWare.getWareDj());
            sysCustomerService.loadCustomerPrice(sysWare, info, cid + "");
            json.put("zxPrice", sysWare.getWareDj());
            json.put("hisPrice", sysWare.getMaxHisPfPrice());
            json.put("minHisPrice", sysWare.getMinHisPfPrice());
//            if (list != null && list.size() > 0) {
//                SysBforderDetail od = list.get(0);
//                String beUnit = od.getBeUnit();
//                if ("S".equals(beUnit)) {
//                    SysWare sysWare = sysWaresService.queryWareById(wareId, info.getDatasource());
//                    Double hsNum = 1d;
//                    if (!StrUtil.isNull(sysWare.getHsNum())) {
//                        hsNum = sysWare.getHsNum();
//                    }
//                    BigDecimal price = new BigDecimal("0.0");
//                    if (!StrUtil.isNull(od.getWareDj())) {
//                        price = new BigDecimal(od.getWareDj() + "");
//                    }
//                    price = price.multiply(new BigDecimal(hsNum));
//                    json.put("orgPrice", sysWare.getWareDj());
//                    json.put("hisPrice", price);
//                    List<SysWare> tempWareList = new ArrayList<SysWare>();
//                    tempWareList.add(sysWare);
//                    sysCustomerService.loadCustomerPrice(tempWareList, info, cid + "");
//                    sysWare = tempWareList.get(0);
//                    json.put("zxPrice", sysWare.getWareDj());
//                } else {
//                    SysWare sysWare = sysWaresService.queryWareById(wareId, info.getDatasource());
//                    json.put("orgPrice", sysWare.getWareDj());
//                    json.put("hisPrice", od.getWareDj());
//                    List<SysWare> tempWareList = new ArrayList<SysWare>();
//                    tempWareList.add(sysWare);
//                    sysCustomerService.loadCustomerPrice(tempWareList, info, cid + "");
//                    sysWare = tempWareList.get(0);
//                    json.put("zxPrice", sysWare.getWareDj());
//                }
//                json.put("state", true);
//                json.put("msg", "获取信息成功");
//            } else {
//                SysWare sysWare = sysWaresService.queryWareById(wareId, info.getDatasource());
//                if (sysWare != null) {
//                    json.put("state", true);
//                    json.put("msg", "获取信息成功");
//                    json.put("orgPrice", sysWare.getWareDj());
//                    json.put("hisPrice", "");
//                    List<SysWare> tempWareList = new ArrayList<SysWare>();
//                    tempWareList.add(sysWare);
//                    sysCustomerService.loadCustomerPrice(tempWareList, info, cid + "");
//                    sysWare = tempWareList.get(0);
//                    json.put("zxPrice", sysWare.getWareDj());
//                } else {
//                    json.put("state", false);
//                    json.put("msg", "暂无记录");
//                }
//            }
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            e.printStackTrace();
            this.sendJsonResponse(response, "获取信息失败");
        }
    }

}
