package com.qweib.cloud.core.domain.dto;

import com.qweib.cloud.service.basedata.common.FuncSpecificTagEnum;
import lombok.Data;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2019/11/1 - 9:44
 */
@Data
public class SysMenuDTO {

    private Integer id;
    /**
     * 上级 id，顶级为 0
     * p_id
     */
    private Integer parentId;
    /**
     * 类型，1：菜单，2：应用
     * tp
     */
    private String type;
    /**
     * 名称
     * apply_name
     */
    private String name;
    /**
     * 代码
     * apply_code
     */
    private String code;
    /**
     * 图标 icon
     * apply_icon
     */
    private String icon;
    /**
     * 备注
     * apply_desc
     */
    private String description;
    /**
     * 菜单类型，0：菜单，1：按钮
     * menu_tp
     */
    private String menuType;
    /**
     * app 类型(app 专用)，0：原生，1：h5
     * apply_ifwap
     */
    private String appType;
    /**
     * 链接地址
     * apply_url
     */
    private String link;
    /**
     * 排序
     * apply_no
     */
    private Integer sort;
    /**
     * 绑定 menu id (app 专用)
     * menu_id
     */
    private Integer bindMenuId;
    /**
     * 特殊标识
     * specific_tag
     */
    private FuncSpecificTagEnum specificTag;
}
