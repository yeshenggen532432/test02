package com.qweib.cloud.biz.system.controller.mobile;


import com.qweib.cloud.biz.system.BaseWebService;
import com.qweib.cloud.biz.system.TokenServer;
import com.qweib.cloud.biz.system.UploadFile;
import com.qweib.cloud.biz.system.service.SysCustomerService;
import com.qweib.cloud.biz.system.service.ws.SysBfgzxcWebService;
import com.qweib.cloud.biz.system.service.ws.SysBfxgPicWebService;
import com.qweib.cloud.biz.system.service.ws.SysCustomerWebService;
import com.qweib.cloud.core.domain.*;
import com.qweib.cloud.core.exception.BizException;
import com.qweib.cloud.utils.DateTimeUtil;
import com.qweib.cloud.utils.StrUtil;
import com.qweibframework.commons.redis.token.TokenCheckTag;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.text.SimpleDateFormat;
import java.util.*;

@Controller
@RequestMapping("/web")
public class SysBfgzxcWebControl extends BaseWebService {
    @Resource
    private SysBfgzxcWebService bfgzxcWebService;
    @Resource
    private SysBfxgPicWebService bfxgPicWebService;
    @Resource
    private SysCustomerWebService customerWebService;
    @Resource
    private SysCustomerService customerService;

    /**
     * 说明：添加道谢并告知下次拜访
     */
    @TokenCheckTag
    @ResponseBody
    @RequestMapping("addBfgzxcWeb")
    public Map<String, Object> addBfgzxcWeb(HttpServletResponse response, HttpServletRequest request, String token, Integer cid, String xsjdNm, String bfflNm,
                                            String bcbfzj, String dbsx, String xcdate, String longitude, String latitude, String address, String date, Integer voiceTime) throws Exception {
        if (StrUtil.isNull(date)) {
            date = new SimpleDateFormat("yyyy-MM-dd").format(new Date());
        }
        OnlineMessage message = TokenServer.tokenCheck(token);
        OnlineUser onlineUser = message.getOnlineMember();
        SysBfgzxc bfgzxc = new SysBfgzxc();
        bfgzxc.setBcbfzj(bcbfzj);
        bfgzxc.setCid(cid);
        bfgzxc.setDbsx(dbsx);
        bfgzxc.setDdtime(DateTimeUtil.getDateToStr(new Date(), "HH:mm:ss"));
        bfgzxc.setDqdate(date);
        bfgzxc.setMid(onlineUser.getMemId());
        bfgzxc.setXcdate(xcdate);
        bfgzxc.setLatitude(latitude);
        bfgzxc.setLongitude(longitude);
        bfgzxc.setAddress(address);
        if (!StrUtil.isNull(voiceTime)) {
            bfgzxc.setVoiceTime(voiceTime);
            bfgzxc.setVoiceUrl(UploadFile.saveBfVoice(request, response, onlineUser.getDatabase()));
        }
        List<SysBfxgPic> bfxgPicLs = new ArrayList<SysBfxgPic>();
        //使用request取
        Map<String, Object> map = UploadFile.updatePhotos(request, onlineUser.getDatabase(), "bfkh/gzxc", 1);
        if ("1".equals(map.get("state"))) {
            if ("1".equals(map.get("ifImg"))) {//是否有图片
                SysBfxgPic btp = new SysBfxgPic();
                List<String> pic = (List<String>) map.get("fileNames");
                List<String> picMini = (List<String>) map.get("smallFile");
                for (int i = 0; i < pic.size(); i++) {
                    btp = new SysBfxgPic();
                    btp.setPicMini(picMini.get(i));
                    btp.setPic(pic.get(i));
                    bfxgPicLs.add(btp);
                }
            }
        } else {
            throw new BizException("图片上传失败");
        }
        this.customerWebService.updateCustomerZF(onlineUser.getDatabase(), xsjdNm, bfflNm, cid);
        this.bfgzxcWebService.addBfgzxc(bfgzxc, bfxgPicLs, onlineUser.getDatabase());
        Map<String,Object> json = new HashMap<>();
        json.put("state", true);
        json.put("msg", "添加道谢并告知下次拜访成功");
        return json;
    }

