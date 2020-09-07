package com.qweib.cloud.biz.system.service.company;

import com.qweib.cloud.core.domain.product.TempProductRecordDTO;
import com.qweib.cloud.core.domain.product.TempProductRecordQuery;
import com.qweib.cloud.core.domain.product.TempProductRecordSave;
import com.qweib.commons.page.Page;
import com.qweib.commons.page.PageRequest;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2019/5/21 - 16:01
 */
public interface TempProductRecordService {

    Integer save(TempProductRecordSave input, String database);

    Page<TempProductRecordDTO> page(TempProductRecordQuery query, PageRequest pageRequest, String database);
}
