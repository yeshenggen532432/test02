package com.qweib.cloud.biz.system.controller.common;

import com.qweib.cloud.biz.system.UserContext;
import com.qweib.cloud.biz.system.service.common.BillConfigService;
import com.qweib.cloud.biz.system.service.common.dto.BillConfigInput;
import com.qweib.cloud.core.domain.SysLoginInfo;
import com.qweibframework.commons.web.BaseController;
import com.qweibframework.commons.web.dto.Response;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;

/**
 * @author: jimmy.lin
 * @time: 2019/8/10 12:05
 * @description:
 */
@RequestMapping("manager/common/bill/config")
@RestController
public class BillConfigController extends BaseController {
    @Autowired
    private BillConfigService billConfigService;

    @GetMapping("{namespace}")
    public Response get(@PathVariable String namespace) {
        SysLoginInfo info = UserContext.getLoginInfo();
        return success(billConfigService.findByNamespace(namespace, info.getDatasource())).message("保存成功");
    }

    /**
     * 差量更新
     *
     * @param config
     * @return
     */
    @PutMapping("{namespace}")
    public Response update(@RequestBody BillConfigInput config, @PathVariable String namespace) {
        SysLoginInfo info = UserContext.getLoginInfo();
        config.setNamespace(namespace);
        billConfigService.update(config, info.getDatasource());
        return success().message("保存成功");
    }

    @PostMapping("{namespace}")
    public Response save(@Valid @RequestBody BillConfigInput config, @PathVariable String namespace) {
        SysLoginInfo info = UserContext.getLoginInfo();
        config.setNamespace(namespace);
        return success(billConfigService.save(config, info.getDatasource()));
    }

    @DeleteMapping("{namespace}")
    public Response reset(@PathVariable String namespace) {
        SysLoginInfo info = UserContext.getLoginInfo();
        billConfigService.flush(info.getDatasource(), namespace);
        return success().message("重置成功");
    }
}
