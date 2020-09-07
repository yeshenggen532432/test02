package com.qweib.cloud.biz.system.service.common;

import com.qweib.cloud.biz.system.service.common.dto.snapshot.BillSnapshotDTO;
import com.qweib.cloud.biz.system.service.common.dto.snapshot.BillSnapshotDetailDTO;

import java.util.List;

/**
 * 单据快照
 * @author: jimmy.lin
 * @time: 2019/10/18 11:43
 * @description:
 */
public interface BillSnapshotService {

    void clear(String database, Integer userId, long timeBefore);

    String save(String database, BillSnapshotDTO snapshot);

    List<BillSnapshotDTO> list(String database, Integer userId, String billType, Integer billId);

    BillSnapshotDetailDTO get(String database, Integer userId, String id);

    Integer remove(String database, Integer userId, String id);
}
