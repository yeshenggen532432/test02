package com.qweib.cloud.biz.system.support;

import com.google.common.collect.Sets;
import com.qweib.cloud.utils.Collections3;
import com.qweib.commons.StringUtils;

import java.util.Map;
import java.util.Set;

/**
 * 设备在线状态辅助类
 *
 * @author: jimmy.lin
 * @time: 2019/10/10 20:35
 * @description:
 */
public class DevicePresenceHelper {
    public static final String DEVICE_IOS = "ios";
    public static final String DEVICE_MOBILE = "mobile";
    public static final String DEVICE_ANDROID = "android";
    public static final String DEVICE_POS = "pos";
    public static final String DEVICE_DESKTOP = "desktop";
    public static final String DEVICE_H5 = "h5";
    public static final Set<String> SSO = Sets.newHashSet(DEVICE_MOBILE,DEVICE_ANDROID, DEVICE_IOS);


    public static boolean needSso(String type) {
        if (StringUtils.isBlank(type)) {
            return false;
        }
        return SSO.contains(type);
    }

    /**
     * @param devices 当前在线设备
     * @return
     */
    public static String detect(Map<String, String> devices) {
        if (Collections3.isEmpty(devices)) {
            return null;
        }
        for (Map.Entry<String, String> entry : devices.entrySet()) {
            if (SSO.contains(entry.getValue())) {
                return entry.getKey();
            }
        }
        return null;
    }


}
