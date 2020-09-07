package com.qweib.cloud.biz.customer.duplicate.dto;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2019/8/9 - 10:18
 */
public class ResultDTO {

    /**
     * 重复标识
     */
    private final Boolean found;
    /**
     * 建议名称
     */
    private final String suggestName;
    /**
     * 重复的实体，包括类型与数据 id(可返回给前台做参考)
     */
    private CustomerDTO repeatData;

    public ResultDTO(Boolean found) {
        this(found, null);
    }

    public ResultDTO(Boolean found, String suggestName) {
        this.found = found;
        this.suggestName = suggestName;
    }

    public Boolean isFound() {
        return found;
    }

    public String getSuggestName() {
        return suggestName;
    }

    public CustomerDTO getRepeatData() {
        return repeatData;
    }

    public ResultDTO setRepeatData(CustomerDTO repeatData) {
        this.repeatData = repeatData;
        return this;
    }
}
