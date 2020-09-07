package com.qweib.cloud.biz.system;

import com.qweib.cloud.biz.system.service.SysConfigService;
import com.qweib.cloud.biz.system.service.plat.SysCompanyRoleService;
import com.qweib.cloud.biz.system.utils.RoleUtils;
import com.qweib.cloud.core.domain.SysConfig;
import com.qweib.cloud.core.domain.SysLoginInfo;
import com.qweib.cloud.utils.Collections3;
import com.qweib.cloud.utils.SpringContextHolder;
import com.qweibframework.boot.datasource.DataSourceContextAllocator;
import com.qweibframework.commons.StringUtils;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


/**
 * 校验按钮权限
 *
 * @author apple
 */
public class PermissionUtil {

    public static Map checkUserBtnPdm(String btnCode) {
        SysLoginInfo sysLoginInfo = getSysLoginInfo();
        SysCompanyRoleService sysCompanyRoleService = SpringContextHolder.getBean("sysCompanyRoleService");
        boolean hasAdmin = RoleUtils.hasCompanyAdmin(sysLoginInfo.getUsrRoleIds(), sysCompanyRoleService, sysLoginInfo.getDatasource());
        if (hasAdmin) {
            Map map = new HashMap<String, Object>();
            map.put("menu", "all");
            return map;
        }
        SysConfigService configService = SpringContextHolder.getBean("sysConfigService");
        SysConfig config = configService.querySysConfigByCode("CONFIG_BUTTON_OPEN_AUTH", sysLoginInfo.getDatasource());
        if (config != null && "1".equals(config.getStatus())) {
        } else {
            Map map = new HashMap<String, Object>();
            map.put("menu", "all");
            return map;
        }

        List<Map<String, Object>> mapList = sysCompanyRoleService.queryRoleButtonByCodes(sysLoginInfo.getDatasource(), sysLoginInfo.getUsrRoleIds(), btnCode);
        if (mapList != null && mapList.size() > 0) {
            return mapList.get(0);
        }
        return null;
    }

    public static String checkUserFieldDisplay(String btnCode) {
        SysCompanyRoleService sysCompanyRoleService = SpringContextHolder.getBean("sysCompanyRoleService");
        SysLoginInfo sysLoginInfo = getSysLoginInfo();
        SysConfigService configService = SpringContextHolder.getBean("sysConfigService");
        SysConfig config = configService.querySysConfigByCode("CONFIG_BUTTON_OPEN_AUTH", sysLoginInfo.getDatasource());
        if (config != null && "1".equals(config.getStatus())) {
        } else {
            return StringUtils.EMPTY;
        }

        boolean hasAdmin = RoleUtils.hasCompanyAdmin(sysLoginInfo.getUsrRoleIds(), sysCompanyRoleService, sysLoginInfo.getDatasource());
        List<Map<String, Object>> mapList;
        if (hasAdmin) {
            mapList = sysCompanyRoleService.queryAdminButtonByCodes(sysLoginInfo.getDatasource(), btnCode);
        } else {
            mapList = sysCompanyRoleService.queryRoleButtonByCodes(sysLoginInfo.getDatasource(), sysLoginInfo.getUsrRoleIds(), btnCode);
        }
        if (Collections3.isNotEmpty(mapList)) {
            return StringUtils.EMPTY;
        } else {
            return "none";
        }
    }

    public static Boolean checkUserFieldPdm(String btnCode) {
        SysCompanyRoleService sysCompanyRoleService = SpringContextHolder.getBean("sysCompanyRoleService");
        SysLoginInfo sysLoginInfo = getSysLoginInfo();
        SysConfigService configService = SpringContextHolder.getBean("sysConfigService");
        SysConfig config = configService.querySysConfigByCode("CONFIG_BUTTON_OPEN_AUTH", sysLoginInfo.getDatasource());
        if (config != null && "1".equals(config.getStatus())) {
        } else {
            return true;
        }

        boolean hasAdmin = RoleUtils.hasCompanyAdmin(sysLoginInfo.getUsrRoleIds(), sysCompanyRoleService, sysLoginInfo.getDatasource());
        List<Map<String, Object>> mapList;
        if (hasAdmin) {
            mapList = sysCompanyRoleService.queryAdminButtonByCodes(sysLoginInfo.getDatasource(), btnCode);
        } else {
            mapList = sysCompanyRoleService.queryRoleButtonByCodes(sysLoginInfo.getDatasource(), sysLoginInfo.getUsrRoleIds(), btnCode);
        }
        if (Collections3.isNotEmpty(mapList)) {
            return true;
        } else {
            return false;
        }
    }

    public static Boolean checkUserButtonPdm(String btnCode) {
        SysCompanyRoleService sysCompanyRoleService = SpringContextHolder.getBean("sysCompanyRoleService");
        SysLoginInfo sysLoginInfo = getSysLoginInfo();

        boolean hasAdmin = RoleUtils.hasCompanyAdmin(sysLoginInfo.getUsrRoleIds(), sysCompanyRoleService, sysLoginInfo.getDatasource());
        List<Map<String, Object>> mapList;
        if (hasAdmin) {
            mapList = sysCompanyRoleService.queryAdminButtonByCodes(sysLoginInfo.getDatasource(), btnCode);
        } else {
            mapList = sysCompanyRoleService.queryRoleButtonByCodes(sysLoginInfo.getDatasource(), sysLoginInfo.getUsrRoleIds(), btnCode);
        }

        if (Collections3.isNotEmpty(mapList)) {
            return true;
        } else {
            return false;
        }
    }



    private static SysLoginInfo getSysLoginInfo() {
        HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder
                .getRequestAttributes())
                .getRequest();
        SysLoginInfo sysLoginInfo = (SysLoginInfo) request.getSession().getAttribute("usr");
        DataSourceContextAllocator allocator = SpringContextHolder.getBean(DataSourceContextAllocator.class);
        allocator.alloc(sysLoginInfo.getDatasource(), sysLoginInfo.getFdCompanyId());
        return sysLoginInfo;
    }


}
