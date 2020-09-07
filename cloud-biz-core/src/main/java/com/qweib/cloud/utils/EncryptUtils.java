package com.qweib.cloud.utils;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class EncryptUtils {

    public EncryptUtils() {
    }

    public static String Encrypt(String str, String alg) {
        MessageDigest digest = null;
        String hex = null;
        byte[] bytes = str.getBytes();

        try {
            if (alg == null || alg.equals("")) {
                alg = "SHA-256";
            }

            digest = MessageDigest.getInstance(alg);
            digest.update(bytes);
            hex = bytes2Hex(digest.digest());
            return hex;
        } catch (NoSuchAlgorithmException e) {
            return null;
        }
    }

    public static String bytes2Hex(byte[] bytes) {
        String str = "";
        String hex = null;

        for (int i = 0; i < bytes.length; ++i) {
            hex = Integer.toHexString(bytes[i] & 255);
            if (hex.length() == 1) {
                str = str + "0";
            }

            str = str + hex;
        }

        return str;
    }
}
