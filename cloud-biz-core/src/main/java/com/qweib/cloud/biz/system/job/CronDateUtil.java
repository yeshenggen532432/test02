package com.qweib.cloud.biz.system.job;

import java.text.SimpleDateFormat;
import java.util.Date;

public class CronDateUtil {

    public static void main(String[] str) {
        Date startTime = new Date();
        startTime.setTime(startTime.getTime() + 1000 * 60 * 2);

        String cron = CronDateUtil.getCron(startTime);
        System.out.println(cron);

        String data = fmtDateToStr(getCron(cron), null);
        System.out.println(data);
    }

    /**
     * 几秒后的cron表达式
     *
     * @param second
     * @return
     */
    public static String getCron(long second) {
        Date startTime = new Date();
        startTime.setTime(startTime.getTime() + 1000 * second);
        return CronDateUtil.getCron(startTime);
    }

    /**
     * 日期转化为cron表达式
     *
     * @param date
     * @return
     */
    public static String getCron(Date date) {
        String dateFormat = "ss mm HH dd MM ? yyyy";
        return CronDateUtil.fmtDateToStr(date, dateFormat);
    }

    /**
     * cron表达式转为日期
     *
     * @param cron
     * @return
     */
    public static Date getCron(String cron) {
        String dateFormat = "ss mm HH dd MM ? yyyy";
        SimpleDateFormat sdf = new SimpleDateFormat(dateFormat);
        Date date = null;
        try {
            date = sdf.parse(cron);
        } catch (Exception e) {
            return null;
        }
        return date;
    }

    /**
     * Description:格式化日期,String字符串转化为Date
     *
     * @param date
     * @param dtFormat 例如:yyyy-MM-dd HH:mm:ss yyyyMMdd
     * @return
     */
    public static String fmtDateToStr(Date date, String dtFormat) {
        if (date == null)
            return "";
        try {
            if (dtFormat == null || "".equals(dtFormat)) dtFormat = "yyyy-MM-dd HH:mm:ss";
            SimpleDateFormat dateFormat = new SimpleDateFormat(dtFormat);
            return dateFormat.format(date);
        } catch (Exception e) {
            e.printStackTrace();
            return "";
        }
    }
}