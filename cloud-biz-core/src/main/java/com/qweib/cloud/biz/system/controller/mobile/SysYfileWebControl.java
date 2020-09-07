package com.qweib.cloud.biz.system.controller.mobile;

import com.qweib.cloud.biz.system.BaseWebService;
import com.qweib.cloud.biz.system.TokenServer;
import com.qweib.cloud.biz.system.service.ws.SysYfileWebService;
import com.qweib.cloud.core.domain.OnlineMessage;
import com.qweib.cloud.core.domain.OnlineUser;
import com.qweib.cloud.core.domain.SysYfile;
import com.qweib.cloud.utils.DateTimeUtil;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;
import java.util.Date;

@Controller
@RequestMapping("/web")
public class SysYfileWebControl extends BaseWebService {
    @Resource
    private SysYfileWebService yfileWebService;

    /**
     * 说明：分页查询云文件公司
     *
     * @创建：作者:llp 创建时间：2016-11-04
     * @修改历史： [序号](llp 2016 - 11 - 04)<修改说明>
     */
    @RequestMapping("queryYfileWeb")
    public void queryYfileWeb(HttpServletResponse response, String token, Integer tp2, String fileNm, Integer pid, Integer pageNo, Integer pageSize) {
        try {
            if (!checkParam(response, token, tp2))
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
            Page p = new Page();
            if (tp2 == 1 || tp2 == 3) {
                p = this.yfileWebService.queryYfileWeb(onlineUser.getDatabase(), onlineUser.getMemId(), tp2, fileNm, pid, pageNo, pageSize);
            } else {
                p = this.yfileWebService.queryYfileWeb(onlineUser.getDatabase(), null, 2, fileNm, pid, pageNo, pageSize);
            }
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "获取云文件列表成功");
            json.put("pageNo", pageNo);
            json.put("pageSize", pageSize);
            json.put("total", p.getTotal());
            json.put("totalPage", p.getTotalPage());
            json.put("rows", p.getRows());
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            this.sendWarm(response, "获取云文件列表失败");
        }
    }

    /**
     * 说明：添加云文件
     *
     * @创建：作者:llp 创建时间：2016-11-07
     * @修改历史： [序号](llp 2016 - 11 - 07)<修改说明>
     */
    @RequestMapping("addYfileWeb")
    public void addYfileWeb(HttpServletResponse response, String token, Integer pid, String fileNm, Integer tp2) {
        try {
            if (!checkParam(response, token, fileNm, tp2)) {
                return;
            }
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            OnlineUser onlineUser = message.getOnlineMember();
            for (int i = 0; i < fileNm.split(",").length; i++) {
                int num = this.yfileWebService.queryIsfileNm(onlineUser.getDatabase(), fileNm.split(",")[i], onlineUser.getMemId());
                if (num > 0) {
                    sendWarm(response, fileNm.split(",")[i] + "文件名已存在");
                    return;
                }
                SysYfile yfile = new SysYfile();
                yfile.setFtime(DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd HH:mm:ss"));
                yfile.setFileNm(fileNm.split(",")[i]);
                yfile.setMemberId(onlineUser.getMemId());
                yfile.setTp2(tp2);
                if (!StrUtil.isNull(pid)) {
                    yfile.setPid(pid);
                }
                int a = fileNm.split(",")[i].indexOf(".");
                if (a > 0) {
                    yfile.setTp1(fileNm.split(",")[i].substring(a + 1, fileNm.split(",")[i].length()));
                    yfile.setTp3(2);
                } else {
                    yfile.setTp3(1);
                }
                this.yfileWebService.addYfile(yfile, onlineUser.getDatabase());
            }
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "添加云文件成功");
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            this.sendWarm(response, "添加云文件失败");
        }
    }

    /**
     * 说明：移动云文件
     *
     * @创建：作者:llp 创建时间：2016-11-07
     * @修改历史： [序号](llp 2016 - 11 - 07)<修改说明>
     */
    @RequestMapping("movefile")
    public void movefile(HttpServletResponse response, String token, Integer id, Integer pid) {
        try {
            if (!checkParam(response, token, id, pid)) {
                return;
            }
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            OnlineUser onlineUser = message.getOnlineMember();
            SysYfile yfile = this.yfileWebService.queryYfileById(onlineUser.getDatabase(), pid);
            this.yfileWebService.updatefilePid(onlineUser.getDatabase(), id, pid, yfile.getTp2());
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "移动云文件成功");
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            this.sendWarm(response, "移动云文件失败");
        }
    }
}
