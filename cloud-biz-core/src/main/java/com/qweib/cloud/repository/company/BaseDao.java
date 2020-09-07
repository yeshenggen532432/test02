package com.qweib.cloud.repository.company;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2019/5/21 - 15:20
 */
public abstract class BaseDao {

    protected String getWhereLogical(int index) {
        if (index > 0) {
            return " AND ";
        } else {
            return " WHERE ";
        }
    }
}
