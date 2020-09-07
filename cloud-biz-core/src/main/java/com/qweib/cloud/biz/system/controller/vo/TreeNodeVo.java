package com.qweib.cloud.biz.system.controller.vo;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.google.common.collect.Lists;
import lombok.Builder;
import lombok.Data;

import java.util.List;

/**
 * @author: jimmy.lin
 * @time: 2019/12/2 10:42
 * @description:
 */
@Data
@Builder
@JsonInclude(JsonInclude.Include.NON_NULL)
public class TreeNodeVo{
    private Integer id;
    private Integer pid;
    private String text;
    private String state;
    private String path;
    private String leaf;
    private List<Integer> pathList;
    private List<TreeNodeVo> children = Lists.newArrayList();
}
