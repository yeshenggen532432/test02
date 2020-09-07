package com.qweib.cloud.biz.system.service.common.dto;

import lombok.Data;

/**
 * @author: jimmy.lin
 * @time: 2019/8/12 15:11
 * @description:
 */
@Data
public class QuerySolutionItemDTO {
    private String field;
    private Integer op;
    private String value;
}
