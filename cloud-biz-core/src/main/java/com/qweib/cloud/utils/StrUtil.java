package com.qweib.cloud.utils;

import com.qweib.commons.StringUtils;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.security.MessageDigest;
import java.text.DateFormat;
import java.text.DecimalFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * 类说明：字符串，消息处理工具类
 */

final public class StrUtil {
    final static String[] chineseNumber = {"零", "壹", "贰", "叁", "肆", "伍", "陆", "柒", "捌", "玖"};
    final static String[] chineseIntBit = {"元", "拾", "佰", "仟"};
    final static String[] chineseLongBit = {"万", "亿"};
    final static String[] chineseDecBit = {"角", "分"};
    final static String chineseZero = "整";
    final static char[] bcdLookup = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f'};
    //本地测试
    public static String weburl = "http://www.7weib.com:8081/cnlife/web/";
    //外网(正)
    //public static String weburl = "http://uglcw.941soft.com:8081/cnlife/web/";
    //外网
    //public static String weburl = "http://122.114.162.76:8080/cnlife/web/";

    /**
     * 不允许实例化
     */
    private StrUtil() {

    }

    /**
     * 字符串：空
     */
    public static boolean isNull(Object str) {
        //测试11
        if (str == null) {
            return true;
        } else if (str.toString().trim().length() == 0) {
            return true;
        } else if (str.toString().trim() == "null") {
            return true;
        }
        return false;
    }

    /**
     * 判断金额大于0
     * @param amt
     * @return
     */
    public static boolean isHaveAmt(BigDecimal amt)
    {
        if(amt == null)return false;
        if(amt.doubleValue() < 0)return false;
        return true;
    }

    /**
     * 字符串：不为空
     */
    public static boolean isNotNull(Object str) {
        return !isNull(str);
    }


    /**
     * 摘要：
     *
     * @param obj
     * @return
     * @说明：根据对象转化为字符串
     * @创建：作者:yxy 创建时间：2012-1-12
     * @修改历史： [序号](yxy 2012 - 1 - 12)<修改说明>
     */
    public static String transStrByObj(Object obj) {
        return null == obj ? "" : obj.toString();
    }

    /**
     * 判断string是否是数字 return boolean
     */
    public static Boolean isStrNum(String str) {
        if (null == str || "".equals(str)) {
            return false;
        }
        Pattern pattern = Pattern.compile("^\\d+(\\.\\d+)?$");
        Matcher mc = pattern.matcher(str);
        return mc.matches();
    }

    /**
     * 设置字符串为空
     *
     * @param strText
     * @return
     */
    public static String setNull(String strText) {
        strText = "null";
        return strText;
    }

    /**
     * 格式化字符串，数量字段专用，返回##0.0000.
     *
     * @param sQty
     * @return
     */
    public static String formatQty(String sQty) {
        if (sQty == null || sQty.equals("")) {
            sQty = "0";
        }
        Double dQty = new Double(sQty);
        DecimalFormat df = new DecimalFormat("##0.000");
        sQty = df.format(dQty);
        return sQty;
    }

    /**
     * 格式化字符串，数量字段专用，当f=null时默认返回###,##0.0000，并自动去除小数点后的0 其它按格式返回
     *
     * @param sQty
     * @param f
     * @return
     */
    public static String formatQty(String sQty, String f) {
        if (sQty == null || sQty.equals(""))
            sQty = "0";

        Double dQty = new Double(sQty);

        DecimalFormat df = new DecimalFormat("##0.0000");
        if (f != null) {
            df = new DecimalFormat(f);
        }
        sQty = df.format(dQty);
        return sQty;
    }

    /**
     * 格式化字符串，数量字段专用，返回######.0000，并自动去除小数点后的0
     *
     * @param dQty
     * @return
     */
    public static String formatQty(double dQty) {
        DecimalFormat df = new DecimalFormat("##0.0000");

        return df.format(dQty);
    }

    // 两位小数
    public static String formatQty2(double dQty) {
        DecimalFormat df = new DecimalFormat("##0.00");

        return df.format(dQty);
    }

    // 三位小数
    public static String formatQty3(double dQty) {
        DecimalFormat df = new DecimalFormat("##0.000");

        return df.format(dQty);
    }

    /**
     * 格式化字符串，数量字段专用，当f=null时默认返回###,###.0000，并自动去除小数点后的0 其它按格式返回
     *
     * @param dQty
     * @param f
     * @return
     */
    public static String formatQty(double dQty, String f) {
        DecimalFormat df = new DecimalFormat("##0.0000");
        if (f != null) {
            df = new DecimalFormat(f);
        }
        String sQty = null;
        sQty = df.format(dQty);
        return sQty;
    }

    /**
     * 格式化字符串，单价字段专用，返回######.000000，并自动去除小数点后的0
     *
     * @return
     */
    public static String formatPrice(String sPrice) {
        if (sPrice == null || sPrice.equals(""))
            sPrice = "0";

        Double dPrice = new Double(sPrice);
        DecimalFormat df = new DecimalFormat("##0.000");
        return df.format(dPrice);
    }

    /**
     * 格式化字符串，单价字段专用，当f=null时默认返回###,###.000000，并自动去除小数点后的0 其它按格式返回
     *
     * @param sPrice
     * @param f
     * @return
     */
    public static String formatPrice(String sPrice, String f) {
        if (sPrice == null || sPrice.equals(""))
            sPrice = "0";
        Double dPrice = new Double(sPrice);
        DecimalFormat df = new DecimalFormat("##0.000000");
        if (f != null) {
            df = new DecimalFormat(f);
        }
        sPrice = df.format(dPrice);
        return sPrice;
    }

