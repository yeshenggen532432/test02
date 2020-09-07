package com.qweib.cloud.core.domain.dto;

import java.util.List;

/**
 * @author: jimmy.lin
 * @time: 2019/1/24 15:09
 * @description:
 */
public class UpdateSunitFrontInput {
    private List ids;
    private Integer type;

    public List getIds() {
        return ids;
    }

    public void setIds(List ids) {
        this.ids = ids;
    }

    public Integer getType() {
        return type;
    }

    public void setType(Integer type) {
        this.type = type;
    }
}