    /**
     * 说明：修改道谢并告知下次拜访
     *
     * @创建：作者:llp 创建时间：2016-3-28
     * @修改历史： [序号](llp 2016 - 3 - 28)<修改说明>
     */
    @RequestMapping("updateBfgzxcWeb")
    public void updateBfgzxcWeb(HttpServletResponse response, HttpServletRequest request, String token, Integer id, Integer cid, String xsjdNm, String bfflNm,
                                String bcbfzj, String dbsx, String xcdate, String longitude, String latitude, String address, String date, Integer voiceTime) {
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
            SysBfgzxc bfgzxc = this.bfgzxcWebService.queryBfgzxcById(onlineUser.getDatabase(), id);
//            SysBfgzxc bfgzxc = new SysBfgzxc();
            bfgzxc.setId(id);
            bfgzxc.setBcbfzj(bcbfzj);
            bfgzxc.setCid(cid);
            bfgzxc.setDbsx(dbsx);
//            bfgzxc.setDdtime(DateTimeUtil.getDateToStr(new Date(), "HH:mm:ss"));
//            bfgzxc.setDqdate(date);
//            bfgzxc.setLatitude(latitude);
//            bfgzxc.setLongitude(longitude);
//            bfgzxc.setAddress(address);
            bfgzxc.setMid(onlineUser.getMemId());
            bfgzxc.setXcdate(xcdate);
            if (!StrUtil.isNull(voiceTime)) {
                bfgzxc.setVoiceTime(voiceTime);
                bfgzxc.setVoiceUrl(UploadFile.saveBfVoice(request, response, onlineUser.getDatabase()));
            }
            List<SysBfxgPic> bfxgPicLs = new ArrayList<SysBfxgPic>();
            //使用request取
            Map<String, Object> map = UploadFile.updatePhotos(request, onlineUser.getDatabase(), "bfkh/gzxc", 1);
            if ("1".equals(map.get("state"))) {
                if ("1".equals(map.get("ifImg"))) {//是否有图片
                    SysBfxgPic btp = new SysBfxgPic();
                    List<String> pic = (List<String>) map.get("fileNames");
                    List<String> picMini = (List<String>) map.get("smallFile");
                    for (int i = 0; i < pic.size(); i++) {
                        btp = new SysBfxgPic();
                        btp.setPicMini(picMini.get(i));
                        btp.setPic(pic.get(i));
                        bfxgPicLs.add(btp);
                    }
                }
            } else {
                sendWarm(response, "图片上传失败");
                return;
            }
            this.customerWebService.updateCustomerZF(onlineUser.getDatabase(), xsjdNm, bfflNm, cid);
            this.bfgzxcWebService.updateBfgzxc(bfgzxc, bfxgPicLs, onlineUser.getDatabase());
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "修改道谢并告知下次拜访成功");
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            log.error("修改道谢并告知下次拜访失败", e);
            this.sendWarm(response, "修改道谢并告知下次拜访失败");
        }
    }

    /**
     * 说明：获取道谢并告知下次拜访信息
     *
     * @创建：作者:llp 创建时间：2016-3-28
     * @修改历史： [序号](llp 2016 - 3 - 28)<修改说明>
     */
    @RequestMapping("queryBfgzxcWeb")
    public void queryBfgzxcWeb(HttpServletResponse response, HttpServletRequest request, String token, Integer cid, String date) {
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
            SysBfgzxc bfgzxc = this.bfgzxcWebService.queryBfgzxcOne(onlineUser.getDatabase(), onlineUser.getMemId(), cid, date);
            SysCustomer customer = this.customerService.queryCustomerById(onlineUser.getDatabase(), cid);
            JSONObject json = new JSONObject();
            if (!StrUtil.isNull(bfgzxc)) {
                List<SysBfxgPic> list = this.bfxgPicWebService.queryBfxgPicls(onlineUser.getDatabase(), bfgzxc.getId(), 5, null);
                json.put("state", true);
                json.put("msg", "获取道谢并告知下次拜访信息成功");
                json.put("xsjdNm", customer.getXsjdNm());
                json.put("bfflNm", customer.getBfflNm());
                json.put("id", bfgzxc.getId());
                json.put("cid", bfgzxc.getCid());
                json.put("bcbfzj", bfgzxc.getBcbfzj());
                json.put("dbsx", bfgzxc.getDbsx());
                json.put("xcdate", bfgzxc.getXcdate());
                json.put("longitude", bfgzxc.getLongitude());
                json.put("latitude", bfgzxc.getLatitude());
                json.put("address", bfgzxc.getAddress());
                json.put("voiceUrl", bfgzxc.getVoiceUrl());
                json.put("voiceTime", bfgzxc.getVoiceTime());
                json.put("list", list);
            } else {
                json.put("state", false);
                json.put("msg", "暂无记录");
                json.put("xsjdNm", customer.getXsjdNm());
                json.put("bfflNm", customer.getBfflNm());
            }
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            log.error("获取道谢并告知下次拜访信息失败", e);
            this.sendWarm(response, "获取道谢并告知下次拜访信息失败");
        }
    }
}
