package com.qweib.cloud.biz.system.controller.plat.vo;

import com.google.common.collect.Lists;
import lombok.Data;

import java.util.List;

/**
 * @author: jimmy.lin
 * @time: 2019/3/1 15:02
 * @description:
 */
@Data
public class MenuItem {
    private int id_key;
    private String menu_cd;
    private String data_tp;
    private String menu_leaf;
    private String menu_url;
    private int apply_no;
    private String menu_tp;
    private String menu_nm;
    private String menu_cls;
    private int p_id;
    private List<MenuItem> children = Lists.newArrayList();

    public boolean isRoot() {
        return this.p_id == 0;
    }
}
