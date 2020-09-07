package com.qweib.cloud.biz.system.controller.plat.vo.importVo;

import com.qweibframework.excel.annotation.ModelProperty;
import lombok.Data;
import org.hibernate.validator.constraints.NotEmpty;

/**
 * 员工信息导入
 */
@Data
public class ImportSysMemberVo extends ImportBaseVo {

    @NotEmpty(message = "姓名不能为空")
    @ModelProperty(label = "姓名")
    private String memberNm;

    @NotEmpty(message = "手机号码不能为空")
    @ModelProperty(label = "手机号码(不能重复)")
    private String memberMobile;

    @ModelProperty(label = "职位")
    private String memberJob;

    @ModelProperty(label = "行业")
    private String memberTrade;

    @ModelProperty(label = "毕业院校")
    private String memberGraduated;

    @ModelProperty(label = "家乡")
    private String memberHometown;

    @NotEmpty(message = "部门不能为空")
    @ModelProperty(label = "部门")
    private String branchName;
}
