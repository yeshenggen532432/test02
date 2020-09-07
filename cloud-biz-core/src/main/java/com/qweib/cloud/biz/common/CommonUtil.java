package com.qweib.cloud.biz.common;

import com.qweib.cloud.utils.Page;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * 用户工具类
 */
public class CommonUtil {

    //默认一页大小
    static final int BATCH_SIZE = 100;


    /**
     * 内存分页方法
     *
     * @param list
     * @return
     */
    public static Page makeListToPage(List list) {
        return makeListToPage(list, null);
    }

    public static Page makeListToPage(List list, Integer pageSize) {
        if (pageSize == null)
            pageSize = BATCH_SIZE;
        Page page = new Page();
        if (list == null || list.isEmpty()) return page;
        page.setCurPage(1);
        page.setPageSize(pageSize);
        int total = list.size();
        page.setTotal(total);
        page.setTotalPage((total - 1) / pageSize + 1);

        int fromIndex = 0;
        int toIndex = pageSize;
        while (fromIndex != list.size()) {
            if (toIndex > list.size()) {
                toIndex = list.size();
            }
            List rows = page.getRows();
            if (rows == null) rows = new ArrayList();
            rows.add(list.subList(fromIndex, toIndex));
            page.setRows(rows);

            fromIndex = toIndex;
            toIndex += pageSize;
            if (toIndex > list.size())
                toIndex = list.size();
        }
        return page;
    }

    public static double div(int d1, int d2) {
        return Double.valueOf(d1) / Double.valueOf(d2);
    }


    /**
     * 获取MAP数组值中其中一个
     *
     * @param requestParamMap
     * @param key
     * @return
     */
    public static String getMapOnlyValue(Map<String, String[]> requestParamMap, String key) {
        if (requestParamMap == null || requestParamMap.isEmpty()) return null;
        String[] ss = requestParamMap.get(key);
        if (ss != null && ss.length > 0)
            return ss[0].trim();
        else return null;
    }
}
