package com.qweib.cloud.biz.system.controller.common;

import com.qweib.cloud.biz.system.UserContext;
import com.qweib.cloud.biz.system.service.common.BillSnapshotService;
import com.qweib.cloud.biz.system.service.common.dto.snapshot.BillSnapshotDetailDTO;
import com.qweib.cloud.biz.system.service.common.dto.snapshot.SnapshotRequest;
import com.qweib.cloud.core.domain.SysLoginInfo;
import com.qweib.commons.mapper.JsonMapper;
import com.qweibframework.commons.web.BaseController;
import com.qweibframework.commons.web.dto.Response;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.concurrent.TimeUnit;

/**
 * @author: jimmy.lin
 * @time: 2019/10/18 11:42
 * @description:
 */
@RestController
@RequestMapping("manager/common/bill/snapshot")
public class BillSnapshotController extends BaseController {

    @Autowired
    private BillSnapshotService snapshotService;

    @GetMapping
    public Response list(@RequestParam String billType, @RequestParam(required = false) Integer billId) {
        SysLoginInfo principal = UserContext.getLoginInfo();
        long diff = System.currentTimeMillis() - TimeUnit.DAYS.toMillis(1);
        snapshotService.clear(principal.getDatasource(), principal.getIdKey(), diff);
        return success(snapshotService.list(principal.getDatasource(), principal.getIdKey(), billType, billId));
    }

    @GetMapping("{id}")
    public Response get(@PathVariable String id) {
        SysLoginInfo principal = UserContext.getLoginInfo();
        return success(snapshotService.get(principal.getDatasource(), principal.getIdKey(), id));
    }

    @PostMapping
    public Response save(@RequestBody SnapshotRequest snapshot) {
        SysLoginInfo principal = UserContext.getLoginInfo();
        BillSnapshotDetailDTO dto = new BillSnapshotDetailDTO();
        dto.setUserId(principal.getIdKey());
        dto.setId(snapshot.getId());
        dto.setBillId(snapshot.getBillId());
        dto.setTitle(snapshot.getTitle());
        dto.setBillType(snapshot.getBillType());
        if (snapshot.getData() != null) {
            dto.setData(JsonMapper.toJsonString(snapshot.getData()));
        }
        return success(snapshotService.save(principal.getDatasource(), dto));
    }

    @DeleteMapping("{id}")
    public Response remove(@PathVariable String id) {
        SysLoginInfo principal = UserContext.getLoginInfo();
        return success(snapshotService.remove(principal.getDatasource(), principal.getIdKey(), id));
    }


}
