package com.qweib.cloud.biz.attendance.control;

import com.qweib.cloud.biz.attendance.model.KqJia;
import com.qweib.cloud.biz.attendance.service.KqJiaService;
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
@RequestMapping("/manager/kqjia")
public class KqJiaControl extends GeneralControl {

    @Resource
    private KqJiaService jiaService;

    @RequestMapping("/toKqJia")
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
        return "/kq/kq_jia";
    }

    @RequestMapping("/queryKqJiaPage")
    public void queryKqJiaPage(HttpServletRequest request, HttpServletResponse response, KqJia jia,
                               Integer page, Integer rows) throws Exception {
        if (page == null) page = 1;
        if (rows == null) rows = 9999;
        SysLoginInfo info = this.getLoginInfo(request);
        String tmpstr = jia.getEdate();
        if (tmpstr != null) {
            Date tmpDate = DateTimeUtil.getStrToDate(tmpstr, "yyyy-MM-dd");
            tmpDate = DateTimeUtil.dateTimeAdd(tmpDate, 5, 1);//增加一天
            tmpstr = DateTimeUtil.getDateToStr(tmpDate, "yyyy-MM-dd");
            jia.setEdate(tmpstr);
        }
        try {
            Page p = this.jiaService.queryKqJiaPage(jia, info.getDatasource(), page, rows);
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("total", p.getTotal());
            json.put("rows", p.getRows());

            this.sendJsonResponse(response, json.toString());
            p = null;
        } catch (Exception e) {
            log.error("分页查询请假出错", e);
        }
    }

    @RequestMapping("addKqJia")
    public void addKqJia(HttpServletResponse response, HttpServletRequest request, KqJia jia) {
        SysLoginInfo info = this.getLoginInfo(request);
        try {
            jia.setOperator(info.getUsrNm());
            int ret = this.jiaService.addKqJia(jia, info.getDatasource());
            JSONObject json = new JSONObject();
            if (ret > 0) {
                json.put("state", true);
                json.put("id", ret);

            } else {
                json.put("state", false);
            }
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            this.sendJsonResponse(response, "{\"state\":false,\"msg\":\"保存失败\"}");
        }
    }

    @RequestMapping("updateJiaStatus")
    public void updateJiaStatus(HttpServletResponse response, HttpServletRequest request, Integer jiaId, Integer status) {
        SysLoginInfo info = this.getLoginInfo(request);
        try {

            int ret = this.jiaService.updateStatus(jiaId, status, info.getDatasource());
            JSONObject json = new JSONObject();
            if (ret > 0) {
                json.put("state", true);
                json.put("id", ret);

            } else {
                json.put("state", false);
            }
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            this.sendJsonResponse(response, "{\"state\":false,\"msg\":\"保存失败\"}");
        }
    }


}
