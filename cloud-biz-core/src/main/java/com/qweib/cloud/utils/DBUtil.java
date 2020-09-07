package com.qweib.cloud.utils;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.BufferedReader;
import java.io.InputStreamReader;


public class DBUtil {


    private static final Logger LOGGER = LoggerFactory.getLogger(DBUtil.class);

    private static String userName = PropertiesUtils.readProperties("/properties/jdbc.properties", "jdbc.username");
    private static String psw = PropertiesUtils.readProperties("/properties/jdbc.properties", "jdbc.password");
    private static final String DB_HOST = PropertiesUtils.readProperties("/properties/jdbc.properties", "jdbc.db.host");
    private static final String DB_PORT = PropertiesUtils.readProperties("/properties/jdbc.properties", "jdbc.db.port");
    /**
     * 操作系统类型:1,windows;2,linux
     */
    private static String osType = PropertiesUtils.readProperties("/properties/jdbc.properties", "os.type");

    /**
     * @param DBName
     * @return
     * @创建：作者:YYP 创建时间：2015-1-21
     * @see 创建数据库
     */
    public static boolean createDB(String DBName) {
        boolean flag = true;
        try {
            StringBuilder str = new StringBuilder(128)
                    .append("mysqladmin -h ").append(DB_HOST).append(" -P").append(DB_PORT);
            str.append(" --user=").append(userName).append(" --password=").append(psw);
            str.append(" create ").append(DBName);
            LOGGER.info("创建数据库-->" + str.toString());
            Process process = Runtime.getRuntime().exec(makeCommand(str.toString())); //执行创建
            process.getOutputStream().close();
            int exitValue = process.waitFor();
            if (exitValue != 0) {
                flag = false;
            }
            LOGGER.info("创建数据库成功");
        } catch (Exception e) {
            e.printStackTrace();
            LOGGER.error("创建数据库失败-->", e);
        }
        return flag;
    }

    /**
     * @param fileAddr sql文件存放位置
     * @param DBName
     * @return
     * @创建：作者:YYP 创建时间：2015-1-21
     * @see 执行.sql文件
     */
    public static boolean createTable(String fileAddr, String DBName) {
        boolean flag = true;
        try {
            StringBuilder str = new StringBuilder(128)
                    .append("mysql -h ").append(DB_HOST).append(" -P").append(DB_PORT);
            str.append(" --user=").append(userName).append(" --password=").append(psw).append(" ");
            str.append(DBName).append(" < ").append(fileAddr);
            LOGGER.info("创建库表-->" + str.toString());
            Process process = Runtime.getRuntime().exec(makeCommand(str.toString())); //执行创建
            process.getOutputStream().close();
            int exitValue = process.waitFor();
            BufferedReader error = new BufferedReader(new InputStreamReader(process.getErrorStream()));
            String line = null;
            while ((line = error.readLine()) != null) {
                System.out.println(line);
            }
            if (exitValue != 0) {
                flag = false;
            }
            LOGGER.info("创建库表完成");
        } catch (Exception e) {
            e.printStackTrace();
            LOGGER.error("创建库表失败-->", e);
        }
        return flag;
    }

    private static String[] makeCommand(String cmdContent) {
        if ("1".equals(osType)) {
            return new String[]{"cmd", "/c", cmdContent};
        } else {
            return new String[]{"sh", "-c", cmdContent};
        }
    }
}
