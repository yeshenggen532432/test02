package com.qweib.cloud.biz.attendance.control;


import com.qweib.cloud.biz.attendance.model.KqEmpRule;
import com.qweib.cloud.biz.attendance.service.KqCheckService;
import com.qweib.cloud.biz.attendance.service.KqDetailService;
import com.qweib.cloud.biz.common.GeneralControl;
import com.qweib.cloud.biz.system.service.plat.SysCheckInPcService;
import com.qweib.cloud.biz.system.service.ws.SysDepartService;
import com.qweib.cloud.core.domain.SysCheckIn;
import com.qweib.cloud.core.domain.SysCheckInPC;
import com.qweib.cloud.core.domain.SysDepart;
import com.qweib.cloud.core.domain.SysLoginInfo;
import com.qweib.cloud.utils.*;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.poifs.filesystem.POIFSFileSystem;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.net.URLEncoder;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

@Controller
@RequestMapping("/manager")
public class KqCheckInControl extends GeneralControl {
    @Resource
    private SysCheckInPcService checkInService;
    @Resource
    private KqCheckService checkInService1;
    @Resource
    private SysDepartService departService;

    @Resource
    private KqDetailService detailService;



    //到签到列表页面
    @RequestMapping("/toCheckInPage")
    public String toCheckInPage(HttpServletRequest request, Model model, String dataTp) {
        SysLoginInfo info = getInfo(request);
        List<SysDepart> list = this.departService.queryDepartLsall(info.getDatasource());
        model.addAttribute("listb", list);
        model.addAttribute("dataTp", dataTp);
        return "/publicplat/checkIn/pageList";
    }

