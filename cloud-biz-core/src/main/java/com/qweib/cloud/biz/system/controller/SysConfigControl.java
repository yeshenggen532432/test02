package com.qweib.cloud.biz.system.controller;

import com.qweib.cloud.biz.common.GeneralControl;
import com.qweib.cloud.biz.system.service.SysConfigService;
import com.qweib.cloud.core.domain.SysConfig;
import com.qweib.cloud.core.domain.SysLoginInfo;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;


@Controller
@RequestMapping("/manager/sysConfig")
public class SysConfigControl extends GeneralControl {
    @Resource
    private SysConfigService configService;

    @RequestMapping("queryConfig")
    public String queryConfig(SysConfig config, Model model, HttpServletRequest request) {
        try {
            SysLoginInfo info = this.getLoginInfo(request);
            List<SysConfig> list = this.configService.queryList(config, info.getDatasource());
//            if (list == null || list.size() == 0) {
//                SysConfig sc1 = new SysConfig();
//                sc1.setCode("CONFIG_ORDER_AUTO_CREATE_XSFP");//订单自动生成销售发票
//                sc1.setName("开启销售订单自动生成销售发票");
//                sc1.setStatus("0");
//                this.configService.addConfig(sc1, info.getDatasource());
//                list = this.configService.queryList(null, info.getDatasource());
//            } else {
//                boolean CONFIG_XSFP_AUTO_SET_HIS_PRICE = true;//开启销售发票历史价格记忆
//                boolean CONFIG_XSFP_AUTO_CREATE_ORDER = true;//开启销售发票自动生成销售订单
//                boolean CONFIG_XSFP_AUTO_CREATE_FHD = true;//开启销售发票自动生成发货单
//                boolean CONFIG_SALER_MODIFY_PRICE = true;
//                boolean CONFIG_BUTTON_OPEN_AUTH = true;//开启分配功能按钮权限
//                boolean CONFIG_WARE_SUNIT_PRICE = true;//开启销售商品单位对应价格
//                boolean CONFIG_SALER_UPDATE_CUSTOMER = true;//开启业务员允许修改已审批客户；
//                boolean CONFIG_XSFP_AUTO_POST = true;//开启销售发票自动过账功能；
//                boolean CONFIG_XSFP_CHANG_ORDER_PRICE = true;//开启销售发票更改订单价格；
//                boolean CONFIG_IN_FANLI_PRICE = true;//开启采购返利;
//                boolean CONFIG_OUT_FANLI_PRICE = true;//开启销售返利;
//                boolean CONFIG_OUT_PRODUCT_DATE = true;//开启销售发票生产日期强制关联;
//                boolean CONFIG_CGFP_AUTO_CREATE_SHD = true;//开启采购发票单自动生成收货单
//                boolean CONFIG_CGFP_AUTO_REAUDIT = true;//开启采购发票反审核
//                boolean CONFIG_XSFP_AUTO_REAUDIT = true;//开启销售发票反审核
//                boolean CONFIG_SUNIT_REFER = true;//开启销售发票小单位参考列
//
//                boolean CONFIG_COST_AUTO_PAY = true;//报销费用自动生成付款单
//                boolean CONFIG_COST_AUTO_PAY_AUDIT = true;//报销费用自动生成付款单
//
//                boolean CONFIG_CLOSE_CGPRICE_AUTO_WRITE = true;//关闭采购单价格自动同步到商品
//
//                boolean CONFIG_REPEAT_BE_BARCODE = true;//允许商品条码重复；
//
//                boolean CONFIG_STORAGE_SHOW_MINUNIT = true;//库存查询显示小单位数量；
//
//                boolean CONFIG_SALE_SHOW_INPRICE = true;//开启销售发票选择商品显示成本价；
//
//                boolean CONFIG_ORDER_AUTO_CREATE_TH = true;//开启销售退货订单自动生成销售退货单;
//
//                boolean CONFIG_SALE_SHOW_HELP_UNIT = true;//开启销售发票启用辅助核销数量；
//
//                boolean CONFIG_WARE_AUTO_CODE = true;//开启商品代码自动生成；
//
//                boolean CONFIG_CGFP_QUICK_BILL = true;//开启采购发票快速开单
//
//                boolean CONFIG_XSFP_QUICK_BILL = true;//开启销售发票快速开单
//
//                boolean CONFIG_XSFP_AUTO_STOCK = true;//开启销售发票快速开单自动补货
//
//                boolean CONFIG_CLOSE_XSPRICE_AUTO_WRITE = true;//关闭销售单价格自动同步到商品
//
//                boolean CONFIG_START_UP_STOCK_CORRECT = true;//启动库存纠偏功能
//
//                boolean CONFIG_SHOP_ORDER_TO_SALE = true;//线上商城订单审批时自动生成销售发票单
//
//                boolean CONFIG_XSTH_AUTO_REAUDIT = true;//开启销售退货反审核
//
//                boolean CONFIG_XSFP_TO_CUSTOMER_PRICE = true;//开始销售发票商品价同步客户商品执行价
//
//                boolean CONFIG_USE_NEW_STOCK_CAL = true;//启用新的库存计算方法
//
//                boolean CONFIG_SHOP_ORDER_REFUND = true;//启用商城订单退款功能；
//
//                boolean CONFIG_XSFP_COMPARE_ZX_PRICE = true;//开启销售发票对比执行价
//
//                boolean CONFIG_XSFP_COMPARE_HIS_PRICE = true;//开启销售发票对比历史价；
//
//                for (int i = 0; i < list.size(); i++) {
//                    SysConfig config = list.get(i);
//                    if ("CONFIG_SALER_MODIFY_PRICE".equals(config.getCode())) {
//                        CONFIG_SALER_MODIFY_PRICE = false;
//                    }
//                    if ("CONFIG_BUTTON_OPEN_AUTH".equals(config.getCode())) {
//                        CONFIG_BUTTON_OPEN_AUTH = false;
//                    }
//                    if ("CONFIG_XSFP_AUTO_CREATE_FHD".equals(config.getCode())) {
//                        CONFIG_XSFP_AUTO_CREATE_FHD = false;
//                    }
//                    if ("CONFIG_XSFP_AUTO_SET_HIS_PRICE".equals(config.getCode())) {
//                        CONFIG_XSFP_AUTO_SET_HIS_PRICE = false;
//                    }
//                    if ("CONFIG_XSFP_AUTO_CREATE_ORDER".equals(config.getCode())) {
//                        CONFIG_XSFP_AUTO_CREATE_ORDER = false;
//                    }
//                    if ("CONFIG_WARE_SUNIT_PRICE".equals(config.getCode())) {
//                        CONFIG_WARE_SUNIT_PRICE = false;
//                    }
//                    if ("CONFIG_SALER_UPDATE_CUSTOMER".equals(config.getCode())) {
//                        CONFIG_SALER_UPDATE_CUSTOMER = false;
//                    }
//                    if ("CONFIG_XSFP_AUTO_POST".equals(config.getCode())) {
//                        CONFIG_XSFP_AUTO_POST = false;
//                    }
//                    if ("CONFIG_XSFP_CHANG_ORDER_PRICE".equals(config.getCode())) {
//                        CONFIG_XSFP_CHANG_ORDER_PRICE = false;
//                    }
//                    if ("CONFIG_IN_FANLI_PRICE".equals(config.getCode())) {
//                        CONFIG_IN_FANLI_PRICE = false;
//                    }
//                    if ("CONFIG_OUT_FANLI_PRICE".equals(config.getCode())) {
//                        CONFIG_OUT_FANLI_PRICE = false;
//                    }
//                    if ("CONFIG_OUT_PRODUCT_DATE".equals(config.getCode())) {
//                        CONFIG_OUT_PRODUCT_DATE = false;
//                    }
//                    if ("CONFIG_CGFP_AUTO_CREATE_SHD".equals(config.getCode())) {
//                        CONFIG_CGFP_AUTO_CREATE_SHD = false;
//                    }
//
//                    if ("CONFIG_CGFP_AUTO_REAUDIT".equals(config.getCode())) {
//                        CONFIG_CGFP_AUTO_REAUDIT = false;
//                    }
//                    if ("CONFIG_XSFP_AUTO_REAUDIT".equals(config.getCode())) {
//                        CONFIG_XSFP_AUTO_REAUDIT = false;
//                    }
//                    if ("CONFIG_SUNIT_REFER".equals(config.getCode())) {
//                        CONFIG_SUNIT_REFER = false;
//                    }
//
//                    if ("CONFIG_COST_AUTO_PAY".equals(config.getCode())) {
//                        CONFIG_COST_AUTO_PAY = false;
//                    }
//                    if ("CONFIG_COST_AUTO_PAY_AUDIT".equals(config.getCode())) {
//                        CONFIG_COST_AUTO_PAY_AUDIT = false;
//                    }
//                    if ("CONFIG_CLOSE_CGPRICE_AUTO_WRITE".equals(config.getCode())) {
//                        CONFIG_CLOSE_CGPRICE_AUTO_WRITE = false;
//                    }
//                    if ("CONFIG_REPEAT_BE_BARCODE".equals(config.getCode())) {
//                        CONFIG_REPEAT_BE_BARCODE = false;
//                    }
//
//                    if ("CONFIG_STORAGE_SHOW_MINUNIT".equals(config.getCode())) {
//                        CONFIG_STORAGE_SHOW_MINUNIT = false;
//                    }
//
//                    if ("CONFIG_SALE_SHOW_INPRICE".equals(config.getCode())) {
//                        CONFIG_SALE_SHOW_INPRICE = false;
//                    }
//
//                    if ("CONFIG_ORDER_AUTO_CREATE_TH".equals(config.getCode())) {
//                        CONFIG_ORDER_AUTO_CREATE_TH = false;
//                    }
//
//                    if ("CONFIG_SALE_SHOW_HELP_UNIT".equals(config.getCode())) {
//                        CONFIG_SALE_SHOW_HELP_UNIT = false;
//                    }
//
//                    if ("CONFIG_WARE_AUTO_CODE".equals(config.getCode())) {
//                        CONFIG_WARE_AUTO_CODE = false;
//                    }
//
//                    if ("CONFIG_CGFP_QUICK_BILL".equals(config.getCode())) {
//                        CONFIG_CGFP_QUICK_BILL = false;
//                    }
//
//                    if ("CONFIG_XSFP_QUICK_BILL".equals(config.getCode())) {
//                        CONFIG_XSFP_QUICK_BILL = false;
//                    }
//
//                    if ("CONFIG_XSFP_AUTO_STOCK".equals(config.getCode())) {
//                        CONFIG_XSFP_AUTO_STOCK = false;
//                    }
//
//                    if ("CONFIG_CLOSE_XSPRICE_AUTO_WRITE".equals(config.getCode())) {
//                        CONFIG_CLOSE_XSPRICE_AUTO_WRITE = false;
//                    }
//
//                    if ("CONFIG_START_UP_STOCK_CORRECT".equals(config.getCode())) {
//                        CONFIG_START_UP_STOCK_CORRECT = false;
//                    }
//
//                    if ("CONFIG_SHOP_ORDER_TO_SALE".equals(config.getCode())) {
//                        CONFIG_SHOP_ORDER_TO_SALE = false;
//                    }
//
//                    if ("CONFIG_XSTH_AUTO_REAUDIT".equals(config.getCode())) {
//                        CONFIG_XSTH_AUTO_REAUDIT = false;
//                    }
//
//                    if ("CONFIG_XSFP_TO_CUSTOMER_PRICE".equals(config.getCode())) {
//                        CONFIG_XSFP_TO_CUSTOMER_PRICE = false;
//                    }
//
//                    if ("CONFIG_USE_NEW_STOCK_CAL".equals(config.getCode())) {
//                        CONFIG_USE_NEW_STOCK_CAL = false;
//                    }
//
//                    if ("CONFIG_SHOP_ORDER_REFUND".equals(config.getCode())) {
//                        CONFIG_SHOP_ORDER_REFUND = false;
//                    }
//
//                    if ("CONFIG_XSFP_COMPARE_ZX_PRICE".equals(config.getCode())) {
//                        CONFIG_XSFP_COMPARE_ZX_PRICE = false;
//                    }
//
//                    if ("CONFIG_XSFP_COMPARE_HIS_PRICE".equals(config.getCode())) {
//                        CONFIG_XSFP_COMPARE_HIS_PRICE = false;
//                    }
//
//                }
//                if (CONFIG_SALER_MODIFY_PRICE) {
//                    SysConfig sc1 = new SysConfig();
//                    sc1.setCode("CONFIG_SALER_MODIFY_PRICE");//订单自动生成销售发票
//                    sc1.setName("开启业务员不可修改销售价格");
//                    sc1.setStatus("0");
//                    this.configService.addConfig(sc1, info.getDatasource());
//                }
//                if (CONFIG_BUTTON_OPEN_AUTH) {
//                    SysConfig sc1 = new SysConfig();
//                    sc1.setCode("CONFIG_BUTTON_OPEN_AUTH");//开启分配功能按钮权限
//                    sc1.setName("开启分配功能按钮权限");
//                    sc1.setStatus("0");
//                    this.configService.addConfig(sc1, info.getDatasource());
//                }
//                if (CONFIG_XSFP_AUTO_CREATE_FHD) {
//                    SysConfig sc1 = new SysConfig();
//                    sc1.setCode("CONFIG_XSFP_AUTO_CREATE_FHD");
//                    sc1.setName("开启销售发票自动生成发货单");
//                    sc1.setStatus("0");
//                    this.configService.addConfig(sc1, info.getDatasource());
//                }
//                if (CONFIG_XSFP_AUTO_SET_HIS_PRICE) {
//                    SysConfig sc1 = new SysConfig();
//                    sc1.setCode("CONFIG_XSFP_AUTO_SET_HIS_PRICE");
//                    sc1.setName("开启销售发票历史价格记忆");
//                    sc1.setStatus("0");
//                    this.configService.addConfig(sc1, info.getDatasource());
//                }
//                if (CONFIG_XSFP_AUTO_CREATE_ORDER) {
//                    SysConfig sc1 = new SysConfig();
//                    sc1.setCode("CONFIG_XSFP_AUTO_CREATE_ORDER");
//                    sc1.setName("开启销售发票自动生成销售订单");
//                    sc1.setStatus("0");
//                    this.configService.addConfig(sc1, info.getDatasource());
//                }
//                if (CONFIG_WARE_SUNIT_PRICE) {
//                    SysConfig sc1 = new SysConfig();
//                    sc1.setCode("CONFIG_WARE_SUNIT_PRICE");
//                    sc1.setName("开启销售商品单位对应价格");
//                    sc1.setStatus("0");
//                    this.configService.addConfig(sc1, info.getDatasource());
//                }
//                if (CONFIG_SALER_UPDATE_CUSTOMER) {
//                    SysConfig sc1 = new SysConfig();
//                    sc1.setCode("CONFIG_SALER_UPDATE_CUSTOMER");
//                    sc1.setName("开启业务员允许修改已审批客户");
//                    sc1.setStatus("0");
//                    this.configService.addConfig(sc1, info.getDatasource());
//                }
//                if (CONFIG_XSFP_AUTO_POST) {
//                    SysConfig sc1 = new SysConfig();
//                    sc1.setCode("CONFIG_XSFP_AUTO_POST");
//                    sc1.setName("开启销售发票自动过账功能");
//                    sc1.setStatus("0");
//                    this.configService.addConfig(sc1, info.getDatasource());
//                }
//                if (CONFIG_XSFP_CHANG_ORDER_PRICE) {
//                    SysConfig sc1 = new SysConfig();
//                    sc1.setCode("CONFIG_XSFP_CHANG_ORDER_PRICE");
//                    sc1.setName("开启销售发票更改订单价格");
//                    sc1.setStatus("0");
//                    this.configService.addConfig(sc1, info.getDatasource());
//                }
//                if (CONFIG_IN_FANLI_PRICE) {
//                    SysConfig sc1 = new SysConfig();
//                    sc1.setCode("CONFIG_IN_FANLI_PRICE");
//                    sc1.setName("开启采购返利");
//                    sc1.setStatus("0");
//                    this.configService.addConfig(sc1, info.getDatasource());
//                }
//                if (CONFIG_OUT_FANLI_PRICE) {
//                    SysConfig sc1 = new SysConfig();
//                    sc1.setCode("CONFIG_OUT_FANLI_PRICE");
//                    sc1.setName("开启销售返利");
//                    sc1.setStatus("0");
//                    this.configService.addConfig(sc1, info.getDatasource());
//                }
//                if (CONFIG_OUT_PRODUCT_DATE) {
//                    SysConfig sc1 = new SysConfig();
//                    sc1.setCode("CONFIG_OUT_PRODUCT_DATE");
//                    sc1.setName("开启销售发票生产日期强制关联库存");
//                    sc1.setStatus("0");
//                    this.configService.addConfig(sc1, info.getDatasource());
//                }
//                if (CONFIG_CGFP_AUTO_CREATE_SHD) {
//                    SysConfig sc1 = new SysConfig();
//                    sc1.setCode("CONFIG_CGFP_AUTO_CREATE_SHD");
//                    sc1.setName("开启采购发票单自动生成收货单");
//                    sc1.setStatus("0");
//                    this.configService.addConfig(sc1, info.getDatasource());
//                }
//                //
//                if (CONFIG_CGFP_AUTO_REAUDIT) {
//                    SysConfig sc1 = new SysConfig();
//                    sc1.setCode("CONFIG_CGFP_AUTO_REAUDIT");
//                    sc1.setName("开启采购发票反审核");
//                    sc1.setStatus("0");
//                    this.configService.addConfig(sc1, info.getDatasource());
//                }
//                if (CONFIG_XSFP_AUTO_REAUDIT) {
//                    SysConfig sc1 = new SysConfig();
//                    sc1.setCode("CONFIG_XSFP_AUTO_REAUDIT");
//                    sc1.setName("开启销售发票反审核");
//                    sc1.setStatus("0");
//                    this.configService.addConfig(sc1, info.getDatasource());
//                }
//
//                if (CONFIG_SUNIT_REFER) {
//                    SysConfig sc1 = new SysConfig();
//                    sc1.setCode("CONFIG_SUNIT_REFER");
//                    sc1.setName("开启销售发票小单位参考列");
//                    sc1.setStatus("0");
//                    this.configService.addConfig(sc1, info.getDatasource());
//                }
//
//                if (CONFIG_COST_AUTO_PAY) {
//                    SysConfig sc1 = new SysConfig();
//                    sc1.setCode("CONFIG_COST_AUTO_PAY");
//                    sc1.setName("报销凭证自动生成付款单");
//                    sc1.setStatus("0");
//                    this.configService.addConfig(sc1, info.getDatasource());
//                }
//                if (CONFIG_COST_AUTO_PAY_AUDIT) {
//                    SysConfig sc1 = new SysConfig();
//                    sc1.setCode("CONFIG_COST_AUTO_PAY_AUDIT");
//                    sc1.setName("报销凭证自动生成付款单且自动审批");
//                    sc1.setStatus("0");
//                    this.configService.addConfig(sc1, info.getDatasource());
//                }
//
//                if (CONFIG_CLOSE_CGPRICE_AUTO_WRITE) {
//                    SysConfig sc1 = new SysConfig();
//                    sc1.setCode("CONFIG_CLOSE_CGPRICE_AUTO_WRITE");
//                    sc1.setName("关闭采购单价格自动同步到商品");
//                    sc1.setStatus("0");
//                    this.configService.addConfig(sc1, info.getDatasource());
//                }
//
//                if (CONFIG_REPEAT_BE_BARCODE) {
//                    SysConfig sc1 = new SysConfig();
//                    sc1.setCode("CONFIG_REPEAT_BE_BARCODE");
//                    sc1.setName("允许商品条码重复");
//                    sc1.setStatus("0");
//                    this.configService.addConfig(sc1, info.getDatasource());
//                }
//
//                if (CONFIG_STORAGE_SHOW_MINUNIT) {
//                    SysConfig sc1 = new SysConfig();
//                    sc1.setCode("CONFIG_STORAGE_SHOW_MINUNIT");
//                    sc1.setName("库存查询显示小单位数量");
//                    sc1.setStatus("0");
//                    this.configService.addConfig(sc1, info.getDatasource());
//                }
//                if (CONFIG_SALE_SHOW_INPRICE) {
//                    SysConfig sc1 = new SysConfig();
//                    sc1.setCode("CONFIG_SALE_SHOW_INPRICE");
//                    sc1.setName("开启销售发票选择商品显示成本价");
//                    sc1.setStatus("0");
//                    this.configService.addConfig(sc1, info.getDatasource());
//                }
//                if (CONFIG_ORDER_AUTO_CREATE_TH) {
//                    SysConfig sc1 = new SysConfig();
//                    sc1.setCode("CONFIG_ORDER_AUTO_CREATE_TH");
//                    sc1.setName("开启销售退货订单自动生成销售退货单");
//                    sc1.setStatus("0");
//                    this.configService.addConfig(sc1, info.getDatasource());
//                }
//                if (CONFIG_SALE_SHOW_HELP_UNIT) {
//                    SysConfig sc1 = new SysConfig();
//                    sc1.setCode("CONFIG_SALE_SHOW_HELP_UNIT");
//                    sc1.setName("开启销售发票启用辅助核销数量");
//                    sc1.setStatus("0");
//                    this.configService.addConfig(sc1, info.getDatasource());
//                }
//                if (CONFIG_WARE_AUTO_CODE) {
//                    SysConfig sc1 = new SysConfig();
//                    sc1.setCode("CONFIG_WARE_AUTO_CODE");
//                    sc1.setName("开启商品代码自动生成");
//                    sc1.setStatus("0");
//                    this.configService.addConfig(sc1, info.getDatasource());
//                }
//                if (CONFIG_CGFP_QUICK_BILL) {
//                    SysConfig sc1 = new SysConfig();
//                    sc1.setCode("CONFIG_CGFP_QUICK_BILL");
//                    sc1.setName("开启采购发票快速开单");
//                    sc1.setStatus("0");
//                    this.configService.addConfig(sc1, info.getDatasource());
//                }
//                if (CONFIG_XSFP_QUICK_BILL) {
//                    SysConfig sc1 = new SysConfig();
//                    sc1.setCode("CONFIG_XSFP_QUICK_BILL");
//                    sc1.setName("开启销售发票快速开单");
//                    sc1.setStatus("0");
//                    this.configService.addConfig(sc1, info.getDatasource());
//                }
//                if (CONFIG_XSFP_AUTO_STOCK) {
//                    SysConfig sc1 = new SysConfig();
//                    sc1.setCode("CONFIG_XSFP_AUTO_STOCK");
//                    sc1.setName("开启销售发票快速开单自动补货");
//                    sc1.setStatus("0");
//                    this.configService.addConfig(sc1, info.getDatasource());
//                }
//
//                if (CONFIG_CLOSE_XSPRICE_AUTO_WRITE) {
//                    SysConfig sc1 = new SysConfig();
//                    sc1.setCode("CONFIG_CLOSE_XSPRICE_AUTO_WRITE");
//                    sc1.setName("关闭销售单价格自动同步到商品");
//                    sc1.setStatus("0");
//                    this.configService.addConfig(sc1, info.getDatasource());
//                }
//
//                if (CONFIG_START_UP_STOCK_CORRECT) {
//                    SysConfig sc1 = new SysConfig();
//                    sc1.setCode("CONFIG_START_UP_STOCK_CORRECT");
//                    sc1.setName("开启库存纠偏功能");
//                    sc1.setStatus("0");
//                    this.configService.addConfig(sc1, info.getDatasource());
//                }
//
//                if (CONFIG_SHOP_ORDER_TO_SALE) {
//                    SysConfig sc1 = new SysConfig();
//                    sc1.setCode("CONFIG_SHOP_ORDER_TO_SALE");
//                    sc1.setName("开启线上商城订单审批时自动生成销售发票单");
//                    sc1.setStatus("0");
//                    this.configService.addConfig(sc1, info.getDatasource());
//                }
//
//                if (CONFIG_XSTH_AUTO_REAUDIT) {
//                    SysConfig sc1 = new SysConfig();
//                    sc1.setCode("CONFIG_XSTH_AUTO_REAUDIT");
//                    sc1.setName("开启销售退货反审批");
//                    sc1.setStatus("0");
//                    this.configService.addConfig(sc1, info.getDatasource());
//                }
//
//                if (CONFIG_XSFP_TO_CUSTOMER_PRICE) {
//                    SysConfig sc1 = new SysConfig();
//                    sc1.setCode("CONFIG_XSFP_TO_CUSTOMER_PRICE");
//                    sc1.setName("关闭销售发票商品价同步客户商品执行价");
//                    sc1.setStatus("0");
//                    this.configService.addConfig(sc1, info.getDatasource());
//                }
//
//                if (CONFIG_USE_NEW_STOCK_CAL) {
//                    SysConfig sc1 = new SysConfig();
//                    sc1.setCode("CONFIG_USE_NEW_STOCK_CAL");
//                    sc1.setName("启用新的库存计算算法(支持负库存)");
//                    sc1.setStatus("0");
//                    this.configService.addConfig(sc1, info.getDatasource());
//                }
//
//                if (CONFIG_SHOP_ORDER_REFUND) {
//                    SysConfig sc1 = new SysConfig();
//                    sc1.setCode("CONFIG_SHOP_ORDER_REFUND");
//                    sc1.setName("启用商城订单退款功能");
//                    sc1.setStatus("0");
//                    this.configService.addConfig(sc1, info.getDatasource());
//                }
//
//                if (CONFIG_XSFP_COMPARE_ZX_PRICE) {
//                    SysConfig sc1 = new SysConfig();
//                    sc1.setCode("CONFIG_XSFP_COMPARE_ZX_PRICE");
//                    sc1.setName("开启销售发票对比执行价");
//                    sc1.setStatus("0");
//                    this.configService.addConfig(sc1, info.getDatasource());
//                }
//
//                if (CONFIG_XSFP_COMPARE_HIS_PRICE) {
//                    SysConfig sc1 = new SysConfig();
//                    sc1.setCode("CONFIG_XSFP_COMPARE_HIS_PRICE");
//                    sc1.setName("开启销售发票对比历史价");
//                    sc1.setStatus("0");
//                    this.configService.addConfig(sc1, info.getDatasource());
//                }
//                list = this.configService.queryList(null, info.getDatasource());
//            }
            request.setAttribute("datas", list);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "/system/config/sysConfig";
    }

    @RequestMapping("toConfigList")
    public void toConfigList(SysConfig config, HttpServletResponse response, HttpServletRequest request) {
        try {
            SysLoginInfo info = this.getLoginInfo(request);
            List<SysConfig> list = this.configService.queryList(config, info.getDatasource());
            JSONObject json = new JSONObject();
            json.put("total", list.size());
            json.put("rows", list);
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            log.error("查询系统参数出错：", e);
        }
    }

    @RequestMapping("toConfigPage")
    public void toConfigPage(SysConfig Config, int page, int rows, HttpServletResponse response, HttpServletRequest request) {
        try {
            SysLoginInfo info = this.getLoginInfo(request);
            Page p = this.configService.queryConfigPage(Config, page, rows, info.getDatasource());
            JSONObject json = new JSONObject();
            json.put("total", p.getTotal());
            json.put("rows", p.getRows());
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            log.error("查询系统参数出错：", e);
        }
    }

    @RequestMapping("updateConfig")
    public void updateConfig(SysConfig config, HttpServletResponse response, HttpServletRequest request) {
        JSONObject json = new JSONObject();
        try {
            json.put("state", false);//默认保存失败
            SysLoginInfo info = this.getLoginInfo(request);
            if (!StrUtil.isNull(config)) {
                this.configService.updateConfig(config, info.getDatasource());
                json.put("state", true);
                json.put("id", config.getId());
                this.sendJsonResponse(response, json.toString());
            }
        } catch (Exception e) {
            log.error("操作系统参数出错：", e);
            this.sendJsonResponse(response, json.toString());
        }
    }

    @RequestMapping("getConfig")
    public void getConfig(Integer id, HttpServletResponse response, HttpServletRequest request) {
        try {
            SysLoginInfo info = this.getLoginInfo(request);
            SysConfig Config = this.configService.queryConfigById(id, info.getDatasource());
            JSONObject json = new JSONObject(Config);
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            log.error("获取系统参数出错：", e);
        }
    }

    @RequestMapping("deleteConfigById")
    public void deleteConfigById(Integer id, HttpServletResponse response, HttpServletRequest request) {
        try {
            SysLoginInfo info = this.getLoginInfo(request);
            this.configService.deleteConfig(id, info.getDatasource());
            this.sendHtmlResponse(response, "1");
        } catch (Exception e) {
            log.error("操作系统参数出错：", e);
            this.sendHtmlResponse(response, "-1");
        }
    }

}
