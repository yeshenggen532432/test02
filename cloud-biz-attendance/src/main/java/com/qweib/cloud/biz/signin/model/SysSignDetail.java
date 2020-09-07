package com.qweib.cloud.biz.signin.model;

public class SysSignDetail {
    private Integer id;
    private Integer signId;
    private Integer objType;
    private String picMini;
    private String pic;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getSignId() {
        return signId;
    }

    public void setSignId(Integer signId) {
        this.signId = signId;
    }

    public Integer getObjType() {
        return objType;
    }

    public void setObjType(Integer objType) {
        this.objType = objType;
    }

    public String getPicMini() {
        return picMini;
    }

    public void setPicMini(String picMini) {
        this.picMini = picMini;
    }

    public String getPic() {
        return pic;
    }

    public void setPic(String pic) {
        this.pic = pic;
    }
}
