package com.qweib.cloud.biz.system.controller.plat.vo.importVo;

import com.qweibframework.excel.annotation.ModelProperty;
import lombok.Data;
import org.hibernate.validator.constraints.NotEmpty;

/**
 * 客户资料导入
 */
@Data
public class ImportSysCustomerVo extends ImportBaseVo {

    @NotEmpty(message = "客户名称不能为空")
    @ModelProperty(label = "客户名称")
    private String khNm;

    @ModelProperty(label = "负责人")
    private String linkman;

    @ModelProperty(label = "负责人电话")
    private String tel;

    //@NotEmpty(message = "负责人手机不能为空")
    @ModelProperty(label = "负责人手机")
    private String mobile;

    @ModelProperty(label = "业务员")
    private String memberNm;

    @ModelProperty(label = "地址")
    private String address;

    @ModelProperty(label = "经度")
    private String longitude;

    @ModelProperty(label = "纬度")
    private String latitude;

    @ModelProperty(label = "客户归属片区")//地区使用/区分上下线
    private String regionStr;
}
