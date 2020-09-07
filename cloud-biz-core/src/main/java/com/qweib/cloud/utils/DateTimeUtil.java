package com.qweib.cloud.utils;

import lombok.extern.slf4j.Slf4j;

import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.Locale;

/**
 * 说明：时间工具类
 */
@Slf4j
public class DateTimeUtil {
    private static Calendar calendar = GregorianCalendar.getInstance(Locale.CHINA);
    public static final String longFormate1Str = "yyyyMMddHHmmss";
    public static final String longFormateStr = "yyyy-MM-dd HH:mm:ss";
    public static final String DEFAULT_YEAR_MON_DAY = "yyyy-MM-dd HH:mm:ss";

    public static String getDateToStr() {
        try {
            return getDateToStr(new Date(), longFormateStr);
        } catch (Exception ex) {
            log.error("日期转换出现错误", ex);
        }
        return null;
    }

    public static String getDateToStr(Date date) {
        try {
            if (date == null) return null;
            return getDateToStr(date, longFormateStr);
        } catch (Exception ex) {
            log.error("日期转换出现错误", ex);
        }
        return null;
    }

    /**
     * 字符串转为long型
     *
     * @param dateStr 必须带时、分、秒
     * @return
     */
    public static long strToLong(String dateStr) throws Exception {
        Date date = getStrToDate(dateStr, DEFAULT_YEAR_MON_DAY);
        return date.getTime();
    }

    /**
     * @param date    日期
     * @param formate 转化格式
     * @return String
     * @说明 得到格式为 formate 的日期Str
     */
    public static String getDateToStr(Date date, String formate) throws Exception {
        try {
            SimpleDateFormat simpleDateFormat = new SimpleDateFormat(formate, Locale.CHINA);
            return simpleDateFormat.format(date);
        } catch (Exception ex) {
            throw new Exception(ex);
        }
    }

    /**
     * 获取上个月的日期字符串
     */
    public static String getLastMonth(String formatStr) throws Exception {
        try {
            Calendar calendar = Calendar.getInstance();
            calendar.add(Calendar.MONTH, -1);
            SimpleDateFormat simpleDateFormat = new SimpleDateFormat(formatStr, Locale.CHINA);
            return simpleDateFormat.format(calendar.getTime());
        } catch (Exception ex) {
            throw new Exception(ex);
        }
    }

    /**
     * 获取本月的第一天日期字符串
     */
    public static String getMonthFirstDay(String formatStr) throws Exception {
        try {
            Calendar calendar = Calendar.getInstance();
            Integer year = calendar.get(Calendar.YEAR);
            Integer month = calendar.get(Calendar.MONTH);
            Date startDate = DateTimeUtil.getDateTime(year, month, 1);
            if (StrUtil.isNull(formatStr)) {
                formatStr = "yyyy-MM-dd";
            }
            return getDateToStr(startDate, formatStr);
        } catch (Exception ex) {
            throw new Exception(ex);
        }
    }

    public static Timestamp getTimestamp() {
        return new Timestamp(System.currentTimeMillis());
    }

    /**
     * @return String
     * @说明 得到格式为 formate 的日期Str
     */
    public static String getDateToStr(String dateStr, String formate1, String formate2) throws Exception {
        try {
            SimpleDateFormat simpleDateFormat1 = new SimpleDateFormat(formate1, Locale.CHINA);
            Date date = simpleDateFormat1.parse(dateStr);
            SimpleDateFormat simpleDateFormat2 = new SimpleDateFormat(formate2, Locale.CHINA);
            return simpleDateFormat2.format(date);
        } catch (Exception ex) {
            throw new Exception(ex);
        }
    }

    /**
     * @param str
     * @param formate 转化格式
     * @return Date
     * @说明 得到格式为 formate 的日期
     */
    public static Date getStrToDate(String str, String formate) throws Exception {
        try {
            SimpleDateFormat simpleDateFormat = new SimpleDateFormat(formate, Locale.CHINA);
            return simpleDateFormat.parse(str);
        } catch (ParseException pe) {
            throw new Exception(pe);
        } catch (Exception ex) {
            throw new Exception(ex);
        }
    }

    /**
     * @return int
     * @说明 获取系统时间年份
     */
    public static int getYear() {
        return calendar.get(Calendar.YEAR);
    }

