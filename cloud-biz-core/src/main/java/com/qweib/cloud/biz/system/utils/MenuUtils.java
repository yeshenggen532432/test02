package com.qweib.cloud.biz.system.utils;

import com.google.common.base.Function;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.google.common.collect.Ordering;
import com.qweib.cloud.biz.system.controller.plat.vo.MenuItem;
import com.qweib.cloud.biz.system.service.MenuLoader;
import com.qweib.cloud.biz.system.service.plat.SysCompanyRoleService;
import com.qweib.cloud.core.domain.SysApplyDTO;
import com.qweib.cloud.utils.Collections3;
import com.qweib.cloud.utils.SpringContextHolder;
import com.qweib.commons.StringUtils;
import com.qweib.commons.mapper.BeanMapper;

import javax.annotation.Nullable;
import java.util.*;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2019/4/13 - 13:59
 */
public class MenuUtils {

    /**
     * 自定义菜单界限
     */
    public static final int CUSTOM_MENU_BOUND = 10000;

    /**
     * 检查是否公司创建者，并增加创建者菜单
     *
     * @param database
     * @param roleIds
     * @param sysCompanyRoleService
     * @return
     */
    public static List<MenuItem> getCompanyCreatorMenuItem(String database, List<Integer> roleIds, SysCompanyRoleService sysCompanyRoleService) {
        if (!RoleUtils.hasCompanyCreator(roleIds, sysCompanyRoleService, database)) {
            return null;
        }

        MenuLoader menuLoader = SpringContextHolder.getBean(MenuLoader.class);

        return menuLoader.getMenus();
    }

    public static List<Map<String, Object>> getCompanyCreatorMenuMap(String database, List<Integer> roleIds, SysCompanyRoleService sysCompanyRoleService) {
        List<MenuItem> menuItems = getCompanyCreatorMenuItem(database, roleIds, sysCompanyRoleService);
        if (Collections3.isEmpty(menuItems)) {
            return null;
        }

        List<Map<String, Object>> menuMapList = Lists.newArrayList();
        convertToMap(menuMapList, menuItems);

        return menuMapList;
    }

    private static void convertToMap(List<Map<String, Object>> menuMapList, List<MenuItem> menuItems) {
        for (MenuItem menuItem : menuItems) {
            Map<String, Object> menuMap  = BeanMapper.map(menuItem, Map.class);
            menuMap.remove("children");
            menuMap.remove("root");
            menuMapList.add(menuMap);

            if (Collections3.isNotEmpty(menuItem.getChildren())) {
                convertToMap(menuMapList, menuItem.getChildren());
            }
        }
    }

    /**
     * 过滤数据权限相同的菜单
     * @param menuList
     * @param <E>
     */
    public static <E extends SysApplyDTO> void filterMenuDataAuthority(List<E> menuList) {
        Map<Integer, E> applyCache = Maps.newHashMap();
        Iterator<E> iterator = menuList.iterator();
        while (iterator.hasNext()) {
            final E applyDTO = iterator.next();
            Optional.ofNullable(applyCache.get(applyDTO.getId()))
                    .map(sysApplyDTO -> {
                        if (compareAndResetDateType(sysApplyDTO.getDataTp(), applyDTO.getDataTp())) {
                            sysApplyDTO.setDataTp(applyDTO.getDataTp());
                            sysApplyDTO.setSgtjz(applyDTO.getSgtjz());
                            sysApplyDTO.setMids(applyDTO.getMids());
                        }
                        iterator.remove();
                        return sysApplyDTO;
                    })
                    .orElseGet(() -> {
                        applyCache.put(applyDTO.getId(), applyDTO);

                        return applyDTO;
                    });
        }
    }

    public static <E extends SysApplyDTO> void sortMenus(List<E> menuList) {
        if (Collections3.isNotEmpty(menuList)) {
            final Ordering<E> ordering = makeMenuOrdering();

            Collections.sort(menuList, ordering);
        }
    }

    public static <E extends SysApplyDTO> Ordering<E> makeMenuOrdering() {
        return Ordering.natural().onResultOf(new Function<E, String>() {
            @Nullable
            @Override
            public String apply(@Nullable E menu) {
                return new StringBuilder(8).append(StringUtils.leftPad(StringUtils.toInteger(menu.getApplyNo()).toString(), 3, '0'))
                        .append(com.qweibframework.commons.StringUtils.leftPad(String.valueOf(menu.getId()), 3, '0')).toString();
            }
        });
    }

    /**
     * 比较并检查是否需要替换数据权限
     *
     * @param oldType
     * @param newType
     * @return
     */
    private static boolean compareAndResetDateType(String oldType, String newType) {
        if (Objects.isNull(oldType)) {
            return true;
        }

        if (Objects.isNull(newType)) {
            return false;
        }

        if (Objects.equals(oldType, newType)) {
            return false;
        }

        Integer oldValue = StringUtils.toInteger(oldType);
        Integer newValue = StringUtils.toInteger(newType);

        return oldValue > newValue;
    }
}
