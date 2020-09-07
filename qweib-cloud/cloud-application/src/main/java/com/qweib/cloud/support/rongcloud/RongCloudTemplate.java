package com.qweib.cloud.support.rongcloud;

import com.qweib.cloud.core.exception.BizException;
import io.rong.RongCloud;
import io.rong.models.Result;
import lombok.extern.slf4j.Slf4j;

/**
 * @author: jimmy.lin
 * @time: 2019/12/18 17:31
 * @description:
 */
@Slf4j
public class RongCloudTemplate {

    private RongCloud rongCloud;

    public RongCloudTemplate(RongCloud rongCloud) {
        this.rongCloud = rongCloud;
    }

    public <T extends Result> T execute(RongCloudAction<T> action) {
        try {
            T result = action.handle(rongCloud);
            if (!result.getCode().equals(200)) {
                throw new BizException(result.getErrorMessage());
            }
            return result;
        } catch (Exception e) {
            log.error("rong cloud error", e);
            throw new BizException(e.getMessage());
        }
    }

}