    /**
     * @param date
     * @return int
     * @说明 根据指定的时间返回年份
     */
    public static int getYear(Date date) {
        Calendar c = GregorianCalendar.getInstance(Locale.CHINA);
        c.setTime(date);
        return c.get(Calendar.YEAR);
    }

    /**
     * @return int
     * @说明 返回系统时间月份
     */
    public static int getMonth() {
        return calendar.get(Calendar.MONTH);
    }

    /**
     * @return int
     * @说明 根据指定的时间返回月份
     */
    public static int getMonth(Date date) {
        Calendar c = GregorianCalendar.getInstance(Locale.CHINA);
        c.setTime(date);
        return c.get(Calendar.MONTH);
    }

    /**
     * @return int
     * @说明 返回当前系统时间的日期(天)
     */
    public static int getDay() {
        return calendar.get(Calendar.DATE);
    }


    /**
     * @return
     * @说明 根据指定的时间返回日期(天)
     */
    public static int getDay(Date date) {
        Calendar c = GregorianCalendar.getInstance(Locale.CHINA);
        c.setTime(date);
        return c.get(Calendar.DATE);
    }

    /**
     * @return
     * @说明：获取月份有多少天
     * @创建：作者:yxy 创建时间：2011-5-14
     */
    public static int getDays(int year, int month) {
        Calendar cal = Calendar.getInstance();
        cal.set(Calendar.YEAR, year);
        cal.set(Calendar.MONTH, (month - 1));//Java月份才0开始算
        return cal.getActualMaximum(Calendar.DATE);
    }

    /**
     * @return
     * @说明：获取月份有多少天
     * @创建：作者:yxy 创建时间：2011-5-14
     */
    public static int getDays(String tgMonth) {
        Calendar cal = Calendar.getInstance();
        int year = Integer.valueOf(tgMonth.substring(0, 4));
        int month = Integer.valueOf(tgMonth.substring(5, 7));
        cal.set(Calendar.YEAR, year);
        cal.set(Calendar.MONTH, (month - 1));//Java月份才0开始算
        return cal.getActualMaximum(Calendar.DATE);
    }

    /**
     * @param year
     * @param month
     * @param day
     * @return
     * @说明 返回自定义时间
     */
    public static Date getDateTime(int year, int month, int day) {
        Calendar c = GregorianCalendar.getInstance(Locale.CHINA);
        c.set(year, month, day);
        return c.getTime();
    }

    /**
     * @param type 5--天  2--月 1--年
     * @return
     * @说明 日期加减
     */
    public static Date dateTimeAdd(Date date, int type, int amount) {
        Calendar c = GregorianCalendar.getInstance(Locale.CHINA);
        c.setTime(date);
        c.add(type, amount);
        return c.getTime();
    }

    /**
     * @param type 5--天  2--月 1--年
     * @return
     * @说明 日期加减
     */
    public static Date dateTimeAdd(String str, int type, int amount, String formate) throws Exception {
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat(formate, Locale.CHINA);
        Calendar c = GregorianCalendar.getInstance(Locale.CHINA);
        try {
            c.setTime(simpleDateFormat.parse(str));
            c.add(type, amount);
            return c.getTime();
        } catch (ParseException e) {
            throw new Exception(e);
        }
    }

    /**
     * @param type 5--天  2--月 1--年
     * @return
     * @说明 日期加减
     */
    public static String dateTimeAddToStr(String str, int type, int amount, String formate) throws Exception {
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat(formate, Locale.CHINA);
        Calendar c = GregorianCalendar.getInstance(Locale.CHINA);
        try {
            c.setTime(simpleDateFormat.parse(str));
            c.add(type, amount);
            return simpleDateFormat.format(c.getTime());
        } catch (ParseException e) {
            throw new Exception(e);
        }
    }

    /**
     * 摘要：
     *
     * @param dte
     * @return
     * @说明：根据日期获取当前时间是周几
     * @创建：作者:yxy 创建时间：2011-8-18
     * @修改历史： [序号](yxy 2011 - 8 - 18)<修改说明>
     */
    public static Integer getWeekByDate(Date dte) {
        Calendar c = GregorianCalendar.getInstance(Locale.CHINA);
        c.setTime(dte);
        return c.get(Calendar.DAY_OF_WEEK);
    }

