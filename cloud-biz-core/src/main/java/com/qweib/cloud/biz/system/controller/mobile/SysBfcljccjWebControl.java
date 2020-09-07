package com.qweib.cloud.biz.system.controller.mobile;


import com.qweib.cloud.biz.system.BaseWebService;
import com.qweib.cloud.biz.system.TokenServer;
import com.qweib.cloud.biz.system.UploadFile;
import com.qweib.cloud.biz.system.service.SysCljccjMdService;
import com.qweib.cloud.biz.system.service.ws.SysBfcljccjWebService;
import com.qweib.cloud.biz.system.service.ws.SysBfxgPicWebService;
import com.qweib.cloud.core.domain.*;
import com.qweib.cloud.core.exception.BizException;
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
public class SysBfcljccjWebControl extends BaseWebService {
    @Resource
    private SysBfcljccjWebService bfcljccjWebService;
    @Resource
    private SysBfxgPicWebService bfxgPicWebService;
    @Resource
    private SysCljccjMdService cljccjMdService;

    /**
     * 说明：添加库存检查
     */
    @TokenCheckTag
    @ResponseBody
    @RequestMapping("addBfcljccjWeb")
    public Map<String, Object> addBfcljccjWeb(HttpServletResponse response, HttpServletRequest request, String token, Integer cid, String xxjh, String date) {
        if (StrUtil.isNull(date)) {
            date = new SimpleDateFormat("yyyy-MM-dd").format(new Date());
        }
        OnlineMessage message = TokenServer.tokenCheck(token);
        OnlineUser onlineUser = message.getOnlineMember();
        List<SysBfcljccj> bfcljccjLs = new ArrayList<SysBfcljccj>();
        List<SysBfxgPic> bfxgPicLs = new ArrayList<SysBfxgPic>();
        net.sf.json.JSONArray jsonarray = net.sf.json.JSONArray.fromObject(xxjh);
        int len = jsonarray.size();
        if (len > 0) {
            for (int j = 0; j < len; j++) {
                net.sf.json.JSONObject json = (net.sf.json.JSONObject) jsonarray.get(j);
                SysBfcljccj bfcljccj = new SysBfcljccj();
                bfcljccj.setCid(cid);
                bfcljccj.setCjdate(date);
                bfcljccj.setDjpms(json.get("djpms").toString());
                bfcljccj.setHjpms(json.get("hjpms").toString());
                bfcljccj.setMdid(Integer.valueOf(json.get("mdid").toString()));
                bfcljccj.setMid(onlineUser.getMemId());
                bfcljccj.setRemo(json.get("remo").toString());
                bfcljccj.setSytwl(json.get("sytwl").toString());
                bfcljccj.setBds(json.get("bds").toString());
                bfcljccjLs.add(bfcljccj);
                //使用request取
                Map<String, Object> map1 = UploadFile.updatePhotosdg(request, onlineUser.getDatabase(), "bfkh/cljccj", 1, json.get("mdid").toString());
                if ("1".equals(map1.get("state"))) {
                    if ("1".equals(map1.get("ifImg"))) {//是否有图片
                        List<String> pic = (List<String>) map1.get("fileNames");
                        List<String> picMini = (List<String>) map1.get("smallFile");
                        for (int i = 0; i < pic.size(); i++) {
                            SysBfxgPic btp = new SysBfxgPic();
                            btp.setPicMini(picMini.get(i));
                            btp.setPic(pic.get(i));
                            btp.setXxId(Integer.valueOf(json.get("mdid").toString()));
                            bfxgPicLs.add(btp);
                        }
                    }
                } else {
                    throw new BizException("图片上传失败");
                }
            }

        }
        this.bfcljccjWebService.addBfcljccj(bfcljccjLs, bfxgPicLs, onlineUser.getDatabase());
        Map<String,Object> json = new HashMap<>();
        json.put("state", true);
        json.put("msg", "添加库存检查成功");
        return json;
    }

