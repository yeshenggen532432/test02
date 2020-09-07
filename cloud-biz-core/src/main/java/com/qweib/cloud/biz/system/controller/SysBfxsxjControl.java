package com.qweib.cloud.biz.system.controller;

import com.qweib.cloud.biz.system.service.SysBfxsxjService;
import com.qweib.cloud.biz.system.service.SysCustomerHzfsService;
import com.qweib.cloud.core.domain.SysBfxsxj;
import com.qweib.cloud.core.domain.SysCustomerHzfs;
import com.qweib.cloud.core.domain.SysLoginInfo;

import com.qweib.cloud.biz.common.GeneralControl;
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
public class SysBfxsxjControl extends GeneralControl {
    @Resource
    private SysBfxsxjService bfxsxjService;

    @Resource
    private SysCustomerHzfsService hzfsService;

    /**
     * 摘要：
     *
     * @说明：查询销售小结（根据业务员和客户）页面
     * @创建：作者:llp 创建时间：2016-4-28
     * @修改历史： [序号](llp 2016 - 4 - 28)<修改说明>
     */
    @RequestMapping("toqueryBfxsxj")
    public String toqueryBfxsxj(Model model, Integer mid, Integer cid, String xjdate) {
        model.addAttribute("mid", mid);
        model.addAttribute("cid", cid);
        model.addAttribute("xjdate", xjdate);
        return "/uglcw/bfxsxj/bfxsxj";
    }

    /**
     * 摘要：
     *
     * @说明：分页查询销售小结（根据业务员和客户）
     * @创建：作者:llp 创建时间：2016-4-28
     * @修改历史： [序号](llp 2016 - 4 - 28)<修改说明>
     */
    @RequestMapping("queryBfxsxjPage")
    public void queryBfxsxjPage(HttpServletRequest request, HttpServletResponse response, Integer mid, Integer cid, String xjdate, Integer page, Integer rows) {
        try {
            SysLoginInfo info = this.getLoginInfo(request);
            Page p = this.bfxsxjService.queryBfxsxjPage(info.getDatasource(), mid, cid, xjdate, page, rows);
            JSONObject json = new JSONObject();
            json.put("total", p.getTotal());
            json.put("rows", p.getRows());
            this.sendJsonResponse(response, json.toString());
            p = null;
        } catch (Exception e) {
            log.error("分页查询销售小结出错", e);
        }
    }