    public static String getWeekNameByDate(Date dte) {
        Calendar c = GregorianCalendar.getInstance(Locale.CHINA);
        c.setTime(dte);
        int n = c.get(Calendar.DAY_OF_WEEK);
        String week = "";
        switch (n) {
            case 1:
                week = "星期天";
                break;
            case 2:
                week = "星期一";
                break;
            case 3:
                week = "星期二";
                break;
            case 4:
                week = "星期三";
                break;
            case 5:
                week = "星期四";
                break;
            case 6:
                week = "星期五";
                break;
            case 7:
                week = "星期六";
                break;
        }
        return week;
    }

    /**
     * 摘要：
     *
     * @param str
     * @param formate
     * @return
     * @throws Exception
     * @说明：根据日期获取当前时间是周几
     * @创建：作者:yxy 创建时间：2011-8-18
     * @修改历史： [序号](yxy 2011 - 8 - 18)<修改说明>
     */
    public static Integer getWeekByStr(String str, String formate) {
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat(formate, Locale.CHINA);
        Calendar c = GregorianCalendar.getInstance(Locale.CHINA);
        try {
            c.setTime(simpleDateFormat.parse(str));
            return c.get(Calendar.DAY_OF_WEEK);
        } catch (ParseException e) {
            return null;
        }
    }

    /**
     * 摘要：
     *
     * @return
     * @throws Exception
     * @说明：根据两个日期字符串获取之间相差多少天
     * @创建：作者:yxy 创建时间：2011-8-18
     * @修改历史： [序号](yxy 2011 - 8 - 18)<修改说明>
     */
    public static Integer getDaysDiff(String str1, String str2, String formate) {
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat(formate, Locale.CHINA);
        try {
            long d1 = simpleDateFormat.parse(str1).getTime();
            long d2 = simpleDateFormat.parse(str2).getTime();
            long t = (d2 - d1) / 1000;
            Long l = t / (3600 * 24);
            return l.intValue() + 1;
        } catch (ParseException e) {
            return null;
        }
    }

    /**
     * 摘要：
     *
     * @return
     * @throws Exception
     * @说明：根据两个日期字符串获取之间相差多少天
     * @创建：作者:yxy 创建时间：2011-8-18
     * @修改历史： [序号](yxy 2011 - 8 - 18)<修改说明>
     */
    public static Integer getDaysDiff(Date dt1, Date dt2) {
        try {
            long d1 = dt1.getTime();
            long d2 = dt2.getTime();
            long t = (d2 - d1) / 1000;
            Long l = t / (3600 * 24);
            return l.intValue() + 1;
        } catch (Exception e) {
            return null;
        }
    }

    public static Integer getMinutes(Date d1, Date d2) {
        long nm = 1000 * 60;
        long diff = d2.getTime() - d1.getTime();
        Long min = diff / nm;
        return min.intValue();
    }

    /**
     * 摘要：
     *
     * @param str
     * @param formate
     * @return
     * @throws Exception
     * @说明：根据时间字符串获取与当前相差多少
     * @创建：作者:yxy 创建时间：2011-8-18
     * @修改历史： [序号](yxy 2011 - 8 - 18)<修改说明>
     */
    @SuppressWarnings("deprecation")
    public static String getDaysDiff(String str, String formate) {
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat(formate, Locale.CHINA);
        try {
            Date d1 = simpleDateFormat.parse(str);
            Date d2 = new Date();
            int year1 = d1.getYear();
            int year2 = d2.getYear();
            int month1 = d1.getMonth();
            int month2 = d2.getMonth();
            int day1 = d1.getDate();
            int day2 = d2.getDate();
            int hours1 = d1.getHours();
            int hours2 = d2.getHours();
            if ((year1 == year2 && month1 == month2 && day1 == day2 && hours1 == hours2)) {
                int temp = (d2.getMinutes() - d1.getMinutes());
                return (temp <= 0 ? 1 : temp) + "分钟前";
            } else if ((year1 == year2 && month1 == month2 && day1 == day2 && (hours1 + 1) == hours2 && d1.getMinutes() > 30 && d2.getMinutes() < 30)) {
                int temp = 60 - d1.getMinutes() + d2.getMinutes();
                return temp + "分钟前";
            } else if (year1 == year2 && month1 == month2 && day1 == day2) {
                return (hours2 - hours1) + "小时前";
            } else if ((year1 == year2 && month1 == month2) || (year1 == year2 && (month1 + 1) == month2)) {
                long time1 = d1.getTime();
                long time2 = d2.getTime();
                long t = (time2 - time1) / 1000;
                Long l = t / (3600 * 24);
                return (l.intValue() + 1) + "天前";
            } else if (year1 == year2) {
                return (month2 - month1) + "个月前";
            } else {
                return (year2 - year1) + "年前";
            }
        } catch (ParseException e) {
            return "";
        }
    }

