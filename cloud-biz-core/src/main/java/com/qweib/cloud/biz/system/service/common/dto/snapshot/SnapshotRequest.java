package com.qweib.cloud.biz.system.service.common.dto.snapshot;

import lombok.Data;

/**
 * @author: jimmy.lin
 * @time: 2019/10/18 18:08
 * @description:
 */
@Data
public class SnapshotRequest {
    private String id;
    private String title;
    private Integer billId;
    private String billType;
    private Object data;
}
