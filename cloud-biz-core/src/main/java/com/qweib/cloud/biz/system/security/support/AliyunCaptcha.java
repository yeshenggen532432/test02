package com.qweib.cloud.biz.system.security.support;

import com.aliyuncs.IAcsClient;
import com.aliyuncs.afs.model.v20180112.AuthenticateSigRequest;
import com.aliyuncs.afs.model.v20180112.AuthenticateSigResponse;
import lombok.Setter;
import lombok.extern.slf4j.Slf4j;

/**
 * @author: jimmy.lin
 * @time: 2019/9/2 10:36
 * @description:
 */
@Slf4j
@Setter
public class AliyunCaptcha {

    private String appKey;

    private IAcsClient client;

    public boolean validate(String remoteIp, String sessionId, String sig, String token, String scene) {
        AuthenticateSigRequest request = new AuthenticateSigRequest();
        request.setAppKey(this.appKey);
        request.setSessionId(sessionId);
        request.setSig(sig);
        request.setToken(token);
        request.setScene(scene);
        request.setRemoteIp(remoteIp);
        try {
            AuthenticateSigResponse response = client.getAcsResponse(request);
            return response.getCode() == 100;
        } catch (Exception e) {
            log.error("aliyun afs request error", e);
            return false;
        }
    }

}
