package com.qweib.cloud.biz.system.service;

import com.qweib.cloud.biz.system.UserContext;
import com.qweib.cloud.core.domain.SysLoginInfo;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.Reflections;
import com.qweib.cloud.utils.StrUtil;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import org.springframework.context.ApplicationContext;
import org.springframework.stereotype.Service;

import java.lang.reflect.Field;
import java.util.*;

/**
 * ClassName:ExportService
 * Function: 导出控制类.
 * Date:     Sep 23, 2014 10:18:42 AM
 *
 * @author hanwei
 * @see
 * @since JDK 1.6
 */
@Service
public class ExportService {

    /**
     * toExport:查询数据集
     *
     * @param classname     导出处理类
     * @param method        方法名称
     * @param bean          条件注入的bean名称
     * @param condition     条件集合
     * @param exportcontent 导出的范围（1 本页	2所有记录）
     * @param pageSize      每页显示条数
     * @param pageNumber    当前页
     * @param total         总记录数
     * @param data          列集合
     * @return
     * @创建时间 Sep 23, 201410:58:29 AM
     * @作者 hanwei
     * @Exception 可能抛出的异常
     */
    public List toExport(String classname, String method, String bean, String condition, String exportcontent, int pageSize, int pageNumber, int total, String data, ApplicationContext ac) {
        try {
            if ("1".equals(exportcontent)) {
                return exportPage(classname, method, bean, condition, pageSize, pageNumber, data, ac);
            } else if ("2".equals(exportcontent)) {
                return exportAll(classname, method, bean, condition, total, data, ac);
            }
        } catch (Exception e) {
            throw new ServiceException(e);
        }
        return null;
    }

    /**
     * exportAll:查询全部的数据集
     *
     * @param classname 导出处理类
     * @param method    方法名称
     * @param bean      条件注入的bean名称
     * @param condition 条件集合
     * @param total     总记录数
     * @param data      列集合
     * @return
     * @throws Exception
     * @创建时间 Sep 23, 201411:20:28 AM
     * @作者 hanwei
     * @Exception 可能抛出的异常
     */
    private List exportAll(String classname, String method, String bean, String condition, int total, String data, ApplicationContext ac) throws Exception {
        //解析查询的条件
        JSONObject conditions = JSONObject.fromObject(condition);
        //解析要查询的列
        JSONArray columns = JSONArray.fromObject(data);


        //封装查询的条件
        Class beanClass = Class.forName(bean);
        Object obj = beanClass.newInstance();

        Field field = Reflections.getAccessibleField(obj, "database");
        if (field != null) {
            SysLoginInfo loginInfo = UserContext.getLoginInfo();
            if (loginInfo != null) {
                Reflections.invokeSetter(obj, "database", loginInfo.getDatasource());
                conditions.put("database", loginInfo.getDatasource());
            }
        }


        //封装查询的条件
        /*Class beanClass = Class.forName(bean);
        Object obj = beanClass.newInstance();*/
        Iterator<String> iterator = conditions.keys();
        while (iterator.hasNext()) {
            String key = iterator.next();
            Object value = conditions.get(key);
            if (!StrUtil.isNull(value)) {
                Field filed = beanClass.getDeclaredField(key);
                filed.setAccessible(true);
                //System.out.println(filed.getType().getTypeName());
                if ("java.lang.Integer".equals(filed.getType().getTypeName())) {
                    filed.set(obj, Integer.valueOf(value + ""));
                } else {
                    filed.set(obj, value);
                }
            }
        }

        Object service = ac.getBean(classname);
        Class serviceClass = service.getClass();
        Page page = (Page) serviceClass.getMethod(method, beanClass, Integer.class, Integer.class).invoke(service, obj, 1, total);
        List list = page.getRows();
        List result = new LinkedList();
        for (int i = 0; i < list.size(); i++) {
            Object b = list.get(i);
            JSONObject temp = JSONObject.fromObject(b);
            Map map = new LinkedHashMap();
            for (int j = 0; j < columns.size(); j++) {
                String key = (String) ((JSONObject) columns.get(j)).get("key");
                map.put(key, String.valueOf(temp.get(key)));
            }
            result.add(map);
        }

        return result;
    }

    /**
     * exportPage:查询当前页的数据集
     *
     * @param classname  导出处理类
     * @param method     方法名称
     * @param bean       条件注入的bean名称
     * @param condition  条件集合
     * @param pageSize   每页的大小
     * @param pageNumber 当前页
     * @param data       列集合
     * @return
     * @throws Exception
     * @创建时间 Sep 23, 201411:21:54 AM
     * @作者 hanwei
     */
    private List exportPage(String classname, String method, String bean, String condition, int pageSize, int pageNumber, String data, ApplicationContext ac) throws Exception {
        //解析查询的条件
        JSONObject conditions = JSONObject.fromObject(condition);
        //解析要查询的列
        JSONArray columns = JSONArray.fromObject(data);

        //封装查询的条件
        Class beanClass = Class.forName(bean);
        Object obj = beanClass.newInstance();

        Field field = Reflections.getAccessibleField(obj, "database");
        if (field != null) {
            SysLoginInfo loginInfo = UserContext.getLoginInfo();
            if (loginInfo != null) {
                Reflections.invokeSetter(obj, "database", loginInfo.getDatasource());
                conditions.put("database", loginInfo.getDatasource());
            }
        }

        Iterator<String> iterator = conditions.keys();
        while (iterator.hasNext()) {
            String key = iterator.next();
            Object value = conditions.get(key);
            if (!StrUtil.isNull(value)) {
                Field filed = beanClass.getDeclaredField(key);
                filed.setAccessible(true);
                String str = filed.getType().toString();
                if (str.indexOf("Integer") > -1) {
                    filed.set(obj, Integer.parseInt(value.toString()));
                } else
                    filed.set(obj, value);
            }
        }

        Object service = ac.getBean(classname);
        Class serviceClass = service.getClass();
        Page page = (Page) serviceClass.getMethod(method, beanClass, Integer.class, Integer.class).invoke(service, obj, pageNumber, pageSize);
        List list = page.getRows();
        List result = new LinkedList();
        for (int i = 0; i < list.size(); i++) {
            Object b = list.get(i);
            JSONObject temp = JSONObject.fromObject(b);
            Map map = new LinkedHashMap();
            for (int j = 0; j < columns.size(); j++) {
                String key = (String) ((JSONObject) columns.get(j)).get("key");
                Object value = temp.get(key);
                String temp1 = null;
                if (value instanceof Double) {
                    temp1 = StrUtil.formatMny(String.valueOf(value));
                } else {
                    temp1 = String.valueOf(value);
                }
                map.put(key, temp1);
            }
            result.add(map);
        }

        return result;
    }
}