    /**
     * 格式化字符串，单价字段专用，返回######.000000，并自动去除小数点后的0
     *
     * @param dPrice
     * @return
     */
    public static String formatPrice(double dPrice) {
        DecimalFormat df = new DecimalFormat("##0.000000");
        return df.format(dPrice);
    }

    // 两位小数
    public static String formatPrice2(double dPrice) {
        DecimalFormat df = new DecimalFormat("##0.000");
        return df.format(dPrice);
    }

    /**
     * 格式化字符串，单价字段专用，当f=null时默认返回###,###.000000，并自动去除小数点后的0 其它按格式返回
     *
     * @param dPrice
     * @param f
     * @return
     */
    public static String formatPrice(double dPrice, String f) {
        DecimalFormat df = new DecimalFormat("##0.000000");
        if (f != null) {
            df = new DecimalFormat(f);
        }
        String sPrice = df.format(dPrice);
        return sPrice;
    }

    /**
     * 格式化字符串，金额字段专用，返回######.000000，并自动去除小数点后的0
     *
     * @return
     */
    public static String formatMny(String sMny) {
        if (sMny == null || sMny.equals(""))
            sMny = "0";

        Double dMny = new Double(sMny);
        DecimalFormat df = new DecimalFormat("##0.00");
        return df.format(dMny);
    }

    /**
     * 格式化字符串，金额字段专用，当f=null时默认返回###,###.000000，并自动去除小数点后的0 其它按格式返回
     *
     * @param sMny
     * @param f
     * @return
     */
    public static String formatMny(String sMny, String f) {
        if (sMny == null || sMny.equals(""))
            sMny = "0";

        Double dMny = new Double(sMny);
        DecimalFormat df = new DecimalFormat("##0.000000");
        if (f != null) {
            df = new DecimalFormat(f);
        }
        sMny = df.format(dMny);
        return sMny;
    }

    /**
     * 格式化字符串，金额字段专用，返回######.000000，并自动去除小数点后的0
     *
     * @param dMny
     * @return
     */
    public static String formatMny(double dMny) {
        DecimalFormat df = new DecimalFormat("##0.000000");
        return df.format(dMny);
    }

    // 两位小数
    public static String formatMny2(double dMny) {
        DecimalFormat df = new DecimalFormat("##0.00");
        return df.format(dMny);
    }

    /**
     * 格式化字符串，金额字段专用，当f=null时默认返回###,###.000000，并自动去除小数点后的0 其它按格式返回
     *
     * @param dMny
     * @param f
     * @return
     */
    public static String formatMny(double dMny, String f) {
        DecimalFormat df = new DecimalFormat("##0.000000");
        if (f != null) {
            df = new DecimalFormat(f);
        }
        String sMny = null;
        sMny = df.format(dMny);
        return sMny;
    }

    /**
     * 摘要：数字格式化字符串
     *
     * @param dMny       格式化数字
     * @param f          格式字符串
     * @param isShowZero true-显示0值，false-不显示0值
     * @return
     * @说明：如果为0，显示为空
     * @创建：作者:lj 创建时间：2007-12-13
     * @修改历史： [序号](lj 2007 - 12 - 13)<修改说明>
     */
    public static String formatMum(double dMny, String f, boolean isShowZero) {
        String sMny = null;

        if (isShowZero == false && dMny == 0) {
            sMny = "";
        } else {
            DecimalFormat df;
            if (f == null) {
                df = new DecimalFormat("##0.000000");
            } else {
                df = new DecimalFormat(f);
            }

            sMny = df.format(dMny);
        }

        return sMny;
    }

    /**
     * 格式化税率
     *
     * @param sRate
     * @param nType 当nType==1时，sRate输入的值应该为17%;当nType!=1时，sRate输入的值应该为0.17;
     * @return nType 当nType==1时，返回0.17;当nType!=1时，返回17%
     */
    public static String formatRate(String sRate, int nType) {

        if (nType == 1) {
            Double dRate = Double.valueOf(sRate.substring(0, sRate.length() - 1));

            return new Double(dRate / 100).toString();
        }

        double dRate = new Double(sRate).doubleValue() * 100;

        return formatMny(dRate, "##0.00") + "%";
    }

