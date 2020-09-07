package com.qweib.cloud.biz.system.service.common.impl;

import com.qweib.cloud.biz.system.service.common.BillSnapshotService;
import com.qweib.cloud.biz.system.service.common.dto.snapshot.BillSnapshotDTO;
import com.qweib.cloud.biz.system.service.common.dto.snapshot.BillSnapshotDetailDTO;
import com.qweib.cloud.core.domain.common.BillSnapshot;
import com.qweib.cloud.repository.common.BillSnapshotRepository;
import com.qweib.commons.Identities;
import com.qweib.commons.StringUtils;
import com.qweib.commons.exceptions.NotFoundException;
import com.qweib.commons.mapper.BeanMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

/**
 * @author: jimmy.lin
 * @time: 2019/10/18 16:19
 * @description:
 */
@Service
public class BillSnapshotServiceImpl implements BillSnapshotService {

    @Autowired
    private BillSnapshotRepository snapshotRepository;

    @Override
    public void clear(String database, Integer userId, long timeBefore) {
        snapshotRepository.removeSnapshotBefore(database, userId, timeBefore);
    }

    @Override
    public String save(String database, BillSnapshotDTO snapshot) {
        BillSnapshot entity = BeanMapper.map(snapshot, BillSnapshot.class);
        long now = System.currentTimeMillis();
        entity.setUpdateTime(now);
        if (StringUtils.isNotBlank(entity.getId())) {
            snapshotRepository.update(database, entity);
        } else {
            entity.setCreateTime(now);
            entity.setId(Identities.uuid());
            snapshotRepository.save(database, entity);
        }
        return entity.getId();
    }

    @Override
    public List<BillSnapshotDTO> list(String database, Integer userId, String billType, Integer billId) {
        return snapshotRepository.list(database, userId, billType, billId)
                .stream()
                .map(entity -> BeanMapper.map(entity, BillSnapshotDTO.class)).collect(Collectors.toList());
    }

    @Override
    public BillSnapshotDetailDTO get(String database, Integer userId, String id) {
        BillSnapshot snapshot = snapshotRepository.get(database, userId, id);
        if (snapshot == null) {
            throw new NotFoundException();
        }
        return BeanMapper.map(snapshot, BillSnapshotDetailDTO.class);
    }

    @Override
    public Integer remove(String database, Integer userId, String id) {
        return snapshotRepository.removeById(database, userId, id);
    }
}
