package com.qweib.cloud.core.domain.product;

import lombok.Data;

import java.util.Date;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2019/5/21 - 14:42
 */
@Data
public class TempProductRecordDTO {

    private Integer id;
    /**
     * 记录标题
     */
    private String title;
    /**
     * 创建人名称
     */
    private String createdName;
    /**
     * 创建时间
     */
    private Date createdTime;
}