    /**
     * 阿拉伯数字转换为中文大写数字
     *
     * @param sNum
     * @return
     */
    public static StringBuffer convertNumberToChinese(String sNum) {
        String sNumber = formatMny(sNum, "#####0.00");
        // 查询小数点位置
        int nDecPos = 0;
        for (int i = 0; i < sNumber.length(); i++) {
            if (sNumber.charAt(i) == '.') {
                nDecPos = i;
                break;
            }
        }
        // 整数位
        StringBuffer sbNumber = new StringBuffer();
        // 小数位
        StringBuffer sbDecimal = new StringBuffer();
        // 最终转换结果
        StringBuffer sbChinese = new StringBuffer();
        if (nDecPos > 0) {
            sbNumber.append(sNumber.substring(0, nDecPos)).reverse();
            sbDecimal.append(sNumber.substring(nDecPos + 1));
        } else {
            sbNumber.append(sNumber).reverse();
        }
        int nLen = sbNumber.length();
        for (int i = 0; i < nLen; i++) {
            String strNum = String.valueOf(sbNumber.charAt(i));
            int nNum = Integer.parseInt(strNum);
            int nPos = i % 4;
            int nZero = i / 4;
            if (nZero > 0) {
                if (nPos > 0) {
                    if (nNum > 0)
                        sbChinese.append(chineseIntBit[nPos]);

                    sbChinese.append(chineseNumber[nNum]);
                } else {
                    if (nNum > 0)
                        sbChinese.append(chineseLongBit[nZero - 1]);
                    sbChinese.append(chineseNumber[nNum]);
                }
            } else {
                if (nNum > 0)
                    sbChinese.append(chineseIntBit[nPos]);

                if (i <= (nLen - 1) && nNum != 0)
                    sbChinese.append(chineseNumber[nNum]);
            }
        }
        sbChinese.reverse();
        if (nDecPos > 0) {
            String decimals = sbDecimal.toString();
            if (decimals.equals("")) {
                sbChinese.append("整");
            } else {
                Double tempdb = Double.parseDouble(decimals);
                if (tempdb == 0) {
                    sbChinese.append("整");
                } else {
                    for (int i = 0; i < sbDecimal.length(); i++) {
                        String strNum = String.valueOf(sbDecimal.charAt(i));
                        int nNum = Integer.parseInt(strNum);
                        int nPos = i % 4;
                        sbChinese.append(chineseNumber[nNum]);
                        sbChinese.append(chineseDecBit[nPos]);
                    }
                }
            }
        } else {
            sbChinese.append(chineseZero);
        }
        return sbChinese;
    }

    /**
     * 阿拉伯数字转换为中文大写数字
     *
     * @param dNum
     * @return
     */
    public static StringBuffer convertNumberToChinese(double dNum) {
        String sNum = String.valueOf(dNum);

        return convertNumberToChinese(sNum);
    }

    /**
     * 阿拉伯数字转换为中文大写数字
     *
     * @param nNum
     * @return
     */
    public static StringBuffer convertNumberToChinese(long nNum) {
        String sNum = String.valueOf(nNum);

        return convertNumberToChinese(sNum);
    }

    /**
     * 阿拉伯数字转换为中文大写数字
     *
     * @param nNum
     * @return
     */
    public static StringBuffer convertNumberToChinese(int nNum) {
        String sNum = String.valueOf(nNum);

        return convertNumberToChinese(sNum);
    }

    public static String convertCharacter(String ss)
        /*
         * 处理从页面获得的字符参数乱码问题
         */ {
        if (ss != null) {
            try {
                String temp_p = ss;
                byte[] temp_t = temp_p.getBytes("ISO8859-1");
                ss = new String(temp_t);
            } catch (Exception e) {
                System.err.println("toChinese exception:" + e.getMessage());
                System.err.println("The String is:" + ss);
            }
        }
        return ss;
    }

    public static String formatQty1(double dQty) {
        DecimalFormat df = new DecimalFormat("##0.00");

        return df.format(dQty);
    }

    public static long getArrayMaxValue(long[] lCompareArray) {
        if (lCompareArray.length <= 0) {
            return 0;
        } else {
            long lRtn = 0;
            for (int i = 0; i < lCompareArray.length; i++) {
                if (lCompareArray[i] > lRtn) {
                    lRtn = lCompareArray[i];
                }
            }
            return lRtn;
        }
    }

    /**
     * 摘要：
     *
     * @param sParam
     * @return
     * @说明：
     * @创建：作者:whj 创建时间：2007-12-19
     * @修改历史： [序号](whj 2007 - 12 - 19)<修改说明>
     */
    public static String formatResult(String sParam) {
        if (sParam == null || sParam.equals("0")) {
            return "";
        } else {
            String sResult = "";
            DecimalFormat df = new DecimalFormat("###,###.00");
            sResult = df.format(Double.valueOf(sParam));
            return sResult;
        }
    }

    /**
     * 摘要：获得指定字符串的长度
     *
     * @param sStr 指定字符串
     * @return
     * @说明：
     * @创建：作者:YQH 创建时间：2008-07-19
     * @修改历史： [序号](whj 2007 - 12 - 19)<修改说明>
     */
    public static int valieFiledLength(String sStr) {
        String regex = "^\\w+$";
        String regex1 = "&@!#$%^)(-+=_\\'?><,~`!/ {}";
        int lengthg = 0;
        int j = 0;
        String srr = "";

        for (int i = 0; i < sStr.length(); i++) {
            if (i < sStr.length())
                j = i + 1;
            else
                j = i;
            srr = sStr.substring(i, j);
            if (!srr.matches(regex) && regex1.indexOf(srr) == -1) {
                lengthg = lengthg + 2;
            } else {
                lengthg = lengthg + 1;
            }

        }
        return lengthg;
    }

    public static String getFiledValue(String sStr, int length) {
        String regex = "^\\w+$";
        String regex1 = "&@!#$%^)(-+=_\\'?><,~`!/ {}";
        int lengthg = 0;
        int j = 0;
        String srr = "";
        String sRtn = "";
        for (int i = 0; i < sStr.length(); i++) {
            if (lengthg >= length)
                break;
            if (i < sStr.length())
                j = i + 1;
            else
                j = i;
            srr = sStr.substring(i, j);
            if (!srr.matches(regex) && regex1.indexOf(srr) == -1) {
                lengthg = lengthg + 2;

            } else {
                lengthg = lengthg + 1;

            }
            sRtn = sRtn + srr;

        }
        return sRtn;
    }

