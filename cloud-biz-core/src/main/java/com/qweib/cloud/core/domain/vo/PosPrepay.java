package com.qweib.cloud.core.domain.vo;

public class PosPrepay {
    private String pay_ver;//版本号

    private String pay_type;//请求类型

    private String service_id;//接口类型

    private String merchant_no;//商户号

    private String terminal_id;//终端号

    private String terminal_trace;//终端流水号

    private String terminal_time;//终端交易时间

    private String total_fee;//金额

    private String sub_appid;

    private String open_id;

    private String goods_detail;

    private String operator_id;//操作员号

    private String order_body;//订单描述

    private String key_sign; //签名检验串

    private String dataSource;

    private Integer orderId;

    private String outTradeNo;

    private String authNo;


    public String getPay_ver() {
        return pay_ver;
    }

    public void setPay_ver(String pay_ver) {
        this.pay_ver = pay_ver;
    }

    public String getPay_type() {
        return pay_type;
    }

    public void setPay_type(String pay_type) {
        this.pay_type = pay_type;
    }

    public String getService_id() {
        return service_id;
    }

    public void setService_id(String service_id) {
        this.service_id = service_id;
    }

    public String getMerchant_no() {
        return merchant_no;
    }

    public void setMerchant_no(String merchant_no) {
        this.merchant_no = merchant_no;
    }

    public String getTerminal_id() {
        return terminal_id;
    }

    public void setTerminal_id(String terminal_id) {
        this.terminal_id = terminal_id;
    }

    public String getTerminal_trace() {
        return terminal_trace;
    }

    public void setTerminal_trace(String terminal_trace) {
        this.terminal_trace = terminal_trace;
    }

    public String getTerminal_time() {
        return terminal_time;
    }

    public void setTerminal_time(String terminal_time) {
        this.terminal_time = terminal_time;
    }

    public String getTotal_fee() {
        return total_fee;
    }

    public void setTotal_fee(String total_fee) {
        this.total_fee = total_fee;
    }

    public String getSub_appid() {
        return sub_appid;
    }

    public void setSub_appid(String sub_appid) {
        this.sub_appid = sub_appid;
    }

    public String getOpen_id() {
        return open_id;
    }

    public void setOpen_id(String open_id) {
        this.open_id = open_id;
    }

    public String getGoods_detail() {
        return goods_detail;
    }

    public void setGoods_detail(String goods_detail) {
        this.goods_detail = goods_detail;
    }

    public String getOperator_id() {
        return operator_id;
    }

    public void setOperator_id(String operator_id) {
        this.operator_id = operator_id;
    }

    public String getOrder_body() {
        return order_body;
    }

    public void setOrder_body(String order_body) {
        this.order_body = order_body;
    }

    public String getKey_sign() {
        return key_sign;
    }

    public void setKey_sign(String key_sign) {
        this.key_sign = key_sign;
    }

    public String getDataSource() {
        return dataSource;
    }

    public void setDataSource(String dataSource) {
        this.dataSource = dataSource;
    }

    public Integer getOrderId() {
        return orderId;
    }

    public void setOrderId(Integer orderId) {
        this.orderId = orderId;
    }

    public String getOutTradeNo() {
        return outTradeNo;
    }

    public void setOutTradeNo(String outTradeNo) {
        this.outTradeNo = outTradeNo;
    }

    public String getAuthNo() {
        return authNo;
    }

    public void setAuthNo(String authNo) {
        this.authNo = authNo;
    }
}
