package com.qweib.cloud.biz.attendance.service;

import com.qweib.cloud.biz.attendance.model.KqPrintConfig;
import com.qweib.cloud.utils.DateTimeUtil;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Service
public class KqPrintService {

    public List<KqPrintConfig> initKqResultPrint(Date startDate, Date endDate) {
        List<KqPrintConfig> list = new ArrayList<KqPrintConfig>();
        KqPrintConfig vo1 = new KqPrintConfig();
        vo1.setFdFieldKey("memberNm");
        vo1.setFdFieldName("姓名");
        vo1.setFdWidth(5);
        list.add(vo1);
        Integer days = DateTimeUtil.getDaysDiff(startDate, endDate) - 1;
        if (days == 0) days = 1;
        try {
            double f = 95f;
            f = f / days;
            int fwidth = (int) f;
            for (int i = 0; i < days; i++) {
                Date curDate = DateTimeUtil.dateTimeAdd(startDate, 5, i);
                String ymd = DateTimeUtil.getDateToStr(curDate, "yyyy-MM-dd");
                String title = ymd.substring(8, 10);
                KqPrintConfig vo = new KqPrintConfig();
                vo.setFdFieldKey("_day" + String.valueOf(i));
                vo.setOrderCd(i);
                vo.setFdFieldName(title);
                vo.setFdWidth(fwidth);
                list.add(vo);


            }
        } catch (Exception e) {

        }
        return list;
    }

    public List<KqPrintConfig> initKqStatPrint() {
        List<KqPrintConfig> list = new ArrayList<KqPrintConfig>();
        KqPrintConfig vo1 = new KqPrintConfig();
        vo1.setFdFieldKey("memberNm");
        vo1.setFdFieldName("姓名");
        vo1.setFdWidth(10);
        list.add(vo1);
        double f = 90f;
        f = f / 12;
        int fwidth = (int) f;
        vo1 = new KqPrintConfig();
        vo1.setFdFieldKey("pbDays");
        vo1.setFdFieldName("排班天数");
        vo1.setFdWidth(fwidth);
        list.add(vo1);

        vo1 = new KqPrintConfig();
        vo1.setFdFieldKey("monthDays");
        vo1.setFdFieldName("实际出勤");
        vo1.setFdWidth(fwidth);
        list.add(vo1);

        vo1 = new KqPrintConfig();
        vo1.setFdFieldKey("cdQty");
        vo1.setFdFieldName("迟到次数");
        vo1.setFdWidth(fwidth);
        list.add(vo1);

        vo1 = new KqPrintConfig();
        vo1.setFdFieldKey("cdMinute");
        vo1.setFdFieldName("迟到分钟");
        vo1.setFdWidth(fwidth);
        list.add(vo1);
        vo1 = new KqPrintConfig();
        vo1.setFdFieldKey("ztQty");
        vo1.setFdFieldName("早退次数");
        vo1.setFdWidth(fwidth);
        list.add(vo1);
        vo1 = new KqPrintConfig();
        vo1.setFdFieldKey("ztMinute");
        vo1.setFdFieldName("早退分钟");
        vo1.setFdWidth(fwidth);
        list.add(vo1);
        vo1 = new KqPrintConfig();
        vo1.setFdFieldKey("lkQty");
        vo1.setFdFieldName("漏卡次数");
        vo1.setFdWidth(fwidth);
        list.add(vo1);
        vo1 = new KqPrintConfig();
        vo1.setFdFieldKey("kgQty");
        vo1.setFdFieldName("旷工次数");
        vo1.setFdWidth(fwidth);
        list.add(vo1);
        vo1 = new KqPrintConfig();
        vo1.setFdFieldKey("outOfQty");
        vo1.setFdFieldName("考勤地点错误");
        vo1.setFdWidth(fwidth);
        list.add(vo1);
        vo1 = new KqPrintConfig();
        vo1.setFdFieldKey("workHours");
        vo1.setFdFieldName("工作小时数");
        vo1.setFdWidth(fwidth);
        list.add(vo1);
        vo1 = new KqPrintConfig();
        vo1.setFdFieldKey("qjQty");
        vo1.setFdFieldName("请假小时数");
        vo1.setFdWidth(fwidth);
        list.add(vo1);
        vo1 = new KqPrintConfig();
        vo1.setFdFieldKey("jbQty");
        vo1.setFdFieldName("加班小时数");
        vo1.setFdWidth(fwidth);

        list.add(vo1);
        return list;
    }

}
