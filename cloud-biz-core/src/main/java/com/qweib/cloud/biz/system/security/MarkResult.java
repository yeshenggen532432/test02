package com.qweib.cloud.biz.system.security;

import lombok.Data;

/**
 * @author: jimmy.lin
 * @time: 2019/9/2 11:59
 * @description:
 */
@Data
public class MarkResult {
    private long count;

    public boolean locked() {
        return this.count >= 5;
    }

    public boolean captcha() {
        return this.count >= 3;
    }

    public long remain() {
        return 5 - this.count;
    }
}
