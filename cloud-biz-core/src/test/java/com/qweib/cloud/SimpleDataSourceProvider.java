package com.qweib.cloud;

import com.alibaba.druid.pool.DruidDataSource;
import com.google.common.collect.Maps;
import com.qweibframework.boot.datasource.config.AbstractDataSourceProvider;
import lombok.Setter;

/**
 * @author: jimmy.lin
 * @time: 2019/9/16 19:25
 * @description:
 */
@Setter
public class SimpleDataSourceProvider extends AbstractDataSourceProvider {

    private DruidDataSource dataSource;

    @Override
    public void load() throws Exception {
        super.targetDataSources = Maps.newHashMap();
        targetDataSources.put("default", dataSource);
        this.setDefaultDataSource(dataSource);
    }
}
