package com.qweib.cloud.biz.system;


import com.qweib.cloud.biz.system.service.plat.SysCompanyRoleService;
import com.qweib.cloud.biz.system.utils.RoleUtils;
import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.OnlineMessage;
import com.qweib.cloud.core.domain.OnlineUser;
import com.qweib.cloud.utils.Collections3;
import com.qweib.cloud.utils.SpringContextHolder;
import com.qweib.cloud.utils.StrUtil;
import com.qweib.commons.StringUtils;
import com.qweibframework.boot.datasource.DataSourceContextAllocator;

import java.util.List;
import java.util.Map;


public class BasicMobileUtil {


    public static List queryListByParam(String tableName, String selectBlock, String whereBlock, String token) {

        OnlineUser onLineUser = getOnlineUser(token);
        if (onLineUser == null) {
            return null;
        }
        if (StrUtil.isNull(selectBlock)) {
            selectBlock = "*";
        }
        if (StrUtil.isNull(whereBlock)) {
            whereBlock = " 1= 1";
        }

        String sql = "select " + selectBlock + " from " + onLineUser.getDatabase() + "." + tableName + " where 1=1 and " + whereBlock + " ";
        JdbcDaoTemplate daoTemplate = SpringContextHolder.getBean("daoTemplate");
        List list = daoTemplate.queryForList(sql);
        return list;
    }

    public static Boolean checkUserMenuPdm(String btnCode, String token) {
        SysCompanyRoleService sysCompanyRoleService = SpringContextHolder.getBean("sysCompanyRoleService");
        OnlineUser onLineUser = getOnlineUser(token);
        List<Map<String, Object>> btnMenus;
        if (RoleUtils.hasCompanyAdmin(onLineUser.getUsrRoleIds(), sysCompanyRoleService, onLineUser.getDatabase())) {
            btnMenus = sysCompanyRoleService.queryAdminMenuByCodes(onLineUser.getDatabase(), btnCode);
        } else {
            btnMenus = sysCompanyRoleService.queryRoleMenuByCodes(onLineUser.getDatabase(), onLineUser.getUsrRoleIds(), btnCode);
        }

        return Collections3.isNotEmpty(btnMenus);
    }

    public static String checkUserFieldDisplay(String btnCode, String token) {
        SysCompanyRoleService sysCompanyRoleService = SpringContextHolder.getBean("sysCompanyRoleService");
        OnlineUser onLineUser = getOnlineUser(token);

        List<Map<String, Object>> btnMenus;
        if (RoleUtils.hasCompanyAdmin(onLineUser.getUsrRoleIds(), sysCompanyRoleService, onLineUser.getDatabase())) {
            btnMenus = sysCompanyRoleService.queryAdminMenuByCodes(onLineUser.getDatabase(), btnCode);
        } else {
            btnMenus = sysCompanyRoleService.queryRoleMenuByCodes(onLineUser.getDatabase(), onLineUser.getUsrRoleIds(), btnCode);
        }
        if (Collections3.isNotEmpty(btnMenus)) {
            return StringUtils.EMPTY;
        }
        return "none";
    }

    private static OnlineUser getOnlineUser(String token) {
        OnlineMessage message = TokenServer.tokenCheck(token);
        if (message.isSuccess() == false) {
            return null;
        }
        OnlineUser onlineUser = message.getOnlineMember();
        DataSourceContextAllocator allocator = SpringContextHolder.getBean(DataSourceContextAllocator.class);
        allocator.alloc(onlineUser.getDatabase(), onlineUser.getFdCompanyId());
        return onlineUser;
    }
}