    /**
     * 摘要：密码加密
     *
     * @param password
     * @return
     * @说明：
     * @创建：作者:Administrator 创建时间：Apr 9, 2009
     * @修改历史： [序号](Administrator Apr 9, 2009)<修改说明>
     */
    public static String encrypt(String password) {
        String result = null;
        String password1 = "";
        if (password != null) {
            try {
                MessageDigest ca = MessageDigest.getInstance("SHA");
                result = "";
                char pass[] = password.toCharArray();
                for (int i = 0; i < pass.length; i++) {
                    password1 = (String) password1 + pass[i] + "&^./&";
                }
                byte mess[] = password1.getBytes();
                ca.reset();
                byte[] hash = ca.digest(mess);
                result = byte2hex(hash);
            } catch (Exception err) {

            }
        }
        return result;
    }

    private static String byte2hex(byte[] b) {
        String hs = "";
        String stmp = "";

        for (int n = 0; n < b.length; n++) {
            stmp = (Integer.toHexString(b[n] & 0XFF));
            if (stmp.length() == 1) {
                hs = hs + "0" + stmp;
            } else {
                hs = hs + stmp;
            }
        }
        return hs.toUpperCase();
    }

    /**
     * Transform the specified byte into a Hex String form.
     *
     * @param bcd
     * @return
     */
    public static final String bytesToHexStr(byte[] bcd) {
        StringBuffer s = new StringBuffer(bcd.length * 2);
        for (int i = 0; i < bcd.length; i++) {
            s.append(bcdLookup[(bcd[i] >>> 4) & 0x0f]);
            s.append(bcdLookup[bcd[i] & 0x0f]);
        }

        return s.toString();
    }

    /**
     * Transform the specified Hex String into a byte array.
     *
     * @param
     * @return
     */
    public static final byte[] hexStrToBytes(String s) {
        byte[] bytes;
        bytes = new byte[s.length() / 2];
        for (int i = 0; i < bytes.length; i++) {
            bytes[i] = (byte) Integer.parseInt(s.substring(2 * i, 2 * i + 2), 16);
        }
        return bytes;
    }

    /**
     * 随机生成n位数字字母组合的str字符
     *
     * @return type=1 数字字母组合。 type=2 数字only.
     */
    public static String generateRandomString(int n, int type) {
        int length = n;
        if (length < 1)
            throw new IllegalArgumentException();

        char[] randomChar = new char[length];
        int index = 0;

        while (index < length) {
            double rand = Math.random() * 74;
            int num = (int) (rand + '0');

            if (type == 1) {
                if (num >= 48 && num <= 57 || num >= 65 && num <= 90 || num >= 97 && num <= 122) // /ascii
                // things.
                {
                    randomChar[index] = (char) num;
                    index++;
                }
            } else if (type == 2) {
                if (num >= 48 && num <= 57) // /numbers.
                {
                    randomChar[index] = (char) num;
                    index++;
                }
            } else {
                return "";
            }

        }
        return new String(randomChar);
    }

    // 对象转化成Str
    public static String convertStr(Object obj) {
        if (null == obj) {
            return null;
        } else {
            return obj.toString();
        }
    }

    // 对象转化成Str
    public static String convertStr2(Object obj) {
        if (null == obj) {
            return "";
        } else {
            return obj.toString();
        }
    }

    // 对象转化成int
    public static Integer convertInt(Object obj) {
        if (null == obj) {
            return null;
        } else {
            if (obj.toString().equals("")) {
                return null;
            }
            return Integer.parseInt(obj.toString());
        }
    }

    // 对象转化成Long
    public static Long convertLong(Object obj) {
        if (null == obj) {
            return null;
        } else {
            if (obj.toString().equals("")) {
                return null;
            }
            return Long.parseLong(obj.toString());
        }
    }

    // 对象转化成int
    public static Integer convertDbToInt(Object obj) {
        if (null == obj) {
            return null;
        } else {
            if (obj.toString().equals("")) {
                return null;
            }
            return Double.valueOf(obj.toString()).intValue();
        }
    }

    // 对象转化成Long
    public static Long convertDbToLong(Object obj) {
        if (null == obj) {
            return null;
        } else {
            if (obj.toString().equals("")) {
                return null;
            }
            return Double.valueOf(obj.toString()).longValue();
        }
    }

    // 对象转化成BigDecimal
    public static BigDecimal convertBigDecimal(Object obj) {
        if (null == obj) {
            return null;
        } else {
            if (obj.toString().equals("")) {
                return null;
            }
            String str = obj.toString();
            if (str.contains(".")) {
                int k = str.indexOf(".");
                if (str.substring(k + 1).length() == 10) {
                    BigDecimal tmp = new BigDecimal(str);
                    //if (Math.abs(tmp.doubleValue()) < 0.00001f) tmp = new BigDecimal(0);
                    return tmp;
                }
            }
            BigDecimal tmp = new BigDecimal(str);
            if (Math.abs(tmp.doubleValue()) < 0.00001f) tmp = new BigDecimal(0);
            //tmp = tmp.setScale(2,BigDecimal.ROUND_HALF_UP);
            String tmpS = tmp.stripTrailingZeros().toPlainString();
            return new BigDecimal(tmpS);
        }
    }

    // 对象转化成Double
    public static Double convertDouble(Object obj) {
        if (null == obj) {
            return null;
        } else {
            if (obj.toString().equals("")) {
                return null;
            }
            String str = obj.toString();
            if (str.contains(".")) {
                int k = str.indexOf(".");
                if (str.substring(k + 1).length() == 7) {
                    return Double.parseDouble(str);
                }
            }
            BigDecimal b = new BigDecimal(Double.parseDouble(str));
            double db = b.setScale(2, BigDecimal.ROUND_HALF_DOWN).doubleValue();
            return db;
        }
    }

