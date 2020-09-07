package com.qweib.cloud.biz.system.service.customer;

import com.qweib.cloud.biz.system.controller.plat.vo.importVo.ImportCustomerPriceVo;
import com.qweib.cloud.biz.system.controller.plat.vo.importVo.ImportResults;
import com.qweib.cloud.core.domain.SysLoginInfo;

import java.util.List;
import java.util.Map;

/**
 * 客户价格更新子线程
 */
public interface CustomerPriceThreadService {


    /**
     * @param models   导入数据
     * @param info     用户资料
     * @param importId 导入临时表数据库ID
     * @param taskId   进度条ID
     * @param start    开始位置
     * @param addLen   增加长度
     * @return
     */
    void updateImportThreadCustomerPrice(List<ImportCustomerPriceVo> models, SysLoginInfo info, String importId, String taskId, double start, double addLen, Map<String, String[]> requestParamMap, ImportResults importResults, int startRow);

}
