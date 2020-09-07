package com.qweib.cloud.biz.attendance.control;

import com.qweib.cloud.biz.attendance.model.*;
import com.qweib.cloud.biz.attendance.service.KqDetailService;
import com.qweib.cloud.biz.attendance.service.KqPrintService;
import com.qweib.cloud.biz.common.GeneralControl;
import com.qweib.cloud.core.domain.SysLoginInfo;
import com.qweib.cloud.utils.DateTimeUtil;
import com.qweib.cloud.utils.Page;
import org.apache.commons.beanutils.BeanUtils;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.*;

@Controller
@RequestMapping("/manager/kqrpt")
public class KqRptControl extends GeneralControl {

    @Resource
    private KqDetailService detailService;

    @Resource
    private KqPrintService printService;

    @RequestMapping("/toKqDetail")
    public String toKqDetail(HttpServletRequest request, Model model, String dataTp) {
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
        return "/kq/kq_detail";
    }

    @RequestMapping("/queryKqDetailPage")
    public void queryKqDetailPage(HttpServletRequest request, HttpServletResponse response, KqEmpRule detail,
                                  Integer page, Integer rows) throws Exception {
        if (page == null) page = 1;
        if (rows == null) rows = 9999;
        String tmpstr = detail.getEdate();
        if (tmpstr != null) {
            Date tmpDate = DateTimeUtil.getStrToDate(tmpstr, "yyyy-MM-dd");
            tmpDate = DateTimeUtil.dateTimeAdd(tmpDate, 5, 1);//增加一天
            tmpstr = DateTimeUtil.getDateToStr(tmpDate, "yyyy-MM-dd");
            detail.setEdate(tmpstr);
        }
        SysLoginInfo info = this.getLoginInfo(request);
        try {
            Page p = this.detailService.queryKqDetailPage(detail, info.getDatasource(), page, rows);
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("total", p.getTotal());
            json.put("rows", p.getRows());

            this.sendJsonResponse(response, json.toString());
            p = null;
        } catch (Exception e) {
            log.error("分页查询考勤明细出错", e);
        }
    }

    @RequestMapping("/SumKqDetail")
    public void SumKqDetail(HttpServletRequest request, HttpServletResponse response, KqEmpRule rule,
                            Integer page, Integer rows) {
        if (page == null) page = 1;
        if (rows == null) rows = 9999;
        SysLoginInfo info = this.getLoginInfo(request);
        try {
            String tmpstr = rule.getEdate();
            Date tmpDate = DateTimeUtil.getStrToDate(tmpstr, "yyyy-MM-dd");
            tmpDate = DateTimeUtil.dateTimeAdd(tmpDate, 5, 1);//增加一天
            tmpstr = DateTimeUtil.getDateToStr(tmpDate, "yyyy-MM-dd");
            rule.setEdate(tmpstr);
            this.detailService.addKqDetail(rule, info.getDatasource());
            //Page p = this.detailService.queryKqDetailPage(detail, info.getDatasource(), page, rows);
            JSONObject json = new JSONObject();
            json.put("state", true);
            //json.put("total", p.getTotal());
            //json.put("rows", p.getRows());

            this.sendJsonResponse(response, json.toString());

        } catch (Exception e) {
            log.error("分页查询考勤明细出错", e);
        }
    }

    @RequestMapping("/toKqResult")
    public String toKqResult(HttpServletRequest request, Model model, String dataTp) {
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
        return "/kq/kq_result";
    }

    @RequestMapping("/queryKqResult")
    public void queryKqResult(HttpServletRequest request, HttpServletResponse response, KqEmpRule detail,
                              Integer page, Integer rows) {
        if (page == null) page = 1;
        if (rows == null) rows = 9999;
        SysLoginInfo info = this.getLoginInfo(request);
        try {
            String tmpstr = detail.getEdate();
            if (tmpstr != null) {
                Date tmpDate = DateTimeUtil.getStrToDate(tmpstr, "yyyy-MM-dd");
                tmpDate = DateTimeUtil.dateTimeAdd(tmpDate, 5, 1);//增加一天
                tmpstr = DateTimeUtil.getDateToStr(tmpDate, "yyyy-MM-dd");
                detail.setEdate(tmpstr);
            }
            Page p = this.detailService.queryKqResult(detail, info.getDatasource(), page, rows);
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("total", p.getTotal());
            json.put("rows", p.getRows());

            this.sendJsonResponse(response, json.toString());
            p = null;
        } catch (Exception e) {
            log.error("分页查询考勤明细出错", e);
        }
    }

    @RequestMapping("/toKqStat")
    public String toKqStat(HttpServletRequest request, Model model, String dataTp) {
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
        return "/kq/kq_stat";
    }

