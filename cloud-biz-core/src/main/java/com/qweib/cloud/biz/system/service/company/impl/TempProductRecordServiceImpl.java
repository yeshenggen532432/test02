package com.qweib.cloud.biz.system.service.company.impl;

import com.qweib.cloud.biz.system.service.company.TempProductRecordService;
import com.qweib.cloud.core.domain.product.TempProductRecordDTO;
import com.qweib.cloud.core.domain.product.TempProductRecordQuery;
import com.qweib.cloud.core.domain.product.TempProductRecordSave;
import com.qweib.cloud.repository.company.TempProductRecordDao;
import com.qweib.commons.page.Page;
import com.qweib.commons.page.PageRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2019/5/21 - 16:05
 */
@Service
public class TempProductRecordServiceImpl implements TempProductRecordService {

    @Autowired
    private TempProductRecordDao recordDao;

    @Override
    public Integer save(TempProductRecordSave input, String database) {
        return recordDao.save(input, database);
    }

    @Override
    public Page<TempProductRecordDTO> page(TempProductRecordQuery query, PageRequest pageRequest, String database) {
        return recordDao.page(query, pageRequest, database);
    }

}
