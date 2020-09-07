
package com.qweib.cloud.biz.system.utils;

import lombok.extern.slf4j.Slf4j;
import org.apache.commons.codec.DecoderException;
import org.apache.commons.codec.binary.Hex;
import org.apache.commons.lang3.StringUtils;

/**
 * 说明：进行数值摘要的加密和解密处理
 */
@Slf4j
public class JiaMiCodeUtil {

    /**
     * 摘要：加密操作
     *
     * @param encode
     * @return
     * @说明：先进行64位的加密 再继续16进制的加密
     */
    public static String encode(String encode) {
        encode = new String(Base64.encode(encode.getBytes()));
        encode = new String(Hex.encodeHex(encode.getBytes()));
        return encode;
    }

    /**
     * 摘要：解密操作
     *
     * @param decode
     * @return
     * @说明：先进行16进制的解密，再进行64位的解密
     */
    public static String decode(String decode) {
        try {
            if (StringUtils.isBlank(decode) || StringUtils.isNumeric(decode)) {//如果为空或本来就已经是数字时不需要解码
                return decode;
            }
            decode = new String(Hex.decodeHex(decode.toCharArray()));
            decode = new String(Base64.decode(decode.toCharArray()));
        } catch (DecoderException e) {
            log.error("解密操作出现错误", e);
        }
        return decode;
    }

    public static void main(String[] args) {
        String str1 = JiaMiCodeUtil.encode("941");
        System.out.println(str1);
        String str2 = JiaMiCodeUtil.decode("4d6a6731");
        System.out.println(str2);
    }

}

