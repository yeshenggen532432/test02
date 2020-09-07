package com.qweib.cloud.biz.system.controller.mobile;


import com.qweib.cloud.biz.system.BaseWebService;
import com.qweib.cloud.biz.system.TokenServer;
import com.qweib.cloud.biz.system.UploadFile;
import com.qweib.cloud.biz.system.service.SysCustomerTmpService;
import com.qweib.cloud.biz.system.service.ws.BscPlanWebService;
import com.qweib.cloud.biz.system.service.ws.SysBfqdpzWebService;
import com.qweib.cloud.biz.system.service.ws.SysBfxgPicWebService;
import com.qweib.cloud.biz.system.service.ws.SysCustomerWebService;
import com.qweib.cloud.core.domain.OnlineMessage;
import com.qweib.cloud.core.domain.OnlineUser;
import com.qweib.cloud.core.domain.SysBfqdpz;
import com.qweib.cloud.core.domain.SysBfxgPic;
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
public class SysBfqdpzWebControl extends BaseWebService {
    @Resource
    private SysBfqdpzWebService bfqdpzWebService;
    @Resource
    private SysBfxgPicWebService bfxgPicWebService;
    @Resource
    private SysCustomerWebService customerWebService;
    @Resource
    private BscPlanWebService planWebService;

    @Resource
    private SysCustomerTmpService tmpService;

