package com.qweib.cloud.biz.system.service.common.dto;

import lombok.Data;

import java.util.List;

/**
 * @author: jimmy.lin
 * @time: 2019/8/10 14:31
 * @description:
 */
@Data
public class BillConfigInput {
    private Integer id;
    private String namespace;
    private List<BillConfigItemDTO> items;
}
