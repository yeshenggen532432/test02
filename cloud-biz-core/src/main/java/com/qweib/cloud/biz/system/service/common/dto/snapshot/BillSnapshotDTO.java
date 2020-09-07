package com.qweib.cloud.biz.system.service.common.dto.snapshot;

import lombok.Data;

import java.io.Serializable;

/**
 * @author: jimmy.lin
 * @time: 2019/10/18 14:04
 * @description:
 */
@Data
public class BillSnapshotDTO implements Serializable {
    private static final long serialVersionUID = 8038504383017580316L;

    private String id;
    private Integer userId;
    private String title;
    private String billType;
    private Integer billId;

    private Long createTime;
    private Long updateTime;
}