    /**
     * 说明：添加拜访签到拍照
     */
    @TokenCheckTag
    @ResponseBody
    @RequestMapping("addBfqdpzWeb")
    public Map<String, Object> addBfqdpzWeb(HttpServletResponse response, HttpServletRequest request, String token, Integer cid, String longitude, String latitude, String address
            , String hbzt, String ggyy, String isXy, String remo, String date, Integer isTmp) throws Exception {
        if (StrUtil.isNull(date)) {
            date = new SimpleDateFormat("yyyy-MM-dd").format(new Date());
        }
        OnlineMessage message = TokenServer.tokenCheck(token);
        if (message.isSuccess() == false) {
            throw new BizException(message.getMessage());
        }
        if (isTmp == null) isTmp = 0;
        OnlineUser onlineUser = message.getOnlineMember();
        SysBfqdpz bfqdpz1 = this.bfqdpzWebService.queryBfqdpzOne(onlineUser.getDatabase(), onlineUser.getMemId(), cid, date);
        if (!StrUtil.isNull(bfqdpz1)) {
            throw new BizException("不能重复提交");
        }
        //修改拜访计划
        this.planWebService.updateBscPlanWeb(onlineUser.getDatabase(), onlineUser.getMemId(), cid, date);
        this.planWebService.updateBscPlanNewWeb(onlineUser.getDatabase(), onlineUser.getMemId(), cid, date);

        SysBfqdpz bfqdpz = new SysBfqdpz();
        bfqdpz.setAddress(address);
        bfqdpz.setCid(cid);
        bfqdpz.setGgyy(ggyy);
        bfqdpz.setHbzt(hbzt);
        bfqdpz.setIsXy(isXy);
        bfqdpz.setLatitude(latitude);
        bfqdpz.setLongitude(longitude);
        bfqdpz.setMid(onlineUser.getMemId());
        bfqdpz.setQddate(date);
        bfqdpz.setQdtime(DateTimeUtil.getDateToStr(new Date(), "HH:mm:ss"));
        bfqdpz.setRemo(remo);
        List<SysBfxgPic> bfxgPicLs = new ArrayList<SysBfxgPic>();
        //使用request取
        Map<String, Object> map = UploadFile.updatePhotos(request, onlineUser.getDatabase(), "bfkh/qdpz", 1);
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
            throw  new BizException("图片上传失败");
        }
        this.bfqdpzWebService.addBfqdpz(bfqdpz, bfxgPicLs, onlineUser.getDatabase());
        this.customerWebService.updateCustomerScbfDate(onlineUser.getDatabase(), cid);
        Map<String, Object> json = new HashMap<>();
        json.put("state", true);
        json.put("msg", "添加拜访签到拍照成功");
        return  json;
    }

    /**
     * 说明：修改拜访签到拍照
     *
     * @创建：作者:llp 创建时间：2016-3-24
     * @修改历史： [序号](llp 2016 - 3 - 24)<修改说明>
     */
    @RequestMapping("updateBfqdpzWeb")
    public void updateBfqdpzWeb(HttpServletResponse response, HttpServletRequest request, String token, Integer id, Integer cid, String longitude, String latitude, String address
            , String hbzt, String ggyy, String isXy, String remo, String date) {
        try {
            if (!checkParam(response, token, id, cid)) {
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
            SysBfqdpz bfqdpz = this.bfqdpzWebService.queryBfqdpzById(onlineUser.getDatabase(), id);
//			SysBfqdpz bfqdpz =new SysBfqdpz();
            bfqdpz.setId(id);
            bfqdpz.setCid(cid);
            bfqdpz.setGgyy(ggyy);
            bfqdpz.setHbzt(hbzt);
            bfqdpz.setIsXy(isXy);
            bfqdpz.setMid(onlineUser.getMemId());
            //备注：修改时时间和地址不变
            //bfqdpz.setLatitude(latitude);
            //bfqdpz.setLongitude(longitude);
            //bfqdpz.setAddress(address);
            //bfqdpz.setQddate(date);
            //bfqdpz.setQdtime(DateTimeUtil.getDateToStr(new Date(), "HH:mm:ss"));
            bfqdpz.setRemo(remo);
            List<SysBfxgPic> bfxgPicLs = new ArrayList<SysBfxgPic>();
            //使用request取
            Map<String, Object> map = UploadFile.updatePhotos(request, onlineUser.getDatabase(), "bfkh/qdpz", 1);
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
            this.bfqdpzWebService.updateBfqdpz(bfqdpz, bfxgPicLs, onlineUser.getDatabase());
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "修改拜访签到拍照成功");
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            e.printStackTrace();
            log.error("修改拜访签到拍照失败", e);
            this.sendWarm(response, "修改拜访签到拍照失败");
        }
    }

    /**
     * 说明：获取拜访签到拍照
     *
     * @创建：作者:llp 创建时间：2016-3-24
     * @修改历史： [序号](llp 2016 - 3 - 24)<修改说明>
     */
    @RequestMapping("queryBfqdpzWeb")
    public void queryBfqdpzWeb(HttpServletResponse response, HttpServletRequest request, String token, Integer cid, String date, Integer isTmp) {
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
            if (isTmp == null) isTmp = 0;
            OnlineUser onlineUser = message.getOnlineMember();
            SysBfqdpz bfqdpz = this.bfqdpzWebService.queryBfqdpzOne(onlineUser.getDatabase(), onlineUser.getMemId(), cid, date);
            JSONObject json = new JSONObject();
            if (!StrUtil.isNull(bfqdpz)) {
                List<SysBfxgPic> list = this.bfxgPicWebService.queryBfxgPicls(onlineUser.getDatabase(), bfqdpz.getId(), 1, null);
                json.put("state", true);
                json.put("msg", "获取拜访签到拍照信息成功");
                json.put("id", bfqdpz.getId());
                json.put("cid", bfqdpz.getCid());
                json.put("longitude", bfqdpz.getLongitude());
                json.put("latitude", bfqdpz.getLatitude());
                json.put("address", bfqdpz.getAddress());
                json.put("hbzt", bfqdpz.getHbzt());
                json.put("ggyy", bfqdpz.getGgyy());
                json.put("isXy", bfqdpz.getIsXy());
                json.put("remo", bfqdpz.getRemo());
                json.put("list", list);
            } else {
                json.put("state", false);
                json.put("msg", "暂无记录");
            }
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            e.printStackTrace();
            log.error("获取拜访签到拍照信息失败", e);
            this.sendWarm(response, "获取拜访签到拍照信息失败");
        }
    }
}
