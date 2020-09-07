package com.qweib.cloud.core.domain.settings.query;

import lombok.Data;

/**
 * @author: jimmy.lin
 * @time: 2019/8/9 17:54
 * @description:
 */
@Data
public class SolutionItem {
    private Integer id;
    private Integer solutionId;
    private String field;
    private Integer op;
    private String value;
}
