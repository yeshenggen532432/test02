package com.qweib.cloud.biz.system;

import com.qweib.cloud.core.domain.dto.SysMenuDTO;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2019/11/1 - 10:53
 */
public interface MenuConverter<T> {

    T convertMenu(SysMenuDTO menuDTO);
}
