package com.qweib.cloud.biz.system.controller.mobile;


import com.qweib.cloud.biz.system.BaseWebService;
import com.qweib.cloud.biz.system.TokenServer;
import com.qweib.cloud.biz.system.service.SysBforderMsgService;
import com.qweib.cloud.biz.system.service.SysBforderService;
import com.qweib.cloud.biz.system.service.ws.BscOrderlsWebService;
import com.qweib.cloud.biz.system.service.ws.SysCorporationtpService;
import com.qweib.cloud.biz.system.service.ws.SysMemberWebService;
import com.qweib.cloud.biz.system.service.ws.SysWareWebService;
import com.qweib.cloud.core.domain.*;
import com.qweib.cloud.utils.DateTimeUtil;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
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
public class BscOrderlsWebControl extends BaseWebService {
    @Resource
    private BscOrderlsWebService orderlsWebService;
    @Resource
    private SysMemberWebService memberWebService;
    @Resource
    private SysBforderMsgService orderMsgService;
    @Resource
    private SysCorporationtpService corporationtpService;
    @Resource
    private SysWareWebService wareWebService;
    @Resource
    private SysBforderService bforderService;

    /**
     * 说明：分页查询订单
     *
     * @创建：作者:llp 创建时间：2016-8-31
     * @修改历史： [序号](llp 2016 - 8 - 31)<修改说明>
     */
    @Deprecated
    @RequestMapping("queryOrderlsPage")
    public void queryOrderlsPage(HttpServletResponse response, String token, Integer pageNo, Integer pageSize, String kmNm, String sdate, String edate) {
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
            SysMember member = this.memberWebService.queryAllById(onlineUser.getMemId());
            Integer zt = null;
//			if(!StrUtil.isNull(member.getIsUnitmng())){
//				if(member.getIsUnitmng().equals("3")){
//					zt=2;
//				}else if(member.getIsUnitmng().equals("0")){
//					zt=3;
//				}
//			}
            Page p = this.orderlsWebService.queryOrderlsPage(onlineUser.getDatabase(), onlineUser.getMemId(), member.getBranchId(), zt, pageNo, pageSize, kmNm, sdate, edate);
            List<BscOrderls> vlist = (List<BscOrderls>) p.getRows();
            for (BscOrderls orderls : vlist) {
                if (orderls.getMid().equals(onlineUser.getMemId())) {
                    orderls.setIsMe(1);
                } else {
                    orderls.setIsMe(2);
                }
            }
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "获取订单列表成功");
            json.put("pageNo", pageNo);
            json.put("pageSize", pageSize);
            json.put("total", p.getTotal());
            json.put("totalPage", p.getTotalPage());
            json.put("rows", p.getRows());
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            this.sendWarm(response, "获取订单列表失败");
        }
    }

    /**
     * 说明：添加订单
     *
     * @创建：作者:llp 创建时间：2016-8-31
     * @修改历史： [序号](llp 2016 - 8 - 31)<修改说明>
     */
    @RequestMapping("addOrderlsWeb")
    public void addOrderlsWeb(HttpServletResponse response, HttpServletRequest request, String token, Integer cid, String orderxx) {
        try {
            if (!checkParam(response, token, cid)) {
                return;
            }
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            OnlineUser onlineUser = message.getOnlineMember();
            List<BscOrderlsDetail> detail = new ArrayList<BscOrderlsDetail>();
            BscOrderls orderls = new BscOrderls();
            net.sf.json.JSONArray jsonarray = net.sf.json.JSONArray.fromObject(orderxx);
            int len = jsonarray.size();
            if (!StrUtil.isNull(orderxx)) {
                if (len > 0) {
                    for (int j = 0; j < len; j++) {
                        net.sf.json.JSONObject json = (net.sf.json.JSONObject) jsonarray.get(j);
                        BscOrderlsDetail orderlsDetail = new BscOrderlsDetail();
                        orderlsDetail.setWareId(Integer.valueOf(json.get("wareId").toString()));
                        orderlsDetail.setZh(Double.valueOf(json.get("zh").toString()));
                        orderlsDetail.setLs(Double.valueOf(json.get("ls").toString()));
                        orderlsDetail.setDy(Double.valueOf(json.get("dy").toString()));
                        orderlsDetail.setSj(Double.valueOf(json.get("sj").toString()));
                        orderlsDetail.setQp(Double.valueOf(json.get("qp").toString()));
                        detail.add(orderlsDetail);
                    }
                }
            }
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyMMdd_HHmmssSSS");
            String orderNo = "T" + dateFormat.format(new Date());
            orderls.setCid(cid);
            orderls.setMid(onlineUser.getMemId());
            orderls.setOddate(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()));
            orderls.setOrderNo(orderNo);
            orderls.setOrderZt("未审核");
            this.orderlsWebService.addOrderls(orderls, detail, onlineUser.getDatabase());
            SysBforderMsg orderMsg = new SysBforderMsg();
            orderMsg.setOrderNo(orderNo);
            orderMsg.setCid(cid);
            orderMsg.setMid(onlineUser.getMemId());
            orderMsg.setMsgtime(DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd HH:mm:ss"));
            orderMsg.setIsRead(2);
            this.orderMsgService.addBforderMsg(orderMsg, onlineUser.getDatabase());
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "添加订单成功");
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            this.sendWarm(response, "添加订单失败");
        }
    }

    /**
     * 说明：修改订单
     *
     * @创建：作者:llp 创建时间：2016-8-31
     * @修改历史： [序号](llp 2016 - 8 - 31)<修改说明>
     */
    @RequestMapping("updateOrderlsWeb")
    public void updateOrderlsWeb(HttpServletResponse response, HttpServletRequest request, String token, Integer id, String orderxx) {
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
            List<BscOrderlsDetail> detail = new ArrayList<BscOrderlsDetail>();
            BscOrderls orderls = new BscOrderls();
            net.sf.json.JSONArray jsonarray = net.sf.json.JSONArray.fromObject(orderxx);
            int len = jsonarray.size();
            if (!StrUtil.isNull(orderxx)) {
                if (len > 0) {
                    for (int j = 0; j < len; j++) {
                        net.sf.json.JSONObject json = (net.sf.json.JSONObject) jsonarray.get(j);
                        BscOrderlsDetail orderlsDetail = new BscOrderlsDetail();
                        orderlsDetail.setWareId(Integer.valueOf(json.get("wareId").toString()));
                        orderlsDetail.setZh(Double.valueOf(json.get("zh").toString()));
                        orderlsDetail.setLs(Double.valueOf(json.get("ls").toString()));
                        orderlsDetail.setDy(Double.valueOf(json.get("dy").toString()));
                        orderlsDetail.setSj(Double.valueOf(json.get("sj").toString()));
                        orderlsDetail.setQp(Double.valueOf(json.get("qp").toString()));
                        detail.add(orderlsDetail);
                    }
                }
            }
            orderls.setOddate(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()));
            orderls.setId(id);
            orderls.setOrderZt("未审核");
            this.orderlsWebService.updateOrderls(orderls, detail, onlineUser.getDatabase());
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "修改订单成功");
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            this.sendWarm(response, "修改订单失败");
        }
    }

    /**
     * 说明：获取订单详情信息
     *
     * @创建：作者:llp 创建时间：2016-9-1
     * @修改历史： [序号](llp 2016 - 9 - 1)<修改说明>
     */
    @RequestMapping("queryOrderlsOneWeb")
    public void queryOrderlsOneWeb(HttpServletResponse response, HttpServletRequest request, String token, Integer cid) {
        try {
            if (!checkParam(response, token, cid)) {
                return;
            }
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            OnlineUser onlineUser = message.getOnlineMember();
            BscOrderls orderls = this.orderlsWebService.queryOrderlsOne2(onlineUser.getDatabase(), cid);
            JSONObject json = new JSONObject();
            if (!StrUtil.isNull(orderls)) {
                List<BscOrderlsDetail> list = this.orderlsWebService.queryOrderlsDetail(onlineUser.getDatabase(), orderls.getId());
                json.put("state", true);
                json.put("msg", "获取订单信息成功");
                json.put("id", orderls.getId());
                json.put("orderNo", orderls.getOrderNo());
                json.put("odate", orderls.getOddate());
                json.put("orderZt", orderls.getOrderZt());
                json.put("list", list);
            } else {
                json.put("state", false);
                json.put("msg", "暂无记录");
            }
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            this.sendWarm(response, "获取订单信息失败");
        }
    }

    /**
     * 说明：获取订单详情信息
     *
     * @创建：作者:llp 创建时间：2016-9-1
     * @修改历史： [序号](llp 2016 - 9 - 1)<修改说明>
     */
    @RequestMapping("queryOrderlsOneDhWeb")
    public void queryOrderlsOneDhWeb(HttpServletResponse response, HttpServletRequest request, String token, Integer id) {
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
            BscOrderls orderls = this.orderlsWebService.queryOrderlsOne(onlineUser.getDatabase(), id);
            JSONObject json = new JSONObject();
            if (!StrUtil.isNull(orderls)) {
                List<BscOrderlsDetail> list = this.orderlsWebService.queryOrderlsDetail(onlineUser.getDatabase(), orderls.getId());
                json.put("state", true);
                json.put("msg", "获取订单信息成功");
                json.put("id", orderls.getId());
                json.put("orderNo", orderls.getOrderNo());
                json.put("odate", orderls.getOddate());
                json.put("orderZt", orderls.getOrderZt());
                json.put("list", list);
            } else {
                json.put("state", false);
                json.put("msg", "暂无记录");
            }
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            this.sendWarm(response, "获取订单信息失败");
        }
    }

    /**
     * 说明：分页查询结算订单
     *
     * @创建：作者:llp 创建时间：2016-8-31
     * @修改历史： [序号](llp 2016 - 8 - 31)<修改说明>
     */
    @Deprecated
    @RequestMapping("queryOrderlsBbPage")
    public void queryOrderlsBbPage(HttpServletResponse response, String token, Integer pageNo, Integer pageSize, String kmNm, String sdate, String edate) {
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
            Integer cid = 0;
            if (!StrUtil.isNull(onlineUser.getCid())) {
                if (onlineUser.getCid() != 0) {
                    cid = onlineUser.getCid();
                }
            }
            SysMember member = this.memberWebService.queryAllById(onlineUser.getMemId());
            Integer zt = null;
//			if(!StrUtil.isNull(member.getIsUnitmng())){
//				if(member.getIsUnitmng().equals("3")){
//					zt=2;
//				}else if(member.getIsUnitmng().equals("0")){
//					zt=3;
//				}
//			}
            Page p = this.orderlsWebService.queryOrderlsBbPage(onlineUser.getDatabase(), onlineUser.getMemId(), member.getBranchId(), zt, pageNo, pageSize, kmNm, sdate, edate, cid);
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "获取结算订单列表成功");
            json.put("pageNo", pageNo);
            json.put("pageSize", pageSize);
            json.put("total", p.getTotal());
            json.put("totalPage", p.getTotalPage());
            json.put("rows", p.getRows());
            List<ToolModel> toolModells = new ArrayList<ToolModel>();
            ToolModel toolModel = new ToolModel();
            toolModel.setAllJg(p.getTolprice1());
            toolModel.setZhJg(p.getTolprice2());
            toolModells.add(toolModel);
            json.put("footer", toolModells);
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            this.sendWarm(response, "获取结算订单列表失败");
        }
    }

    /**
     * 说明：获取公司类型列表
     *
     * @创建：作者:llp 创建时间：2016-8-31
     * @修改历史： [序号](llp 2016 - 8 - 31)<修改说明>
     */
    @RequestMapping("queryGsTpLs")
    public void queryGsTpLs(HttpServletResponse response, HttpServletRequest request) {
        try {
            List<SysCorporationtp> list = this.corporationtpService.queryGsTpLs();
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "获取公司类型列表成功");
            json.put("list", list);
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            this.sendWarm(response, "获取公司类型列表失败");
        }
    }

    /**
     * 说明：获取卖场商品列表
     *
     * @创建：作者:llp 创建时间：2016-9-1
     * @修改历史： [序号](llp 2016 - 9 - 1)<修改说明>
     */
    @RequestMapping("queryMsWareLs")
    public void queryMsWareLs(HttpServletResponse response, HttpServletRequest request, String token) {
        try {
            if (!checkParam(response, token)) {
                return;
            }
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            List<SysWare> list = null;
            if (message.getOnlineMember().getDatabase().equals("hygj184")) {
                list = this.wareWebService.queryWareLs(message.getOnlineMember().getDatabase(), 15);
            } else {
                list = this.wareWebService.queryWareLs(message.getOnlineMember().getDatabase(), 1);
            }
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "获取卖场商品列表成功");
            json.put("list", list);
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            this.sendWarm(response, "获取卖场商品列表失败");
        }
    }

    /**
     * 审批订单
     *
     * @param response
     * @param request
     * @param token
     * @param id
     * @param sh
     * @author guojr
     */
    @RequestMapping("/updateOrderSh")
    public void updateOrderSh(HttpServletResponse response, HttpServletRequest request, String token, Integer id, String sh) {
        SysLoginInfo info = this.getLoginInfo(request);
        try {
            if (!checkParam(response, token)) {
                return;
            }
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            this.bforderService.updateOrderSh(info.getDatasource(), id, sh);
            SysBforder order = this.bforderService.queryBforderByid(info.getDatasource(), id);
            this.orderMsgService.updateBforderMsgisRead2(info.getDatasource(), order.getOrderNo());
            this.sendJsonResponse(response, "1");
        } catch (Exception e) {
            log.error("修改订单审核出错：", e);
            this.sendHtmlResponse(response, "-1");
        }
    }

}
