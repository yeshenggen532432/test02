package com.qweib.cloud.core.domain;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.qweib.cloud.biz.system.controller.plat.vo.importVo.*;
import lombok.Data;

import java.util.*;

/**
 * 导入数据临时表
 */
@Data
public class SysImportTemp {

    private Integer id;
    /**
     * 标题JSON
     */
    private String titleJson;

    /**
     * 标题
     */
    private String title;
    /**
     * 保存时间
     */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    private Date saveDate;
    /**
     * 修改时间
     */
    private Date updateDate;
    /**
     * 类型
     */
    private Integer type;

    /**
     * 操作人ID
     */
    private Integer operId;

    /**
     * 操作员
     */
    private String operName;

    /**
     * 导入0或导出数据1 InputDownEnum
     */
    private Integer inputDown;

    /**
     * 导入状态0待导入,1导入成功(全部导入成功后状态改为1)
     */
    private Integer status;

    /**
     * 成功导入时间
     */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    private Date successDate;

    public static Map<Integer, ImportTypeBean> typeMap = new HashMap<>();


    static {
        Set<String> waryOperationScript = new LinkedHashSet<>();
        waryOperationScript.add("<input class='dataVaildata' name='replaceWare' type='checkbox'>覆盖重名商品信息");
        waryOperationScript.add("<input class='dataVaildata' name='notWareVaildateMaxAttr' type='checkbox'>支持单位和规格为空导入");

        ImportTypeBean typeBeanSysWare = new ImportTypeBean();
        typeBeanSysWare.setName("商品信息");
        typeBeanSysWare.setVo(new ImportWareVo());
        typeBeanSysWare.setDownVo(new DownWareVo());
        typeBeanSysWare.setHandleExcelUrl("manager/sysWareImportNew/toUpWareNew");
        typeBeanSysWare.setDownExcelModelUrl("manager/sysWareImportNew/toWareImportTemplate?type=" + TypeEnum.type_ware.code);
        typeBeanSysWare.setOldMainPageUrl("manager/sysWareImportMain/toPage");
        typeBeanSysWare.setToUpExcelUrl("manager/sysWareImportNew/toUpExcel");
        typeBeanSysWare.setToCreateEmptyUrl("manager/sysWareImportNew/toCreateEmpty");
        Map<String, String> map = new HashMap<>();
        map.put("双单位模版", "manager/sysImportTemp/toMainPage?_sticky=v2&type=" + TypeEnum.type_ware_big_unit.code);

        typeBeanSysWare.setOtherToolBarMap(map);
        typeBeanSysWare.setDownDataToImportTempUrl("manager/sysWareImportNew/downSysWareToImportTemp?_sticky=v2&type=" + TypeEnum.type_ware.code);
        typeBeanSysWare.setDownDataToImportTempFun("productTemplate");
        //typeBeanSysWare.setDownDataToExcelUrl("manager/toWareImportData");
        typeBeanSysWare.setDownDataToExcelUrl("manager/sysWareImportNew/downSysWareToImportTemp?_sticky=v2&type=" + TypeEnum.type_ware.code);//使用新版本导出zzx
        typeBeanSysWare.setOperationScript(waryOperationScript);

        //基本条件
        Set<String> customerScript = new LinkedHashSet<>();
        customerScript.addAll(waryOperationScript);
        customerScript.add("<span class='form-horizontal'>");
        customerScript.add("<input uglcw-model='queryStr' id='queryStr' uglcw-role='textbox' style='display:none;'>");
        /* customerScript.add("<input class='query' name='customerName' placeholder='客户名称'>");*/
        customerScript.add("<input class='query' name='wareNm' placeholder='商品名称'>");
        customerScript.add("<button onclick='reload();' uglcw-role='button' class='k-button k-info'>搜索</button>");
        customerScript.add("</span>");
        typeBeanSysWare.setOperationScript(customerScript);

        typeMap.put(TypeEnum.type_ware.code, typeBeanSysWare);

        ImportTypeBean typeBeanSysWareBigUnti = new ImportTypeBean();
        typeBeanSysWareBigUnti.setName("商品大单位信息");
        typeBeanSysWareBigUnti.setVo(new ImportWareBigUnitVo());
        typeBeanSysWareBigUnti.setHandleExcelUrl("manager/sysWareImportNew/toUpWareNew");
        typeBeanSysWareBigUnti.setDownExcelModelUrl("manager/sysWareImportNew/toWareImportTemplate?type=" + TypeEnum.type_ware_big_unit.code);
        typeBeanSysWareBigUnti.setOldMainPageUrl("manager/sysWareImportMain/toPage");
        typeBeanSysWareBigUnti.setToUpExcelUrl("manager/sysWareImportNew/toUpExcel");
        typeBeanSysWareBigUnti.setToCreateEmptyUrl("manager/sysWareImportNew/toCreateEmpty");
        map = new HashMap<>();
        map.put("大单位模版", "manager/sysImportTemp/toMainPage?_sticky=v2&type=" + TypeEnum.type_ware.code);
        typeBeanSysWareBigUnti.setOtherToolBarMap(map);
        typeBeanSysWareBigUnti.setDownDataToImportTempUrl("manager/sysWareImportNew/downSysWareToImportTemp?_sticky=v2&type=" + TypeEnum.type_ware_big_unit.code);
        typeBeanSysWareBigUnti.setDownDataToImportTempFun("productTemplate");
        typeBeanSysWareBigUnti.setOperationScript(waryOperationScript);
        typeBeanSysWareBigUnti.setOperationScript(customerScript);
        typeMap.put(TypeEnum.type_ware_big_unit.code, typeBeanSysWareBigUnti);


        ImportTypeBean typeBeanInPrice = new ImportTypeBean();
        typeBeanInPrice.setName("商品采购设置");
        typeBeanInPrice.setVo(new ImportWareInPriceVo());
        typeBeanInPrice.setHandleExcelUrl("manager/sysWareImportNew/toUpWareInPrice");
        typeBeanInPrice.setDownDataToImportTempUrl("manager/sysWareImportNew/downWareInPriceToImportTemp");
        typeBeanInPrice.setDownExcelModelUrl("static/template/uglcw_wareinprice_import.xlsx");
        typeBeanInPrice.setDownDataToImportTempFun("productTemplate");
        typeMap.put(TypeEnum.type_ware_in_price.code, typeBeanInPrice);


        ImportTypeBean typeBeanSysCustomer = new ImportTypeBean();
        typeBeanSysCustomer.setName("客户信息");
        typeBeanSysCustomer.setVo(new ImportSysCustomerVo());
        typeBeanSysCustomer.setHandleExcelUrl("manager/toUpCustomerExcelNew");
        typeBeanSysCustomer.setDownExcelModelUrl("static/template/uglcw_customer_import.xlsx");
        typeBeanSysCustomer.setOldMainPageUrl("manager/sysCustomerImportMain/toPage");
        typeBeanSysCustomer.setDownDataToImportTempUrl("manager/downCustomerToImportTemp");
        //map = new HashMap<>();
        //map.put("下载客户数据", "manager/export?classname=sysCustomerService&method=queryCustomer2&condition=%7BkhNm%3A%27%27%2CmemberNm%3A%27%27%2Cdatabase%3A%27xmuglcwwlkjyxgs285%27%2CkhTp%3A2%2CisDb%3A2%2CnullStaff%3A0%7D&bean=com.qweib.cloud.core.domain.SysCustomer&discribe=%E5%AE%A2%E6%88%B7%E8%AE%B0%E5%BD%95&exportstyle=1&exportcontent=2&pageSize=20&pageNumber=1&total=2387&data=%5B%7Bkey%3A%27khCode%27%2Cname%3A%27%E5%AE%A2%E6%88%B7%E7%BC%96%E7%A0%81%27%7D%2C%7Bkey%3A%27khNm%27%2Cname%3A%27%E5%AE%A2%E6%88%B7%E5%90%8D%E7%A7%B0%27%7D%2C%7Bkey%3A%27linkman%27%2Cname%3A%27%E8%B4%9F%E8%B4%A3%E4%BA%BA%27%7D%2C%7Bkey%3A%27tel%27%2Cname%3A%27%E8%B4%9F%E8%B4%A3%E4%BA%BA%E7%94%B5%E8%AF%9D%27%7D%2C%7Bkey%3A%27mobile%27%2Cname%3A%27%E8%B4%9F%E8%B4%A3%E4%BA%BA%E6%89%8B%E6%9C%BA%27%7D%2C%7Bkey%3A%27address%27%2Cname%3A%27%E5%9C%B0%E5%9D%80%27%7D%2C%7Bkey%3A%27qdtpNm%27%2Cname%3A%27%E5%AE%A2%E6%88%B7%E7%B1%BB%E5%9E%8B%27%7D%2C%7Bkey%3A%27khdjNm%27%2Cname%3A%27%E5%AE%A2%E6%88%B7%E7%AD%89%E7%BA%A7%27%7D%2C%7Bkey%3A%27bfpcNm%27%2Cname%3A%27%E6%8B%9C%E8%AE%BF%E9%A2%91%E6%AC%A1%27%7D%2C%7Bkey%3A%27xsjdNm%27%2Cname%3A%27%E9%94%80%E5%94%AE%E9%98%B6%E6%AE%B5%27%7D%2C%7Bkey%3A%27sctpNm%27%2Cname%3A%27%E5%B8%82%E5%9C%BA%E7%B1%BB%E5%9E%8B%27%7D%2C%7Bkey%3A%27hzfsNm%27%2Cname%3A%27%E5%90%88%E4%BD%9C%E6%96%B9%E5%BC%8F%27%7D%2C%7Bkey%3A%27regionNm%27%2Cname%3A%27%E5%AE%A2%E6%88%B7%E5%BD%92%E5%B1%9E%E7%89%87%E5%8C%BA%27%7D%2C%7Bkey%3A%27shZt%27%2Cname%3A%27%E5%AE%A1%E6%A0%B8%E7%8A%B6%E6%80%81%27%7D%2C%7Bkey%3A%27uscCode%27%2Cname%3A%27%E7%A4%BE%E4%BC%9A%E4%BF%A1%E7%94%A8%E7%BB%9F%E4%B8%80%E4%BB%A3%E7%A0%81%27%7D%2C%7Bkey%3A%27memberNm%27%2Cname%3A%27%E4%B8%9A%E5%8A%A1%E5%91%98%27%7D%2C%7Bkey%3A%27memberMobile%27%2Cname%3A%27%E4%B8%9A%E5%8A%A1%E5%91%98%E6%89%8B%E6%9C%BA%E5%8F%B7%27%7D%2C%7Bkey%3A%27branchName%27%2Cname%3A%27%E9%83%A8%E9%97%A8%27%7D%2C%7Bkey%3A%27ghtpNm%27%2Cname%3A%27%E4%BE%9B%E8%B4%A7%E7%B1%BB%E5%9E%8B%27%7D%2C%7Bkey%3A%27pkhCode%27%2Cname%3A%27%E4%BE%9B%E8%B4%A7%E7%BB%8F%E9%94%80%E5%95%86%E7%BC%96%E7%A0%81%27%7D%2C%7Bkey%3A%27pkhNm%27%2Cname%3A%27%E4%BE%9B%E8%B4%A7%E7%BB%8F%E9%94%80%E5%95%86%27%7D%2C%7Bkey%3A%27jyfw%27%2Cname%3A%27%E9%94%80%E5%94%AE%E5%8C%BA%E5%9F%9F%27%7D%2C%7Bkey%3A%27fgqy%27%2Cname%3A%27%E8%A6%86%E7%9B%96%E5%8C%BA%E5%9F%9F%27%7D%2C%7Bkey%3A%27longitude%27%2Cname%3A%27%E7%BB%8F%E5%BA%A6%27%7D%2C%7Bkey%3A%27latitude%27%2Cname%3A%27%E7%BA%AC%E5%BA%A6%27%7D%2C%7Bkey%3A%27province%27%2Cname%3A%27%E7%9C%81%27%7D%2C%7Bkey%3A%27city%27%2Cname%3A%27%E5%9F%8E%E5%B8%82%27%7D%2C%7Bkey%3A%27area%27%2Cname%3A%27%E5%8C%BA%E5%8E%BF%27%7D%2C%7Bkey%3A%27openDate%27%2Cname%3A%27%E5%BC%80%E6%88%B7%E6%97%A5%E6%9C%9F%27%7D%2C%7Bkey%3A%27closeDate%27%2Cname%3A%27%E9%97%AD%E6%88%B7%E6%97%A5%E6%9C%9F%27%7D%2C%7Bkey%3A%27isYx%27%2Cname%3A%27%E6%98%AF%E5%90%A6%E6%9C%89%E6%95%88%27%7D%2C%7Bkey%3A%27isDb%27%2Cname%3A%27%E5%AE%A2%E6%88%B7%E7%8A%B6%E6%80%81%27%7D%2C%7Bkey%3A%27remo%27%2Cname%3A%27%E5%A4%87%E6%B3%A8%27%7D%2C%7Bkey%3A%27createTime%27%2Cname%3A%27%E5%88%9B%E5%BB%BA%E6%97%A5%E6%9C%9F%27%7D%2C%7Bkey%3A%27shTime%27%2Cname%3A%27%E5%AE%A1%E6%A0%B8%E6%97%B6%E9%97%B4%27%7D%2C%7Bkey%3A%27shMemberNm%27%2Cname%3A%27%E5%AE%A1%E6%A0%B8%E4%BA%BA%27%7D%2C%7Bkey%3A%27erpCode%27%2Cname%3A%27ERP%E7%BC%96%E7%A0%81%27%7D%2C%7Bkey%3A%27py%27%2Cname%3A%27%E5%8A%A9%E8%AE%B0%E7%A0%81%27%7D%5D");
        //typeBeanSysCustomer.setOtherToolBarMap(map);
        typeBeanSysCustomer.setDownDataToExcelUrl("manager/downCustomerToImportTemp");
        typeBeanSysCustomer.setOperationScriptStr("<input class='dataVaildata' name='replaceSysCustomer' type='checkbox'>覆盖重名客户信息");
        typeMap.put(TypeEnum.type_sys_customer.code, typeBeanSysCustomer);


        ImportTypeBean typeBeanSysMember = new ImportTypeBean();
        typeBeanSysMember.setName("员工信息");
        typeBeanSysMember.setVo(new ImportSysMemberVo());
        typeBeanSysMember.setHandleExcelUrl("manager/sysMember/toUpExcel");
        typeBeanSysMember.setDownExcelModelUrl("static/template/uglcw_member_import.xlsx");
        typeBeanSysMember.setOldMainPageUrl("manager/sysMemberImportMain/toPage");
        typeBeanSysMember.setDownDataToImportTempUrl("manager/sysMember/downSysMemberToImportTemp");
        typeBeanSysMember.setOperationScriptStr("<input class='dataVaildata' name='replaceSysMember' type='checkbox'>覆盖重名会员信息");
        typeMap.put(TypeEnum.type_sys_member.code, typeBeanSysMember);


        ImportTypeBean typeBeanCustomerPrice = new ImportTypeBean();
        typeBeanCustomerPrice.setName("客户历史销售价格");
        typeBeanCustomerPrice.setVo(new ImportCustomerPriceVo());
        typeBeanCustomerPrice.setDownVo(new DownCustomerPriceVo());
        typeBeanCustomerPrice.setHandleExcelUrl("manager/customer/price/import_data_new");
        typeBeanCustomerPrice.setDownExcelModelUrl("static/template/uglcw_customer_price_import.xlsx");
        //typeBeanCustomerPrice.setOldMainPageUrl("manager/toCustomerPriceImport");
        typeBeanCustomerPrice.setDownDataToImportTempUrl("manager/customer/price/downCustomerPriceToImportTemp");
        typeBeanCustomerPrice.setDownDataToImportTempFun("productTemplate");
        //基本条件
        customerScript = new LinkedHashSet<>();
        customerScript.addAll(waryOperationScript);
        customerScript.add("<span class='form-horizontal'>");
        customerScript.add("<input uglcw-model='queryStr' id='queryStr' uglcw-role='textbox' style='display:none;' placeholder='客户名称'>");
        customerScript.add("<input class='query' name='customerName' placeholder='客户名称'>");
        customerScript.add("<input class='query' name='productName' placeholder='商品名称'>");
        customerScript.add("<button onclick='reload();' uglcw-role='button' class='k-button k-info'>搜索</button>");
        customerScript.add("</span>");
        typeBeanCustomerPrice.setOperationScript(customerScript);
        typeMap.put(TypeEnum.type_customer_price.code, typeBeanCustomerPrice);
    }

    public enum TypeEnum {
        type_ware(1), type_ware_big_unit(11), type_ware_in_price(12), type_sys_customer(3), type_sys_member(4), type_customer_price(5);
        private int code;

        TypeEnum(int code) {
            this.code = code;
        }

        public int getCode() {
            return this.code;
        }
    }

    public enum StateEnum {
        state_import_success(1), state_save(0);
        private int code;

        StateEnum(int code) {
            this.code = code;
        }

        public int getCode() {
            return this.code;
        }
    }

    public enum InputDownEnum {
        input(0), down(1);
        private int code;

        InputDownEnum(int code) {
            this.code = code;
        }

        public int getCode() {
            return this.code;
        }
    }
}
