package com.qweib.cloud.biz.system.service.common.dto;

import lombok.Data;

import java.util.List;

/**
 * @author: jimmy.lin
 * @time: 2019/8/10 14:34
 * @description:
 */
@Data
public class BillConfigDTO {
    private Integer id;
    private String namespace;
    private List<BillConfigItemDTO> master;
    private List<BillConfigItemDTO> slave;
    private List<BillConfigItemDTO> other;
}
