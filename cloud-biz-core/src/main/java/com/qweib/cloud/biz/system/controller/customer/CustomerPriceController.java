package com.qweib.cloud.biz.system.controller.customer;

import com.google.common.collect.Maps;
import com.qweib.cloud.biz.common.FileUtils;
import com.qweib.cloud.biz.common.GeneralControl;
import com.qweib.cloud.biz.common.Response;
import com.qweib.cloud.biz.system.controller.customer.price.CustomerPriceEventListener;
import com.qweib.cloud.biz.system.controller.customer.price.CustomerPriceModelExecutor;
import com.qweib.cloud.biz.system.controller.customer.price.domain.CustomerPriceModel;
import com.qweib.cloud.biz.system.controller.customer.price.domain.CustomerPriceModelVo;
import com.qweib.cloud.biz.system.controller.plat.vo.importVo.ImportCustomerPriceVo;
import com.qweib.cloud.biz.system.controller.plat.vo.importVo.ImportTitleVo;
import com.qweib.cloud.biz.system.controller.plat.vo.importVo.ImportTypeBean;
import com.qweib.cloud.biz.system.service.*;
import com.qweib.cloud.biz.system.service.customer.CustomerPriceService;
import com.qweib.cloud.core.domain.SysImportTemp;
import com.qweib.cloud.core.domain.SysLoginInfo;
import com.qweib.cloud.utils.Collections3;
import com.qweib.cloud.utils.StrUtil;
import com.qweibframework.async.handler.AsyncProcessHandler;
import com.qweibframework.commons.StringUtils;
import com.qweibframework.commons.zookeeper.lock.ZkLock;
import com.qweibframework.commons.zookeeper.lock.ZkLockTemplate;
import com.qweibframework.excel.ExcelFactory;
import com.qweibframework.excel.event.ModelExecutor;
import com.qweibframework.excel.message.ErrorMessage;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.annotation.Resource;
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
 * Created on 2019/4/22 - 17:48
 */
@Controller
@RequestMapping("manager/customer/price")
public class CustomerPriceController extends GeneralControl {

    @Autowired
    private SysWaretypeService productTypeService;
    @Autowired
    private SysWaresService productService;
    @Autowired
    private SysCustomerService customerService;
    @Autowired
    private CustomerPriceService customerPriceService;
    @Autowired
    private ZkLockTemplate lockTemplate;
    @Resource
    private SysInportTempService sysInportTempService;
    @Resource
    private SysWareService wareService;
    @Resource
    private AsyncProcessHandler asyncProcessHandler;

    /**
     * 客户价格批量导入
     *
     * @param uploadFile
     * @param request
     * @return
     */
    @ResponseBody
    @PostMapping("import_data")
    public Response uploadCustomerPrice(MultipartFile uploadFile, HttpServletRequest request) {
        final SysLoginInfo currentUser = getLoginInfo(request);

        File importFile = FileUtils.copyFile(uploadFile, request);

        ZkLock lock = this.lockTemplate.getLock("cloud:customer:price:" + currentUser.getFdCompanyId());
        boolean acquire = lock.acquire(1, TimeUnit.SECONDS);
        if (acquire) {
            try {
                ModelExecutor<CustomerPriceModel> modelExecutor = new CustomerPriceModelExecutor(currentUser.getDatasource(), customerService,
                        productTypeService, productService, customerPriceService, currentUser.getIdKey());
                CustomerPriceEventListener eventListener = new CustomerPriceEventListener(modelExecutor);
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


    /**
     * 客户价格批量导入 zzx
     *
     * @param request
     * @return
     */
    @ResponseBody
    @RequestMapping("/import_data_new")
    public Map<String, Object> import_data_new(HttpServletRequest request, HttpServletResponse response) {
        Map<String, Object> map = new HashMap<>();
        map.put("state", false);
        map.put("msg", "操作失败");
        final SysLoginInfo currentUser = getLoginInfo(request);
        ZkLock lock = null;
        try {
            long st = System.currentTimeMillis();
            lock = this.lockTemplate.getLock("cloud:customer:price:import:" + currentUser.getFdCompanyId());
            boolean acquire = lock.acquire(3, TimeUnit.SECONDS);
            if (!acquire) {
                map.put("msg", "已有其他人员在处理中，请稍等");
                return map;
            }
            List<ImportCustomerPriceVo> list = sysInportTempService.queryItemList(request, currentUser.getDatasource());
            if (Collections3.isNotEmpty(list)) {
                String taskId = asyncProcessHandler.createTask();
                map.put("taskId", taskId);
                customerPriceService.changeCustomerPrice(st, list, currentUser, request.getParameter("importId"), taskId, Maps.newHashMap(request.getParameterMap()));
                map.put("state", true);
                map.put("msg", "已提交后台处理");
            } else {
                map.put("msg", "暂无有效数据可导入");
            }
        } catch (Exception e) {
            e.printStackTrace();
            map.put("msg", "操作出现错误" + e.getMessage());
        } finally {
            if (lock != null)
                lock.release();
        }
        return map;

    }

    /**
     * 下载编辑后数据zzx
     *
     * @param request
     * @param response
     * @return
     */
    @ResponseBody
    @RequestMapping("/downCustomerPriceToImportTemp")
    public Map<String, Object> downCustomerPriceToImportTemp(HttpServletRequest request, HttpServletResponse response, @ModelAttribute CustomerPriceModelVo vo, @RequestParam(value = "wareNm", required = false, defaultValue = "") String wareNm) {
        Map<String, Object> map = new HashMap<>();
        map.put("state", false);
        map.put("msg", "操作失败");
        try {
            SysLoginInfo info = this.getLoginInfo(request);
            if (!StrUtil.isNull(wareNm))
                vo.setProductName(wareNm);
            List<CustomerPriceModelVo> list = customerPriceService.queryCustomerPriceList(info.getDatasource(), vo);
            if (Collections3.isNotEmpty(list)) {
               /* List<ImportCustomerPriceVo> volist = new ArrayList<>(list.size());
                ImportCustomerPriceVo vo = null;
                for (CustomerPriceModelVo customerPriceModelVo : list) {
                    vo = new ImportCustomerPriceVo();
                    BeanCopy.copyBeanProperties(vo, customerPriceModelVo);
                    volist.add(vo);
                }*/
                //int importId = sysInportTempService.save(list, SysImportTemp.TypeEnum.type_customer_price.getCode(), info, SysImportTemp.InputDownEnum.down.getCode());
                ImportTypeBean typeBean = SysImportTemp.typeMap.get(SysImportTemp.TypeEnum.type_customer_price.getCode());
                Object obj = typeBean.getDownVo();
                if (obj == null) obj = typeBean.getVo();
                List<ImportTitleVo> titleVoList = sysInportTempService.getModelPropertyList(obj);
                int importId = sysInportTempService.save(list, titleVoList, info, SysImportTemp.TypeEnum.type_customer_price.getCode(), SysImportTemp.InputDownEnum.down.getCode());
                map.put("importId", importId);
                map.put("state", true);
                map.put("msg", "操作成功，导出数量" + list.size());
            }
        } catch (Exception e) {
            log.error("上传客户失败", e);
            map.put("msg", "操作失败," + e.getMessage());
        }
        return map;
    }

}