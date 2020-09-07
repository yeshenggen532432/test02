package com.qweib.cloud.biz.system.controller.plat.vo.importVo;

import com.qweib.cloud.utils.DateTimeUtil;

import java.util.HashSet;
import java.util.LinkedHashSet;
import java.util.Set;

/**
 * 导入处理结果VO
 */
public class ImportResults {
    //成功数量
    private Integer successNum = 0;
    //存在数量
    private Integer existsNum = 0;
    //错误消息
    private Set<String> errorMsg = new LinkedHashSet<>();

    //成功消息
    private String successMsg;

    /**
     * 操作SCRIPT
     */
    private Set<String> operationScript = new HashSet<>();

    public String getErrorMsg() {
        if (this.errorMsg.isEmpty()) return "";
        return String.join("", errorMsg);
    }

    public String getOperationScript() {
        if (this.operationScript.isEmpty()) return "";
        return String.join("", operationScript);
    }

    public void setErrorMsg(String msg) {
        if (msg != null && !"".equals(msg)) {
            errorMsg.add(msg + "<br/>");
        }
    }

    public void addSuccessNum() {
        this.successNum = this.successNum + 1;
    }

    public void addExistsNum() {
        this.existsNum = this.existsNum + 1;
    }

    /**
     * 暂时不使用，使用默认显示
     *
     * @param scriptStr
     */
    @Deprecated
    public void setOperationScript(String scriptStr) {
        if (scriptStr != null && !"".equals(scriptStr)) {
            operationScript.add(scriptStr);
        }
    }

    public void setSuccessMsg(long st) {
        StringBuffer str = new StringBuffer();
        str.append("处理完成-" + "耗时:" + DateTimeUtil.formatDateTime((System.currentTimeMillis() - st) / 1000));
        if (this.existsNum > 0) {
            str.append(",名称存在重复(" + this.existsNum + ")条");
        }
        str.append(",成功导入(" + this.successNum + ")条");
        this.successMsg = str.toString();
    }

    public String getSuccessMsg() {
        return successMsg;
    }
}
