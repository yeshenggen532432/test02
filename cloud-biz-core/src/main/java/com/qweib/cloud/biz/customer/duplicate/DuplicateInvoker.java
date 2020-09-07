package com.qweib.cloud.biz.customer.duplicate;

import com.qweib.cloud.biz.customer.duplicate.dto.CustomerDTO;
import com.qweib.cloud.biz.customer.duplicate.dto.ResultDTO;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2019/8/9 - 10:09
 */
public interface DuplicateInvoker {

    /**
     * 检查名称是否有重复，并给出建议名称
     *
     * @param database    执行数据库
     * @param customerDTO 客户基础信息
     * @return
     */
    ResultDTO invoke(String database, CustomerDTO customerDTO);
}
