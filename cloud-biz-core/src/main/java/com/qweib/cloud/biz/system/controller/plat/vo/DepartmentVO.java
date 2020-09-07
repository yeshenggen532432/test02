package com.qweib.cloud.biz.system.controller.plat.vo;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.qweib.cloud.core.domain.SysDepart;
import com.qweib.commons.mapper.BeanMapper;
import lombok.Data;
import lombok.extern.slf4j.Slf4j;

import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * @author: jimmy.lin
 * @time: 2019/3/6 17:52
 * @description:
 */
@Slf4j
@Data
public class DepartmentVO {

    private Integer branchId;
    private String branchName;
    private Integer parentId;
    private List<DepartmentVO> children;
    private String branchPath;

    public boolean isRoot(){
        return parentId == null || parentId.equals(0);
    }

    public static List<DepartmentVO> tree(List<SysDepart> departs) {
        List<DepartmentVO> items = Lists.newArrayList();

        Map<String, DepartmentVO> map = Maps.newHashMap();

        for (SysDepart menu : departs) {
            DepartmentVO item = BeanMapper.map(menu, DepartmentVO.class);
            item.setChildren(Lists.<DepartmentVO>newArrayList());
            if (item.isRoot()) {
                items.add(item);
            }
            map.put(String.valueOf(item.branchId), item);
        }

        Set<Map.Entry<String, DepartmentVO>> entries = map.entrySet();
        for (Map.Entry<String, DepartmentVO> entry : entries) {
            DepartmentVO item = entry.getValue();
            if (item.isRoot()) {
                continue;
            }
            String key = String.valueOf(item.getParentId());
            if (map.containsKey(key)) {
                map.get(key).getChildren().add(item);
            } else {
                log.debug("can not found department id:[{}]", key);
            }
        }
        return items;
    }

}
