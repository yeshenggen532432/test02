package com.qweib.cloud.biz.system.controller.mobile;

import com.qweib.cloud.biz.common.CnlifeConstants;
import com.qweib.cloud.biz.system.BaseWebService;
import com.qweib.cloud.biz.system.TokenServer;
import com.qweib.cloud.biz.system.UploadFile;
import com.qweib.cloud.biz.system.jpush.JpushClassifies;
import com.qweib.cloud.biz.system.jpush.JpushClassifies2;
import com.qweib.cloud.biz.system.service.SysCustomerService;
import com.qweib.cloud.biz.system.service.ws.*;
import com.qweib.cloud.core.domain.*;
import com.qweib.cloud.utils.DateTimeUtil;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

;

@Controller
@RequestMapping("/web")
public class SysBfkhWebControl extends BaseWebService {
    @Resource
    private SysBfqdpzWebService bfqdpzWebService;//签到拍照
    @Resource
    private SysBfsdhjcService bfsdhjcService;//生动化检查
    @Resource
    private SysBfcljccjWebService bfcljccjWebService;//陈列检查采集
    @Resource
    private SysBfxsxjWebService bfxsxjWebService;//销售小结
    @Resource
    private SysBforderWebService bforderWebService;//供货下单
    @Resource
    private BscOrderlsWebService orderlsWebService;
    @Resource
    private SysBfgzxcWebService bfgzxcWebService;//道谢并告知下次拜访
    @Resource
    private SysBfxgPicWebService bfxgPicWebService;//图片
    @Resource
    private SysCustomerService customerService;
    @Resource
    private SysMemberWebService memberWebService;
    @Resource
    private SysChatMsgService chatMsgService;
    @Resource
    private JpushClassifies jpushClassifies;
    @Resource
    private JpushClassifies2 jpushClassifies2;

    /**
     * 说明：获取拜访客户信息1
     *
     * @创建：作者:llp 创建时间：2016-3-30
     * @修改历史： [序号](llp 2016 - 3 - 30)<修改说明>
     */
    @RequestMapping("queryBfkhsWeb")
    public void queryBfkhsWeb(HttpServletResponse response, HttpServletRequest request, String token, Integer cid, String date) {
        //long startTime=System.currentTimeMillis();   //获取开始时间
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
            //拜访签到拍照上次
            SysBfqdpz bfqdpzsc = this.bfqdpzWebService.queryBfqdpzOneSc(onlineUser.getDatabase(), onlineUser.getMemId(), cid);
            //道谢并告知下次拜访上次
            SysBfgzxc bfgzxcsc = this.bfgzxcWebService.queryBfgzxcOneSc(onlineUser.getDatabase(), onlineUser.getMemId(), cid);
            //1拜访签到拍照
            SysBfqdpz bfqdpz = this.bfqdpzWebService.queryBfqdpzOne(onlineUser.getDatabase(), onlineUser.getMemId(), cid, date);
            //2生动化检查
            SysBfsdhjc bfsdhjc = this.bfsdhjcService.queryBfsdhjcOne(onlineUser.getDatabase(), onlineUser.getMemId(), cid, date);
            //3陈列检查采集
            List<SysBfcljccj> list1 = this.bfcljccjWebService.queryBfcljccjOne(onlineUser.getDatabase(), onlineUser.getMemId(), cid, date);
            //4销售小结
            List<SysBfxsxj> list2 = this.bfxsxjWebService.queryBfxsxjOne(onlineUser.getDatabase(), onlineUser.getMemId(), cid, date);
            //5供货下单
            SysBforder bforder = null;
            BscOrderls orderls = null;
            if (onlineUser.getTpNm().equals("卖场")) {
                orderls = this.orderlsWebService.queryOrderlsOne2(onlineUser.getDatabase(), cid);
            } else {
                bforder = this.bforderWebService.queryBforderOne(onlineUser.getDatabase(), onlineUser.getMemId(), cid, date);
            }
            //6道谢并告知下次拜访
            SysBfgzxc bfgzxc = this.bfgzxcWebService.queryBfgzxcOne(onlineUser.getDatabase(), onlineUser.getMemId(), cid, date);
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "获取拜访客户信息成功");
            //拜访签到拍照上次
            if (!StrUtil.isNull(bfqdpzsc)) {
                json.put("qddate", bfqdpzsc.getQddate());
            } else {
                json.put("qddate", "");
            }
            //道谢并告知下次拜访上次
            if (!StrUtil.isNull(bfgzxcsc)) {
                json.put("bcbfzj", bfgzxcsc.getBcbfzj());
                json.put("dbsx", bfgzxcsc.getDbsx());
            } else {
                json.put("bcbfzj", "");
                json.put("dbsx", "");
            }
            //1拜访签到拍照
            if (!StrUtil.isNull(bfqdpz)) {
                //判断临期
                SysBfxsxj bfxsxj2 = this.bfxsxjWebService.queryBfxsxjOneSc(onlineUser.getDatabase(), onlineUser.getMemId(), bfqdpz.getCid());
                int count = 0;
                if (!StrUtil.isNull(bfxsxj2)) {
                    count = this.bfxsxjWebService.queryBfxsxjByCount(onlineUser.getDatabase(), onlineUser.getMemId(), bfqdpz.getCid(), bfxsxj2.getXjdate());
                    if (count > 0) {
                        json.put("xxzt", "临期");
                    } else {
                        json.put("xxzt", "正常");
                    }
                } else {
                    json.put("xxzt", "正常");
                }
                json.put("count1", 1);
            } else {
                json.put("xxzt", "正常");
                json.put("count1", 0);
            }
            //2生动化检查
            if (!StrUtil.isNull(bfsdhjc)) {
                json.put("count2", 1);
            } else {
                json.put("count2", 0);
            }
            //3陈列检查采集
            if (list1.size() > 0) {
                json.put("count3", 1);
            } else {
                json.put("count3", 0);
            }
            //4销售小结
            if (list2.size() > 0) {
                json.put("count4", 1);
            } else {
                json.put("count4", 0);
            }
            //5供货下单
            if (onlineUser.getTpNm().equals("卖场")) {
                if (!StrUtil.isNull(orderls)) {
                    json.put("count5", 1);
                } else {
                    json.put("count5", 0);
                }
            } else {
                if (!StrUtil.isNull(bforder)) {
                    json.put("count5", 1);
                } else {
                    json.put("count5", 0);
                }
            }
            //6道谢并告知下次拜访
            if (!StrUtil.isNull(bfgzxc)) {
                json.put("count6", 1);
            } else {
                json.put("count6", 0);
            }

