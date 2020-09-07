package com.qweib.cloud.core.domain;

import lombok.Data;

import java.util.Date;

/**
 * 导入数据临时表
 */
@Data
public class SysImportTempItem {

    private Integer id;
    /**
     * 导入临时表ID
     */
    private Integer importId;
    /**
     * 内容JSON
     */
    private String contextJson;
    /**
     * 导入状态:0未成功,1成功
     */
    private Integer importStatus;
    /**
     * 成功导入时间
     */
    private Date importSuccessDate;

}
