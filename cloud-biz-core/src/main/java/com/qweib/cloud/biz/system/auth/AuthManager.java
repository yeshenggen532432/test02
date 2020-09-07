package com.qweib.cloud.biz.system.auth;

import java.util.List;

/**
 * @author: jimmy.lin
 * @time: 2019/11/15 11:11
 * @description:
 */
public interface AuthManager {

    void refreshMenuMap();

    boolean hasPermission(String request, String database,List<Integer> roleIds, Integer memberId);

    void refreshPermission(String database,List<Integer> roleIds, Integer memberId);

    String getUserPermissionHex(List<String> memberMenus, String database, Integer memberId);

    void clearPermissionCache(String database);

    /**
     * 平台更新菜单 清除所有个人权限缓存
     */
    void clearPermissionCache();
}
