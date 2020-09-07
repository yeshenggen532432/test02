package com.qweib.cloud.biz.system.service.common;

import com.qweib.cloud.biz.system.service.common.dto.BillConfigDTO;
import com.qweib.cloud.biz.system.service.common.dto.BillConfigInput;

/**
 * @author: jimmy.lin
 * @time: 2019/8/10 12:00
 * @description:
 */
public interface BillConfigService {

    /**
     * 加载指定单据配置
     * @param namespace
     * @param database
     * @return
     */
    BillConfigDTO findByNamespace(String namespace, String database);

    /**
     * 保存单据配置
     * @param config
     * @param database
     * @return
     */
    Integer save(BillConfigInput config, String database);

    /**
     * 重置单据配置
     * @param datasource
     * @param namespace
     */
    void flush(String datasource, String namespace);

    /**
     * 更新
     * @param config
     * @param datasource
     */
    void update(BillConfigInput config, String datasource);
}
