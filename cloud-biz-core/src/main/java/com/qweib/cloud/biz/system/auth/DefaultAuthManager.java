package com.qweib.cloud.biz.system.auth;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.google.common.collect.Sets;
import com.qweib.commons.StringUtils;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * @author: jimmy.lin
 * @time: 2019/11/15 11:18
 * @description:
 */
@Slf4j
@Component
public class DefaultAuthManager implements AuthManager {
    private static final String KEY_PERMISSION_PREFIX = "user_permission:";
    private Map<String, Integer> menuMap = Maps.newConcurrentMap();
    @Autowired
    @Qualifier("stringRedisTemplate")
    private StringRedisTemplate redisTemplate;
    @Autowired
    private MenuProvider menuProvider;

    @PostConstruct
    public void loadMenu() {
        List<String> all = Lists.newArrayList(Sets.newHashSet(menuProvider.getAll()));
        all.sort(String::compareTo);
        menuMap.clear();

        for (int i = 0; i < all.size(); i++) {
            String menu = all.get(i);
            menu = MenuHelper.trim(menu);
            if (menuMap.containsKey(menu)) {
                System.out.println(menu);
            }
            menuMap.put(MenuHelper.trim(menu), i);
        }
        log.info("[{}] menus loaded", menuMap.size());
    }

    @Override
    public void refreshMenuMap() {
        loadMenu();
    }

    @Override
    public boolean hasPermission(String request, String database, List<Integer> roleIds, Integer memberId) {
        String hex = redisTemplate.opsForValue().get(KEY_PERMISSION_PREFIX + database + ":" + memberId);
        if (StringUtils.isBlank(hex)) {
            hex = MenuHelper.getPermissions(menuMap, menuProvider.gerRoleMenus(database, roleIds, memberId));
            redisTemplate.opsForValue().set(KEY_PERMISSION_PREFIX + database + ":" + memberId, hex);
        }
        return MenuHelper.hasPermission(request, menuMap, hex);
    }

    @Override
    public void refreshPermission(String database, List<Integer> roleIds, Integer memberId) {
        String hex = MenuHelper.getPermissions(menuMap, menuProvider.gerRoleMenus(database, roleIds, memberId));
        redisTemplate.opsForValue().set(KEY_PERMISSION_PREFIX + database + ":" + memberId, hex);
    }

    @Override
    public String getUserPermissionHex(List<String> menus, String database, Integer memberId) {
        String hex = MenuHelper.getPermissions(menuMap, menus);
        redisTemplate.opsForValue().set(KEY_PERMISSION_PREFIX + database + ":" + memberId, hex);
        return hex;
    }

    @Override
    public void clearPermissionCache(String database) {
        Set<String> keys = redisTemplate.keys(KEY_PERMISSION_PREFIX + database + "*");
        redisTemplate.delete(keys);
    }

    @Override
    public void clearPermissionCache() {
        Set<String> keys = redisTemplate.keys(KEY_PERMISSION_PREFIX + "*");
        redisTemplate.delete(keys);
    }
}