    @RequestMapping("/toKqCheckin")
    public String toKqCheckin(HttpServletRequest request, Model model, String dataTp) {
        SysLoginInfo info = getInfo(request);
        //List<SysDepart> list=this.departService.queryDepartLsall(info.getDatasource());
        //model.addAttribute("listb",list);
        try {
            Calendar calendar = Calendar.getInstance();
            Integer year = calendar.get(Calendar.YEAR);
            Integer month = calendar.get(Calendar.MONTH);
            Date startDate = DateTimeUtil.getDateTime(year, month, 1);

            model.addAttribute("sdate", DateTimeUtil.getDateToStr(startDate, "yyyy-MM-dd"));
            model.addAttribute("edate", DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd"));
            model.addAttribute("dataTp", dataTp);
        } catch (Exception e) {
            log.error("签到记录数据查询出错:", e);
        }
        return "/kq/kq_checkin";

    }

    /**
     * @param request
     * @param response
     * @param
     * @param page
     * @param rows
     * @创建：作者:YYP 创建时间：Jul 30, 2015
     * @see
     */
    @RequestMapping("checkInPage")
    public void checkInPage(HttpServletRequest request, HttpServletResponse response,
                            Integer page, Integer rows, Integer psnId, String memberNm, Integer branchId, String atime,
                            String btime, String dataTp) {
        try {
            SysLoginInfo info = getInfo(request);
            Page p = checkInService.page(psnId, memberNm, branchId, atime, btime, dataTp, info.getIdKey(), page, rows, info.getDatasource());

            JSONObject json = new JSONObject();
            json.put("total", p.getTotal());
            json.put("rows", p.getRows());
            json.put("memberNm", memberNm);
            json.put("atime", atime);
            json.put("btime", btime);
            this.sendJsonResponse(response, json.toString());
            p = null;
        } catch (Exception e) {
            log.error("签到记录数据查询出错:", e);
        }
    }

    /**
     * @param request
     * @param response
     * @param memNm
     * @param time1
     * @param time2
     * @创建：作者:YYP 创建时间：Aug 3, 2015
     * @see
     */
    @RequestMapping("loadForExcel")
    public void loadForExcel(HttpServletRequest request, HttpServletResponse response, String memNm, String time1, String time2, Integer branchId2) {
        FileInputStream in = null;
        FileOutputStream out = null;
        POIFSFileSystem fs = null;
        InputStream inStream = null;
        File tempFile = null;
        try {
            SysLoginInfo info = getInfo(request);
            List<SysCheckInPC> checkinList = checkInService.queryCheckInList(memNm, time1, time2, branchId2, info.getDatasource());
            String path = request.getSession().getServletContext().getRealPath("exefile");
            File file = new File(path + "\\checkInbase.xls");
            tempFile = new File(request.getSession().getServletContext().getRealPath("/upload") + "\\temp\\" + System.currentTimeMillis() + ".xls");
            //拷贝临时文件
            FileUtil.copyFile(file, tempFile);
            file = null;
            in = new FileInputStream(tempFile);
            fs = new POIFSFileSystem(in);
            HSSFWorkbook workBook = new HSSFWorkbook(fs);
            Font f = new Font();
            f.setFontSize((short) 12);
            HSSFFont font = ExcelUtil.getHSSFFont(workBook, f);
            HSSFSheet sheet0 = workBook.getSheetAt(0);
            //excel标题--导出条件
            String condition = getConditionStr(memNm, time1, time2);
            Font f1 = new Font();
            f1.setFontSize((short) 14);
            f1.setBold(HSSFFont.BOLDWEIGHT_BOLD);
            HSSFFont font1 = ExcelUtil.getHSSFFont(workBook, f1);
            ExcelUtil.setCells(0, 0, "考勤详细表" + condition, font1, sheet0);
            int index = 2;
            if (checkinList.size() > 0 && checkinList != null) {
                for (SysCheckInPC checkIn : checkinList) {
                    ExcelUtil.setCells(index, 0, index - 1, font, sheet0);//序号
                    ExcelUtil.setCells(index, 1, null == checkIn.getBranchNm() ? "" : checkIn.getBranchNm(), font, sheet0);//部门
                    ExcelUtil.setCells(index, 2, null == checkIn.getMemberNm() ? "" : checkIn.getMemberNm(), font, sheet0);//姓名
                    String dateweek = checkIn.getDateweek();
                    ExcelUtil.setCells(index, 3, null == checkIn.getCdate() ? "" : checkIn.getCdate() + getWeek(dateweek), font, sheet0);//日期
                    ExcelUtil.setCells(index, 4, null == checkIn.getLocation() ? "" : checkIn.getLocation(), font, sheet0);// 地址
                    ExcelUtil.setCells(index, 5, null == checkIn.getStime() ? "" : checkIn.getStime(), font, sheet0);//上班时间
                    ExcelUtil.setCells(index, 6, null == checkIn.getEtime() ? "" : checkIn.getEtime(), font, sheet0);//下班时间
                    ExcelUtil.setCells(index, 7, null == checkIn.getCdzt() ? "" : checkIn.getCdzt(), font, sheet0);//迟到/早退情况
                    index++;
                }
            }

            out = new FileOutputStream(tempFile);
            workBook.write(out);//写入文件
            String fileName = "考勤数据" + DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd") + ".xls";
            if (request.getHeader("User-Agent").toLowerCase().indexOf("firefox") > 0)
                fileName = new String(fileName.getBytes("UTF-8"), "ISO8859-1");// firefox浏览器
            else if (request.getHeader("User-Agent").toUpperCase().indexOf("MSIE") > 0)
                fileName = URLEncoder.encode(fileName, "UTF-8");// IE浏览器
            inStream = new FileInputStream(tempFile);
            response.reset();
            response.setContentType("application/vnd.ms-excel;");
            response.setContentType("text/html;charset=UTF-8"); // 设置输出编码格式
            response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
            //循环取出流中的数据
            byte[] b = new byte[inStream.available()];
            int len;
            while ((len = inStream.read(b)) > 0)
                response.getOutputStream().write(b, 0, len);
            inStream.close();
            tempFile.delete();
            tempFile = null;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (null != in) {
                    in.close();
                }
                if (null != out) {
                    out.close();
                }
                fs = null;
                if (null != inStream) {
                    inStream.close();
                }
                if (null != tempFile) {
                    tempFile.delete();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    //带条件文字
    private String getConditionStr(String memNm, String time1, String time2) {
        String condition = "";
        if (!StrUtil.isNull(time1) || !StrUtil.isNull(time2) || !StrUtil.isNull(memNm)) {
            condition += "(";
            if (!StrUtil.isNull(memNm)) {
                condition += " 姓名<包含>：" + memNm;
            }
            if (!StrUtil.isNull(time1) || !StrUtil.isNull(time2)) {
                condition += " 日期：";
                if (!StrUtil.isNull(time1) && !StrUtil.isNull(time2)) {
                    condition += time1 + "至" + time2;
                } else if (!StrUtil.isNull(time1)) {
                    condition += "大于" + time1;
                } else if (!StrUtil.isNull(time2)) {
                    condition += "小于" + time2;
                }
            }
            condition += ")";
        }
        return condition;
    }

    //转成成星期
    private String getWeek(String dateweek) {
        String w = "";
        if ("1".equals(dateweek)) {
            w = " 星期日";
        } else if ("2".equals(dateweek)) {
            w = " 星期一";
        } else if ("3".equals(dateweek)) {
            w = " 星期二";
        } else if ("4".equals(dateweek)) {
            w = " 星期三";
        } else if ("5".equals(dateweek)) {
            w = " 星期四";
        } else if ("6".equals(dateweek)) {
            w = " 星期五";
        } else if ("7".equals(dateweek)) {
            w = " 星期六";
        }
        return w;
    }

    /**
     * 补签
     *
     * @param response
     * @param request
     * @param
     */
    @RequestMapping("manuAddCheckIn")
    public void manuAddCheckIn(HttpServletResponse response, HttpServletRequest request, SysCheckIn checkIn) {
        SysLoginInfo info = this.getLoginInfo(request);
        try {
            checkIn.setCdzt("补签");
            double f = (double) 0;
            checkIn.setLatitude(f);
            checkIn.setLongitude(f);
            checkIn.setJobContent("");
            checkIn.setLocation("");
            int ret = this.checkInService1.addCheck(checkIn, info.getDatasource(), null);
            JSONObject json = new JSONObject();
            if (ret > 0) {
                json.put("state", true);
                json.put("id", ret);

            } else {
                json.put("state", false);
            }
            //计算考勤
            if(checkIn.getTp().equals("1-2")) {//如果是下班
                String endDate = checkIn.getCheckTime().substring(0, 10);
                Date dt = DateTimeUtil.getStrToDate(endDate, "yyyy-MM-dd");
                dt = DateTimeUtil.addDay(dt, 1);
                endDate = DateTimeUtil.getDateToStr(dt, "yyyy-MM-dd");
                Date lastDt = DateTimeUtil.addMonth(dt, -1);
                String lastKqDate = this.detailService.getLastKqDate(checkIn.getPsnId(), endDate, info.getDatasource());
                if (lastKqDate.length() == 0) lastKqDate = DateTimeUtil.getDateToStr(lastDt, "yyyy-MM-dd");
                KqEmpRule emp = new KqEmpRule();
                emp.setSdate(lastKqDate);
                emp.setEdate(endDate);
                emp.setMemberId(checkIn.getPsnId());
                detailService.addKqDetail(emp, info.getDatasource());
            }
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            this.sendJsonResponse(response, "{\"state\":false,\"msg\":\"保存失败\"}");
        }
    }

    @RequestMapping("chgCheckInPos")
    public void chgCheckInPos(HttpServletResponse response, HttpServletRequest request, Integer checkId) {
        SysLoginInfo info = this.getLoginInfo(request);
        try {


            int ret = this.checkInService1.updateCheck(checkId, info.getDatasource());
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


    @RequestMapping("deleteCheckIn")
    public void deleteCheckIn(HttpServletResponse response, HttpServletRequest request, String ids) {
        SysLoginInfo info = this.getLoginInfo(request);
        try {

            int ret = this.checkInService1.deleteCheck(ids, info.getDatasource());
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
