package com.qweib.cloud.biz.system.security.support;

import com.aliyuncs.DefaultAcsClient;
import com.aliyuncs.IAcsClient;
import com.aliyuncs.profile.DefaultProfile;
import com.aliyuncs.profile.IClientProfile;
import lombok.Setter;
import org.springframework.beans.factory.config.AbstractFactoryBean;

/**
 * @author: jimmy.lin
 * @time: 2019/9/2 10:37
 * @description:
 */
@Setter
public class IAcsClientFactory extends AbstractFactoryBean<IAcsClient> {

    private String accessKey;
    private String secret;
    private String region = "cn-hangzhou";

    @Override
    public Class<?> getObjectType() {
        return IAcsClient.class;
    }

    @Override
    protected IAcsClient createInstance() throws Exception {
        IClientProfile profile = DefaultProfile.getProfile(region, accessKey, secret);
        return new DefaultAcsClient(profile);
    }
}
