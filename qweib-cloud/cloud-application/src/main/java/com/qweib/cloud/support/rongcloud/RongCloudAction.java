package com.qweib.cloud.support.rongcloud;

import io.rong.RongCloud;

/**
 * @author: jimmy.lin
 * @time: 2019/12/18 17:35
 * @description:
 */
public interface RongCloudAction<T> {
    T handle(RongCloud cloud) throws Exception;
}