    /**
     * 说明：修改库存检查
     *
     * @创建：作者:llp 创建时间：2016-3-25
     * @修改历史： [序号](llp 2016 - 3 - 25)<修改说明>
     */
    @RequestMapping("updateBfcljccjWeb")
    public void updateBfcljccjWeb(HttpServletResponse response, HttpServletRequest request, String token, Integer cid, String xxjh, String date) {
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
            List<SysBfcljccj> bfcljccjLs = new ArrayList<SysBfcljccj>();
            List<SysBfxgPic> bfxgPicLs = new ArrayList<SysBfxgPic>();
            net.sf.json.JSONArray jsonarray = net.sf.json.JSONArray.fromObject(xxjh);
            int len = jsonarray.size();
            if (len > 0) {
                for (int j = 0; j < len; j++) {
                    net.sf.json.JSONObject json = (net.sf.json.JSONObject) jsonarray.get(j);
                    SysBfcljccj bfcljccj = new SysBfcljccj();
                    bfcljccj.setCid(cid);
                    bfcljccj.setId(Integer.valueOf(json.get("id").toString()));
                    bfcljccj.setCjdate(date);
                    bfcljccj.setDjpms(json.get("djpms").toString());
                    bfcljccj.setHjpms(json.get("hjpms").toString());
                    bfcljccj.setMdid(Integer.valueOf(json.get("mdid").toString()));
                    bfcljccj.setMid(onlineUser.getMemId());
                    bfcljccj.setRemo(json.get("remo").toString());
                    bfcljccj.setSytwl(json.get("sytwl").toString());
                    bfcljccj.setBds(json.get("bds").toString());
                    bfcljccjLs.add(bfcljccj);
                    //使用request取
                    Map<String, Object> map1 = UploadFile.updatePhotosdg(request, onlineUser.getDatabase(), "bfkh/cljccj", 1, json.get("mdid").toString());
                    if ("1".equals(map1.get("state"))) {
                        if ("1".equals(map1.get("ifImg"))) {//是否有图片
                            SysBfxgPic btp = new SysBfxgPic();
                            List<String> pic = (List<String>) map1.get("fileNames");
                            List<String> picMini = (List<String>) map1.get("smallFile");
                            for (int i = 0; i < pic.size(); i++) {
                                btp = new SysBfxgPic();
                                btp.setPicMini(picMini.get(i));
                                btp.setPic(pic.get(i));
                                btp.setXxId(Integer.valueOf(json.get("mdid").toString()));
                                bfxgPicLs.add(btp);
                            }
                        }
                    } else {
                        sendWarm(response, "图片上传失败");
                        return;
                    }
                }

            }
            this.bfcljccjWebService.updateBfcljccj(bfcljccjLs, bfxgPicLs, onlineUser.getDatabase());
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "修改库存检查成功");
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            log.error("修改库存检查失败", e);
            this.sendWarm(response, "修改库存检查失败");
        }
    }

    /**
     * 说明：获取库存检查模板
     *
     * @创建：作者:llp 创建时间：2016-3-25
     * @修改历史： [序号](llp 2016 - 3 - 25)<修改说明>
     */
    @RequestMapping("queryCljccjMdlsWeb")
    public void queryCljccjMdlsWeb(HttpServletResponse response, HttpServletRequest request, String token) {
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
            List<SysCljccjMd> list = this.cljccjMdService.queryCljccjMdls(onlineUser.getDatabase());
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "获取库存检查模板成功");
            json.put("list", list);
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            log.error("获取库存检查模板失败", e);
            this.sendWarm(response, "获取库存检查模板失败");
        }
    }

    /**
     * 说明：获取库存检查信息
     *
     * @创建：作者:llp 创建时间：2016-3-24
     * @修改历史： [序号](llp 2016 - 3 - 24)<修改说明>
     */
    @RequestMapping("queryBfcljccjWeb")
    public void queryBfcljccjWeb(HttpServletResponse response, HttpServletRequest request, String token, Integer cid, String date) {
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
            List<SysBfcljccj> list = this.bfcljccjWebService.queryBfcljccjOne(onlineUser.getDatabase(), onlineUser.getMemId(), cid, date);
            for (int i = 0; i < list.size(); i++) {
                list.get(i).setBfxgPicLs(this.bfxgPicWebService.queryBfxgPicls(onlineUser.getDatabase(), list.get(i).getId(), 4, null));
            }
            JSONObject json = new JSONObject();
            if (list.size() > 0) {
                json.put("state", true);
                json.put("msg", "获取库存检查信息成功");
                json.put("list", list);
            } else {
                json.put("state", false);
                json.put("msg", "暂无记录");
            }
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            log.error("获取库存检查信息失败", e);
            this.sendWarm(response, "获取库存检查信息失败");
        }
    }
}
