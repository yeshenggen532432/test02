package com.qweib.cloud.biz.system.auth;

import java.util.List;

/**
 * @author: jimmy.lin
 * @time: 2019/11/15 11:43
 * @description:
 */
public interface MenuProvider {

    List<String> getAll();

    List<String> gerRoleMenus(String database, List<Integer> roleIds, Integer memberId);

}