    @RequestMapping("toSumBfxsxj")
    public String toSumBfxsxj(HttpServletRequest request, Model model) throws Exception {
        SysLoginInfo info = this.getLoginInfo(request);
        model.addAttribute("database", info.getDatasource());
        Calendar calendar = Calendar.getInstance();
        Integer year = calendar.get(Calendar.YEAR);
        Integer month = calendar.get(Calendar.MONTH);
        Date startDate = DateTimeUtil.getDateTime(year, month, 1);
        model.addAttribute("sdate", DateTimeUtil.getDateToStr(startDate, "yyyy-MM-dd"));
        model.addAttribute("edate", DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd"));
        List<SysCustomerHzfs> hzfsls = this.hzfsService.queryHzfsList(info.getDatasource());
        model.addAttribute("hzfsls", hzfsls);
        return "/uglcw/bfxsxj/bfxsxj_stat1";

    }

    @RequestMapping("toSumBfxsxj1")
    public String toSumBfxsxj1(HttpServletRequest request, HttpServletResponse response, Model model, SysBfxsxj xj) {
        SysLoginInfo info = this.getLoginInfo(request);
        try {
            model.addAttribute("database", info.getDatasource());

            model.addAttribute("sdate", xj.getSdate());
            model.addAttribute("edate", xj.getEdate());
            model.addAttribute("cid", xj.getCid());
            model.addAttribute("noCompany", xj.getNoCompany());
            return "/uglcw/bfxsxj/bfxsxj_stat";
        } catch (Exception e) {
            log.error("分页查询拜访销售小结的数据", e);
        }
        return "";
    }

    @RequestMapping("sumBfxsxjPage")
    public void sumBfxsxjPage(HttpServletRequest request, HttpServletResponse response, SysBfxsxj xj, Integer page, Integer rows) {
        try {
            SysLoginInfo info = this.getLoginInfo(request);
            xj.setDatabase(info.getDatasource());
            String tmpstr = xj.getEdate();
            if (tmpstr == null) return;
            Date tmpDate = DateTimeUtil.getStrToDate(tmpstr, "yyyy-MM-dd");
            tmpDate = DateTimeUtil.dateTimeAdd(tmpDate, 5, 1);//增加一天
            tmpstr = DateTimeUtil.getDateToStr(tmpDate, "yyyy-MM-dd");
            xj.setEdate(tmpstr);
            Page p = this.bfxsxjService.sumBfxsxjPage(xj, page, rows);
            JSONObject json = new JSONObject();
            json.put("total", p.getTotal());
            json.put("rows", p.getRows());
            this.sendJsonResponse(response, json.toString());
            p = null;
        } catch (Exception e) {
            log.error("分页查询销售小结出错", e);
        }
    }

    @RequestMapping("toBfxsxjDetail")
    public String toBfxsxjDetail(HttpServletRequest request, HttpServletResponse response, Model model, Integer cid, Integer wid, String sdate, String edate) {
        //SysLoginInfo info = this.getLoginInfo(request);
        try {

            model.addAttribute("cid", cid);
            model.addAttribute("wid", wid);
            model.addAttribute("sdate", sdate);
            model.addAttribute("edate", edate);
            return "/uglcw/bfxsxj/bfxsxj_detail";
        } catch (Exception e) {
            log.error("分页查询拜访销售小结的数据", e);
        }
        return "";
    }

    @RequestMapping("queryBfxsxjDetail")
    public void queryBfxsxjDetail(HttpServletRequest request, HttpServletResponse response, SysBfxsxj xj) {
        try {
            SysLoginInfo info = this.getLoginInfo(request);
            xj.setDatabase(info.getDatasource());
            String tmpstr = xj.getEdate();
            if (tmpstr == null) return;
            Date tmpDate = DateTimeUtil.getStrToDate(tmpstr, "yyyy-MM-dd");
            tmpDate = DateTimeUtil.dateTimeAdd(tmpDate, 5, 1);//增加一天
            tmpstr = DateTimeUtil.getDateToStr(tmpDate, "yyyy-MM-dd");
            xj.setEdate(tmpstr);
            List<SysBfxsxj> list = this.bfxsxjService.queryxjDetail(xj);
            JSONObject json = new JSONObject();
            json.put("total", list.size());
            json.put("rows", list);
            this.sendJsonResponse(response, json.toString());

        } catch (Exception e) {
            log.error("分页查询销售小结出错", e);
        }
    }


    @RequestMapping("sumBfxsxjPage1")
    public void sumBfxsxjPage1(HttpServletRequest request, HttpServletResponse response, SysBfxsxj xj, Integer page, Integer rows) {
        try {
            SysLoginInfo info = this.getLoginInfo(request);
            xj.setDatabase(info.getDatasource());
            String tmpstr = xj.getEdate();
            if (tmpstr == null) return;
            Date tmpDate = DateTimeUtil.getStrToDate(tmpstr, "yyyy-MM-dd");
            tmpDate = DateTimeUtil.dateTimeAdd(tmpDate, 5, 1);//增加一天
            tmpstr = DateTimeUtil.getDateToStr(tmpDate, "yyyy-MM-dd");
            xj.setEdate(tmpstr);
            Page p = this.bfxsxjService.sumBfxsxjPage1(xj, page, rows);
            JSONObject json = new JSONObject();
            json.put("total", p.getTotal());
            json.put("rows", p.getRows());
            this.sendJsonResponse(response, json.toString());
            p = null;
        } catch (Exception e) {
            log.error("分页查询销售小结出错", e);
        }
    }
}
