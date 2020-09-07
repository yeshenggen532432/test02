package com.qweib.cloud.biz.signin.control;

import com.qweib.cloud.biz.common.GeneralControl;
import com.qweib.cloud.biz.signin.model.SysSignIn;
import com.qweib.cloud.biz.signin.service.SysSignInService;
import com.qweib.cloud.core.domain.SysLoginInfo;
import com.qweib.cloud.utils.DateTimeUtil;
import com.qweib.cloud.utils.Page;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

@Controller
@RequestMapping("/manager/sign")
public class SysSignInControl extends GeneralControl {

    @Resource
    private SysSignInService sysSignInService;

    @RequestMapping("/toSignRecord")
    public String toPosShopDisSet(HttpServletRequest request, Model model, Integer mastId) {
        try {
            SysLoginInfo info = this.getLoginInfo(request);
            Calendar calendar = Calendar.getInstance();
            Integer year = calendar.get(Calendar.YEAR);
            Integer month = calendar.get(Calendar.MONTH);
            Date startDate = DateTimeUtil.getDateTime(year, month, 1);

            model.addAttribute("sdate", DateTimeUtil.getDateToStr(startDate, "yyyy-MM-dd"));
            model.addAttribute("edate", DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd"));

        } catch (Exception e) {
            // TODO: handle exception
            log.error("登录错误" + e);
        }
        return "/kq/sign/sign_record";
    }

    @RequestMapping("/querySignInPage")
    public void querySignInPage(HttpServletRequest request, HttpServletResponse response, SysSignIn vo,Integer page,Integer rows) {

        SysLoginInfo info = this.getLoginInfo(request);
        try {
            Page p = this.sysSignInService.querySignInPage1(vo,info.getDatasource(),page,rows);

            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("total", p.getTotal());
            json.put("rows", p.getRows());

            this.sendJsonResponse(response, json.toString());

        } catch (Exception e) {
            log.error("查询移动签到出错", e);
        }
    }


}
