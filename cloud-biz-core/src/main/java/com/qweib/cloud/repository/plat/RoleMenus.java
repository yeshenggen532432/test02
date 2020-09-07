package com.qweib.cloud.repository.plat;

import com.qweib.cloud.service.basedata.domain.firm.FirmMenuConfigDTO;
import com.qweib.cloud.service.basedata.domain.firm.FirmMenuConfigQuery;
import com.qweib.cloud.service.basedata.retrofit.FirmMenuConfigRequest;
import com.qweibframework.commons.Collections3;
import com.qweibframework.commons.StringUtils;
import com.qweibframework.commons.domain.DelFlagEnum;
import com.qweibframework.commons.http.ResponseUtils;
import org.springframework.context.ApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import java.util.*;

//FIXME

/**
 * 说明：
 *
 * @创建：作者:yxy 创建时间：2011-6-28
 * @修改历史： [序号](yxy 2011 - 6 - 28)<修改说明>
 */
public class RoleMenus implements ServletContextListener {
    private static final List<FirmMenuConfigDTO> menuCache = new ArrayList<>(64);
    //	public static List<SysMenu> menuList = new ArrayList<>();
    public static Map<Integer, List<Map<String, Object>>> roleMenus = new HashMap<Integer, List<Map<String, Object>>>();//角色和菜单map
    public static Map<Integer, List<Map<String, Object>>> roleMenusMc = new HashMap<Integer, List<Map<String, Object>>>();//角色和菜单map

    @Override
    public void contextDestroyed(ServletContextEvent arg0) {
        menuCache.clear();
    }

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        ApplicationContext context = WebApplicationContextUtils.getWebApplicationContext(sce.getServletContext());
//        FirmMenuConfigRequest menuConfigRequest = (FirmMenuConfigRequest) context.getBean("firmMenuConfigRequest");
//        FirmMenuConfigQuery query = new FirmMenuConfigQuery();
//        query.setDelFlag(DelFlagEnum.NORMAL);
//        List<FirmMenuConfigDTO> menuConfigDTOS = ResponseUtils.convertResponse(menuConfigRequest.list(query));
//        if (Collections3.isNotEmpty(menuConfigDTOS)) {
//            for (FirmMenuConfigDTO menuConfigDTO : menuConfigDTOS) {
//                if (StringUtils.isNotBlank(menuConfigDTO.getLink())) {
//                    menuCache.add(menuConfigDTO);
//                }
//            }
//        }
//		SysRoleDao roleDao = (SysRoleDao)ac.getBean("sysRoleDao");
//		SysMenuDao menusDao = (SysMenuDao)ac.getBean("sysMenuDao");
//		menuList = menusDao.queryMenus();
//		List<SysRole> roles = roleDao.queryRoleAll();
//		for (SysRole role : roles) {
//			List<Map<String,Object>> menus = menusDao.querySysMenuByRoleId(role.getIdKey());
//			roleMenus.put(role.getIdKey(), menus);
//			List<Map<String,Object>> menusmc = menusDao.querySysMenuByRoleIdMc(role.getIdKey());
//			roleMenusMc.put(role.getIdKey(), menusmc);
//		}
    }

    public static Optional<FirmMenuConfigDTO> getMenuByLink(String link) {
        return menuCache.stream()
                .filter(e -> link.contains(e.getLink()))
                .findFirst();
    }
}