    public static Float convertFloat(Object obj) {
        if (null == obj) {
            return null;
        } else {
            if (obj.toString().equals("")) {
                return null;
            }
            String str = obj.toString();
            if (str.contains(".")) {
                int k = str.indexOf(".");
                if (str.substring(k + 1).length() == 7) {
                    return Float.parseFloat(str);
                }
            }
            return Float.parseFloat(str);
        }
    }

    // 对象转化成Date
    public static Date convertDate(Object obj, String formate) {
        if (null == obj) {
            return null;
        } else {
            try {
                return DateTimeUtil.getStrToDate(obj.toString(), formate);
            } catch (Exception e) {
                return null;
            }
        }
    }

    // 对象转化成T
//	@SuppressWarnings("unchecked")
//	public static <T> T convertT(Object obj, Class tp) {
//		if (tp == Integer.class) {
//			return (T) convertInt(obj);
//		} else if (tp == Long.class) {
//			return (T) convertLong(obj);
//		} else if (tp == Double.class) {
//			return (T) convertDouble(obj);
//		} else if (tp == String.class) {
//			return (T) convertStr(obj);
//		} else if (tp == Date.class) {
//			return (T) convertDate(obj, "yyyy-MM-dd HH:mm:ss");
//		} else if (tp == Short.class) {
//			if (null == obj || obj.toString().length() == 0) {
//				return null;
//			}
//			Short s = Short.parseShort(obj.toString());
//			return (T) s;
//		} else if (tp == Byte.class) {
//			if (null == obj || obj.toString().length() == 0) {
//				return null;
//			}
//			Byte b = Byte.parseByte(obj.toString());
//			return (T) b;
//		} else {
//			return null;
//		}
//	}

    /**
     * @param count 值 2
     * @param bits  位数 5
     * @return 00002
     * @说明: 根据个数获取序号
     */
    public static String getCdByCount(String finalCd, String count, int bits) {
        StringBuffer suffix = new StringBuffer(finalCd);
        int len = bits - count.length();
        if (len > 0) {
            for (int i = 0; i < len; i++)
                suffix.append("0");
        }
        suffix.append(count);
        return suffix.toString();
    }

    //对象转化成T
    @SuppressWarnings("unchecked")
    public static <T> T convertT(Object obj, String tp) {
        if (tp.equals("Integer") || tp.equals("int")) {
            return (T) convertInt(obj);
        } else if (tp.equals("Long") || tp.equals("long")) {
            return (T) convertLong(obj);
        } else if (tp.equals("Double") || tp.equals("double")) {
            return (T) convertDouble(obj);
        } else if (tp.equals("String")) {
            return (T) convertStr(obj);
        } else if (tp.equals("Date")) {
            return (T) convertDate(obj, "yyyy-MM-dd HH:mm:ss");
        } else if (tp.equals("BigDecimal")) {
            return (T) convertBigDecimal(obj);
        } else if (tp.equals("Float") || tp.equals("float")) {
            return (T) convertFloat(obj);
        } else {
            return null;
        }
    }

    /**
     * 摘要：
     *
     * @param field
     * @return
     * @说明：格式字符串用于和数据库字段对应
     * @创建：作者:yxy 创建时间：2013-3-13
     * @修改历史：
     */
    public static String convertField(String field) {
        StringBuffer f = new StringBuffer();
        for (int i = 0; i < field.length(); i++) {
            char c = field.charAt(i);
            if (Character.isUpperCase(c)) {
                char temp = Character.toLowerCase(c);
                if (i > 0) {
                    f.append("_");
                }
                f.append(temp);
            } else {
                f.append(c);
            }
        }
        return f.toString();
    }

    /**
     * 摘要：
     *
     * @param source
     * @throws IOException
     * @说明：上传
     * @创建：作者:yxy 创建时间：2012-9-18
     * @修改历史： [序号](yxy 2012 - 9 - 18)<修改说明>
     */
    public static String upLoadFile(MultipartFile source, String basePath, String oldName) throws IOException {
        if (null != source) {
            String fileName = source.getOriginalFilename();
            if (StrUtil.isNull(fileName)) {
                return null;
            }
            if (isNull(oldName)) {
                String flagType = fileName.substring(fileName.lastIndexOf("."));
                fileName = System.currentTimeMillis() + flagType;
            } else {
                fileName = oldName;
            }
            File file = new File(basePath);
            if (!file.exists()) {
                file.mkdirs();
            }
            File target = new File((basePath + "/" + fileName));
            FileCopyUtils.copy(source.getBytes(), target);
            return fileName;
        }
        return null;
    }

    /**
     * 摘要：
     *
     * @param path       文件总路径
     * @param tempName   临时文件名称
     * @param folderPath 正式文件夹
     * @param fileName   正式文件
     * @说明：移动文件
     * @创建：作者:yxy 创建时间：2013-4-20
     * @修改历史： [序号](yxy 2013 - 4 - 20)<修改说明>
     */
    public static void renameFile(String path, String tempName, String folderPath, String fileName) {
        //原图片
        File f = new File(path + "/" + tempName);
        //正式图片目录
        File folder = new File(folderPath);
        //目录不存在创建
        if (!folder.exists()) {
            folder.mkdir();
        }
        //获取正式文件
        File renameFile = new File(folderPath + "/" + fileName);
        //已存在删除
        if (renameFile.exists()) {
            renameFile.delete();
        }
        //移动文件
        f.renameTo(renameFile);
    }

