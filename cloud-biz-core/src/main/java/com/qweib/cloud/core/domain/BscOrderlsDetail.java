package com.qweib.cloud.core.domain;


import com.qweib.cloud.utils.TableAnnotation;

//旅行社订单详情
public class BscOrderlsDetail {
    private Integer id;//详情id
    private Integer orderId;//订单id
    private Integer wareId;//商品id
    private Double zh;//总回率
    private Double ls;//旅社率
    private Double dy;//导游率
    private Double sj;//司机率
    private Double qp;//全陪率
    //-------------------不在数据库--------------
    private String wareNm;//商品名称


    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    @TableAnnotation(insertAble = false, updateAble = false)
    public String getWareNm() {
        return wareNm;
    }

    public void setWareNm(String wareNm) {
        this.wareNm = wareNm;
    }

    public Double getDy() {
        return dy;
    }

    public void setDy(Double dy) {
        this.dy = dy;
    }

    public Double getLs() {
        return ls;
    }

    public void setLs(Double ls) {
        this.ls = ls;
    }

    public Integer getOrderId() {
        return orderId;
    }

    public void setOrderId(Integer orderId) {
        this.orderId = orderId;
    }

    public Double getQp() {
        return qp;
    }

    public void setQp(Double qp) {
        this.qp = qp;
    }

    public Double getSj() {
        return sj;
    }

    public void setSj(Double sj) {
        this.sj = sj;
    }

    public Integer getWareId() {
        return wareId;
    }

    public void setWareId(Integer wareId) {
        this.wareId = wareId;
    }

    public Double getZh() {
        return zh;
    }

    public void setZh(Double zh) {
        this.zh = zh;
    }


}
