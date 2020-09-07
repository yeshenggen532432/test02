package com.qweib.cloud.biz.system.controller.ws;

import com.qweib.cloud.biz.system.UserContext;
import com.qweib.cloud.biz.system.service.SysSalesmanService;
import com.qweib.cloud.core.domain.SysLoginInfo;
import com.qweib.cloud.core.domain.SysSalesman;
import com.qweibframework.commons.web.BaseController;
import com.qweibframework.commons.web.dto.Response;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.List;

/**
 * 业务员移动API
 */
@RestController
@RequestMapping("web/sys/salesman")
public class SalesmanApiController extends BaseController {

    @Autowired
    private SysSalesmanService sysSalesmanService;

    private String getTenant() {
        SysLoginInfo loginInfo = UserContext.getLoginInfo();
        return loginInfo.getDatasource();
    }

    @GetMapping
    public Response list() {
        List<SysSalesman> salesmanList = sysSalesmanService.queryList(null,getTenant());
        return success(salesmanList);
    }

    @GetMapping("{id}")
    public Response get(@PathVariable Integer id){
        SysSalesman salesman =  sysSalesmanService.queryById(id,getTenant());
        return success(salesman);
    }

    @PostMapping
    public Response save(@RequestBody @Valid SysSalesman salesman) {
        String tenant = getTenant();
        Integer id;
        if (salesman.getId() == null) {
            salesman.setStatus(1);
            id = this.sysSalesmanService.addData(salesman,getTenant());
        } else {
            id = salesman.getId();
            sysSalesmanService.updateData(salesman,tenant);
        }
        return success().data(id).message("保存成功");
    }

//    @DeleteMapping("{id}")
//    public Response remove(@PathVariable Integer id){
//        sysSalesmanService.deleteData(id,getTenant());
//        return success().message("删除成功");
//    }

    @GetMapping("update")
    public Response update(Integer id,Integer status){
        SysSalesman salesman =  sysSalesmanService.queryById(id,getTenant());
        salesman.setStatus(status);
        this.sysSalesmanService.updateData(salesman,getTenant());
        return success().message("状态更新成功");
    }

}
