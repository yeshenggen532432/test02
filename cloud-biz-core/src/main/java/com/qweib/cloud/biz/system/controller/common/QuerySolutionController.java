package com.qweib.cloud.biz.system.controller.common;

import com.qweib.cloud.biz.system.UserContext;
import com.qweib.cloud.biz.system.service.common.QuerySolutionService;
import com.qweib.cloud.biz.system.service.common.dto.QuerySolutionInput;
import com.qweib.cloud.core.domain.SysLoginInfo;
import com.qweibframework.commons.web.BaseController;
import com.qweibframework.commons.web.dto.Response;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;

/**
 * 查询方案
 *
 * @author: jimmy.lin
 * @time: 2019/8/8 20:55
 * @description: 列表页通用查询方案接口
 */
@RequestMapping("manager/common/querysolution")
@RestController
public class QuerySolutionController extends BaseController {
    @Autowired
    private QuerySolutionService querySolutionService;

    /**
     * 获取查询方案列表
     *
     * @param namespace
     * @return
     */
    @GetMapping("{namespace}")
    public Response list(@PathVariable String namespace) {
        SysLoginInfo info = UserContext.getLoginInfo();
        return success(querySolutionService.listByNamespace(namespace, info.getDatasource(), info.getIdKey()));
    }

    /**
     * 保存查询方案
     *
     * @param namespace
     * @return
     */
    @PostMapping("{namespace}")
    public Response save(@RequestBody @Valid QuerySolutionInput solution, @PathVariable String namespace) {
        solution.setNamespace(namespace);
        SysLoginInfo info = UserContext.getLoginInfo();
        return success(querySolutionService.addSolution(solution, info.getIdKey(), info.getDatasource())).message("保存成功");
    }

    @GetMapping("{namespace}/{id}")
    public Response get(@PathVariable String namespace, @PathVariable Integer id) {
        SysLoginInfo info = UserContext.getLoginInfo();
        return success(querySolutionService.listItemsBySolutionId(info.getDatasource(), id));
    }

    /**
     * 删除查询方案
     *
     * @param namespace
     * @param id
     * @return
     */
    @DeleteMapping("{namespace}/{id}")
    public Response remove(@PathVariable String namespace, @PathVariable Integer id) {
        SysLoginInfo info = UserContext.getLoginInfo();
        querySolutionService.remove(info.getDatasource(), id);
        return success().message("删除成功");
    }

}