            //long endTime=System.currentTimeMillis(); //获取结束时间
            //System.out.println("程序运行时间： "+(endTime-startTime)+"ms");
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            this.sendWarm(response, "获取拜访客户信息失败");
        }

    }

    /**
     * 说明：获取拜访客户信息2
     *
     * @创建：作者:llp 创建时间：2016-3-31
     * @修改历史： [序号](llp 2016 - 3 - 31)<修改说明>
     */
    @RequestMapping("queryBfkheWeb")
    public void queryBfkheWeb(HttpServletResponse response, HttpServletRequest request, String token, Integer id) {
        try {
            if (!checkParam(response, token)) {
                return;
            }
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            OnlineUser onlineUser = message.getOnlineMember();
            SysBfqdpz bfqdpzbyid = this.bfqdpzWebService.queryBfqdpzById(onlineUser.getDatabase(), id);
            //1拜访签到拍照
            SysBfqdpz bfqdpz = this.bfqdpzWebService.queryBfqdpzOne(onlineUser.getDatabase(), bfqdpzbyid.getMid(), bfqdpzbyid.getCid(), bfqdpzbyid.getQddate());
            List<SysBfxgPic> bfqdpzPic = null;
            //2生动化检查
            SysBfsdhjc bfsdhjc = this.bfsdhjcService.queryBfsdhjcOne(onlineUser.getDatabase(), bfqdpzbyid.getMid(), bfqdpzbyid.getCid(), bfqdpzbyid.getQddate());
            List<SysBfxgPic> bfsdhjcPic1 = null;
            List<SysBfxgPic> bfsdhjcPic2 = null;
            //3陈列检查采集
            List<SysBfcljccj> list1 = this.bfcljccjWebService.queryBfcljccjOne(onlineUser.getDatabase(), bfqdpzbyid.getMid(), bfqdpzbyid.getCid(), bfqdpzbyid.getQddate());
            for (int i = 0; i < list1.size(); i++) {
                list1.get(i).setBfxgPicLs(this.bfxgPicWebService.queryBfxgPicls(onlineUser.getDatabase(), list1.get(i).getId(), 4, null));
            }
            //4销售小结
            List<SysBfxsxj> list2 = this.bfxsxjWebService.queryBfxsxjOne(onlineUser.getDatabase(), bfqdpzbyid.getMid(), bfqdpzbyid.getCid(), bfqdpzbyid.getQddate());
            //5供货下单
            SysBforder bforder = null;
            BscOrderls orderls = null;
            List<SysBforderDetail> orderDetail = null;
            List<BscOrderlsDetail> orderlsDetail = null;
            if (onlineUser.getTpNm().equals("卖场")) {
                orderls = this.orderlsWebService.queryOrderlsOne2(onlineUser.getDatabase(), bfqdpzbyid.getCid());
            } else {
                bforder = this.bforderWebService.queryBforderOne(onlineUser.getDatabase(), bfqdpzbyid.getMid(), bfqdpzbyid.getCid(), bfqdpzbyid.getQddate());
            }
            //6道谢并告知下次拜访
            SysBfgzxc bfgzxc = this.bfgzxcWebService.queryBfgzxcOne(onlineUser.getDatabase(), bfqdpzbyid.getMid(), bfqdpzbyid.getCid(), bfqdpzbyid.getQddate());
            List<SysBfxgPic> bfgzxcPic = null;
            //判断临期
            SysBfxsxj bfxsxj2 = this.bfxsxjWebService.queryBfxsxjOneSc(onlineUser.getDatabase(), onlineUser.getMemId(), bfqdpz.getCid());
            int count = 0;
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "获取拜访客户信息成功");
            if (!StrUtil.isNull(bfxsxj2)) {
                count = this.bfxsxjWebService.queryBfxsxjByCount(onlineUser.getDatabase(), onlineUser.getMemId(), bfqdpz.getCid(), bfxsxj2.getXjdate());
                if (count > 0) {
                    json.put("xxzt", "临期");
                } else {
                    json.put("xxzt", "正常");
                }
            } else {
                json.put("xxzt", "正常");
            }
            //获取顶部日期，签到时间，签到地址
            String stime = "";
            if (!StrUtil.isNull(bfqdpz)) {
                json.put("Dqddate", bfqdpz.getQddate());
                json.put("Dqdtime", bfqdpz.getQdtime());
                json.put("Daddress", bfqdpz.getAddress());
                json.put("jd1", bfqdpz.getLongitude());
                json.put("wd1", bfqdpz.getLatitude());
                stime = bfqdpz.getQdtime();
            } else {
                json.put("Dqddate", "");
                json.put("Dqdtime", "");
                json.put("Daddress", "");
                json.put("jd1", "");
                json.put("wd1", "");
            }
            //离开时间，拜访总结，代办事项
            String etime = "";
            if (!StrUtil.isNull(bfgzxc)) {
                json.put("Dddtime", bfgzxc.getDdtime());
                json.put("Dbcbfzj", bfgzxc.getBcbfzj());
                json.put("Ddbsx", bfgzxc.getDbsx());
                etime = bfgzxc.getDdtime();
            } else {
                json.put("Dddtime", "");
                json.put("Dbcbfzj", "");
                json.put("Ddbsx", "");
            }
            //时长
            if (!StrUtil.isNull(stime) && !StrUtil.isNull(etime)) {
                DateFormat df = new SimpleDateFormat("HH:mm:ss");
                Date d1 = df.parse(etime);
                Date d2 = df.parse(stime);
                long diff = d1.getTime() - d2.getTime();
                long hour = (diff / (60 * 60 * 1000) - 0 * 24);
                long min = ((diff / (60 * 1000)) - 0 * 24 * 60 - hour * 60);
                long s = (diff / 1000 - 0 * 24 * 60 * 60 - hour * 60 * 60 - min * 60);
                json.put("setime", hour + "时" + min + "分" + s + " 秒");
            } else {
                json.put("setime", "");
            }
            //客户地址
            SysCustomer customer = this.customerService.queryCustomerById(onlineUser.getDatabase(), bfqdpzbyid.getCid());
            json.put("khaddress", customer.getAddress());
            json.put("jd2", customer.getLongitude());
            json.put("wd2", customer.getLatitude());
            //签退地址
            if (!StrUtil.isNull(bfgzxc)) {
                json.put("qtaddress", bfgzxc.getAddress());
                json.put("jd3", bfgzxc.getLongitude());
                json.put("wd3", bfgzxc.getLatitude());
            } else {
                json.put("qtaddress", "");
                json.put("jd3", "");
                json.put("wd3", "");
            }
            //1拜访签到拍照
            if (!StrUtil.isNull(bfqdpz)) {
                json.put("count1", 1);
                json.put("hbzt", bfqdpz.getHbzt());
                json.put("ggyy", bfqdpz.getGgyy());
                json.put("isXy", bfqdpz.getIsXy());
                json.put("remo", bfqdpz.getRemo());
                bfqdpzPic = this.bfxgPicWebService.queryBfxgPicls(onlineUser.getDatabase(), bfqdpz.getId(), 1, null);
                json.put("bfqdpzPic", bfqdpzPic);
            } else {
                json.put("count1", 0);
                json.put("hbzt", "");
                json.put("ggyy", "");
                json.put("isXy", "");
                json.put("remo", "");
                json.put("bfqdpzPic", bfqdpzPic);
            }
            //2生动化检查
            if (!StrUtil.isNull(bfsdhjc)) {
                json.put("count2", 1);
                json.put("pophb", bfsdhjc.getPophb());
                json.put("cq", bfsdhjc.getCq());
                json.put("wq", bfsdhjc.getWq());
                json.put("remo1", bfsdhjc.getRemo1());
                json.put("isXy", bfsdhjc.getIsXy());
                json.put("remo2", bfsdhjc.getRemo2());
                bfsdhjcPic1 = this.bfxgPicWebService.queryBfxgPicls(onlineUser.getDatabase(), bfsdhjc.getId(), 2, null);
                bfsdhjcPic2 = this.bfxgPicWebService.queryBfxgPicls(onlineUser.getDatabase(), bfsdhjc.getId(), 3, null);
                json.put("bfsdhjcPic1", bfsdhjcPic1);
                json.put("bfsdhjcPic2", bfsdhjcPic2);
            } else {
                json.put("count2", 0);
                json.put("pophb", "");
                json.put("cq", "");
                json.put("wq", "");
                json.put("remo1", "");
                json.put("isXy", "");
                json.put("remo2", "");
                json.put("bfsdhjcPic1", bfsdhjcPic1);
                json.put("bfsdhjcPic2", bfsdhjcPic2);
            }
            //3陈列检查采集
            if (list1.size() > 0) {
                json.put("count3", 1);
                json.put("list1", list1);
            } else {
                json.put("count3", 0);
                json.put("list1", list1);
            }
            //4销售小结
            if (list2.size() > 0) {
                json.put("count4", 1);
                json.put("list2", list2);
            } else {
                json.put("count4", 0);
                json.put("list2", list2);
            }
            //5供货下单
            if (onlineUser.getTpNm().equals("卖场")) {
                if (!StrUtil.isNull(bforder)) {
                    json.put("count5", 1);
                    orderlsDetail = this.orderlsWebService.queryOrderlsDetail(onlineUser.getDatabase(), orderls.getId());
                    json.put("orderlsDetail", orderlsDetail);
                } else {
                    json.put("count5", 0);
                    json.put("shr", "");
                    json.put("tel", "");
                    json.put("address", "");
                    json.put("remo", "");
                    json.put("zje", "");
                    json.put("zdzk", "");
                    json.put("cjje", "");
                    json.put("orderlsDetail", orderlsDetail);
                }
            } else {
                if (!StrUtil.isNull(bforder)) {
                    json.put("count5", 1);
                    json.put("shr", bforder.getShr());
                    json.put("tel", bforder.getTel());
                    json.put("address", bforder.getAddress());
                    json.put("remo", bforder.getRemo());
                    json.put("zje", bforder.getZje());
                    json.put("zdzk", bforder.getZdzk());
                    json.put("cjje", bforder.getCjje());
                    orderDetail = this.bforderWebService.queryBforderDetail(onlineUser.getDatabase(), bforder.getId());
                    json.put("orderDetail", orderDetail);
                } else {
                    json.put("count5", 0);
                    json.put("shr", "");
                    json.put("tel", "");
                    json.put("address", "");
                    json.put("remo", "");
                    json.put("zje", "");
                    json.put("zdzk", "");
                    json.put("cjje", "");
                    json.put("orderDetail", orderDetail);
                }
            }
            //6道谢并告知下次拜访
            if (!StrUtil.isNull(bfgzxc)) {
                json.put("count6", 1);
                json.put("bcbfzj", bfgzxc.getBcbfzj());
                json.put("dbsx", bfgzxc.getDbsx());
                json.put("xcdate", bfgzxc.getXcdate());
                json.put("voiceUrl", bfgzxc.getVoiceUrl());
                json.put("voiceTime", bfgzxc.getVoiceTime());
                bfgzxcPic = this.bfxgPicWebService.queryBfxgPicls(onlineUser.getDatabase(), bfgzxc.getId(), 5, null);
                json.put("bfgzxcPic", bfgzxcPic);
            } else {
                json.put("count6", 0);
                json.put("bcbfzj", "");
                json.put("dbsx", "");
                json.put("xcdate", "");
                json.put("voiceUrl", "");
                json.put("voiceTime", 0);
                json.put("bfgzxcPic", bfgzxcPic);
            }
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            this.sendWarm(response, "获取拜访客户信息失败");
        }
    }

    /**
     * 说明：获取拜访客户信息3
     *
     * @创建：作者:llp 创建时间：2016-3-31
     * @修改历史： [序号](llp 2016 - 3 - 31)<修改说明>
     */
    @RequestMapping("queryBfkheWeb2")
    public void queryBfkheWeb2(HttpServletResponse response, HttpServletRequest request, String token, Integer mid, Integer cid, String date) {
        try {
            if (!checkParam(response, token)) {
                return;
            }
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            OnlineUser onlineUser = message.getOnlineMember();
            SysBfqdpz bfqdpzbyid = this.bfqdpzWebService.queryBfqdpzBycmd(onlineUser.getDatabase(), mid, cid, date);
            //1拜访签到拍照
            SysBfqdpz bfqdpz = this.bfqdpzWebService.queryBfqdpzOne(onlineUser.getDatabase(), bfqdpzbyid.getMid(), bfqdpzbyid.getCid(), bfqdpzbyid.getQddate());
            List<SysBfxgPic> bfqdpzPic = null;
            //2生动化检查
            SysBfsdhjc bfsdhjc = this.bfsdhjcService.queryBfsdhjcOne(onlineUser.getDatabase(), bfqdpzbyid.getMid(), bfqdpzbyid.getCid(), bfqdpzbyid.getQddate());
            List<SysBfxgPic> bfsdhjcPic1 = null;
            List<SysBfxgPic> bfsdhjcPic2 = null;
            //3陈列检查采集
            List<SysBfcljccj> list1 = this.bfcljccjWebService.queryBfcljccjOne(onlineUser.getDatabase(), bfqdpzbyid.getMid(), bfqdpzbyid.getCid(), bfqdpzbyid.getQddate());
            for (int i = 0; i < list1.size(); i++) {
                list1.get(i).setBfxgPicLs(this.bfxgPicWebService.queryBfxgPicls(onlineUser.getDatabase(), list1.get(i).getId(), 4, null));
            }
            //4销售小结
            List<SysBfxsxj> list2 = this.bfxsxjWebService.queryBfxsxjOne(onlineUser.getDatabase(), bfqdpzbyid.getMid(), bfqdpzbyid.getCid(), bfqdpzbyid.getQddate());
            //5供货下单
            SysBforder bforder = this.bforderWebService.queryBforderOne(onlineUser.getDatabase(), bfqdpzbyid.getMid(), bfqdpzbyid.getCid(), bfqdpzbyid.getQddate());
            List<SysBforderDetail> orderDetail = null;
            //6道谢并告知下次拜访
            SysBfgzxc bfgzxc = this.bfgzxcWebService.queryBfgzxcOne(onlineUser.getDatabase(), bfqdpzbyid.getMid(), bfqdpzbyid.getCid(), bfqdpzbyid.getQddate());
            List<SysBfxgPic> bfgzxcPic = null;
            //判断临期
            SysBfxsxj bfxsxj2 = this.bfxsxjWebService.queryBfxsxjOneSc(onlineUser.getDatabase(), onlineUser.getMemId(), bfqdpz.getCid());
            int count = 0;
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "获取拜访客户信息成功");
            if (!StrUtil.isNull(bfxsxj2)) {
                count = this.bfxsxjWebService.queryBfxsxjByCount(onlineUser.getDatabase(), onlineUser.getMemId(), bfqdpz.getCid(), bfxsxj2.getXjdate());
                if (count > 0) {
                    json.put("xxzt", "临期");
                } else {
                    json.put("xxzt", "正常");
                }
            } else {
                json.put("xxzt", "正常");
            }
            //获取顶部日期，签到时间，签到地址
            String stime = "";
            if (!StrUtil.isNull(bfqdpz)) {
                json.put("Dqddate", bfqdpz.getQddate());
                json.put("Dqdtime", bfqdpz.getQdtime());
                json.put("Daddress", bfqdpz.getAddress());
                json.put("jd1", bfqdpz.getLongitude());
                json.put("wd1", bfqdpz.getLatitude());
                stime = bfqdpz.getQdtime();
            } else {
                json.put("Dqddate", "");
                json.put("Dqdtime", "");
                json.put("Daddress", "");
                json.put("jd1", "");
                json.put("wd1", "");
            }
            //离开时间，拜访总结，代办事项
            String etime = "";
            if (!StrUtil.isNull(bfgzxc)) {
                json.put("Dddtime", bfgzxc.getDdtime());
                json.put("Dbcbfzj", bfgzxc.getBcbfzj());
                json.put("Ddbsx", bfgzxc.getDbsx());
                etime = bfgzxc.getDdtime();
            } else {
                json.put("Dddtime", "");
                json.put("Dbcbfzj", "");
                json.put("Ddbsx", "");
            }
            //时长
            if (!StrUtil.isNull(stime) && !StrUtil.isNull(etime)) {
                DateFormat df = new SimpleDateFormat("HH:mm:ss");
                Date d1 = df.parse(etime);
                Date d2 = df.parse(stime);
                long diff = d1.getTime() - d2.getTime();
                long hour = (diff / (60 * 60 * 1000) - 0 * 24);
                long min = ((diff / (60 * 1000)) - 0 * 24 * 60 - hour * 60);
                long s = (diff / 1000 - 0 * 24 * 60 * 60 - hour * 60 * 60 - min * 60);
                json.put("setime", hour + "时" + min + "分" + s + " 秒");
            } else {
                json.put("setime", "");
            }
            //客户地址
            SysCustomer customer = this.customerService.queryCustomerById(onlineUser.getDatabase(), bfqdpzbyid.getCid());
            json.put("khaddress", customer.getAddress());
            json.put("jd2", customer.getLongitude());
            json.put("wd2", customer.getLatitude());
            //签退地址
            if (!StrUtil.isNull(bfgzxc)) {
                json.put("qtaddress", bfgzxc.getAddress());
                json.put("jd3", bfgzxc.getLongitude());
                json.put("wd3", bfgzxc.getLatitude());
            } else {
                json.put("qtaddress", "");
                json.put("jd3", "");
                json.put("wd3", "");
            }
            //1拜访签到拍照
            if (!StrUtil.isNull(bfqdpz)) {
                json.put("count1", 1);
                json.put("hbzt", bfqdpz.getHbzt());
                json.put("ggyy", bfqdpz.getGgyy());
                json.put("isXy", bfqdpz.getIsXy());
                json.put("remo", bfqdpz.getRemo());
                bfqdpzPic = this.bfxgPicWebService.queryBfxgPicls(onlineUser.getDatabase(), bfqdpz.getId(), 1, null);
                json.put("bfqdpzPic", bfqdpzPic);
            } else {
                json.put("count1", 0);
                json.put("hbzt", "");
                json.put("ggyy", "");
                json.put("isXy", "");
                json.put("remo", "");
                json.put("bfqdpzPic", bfqdpzPic);
            }
            //2生动化检查
            if (!StrUtil.isNull(bfsdhjc)) {
                json.put("count2", 1);
                json.put("pophb", bfsdhjc.getPophb());
                json.put("cq", bfsdhjc.getCq());
                json.put("wq", bfsdhjc.getWq());
                json.put("remo1", bfsdhjc.getRemo1());
                json.put("isXy", bfsdhjc.getIsXy());
                json.put("remo2", bfsdhjc.getRemo2());
                bfsdhjcPic1 = this.bfxgPicWebService.queryBfxgPicls(onlineUser.getDatabase(), bfsdhjc.getId(), 2, null);
                bfsdhjcPic2 = this.bfxgPicWebService.queryBfxgPicls(onlineUser.getDatabase(), bfsdhjc.getId(), 3, null);
                json.put("bfsdhjcPic1", bfsdhjcPic1);
                json.put("bfsdhjcPic2", bfsdhjcPic2);
            } else {
                json.put("count2", 0);
                json.put("pophb", "");
                json.put("cq", "");
                json.put("wq", "");
                json.put("remo1", "");
                json.put("isXy", "");
                json.put("remo2", "");
                json.put("bfsdhjcPic1", bfsdhjcPic1);
                json.put("bfsdhjcPic2", bfsdhjcPic2);
            }
            //3陈列检查采集
            if (list1.size() > 0) {
                json.put("count3", 1);
                json.put("list1", list1);
            } else {
                json.put("count3", 0);
                json.put("list1", list1);
            }
            //4销售小结
            if (list2.size() > 0) {
                json.put("count4", 1);
                json.put("list2", list2);
            } else {
                json.put("count4", 0);
                json.put("list2", list2);
            }
            //5供货下单
            if (!StrUtil.isNull(bforder)) {
                json.put("count5", 1);
                json.put("shr", bforder.getShr());
                json.put("tel", bforder.getTel());
                json.put("address", bforder.getAddress());
                json.put("remo", bforder.getRemo());
                json.put("zje", bforder.getZje());
                json.put("zdzk", bforder.getZdzk());
                json.put("cjje", bforder.getCjje());
                orderDetail = this.bforderWebService.queryBforderDetail(onlineUser.getDatabase(), bforder.getId());
                json.put("orderDetail", orderDetail);
            } else {
                json.put("count5", 0);
                json.put("shr", "");
                json.put("tel", "");
                json.put("address", "");
                json.put("remo", "");
                json.put("zje", "");
                json.put("zdzk", "");
                json.put("cjje", "");
                json.put("orderDetail", orderDetail);
            }
            //6道谢并告知下次拜访
            if (!StrUtil.isNull(bfgzxc)) {
                json.put("count6", 1);
                json.put("bcbfzj", bfgzxc.getBcbfzj());
                json.put("dbsx", bfgzxc.getDbsx());
                json.put("xcdate", bfgzxc.getXcdate());
                bfgzxcPic = this.bfxgPicWebService.queryBfxgPicls(onlineUser.getDatabase(), bfgzxc.getId(), 5, null);
                json.put("bfgzxcPic", bfgzxcPic);
            } else {
                json.put("count6", 0);
                json.put("bcbfzj", "");
                json.put("dbsx", "");
                json.put("xcdate", "");
                json.put("bfgzxcPic", bfgzxcPic);
            }
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            this.sendWarm(response, "获取拜访客户信息失败");
        }
    }

    /**
     * 说明：获取拜访客户信息列表(所有)
     *
     * @创建：作者:llp 创建时间：2016-3-31
     * @修改历史： [序号](llp 2016 - 3 - 31)<修改说明>
     */
    @RequestMapping("queryBfkhLsWeb")
    public void queryBfkhLsWeb(HttpServletResponse response, HttpServletRequest request, String token, Integer pageNo,
                               Integer pageSize, String khNm, String qddate, @RequestParam(defaultValue = "3") String dataTp, String mids) {
        try {
            if (!checkParam(response, token)) {
                return;
            }
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
//			if (StrUtil.isNull(dataTp)) {
//				sendWarm(response, CnlifeConstants.VIEW_MESSAGE);
//				return;
//			}
            if (pageSize == null) {
                pageSize = 10;
            }
            OnlineUser onlineUser = message.getOnlineMember();
//            SysMember member = this.memberWebService.queryAllById(onlineUser.getMemId());
//			Integer zt=null;
//			if(!StrUtil.isNull(member.getIsUnitmng())){
//				if(member.getIsUnitmng().equals("3")){
//					zt=2;
//				}else if(member.getIsUnitmng().equals("0")){
//					zt=3;
//				}
//			}
//			if(!StrUtil.isNull(mids)){
//				mids=mids+","+onlineUser.getMemId();
//			}
            Page p = this.bfqdpzWebService.queryBfqdpzPage(onlineUser, dataTp, pageNo, pageSize, khNm, qddate, mids);
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "获取拜访客户信息列表成功");
            json.put("pageNo", pageNo);
            json.put("pageSize", pageSize);
            json.put("total", p.getTotal());
            json.put("totalPage", p.getTotalPage());
            json.put("rows", p.getRows());
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            this.sendWarm(response, "获取拜访客户信息列表失败");
        }
    }

    /**
     * 说明：获取拜访客户信息列表(所有)2
     *
     * @创建：作者:llp 创建时间：2016-3-31
     * @修改历史： [序号](llp 2016 - 3 - 31)<修改说明>
     */
    @RequestMapping("queryBfkhLsWeb2")
    public void queryBfkhLsWeb2(HttpServletResponse response, HttpServletRequest request, String token, Integer pageNo,
                                Integer pageSize, String khNm, @RequestParam(defaultValue = "3") String dataTp, String mids, String sdate, String edate, Integer cid, Integer id) {
        try {
            if (!checkParam(response, token)) {
                return;
            }
            OnlineMessage message = TokenServer.tokenCheck(token);


            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            if (pageSize == null) {
                pageSize = 10;
            }
            OnlineUser onlineUser = message.getOnlineMember();
//			if(!StrUtil.isNull(mids)){
//				mids=mids+","+onlineUser.getMemId();
//			}
            Page p = this.bfqdpzWebService.queryBfqdpzPage2(onlineUser, dataTp, pageNo, pageSize, khNm, mids, sdate, edate, cid, id);
            int num = this.bfqdpzWebService.queryBfqdpzWebCount(onlineUser, dataTp, pageNo, pageSize, khNm, mids, sdate, edate, cid);
            if (StrUtil.isNull(num)) {
                num = 0;
            }
            List<SysBfqdpzJl> vlist = (List<SysBfqdpzJl>) p.getRows();
            for (SysBfqdpzJl bfqdpzJl : vlist) {
                bfqdpzJl.setZfcount(this.bfqdpzWebService.queryBfqdpzWebCount2(onlineUser, dataTp, pageNo, pageSize, khNm, mids, sdate, edate, bfqdpzJl.getCid()));
                List<SysBfcomment> commentList = this.bfqdpzWebService.queryBfCommentList(bfqdpzJl.getId(), onlineUser.getDatabase());//评论
                bfqdpzJl.setCommentList(commentList);
                if (null != commentList) {
                    for (SysBfcomment comment : commentList) {
                        comment.setRcList(bfqdpzWebService.queryBfRcList(comment.getCommentId(), onlineUser.getDatabase()));//获取回复
                    }
                }
                SysCustomer customer = this.customerService.queryCustomerById(onlineUser.getDatabase(), bfqdpzJl.getCid());
                if (customer == null) {
                    continue;
                }
                //图片集合
                List<bfpzpicxx> listpic = new ArrayList<bfpzpicxx>();
                //1拜访签到拍照
                List<SysBfxgPic> bfqdpzPic = null;
                bfqdpzPic = this.bfxgPicWebService.queryBfxgPicls(onlineUser.getDatabase(), bfqdpzJl.getId(), 1, null);
                for (int i = 0; i < bfqdpzPic.size(); i++) {
                    bfpzpicxx pic = new bfpzpicxx();
                    pic.setNm("1签到");
                    pic.setPic(bfqdpzPic.get(i).getPic());
                    pic.setPicMin(bfqdpzPic.get(i).getPicMini());
                    listpic.add(pic);
                }
                //2生动化陈列检查
                SysBfsdhjc bfsdhjc = this.bfsdhjcService.queryBfsdhjcOne(onlineUser.getDatabase(), bfqdpzJl.getMid(), bfqdpzJl.getCid(), bfqdpzJl.getQddate());
                List<SysBfxgPic> bfsdhjcPic1 = null;
                List<SysBfxgPic> bfsdhjcPic2 = null;
                if (!StrUtil.isNull(bfsdhjc)) {
                    bfsdhjcPic1 = this.bfxgPicWebService.queryBfxgPicls(onlineUser.getDatabase(), bfsdhjc.getId(), 2, null);
                    for (int i = 0; i < bfsdhjcPic1.size(); i++) {
                        bfpzpicxx pic = new bfpzpicxx();
                        pic.setNm("2生动化检查");
                        pic.setPic(bfsdhjcPic1.get(i).getPic());
                        pic.setPicMin(bfsdhjcPic1.get(i).getPicMini());
                        listpic.add(pic);
                    }
                    bfsdhjcPic2 = this.bfxgPicWebService.queryBfxgPicls(onlineUser.getDatabase(), bfsdhjc.getId(), 3, null);
                    for (int i = 0; i < bfsdhjcPic2.size(); i++) {
                        bfpzpicxx pic = new bfpzpicxx();
                        pic.setNm("2生动化检查");
                        pic.setPic(bfsdhjcPic2.get(i).getPic());
                        pic.setPicMin(bfsdhjcPic2.get(i).getPicMini());
                        listpic.add(pic);
                    }
                }
                //3库存检查
                List<SysBfcljccj> list1 = this.bfcljccjWebService.queryBfcljccjOne(onlineUser.getDatabase(), bfqdpzJl.getMid(), bfqdpzJl.getCid(), bfqdpzJl.getQddate());
                if (list1.size() > 0) {
                    for (int i = 0; i < list1.size(); i++) {
                        List<SysBfxgPic> cljccjPic4 = this.bfxgPicWebService.queryBfxgPicls(onlineUser.getDatabase(), list1.get(i).getId(), 4, null);
                        for (int j = 0; j < cljccjPic4.size(); j++) {
                            bfpzpicxx pic = new bfpzpicxx();
                            pic.setNm("3库存检查");
                            pic.setPic(cljccjPic4.get(j).getPic());
                            pic.setPicMin(cljccjPic4.get(j).getPicMini());
                            listpic.add(pic);
                        }
                    }
                }
                //4道谢并告知下次拜访
                SysBfgzxc bfgzxc = this.bfgzxcWebService.queryBfgzxcOne(onlineUser.getDatabase(), bfqdpzJl.getMid(), bfqdpzJl.getCid(), bfqdpzJl.getQddate());
                List<SysBfxgPic> bfgzxcPic = null;
                if (!StrUtil.isNull(bfgzxc)) {
                    bfgzxcPic = this.bfxgPicWebService.queryBfxgPicls(onlineUser.getDatabase(), bfgzxc.getId(), 5, null);
                    for (int i = 0; i < bfgzxcPic.size(); i++) {
                        bfpzpicxx pic = new bfpzpicxx();
                        pic.setNm("4告知下次拜访");
                        pic.setPic(bfgzxcPic.get(i).getPic());
                        pic.setPicMin(bfgzxcPic.get(i).getPicMini());
                        listpic.add(pic);
                    }
                    bfqdpzJl.setBcbfzj(bfgzxc.getBcbfzj());
                    if (!StrUtil.isNull(bfqdpzJl.getLongitude())) {
                        if (!bfqdpzJl.getLongitude().equals("null")) {
                            if (!StrUtil.isNull(customer.getLongitude())) {
                                if (!customer.getLongitude().equals("null")) {
                                    bfqdpzJl.setJlm(StrUtil.GetDistancePJZ(Double.parseDouble(customer.getLongitude()), Double.parseDouble(customer.getLatitude()), Double.parseDouble(bfqdpzJl.getLongitude()), Double.parseDouble(bfqdpzJl.getLatitude()), Double.parseDouble(bfgzxc.getLongitude()), Double.parseDouble(bfgzxc.getLatitude())));
                                }
                            }
                        }
                    } else {
                        bfqdpzJl.setJlm(0);
                    }
                    bfqdpzJl.setQddate(bfqdpzJl.getQddate() + " " + bfqdpzJl.getQdtime() + "-" + bfgzxc.getDdtime());
                    //时长
                    DateFormat df = new SimpleDateFormat("HH:mm:ss");
                    Date d1 = df.parse(bfgzxc.getDdtime());
                    Date d2 = df.parse(bfqdpzJl.getQdtime());
                    long diff = d1.getTime() - d2.getTime();
                    long hour = (diff / (60 * 60 * 1000) - 0 * 24);
                    long min = ((diff / (60 * 1000)) - 0 * 24 * 60 - hour * 60);
                    long s = (diff / 1000 - 0 * 24 * 60 * 60 - hour * 60 * 60 - min * 60);
                    bfqdpzJl.setQdtime(hour + ":" + min + ":" + s);
                    bfqdpzJl.setVoiceTime(StrUtil.isNull(bfgzxc.getVoiceTime()) ? 0 : bfgzxc.getVoiceTime());
                    bfqdpzJl.setVoiceUrl(StrUtil.isNull(bfgzxc.getVoiceUrl()) ? "" : bfgzxc.getVoiceUrl());
                    bfqdpzJl.setLongitude2(bfgzxc.getLongitude());
                    bfqdpzJl.setLatitude2(bfgzxc.getLatitude());
                } else {
                    bfqdpzJl.setBcbfzj("");
                    if (!StrUtil.isNull(bfqdpzJl.getLongitude())) {
                        if (!bfqdpzJl.getLongitude().equals("null")) {
                            if (!StrUtil.isNull(customer.getLongitude())) {
                                if (!customer.getLongitude().equals("null")) {
                                    bfqdpzJl.setJlm(StrUtil.GetDistancePJZ(Double.parseDouble(customer.getLongitude()), Double.parseDouble(customer.getLatitude()), Double.parseDouble(bfqdpzJl.getLongitude()), Double.parseDouble(bfqdpzJl.getLatitude()), null, null));
                                }
                            }
                        }
                    } else {
                        bfqdpzJl.setJlm(0);
                    }
                    bfqdpzJl.setQddate(bfqdpzJl.getQddate() + " " + bfqdpzJl.getQdtime());
                    bfqdpzJl.setQdtime("");
                    bfqdpzJl.setVoiceTime(0);
                    bfqdpzJl.setVoiceUrl("");
                    bfqdpzJl.setLongitude2("");
                    bfqdpzJl.setLatitude2("");
                }
                bfqdpzJl.setListpic(listpic);
            }
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "获取拜访客户信息列表成功");
            json.put("pageNo", pageNo);
            json.put("pageSize", pageSize);
            json.put("total", p.getTotal());
            json.put("totalPage", p.getTotalPage());
            json.put("num", num);
            json.put("rows", p.getRows());
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            this.sendWarm(response, "获取拜访客户信息列表失败");
        }
    }

    /**
     * 说明：获取拜访客户信息列表(所有)3
     *
     * @创建：作者:llp 创建时间：2016-3-31
     * @修改历史： [序号](llp 2016 - 3 - 31)<修改说明>
     */
    @RequestMapping("queryBfkhLsWeb3")
    public void queryBfkhLsWeb3(HttpServletResponse response, HttpServletRequest request, String token, Integer pageNo,
                                Integer pageSize, String khNm, @RequestParam(defaultValue = "3") String dataTp, String mids, String sdate, String edate, Integer cid, Integer id) {
        try {
            if (!checkParam(response, token)) {
                return;
            }
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            if (pageSize == null) {
                pageSize = 10;
            }
            OnlineUser onlineUser = message.getOnlineMember();

            Page p = this.bfqdpzWebService.queryBfqdpzPage3(onlineUser, dataTp, pageNo, pageSize, khNm, mids, sdate, edate, cid, id);
            List<SysBfqdpzJl> vlist = (List<SysBfqdpzJl>) p.getRows();
            for (SysBfqdpzJl bfqdpzJl : vlist) {
                List<SysBfcomment> commentList = this.bfqdpzWebService.queryBfCommentList(bfqdpzJl.getId(), onlineUser.getDatabase());//评论
                bfqdpzJl.setCommentList(commentList);
                if (null != commentList) {
                    for (SysBfcomment comment : commentList) {
                        comment.setRcList(bfqdpzWebService.queryBfRcList(comment.getCommentId(), onlineUser.getDatabase()));//获取回复
                    }
                }
                SysCustomer customer = this.customerService.queryCustomerById(onlineUser.getDatabase(), bfqdpzJl.getCid());
                if (customer == null) {
                    continue;
                }
                //图片集合
                List<bfpzpicxx> listpic = new ArrayList<bfpzpicxx>();
                //1拜访签到拍照
                List<SysBfxgPic> bfqdpzPic = null;
                bfqdpzPic = this.bfxgPicWebService.queryBfxgPicls(onlineUser.getDatabase(), bfqdpzJl.getId(), 1, null);
                for (int i = 0; i < bfqdpzPic.size(); i++) {
                    bfpzpicxx pic = new bfpzpicxx();
                    pic.setNm("1签到");
                    pic.setPic(bfqdpzPic.get(i).getPic());
                    pic.setPicMin(bfqdpzPic.get(i).getPicMini());
                    listpic.add(pic);
                }
                //2生动化陈列检查
                SysBfsdhjc bfsdhjc = this.bfsdhjcService.queryBfsdhjcOne(onlineUser.getDatabase(), bfqdpzJl.getMid(), bfqdpzJl.getCid(), bfqdpzJl.getQddate());
                List<SysBfxgPic> bfsdhjcPic1 = null;
                List<SysBfxgPic> bfsdhjcPic2 = null;
                if (!StrUtil.isNull(bfsdhjc)) {
                    bfsdhjcPic1 = this.bfxgPicWebService.queryBfxgPicls(onlineUser.getDatabase(), bfsdhjc.getId(), 2, null);
                    for (int i = 0; i < bfsdhjcPic1.size(); i++) {
                        bfpzpicxx pic = new bfpzpicxx();
                        pic.setNm("2生动化检查");
                        pic.setPic(bfsdhjcPic1.get(i).getPic());
                        pic.setPicMin(bfsdhjcPic1.get(i).getPicMini());
                        listpic.add(pic);
                    }
                    bfsdhjcPic2 = this.bfxgPicWebService.queryBfxgPicls(onlineUser.getDatabase(), bfsdhjc.getId(), 3, null);
                    for (int i = 0; i < bfsdhjcPic2.size(); i++) {
                        bfpzpicxx pic = new bfpzpicxx();
                        pic.setNm("2生动化检查");
                        pic.setPic(bfsdhjcPic2.get(i).getPic());
                        pic.setPicMin(bfsdhjcPic2.get(i).getPicMini());
                        listpic.add(pic);
                    }
                }
                //3库存检查
                List<SysBfcljccj> list1 = this.bfcljccjWebService.queryBfcljccjOne(onlineUser.getDatabase(), bfqdpzJl.getMid(), bfqdpzJl.getCid(), bfqdpzJl.getQddate());
                if (list1.size() > 0) {
                    for (int i = 0; i < list1.size(); i++) {
                        List<SysBfxgPic> cljccjPic4 = this.bfxgPicWebService.queryBfxgPicls(onlineUser.getDatabase(), list1.get(i).getId(), 4, null);
                        for (int j = 0; j < cljccjPic4.size(); j++) {
                            bfpzpicxx pic = new bfpzpicxx();
                            pic.setNm("3库存检查");
                            pic.setPic(cljccjPic4.get(j).getPic());
                            pic.setPicMin(cljccjPic4.get(j).getPicMini());
                            listpic.add(pic);
                        }
                    }
                }
                //4道谢并告知下次拜访
                SysBfgzxc bfgzxc = this.bfgzxcWebService.queryBfgzxcOne(onlineUser.getDatabase(), bfqdpzJl.getMid(), bfqdpzJl.getCid(), bfqdpzJl.getQddate());
                List<SysBfxgPic> bfgzxcPic = null;
                if (!StrUtil.isNull(bfgzxc)) {
                    bfgzxcPic = this.bfxgPicWebService.queryBfxgPicls(onlineUser.getDatabase(), bfgzxc.getId(), 5, null);
                    for (int i = 0; i < bfgzxcPic.size(); i++) {
                        bfpzpicxx pic = new bfpzpicxx();
                        pic.setNm("4告知下次拜访");
                        pic.setPic(bfgzxcPic.get(i).getPic());
                        pic.setPicMin(bfgzxcPic.get(i).getPicMini());
                        listpic.add(pic);
                    }
                    bfqdpzJl.setBcbfzj(bfgzxc.getBcbfzj());
                    if (!StrUtil.isNull(bfqdpzJl.getLongitude())) {
                        if (!bfqdpzJl.getLongitude().equals("null")) {
                            if (!StrUtil.isNull(customer.getLongitude())) {
                                if (!customer.getLongitude().equals("null")) {
                                    bfqdpzJl.setJlm(StrUtil.GetDistancePJZ(Double.parseDouble(customer.getLongitude()), Double.parseDouble(customer.getLatitude()), Double.parseDouble(bfqdpzJl.getLongitude()), Double.parseDouble(bfqdpzJl.getLatitude()), Double.parseDouble(bfgzxc.getLongitude()), Double.parseDouble(bfgzxc.getLatitude())));
                                }
                            }
                        }
                    } else {
                        bfqdpzJl.setJlm(0);
                    }
                    bfqdpzJl.setQddate(bfqdpzJl.getQddate() + " " + bfqdpzJl.getQdtime() + "-" + bfgzxc.getDdtime());
                    //时长
                    DateFormat df = new SimpleDateFormat("HH:mm:ss");
                    Date d1 = df.parse(bfgzxc.getDdtime());
                    Date d2 = df.parse(bfqdpzJl.getQdtime());
                    long diff = d1.getTime() - d2.getTime();
                    long hour = (diff / (60 * 60 * 1000) - 0 * 24);
                    long min = ((diff / (60 * 1000)) - 0 * 24 * 60 - hour * 60);
                    long s = (diff / 1000 - 0 * 24 * 60 * 60 - hour * 60 * 60 - min * 60);
                    bfqdpzJl.setQdtime(hour + ":" + min + ":" + s);
                    bfqdpzJl.setVoiceTime(StrUtil.isNull(bfgzxc.getVoiceTime()) ? 0 : bfgzxc.getVoiceTime());
                    bfqdpzJl.setVoiceUrl(StrUtil.isNull(bfgzxc.getVoiceUrl()) ? "" : bfgzxc.getVoiceUrl());
                    bfqdpzJl.setLongitude2(bfgzxc.getLongitude());
                    bfqdpzJl.setLatitude2(bfgzxc.getLatitude());
                } else {
                    bfqdpzJl.setBcbfzj("");
                    if (!StrUtil.isNull(bfqdpzJl.getLongitude())) {
                        if (!bfqdpzJl.getLongitude().equals("null")) {
                            if (!StrUtil.isNull(customer.getLongitude())) {
                                if (!customer.getLongitude().equals("null")) {
                                    bfqdpzJl.setJlm(StrUtil.GetDistancePJZ(Double.parseDouble(customer.getLongitude()), Double.parseDouble(customer.getLatitude()), Double.parseDouble(bfqdpzJl.getLongitude()), Double.parseDouble(bfqdpzJl.getLatitude()), null, null));
                                }
                            }
                        }
                    } else {
                        bfqdpzJl.setJlm(0);
                    }
                    bfqdpzJl.setQddate(bfqdpzJl.getQddate() + " " + bfqdpzJl.getQdtime());
                    bfqdpzJl.setQdtime("");
                    bfqdpzJl.setVoiceTime(0);
                    bfqdpzJl.setVoiceUrl("");
                    bfqdpzJl.setLongitude2("");
                    bfqdpzJl.setLatitude2("");
                }
                bfqdpzJl.setListpic(listpic);
            }
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "获取拜访客户信息列表成功");
            json.put("pageNo", pageNo);
            json.put("pageSize", pageSize);
            json.put("total", p.getTotal());
            json.put("totalPage", p.getTotalPage());
            json.put("rows", p.getRows());
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            e.printStackTrace();
            this.sendWarm(response, "获取拜访客户信息列表失败");
        }
    }

    /**
     * 说明：获取拜访最新时间
     *
     * @创建：作者:llp 创建时间：2016-3-31
     * @修改历史： [序号](llp 2016 - 3 - 31)<修改说明>
     */
    @RequestMapping("queryBfkhWebTime")
    public void queryBfkhWebTime(HttpServletResponse response, HttpServletRequest request, String token,
                                 @RequestParam(defaultValue = "3") String dataTp, String mids) {
        try {
            if (!checkParam(response, token)) {
                return;
            }
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            OnlineUser onlineUser = message.getOnlineMember();
            String bfdate = "";
            SysBfqdpzJl bfqdpzJl = this.bfqdpzWebService.queryBfqdpzBy4cs(onlineUser, dataTp, mids);
            if (!StrUtil.isNull(bfqdpzJl)) {
                bfdate = bfqdpzJl.getQddate();
            }
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "获取拜访最新时间成功");
            json.put("bfdate", bfdate);
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            this.sendWarm(response, "获取拜访最新时间失败");
        }
    }

    /**
     * 说明：获取拜访客户信息列表详情
     *
     * @创建：作者:llp 创建时间：2017-8-14
     * @修改历史： [序号](llp 2017 - 8 - 14)<修改说明>
     */
    @RequestMapping("queryBfkhLsWebOne")
    public void queryBfkhLsWebOne(HttpServletResponse response, HttpServletRequest request, String token, Integer bfId) {
        try {
            if (!checkParam(response, token, bfId)) {
                return;
            }
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            OnlineUser onlineUser = message.getOnlineMember();
            SysBfqdpzJl bfqdpzJl = this.bfqdpzWebService.queryBfqdpzById2(onlineUser.getDatabase(), bfId);
            List<SysBfcomment> commentList = this.bfqdpzWebService.queryBfCommentList(bfqdpzJl.getId(), onlineUser.getDatabase());//评论
            bfqdpzJl.setCommentList(commentList);
            if (null != commentList) {
                for (SysBfcomment comment : commentList) {
                    comment.setRcList(bfqdpzWebService.queryBfRcList(comment.getCommentId(), onlineUser.getDatabase()));//获取回复
                }
            }
            SysCustomer customer = this.customerService.queryCustomerById(onlineUser.getDatabase(), bfqdpzJl.getCid());
            if (customer != null) {
                //图片集合
                List<bfpzpicxx> listpic = new ArrayList<bfpzpicxx>();
                //1拜访签到拍照
                List<SysBfxgPic> bfqdpzPic = null;
                bfqdpzPic = this.bfxgPicWebService.queryBfxgPicls(onlineUser.getDatabase(), bfqdpzJl.getId(), 1, null);
                for (int i = 0; i < bfqdpzPic.size(); i++) {
                    bfpzpicxx pic = new bfpzpicxx();
                    pic.setNm("1签到");
                    pic.setPic(bfqdpzPic.get(i).getPic());
                    pic.setPicMin(bfqdpzPic.get(i).getPicMini());
                    listpic.add(pic);
                }
                //2生动化陈列检查
                SysBfsdhjc bfsdhjc = this.bfsdhjcService.queryBfsdhjcOne(onlineUser.getDatabase(), bfqdpzJl.getMid(), bfqdpzJl.getCid(), bfqdpzJl.getQddate());
                List<SysBfxgPic> bfsdhjcPic1 = null;
                List<SysBfxgPic> bfsdhjcPic2 = null;
                if (!StrUtil.isNull(bfsdhjc)) {
                    bfsdhjcPic1 = this.bfxgPicWebService.queryBfxgPicls(onlineUser.getDatabase(), bfsdhjc.getId(), 2, null);
                    for (int i = 0; i < bfsdhjcPic1.size(); i++) {
                        bfpzpicxx pic = new bfpzpicxx();
                        pic.setNm("2生动化检查");
                        pic.setPic(bfsdhjcPic1.get(i).getPic());
                        pic.setPicMin(bfsdhjcPic1.get(i).getPicMini());
                        listpic.add(pic);
                    }
                    bfsdhjcPic2 = this.bfxgPicWebService.queryBfxgPicls(onlineUser.getDatabase(), bfsdhjc.getId(), 3, null);
                    for (int i = 0; i < bfsdhjcPic2.size(); i++) {
                        bfpzpicxx pic = new bfpzpicxx();
                        pic.setNm("2生动化检查");
                        pic.setPic(bfsdhjcPic2.get(i).getPic());
                        pic.setPicMin(bfsdhjcPic2.get(i).getPicMini());
                        listpic.add(pic);
                    }
                }
                //3库存检查
                List<SysBfcljccj> list1 = this.bfcljccjWebService.queryBfcljccjOne(onlineUser.getDatabase(), bfqdpzJl.getMid(), bfqdpzJl.getCid(), bfqdpzJl.getQddate());
                if (list1.size() > 0) {
                    for (int i = 0; i < list1.size(); i++) {
                        List<SysBfxgPic> cljccjPic4 = this.bfxgPicWebService.queryBfxgPicls(onlineUser.getDatabase(), list1.get(i).getId(), 4, null);
                        for (int j = 0; j < cljccjPic4.size(); j++) {
                            bfpzpicxx pic = new bfpzpicxx();
                            pic.setNm("3库存检查");
                            pic.setPic(cljccjPic4.get(j).getPic());
                            pic.setPicMin(cljccjPic4.get(j).getPicMini());
                            listpic.add(pic);
                        }
                    }
                }
                //4道谢并告知下次拜访
                SysBfgzxc bfgzxc = this.bfgzxcWebService.queryBfgzxcOne(onlineUser.getDatabase(), bfqdpzJl.getMid(), bfqdpzJl.getCid(), bfqdpzJl.getQddate());
                List<SysBfxgPic> bfgzxcPic = null;
                if (!StrUtil.isNull(bfgzxc)) {
                    bfgzxcPic = this.bfxgPicWebService.queryBfxgPicls(onlineUser.getDatabase(), bfgzxc.getId(), 5, null);
                    for (int i = 0; i < bfgzxcPic.size(); i++) {
                        bfpzpicxx pic = new bfpzpicxx();
                        pic.setNm("4告知下次拜访");
                        pic.setPic(bfgzxcPic.get(i).getPic());
                        pic.setPicMin(bfgzxcPic.get(i).getPicMini());
                        listpic.add(pic);
                    }
                    bfqdpzJl.setBcbfzj(bfgzxc.getBcbfzj());
                    if (!StrUtil.isNull(bfqdpzJl.getLongitude())) {
                        bfqdpzJl.setJlm(StrUtil.GetDistancePJZ(Double.parseDouble(customer.getLongitude()), Double.parseDouble(customer.getLatitude()), Double.parseDouble(bfqdpzJl.getLongitude()), Double.parseDouble(bfqdpzJl.getLatitude()), Double.parseDouble(bfgzxc.getLongitude()), Double.parseDouble(bfgzxc.getLatitude())));
                    } else {
                        bfqdpzJl.setJlm(0);
                    }
                    bfqdpzJl.setQddate(bfqdpzJl.getQddate() + " " + bfqdpzJl.getQdtime() + "-" + bfgzxc.getDdtime());
                    //时长
                    DateFormat df = new SimpleDateFormat("HH:mm:ss");
                    Date d1 = df.parse(bfgzxc.getDdtime());
                    Date d2 = df.parse(bfqdpzJl.getQdtime());
                    long diff = d1.getTime() - d2.getTime();
                    long hour = (diff / (60 * 60 * 1000) - 0 * 24);
                    long min = ((diff / (60 * 1000)) - 0 * 24 * 60 - hour * 60);
                    long s = (diff / 1000 - 0 * 24 * 60 * 60 - hour * 60 * 60 - min * 60);
                    bfqdpzJl.setQdtime(hour + ":" + min + ":" + s);
                    bfqdpzJl.setVoiceTime(StrUtil.isNull(bfgzxc.getVoiceTime()) ? 0 : bfgzxc.getVoiceTime());
                    bfqdpzJl.setVoiceUrl(StrUtil.isNull(bfgzxc.getVoiceUrl()) ? "" : bfgzxc.getVoiceUrl());
                } else {
                    bfqdpzJl.setBcbfzj("");
                    if (!StrUtil.isNull(bfqdpzJl.getLongitude())) {
                        bfqdpzJl.setJlm(StrUtil.GetDistancePJZ(Double.parseDouble(customer.getLongitude()), Double.parseDouble(customer.getLatitude()), Double.parseDouble(bfqdpzJl.getLongitude()), Double.parseDouble(bfqdpzJl.getLatitude()), null, null));
                    } else {
                        bfqdpzJl.setJlm(0);
                    }
                    bfqdpzJl.setQddate(bfqdpzJl.getQddate() + " " + bfqdpzJl.getQdtime());
                    bfqdpzJl.setQdtime("");
                    bfqdpzJl.setVoiceTime(0);
                    bfqdpzJl.setVoiceUrl("");
                }
                bfqdpzJl.setListpic(listpic);
                JSONObject json = new JSONObject();
                json.put("state", true);
                json.put("msg", "获取拜访客户信息详情成功");
                json.put("xx", new JSONObject(bfqdpzJl));
                this.sendJsonResponse(response, json.toString());

            }
        } catch (Exception e) {
            this.sendWarm(response, "获取拜访客户信息详情失败");
        }
    }

    /**
     * 说明：根据客户id获取拜访客户信息列表
     *
     * @创建：作者:llp 创建时间：2016-4-12
     * @修改历史： [序号](llp 2016 - 4 - 12)<修改说明>
     */
    @RequestMapping("queryBfqdpzPageBymcid")
    public void queryBfqdpzPageBymcid(HttpServletResponse response, HttpServletRequest request, String token, Integer pageNo, Integer pageSize,
                                      Integer cid, @RequestParam(defaultValue = "3") String dataTp) {
        try {
            if (!checkParam(response, token)) {
                return;
            }
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
//			if (StrUtil.isNull(dataTp)) {
//				sendWarm(response, CnlifeConstants.VIEW_MESSAGE);
//				return;
//			}
            if (pageSize == null) {
                pageSize = 10;
            }
            OnlineUser onlineUser = message.getOnlineMember();
//            SysMember member = this.memberWebService.queryAllById(onlineUser.getMemId());
//			Integer zt=null;
//			if(!StrUtil.isNull(member.getIsUnitmng())){
//				if(member.getIsUnitmng().equals("3")){
//					zt=2;
//				}else if(member.getIsUnitmng().equals("0")){
//					zt=3;
//				}
//			}
            Page p = this.bfqdpzWebService.queryBfqdpzPageBymcid(onlineUser, pageNo, pageSize, cid, dataTp);
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "获取拜访客户信息列表成功");
            json.put("pageNo", pageNo);
            json.put("pageSize", pageSize);
            json.put("total", p.getTotal());
            json.put("totalPage", p.getTotalPage());
            json.put("rows", p.getRows());
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            this.sendWarm(response, "获取拜访客户信息列表失败");
        }
    }

    /**
     * 说明：添加评论/回复
     *
     * @创建：作者:llp 创建时间：2017-8-9
     * @修改历史： [序号](llp 2017 - 8 - 9)<修改说明>
     */
    @RequestMapping("addBfcomment")
    public void addBfcomment(HttpServletRequest request, HttpServletResponse response, String token, SysBfcomment topicComment) {
        if (!checkParam(response, token, topicComment.getBfId()))
            return;
        try {
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            OnlineUser loginDto = message.getOnlineMember();
            String datasource = loginDto.getDatabase();
            if (null != topicComment.getRcId()) {//自己不能回复自己的评论
                if (topicComment.getRcId().equals(loginDto.getMemId())) {
                    sendWarm(response, "自己不能回复自己的评论");
                    return;
                }
            }
            topicComment.setCommentTime(DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd HH:mm:ss"));
            topicComment.setMemberId(loginDto.getMemId());
            if (!StrUtil.isNull(topicComment.getVoiceTime())) {
                topicComment.setContent(UploadFile.saveBfVoice(request, response, datasource));
            }
            Integer info = this.bfqdpzWebService.addBfcomment(topicComment, datasource);
            //查询主题发表人信息
            SysMemDTO member = new SysMemDTO();
            String sendContent = "";
            if (null != topicComment.getRcId()) {//回复
                member = memberWebService.queryMemByMemId(topicComment.getRcId());
                sendContent = "回复你的拜访";
            } else {
                member = this.bfqdpzWebService.findMemberByQdpz(topicComment.getBfId(), datasource);
                sendContent = "评论你的拜访";
            }
            if (!loginDto.getMemId().equals(member.getMemberId())) {
                //--保存临时消息--
                SysChatMsg scm = new SysChatMsg();
                scm.setAddtime(DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd HH:mm:ss"));
                scm.setMemberId(loginDto.getMemId());
                scm.setReceiveId(member.getMemberId());
                scm.setTp("43");//拜访评论
                scm.setBelongId(topicComment.getBfId());//拜访id
                scm.setMsg(sendContent);
                chatMsgService.addChatMsg(scm, datasource);
                jpushClassifies.toJpush(member.getMemberMobile(), CnlifeConstants.MODE3, CnlifeConstants.NEWMSG, null, null, "拜访评论推送", null);
                jpushClassifies2.toJpush(member.getMemberMobile(), CnlifeConstants.MODE3, CnlifeConstants.NEWMSG, null, null, "拜访评论推送", null);
            }
            this.sendJsonResponse(response, "{\"state\":true,\"msg\":\"添加评论回复成功\",\"commentId\":" + info + "}");
        } catch (Exception e) {
            sendException(response, e);
        }
    }

    /**
     * 说明：删除评论,回复
     *
     * @创建：作者:llp 创建时间：2017-8-9
     * @修改历史： [序号](llp 2017 - 8 - 9)<修改说明>
     */
    @RequestMapping("deleteBfComment")
    public void deleteBfComment(HttpServletRequest request, HttpServletResponse response, String token, Integer commentId) {
        if (!checkParam(response, token, commentId))
            return;
        try {
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            String datasource = message.getOnlineMember().getDatabase();
            SysBfcomment comment = bfqdpzWebService.queryBfCommentById(commentId, datasource);
            if (!comment.getMemberId().equals(message.getOnlineMember().getMemId())) {
                sendWarm(response, "只有本人才能删除自己评论");
                return;
            }
            bfqdpzWebService.deleteBfComment(commentId, datasource);
            sendSuccess(response, "删除评论成功");
        } catch (Exception e) {
            sendException(response, e);
        }
    }

    /**
     * 拜访查询（合并打卡查询）
     */
    @RequestMapping("queryBfkhLsWebNew")
    public void queryBfkhLsWebNew(HttpServletResponse response, HttpServletRequest request, String token, Integer pageNo,
                                Integer pageSize, String khNm, @RequestParam(defaultValue = "3") String dataTp, String mids, String sdate, String edate, Integer cid, Integer id) {
        try {
            if (!checkParam(response, token)) {
                return;
            }
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            if (pageSize == null) {
                pageSize = 10;
            }
            OnlineUser onlineUser = message.getOnlineMember();

            Page p = this.bfqdpzWebService.queryBfqdpzPageNew(onlineUser, dataTp, pageNo, pageSize, khNm, mids, sdate, edate, cid, id);
            List<SysBfqdpzJl> rows = (List<SysBfqdpzJl>) p.getRows();
            for (SysBfqdpzJl bfqdpzJl : rows) {
                if(1 == bfqdpzJl.getType()){
                    //拜访查询
                    List<SysBfcomment> commentList = this.bfqdpzWebService.queryBfCommentList(bfqdpzJl.getId(), onlineUser.getDatabase());//评论
                    bfqdpzJl.setCommentList(commentList);
                    if (null != commentList) {
                        for (SysBfcomment comment : commentList) {
                            comment.setRcList(bfqdpzWebService.queryBfRcList(comment.getCommentId(), onlineUser.getDatabase()));//获取回复
                        }
                    }
                    SysCustomer customer = this.customerService.queryCustomerById(onlineUser.getDatabase(), bfqdpzJl.getCid());
                    if (customer == null) {
                        continue;
                    }
                    //------图片集合-------
                    List<bfpzpicxx> listpic = new ArrayList<>();
                    //1拜访签到拍照
                    List<SysBfxgPic> bfqdpzPic = null;
                    bfqdpzPic = this.bfxgPicWebService.queryBfxgPicls(onlineUser.getDatabase(), bfqdpzJl.getId(), 1, null);
                    for (int i = 0; i < bfqdpzPic.size(); i++) {
                        bfpzpicxx pic = new bfpzpicxx();
                        pic.setNm("1签到");
                        pic.setPic(bfqdpzPic.get(i).getPic());
                        pic.setPicMin(bfqdpzPic.get(i).getPicMini());
                        listpic.add(pic);
                    }
                    //2生动化陈列检查
                    SysBfsdhjc bfsdhjc = this.bfsdhjcService.queryBfsdhjcOne(onlineUser.getDatabase(), bfqdpzJl.getMid(), bfqdpzJl.getCid(), bfqdpzJl.getQddate());
                    List<SysBfxgPic> bfsdhjcPic1 = null;
                    List<SysBfxgPic> bfsdhjcPic2 = null;
                    if (!StrUtil.isNull(bfsdhjc)) {
                        bfsdhjcPic1 = this.bfxgPicWebService.queryBfxgPicls(onlineUser.getDatabase(), bfsdhjc.getId(), 2, null);
                        for (int i = 0; i < bfsdhjcPic1.size(); i++) {
                            bfpzpicxx pic = new bfpzpicxx();
                            pic.setNm("2生动化检查");
                            pic.setPic(bfsdhjcPic1.get(i).getPic());
                            pic.setPicMin(bfsdhjcPic1.get(i).getPicMini());
                            listpic.add(pic);
                        }
                        bfsdhjcPic2 = this.bfxgPicWebService.queryBfxgPicls(onlineUser.getDatabase(), bfsdhjc.getId(), 3, null);
                        for (int i = 0; i < bfsdhjcPic2.size(); i++) {
                            bfpzpicxx pic = new bfpzpicxx();
                            pic.setNm("2生动化检查");
                            pic.setPic(bfsdhjcPic2.get(i).getPic());
                            pic.setPicMin(bfsdhjcPic2.get(i).getPicMini());
                            listpic.add(pic);
                        }
                    }
                    //3库存检查
                    List<SysBfcljccj> list1 = this.bfcljccjWebService.queryBfcljccjOne(onlineUser.getDatabase(), bfqdpzJl.getMid(), bfqdpzJl.getCid(), bfqdpzJl.getQddate());
                    if (list1.size() > 0) {
                        for (int i = 0; i < list1.size(); i++) {
                            List<SysBfxgPic> cljccjPic4 = this.bfxgPicWebService.queryBfxgPicls(onlineUser.getDatabase(), list1.get(i).getId(), 4, null);
                            for (int j = 0; j < cljccjPic4.size(); j++) {
                                bfpzpicxx pic = new bfpzpicxx();
                                pic.setNm("3库存检查");
                                pic.setPic(cljccjPic4.get(j).getPic());
                                pic.setPicMin(cljccjPic4.get(j).getPicMini());
                                listpic.add(pic);
                            }
                        }
                    }
                    //4道谢并告知下次拜访
                    SysBfgzxc bfgzxc = this.bfgzxcWebService.queryBfgzxcOne(onlineUser.getDatabase(), bfqdpzJl.getMid(), bfqdpzJl.getCid(), bfqdpzJl.getQddate());
                    List<SysBfxgPic> bfgzxcPic = null;
                    if (!StrUtil.isNull(bfgzxc)) {
                        bfgzxcPic = this.bfxgPicWebService.queryBfxgPicls(onlineUser.getDatabase(), bfgzxc.getId(), 5, null);
                        for (int i = 0; i < bfgzxcPic.size(); i++) {
                            bfpzpicxx pic = new bfpzpicxx();
                            pic.setNm("4告知下次拜访");
                            pic.setPic(bfgzxcPic.get(i).getPic());
                            pic.setPicMin(bfgzxcPic.get(i).getPicMini());
                            listpic.add(pic);
                        }
                        bfqdpzJl.setBcbfzj(bfgzxc.getBcbfzj());
                        if (!StrUtil.isNull(bfqdpzJl.getLongitude())) {
                            if (!bfqdpzJl.getLongitude().equals("null")) {
                                if (!StrUtil.isNull(customer.getLongitude())) {
                                    if (!customer.getLongitude().equals("null")) {
                                        bfqdpzJl.setJlm(StrUtil.GetDistancePJZ(Double.parseDouble(customer.getLongitude()), Double.parseDouble(customer.getLatitude()), Double.parseDouble(bfqdpzJl.getLongitude()), Double.parseDouble(bfqdpzJl.getLatitude()), Double.parseDouble(bfgzxc.getLongitude()), Double.parseDouble(bfgzxc.getLatitude())));
                                    }
                                }
                            }
                        } else {
                            bfqdpzJl.setJlm(0);
                        }
                        bfqdpzJl.setQddate(bfqdpzJl.getQddate() + " " + bfqdpzJl.getQdtime() + "-" + bfgzxc.getDdtime());
                        //时长
                        DateFormat df = new SimpleDateFormat("HH:mm:ss");
                        Date d1 = df.parse(bfgzxc.getDdtime());
                        Date d2 = df.parse(bfqdpzJl.getQdtime());
                        long diff = d1.getTime() - d2.getTime();
                        long hour = (diff / (60 * 60 * 1000) - 0 * 24);
                        long min = ((diff / (60 * 1000)) - 0 * 24 * 60 - hour * 60);
                        long s = (diff / 1000 - 0 * 24 * 60 * 60 - hour * 60 * 60 - min * 60);
                        bfqdpzJl.setQdtime(hour + ":" + min + ":" + s);
                        bfqdpzJl.setVoiceTime(StrUtil.isNull(bfgzxc.getVoiceTime()) ? 0 : bfgzxc.getVoiceTime());
                        bfqdpzJl.setVoiceUrl(StrUtil.isNull(bfgzxc.getVoiceUrl()) ? "" : bfgzxc.getVoiceUrl());
                        bfqdpzJl.setLongitude2(bfgzxc.getLongitude());
                        bfqdpzJl.setLatitude2(bfgzxc.getLatitude());
                    } else {
                        bfqdpzJl.setBcbfzj("");
                        if (!StrUtil.isNull(bfqdpzJl.getLongitude())) {
                            if (!bfqdpzJl.getLongitude().equals("null")) {
                                if (!StrUtil.isNull(customer.getLongitude())) {
                                    if (!customer.getLongitude().equals("null")) {
                                        bfqdpzJl.setJlm(StrUtil.GetDistancePJZ(Double.parseDouble(customer.getLongitude()), Double.parseDouble(customer.getLatitude()), Double.parseDouble(bfqdpzJl.getLongitude()), Double.parseDouble(bfqdpzJl.getLatitude()), null, null));
                                    }
                                }
                            }
                        } else {
                            bfqdpzJl.setJlm(0);
                        }
                        bfqdpzJl.setQddate(bfqdpzJl.getQddate() + " " + bfqdpzJl.getQdtime());
                        bfqdpzJl.setQdtime("");
                        bfqdpzJl.setVoiceTime(0);
                        bfqdpzJl.setVoiceUrl("");
                        bfqdpzJl.setLongitude2("");
                        bfqdpzJl.setLatitude2("");
                    }
                    bfqdpzJl.setListpic(listpic);


                }else if(2 == bfqdpzJl.getType()){
                    //打卡查询
                    List<SysSignDetail> detailList = this.bfqdpzWebService.querySignInDetailList(onlineUser.getDatabase(), bfqdpzJl.getId());
                    List<bfpzpicxx> picList = new ArrayList<>();
                    if(detailList != null ){
                        for (SysSignDetail detail : detailList) {
                            if (detail.getObjType().intValue() == 1) {
                                bfqdpzJl.setVoiceUrl(detail.getPic());
                                continue;
                            }
                            bfpzpicxx pic = new bfpzpicxx();
                            pic.setPic(detail.getPic());
                            pic.setPicMin(detail.getPicMini());
                            picList.add(pic);
                        }
                    }
                    bfqdpzJl.setListpic(picList);
                }

            }
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "获取拜访客户信息列表成功");
            json.put("pageNo", pageNo);
            json.put("pageSize", pageSize);
            json.put("total", p.getTotal());
            json.put("totalPage", p.getTotalPage());
            json.put("rows", p.getRows());
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            e.printStackTrace();
            this.sendWarm(response, "获取拜访客户信息列表失败");
        }
    }



}
