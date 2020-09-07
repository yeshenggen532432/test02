package com.qweib.cloud.biz.system.service.common.dto;

import lombok.Data;

/**
 * @author: jimmy.lin
 * @time: 2019/8/10 14:32
 * @description:
 */
@Data
public class BillConfigItemDTO {
    private Integer id;
    private String field;
    private String title;
    private Integer width;
    private Boolean hidden;
    private Integer type;
    private Boolean reserved;
    private Integer sort;
}
