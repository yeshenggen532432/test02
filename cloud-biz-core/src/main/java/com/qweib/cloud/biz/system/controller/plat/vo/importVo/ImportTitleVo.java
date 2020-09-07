package com.qweib.cloud.biz.system.controller.plat.vo.importVo;

import lombok.Data;

/**
 * 导入实体
 */
@Data
public class ImportTitleVo {
    private String title;
    private String field;
    private String type;//number,string,默认为string

    public ImportTitleVo() {

    }

    public ImportTitleVo(String title, String field, String type) {
        this.title = title;
        this.field = field;
        if (type != null)
            this.type = type;
    }
}
