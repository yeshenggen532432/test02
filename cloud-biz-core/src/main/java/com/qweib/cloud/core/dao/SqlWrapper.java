package com.qweib.cloud.core.dao;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

/**
 * @author: jimmy.lin
 * @time: 2019/5/30 15:16
 * @description:
 */
@Data
@AllArgsConstructor
@NoArgsConstructor
public class SqlWrapper {
    private String sql;
    private List<Object> params;
}
