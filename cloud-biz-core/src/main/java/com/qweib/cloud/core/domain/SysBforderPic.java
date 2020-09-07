package com.qweib.cloud.core.domain;

import lombok.Data;

/**
 * 订单图片历史
 */
@Data
public class SysBforderPic {
    private Integer id;//图片id
    private Integer type;//1主图
    private String picMini;//小图
    private String pic;//大图
    private Integer wareId;
    private Integer orderId;//订单ID
}
