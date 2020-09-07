package com.qweib.cloud.biz.system.controller;

import com.qweib.cloud.biz.common.GeneralControl;
import com.qweib.cloud.biz.system.service.SysBfxsxjService;
import com.qweib.cloud.biz.system.service.SysCustomerHzfsService;
import com.qweib.cloud.biz.system.service.SysMemBfStatService;
import com.qweib.cloud.core.domain.SysBfxsxj;
import com.qweib.cloud.core.domain.SysCustomerHzfs;
import com.qweib.cloud.core.domain.SysLoginInfo;
import com.qweib.cloud.core.domain.SysMemBfStat;
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
@RequestMapping("/manager")
public class SysMemBfStatControl extends GeneralControl {

    @Resource
    private SysMemBfStatService sysMemBfStatService;

    @Resource
    private SysBfxsxjService sysBfxsxjService;

    @Resource
    private SysCustomerHzfsService hzfsService;

    @RequestMapping("toMemBfStat")
    public String toMemBfStat(HttpServletRequest request,Model model) {
        try {
            SysLoginInfo info = this.getLoginInfo(request);
            Calendar calendar = Calendar.getInstance();
            Integer year = calendar.get(Calendar.YEAR);
            Integer month = calendar.get(Calendar.MONTH);
            Date startDate = DateTimeUtil.getDateTime(year, month, 1);
            model.addAttribute("sdate", DateTimeUtil.getDateToStr(startDate, "yyyy-MM-dd"));
            model.addAttribute("edate", DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd"));
            List<SysCustomerHzfs> hzfsls=this.hzfsService.queryHzfsList(info.getDatasource());
            model.addAttribute("hzfsls", hzfsls);
            return "/uglcw/bfxsxj/membfstat";
        } catch (Exception e) {
            log.error("分页查询拜访销售小结的数据", e);
        }
        return  "";
    }

    @RequestMapping("queryMemBfStatPage")
    public void queryBfxsxjPage(HttpServletRequest request, HttpServletResponse response, SysMemBfStat stat, Integer page, Integer rows){
        try{
            SysLoginInfo info = this.getLoginInfo(request);
            Page p = this.sysMemBfStatService.queryMemBfStatPage(stat,info.getDatasource(),page,rows);
            JSONObject json = new JSONObject();
            json.put("total", p.getTotal());
            json.put("rows", p.getRows());
            this.sendJsonResponse(response, json.toString());
            p = null;
        }catch (Exception e) {
            log.error("分页查询拜访统计出错", e);
        }
    }

    @RequestMapping("toMemBfXsxjStat")
    public String toMemBfXsxjStat(HttpServletRequest request,Model model) {
        try {
            SysLoginInfo info = this.getLoginInfo(request);
            Calendar calendar = Calendar.getInstance();
            Integer year = calendar.get(Calendar.YEAR);
            Integer month = calendar.get(Calendar.MONTH);
            Date startDate = DateTimeUtil.getDateTime(year, month, 1);
            model.addAttribute("sdate", DateTimeUtil.getDateToStr(startDate, "yyyy-MM-dd"));
            model.addAttribute("edate", DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd"));
            List<SysCustomerHzfs> hzfsls=this.hzfsService.queryHzfsList(info.getDatasource());
            model.addAttribute("hzfsls", hzfsls);
            return "/uglcw/bfxsxj/bfxsxj_stat2";
        } catch (Exception e) {
            log.error("分页查询拜访销售小结的数据", e);
        }
        return  "";
    }

    @RequestMapping("queryMemBfXsxjStatPage")
    public void queryMemBfXsxjStatPage(HttpServletRequest request, HttpServletResponse response, SysBfxsxj stat, Integer page, Integer rows){
        try{
            SysLoginInfo info = this.getLoginInfo(request);
            stat.setDatabase(info.getDatasource());
            Page p = this.sysBfxsxjService.sumBfxsxjStatPage(stat,page,rows);
            JSONObject json = new JSONObject();
            json.put("total", p.getTotal());
            json.put("rows", p.getRows());
            this.sendJsonResponse(response, json.toString());
            p = null;
        }catch (Exception e) {
            log.error("分页查询拜访统计出错", e);
        }
    }
}
