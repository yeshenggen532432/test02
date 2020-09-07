package com.qweib.cloud.biz.system.controller.mobile;


import com.qweib.cloud.biz.system.BaseWebService;
import com.qweib.cloud.biz.system.TokenServer;
import com.qweib.cloud.biz.system.service.ws.SysYfilepwdWebService;
import com.qweib.cloud.core.domain.OnlineMessage;
import com.qweib.cloud.core.domain.OnlineUser;
import com.qweib.cloud.core.domain.SysYfilepwd;
import com.qweib.cloud.utils.StrUtil;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;

@Controller
@RequestMapping("/web")
public class SysYfilepwdWebControl extends BaseWebService {
    @Resource
    private SysYfilepwdWebService sysYfilepwdWebService;

    /**
     * 说明：添加云文件密码
     *
     * @创建：作者:llp 创建时间：2016-11-18
     * @修改历史： [序号](llp 2016 - 11 - 18)<修改说明>
     */
    @RequestMapping("addYfilepwd")
    public void addYfilepwd(HttpServletResponse response, String token, String yfPwd) {
        try {
            if (!checkParam(response, token, yfPwd)) {
                return;
            }
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            OnlineUser onlineUser = message.getOnlineMember();
            SysYfilepwd Yfilepwd = new SysYfilepwd();
            Yfilepwd.setMemberId(onlineUser.getMemId());
            Yfilepwd.setYfPwd(yfPwd);
            this.sysYfilepwdWebService.addYfilepwd(Yfilepwd, onlineUser.getDatabase());
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "添加云文件密码成功");
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            this.sendWarm(response, "添加云文件密码失败");
        }
    }

    /**
     * 说明：修改云文件密码
     *
     * @创建：作者:llp 创建时间：：2016-11-18
     * @修改历史： [序号](llp ： 2016 - 11 - 18)<修改说明>
     */
    @RequestMapping("updateYfilepwd")
    public void updateYfilepwd(HttpServletResponse response, String token, String yfPwd) {
        try {
            if (!checkParam(response, token, yfPwd)) {
                return;
            }
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            OnlineUser onlineUser = message.getOnlineMember();
            this.sysYfilepwdWebService.updateYfilepwd(onlineUser.getDatabase(), yfPwd, onlineUser.getMemId());
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "修改云文件密码成功");
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            this.sendWarm(response, "修改云文件密码失败");
        }
    }

    /**
     * 说明：获取云文件密码
     *
     * @创建：作者:llp 创建时间：2016-11-18
     * @修改历史： [序号](llp 2016 - 11 - 18)<修改说明>
     */
    @RequestMapping("queryYfilepwd")
    public void queryYfilepwd(HttpServletResponse response, String token) {
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
            SysYfilepwd yfilepwd = this.sysYfilepwdWebService.queryYfilepwd(onlineUser.getDatabase(), onlineUser.getMemId());
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "获取云文件密码成功");
            if (StrUtil.isNull(yfilepwd)) {
                json.put("yfPwd", "");
            } else {
                json.put("yfPwd", yfilepwd.getYfPwd());
            }
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            this.sendWarm(response, "获取云文件密码失败");
        }
    }
}
