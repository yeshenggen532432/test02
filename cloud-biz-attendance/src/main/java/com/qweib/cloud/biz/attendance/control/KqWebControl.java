package com.qweib.cloud.biz.attendance.control;

import com.qweib.cloud.biz.attendance.model.KqBc;
import com.qweib.cloud.biz.attendance.service.KqBcService;
import com.qweib.cloud.biz.system.BaseWebService;
import com.qweib.cloud.biz.system.TokenServer;
import com.qweib.cloud.core.domain.OnlineMessage;
import com.qweib.cloud.core.domain.OnlineUser;
import com.qweib.cloud.utils.Page;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@Controller
@RequestMapping("/web")
public class KqWebControl extends BaseWebService {

    @Resource
    private KqBcService bcService;


    @RequestMapping("queryBcList")
    public void queryBcList(HttpServletResponse response, HttpServletRequest request, String token) {
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
            Integer page = 1;
            Integer rows = 9999;

            KqBc bc = new KqBc();
            bc.setStatus(1);
            Page p = this.bcService.queryKqBc(bc, onlineUser.getDatabase(), page, rows);
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("total", p.getTotal());
            json.put("rows", p.getRows());

            this.sendJsonResponse(response, json.toString());
            p = null;


        } catch (Exception e) {
            this.sendWarm(response, "查询班次失败");
        }
    }


    @RequestMapping("updateBcPosition")
    public void updateBcPosition(HttpServletResponse response, HttpServletRequest request, String token, KqBc bc) {
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
            JSONObject json = new JSONObject();

            KqBc bc1 = this.bcService.getKqBcById(bc.getId(), onlineUser.getDatabase());
            if (bc1 == null) {
                json.put("state", false);
                json.put("msg", "班次不存在");
                this.sendJsonResponse(response, json.toString());
                return;

            }
            bc1.setLatitude(bc.getLatitude());
            bc1.setLongitude(bc.getLongitude());
            bc1.setAreaLong(bc.getAreaLong());
            bc1.setOutOf(bc.getOutOf());
            bc1.setAddress(bc.getAddress());
            int ret = this.bcService.updateKqBc(bc1, onlineUser.getDatabase());
            if (ret == 0) {
                json.put("state", false);
                json.put("msg", "保存失败");
                this.sendJsonResponse(response, json.toString());
                return;
            }
            json.put("state", true);
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            this.sendWarm(response, "修改班次失败");
        }
    }
}
