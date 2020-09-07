package com.qweib.cloud.core.domain.common;

import lombok.Data;

/**
 * @author: jimmy.lin
 * @time: 2019/10/18 14:14
 * @description:
 */
@Data
public class BillSnapshot {
    private String id;
    private Integer userId;
    private String title;
    private String billType;
    private Integer billId;
    private String data;
    private Long createTime;
    private Long updateTime;
}
