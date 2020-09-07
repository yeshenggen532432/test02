package com.qweib.cloud.biz.attendance.control;

import com.qweib.cloud.biz.attendance.model.KqBc;
import com.qweib.cloud.biz.attendance.model.KqChgBc;
import com.qweib.cloud.biz.attendance.service.KqChgBcService;
import com.qweib.cloud.biz.attendance.service.KqDetailService;
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
@RequestMapping("/manager/chgbc")
public class KqChgBcControl extends GeneralControl {

    @Resource
    private KqChgBcService chgBcService;

    @Resource
    private KqDetailService detailService;

    @RequestMapping("/toChgBc")
    public String toChgBc(HttpServletRequest request, Model model, String dataTp) {
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
        return "/kq/kq_chgbc";
    }


    @RequestMapping("/queryKqChgBcPage")
    public void queryKqChgBcPage(HttpServletRequest request, HttpServletResponse response, KqChgBc bc,
                                 Integer page, Integer rows) throws Exception {
        if (page == null) page = 1;
        if (rows == null) rows = 9999;
        SysLoginInfo info = this.getLoginInfo(request);
        String tmpstr = bc.getEdate();
        if (tmpstr != null) {
            Date tmpDate = DateTimeUtil.getStrToDate(tmpstr, "yyyy-MM-dd");
            tmpDate = DateTimeUtil.dateTimeAdd(tmpDate, 5, 1);//增加一天
            tmpstr = DateTimeUtil.getDateToStr(tmpDate, "yyyy-MM-dd");
            bc.setEdate(tmpstr);
        }
        try {
            Page p = this.chgBcService.queryChgBcPage(bc, info.getDatasource(), page, rows);
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("total", p.getTotal());
            json.put("rows", p.getRows());

            this.sendJsonResponse(response, json.toString());
            p = null;
        } catch (Exception e) {
            log.error("分页查询调班出错", e);
        }
    }

    @RequestMapping("addKqChgBc")
    public void addKqChgBc(HttpServletResponse response, HttpServletRequest request, String ids, KqChgBc bc) {
        SysLoginInfo info = this.getLoginInfo(request);
        try {
            bc.setOperator(info.getUsrNm());
            String[] memberIds = ids.split(",");
            int ret = 0;
            for (int i = 0; i < memberIds.length; i++) {
                Integer memberId = Integer.parseInt(memberIds[i]);
                if (memberId.intValue() == 0) continue;
                bc.setMemberId(memberId);
                KqBc bc1 = this.detailService.getEmpBcByDate(bc.getMemberId(), bc.getFromDate(), info.getDatasource());
                if (bc1 == null) bc.setBcId1(0);
                else bc.setBcId1(bc1.getId());

                KqBc bc2 = this.detailService.getEmpBcByDate(bc.getMemberId(), bc.getToDate(), info.getDatasource());
                if (bc2 == null) bc.setBcId2(0);
                else bc.setBcId2(bc2.getId());
                bc.setStatus(0);
                bc.setChgDate(DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd HH:mm:ss"));
                ret = this.chgBcService.addChgBc(bc, info.getDatasource());
            }
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
