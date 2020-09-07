package com.qweib.cloud.gradeEvent;

import lombok.Data;

@Data
public class GradeEventBean {

    public GradeEventBean(Integer id, String name, String database, String companyId) {
        this.id = id;
        this.name = name;
        this.database = database;
        this.companyId = companyId;
    }

    private Integer id;
    private String name;
    private String database;
    private String companyId;

}
