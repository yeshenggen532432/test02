package com.qweib.cloud.biz.system.service.company;

import com.qweib.cloud.core.domain.product.*;
import com.qweib.commons.page.Page;
import com.qweib.commons.page.PageRequest;

import java.util.List;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2019/5/21 - 16:01
 */
public interface TempProductService {

    Integer saveBatch(List<TempProductSave> inputs, String database);

    Page<TempProductDTO> page(TempProductQuery query, PageRequest pageRequest, String database);

    TempProductDTO get(Integer id, String database);

    List<TempProductBaseDTO> getAllBaseProduct(Integer recordId, String database);

    boolean update(TempProductUpdate input, String database);

    void delete(List<Integer> ids, String database);
}
