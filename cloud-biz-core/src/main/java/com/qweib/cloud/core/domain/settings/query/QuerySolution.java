package com.qweib.cloud.core.domain.settings.query;

import com.qweib.cloud.core.dao.annotations.QwbTable;
import lombok.Data;

import java.io.Serializable;
import java.util.Date;

/**
 * @author: jimmy.lin
 * @time: 2019/8/9 17:48
 * @description:
 */
@Data
@QwbTable("bsc_query_solution")
public class QuerySolution implements Serializable {
    private Integer id;
    private String namespace;
    private String title;
    private Boolean share;
    private Integer creatorId;
    private Date createTime;
}