    //剩余百分之pcent时间计算
    public static String getTimePercent(String beginDt, String endDt, Integer pcent) {
        String str = "";
        try {
            Date bdt = DateTimeUtil.getStrToDate(beginDt, "yyyy-MM-dd HH:mm");
            Date edt = DateTimeUtil.getStrToDate(endDt, "yyyy-MM-dd HH:mm");

            Long bTime = bdt.getTime();
            Long eTime = edt.getTime();

            Long dis = eTime - bTime;
            long l = (dis * (100 - pcent)) / 100;
            Date newDate = new Date(l + bTime);
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
            str = sdf.format(newDate);
        } catch (Exception e) {
            e.printStackTrace();
            return "";
        }
        return str;
    }

    //时间减去时间(分钟算)
    public static String getTimeMinus(String endDt, Integer mtime) {
        String str = "";
        try {
            Date edt = DateTimeUtil.getStrToDate(endDt, "yyyy-MM-dd HH:mm");
            Long eTime = edt.getTime();

            long l = mtime * 60 * 1000;
            Date newDate = new Date(eTime - l);
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
            str = sdf.format(newDate);
        } catch (Exception e) {
            e.printStackTrace();
            return "";
        }
        return str;
    }

    public static Date decMinute(Date dt, Integer minute) {
        Long eTime = dt.getTime();
        long l = minute * 60 * 1000;
        Date newDate = new Date(eTime - l);
        return newDate;
    }

    public static Date addMinute(Date dt, Integer minute) {
        Long eTime = dt.getTime();
        long l = minute * 60 * 1000;
        Date newDate = new Date(eTime + l);
        return newDate;
    }

    public static Date addDay(Date dt, Integer days) {
        Date currdate = dt;
        Calendar ca = Calendar.getInstance();
        ca.setTime(dt);
        ca.add(Calendar.DATE, days);// days为增加的天数，可以改变的
        currdate = ca.getTime();
        return currdate;
    }

    public static Date addMonth(Date dt, Integer months) {
        Date currdate = dt;
        Calendar ca = Calendar.getInstance();
        ca.setTime(dt);
        ca.add(Calendar.MONTH, months);// days为增加的天数，可以改变的
        currdate = ca.getTime();
        return currdate;
    }

    public static Date addYear(Date dt, Integer years) {
        Date currdate = dt;
        Calendar ca = Calendar.getInstance();
        ca.setTime(dt);
        ca.add(Calendar.YEAR, years);// days为增加的天数，可以改变的

        currdate = ca.getTime();
        return currdate;
    }


    /**
     * 秒转成天时分秒
     *
     * @param mss
     * @return
     */
    public static String formatDateTime(long mss) {
        String DateTimes = null;
        long days = mss / (60 * 60 * 24);
        long hours = (mss % (60 * 60 * 24)) / (60 * 60);
        long minutes = (mss % (60 * 60)) / 60;
        long seconds = mss % 60;
        if (days > 0) {
            DateTimes = days + "天" + hours + "时" + minutes + "分"
                    + seconds + "秒";
        } else if (hours > 0) {
            DateTimes = hours + ":" + minutes + ":" + seconds;
        } else if (minutes > 0) {
            DateTimes = minutes + ":" + seconds;
        } else {
            DateTimes = seconds + "";
        }

        return DateTimes;
    }

    public static void main(String[] args) {
        long mss = 3600;
        System.out.println(formatDateTime(mss));
    }

 /*   public static void main(String[] args) {
        String time = "2015-08-03";
        Integer a = getWeekByStr(time, "yyyy-MM-dd");
        System.out.println(a);
    }*/
}
