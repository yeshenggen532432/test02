package com.qweib.cloud.core.domain;

import java.util.Date;

/**
 * WebServer常量类.
 * 
 * @author lhq
 * @since JDK 1.6
 * @see
 */
public class WebServerConstants {

    public static final String NS = "http://36.249.51.30:8100";

    /**
     * 客户端用户超时时间,默认120分钟.
     */
    public static long APP_OVERTIME = 1440;
    /**
     * 短信验证码超时时间,默认2分钟.
     */
    public static long CODE_OVERTIME = 2;
    /**
     * 字符集设置.
     */
    public static final String CHARSET = "UTF-8";
    /**
     * 连接请求超时时间.
     */
    public static final Integer CONNECT_TIMEOUT = 3000;
    /**
     * 读取请求返回数据超时时间.
     */
    public static final Integer READ_TIMEOUT = 5000;

    public static final String SUCCESS = "操作成功";// 操作结果,成功.
    public static final String FAILURE = "操作失败";// 操作结果,失败.
    
    public static final String LONGIN_SUCCESS = "登录成功";// 登录成功.
    public static final String LONGIN_FAILURE = "请先登录系统";// 登录失败.
    
    public static final String REGISTER_SUCCESS = "注册成功";// 注册成功.
    public static final String REGISTER_FAILURE = "注册失败";// 注册失败.

    public static final String MESSAGE_EXISTS ="查询详情成功";
    public static final String MESSAGE_NOTEXISTS ="详情不存在";

    public static final String MESSAGE_LIST_EXISTS ="列表存在";
    public static final String MESSAGE_LIST_NOTEXISTS ="列表不存在";

    public static final String MESSAGE_SEARCH_EXISTS ="搜索内容存在";
    public static final String MESSAGE_SEARCH_NOTEXISTS ="搜索内容不存在";

    public static final String MESSAGE_UPDATE_SUCCESS ="更新成功";
    public static final String MESSAGE_UPDATE_FAILURE ="更新失败";

    public static final String MESSAGE_INSERT_SUCCESS ="插入成功";
    public static final String MESSAGE_INSERT_FAILURE ="插入失败";


}
