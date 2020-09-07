package com.qweib.cloud.biz.system.controller.ws;

import com.qweib.cloud.biz.system.UserContext;
import com.qweib.cloud.biz.system.service.SysKhlevelService;
import com.qweib.cloud.core.domain.SysKhlevel;
import com.qweib.cloud.core.domain.SysLoginInfo;
import com.qweibframework.commons.web.BaseController;
import com.qweibframework.commons.web.dto.Response;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.List;

/**
 * 客户等级移动API
 */
@RestController
@RequestMapping("web/sys/customerlevel")
public class CustomerlevelApiController extends BaseController {

    @Autowired
    private SysKhlevelService sysKhlevelService;

    private String getTenant() {
        SysLoginInfo loginInfo = UserContext.getLoginInfo();
        return loginInfo.getDatasource();
    }

    @GetMapping
    public Response list() {
        List<SysKhlevel> customerLevels = sysKhlevelService.queryList(null,getTenant());
        return success(customerLevels);
    }

    @GetMapping("{id}")
    public Response get(@PathVariable Integer id){
        SysKhlevel level = this.sysKhlevelService.querykhlevelById(id,getTenant());
        return success(level);
    }

    @PostMapping
    public Response save(@RequestBody @Valid SysKhlevel customerlevel) {
        String tenant = getTenant();
        Integer id;
        if (customerlevel.getId() == null) {
            id = this.sysKhlevelService.addkhlevel(customerlevel,tenant);
        } else {
            id = customerlevel.getId();
            sysKhlevelService.updatekhlevel(customerlevel,tenant);
        }
        return success().data(id).message("保存成功");
    }

    @DeleteMapping("{id}")
    public Response remove(@PathVariable Integer id){
        sysKhlevelService.deletekhlevelById(id,getTenant());
        return success().message("删除成功");
    }

}
