package com.qweib.cloud.biz.system.service.common.impl;

import com.google.common.collect.Lists;
import com.google.common.collect.Sets;
import com.qweib.cloud.biz.system.service.common.BillConfigService;
import com.qweib.cloud.biz.system.service.common.dto.BillConfigDTO;
import com.qweib.cloud.biz.system.service.common.dto.BillConfigInput;
import com.qweib.cloud.biz.system.service.common.dto.BillConfigItemDTO;
import com.qweib.cloud.core.domain.settings.bill.BillConfig;
import com.qweib.cloud.core.domain.settings.bill.BillConfigItem;
import com.qweib.cloud.repository.common.BillConfigRepository;
import com.qweib.commons.Collections3;
import org.dozer.Mapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Comparator;
import java.util.List;
import java.util.Objects;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * @author: jimmy.lin
 * @time: 2019/8/10 12:03
 * @description:
 */
@Service
public class BillConfigServiceImpl implements BillConfigService {
    @Autowired
    private BillConfigRepository billConfigRepository;
    @Autowired
    private Mapper dozer;

    @Override
    public BillConfigDTO findByNamespace(String namespace, String database) {
        BillConfig config = billConfigRepository.getByNamespace(database, namespace);
        if (config == null) {
            return null;
        }
        BillConfigDTO dto = dozer.map(config, BillConfigDTO.class);
        List<BillConfigItem> items = billConfigRepository.listItemsByNamespace(database, namespace);
        if (Collections3.isNotEmpty(items)) {
            List<BillConfigItemDTO> master = Lists.newArrayList();
            List<BillConfigItemDTO> slave = Lists.newArrayList();
            List<BillConfigItemDTO> other = Lists.newArrayList();
            for (BillConfigItem item : items) {
                BillConfigItemDTO itemDTO = dozer.map(item, BillConfigItemDTO.class);
                if (Objects.equals(0, item.getType())) {
                    master.add(itemDTO);
                } else if (Objects.equals(1, item.getType())) {
                    slave.add(itemDTO);
                } else if (Objects.equals(2, item.getType())) {
                    other.add(itemDTO);
                }
            }
            //排序
            master.sort(Comparator.comparingInt(BillConfigItemDTO::getSort));
            slave.sort(Comparator.comparingInt(BillConfigItemDTO::getSort));
            dto.setMaster(master);
            dto.setSlave(slave);
            dto.setOther(other);
        }
        return dto;
    }

    @Override
    public Integer save(BillConfigInput config, String database) {
        BillConfig entity = billConfigRepository.getByNamespace(database, config.getNamespace());
        if (entity == null) {
            entity = new BillConfig();
            entity.setNamespace(config.getNamespace());
            Integer id = billConfigRepository.save(database, entity);
            entity.setId(id);
        } else {
            billConfigRepository.removeItems(database, entity.getId());
        }
        final Integer configId = entity.getId();
        List<BillConfigItemDTO> items = config.getItems();
        if (Collections3.isNotEmpty(items)) {
            List<BillConfigItem> itemList = items.stream().map(
                    it -> {
                        BillConfigItem item = dozer.map(it, BillConfigItem.class);
                        item.setConfigId(configId);
                        return item;
                    }
            ).collect(Collectors.toList());
            billConfigRepository.saveItems(database, itemList);
        }
        return configId;
    }

    @Override
    public void flush(String datasource, String namespace) {
        BillConfig entity = billConfigRepository.getByNamespace(datasource, namespace);
        if (entity != null) {
            billConfigRepository.removeItems(datasource, entity.getId());
        }
    }

    @Override
    public void update(BillConfigInput config, String database) {
        BillConfig entity = billConfigRepository.getByNamespace(database, config.getNamespace());
        if (entity != null) {
            List<BillConfigItemDTO> items = config.getItems();
            List<BillConfigItem> addList = Lists.newArrayList();
            List<BillConfigItem> updateList = Lists.newArrayList();
            Set<String> fields = Sets.newHashSet();
            if (Collections3.isNotEmpty(items)) {
                for (BillConfigItemDTO item : items) {
                    String key = item.getField()+item.getType();
                    if(fields.contains(key)){
                        break;
                    }
                    fields.add(key);
                    BillConfigItem itemEntity = dozer.map(item, BillConfigItem.class);
                    itemEntity.setConfigId(entity.getId());
                    if (null == itemEntity.getId()) {
                        addList.add(itemEntity);
                    } else {
                        updateList.add(itemEntity);
                    }
                }
                billConfigRepository.saveItems(database, addList);
                billConfigRepository.updateItems(database, updateList);
            }

        }

    }
}