    @RequestMapping("/queryKqStat")
    public void queryKqStat(HttpServletRequest request, HttpServletResponse response, KqEmpRule emp, Integer page, Integer rows) {
        SysLoginInfo info = this.getLoginInfo(request);
        try {
            String tmpstr = emp.getEdate();
            if (tmpstr != null) {
                Date tmpDate = DateTimeUtil.getStrToDate(tmpstr, "yyyy-MM-dd");
                tmpDate = DateTimeUtil.dateTimeAdd(tmpDate, 5, 1);//增加一天
                tmpstr = DateTimeUtil.getDateToStr(tmpDate, "yyyy-MM-dd");
                emp.setEdate(tmpstr);
            }
            Page p = this.detailService.queryKqStatPage(emp, info.getDatasource(), page, rows);
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("total", p.getTotal());
            json.put("rows", p.getRows());

            this.sendJsonResponse(response, json.toString());
            p = null;
        } catch (Exception e) {
            log.error("分页查询考勤汇总出错", e);
        }
    }

    @RequestMapping("/toKqRecord")
    public String toKqRecord(HttpServletRequest request, Model model, String dataTp) {
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
        return "/kq/kq_record";
    }

    @RequestMapping("/queryKqRecord")
    public void queryKqRecord(HttpServletRequest request, HttpServletResponse response, KqEmpRule emp, Integer page, Integer rows) {
        SysLoginInfo info = this.getLoginInfo(request);
        try {
            String tmpstr = emp.getEdate();
            Date tmpDate = DateTimeUtil.getStrToDate(tmpstr, "yyyy-MM-dd");
            tmpDate = DateTimeUtil.dateTimeAdd(tmpDate, 5, 1);//增加一天
            tmpstr = DateTimeUtil.getDateToStr(tmpDate, "yyyy-MM-dd");
            emp.setEdate(tmpstr);
            Page p = this.detailService.queryKqRecordPage(emp, info.getDatasource(), page, rows);
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("total", p.getTotal());
            json.put("rows", p.getRows());

            this.sendJsonResponse(response, json.toString());
            p = null;
        } catch (Exception e) {
            log.error("分页查询考勤记录出错", e);
        }
    }

    @RequestMapping("/addKqRemarks")
    public void addKqRemarks(HttpServletRequest request, HttpServletResponse response, KqRemarks bo) {
        SysLoginInfo info = this.getLoginInfo(request);
        try {

            int ret = this.detailService.addKqRemarks(bo, info.getDatasource());
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("id", ret);

            this.sendJsonResponse(response, json.toString());

        } catch (Exception e) {
            log.error("保存备注出错", e);
        }
    }

    @RequestMapping("/deleteKqRemarks")
    public void deleteKqRemarks(HttpServletRequest request, HttpServletResponse response, KqRemarks bo) {
        SysLoginInfo info = this.getLoginInfo(request);
        try {
            int ret = this.detailService.deleteRemarks(bo, info.getDatasource());
            JSONObject json = new JSONObject();
            json.put("state", true);


            this.sendJsonResponse(response, json.toString());

        } catch (Exception e) {
            log.error("删除备注出错", e);
        }
    }

    @RequestMapping("/getKqBcTimeByEmpId")
    public void getKqBcTimeByEmpId(HttpServletRequest request, HttpServletResponse response, Integer empId, String dateStr) {
        SysLoginInfo info = this.getLoginInfo(request);
        try {
            KqBc bc = this.detailService.getEmpBcByDate(empId, dateStr, info.getDatasource());
            String startTime = "";
            String endTime = "";
            if (bc != null) {
                List<KqBcTimes> list = bc.getSubList();
                if (list.size() > 0) {
                    KqBcTimes vo = list.get(0);
                    startTime = vo.getStartTime();
                    endTime = vo.getEndTime();
                }
                if (list.size() > 1) {
                    KqBcTimes vo = list.get(1);
                    endTime = vo.getEndTime();
                }
            }
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("startTime", startTime);
            json.put("endTime", endTime);

            this.sendJsonResponse(response, json.toString());

        } catch (Exception e) {
            log.error("分页查询考勤记录出错", e);
        }
    }


