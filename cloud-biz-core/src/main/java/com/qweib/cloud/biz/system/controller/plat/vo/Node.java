package com.qweib.cloud.biz.system.controller.plat.vo;

import lombok.Builder;
import lombok.Data;

/**
 * @author: jimmy.lin
 * @time: 2019/9/9 11:20
 * @description:
 */
@Data
@Builder
public class Node {
    private Integer id;
    private Integer pid;
    private String text;
    private Boolean expanded;
    private Boolean checked;
}
