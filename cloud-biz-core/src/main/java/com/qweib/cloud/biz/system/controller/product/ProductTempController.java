package com.qweib.cloud.biz.system.controller.product;

import com.qweib.cloud.biz.common.GeneralControl;
import com.qweib.cloud.biz.common.Response;
import com.qweib.cloud.biz.system.service.company.TempProductService;
import com.qweib.cloud.core.domain.SysLoginInfo;
import com.qweib.cloud.core.domain.product.TempProductDTO;
import com.qweib.cloud.core.domain.product.TempProductQuery;
import com.qweib.cloud.core.domain.product.TempProductUpdate;
import com.qweib.commons.MathUtils;
import com.qweib.commons.page.Page;
import com.qweib.commons.page.PageRequest;
import com.qweib.commons.page.SpringPageUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Pageable;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2019/5/22 - 11:08
 */
@RequestMapping("/manager/company/product/temp")
@RestController
public class ProductTempController extends GeneralControl {

    @Autowired
    private TempProductService productService;

    @GetMapping("productPage")
    public Map page(TempProductQuery query, Pageable pageable, HttpServletRequest request) {
        Map<String, Object> json = new HashMap<>();
        if (!MathUtils.valid(query.getRecordId())) {
            json.put("state1", false);
            json.put("message", "请选择导入记录查询");
            return json;
        }
        final SysLoginInfo currentUser = getLoginInfo(request);
        Page<TempProductDTO> page = this.productService.page(query, new PageRequest(pageable.getPageNumber() - 1, pageable.getPageSize()), currentUser.getDatasource());
        json.put("state1", true);
        json.put("total", page.getTotalCount());
        json.put("rows", page.getData());
        return json;
    }

    @PutMapping("{id}")
    public Response update(@PathVariable("id") Integer id, @RequestBody TempProductUpdate input, HttpServletRequest request) {
        final SysLoginInfo currentUser = getLoginInfo(request);
        input.setId(id);
        input.setUpdatedBy(currentUser.getIdKey());

        boolean result = this.productService.update(input, currentUser.getDatasource());
        if (result) {
            return Response.createSuccess().setMessage("更新成功");
        } else {
            return Response.createError("更新失败");
        }
    }

    @DeleteMapping("batch")
    public Response deleteBatch(@RequestBody List<Integer> ids, HttpServletRequest request) {
        final SysLoginInfo currentUser = getLoginInfo(request);

        this.productService.delete(ids, currentUser.getDatasource());

        return Response.createSuccess().setMessage("删除成功");
    }
}