    @RequestMapping("/getKqBcTimeById")
    public void getKqBcTimeById(HttpServletRequest request, HttpServletResponse response, Integer bcId) {
        SysLoginInfo info = this.getLoginInfo(request);
        try {
            KqBc bc = this.detailService.getBcById1(bcId, info.getDatasource());
            String startTime = "";
            String endTime = "";
            if (bc != null) {
                List<KqBcTimes> list = bc.getSubList();
                if (list.size() > 0) {
                    KqBcTimes vo = list.get(0);
                    startTime = vo.getStartTime();
                    endTime = vo.getEndTime();
                }
                if (list.size() > 1) {
                    KqBcTimes vo = list.get(1);
                    endTime = vo.getEndTime();
                }
            }
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("startTime", startTime);
            json.put("endTime", endTime);

            this.sendJsonResponse(response, json.toString());

        } catch (Exception e) {
            log.error("分页查询考勤记录出错", e);
        }
    }

    @RequestMapping("/getKqBcByEmpIdAndDate")
    public void getKqBcByEmpIdAndDate(HttpServletRequest request, HttpServletResponse response, Integer empId, String dateStr) {
        SysLoginInfo info = this.getLoginInfo(request);
        try {
            KqBc bc = this.detailService.getEmpBcByDate(empId, dateStr, info.getDatasource());
            String bcName = "休";
            Integer bcId = 0;
            if (bc != null) {
                bcName = bc.getBcName();
                bcId = bc.getId();
            }
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("bcName", bcName);
            json.put("bcId", bcId);

            this.sendJsonResponse(response, json.toString());

        } catch (Exception e) {
            log.error("分页查询考勤班次出错", e);
        }
    }

    @RequestMapping("/toKqResultPrint")
    public String toKqPrint(HttpServletRequest request, Model model, String billName, KqEmpRule detail) {
        try {
            SysLoginInfo info = this.getLoginInfo(request);
            String tmpstr = detail.getEdate();
            if (tmpstr == null) return "";
            Date startDate = DateTimeUtil.getStrToDate(detail.getSdate(), "yyyy-MM-dd");
            Date endDate = DateTimeUtil.getStrToDate(tmpstr, "yyyy-MM-dd");
            endDate = DateTimeUtil.dateTimeAdd(endDate, 5, 1);//增加一天
            tmpstr = DateTimeUtil.getDateToStr(endDate, "yyyy-MM-dd");
            detail.setEdate(tmpstr);

            Page p = this.detailService.queryKqResult(detail, info.getDatasource(), 1, 99999);
            List<KqResultVo> list = p.getRows();
            List<Map<String, Object>> mapList = new ArrayList<Map<String, Object>>();
            Integer days = DateTimeUtil.getDaysDiff(startDate, endDate) - 1;
            if (days == 0) days = 1;
            for (KqResultVo vo : list) {
                Map<String, Object> map = map = new HashMap<String, Object>();//BeanUtils.describe(vo);
                map.put("memberNm", vo.getMemberNm());
                for (int i = 0; i < days; i++) {
                    String keyName = "_day" + Integer.valueOf(i);
                    List<String> dayStr = vo.getDayStr();
                    map.put(keyName, dayStr.get(i));
                }

                mapList.add(map);
            }
            model.addAttribute("mapList", mapList);
            model.addAttribute("printTitle", billName);
            List datas = this.printService.initKqResultPrint(startDate, endDate);
            model.addAttribute("datas", datas);


        } catch (Exception e) {
            // TODO: handle exception
            log.error("登录错误", e);
        }
        return "/kq/kq_result_print";
    }

    @RequestMapping("/toKqStatPrint")
    public String toKqStatPrint(HttpServletRequest request, Model model, String billName, KqEmpRule emp) {
        try {
            SysLoginInfo info = this.getLoginInfo(request);
            String tmpstr = emp.getEdate();
            if (tmpstr == null) return "";

            Date endDate = DateTimeUtil.getStrToDate(tmpstr, "yyyy-MM-dd");
            endDate = DateTimeUtil.dateTimeAdd(endDate, 5, 1);//增加一天
            tmpstr = DateTimeUtil.getDateToStr(endDate, "yyyy-MM-dd");
            emp.setEdate(tmpstr);
            Date startDate = DateTimeUtil.getStrToDate(emp.getSdate(), "yyyy-MM-dd");
            Page p = this.detailService.queryKqStatPage(emp, info.getDatasource(), 1, 99999);
            List<KqStat> list = p.getRows();
            List<Map<String, Object>> mapList = new ArrayList<Map<String, Object>>();

            for (KqStat vo : list) {
                Map map = BeanUtils.describe(vo);
                mapList.add(map);
            }
            model.addAttribute("mapList", mapList);
            model.addAttribute("printTitle", billName);
            List datas = this.printService.initKqStatPrint();
            model.addAttribute("datas", datas);


        } catch (Exception e) {
            // TODO: handle exception
            log.error("登录错误", e);
        }
        return "/kq/kq_result_print";
    }

}
