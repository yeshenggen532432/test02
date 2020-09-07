package com.qweib.cloud.biz.system.controller.plat.vo;

import com.google.common.base.Function;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.google.common.collect.Ordering;
import com.qweib.commons.StringUtils;
import com.qweib.commons.mapper.BeanMapper;
import lombok.extern.slf4j.Slf4j;

import java.util.Collections;
import java.util.List;
import java.util.Map;

/**
 * 菜单树生成
 *
 * @author: jimmy.lin
 * @time: 2019/3/1 11:49
 * @description:
 */
@Slf4j
public class MenuHelper {

    /**
     * 功能菜单
     */
    private static final String TYPE_FUNC = "0";

    private MenuHelper() {
    }

    public static List<MenuItem> build(List<Map<String, Object>> menus) {
        List<MenuItem> items = Lists.newArrayList();

        Map<String, MenuItem> map = Maps.newHashMap();

        for (Map<String, Object> menu : menus) {
            if (!TYPE_FUNC.equals(menu.get("menu_tp"))) {
                continue;
            }
            MenuItem item = BeanMapper.map(menu, MenuItem.class);
            item.setChildren(Lists.newArrayListWithCapacity(5));
            if (item.isRoot()) {
                items.add(item);
            }
            map.put(String.valueOf(item.getId_key()), item);
        }

        final Ordering<MenuItem> menuOrdering = Ordering.natural().onResultOf((Function<MenuItem, String>) menuItem ->
                new StringBuilder(8).append(StringUtils.leftPad(StringUtils.toInteger(menuItem.getApply_no()).toString(), 3, '0'))
                        .append(StringUtils.leftPad(String.valueOf(menuItem.getId_key()), 3, '0')).toString()
        );
        List<MenuItem> menuItems = Lists.newArrayList(map.values());
        Collections.sort(menuItems, menuOrdering);

        for (MenuItem item : menuItems) {
            if (item.isRoot()) {
                continue;
            }
            String key = String.valueOf(item.getP_id());
            if (map.containsKey(key)) {
                map.get(key).getChildren().add(item);
            } else {
                log.debug("can not found menu id:[{}]", key);
            }
        }
        return items;
    }
}
