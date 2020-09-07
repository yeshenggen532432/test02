package com.qweib.cloud.biz.common;

import com.qweib.cloud.utils.StrUtil;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2019/4/15 - 17:27
 */
public class GpsUtils {

    public static void createGpsMember(String url, Integer companyId, Integer memberId) {
        StringBuilder params = new StringBuilder(128);
        params.append("company_id=").append(companyId).append("&user_id=").append(memberId)
                .append("&location=[{\"longitude\":14.22222,\"latitude\":23.25555,\"address\":\"\",\"location_time\":").append(StrUtil.getDqsjc())
                .append(",\"location_from\":\"\",\"os\":\"\"}]");
        MapGjTool.postMapGjurl2(url, params.toString());
    }
}
