package com.qweib.cloud.biz.system.controller.ws;

import com.qweib.cloud.biz.system.UserContext;
import com.qweib.cloud.biz.system.service.SysWaretypeService;
import com.qweib.cloud.core.domain.SysLoginInfo;
import com.qweib.cloud.core.domain.SysWaretype;
import com.qweibframework.commons.web.BaseController;
import com.qweibframework.commons.web.dto.Response;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.List;

/**
 * 商品类别移动API
 */
@RestController
@RequestMapping("web/sys/waretype")
public class SysWareTypeApiController extends BaseController {

    @Autowired
    private SysWaretypeService sysWaretypeService;

    private String getTenant() {
        SysLoginInfo loginInfo = UserContext.getLoginInfo();
        return loginInfo.getDatasource();
    }

    @GetMapping
    public Response list(SysWaretype type) {
        List<SysWaretype> waretypes = sysWaretypeService.queryWaretype(type,getTenant());
        if(waretypes!=null){
            String upName = "无";
            if(type!=null&&type.getWaretypeId()>0){
                SysWaretype parentType = this.sysWaretypeService.queryWaretypeById(type.getWaretypeId(),getTenant());
                upName = parentType.getWaretypeNm();
            }
            for(int i=0;i<waretypes.size();i++){
                SysWaretype waretype = waretypes.get(i);
                waretype.setUpWaretypeNm(upName);
            }


        }

        return success(waretypes);
    }

    @GetMapping("{id}")
    public Response get(@PathVariable Integer id){
        SysWaretype type = this.sysWaretypeService.queryWaretypeById(id,getTenant());
        return success(type);
    }

    @PostMapping
    public Response save(@RequestBody @Valid SysWaretype waretype) {
        String tenant = getTenant();
        Integer id;
        if (waretype.getWaretypeId() == null) {
            id = this.sysWaretypeService.addWaretype(waretype,tenant);
        } else {
            id = waretype.getWaretypeId();
            sysWaretypeService.updateWaretype(waretype,null,tenant);
        }
        return success().data(id).message("保存成功");
    }

    @DeleteMapping("{id}")
    public Response remove(@PathVariable Integer id){
        SysWaretype type = this.sysWaretypeService.queryWaretypeById(id,getTenant());
        sysWaretypeService.deleteWaretype(type,getTenant());
        return success().message("删除成功");
    }

}
