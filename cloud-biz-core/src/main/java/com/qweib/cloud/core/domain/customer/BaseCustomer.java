package com.qweib.cloud.core.domain.customer;

import lombok.Data;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2019/4/24 - 19:13
 */
@Data
public class BaseCustomer {

    private Integer id;
    private String name;
    private String address;
    private Integer isDb;

    public BaseCustomer() {

    }

    public BaseCustomer(Integer id, String name, String address, Integer isDb) {
        this.id = id;
        this.name = name;
        this.address = address;
        this.isDb = isDb;
    }
}
