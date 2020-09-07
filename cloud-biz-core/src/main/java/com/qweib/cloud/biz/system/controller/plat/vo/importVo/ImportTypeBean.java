package com.qweib.cloud.biz.system.controller.plat.vo.importVo;

import lombok.Data;

import java.util.LinkedHashSet;
import java.util.Map;
import java.util.Set;

/**
 * 导入BEAN封装
 */
@Data
public class ImportTypeBean {

    /**
     * 名称
     */
    private String name;

    /**
     * 对应的VO(注需要是ImportBaseVo子类)
     */
    private Object vo;

    /**
     * 导出VO
     */
    private Object downVo;

    /**
     * 处理编辑后文本地址
     */
    private String handleExcelUrl;

    /**
     * 下载EXCEL模版地址
     */
    private String downExcelModelUrl;

    /**
     * 历史数据链接
     */
    private String oldMainPageUrl;

    /**
     * 下载数据到临时表接口
     */
    private String downDataToImportTempUrl;

    /**
     * 下单数据到EXCEL
     */
    private String downDataToExcelUrl;

    /**
     * 下载数据到临时表查询方法
     */
    private String downDataToImportTempFun;

    /**
     * 上传EXCEL链接，解析EXCEL，默认使用manager/sysImportTemp/toUpExcel
     */
    private String toUpExcelUrl;

    /**
     * 新增空页面链接,默认使用manager/sysImportTemp/toEdit
     */
    private String toCreateEmptyUrl;

    /**
     * 其它链接
     */
    private Map<String, String> otherToolBarMap;
    /**
     * 操作SCRIPT
     */
    private Set<String> operationScript = null;

    public void setOperationScriptStr(String scriptStr) {
        if (scriptStr != null && !"".equals(scriptStr)) {
            if (operationScript == null) operationScript = new LinkedHashSet<>();
            operationScript.add(scriptStr);
        }
    }
}
