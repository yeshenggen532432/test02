package com.qweib.cloud.biz.system.controller.mobile;


import com.qweib.cloud.biz.system.BaseWebService;
import com.qweib.cloud.biz.system.TokenServer;
import com.qweib.cloud.biz.system.service.SysKhfbszService;
import com.qweib.cloud.biz.system.service.ws.SysBflsmWebService;
import com.qweib.cloud.core.domain.OnlineMessage;
import com.qweib.cloud.core.domain.SysBfgzxc;
import com.qweib.cloud.core.domain.SysBflsm;
import com.qweib.cloud.core.domain.SysKhfbsz;
import com.qweib.cloud.utils.StrUtil;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.text.SimpleDateFormat;
import java.util.List;

@Controller
@RequestMapping("/web")
public class SysBflsmWebControl extends BaseWebService {
    @Resource
    private SysBflsmWebService bflsmWebService;
    @Resource
    private SysKhfbszService khfbszService;

    /**
     * 说明：根据用户id,日期获取签到信息
     *
     * @创建：作者:llp 创建时间：2016-11-21
     * @修改历史： [序号](llp 2016 - 11 - 21)<修改说明>
     */
    @RequestMapping("queryBflsmweb")
    public void queryBflsmweb(HttpServletResponse response, HttpServletRequest request, String token, Integer mid, String date) {
        try {
            if (!checkParam(response, token, mid, date)) {
                return;
            }
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            List<SysBflsm> list = this.bflsmWebService.queryBflsm(message.getOnlineMember().getDatabase(), mid, date);
            for (int i = 0; i < list.size(); i++) {
                SysBfgzxc bfgzxc = this.bflsmWebService.queryBfgzxcByMCD(message.getOnlineMember().getDatabase(), mid, list.get(i).getCid(), date);
                if (StrUtil.isNull(bfgzxc)) {
                    list.get(i).setTime2("");
                    list.get(i).setYs("蓝色");
                    list.get(i).setFz(0);
                    list.get(i).setVoiceTime(0);
                    list.get(i).setVoiceUrl("");
                } else {
                    if (StrUtil.isNull(bfgzxc.getVoiceUrl())) {
                        list.get(i).setVoiceTime(0);
                        list.get(i).setVoiceUrl("");
                    } else {
                        list.get(i).setVoiceTime(bfgzxc.getVoiceTime());
                        list.get(i).setVoiceUrl(bfgzxc.getVoiceUrl());
                    }
                    list.get(i).setTime2(bfgzxc.getDdtime());
                    SysKhfbsz khfbsz = this.khfbszService.queryKhfbszByFz(getYs(list.get(i).getTime1(), bfgzxc.getDdtime()).intValue(), message.getOnlineMember().getDatabase());
                    if (StrUtil.isNull(khfbsz)) {
                        list.get(i).setYs("蓝色");
                    } else {
                        list.get(i).setYs(khfbsz.getYsz());
                    }
                    list.get(i).setFz(getYs(list.get(i).getTime1(), bfgzxc.getDdtime()).intValue());
                }
            }
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "获取拜访客户轨迹成功");
            json.put("list", list);
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            this.sendWarm(response, "获取拜访客户轨迹失败");
        }
    }

    private Long getYs(String stime, String etime) {
        Long min = null;
        try {
            SimpleDateFormat df = new SimpleDateFormat("HH:mm:ss");
            java.util.Date now = df.parse(etime);
            java.util.Date date = df.parse(stime);
            Long l = now.getTime() - date.getTime();
            Long day = l / (24 * 60 * 60 * 1000);
            Long hour = (l / (60 * 60 * 1000) - day * 24);
            min = ((l / (60 * 1000)) - day * 24 * 60 - hour * 60) + hour * 60;
        } catch (Exception e) {
            // TODO: handle exception
        }
        return min;
    }

    public static void main(String[] args) {
        try {
            SimpleDateFormat df = new SimpleDateFormat("HH:mm:ss");
            java.util.Date now = df.parse("13:59:40");
            java.util.Date date = df.parse("13:30:24");
            Long l = now.getTime() - date.getTime();
            Long day = l / (24 * 60 * 60 * 1000);
            Long hour = (l / (60 * 60 * 1000) - day * 24);
            Long min = ((l / (60 * 1000)) - day * 24 * 60 - hour * 60) + hour * 60;
        } catch (Exception e) {
            // TODO: handle exception
        }
    }
}
