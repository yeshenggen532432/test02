package com.qweib.cloud.biz.system.service.common.impl;

import com.google.common.collect.Lists;
import com.qweib.cloud.biz.system.service.common.QuerySolutionService;
import com.qweib.cloud.biz.system.service.common.dto.QuerySolutionDTO;
import com.qweib.cloud.biz.system.service.common.dto.QuerySolutionInput;
import com.qweib.cloud.biz.system.service.common.dto.QuerySolutionItemDTO;
import com.qweib.cloud.core.domain.settings.query.QuerySolution;
import com.qweib.cloud.core.domain.settings.query.SolutionItem;
import com.qweib.cloud.repository.common.QuerySolutionRepository;
import com.qweib.cloud.utils.Collections3;
import com.qweib.commons.mapper.BeanMapper;
import org.dozer.Mapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

/**
 * @author: jimmy.lin
 * @time: 2019/8/10 12:01
 * @description:
 */
@Service
public class QuerySolutionServiceImpl implements QuerySolutionService {
    @Autowired
    private QuerySolutionRepository repository;
    @Autowired
    private Mapper dozer;

    @Override
    public Integer addSolution(QuerySolutionInput solution, Integer creatorId, String database) {
        QuerySolution entity = dozer.map(solution, QuerySolution.class);
        entity.setCreateTime(new Date());
        entity.setCreatorId(creatorId);
        Integer solutionId = repository.save(entity, database);
        List<QuerySolutionItemDTO> items = solution.getItems();
        if (Collections3.isNotEmpty(items)) {
            List<SolutionItem> itemList = items.stream().map(i -> {
                SolutionItem item = dozer.map(i, SolutionItem.class);
                item.setSolutionId(solutionId);
                return item;
            }).collect(Collectors.toList());
            repository.saveItems(itemList, database);
        }
        return solutionId;
    }

    @Override
    public List<QuerySolutionDTO> listByNamespace(String namespace, String database, Integer userId) {
        List<QuerySolution> solutions = repository.list(database, namespace, userId);
        if (Collections3.isNotEmpty(solutions)) {
            return BeanMapper.mapList(solutions, QuerySolutionDTO.class, dozer);
        }
        return Lists.newArrayList();
    }

    @Override
    public List<QuerySolutionItemDTO> listItemsBySolutionId(String database, Integer solutionId) {
        List<SolutionItem> items = repository.getItemsBySolutionId(solutionId, database);
        if (Collections3.isNotEmpty(items)) {
            return BeanMapper.mapList(items, QuerySolutionItemDTO.class);
        }
        return Lists.newArrayList();
    }

    @Override
    public void remove(String database, Integer id) {
        repository.remove(id, database);
        repository.removeItemsBySolutionId(id, database);
    }
}