    /**
     * 摘要：
     *
     * @return
     * @说明：MD5加密
     * @创建：作者:yxy 创建时间：2012-6-19
     * @修改历史： [序号](yxy 2012 - 6 - 19)<修改说明>
     */
//	public static String md5Pwd(String str){
//		return encodePwd(str, "MD5");
//	}
//	/**
//	 *
//	 *摘要：
//	 *@说明：密码加密
//	 *@创建：作者:yxy		创建时间：2012-6-19
//	 *@param str
//	 *@param formate
//	 *@return
//	 *@修改历史：
//	 *		[序号](yxy	2012-6-19)<修改说明>
//	 */
//	public static String encodePwd(String str, String formate){
//		try {
//			MessageDigest md = MessageDigest.getInstance(formate);
//			md.update(str.getBytes());
//			byte ty[] = md.digest();
//			int i;
//			StringBuffer buf = new StringBuffer("");
//			for (int offset = 0; offset < ty.length; offset++) {
//				i = ty[offset];
//				if(i<0) i+= 256;
//				if(i<16)
//				buf.append("0");
//				buf.append(Integer.toHexString(i));
//			}
//			//BASE64Encoder e = new BASE64Encoder();
//			//buf = e.encode(ty);
//			return buf.toString().toUpperCase();
//		} catch (Exception e) {
//			return null;
//		}
//	}
    public static double distanceByLngLat(double lng1, double lat1, double lng2, double lat2) {
        double radLat1 = lat1 * Math.PI / 180;
        double radLat2 = lat2 * Math.PI / 180;
        double a = radLat1 - radLat2;
        double b = lng1 * Math.PI / 180 - lng2 * Math.PI / 180;
        double s = 2 * Math.asin(Math.sqrt(Math.pow(Math.sin(a / 2), 2) + Math.cos(radLat1)
                * Math.cos(radLat2) * Math.pow(Math.sin(b / 2), 2)));
        s = s * 6378137.0;// 取WGS84标准参考椭球中的地球长半径(单位:m)
        s = Math.round(s * 10000) / 10000;
        return s;
    }

    /**
     * @param source
     * @throws IOException
     * @说明：获取上传图片的类型
     * @创建：作者:yxy 创建时间：2012-9-18
     * @修改历史： [序号](yxy 2012 - 9 - 18)<修改说明>
     */
    public static String returnFileType(MultipartFile source) throws IOException {
        if (null != source) {
            String sourceName = source.getOriginalFilename();
            if (StrUtil.isNull(sourceName)) {
                return null;
            }
            return sourceName.substring(sourceName.lastIndexOf("."));
        }
        return null;
    }

    /***
     * MD5加码 生成32位md5码
     */
    public static String string2MD5(String str) {
        MessageDigest md5 = null;
        try {
            md5 = MessageDigest.getInstance("MD5");
        } catch (Exception e) {
//			System.out.println(e.toString());
            e.printStackTrace();
            return "";
        }
        byte[] byteArray = str.getBytes();
        byte[] md5Bytes = md5.digest(byteArray);
        StringBuffer hexValue = new StringBuffer();
        for (int i = 0; i < md5Bytes.length; i++) {
            int val = ((int) md5Bytes[i]) & 0xff;
            if (val < 16)
                hexValue.append("0");
            hexValue.append(Integer.toHexString(val));
        }
        return hexValue.toString();
    }

    //随机生成六位验证码
    public static String stringyzm() {
        String s = "";
        while (s.length() < 6) {
            s += (int) (Math.random() * 10);
        }
        return s;
    }

    //判断时间date1是否在时间date2之前
    public static String isDateBefore(String date1, String date2) {
        DateFormat df = new SimpleDateFormat("HH:mm");
        try {
            Date dt1 = df.parse(date1);
            Date dt2 = df.parse(date2);
            if (dt1.getTime() > dt2.getTime()) {
                return "1";
            } else if (dt1.getTime() < dt2.getTime()) {
                return "2";
            } else {
                return "1";
            }
        } catch (ParseException e) {

        }
        return "";
    }

