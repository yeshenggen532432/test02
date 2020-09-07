package com.qweib.cloud.core.domain;


import com.qweib.cloud.utils.TableAnnotation;

/**
 * 审批科目
 * @TableAnnotation(insertAble = false, updateAble = false)
 */
public class BscAuditSubject {
    private Integer id;
    private String itemName;
    private Integer typeId;
    private String remarks;
    private Integer mark;//1:默认核销费用项目；
    private Integer saleMark;//1:销售费用投入；
    private Integer status;//1:正常 0:禁用



}
