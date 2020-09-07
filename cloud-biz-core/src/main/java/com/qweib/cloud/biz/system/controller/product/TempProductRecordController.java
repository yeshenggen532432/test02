package com.qweib.cloud.biz.system.controller.product;

import com.qweib.cloud.biz.common.FileUtils;
import com.qweib.cloud.biz.common.GeneralControl;
import com.qweib.cloud.biz.common.Response;
import com.qweib.cloud.biz.system.controller.product.excel.TempProductEventListener;
import com.qweib.cloud.biz.system.controller.product.excel.TempProductModelExecutor;
import com.qweib.cloud.biz.system.service.SysWaresService;
import com.qweib.cloud.biz.system.service.SysWaretypeService;
import com.qweib.cloud.biz.system.service.company.TempProductRecordService;
import com.qweib.cloud.biz.system.service.company.TempProductService;
import com.qweib.cloud.biz.system.service.ruleengine.RuleEngineService;
import com.qweib.cloud.biz.system.utils.TempProductExecutor;
import com.qweib.cloud.core.domain.SysLoginInfo;
import com.qweib.cloud.core.domain.product.*;
import com.qweib.cloud.utils.Collections3;
import com.qweib.commons.page.Page;
import com.qweib.commons.page.PageRequest;
import com.qweibframework.commons.DateUtils;
import com.qweibframework.commons.MathUtils;
import com.qweibframework.commons.StringUtils;
import com.qweibframework.commons.zookeeper.lock.ZkLock;
import com.qweibframework.commons.zookeeper.lock.ZkLockTemplate;
import com.qweibframework.excel.ExcelFactory;
import com.qweibframework.excel.message.ErrorMessage;
import org.dozer.Mapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2019/5/21 - 16:08
 */
@RequestMapping("/manager/company/product/temp_record")
@Controller
public class TempProductRecordController extends GeneralControl {

    @Autowired
    private TempProductRecordService recordService;
    @Autowired
    private TempProductService tempProductService;
    @Autowired
    private RuleEngineService ruleEngineService;
    @Autowired
    private SysWaretypeService productTypeService;
    @Autowired
    private SysWaresService productService;
    @Autowired
    private ZkLockTemplate lockTemplate;
    @Autowired
    private Mapper mapper;

    @GetMapping("index")
    public String index() {
        return "uglcw/ware/temp/index";
    }

    /**
     * 产品数据导入到临时产品表
     * @param uploadFile
     * @param recordId
     * @param request
     * @return
     */
    @ResponseBody
    @PostMapping("import_data")
    public Response uploadProduct(MultipartFile uploadFile,
                                  @RequestParam(value = "record_id", required = false) Integer recordId,
                                  HttpServletRequest request) {
        File importFile = FileUtils.copyFile(uploadFile, request);
        final SysLoginInfo currentUser = getLoginInfo(request);
        ZkLock lock = this.lockTemplate.getLock("cloud:product:temp_product:" + currentUser.getFdCompanyId());
        boolean acquire = lock.acquire(1, TimeUnit.SECONDS);
        if (acquire) {
            try {
                final String database = currentUser.getDatasource();
                if (!MathUtils.valid(recordId)) {
                    TempProductRecordSave input = new TempProductRecordSave();
                    input.setTitle(DateUtils.getDateTime() + " 商品信息导入");
                    input.setCreatedBy(currentUser.getIdKey());
                    recordId = this.recordService.save(input, database);
                }

                TempProductModelExecutor modelExecutor =
                        new TempProductModelExecutor(database, currentUser.getIdKey(), recordId, tempProductService, ruleEngineService, mapper);
                TempProductEventListener eventListener = new TempProductEventListener(modelExecutor);

                try {
                    ExcelFactory.read(new FileInputStream(importFile), 1, eventListener);
                } catch (IOException e) {
                    e.printStackTrace();
                }

                List<ErrorMessage> errors = eventListener.getErrors();
                int repeatCount = modelExecutor.getRepeatCount();
                String repeatMessage = StringUtils.EMPTY;
                if (repeatCount > 0) {
                    repeatMessage = "，有 " + repeatCount + " 条重复数据";
                }
                if (Collections3.isNotEmpty(errors)) {
                    return Response.createError("有部分数据导入出错" + repeatMessage).setData(errors);
                } else {
                    return Response.createSuccess().setMessage("导入成功" + repeatMessage);
                }
            } finally {
                lock.release();
                if (importFile.exists()) {
                    importFile.delete();
                }
            }
        } else {
            return Response.createError("已有其他人员在处理中，请稍等");
        }
    }

    @ResponseBody
    @GetMapping("productRecordPage")
    public Map page(TempProductRecordQuery query, Pageable pageable, HttpServletRequest request, HttpServletResponse response) {
        final SysLoginInfo currentUser = getLoginInfo(request);
        Page<TempProductRecordDTO> page = this.recordService.page(query, new PageRequest(pageable.getPageNumber() - 1, pageable.getPageSize()), currentUser.getDatasource());
        Map<String, Object> json = new HashMap<>();
        json.put("total", page.getTotalCount());
        json.put("rows", page.getData());
        return json;
    }

    @RequestMapping("toProductRecordSubPage")
    public String toProductRecordSubPage(HttpServletRequest request){
        String recordId = request.getParameter("recordId");
        request.setAttribute("recordId",recordId);
        return "/uglcw/import/sys_ware_arrange_import_sub_page";
    }

    @PostMapping("import_to_db")
    public Response importToDb(@RequestParam Integer recordId, HttpServletRequest request) {
        final SysLoginInfo currentUser = getLoginInfo(request);

        if (MathUtils.valid(recordId)) {
            ZkLock lock = this.lockTemplate.getLock("cloud:product:temp_product:" + currentUser.getFdCompanyId());
            boolean acquire = lock.acquire(1, TimeUnit.SECONDS);
            if (acquire) {
                try {
                    this.saveProductToDb(recordId, currentUser.getDatasource());
                } finally {
                    lock.release();
                }
            } else {
                return Response.createError("已有其他人员在处理中，请稍等");
            }

            return Response.createSuccess().setMessage("导入成功");
        } else {
            return Response.createError("请选择有效的记录提交");
        }
    }

    private void saveProductToDb(Integer id, String database) {
        TempProductQuery query = new TempProductQuery();
        query.setRecordId(id);
        PageRequest pageRequest = new PageRequest(0, 100);
        Page<TempProductDTO> page = tempProductService.page(query, pageRequest, database);

        if (com.qweib.commons.Collections3.isEmpty(page.getData())) {
            return;
        }

        TempProductExecutor productExecutor = new TempProductExecutor(database, "/", productTypeService, productService);
        productExecutor.initialData();

        // 处理第一页
        saveBatchProduct(productExecutor, page.getData());

        final int totalPages = page.getTotalPages();
        for (int pageNo = 1; pageNo < totalPages; pageNo++) {
            pageRequest.setPage(pageNo);
            page = tempProductService.page(query, pageRequest, database);
            saveBatchProduct(productExecutor, page.getData());
        }
    }

    private void saveBatchProduct(TempProductExecutor productExecutor, List<TempProductDTO> list) {
        if (Collections3.isEmpty(list)) {
            return;
        }

        for (TempProductDTO productDTO : list) {
            productExecutor.getProduct(productDTO.getCategoryName(), productDTO.getProductName(), productDTO);
        }
    }
}
