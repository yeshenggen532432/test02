package com.qweib.cloud.utils;

import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.JavaType;
import com.fasterxml.jackson.databind.ObjectMapper;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;
import net.sf.json.processors.JsonValueProcessor;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * AJAX 工具类
 *
 * @author 吴进 by 20150714
 * <p>
 */
public class JsonUtil {

    /**
     * 将o序列化成json格式
     *
     * @param o
     * @return
     */
    public static String toJson(Object o) {
        JSONObject jsonobj = JSONObject.fromObject(o);
        String jsonStr = jsonobj.toString();
        return jsonStr;
    }

    /**
     * 将o序列化成json格式
     *
     * @param o
     * @return
     */
    public static String toJson(List<?> o) {
        JSONArray jsonobj = JSONArray.fromObject(o);
        String jsonStr = jsonobj.toString();
        return jsonStr;
    }

    /**
     * 将map格式转换成json格式串
     *
     * @return
     */
    @SuppressWarnings("unchecked")
    public static String getJsonStringFromMap(Map map) {
        if (null != map) {
            JSONObject json = JSONObject.fromObject(map, jsonConfig);
            return json.toString();
        }
        return "";
    }

    /**
     * 解析json属性，放到实体里面去
     */
    @SuppressWarnings("unchecked")
    public static List readJsonList(String jsondata, Class collectionClass) {
        try {
            ObjectMapper mapper = new ObjectMapper();
            mapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);//忽略多余字段防止不存在字段时报错08-15
            JavaType javaType = getCollectionType(ArrayList.class, collectionClass);
            List lst = mapper.readValue(jsondata, javaType);
            return lst;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * 解析json属性，放到实体里面去
     */
    @SuppressWarnings("unchecked")
    public static <T> T readJsonObject(String jsondata, Class<T> collectionClass) {
        try {
            ObjectMapper mapper = new ObjectMapper();
            mapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);//忽略多余字段防止不存在字段时报错08-15
            return mapper.readValue(jsondata, collectionClass);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public static JavaType getCollectionType(Class<?> collectionClass, Class<?>... elementClasses) {
        ObjectMapper mapper = new ObjectMapper();
        return mapper.getTypeFactory().constructParametricType(collectionClass, elementClasses);
    }

    private static JsonConfig jsonConfig;

    static {
        jsonConfig = new JsonConfig();
        jsonConfig.registerJsonValueProcessor(java.util.Date.class, new JsonValueProcessor() {
            private final String format = "yyyy-MM-dd HH:mm:ss";

            public Object processObjectValue(String key, Object value, JsonConfig arg2) {
                if (value == null)
                    return "";
                if (value instanceof java.util.Date) {
                    String str = new SimpleDateFormat(format).format((java.util.Date) value);
                    return str;
                }
                return value.toString();
            }

            public Object processArrayValue(Object value, JsonConfig arg1) {
                if (value == null)
                    return "";
                if (value instanceof java.util.Date) {
                    String str = new SimpleDateFormat(format).format((java.util.Date) value);
                    return str;
                }
                return value.toString();
            }
        });
    }
}
