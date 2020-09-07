package com.qweib.cloud.biz.system.controller.ws;

import com.qweib.cloud.biz.system.UserContext;
import com.qweib.cloud.biz.system.service.SysQdtypeService;
import com.qweib.cloud.core.domain.SysLoginInfo;
import com.qweib.cloud.core.domain.SysQdtype;
import com.qweibframework.commons.web.BaseController;
import com.qweibframework.commons.web.dto.Response;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.List;

/**
 * 客户类别移动API
 */
@RestController
@RequestMapping("web/sys/customertype")
public class CustomertypeApiController extends BaseController {

    @Autowired
    private SysQdtypeService sysQdtypeService;

    private String getTenant() {
        SysLoginInfo loginInfo = UserContext.getLoginInfo();
        return loginInfo.getDatasource();
    }

    @GetMapping
    public Response list() {
        List<SysQdtype> customertypes = sysQdtypeService.queryList(null,getTenant());
        return success(customertypes);
    }

    @GetMapping("{id}")
    public Response get(@PathVariable Integer id){
        SysQdtype type = this.sysQdtypeService.queryQdtypeById(id,getTenant());
        return success(type);
    }

    @PostMapping
    public Response save(@RequestBody @Valid SysQdtype customertype) {
        String tenant = getTenant();
        Integer id;
        if (customertype.getId() == null) {
            id = this.sysQdtypeService.addQdtype(customertype,tenant);
        } else {
            id = customertype.getId();
            sysQdtypeService.updateQdtype(customertype,tenant);
        }
        return success().data(id).message("保存成功");
    }

    @DeleteMapping("{id}")
    public Response remove(@PathVariable Integer id){
        sysQdtypeService.deleteQdtypeById(id,getTenant());
        return success().message("删除成功");
    }

}
