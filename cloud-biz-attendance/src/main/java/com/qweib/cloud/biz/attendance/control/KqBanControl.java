package com.qweib.cloud.biz.attendance.control;

import com.qweib.cloud.biz.attendance.model.KqBan;
import com.qweib.cloud.biz.attendance.service.KqBanService;
import com.qweib.cloud.biz.common.GeneralControl;
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

@Controller
@RequestMapping("/manager/kqban")
public class KqBanControl extends GeneralControl {

    @Resource
    private KqBanService banService;

    @RequestMapping("/toKqBan")
    public String toKqJia(HttpServletRequest request, Model model, String dataTp) {
        try {
            SysLoginInfo info = this.getLoginInfo(request);
            model.addAttribute("database", info.getDatasource());
            Calendar calendar = Calendar.getInstance();
            Integer year = calendar.get(Calendar.YEAR);
            Integer month = calendar.get(Calendar.MONTH);
            Date startDate = DateTimeUtil.getDateTime(year, month, 1);
            model.addAttribute("sdate", DateTimeUtil.getDateToStr(startDate, "yyyy-MM-dd"));
            model.addAttribute("edate", DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd"));
        } catch (Exception e) {
            // TODO: handle exception
            log.error("登录错误", e);
        }
        return "/kq/kq_ban";
    }

    @RequestMapping("/queryKqBanPage")
    public void queryKqBanPage(HttpServletRequest request, HttpServletResponse response, KqBan ban,
                               Integer page, Integer rows) throws Exception {
        if (page == null) page = 1;
        if (rows == null) rows = 9999;
        SysLoginInfo info = this.getLoginInfo(request);
        String tmpstr = ban.getEdate();
        if (tmpstr != null) {
            Date tmpDate = DateTimeUtil.getStrToDate(tmpstr, "yyyy-MM-dd");
            tmpDate = DateTimeUtil.dateTimeAdd(tmpDate, 5, 1);//增加一天
            tmpstr = DateTimeUtil.getDateToStr(tmpDate, "yyyy-MM-dd");
            ban.setEdate(tmpstr);
        }
        try {
            Page p = this.banService.queryKqBanPage(ban, info.getDatasource(), page, rows);
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("total", p.getTotal());
            json.put("rows", p.getRows());

            this.sendJsonResponse(response, json.toString());
            p = null;
        } catch (Exception e) {
            log.error("分页查询加班出错", e);
        }
    }

    @RequestMapping("addKqBan")
    public void addKqBan(HttpServletResponse response, HttpServletRequest request, KqBan ban) {
        SysLoginInfo info = this.getLoginInfo(request);
        try {
            ban.setOperator(info.getUsrNm());
            int ret = this.banService.addKqBan(ban, info.getDatasource());
            JSONObject json = new JSONObject();
            if (ret > 0) {
                json.put("state", true);
                json.put("id", ret);

            } else {
                json.put("state", false);
            }
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            this.sendJsonResponse(response, "保存失败");
        }
    }


    @RequestMapping("updateBanStatus")
    public void updateBanStatus(HttpServletResponse response, HttpServletRequest request, Integer banId, Integer status) {
        SysLoginInfo info = this.getLoginInfo(request);
        try {

            int ret = this.banService.updateStatus(banId, status, info.getDatasource());
            JSONObject json = new JSONObject();
            if (ret > 0) {
                json.put("state", true);
                json.put("id", ret);

            } else {
                json.put("state", false);
            }
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            this.sendJsonResponse(response, "保存失败");
        }
    }


}
