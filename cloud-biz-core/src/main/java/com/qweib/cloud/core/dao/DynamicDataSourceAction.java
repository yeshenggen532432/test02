package com.qweib.cloud.core.dao;

/**
 * @author jimmy.lin
 * create at 2020/1/20 17:48
 */
public interface DynamicDataSourceAction<T> {

    T handle(String datasource);
}
