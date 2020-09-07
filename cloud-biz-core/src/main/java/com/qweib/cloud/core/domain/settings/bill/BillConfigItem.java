package com.qweib.cloud.core.domain.settings.bill;

import lombok.Data;

/**
 * @author: jimmy.lin
 * @time: 2019/8/9 17:54
 * @description:
 */
@Data
public class BillConfigItem {
    private Integer id;
    private Integer configId;
    private String field;
    private String title;
    private Integer width;
    private Boolean hidden;
    private Integer type;
    private Boolean reserved;
    private Integer sort;

}
