package com.qweib.cloud.utils;

import org.springframework.util.ReflectionUtils;

import java.lang.reflect.Method;

public class SpringBeanReflectUtil {

    /**
     * @param serviceName
     *            服务名称
     * @param methodName
     *            方法名称
     * @param params
     *            参数
     * @return
     * @throws Exception
     */
    public static Object springInvokeMethod(String serviceName, String methodName, Object[] params) throws Exception {
        Object service = SpringContextHolder.getBean(serviceName);
        Class<? extends Object>[] paramClass = null;
        if (params != null) {
            int paramsLength = params.length;
            paramClass = new Class[paramsLength];
            for (int i = 0; i < paramsLength; i++) {
                paramClass[i] = params[i].getClass();
            }
        }
        // 找到方法
        Method method = ReflectionUtils.findMethod(service.getClass(), methodName, paramClass);
        // 执行方法
        return ReflectionUtils.invokeMethod(method, service, params);
    }
}
