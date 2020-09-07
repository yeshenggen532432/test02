package com.qweib.cloud.biz.attendance.control;

import com.qweib.cloud.biz.attendance.model.KqPb;
import com.qweib.cloud.biz.attendance.service.KqPbService;
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
@RequestMapping("/manager/kqpb")
public class KqPbControl extends GeneralControl {

    @Resource
    private KqPbService pbService;

    @RequestMapping("/toEmpClass")
    public String toEmpClass(HttpServletRequest request, Model model, String dataTp) {
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
            log.error("登录错误", e);
        }
        return "/kq/kq_pb";
    }

    @RequestMapping("saveBatKqPb")
    public void saveBatKqPb(HttpServletResponse response, HttpServletRequest request, String dateStr, String empStr, Integer bcId) {
        SysLoginInfo info = this.getLoginInfo(request);
        try {
            JSONObject json = new JSONObject();
            if (dateStr == null || empStr == null || bcId == null) {
                json.put("state", false);
                json.put("msg", "参数错误");
                this.sendJsonResponse(response, json.toString());
            }
            if (dateStr.length() == 0 || empStr.length() == 0) {
                json.put("state", false);
                json.put("msg", "参数错误");
                this.sendJsonResponse(response, json.toString());
            }
            int ret = this.pbService.addBatKqPb(dateStr, empStr, bcId, info.getDatasource());

            if (ret > 0) {
                json.put("state", true);
                json.put("msg", "排班成功");
            } else {
                json.put("state", false);
            }
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            this.sendJsonResponse(response, "保存排班失败");
        }
    }

    @RequestMapping("deleteKqPb")
    public void deleteKqPb(HttpServletResponse response, HttpServletRequest request, String ids, String sdate, String edate) {
        SysLoginInfo info = this.getLoginInfo(request);
        try {
            JSONObject json = new JSONObject();
            if (ids == null || sdate == null || edate == null) {
                json.put("state", false);
                json.put("msg", "参数错误");
                this.sendJsonResponse(response, json.toString());
            }
            if (ids.length() == 0) {
                json.put("state", false);
                json.put("msg", "参数错误");
                this.sendJsonResponse(response, json.toString());
            }
            int ret = this.pbService.deleteKqPb1(ids, sdate, edate, info.getDatasource());

            if (ret > 0) {
                json.put("state", true);
                json.put("msg", "删除成功");
            } else {
                json.put("state", false);
            }
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            this.sendJsonResponse(response, "删除排班失败");
        }
    }


    @RequestMapping("/queryKqPbPage")
    public void queryKqPbPage(HttpServletRequest request, HttpServletResponse response, KqPb pb,
                              Integer page, Integer rows) {
        if (page == null) page = 1;
        if (rows == null) rows = 9999;
        SysLoginInfo info = this.getLoginInfo(request);
        try {
            Page p = this.pbService.queryKqPbPage(pb, info.getDatasource(), page, rows);
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("total", p.getTotal());
            json.put("rows", p.getRows());

            this.sendJsonResponse(response, json.toString());
            p = null;
        } catch (Exception e) {
            log.error("分页查询班次出错", e);
        }
    }


}
