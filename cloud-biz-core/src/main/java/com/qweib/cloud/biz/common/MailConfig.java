package com.qweib.cloud.biz.common;

import com.qweib.cloud.utils.PropertiesUtils;

import java.util.Properties;

public class MailConfig {
    private static final String PROPERTIES_DEFAULT = "/properties/application.properties";
    public static String mailSmtp;
    public static Integer port = 25;
    public static String mailUsername;
    public static String mailPassword;
    public static String mailForm;
    public static Integer timeout = 2500;
    public static String mailFormName;
    public static Properties properties;

    static {
        init();
    }

    /**
     * 初始化
     */
    private static void init() {
       /* properties = new Properties();
        try {
            InputStream inputStream = MailConfig.class.getClassLoader().getResourceAsStream(PROPERTIES_DEFAULT);
            properties.load(inputStream);
            inputStream.close();
            host = properties.getProperty("mailSmtp");
            port = Integer.parseInt(properties.getProperty("mailPort"));
            userName = properties.getProperty("mailUsername");
            passWord = properties.getProperty("mailPassword");
            emailForm = userName;
            timeout = 2500;
            personal = "驰用T3";
        } catch (IOException e) {
            e.printStackTrace();
        }*/

        mailSmtp = PropertiesUtils.readProperties(PROPERTIES_DEFAULT, "mailSmtp");
        mailUsername = PropertiesUtils.readProperties(PROPERTIES_DEFAULT, "mailUsername");
        mailPassword = PropertiesUtils.readProperties(PROPERTIES_DEFAULT, "mailPassword");
        mailForm = mailUsername;
        mailFormName = "驰用T3";
    }
}
