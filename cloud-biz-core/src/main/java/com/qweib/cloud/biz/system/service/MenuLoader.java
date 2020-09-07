package com.qweib.cloud.biz.system.service;

import com.qweib.cloud.biz.system.controller.plat.vo.MenuItem;

import java.util.List;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2019/4/13 - 14:15
 */
public interface MenuLoader {

    List<MenuItem> getMenus();
}
