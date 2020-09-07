package com.qweib.cloud.utils;


import java.math.BigInteger;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

/**
 *说明：
 *@创建：作者:yxy		创建时间：2013-9-29
 *@修改历史：
 *		[序号](yxy	2013-9-29)<修改说明>
 */
public class EncryptionUtil {
	//秘钥
	private static final byte[] KEY = "SIXUNCBP19830625".getBytes();
	public EncryptionUtil() {
	}
	//加密
	public static String encrypt(String str){
		byte[] buffer = str.getBytes();
		int i=0;
		int keylength = KEY.length;
		StringBuilder sbr = new StringBuilder();
		for (byte b : buffer) {
			//异或
			int t = (b^KEY[i]);
			//位移
			t = t<<2;
			//转二进制
			String tempStr = Integer.toBinaryString(t);
			//取反
			StringBuilder sb = new StringBuilder();
			for (int m=0;m<tempStr.length();m++) {
				String substr = tempStr.substring(m, m+1);
				if(m>0){
					if("0".equals(substr)){
						substr="1";
					}else{
						substr="0";
					}
				}
				sb.append(substr);
			}
			//二进制转数字
			BigInteger bi = new BigInteger(sb.toString(),2);
			//数字转byte
			t = Integer.parseInt(bi.toString());
			if((t>=65 && t<=90) || (t>=97 && t<=122)){
				sbr.append((char)t);
			}else{
				sbr.append((t+"").length());
				sbr.append(t);
			}
			i++;
			if(i==keylength){
				i=0;
			}
		}
		return sbr.toString();
	}
	//解密
	public static String decrypt(String str){
		byte[] bytes = new byte[1];
		int keylength = KEY.length;
		int j=0;
		int l=0;
		for (int i = 0; i < str.length(); i++) {
			//转byte
			String substr = str.substring(i, i+1);
			int b;
			if(StrUtil.isStrNum(substr)){
				i++;
				int num = Integer.parseInt(substr);
				b = Integer.parseInt(str.substring(i, (i+num)));
				i=(i+num-1);
			}else{
				b = substr.getBytes()[0];
			}
			//byte转二进制
			String tempStr = Integer.toBinaryString(b);
			//取反
			StringBuilder sb = new StringBuilder();
			for (int m=0;m<tempStr.length();m++) {
				String tstr = tempStr.substring(m, m+1);
				if(m>0){
					if("0".equals(tstr)){
						tstr="1";
					}else{
						tstr="0";
					}
				}
				sb.append(tstr);
			}
			//转int
			BigInteger bi = new BigInteger(sb.toString(),2);
			b = Integer.parseInt(bi.toString());
			//位移
			b = b>>2;
			//异或
			b = b^KEY[j];
			byte bt = (byte)b;
			if(l==0){
				bytes[l]=bt;
			}else{
				byte[] temps = bytes;
				bytes = new byte[l+1];
				for (int k = 0; k < temps.length; k++) {
					bytes[k]=temps[k];
				}
				bytes[l]=bt;
			}
			l++;
			j++;
			if(j==keylength){
				j=0;
			}
		}
		return new String(bytes);
	}
	
	
	
	//MD5加密
	// 全局数组
    private final static String[] strDigits = { "0", "1", "2", "3", "4", "5",
            "6", "7", "8", "9", "a", "b", "c", "d", "e", "f" };


    // 返回形式为数字跟字符串
    private static String byteToArrayString(byte bByte) {
        int iRet = bByte;
        // System.out.println("iRet="+iRet);
        if (iRet < 0) {
            iRet += 256;
        }
        int iD1 = iRet / 16;
        int iD2 = iRet % 16;
        return strDigits[iD1] + strDigits[iD2];
    }

    // 返回形式只为数字
    private static String byteToNum(byte bByte) {
        int iRet = bByte;
        System.out.println("iRet1=" + iRet);
        if (iRet < 0) {
            iRet += 256;
        }
        return String.valueOf(iRet);
    }

    // 转换字节数组为16进制字串
    private static String byteToString(byte[] bByte) {
        StringBuffer sBuffer = new StringBuffer();
        for (int i = 0; i < bByte.length; i++) {
            sBuffer.append(byteToArrayString(bByte[i]));
        }
        return sBuffer.toString();
    }

    public static String GetMD5Code(String strObj) {
        String resultString = null;
        try {
            resultString = new String(strObj);
            MessageDigest md = MessageDigest.getInstance("MD5");
            // md.digest() 该函数返回值为存放哈希值结果的byte数组
            resultString = byteToString(md.digest(strObj.getBytes()));
        } catch (NoSuchAlgorithmException ex) {
            ex.printStackTrace();
        }
        return resultString;
    }

    public static void main(String[] args) {
        System.out.println(GetMD5Code("123456"));
    }
}

