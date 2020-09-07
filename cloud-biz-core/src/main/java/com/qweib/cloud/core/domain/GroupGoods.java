package com.qweib.cloud.core.domain;


import com.qweib.cloud.utils.TableAnnotation;

/**
 * 说明：商品
 *
 * @创建：作者:llp 创建时间：2015-1-27
 * @修改历史： [序号](llp 2015 - 1 - 27)<修改说明>
 */
public class GroupGoods {
    private Integer id;                   //商品id
    private String gname;                 //品商名称
    private Double yprice;                //原价
    private Double xprice;                //现价
    private String url;                   //淘宝地址
    private String stime;                 //开始时间
    private String etime;                 //结束时间
    private Integer humennum;             //人气
    private Integer salesvolume;          //销量
    private String pic;                   //图片
    private Integer stock;                //库存
    private String isrx;                  //是否热销1,是；2,否
    private String remark;                //商品介绍
    //----------------------不在数据库--------------
    private String oldpic;                //原图ԭͼ


    public String getIsrx() {
        return isrx;
    }

    public void setIsrx(String isrx) {
        this.isrx = isrx;
    }

    public String getRemark() {
        return remark;
    }

    public void setRemark(String remark) {
        this.remark = remark;
    }

    public Integer getStock() {
        return stock;
    }

    public void setStock(Integer stock) {
        this.stock = stock;
    }

    @TableAnnotation(updateAble = false, insertAble = false)
    public String getOldpic() {
        return oldpic;
    }

    public void setOldpic(String oldpic) {
        this.oldpic = oldpic;
    }

    public String getEtime() {
        return etime;
    }

    public void setEtime(String etime) {
        this.etime = etime;
    }

    public String getGname() {
        return gname;
    }

    public void setGname(String gname) {
        this.gname = gname;
    }

    public Integer getHumennum() {
        return humennum;
    }

    public void setHumennum(Integer humennum) {
        this.humennum = humennum;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getPic() {
        return pic;
    }

    public void setPic(String pic) {
        this.pic = pic;
    }

    public Integer getSalesvolume() {
        return salesvolume;
    }

    public void setSalesvolume(Integer salesvolume) {
        this.salesvolume = salesvolume;
    }

    public String getStime() {
        return stime;
    }

    public void setStime(String stime) {
        this.stime = stime;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public Double getXprice() {
        return xprice;
    }

    public void setXprice(Double xprice) {
        this.xprice = xprice;
    }

    public Double getYprice() {
        return yprice;
    }

    public void setYprice(Double yprice) {
        this.yprice = yprice;
    }


}
