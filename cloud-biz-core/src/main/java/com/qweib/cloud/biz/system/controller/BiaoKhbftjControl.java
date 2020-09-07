package com.qweib.cloud.biz.system.controller;

import com.qweib.cloud.biz.system.service.BiaoKhbftjService;
import com.qweib.cloud.biz.system.service.SysCustomerService;
import com.qweib.cloud.biz.system.service.SysKhgxsxService;
import com.qweib.cloud.core.domain.*;

import com.qweib.cloud.biz.common.GeneralControl;
import com.qweib.cloud.utils.DateTimeUtil;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

@Controller
@RequestMapping("/manager")
public class BiaoKhbftjControl extends GeneralControl {
    @Resource
    private BiaoKhbftjService khbftjService;
    @Resource
    private SysCustomerService customerService;
    @Resource
    private SysKhgxsxService khgxsxService;

    /**
     * 说明：到客户拜访统计表主页
     *
     * @创建：作者:llp 创建时间：2016-7-5
     * @修改历史： [序号](llp 2016 - 7 - 5)<修改说明>
     */
    @RequestMapping("/queryKhbftj")
    public String queryKhbftj(Model model, HttpServletRequest request, String dataTp) {
        try {
            SysLoginInfo info = this.getLoginInfo(request);
            List<SysKhlevel> list = this.khgxsxService.queryKhlevells(null, info.getDatasource());
            model.addAttribute("list", list);
            SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
            Calendar calendar = Calendar.getInstance();
            calendar.set(Calendar.DAY_OF_WEEK, Calendar.MONDAY);
            model.addAttribute("stime", format.format(calendar.getTime()));
            model.addAttribute("etime", DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd"));
            model.addAttribute("dataTp", dataTp);
        } catch (Exception e) {
            // TODO: handle exception
        }
        return "/uglcw/Biao/khbftj";
    }

    /**
     * 说明：分页查询客户拜访统计表
     *
     * @创建：作者:llp 创建时间：2016-7-5
     * @修改历史： [序号](llp 2016 - 7 - 5)<修改说明>
     */
    @RequestMapping("/khbftjPage")
    public void khbftjPage(HttpServletRequest request, HttpServletResponse response, BiaoKhbftj Khbftj, String dataTp, Integer page, Integer rows) {
        try {
            SysLoginInfo info = this.getLoginInfo(request);
            SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
            Calendar calendar = Calendar.getInstance();
            calendar.set(Calendar.DAY_OF_WEEK, Calendar.MONDAY);
            if (StrUtil.isNull(Khbftj.getStime())) {
                Khbftj.setStime(format.format(calendar.getTime()));
            }
            if (StrUtil.isNull(Khbftj.getEtime())) {
                Khbftj.setEtime(DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd"));
            }
            Page p = this.khbftjService.queryBiaoKhbftj(Khbftj, info, dataTp, page, rows);
            List<BiaoKhbftj> vlist = (List<BiaoKhbftj>) p.getRows();
            for (BiaoKhbftj biaoKhbftj : vlist) {
                SysBfqdpz bfqdpz = this.khbftjService.queryBfqdpzOne1(info.getDatasource(), biaoKhbftj.getId(), biaoKhbftj.getScbfDate());
                SysBfgzxc bfgzxc = this.khbftjService.queryBfgzxcOne1(info.getDatasource(), biaoKhbftj.getId(), biaoKhbftj.getScbfDate());
                if (!StrUtil.isNull(bfqdpz) && !StrUtil.isNull(bfgzxc)) {
                    DateFormat df = new SimpleDateFormat("HH:mm:ss");
                    Date d1 = df.parse(bfgzxc.getDdtime());
                    Date d2 = df.parse(bfqdpz.getQdtime());
                    long diff = d1.getTime() - d2.getTime();
                    long hour = (diff / (60 * 60 * 1000) - 0 * 24);
                    long min = ((diff / (60 * 1000)) - 0 * 24 * 60 - hour * 60);
                    biaoKhbftj.setBfsc(60 * hour + min + "分");
                }
            }
            JSONObject json = new JSONObject();
            json.put("total", p.getTotal());
            json.put("rows", p.getRows());
            this.sendJsonResponse(response, json.toString());
            p = null;
        } catch (Exception e) {
            log.error("分页查询客户拜访统计表出错", e);
        }
    }

    /**
     * @说明：添加/修改客户页面
     * @创建：作者:llp 创建时间：2016-7-11
     * @修改历史： [序号](llp 2016 - 7 - 11)<修改说明>
     */
    @RequestMapping("tocustomerxq")
    public String toopercustomer(HttpServletRequest request, Model model, Integer Id, Integer khTp) {
        SysLoginInfo info = this.getLoginInfo(request);
        if (null != Id) {
            try {
                SysCustomer customer = this.customerService.queryCustomerById(info.getDatasource(), Id);
                model.addAttribute("customer", customer);
            } catch (Exception e) {
                log.error("获取客户出错：", e);
            }
        }
        List<SysBfpc> bfpcls = this.khgxsxService.queryBfpcls();
        List<SysGhtype> ghtypels = this.khgxsxService.queryGhtypels();
        List<SysJxsfl> jxsflls = this.khgxsxService.queryJxsflls(info.getDatasource());
        List<SysJxsjb> jxsjbls = this.khgxsxService.queryJxsjbls(info.getDatasource());
        List<SysJxszt> jxsztls = this.khgxsxService.queryJxsztls(info.getDatasource());
        List<SysKhlevel> khlevells = this.khgxsxService.queryKhlevells(null, info.getDatasource());
        List<SysSctype> sctypels = this.khgxsxService.querySctypels();
        List<SysXsphase> xsphasels = this.khgxsxService.queryXsphasels();
        List<SysHzfs> hzfsls = this.khgxsxService.queryHzfsls();
        model.addAttribute("bfpcls", bfpcls);
        model.addAttribute("ghtypels", ghtypels);
        model.addAttribute("jxsflls", jxsflls);
        model.addAttribute("jxsjbls", jxsjbls);
        model.addAttribute("jxsztls", jxsztls);
        model.addAttribute("khlevells", khlevells);
        model.addAttribute("sctypels", sctypels);
        model.addAttribute("xsphasels", xsphasels);
        model.addAttribute("hzfsls", hzfsls);
        if (khTp == 1) {
            return "/uglcw/Biao/customerxq1";
        } else {
            return "/uglcw/Biao/customerxq2";
        }
    }
}
