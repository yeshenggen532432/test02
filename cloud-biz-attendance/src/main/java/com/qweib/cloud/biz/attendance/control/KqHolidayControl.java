package com.qweib.cloud.biz.attendance.control;

import com.qweib.cloud.biz.attendance.model.KqHoliday;
import com.qweib.cloud.biz.attendance.service.KqHolidayService;
import com.qweib.cloud.biz.common.GeneralControl;
import com.qweib.cloud.core.domain.SysLoginInfo;
import com.qweib.cloud.utils.Page;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@Controller
@RequestMapping("/manager/kqholiday")
public class KqHolidayControl extends GeneralControl {

    @Resource
    private KqHolidayService holidayService;

    @RequestMapping("/toBaseHoliday")
    public String toBaseHoliday(HttpServletRequest request, Model model, String dataTp) {
        try {
            SysLoginInfo info = this.getLoginInfo(request);

        } catch (Exception e) {
            // TODO: handle exception
            log.error("登录错误", e);
        }
        return "/kq/base_holiday";
    }

    @RequestMapping("/toBaseHolidayEdit")
    public String toBaseHolidayEdit(HttpServletRequest request, Model model, Integer id) {
        try {
            SysLoginInfo info = this.getLoginInfo(request);
            KqHoliday day = this.holidayService.getHoliday(id, info.getDatasource());
            model.addAttribute("day", day);
        } catch (Exception e) {
            // TODO: handle exception
            log.error("登录错误", e);
        }
        return "/kq/base_holiday_edit";
    }

    @RequestMapping("/queryHolidayPage")
    public void queryHolidayPage(HttpServletRequest request, HttpServletResponse response, KqHoliday day,
                                 Integer page, Integer rows) {
        if (page == null) page = 1;
        if (rows == null) rows = 9999;
        SysLoginInfo info = this.getLoginInfo(request);
        try {
            Page p = this.holidayService.queryHolidayPage(day, info.getDatasource(), page, rows);
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("total", p.getTotal());
            json.put("rows", p.getRows());

            this.sendJsonResponse(response, json.toString());
            p = null;
        } catch (Exception e) {
            log.error("分页查询节假日出错", e);
        }
    }


    @RequestMapping("deleteHoliday")
    public void deleteHoliday(HttpServletResponse response, HttpServletRequest request, String token, String ids) {
        SysLoginInfo info = this.getLoginInfo(request);
        try {
            String[] bcIds = ids.split(",");
            for (int i = 0; i < bcIds.length; i++) {
                Integer id = Integer.parseInt(bcIds[i]);
                this.holidayService.deleteHoliday(id, info.getDatasource());
            }
            JSONObject json = new JSONObject();

            json.put("state", true);
            json.put("id", 0);
            json.put("msg", "删除成功");
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            this.sendJsonResponse(response, "删除节假日失败");
        }
    }

    @RequestMapping("/saveHoliday")
    public void saveHoliday(HttpServletResponse response, HttpServletRequest request, KqHoliday day) {
        try {
            SysLoginInfo info = this.getLoginInfo(request);
            int ret = 0;
            if (day.getId() != null) {
                if (day.getId().intValue() > 0) ret = this.holidayService.updateHoliday(day, info.getDatasource());
                else
                    ret = this.holidayService.addHoliday(day, info.getDatasource());
            } else
                ret = this.holidayService.addHoliday(day, info.getDatasource());
            if (ret > 0)
                this.sendHtmlResponse(response, "1");
            else
                this.sendHtmlResponse(response, "-1");
        } catch (Exception e) {
            log.error("批量修改客户分布设置出错：", e);
        }
    }

}
