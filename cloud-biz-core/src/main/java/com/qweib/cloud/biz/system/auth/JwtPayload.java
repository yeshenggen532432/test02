package com.qweib.cloud.biz.system.auth;

import lombok.Builder;
import lombok.Data;

import java.io.Serializable;

/**
 * @author jimmy.lin
 * create at 2020/4/17 19:31
 */
@Builder
@Data
public class JwtPayload implements Serializable {
    private Integer userId;
    private Integer companyId;
    private String mobile;
}
