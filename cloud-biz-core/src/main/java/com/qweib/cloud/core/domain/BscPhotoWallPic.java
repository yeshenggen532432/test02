package com.qweib.cloud.core.domain;

/**
 * @说明：照片墙图片类
 * @创建者： 作者：llp   创建时间：2014-5-6
 */
public class BscPhotoWallPic {
    private Integer picId;            //id
    private Integer wallId;           //所属照片墙id
    private String picMini;           //小图
    private String pic;                //原图

    public String getPic() {
        return pic;
    }

    public void setPic(String pic) {
        this.pic = pic;
    }

    public Integer getPicId() {
        return picId;
    }

    public void setPicId(Integer picId) {
        this.picId = picId;
    }

    public String getPicMini() {
        return picMini;
    }

    public void setPicMini(String picMini) {
        this.picMini = picMini;
    }

    public Integer getWallId() {
        return wallId;
    }

    public void setWallId(Integer wallId) {
        this.wallId = wallId;
    }

}
