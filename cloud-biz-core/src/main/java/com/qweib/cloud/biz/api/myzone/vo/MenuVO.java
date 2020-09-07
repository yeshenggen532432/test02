package com.qweib.cloud.biz.api.myzone.vo;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.google.common.collect.Lists;
import com.qweib.cloud.utils.Collections3;
import lombok.Data;

import java.util.*;
import java.util.stream.Collectors;

/**
 * @author: jimmy.lin
 * @time: 2019/11/14 17:11
 * @description:
 */
@Data
public class MenuVO {
    private String applyIcon;
    private String applyCode;
    private String applyUrl;
    private Integer tp;
    @JsonIgnore
    private String id;
    @JsonIgnore
    private String pid;
    private String applyName;
    @JsonIgnore
    private Integer sort;
    private List<MenuVO> children = Lists.newArrayList();


    public static List<MenuVO> toTree(List<MenuVO> menus) {
        if (Collections3.isEmpty(menus)) {
            return Lists.newArrayList();
        }
        Map<String, MenuVO> map = menus.stream().collect(Collectors.toMap(MenuVO::getId, m -> m));
        List<MenuVO> m = Lists.newArrayList();
        for (MenuVO menu : menus) {
            if (Objects.equals(menu.getPid(), "-1")) {
                //root
                m.add(menu);
            } else {
                MenuVO parent = map.get(menu.getPid());
                if (parent != null) {
                    parent.getChildren().add(menu);
                }
            }
        }
        sort(m);
        return m;
    }

    private static void sort(List<MenuVO> menus) {
        for (MenuVO menu : menus) {
            if (Collections3.isNotEmpty(menu.getChildren())) {
                sort(menu.getChildren());
            }
        }
        menus.sort(Comparator.comparing(MenuVO::getSort));
    }
}
