package com.qweib.cloud.biz.system.controller.mobile;


import com.qweib.cloud.biz.common.GpsUtils;
import com.qweib.cloud.biz.system.BaseWebService;
import com.qweib.cloud.biz.system.QiniuControl;
import com.qweib.cloud.biz.system.service.plat.SysMemberService;
import com.qweib.cloud.core.domain.SysMember;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;
import java.util.List;

@Controller
@RequestMapping("/web")
public class UtilWebControl extends BaseWebService {
    @Resource
    private SysMemberService memberService;

    /**
     * 说明：创建gps用户
     *
     * @创建：作者:llp 创建时间：2017-3-17
     * @修改历史： [序号](llp 2017 - 3 - 17)<修改说明>
     */
    @RequestMapping("createGpsMem")
    public void createGpsMem(HttpServletResponse response) {
        try {
            List<SysMember> list = this.memberService.queryMemberAll();
            //创建创建gps用户
            final String gpsUrl = QiniuControl.GPS_SERVICE_URL + "/User/postLocation";
            for (SysMember member : list) {
                GpsUtils.createGpsMember(gpsUrl, member.getUnitId(), member.getMemberId());
            }
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "创建gps用户成功");
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            this.sendWarm(response, "创建gps用户失败");
        }
    }

}
