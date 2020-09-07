package com.qweib.cloud.biz.system.service.common.dto;

import lombok.Data;

import java.util.List;

/**
 * @author: jimmy.lin
 * @time: 2019/8/12 15:10
 * @description:
 */
@Data
public class QuerySolutionInput {
    private String title;
    private String namespace;
    private Boolean share;
    private List<QuerySolutionItemDTO> items;
}
