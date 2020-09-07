package com.qweib.cloud.biz.system.service.common;

import com.qweib.cloud.biz.system.service.common.dto.QuerySolutionDTO;
import com.qweib.cloud.biz.system.service.common.dto.QuerySolutionInput;
import com.qweib.cloud.biz.system.service.common.dto.QuerySolutionItemDTO;

import java.util.List;

/**
 * @author: jimmy.lin
 * @time: 2019/8/10 12:01
 * @description:
 */
public interface QuerySolutionService {

    Integer addSolution(QuerySolutionInput solution, Integer creatorId, String database);

    List<QuerySolutionDTO> listByNamespace(String namespace, String database, Integer userId);

    List<QuerySolutionItemDTO> listItemsBySolutionId(String database, Integer solutionId);

    void remove(String database, Integer id);

}