    /*
     * 将时间戳转换为时间
     */
    public static String stampToDate(long s) {
        String date = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date(s * 1000));
        return date;
    }

    /*
     * 将时间转换为时间戳
     */
    public static String dateToStamp(String s) throws ParseException {
        String res;
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Date date = simpleDateFormat.parse(s);
        long ts = date.getTime();
        res = String.valueOf(ts);
        return res.substring(0, 10);
    }

    /*
     * 获取当前时间戳
     */
    public static long getDqsjc() {
        long ts = 0;
        try {
            ts = Long.parseLong(StrUtil.dateToStamp(DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd HH:mm:ss")));
        } catch (Exception e) {
        }
        return ts - 2000;
    }

    //判断是否迟到还是早退
    public static String isCdZt(String tp, String sftime, String sjd) {
        try {
            String s1[] = sjd.split(" ");
            DateFormat df = new SimpleDateFormat("HH:mm");
            for (int j = 0; j < s1.length; j++) {
                String ist = isInTime(s1[j], sftime);
                if (ist.equals("1")) {
                    if (tp.equals("1-1")) {
                        Date d1 = df.parse(sftime);
                        Date d2 = df.parse(s1[j].substring(0, s1[j].indexOf("-")));
                        long diff = d1.getTime() - d2.getTime();
                        long hour = (diff / (60 * 60 * 1000) - 0 * 24);
                        long min = ((diff / (60 * 1000)) - 0 * 24 * 60 - hour * 60);
                        return "迟到:" + hour + "时" + min + "分";
                    } else if (tp.equals("1-2")) {
                        Date d1 = df.parse(s1[j].substring(s1[j].indexOf("-") + 1, s1[j].length()));
                        Date d2 = df.parse(sftime);
                        long diff = d1.getTime() - d2.getTime();
                        long hour = (diff / (60 * 60 * 1000) - 0 * 24);
                        long min = ((diff / (60 * 1000)) - 0 * 24 * 60 - hour * 60);
                        return "早退:" + hour + "时" + min + "分";
                    }
                }

            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "";
    }

    //判断某时间是否在一个时间段
    public static String isInTime(String sourceTime, String curTime) {
        String[] args = sourceTime.split("-");
        SimpleDateFormat sdf = new SimpleDateFormat("HH:mm");
        try {
            long now = sdf.parse(curTime).getTime();
            long start = sdf.parse(args[0]).getTime();
            long end = sdf.parse(args[1]).getTime();
            if (args[1].equals("00:00")) {
                args[1] = "24:00";
            }
            if (end < start) {
                if (now >= end && now < start) {
                    return "2";
                } else {
                    return "1";
                }
            } else {
                if (now >= start && now < end) {
                    return "1";
                } else {
                    return "2";
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "-1";
    }

    //获取当前时间是周几
    public static String getXQJ() {
        Date date = new Date();
        String[] weekDays = {"周日", "周一", "周二", "周三", "周四", "周五", "周六"};
        Calendar cal = Calendar.getInstance();
        cal.setTime(date);
        int w = cal.get(Calendar.DAY_OF_WEEK) - 1;
        if (w < 0)
            w = 0;
        return weekDays[w];
    }

    //根据日期获取是周几
    public static String getXQJ2(String dates) {
        try {
            SimpleDateFormat formater = new SimpleDateFormat("yyyy-MM-dd");
            Date date = formater.parse(dates);
            String[] weekDays = {"周日", "周一", "周二", "周三", "周四", "周五", "周六"};
            Calendar cal = Calendar.getInstance();
            cal.setTime(date);
            int w = cal.get(Calendar.DAY_OF_WEEK) - 1;
            if (w < 0)
                w = 0;
            return weekDays[w];
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "";
    }

    //根据两个经纬度计算距离（m）
    private static final double EARTH_RADIUS = 6378137;

    private static double rad(double d) {
        return d * Math.PI / 180.0;
    }

    public static int GetDistance(double lng1, double lat1, double lng2, double lat2) {
        double radLat1 = rad(lat1);
        double radLat2 = rad(lat2);
        double a = radLat1 - radLat2;
        double b = rad(lng1) - rad(lng2);
        double s = 2 * Math.asin(Math.sqrt(Math.pow(Math.sin(a / 2), 2) +
                Math.cos(radLat1) * Math.cos(radLat2) * Math.pow(Math.sin(b / 2), 2)));
        s = s * EARTH_RADIUS;
        s = Math.round(s * 10000) / 10000;
        return (int) s;
    }

    //两两经纬度的平均值
    public static int GetDistancePJZ(Double lng1, Double lat1, Double lng2, Double lat2, Double lng3, Double lat3) {
        int s = 0;
        int a = GetDistance(lng1, lat1, lng2, lat2);
        if (!isNull(lng3)) {
            int b = GetDistance(lng1, lat1, lng3, lat3);
            s = (a + b) / 2;
        } else {
            s = a;
        }
        return s;
    }

    //根据某段时间获取上班天数
    public static int GetSbTs(String sdate, String edate, String dategz) {
        try {
            SimpleDateFormat formater = new SimpleDateFormat("yyyy-MM-dd");
            Date dateBegin = formater.parse(sdate);
            Date dateEnd = formater.parse(edate);
            Calendar ca = Calendar.getInstance();
            int i = 0;
            while (dateBegin.compareTo(dateEnd) < 0) {
                ca.setTime(dateBegin);
                ca.add(ca.DATE, 1);//把dateBegin加上1天然后重新赋值给date1
                dateBegin = ca.getTime();
                String s1 = getXQJ2(formater.format(dateBegin));
                if (dategz.indexOf(s1) >= 0) {
                    i++;
                }
            }
            String s1 = getXQJ2(sdate);
            if (dategz.indexOf(s1) >= 0) {
                i++;
            }
            return i;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    //根据某段时间获取上班日期和周几
    public static String GetSbTs2(String sdate, String edate, String dategz) {
        try {
            SimpleDateFormat formater = new SimpleDateFormat("yyyy-MM-dd");
            Date dateBegin = formater.parse(sdate);
            Date dateEnd = formater.parse(edate);
            Calendar ca = Calendar.getInstance();
            String str = "";
            String s1 = getXQJ2(sdate);
            if (dategz.indexOf(s1) >= 0) {
                str = str + sdate + ":" + s1 + ",";
            }
            while (dateBegin.compareTo(dateEnd) < 0) {
                ca.setTime(dateBegin);
                ca.add(ca.DATE, 1);//把dateBegin加上1天然后重新赋值给date1
                dateBegin = ca.getTime();
                s1 = getXQJ2(formater.format(dateBegin));
                if (dategz.indexOf(s1) >= 0) {
                    str = str + formater.format(dateBegin) + ":" + s1 + ",";
                }
            }
            if (!StrUtil.isNull(str)) {
                return str.substring(0, str.length() - 1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "";
    }

    /**
     * 两个字符串整合（逗号隔开的字符串）
     */
    public static String addStr(String s1, String s2) {
        if(StrUtil.isNotNull(s1)){
            s1 = s1.replace("-", ",");
        }
        if(StrUtil.isNotNull(s2)){
            s2 = s2.replace("-", ",");
        }
        String str = "";
        if(StrUtil.isNotNull(s1)){
            str = s1;
        }
        if(StrUtil.isNotNull(s2)){
            String[] split2 = s2.split(",");
            for (String c2:split2) {
                if(StrUtil.isNotNull(c2)){
                    if(StrUtil.isNull(str)){
                        str = "" + c2;
                    }else{
                        str += "," + c2;
                    }
                }
            }
        }
        return removeLastComma(str);
    }

    /**
     * 去掉最后字符是逗号的
     */
    public static String removeLastComma(String str){
        if(StrUtil.isNotNull(str) && str.endsWith(",")){
            str = str.substring(0, str.length() - 1);
        }
        return  str;
    }

    /**
     * 两个字符串整合（逗号隔开的字符串）
     */
    public static String removeStr(String s1, String s2) {
        if(StrUtil.isNotNull(s1)){
            s1 = s1.replace("-", ",");
        }
        if(StrUtil.isNotNull(s2)){
            s2 = s2.replace("-", ",");
        }
        String s = "";
        String[] split1 = s1.split(",");
        if(StrUtil.isNotNull(s2)){
            String[] split2 = s2.split(",");
            for (String c1:split1) {
                boolean flag = true;
                for (String c2:split2) {
                    if(c1.equals(c2)){
                        flag = false;
                        break;
                    }
                }
                if(flag){
                    if(StrUtil.isNull(s)){
                        s = "" + c1;
                    }else{
                        s += "," + c1;
                    }
                }
            }
        }else {
            s = s1;
        }
        return removeLastComma(s);
    }

    //java自带MD5,SHA1
    private static final String ALGORITHM = "MD5";

    private static final char[] HEX_DIGITS = {'0', '1', '2', '3', '4', '5',
            '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f'};

    public static String encode(String algorithm, String str) {
        if (str == null) {
            return null;
        }
        try {
            MessageDigest messageDigest = MessageDigest.getInstance(algorithm);
            messageDigest.update(str.getBytes());
            return getFormattedText(messageDigest.digest());
        } catch (Exception e) {
            throw new RuntimeException(e);
        }

    }

    private static String getFormattedText(byte[] bytes) {
        int len = bytes.length;
        StringBuilder buf = new StringBuilder(len * 2);
        // 把密文转换成十六进制的字符串形式
        for (int j = 0; j < len; j++) {
            buf.append(HEX_DIGITS[(bytes[j] >> 4) & 0x0f]);
            buf.append(HEX_DIGITS[bytes[j] & 0x0f]);
        }
        return buf.toString();
    }

    public static Double ConvertUnitBigToSmall(Double hsNum, Double o) {
        if (0 == hsNum) {
            return o;
        }
        if (0.0 == hsNum) {
            return o;
        }
        if (StrUtil.isNull(o)) {
            return 0.0;
        }
        String d = formatMny2(o / hsNum);
        return new Double(d);
    }

    public static Double ConvertUnitSmallToBig(Double hsNum, Double o) {
        if (StrUtil.isNull(o)) {
            return 0.0;
        }
        String d = formatMny2(hsNum * o);
        return new Double(d);
    }

    public static boolean isNumberNullOrZero(Object o) {
        if (o == null) {
            return true;
        } else if (o.toString().trim().length() == 0) {
            return true;
        } else if (o.toString().trim() == "null") {
            return true;
        } else if ("0".equals(o + "")) {
            return true;
        } else if ("0.0".equals(o + "")) {
            return true;
        } else if ("0.00".equals(o + "")) {
            return true;
        }else if("0E-10".equals(o+"")){
            return true;
        }
        return false;
    }

    public static boolean isNumeric(String str) {
        if (str == null)
            return false;
        Pattern pattern = Pattern.compile("^-?\\d+(\\.\\d+)?$");
        return pattern.matcher(str).matches();
    }

    public static String trimToZero(String str) {
        if (StringUtils.isEmpty(str)) {
            return "0";
        }
        return str;
    }

    /**
     * 过滤emoji表情
     *
     * @param source
     * @return
     */
    public static String filterEmoji(String source) {
        if (source != null) {
            Pattern emoji = Pattern.compile("[\ud83c\udc00-\ud83c\udfff]|[\ud83d\udc00-\ud83d\udfff]|[\u2600-\u27ff]", Pattern.UNICODE_CASE | Pattern.CASE_INSENSITIVE);
            Matcher emojiMatcher = emoji.matcher(source);
            if (emojiMatcher.find()) {
                source = emojiMatcher.replaceAll("*");
                return source;
            }
            return source;
        }
        return source;
    }

    public static boolean isContainChinese(String str) {
        Pattern p = Pattern.compile("[\u4e00-\u9fa5]");
        Matcher m = p.matcher(str);
        if (m.find()) {
            return true;
        }
        return false;
    }

    public static BigDecimal convertOToB(Object o){
        if(o==null||o==""){
            return new BigDecimal(0);
        }
        return new BigDecimal(o+"");
    }

    public static void main(String[] args) {
        //double distance = GetDistance(118.1966425123, 24.4795791608, 118.2002214397, 24.4836513267);
        //System.out.println(encode("SHA1", "js_ticket=761cf75d230968f2d4ccc39dd1b4e5df&noncestr=0hd5v9amwu9ps3a7&sign_timestamp=1509450621"));
    }








}
