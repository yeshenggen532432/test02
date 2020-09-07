package com.qweib.cloud.biz.customer.duplicate.dto;

import java.util.Objects;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2019/8/9 - 11:24
 */
public class CustomerDTO {

    private final Integer id;
    private final CustomerTypeEnum type;
    private final String name;

    public CustomerDTO(CustomerTypeEnum type, String name) {
        this(null, type, name);
    }

    public CustomerDTO(Integer id, CustomerTypeEnum type, String name) {
        this.id = id;
        this.type = type;
        this.name = name;
    }

    public Integer getId() {
        return id;
    }

    public CustomerTypeEnum getType() {
        return type;
    }

    public String getName() {
        return name;
    }

    @Override
    public int hashCode() {
        return super.hashCode() +
                (this.id != null ? this.id.hashCode() : 0) +
                this.type.hashCode() + this.name.hashCode();
    }

    @Override
    public boolean equals(Object obj) {
        if (obj == this) {
            return true;
        }

        if (!(obj instanceof CustomerDTO)) {
            return false;
        }

        CustomerDTO other = (CustomerDTO) obj;

        return Objects.equals(this.id, other.id)
                && Objects.equals(this.type, other.type)
                && Objects.equals(this.name, other.name);
    }
}
