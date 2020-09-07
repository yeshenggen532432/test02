package com.qweib.cloud.biz.system.controller;


import com.qweib.cloud.biz.system.BaseWebService;
import com.qweib.cloud.biz.system.TokenServer;
import com.qweib.cloud.biz.system.service.plat.SysVersionService;
import com.qweib.cloud.core.domain.OnlineUser;
import com.qweib.cloud.core.domain.SysVersion;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Objects;

@Controller
@RequestMapping("/web")
public class SysVersionWebService extends BaseWebService {

    @Resource
    private SysVersionService sysVersionService;

    /**
     * @param res
     * @param token
     * @param verSion 0:android	1:ios
     * @说明：版本更新(安卓)
     * @创建者：作者：YJP 创建时间：2014-07-09
     */
    @RequestMapping("updateVerSion")
    public void sysVerSion(HttpServletResponse res, String token, String verSion) {
        OnlineUser loginDto = TokenServer.tokenCheck(token).getOnlineMember();
        if (loginDto == null) {
            sendWarm(res, "请先登录系统");
            return;
        }
        if (null != loginDto.getMemId()) {
            try {
                if (Objects.equals(verSion, "2")) {
                    verSion = "1";
                } else if (Objects.equals(verSion, "4")) {
                    verSion = "0";
                }
                SysVersion appVersionDTO = this.sysVersionService.getLastVersion(verSion);
                if (Objects.nonNull(appVersionDTO)) {
                    JSONObject json = new JSONObject();
                    json.put("state", true);
                    json.put("msg", "请求成功");
                    json.put("version", new JSONObject(appVersionDTO));
                    this.sendJsonResponse(res, json.toString());
                    return;
                } else {
                    JSONObject json = new JSONObject();
                    json.put("state", false);
                    json.put("msg", "暂无更新");
                    this.sendJsonResponse(res, json.toString());
                    return;
                }
            } catch (Exception e) {
                log.error("通知:", e);
                sendException(res, e);
                return;
            }
        } else {
            sendWarm(res, "请先登录系统");
            return;
        }
    }

    /**
     * 到下载页面
     * @param model
     * @param request
     * @param type
     * @return
     * @创建：作者:YYP 创建时间：2015-3-13
     */
    @RequestMapping("/wapdl")
    public String appDownload(Model model, HttpServletRequest request, String type) {
        model.addAttribute("type", type);
        model.addAttribute("android", request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + "/" + request.getContextPath() + "/upload/app/cnlife/CnlifeApp.apk");
        return "mobilePage/load";
    }

    /**
     * 到下载页面（园区）
     * @param model
     * @param request
     * @param type
     * @return
     * @创建：作者:YYP 创建时间：2015-3-13
     */
    @RequestMapping("/yqwapdl")
    public String yqappDownload(Model model, HttpServletRequest request, String type) {
        model.addAttribute("type", type);
        model.addAttribute("android", request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + "/" + request.getContextPath() + "/upload/app/cnlife/CnlifeAppyq.apk");
        return "mobilePage/Appdownload2";
    }
}
