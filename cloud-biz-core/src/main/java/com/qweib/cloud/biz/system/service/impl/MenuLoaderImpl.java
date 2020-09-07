package com.qweib.cloud.biz.system.service.impl;

import com.fasterxml.jackson.databind.JavaType;
import com.qweib.cloud.biz.system.controller.plat.vo.MenuItem;
import com.qweib.cloud.biz.system.service.MenuLoader;
import com.qweibframework.commons.mapper.JsonMapper;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.io.FileUtils;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.core.io.Resource;

import java.io.IOException;
import java.util.List;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2019/4/13 - 14:09
 */
@Slf4j
public class MenuLoaderImpl implements InitializingBean, MenuLoader {

    private Resource location;

    private List<MenuItem> menuItems;

    private void load() throws IOException {
        String jsonContent = FileUtils.readFileToString(location.getFile(), "UTF-8");
        JsonMapper jsonMapper = JsonMapper.getInstance();
        JavaType collectionType = jsonMapper.createCollectionType(List.class, MenuItem.class);
        this.menuItems = jsonMapper.fromJson(jsonContent, collectionType);
    }

    @Override
    public void afterPropertiesSet() throws Exception {
        load();
    }

    @Override
    public List<MenuItem> getMenus() {
        if (menuItems == null) {
            try {
                load();
            } catch (IOException e) {
                log.error("load menu error", e);
            }
        }

        return menuItems;
    }

    public Resource getLocation() {
        return location;
    }

    public void setLocation(Resource location) {
        this.location = location;
    }
}
