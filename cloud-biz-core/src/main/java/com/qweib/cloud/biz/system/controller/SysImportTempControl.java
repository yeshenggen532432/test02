package com.qweib.cloud.biz.system.controller;

import com.qweib.cloud.biz.common.FileUtils;
import com.qweib.cloud.biz.common.GeneralControl;
import com.qweib.cloud.biz.system.controller.plat.vo.importVo.ImportTitleVo;
import com.qweib.cloud.biz.system.controller.plat.vo.importVo.ImportTypeBean;
import com.qweib.cloud.biz.system.service.SysInportTempService;
import com.qweib.cloud.core.domain.SysImportTemp;
import com.qweib.cloud.core.domain.SysImportTempItem;
import com.qweib.cloud.core.domain.SysLoginInfo;
import com.qweib.cloud.utils.JsonUtil;
import com.qweib.cloud.utils.Page;
import com.qweibframework.commons.zookeeper.lock.ZkLock;
import com.qweibframework.commons.zookeeper.lock.ZkLockTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.util.*;
import java.util.concurrent.TimeUnit;

/**
 * 导入数据临时表
 */
@Controller
@RequestMapping("/manager/sysImportTemp")
public class SysImportTempControl extends GeneralControl {
    @Resource
    private SysInportTempService sysInportTempService;
    @Autowired
    private ZkLockTemplate lockTemplate;

    /**
     * 统一导入页面
     *
     * @param model
     * @param request
     * @return
     */
    @RequestMapping("toMainPage")
    public String toMainPage(Model model, HttpServletRequest request, @RequestParam(value = "type", required = true) Integer type) {
        SysImportTemp sysImportTemp = new SysImportTemp();
        sysImportTemp.setType(type);
        model.addAttribute("sysImportTemp", sysImportTemp);
        model.addAttribute("typeBean", SysImportTemp.typeMap.get(type));
        return "/uglcw/import/sys_import_main_page";
    }

    /**
     * 导入页面数据
     *
     * @param model
     * @param request
     * @param page
     * @param rows
     * @return
     */
    @ResponseBody
    @RequestMapping("mainPage")
    public Page mainPage(Model model, HttpServletRequest request, @RequestParam(value = "type", required = true) Integer type, @RequestParam(value = "page", defaultValue = "1") Integer page, @RequestParam(value = "rows", defaultValue = "20") Integer rows) {
        SysLoginInfo info = this.getLoginInfo(request);
        SysImportTemp sysImportTemp = new SysImportTemp();
        sysImportTemp.setType(type);
        return sysInportTempService.queryPage(sysImportTemp, page, rows, info.getDatasource());
    }


    /**
     * 编辑页面
     *
     * @param model
     * @param request
     * @param id
     * @return
     */
    @RequestMapping("toEdit")
    public String toEdit(Model model, HttpServletRequest request, @RequestParam(value = "id", required = false, defaultValue = "0") Integer id, @RequestParam(value = "type", required = true) Integer type,
                         @RequestParam(value = "importStatus", defaultValue = "0", required = false) Integer importStatus) {
        SysLoginInfo info = this.getLoginInfo(request);
        ImportTypeBean typeBean = SysImportTemp.typeMap.get(type);
        List<?> titleList = sysInportTempService.getModelPropertyList(typeBean.getVo());
        if (id != null && !Objects.equals(id, 0)) {
            SysImportTemp sysImportTemp = sysInportTempService.queryById(id, info.getDatasource());
            titleList = JsonUtil.readJsonList(sysImportTemp.getTitleJson(), ImportTitleVo.class);
            model.addAttribute("inputDown", sysImportTemp.getInputDown());
        }
        model.addAttribute("titleList", titleList);
        model.addAttribute("editUrl", typeBean.getHandleExcelUrl());
        model.addAttribute("id", id);
        model.addAttribute("type", type);
        model.addAttribute("name", typeBean.getName());
        model.addAttribute("importStatus", importStatus);
        model.addAttribute("operationScript", typeBean.getOperationScript());
        return "/uglcw/import/sys_import_edit";
    }

    /**
     * 获取列表数据
     */
    @ResponseBody
    @RequestMapping("queryItemPage")
    public Page queryById(HttpServletRequest request, @ModelAttribute SysImportTempItem sysImportTempItem, @RequestParam(value = "queryStr", defaultValue = "") String queryStr,
                          @RequestParam(value = "page", defaultValue = "1") Integer page, @RequestParam(value = "rows", defaultValue = "20") Integer rows) {
        SysLoginInfo info = this.getLoginInfo(request);
        return sysInportTempService.queryItemPage(sysImportTempItem, queryStr, page, rows, info.getDatasource());
    }


    /**
     * 导入数据到临时表
     *
     * @param request
     * @param response
     */
    @ResponseBody
    @RequestMapping("/toUpExcel")
    public Map<String, Object> toUpExcel1(HttpServletRequest request, HttpServletResponse response, MultipartFile upFile, @RequestParam(value = "type", required = true) Integer type) {
        Map<String, Object> map = new HashMap<>();
        map.put("state", false);
        map.put("msg", "导入失败");
        SysLoginInfo info = this.getLoginInfo(request);
        ZkLock lock = null;
        File importFile = FileUtils.copyFile(upFile, request);
        try {
            lock = this.lockTemplate.getLock("cloud:sys:import:temp:" + info.getFdCompanyId() + ":" + type);
            boolean acquire = lock.acquire(1, TimeUnit.SECONDS);
            if (acquire) {
                int tempId = sysInportTempService.addUploadExcel(request, new FileInputStream(importFile), type, info);
                if (tempId > 0) {
                    map.put("state", true);
                    map.put("importId", tempId);
                    map.put("msg", "导入成功");
                }
            } else {
                map.put("msg", "已有其他人员在处理中，请稍等");
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            map.put("msg", "导入出现错误" + ex.getMessage());
        } finally {
            if (lock != null)
                lock.release();
            if (importFile.exists()) {
                importFile.delete();
            }
        }
        return map;
    }

    /**
     * 新版本上传方法 zzx
     *
     * @param request
     * @param response
     */
    @ResponseBody
    @RequestMapping("/updateOrSave")
    public Map<String, Object> updateOrSave(HttpServletRequest request, HttpServletResponse response, @RequestParam(value = "type", required = true) Integer type, @RequestParam(value = "contextJson", required = true) String contextJson) {
        Map<String, Object> map = new HashMap<>();
        SysLoginInfo info = this.getLoginInfo(request);
        map.put("state", false);
        map.put("msg", "操作失败");
        try {
            ImportTypeBean typeBean = SysImportTemp.typeMap.get(type);
            List<Object> list = JsonUtil.readJsonList(contextJson, Map.class);
            //保存或修改导入临时记录
            Map<String, Integer> map1 = sysInportTempService.updateOrSave(request, list, type, 0, info);
            if (map1 != null) {
                map.putAll(map1);
            }
            map.put("state", true);
            map.put("msg", "操作成功");
        } catch (Exception ex) {
            ex.printStackTrace();
            map.put("msg", "出现错误" + ex.getMessage());
        }
        return map;
    }
}
