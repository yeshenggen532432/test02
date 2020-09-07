package com.qweib.cloud.biz.system;

import com.qweib.cloud.biz.system.service.plat.SysCompanyRoleService;
import com.qweib.cloud.biz.system.utils.RoleUtils;
import com.qweib.cloud.core.domain.OnlineUser;
import com.qweib.cloud.utils.Collections3;
import java.util.List;
import java.util.Map;


/**
 * 校验按钮权限
 *
 * @author apple
 */
public class MobileButtonAuthUtil {

    public static Boolean checkUserButtonPdm(String btnCode, SysCompanyRoleService sysCompanyRoleService, OnlineUser onlineUser ) {
        boolean hasAdmin = RoleUtils.hasCompanyAdmin(onlineUser.getUsrRoleIds(), sysCompanyRoleService, onlineUser.getDatabase());
        List<Map<String, Object>> mapList;
        if (hasAdmin) {
            mapList = sysCompanyRoleService.queryAdminAppButtonByCodes(onlineUser.getDatabase(), btnCode);
        } else {
            mapList = sysCompanyRoleService.queryRoleAppButtonByCodes(onlineUser.getDatabase(), onlineUser.getUsrRoleIds(), btnCode);
        }

        if (Collections3.isNotEmpty(mapList)) {
            return true;
        } else {
            return false;
        }
    }


}
