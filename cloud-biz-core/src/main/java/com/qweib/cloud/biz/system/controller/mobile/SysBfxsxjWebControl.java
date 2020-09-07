package com.qweib.cloud.biz.system.controller.mobile;


import com.qweib.cloud.biz.system.BaseWebService;
import com.qweib.cloud.biz.system.TokenServer;
import com.qweib.cloud.biz.system.service.ws.SysBfxsxjWebService;
import com.qweib.cloud.core.domain.OnlineMessage;
import com.qweib.cloud.core.domain.OnlineUser;
import com.qweib.cloud.core.domain.SysBfxsxj;
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
public class SysBfxsxjWebControl extends BaseWebService {
    @Resource
    private SysBfxsxjWebService bfxsxjWebService;

    /**
     * 说明：添加销售小结
     */
    @TokenCheckTag
    @ResponseBody
    @RequestMapping("addBfxsxjWeb")
    public Map<String, Object> addBfxsxjWeb(HttpServletResponse response, HttpServletRequest request, String token, Integer cid, String xsxj, String date) {
        if (StrUtil.isNull(date)) {
            date = new SimpleDateFormat("yyyy-MM-dd").format(new Date());
        }
        OnlineMessage message = TokenServer.tokenCheck(token);
        OnlineUser onlineUser = message.getOnlineMember();
        List<SysBfxsxj> bfxsxjLs = new ArrayList<SysBfxsxj>();
        net.sf.json.JSONArray jsonarray = net.sf.json.JSONArray.fromObject(xsxj);
        int len = jsonarray.size();
        if (!StrUtil.isNull(xsxj)) {
            if (len > 0) {
                for (int j = 0; j < len; j++) {
                    net.sf.json.JSONObject json = (net.sf.json.JSONObject) jsonarray.get(j);
                    SysBfxsxj bfxsxj = new SysBfxsxj();
                    bfxsxj.setCid(cid);
                    bfxsxj.setWid(Integer.valueOf(json.get("wid").toString()));
                    bfxsxj.setDhNum(Integer.valueOf(json.get("dhNum").toString().equals("") ? "0" : json.get("dhNum").toString()));
                    bfxsxj.setSxNum(Integer.valueOf(json.get("sxNum").toString().equals("") ? "0" : json.get("sxNum").toString()));
                    bfxsxj.setKcNum(Integer.valueOf(json.get("kcNum").toString().equals("") ? "0" : json.get("kcNum").toString()));
                    bfxsxj.setDdNum(Integer.valueOf(json.get("ddNum").toString().equals("") ? "0" : json.get("ddNum").toString()));
                    bfxsxj.setXxd(Integer.valueOf(json.get("xxd").toString().equals("") ? "0" : json.get("xxd").toString()));
                    bfxsxj.setXjdate(date);
                    bfxsxj.setMid(onlineUser.getMemId());
                    bfxsxj.setXstp(json.get("xstp").toString());
                    bfxsxj.setRemo(json.get("remo").toString());
                    bfxsxjLs.add(bfxsxj);
                }
            }
        }
        this.bfxsxjWebService.addBfxsxj(bfxsxjLs, onlineUser.getDatabase());
        Map<String,Object> json = new HashMap<>();
        json.put("state", true);
        json.put("msg", "添加销售小结成功");
        return json;
    }

    /**
     * 说明：修改销售小结
     *
     * @创建：作者:llp 创建时间：2016-3-28
     * @修改历史： [序号](llp 2016 - 3 - 28)<修改说明>
     */
    @RequestMapping("updateBfxsxjWeb")
    public void updateBfxsxjWeb(HttpServletResponse response, HttpServletRequest request, String token, Integer cid, String xsxj, String date) {
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
            this.bfxsxjWebService.deleteBfxsxj(onlineUser.getDatabase(), onlineUser.getMemId(), cid);
            List<SysBfxsxj> bfxsxjLs = new ArrayList<SysBfxsxj>();
            net.sf.json.JSONArray jsonarray = net.sf.json.JSONArray.fromObject(xsxj);
            int len = jsonarray.size();
            if (!StrUtil.isNull(xsxj)) {
                if (len > 0) {
                    for (int j = 0; j < len; j++) {
                        net.sf.json.JSONObject json = (net.sf.json.JSONObject) jsonarray.get(j);
                        SysBfxsxj bfxsxj = new SysBfxsxj();
                        bfxsxj.setCid(cid);
                        bfxsxj.setWid(Integer.valueOf(json.get("wid").toString()));
                        bfxsxj.setDhNum(Integer.valueOf(json.get("dhNum").toString().equals("") ? "0" : json.get("dhNum").toString()));
                        bfxsxj.setSxNum(Integer.valueOf(json.get("sxNum").toString().equals("") ? "0" : json.get("sxNum").toString()));
                        bfxsxj.setKcNum(Integer.valueOf(json.get("kcNum").toString().equals("") ? "0" : json.get("kcNum").toString()));
                        bfxsxj.setDdNum(Integer.valueOf(json.get("ddNum").toString().equals("") ? "0" : json.get("ddNum").toString()));
                        bfxsxj.setXxd(Integer.valueOf(json.get("xxd").toString().equals("") ? "0" : json.get("xxd").toString()));
                        bfxsxj.setXjdate(date);
                        bfxsxj.setMid(onlineUser.getMemId());
                        bfxsxj.setXstp(json.get("xstp").toString());
                        bfxsxj.setRemo(json.get("remo").toString());
                        bfxsxjLs.add(bfxsxj);
                    }
                }
            }
            this.bfxsxjWebService.addBfxsxj(bfxsxjLs, onlineUser.getDatabase());
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "修改销售小结成功");
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            this.sendWarm(response, "修改销售小结失败");
        }
    }

    /**
     * 说明：获取销售小结
     *
     * @创建：作者:llp 创建时间：2016-3-28
     * @修改历史： [序号](llp 2016 - 3 - 28)<修改说明>
     */
    @RequestMapping("queryBfxsxjlsWeb")
    public void queryBfxsxjlsWeb(HttpServletResponse response, HttpServletRequest request, String token, Integer cid, String date) {
        try {
            if (!checkParam(response, token)) {
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
            List<SysBfxsxj> list = this.bfxsxjWebService.queryBfxsxjOne(onlineUser.getDatabase(), onlineUser.getMemId(), cid, date);
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "获取销售小结信息成功");
            json.put("list", list);
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            this.sendWarm(response, "获取销售小结信息失败");
        }
    }

    public static void main(String[] args) {
        int a = 15;
        System.out.println("一");
        for (int i = 0; i < a; i++) {
            if ((i + 1) % 4 == 0) {
                System.out.println(i);
                System.out.println("二");
                System.out.println("一");
            } else {
                System.out.println(i);
            }
        }
        System.out.println("二");
    }
}
