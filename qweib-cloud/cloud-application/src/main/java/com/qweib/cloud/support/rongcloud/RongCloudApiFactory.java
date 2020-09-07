package com.qweib.cloud.support.rongcloud;

import io.rong.RongCloud;
import lombok.Setter;
import org.springframework.beans.factory.config.AbstractFactoryBean;

/**
 * @author: jimmy.lin
 * @time: 2019/12/18 17:09
 * @description:
 */
@Setter
public class RongCloudApiFactory extends AbstractFactoryBean<RongCloud> {

    private String appKey;
    private String appSecret;


    @Override
    public Class<?> getObjectType() {
        return RongCloud.class;
    }

    @Override
    protected RongCloud createInstance() throws Exception {
        return RongCloud.getInstance(this.appKey, this.appSecret);
    }
}
