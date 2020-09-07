package com.qweib.cloud.core.domain;


import com.qweib.cloud.utils.TableAnnotation;

public class GroupGoodsDetail {
    private Integer gpid;//商品id
    private Integer step;//步骤
    private String pic;//图片
    //--------------------------不在数据库----------------
    private String oldpic;

    @TableAnnotation(updateAble = false, insertAble = false)
    public String getOldpic() {
        return oldpic;
    }

    public void setOldpic(String oldpic) {
        this.oldpic = oldpic;
    }

    public Integer getGpid() {
        return gpid;
    }

    public void setGpid(Integer gpid) {
        this.gpid = gpid;
    }

    public String getPic() {
        return pic;
    }

    public void setPic(String pic) {
        this.pic = pic;
    }

    public Integer getStep() {
        return step;
    }

    public void setStep(Integer step) {
        this.step = step;
    }


}
