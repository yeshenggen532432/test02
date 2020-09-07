package com.qweib.cloud.repository.utils;

import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

/**
 * ysg
 * 请求第三方接口（百度地图等等）
 */
public class HttpUrlUtils {

    /**
     *
     */
    public static String convertResponse(String url) {
        StringBuffer sb = new StringBuffer();
        URL url2 = null;
        HttpURLConnection connection = null;
        InputStream inputStream = null;
        InputStreamReader isr = null;
        try {
            url2 = new URL(url);
            connection = (HttpURLConnection) url2.openConnection();
            connection.setDoInput(true);
            connection.setDoOutput(false);
            connection.setUseCaches(false);
            connection.setRequestMethod("GET");
            connection.connect();

            inputStream = connection.getInputStream();
            isr = new InputStreamReader(inputStream, "UTF-8");

            char[] buffer = new char[1];
            while (isr.read(buffer) != -1) {
                sb.append(buffer);
            }
            isr.close();
            inputStream.close();
            connection.disconnect();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            isr = null;
            inputStream = null;
            connection = null;
            url2 = null;
        }

        return sb.toString();
    }


}
