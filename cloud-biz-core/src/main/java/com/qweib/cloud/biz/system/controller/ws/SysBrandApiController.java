package com.qweib.cloud.biz.system.controller.ws;

import com.qweib.cloud.biz.system.UserContext;
import com.qweib.cloud.core.domain.SysBrand;
import com.qweib.cloud.biz.system.service.SysBrandService;
import com.qweib.cloud.core.domain.SysLoginInfo;
import com.qweibframework.commons.web.BaseController;
import com.qweibframework.commons.web.dto.Response;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.List;

/**
 * 商品品牌移动API
 */
@RestController
@RequestMapping("web/sys/brand")
public class SysBrandApiController extends BaseController {

    @Autowired
    private SysBrandService sysBrandService;

    private String getTenant() {
        SysLoginInfo loginInfo = UserContext.getLoginInfo();
        return loginInfo.getDatasource();
    }

    @GetMapping
    public Response list() {
        List<SysBrand> brands = sysBrandService.queryList(null,getTenant());
        return success(brands);
    }

    @GetMapping("{id}")
    public Response get(@PathVariable Integer id){
        SysBrand brand = this.sysBrandService.queryBrandById(id,getTenant());
        return success(brand);
    }

    @PostMapping
    public Response save(@RequestBody @Valid SysBrand sysBrand) {
        String tenant = getTenant();
        Integer id;
        if (sysBrand.getId() == null) {
            id = this.sysBrandService.addBrand(sysBrand,tenant);
        } else {
            id = sysBrand.getId();
            sysBrandService.updateBrand(sysBrand,tenant);
        }
        return success().data(id).message("保存成功");
    }

    @DeleteMapping("{id}")
    public Response remove(@PathVariable Integer id){
        sysBrandService.deleteBrandById(id,getTenant());
        return success().message("删除成功");
    }

}
