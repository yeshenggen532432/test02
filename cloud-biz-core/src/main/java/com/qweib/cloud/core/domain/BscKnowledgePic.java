package com.qweib.cloud.core.domain;

public class BscKnowledgePic {

    private Integer picId;//图片id
    private Integer knowledgeId;//所属知识点
    private String picMini;//图片小图
    private String pic;//图片

    public Integer getPicId() {
        return picId;
    }

    public void setPicId(Integer picId) {
        this.picId = picId;
    }

    public Integer getKnowledgeId() {
        return knowledgeId;
    }

    public void setKnowledgeId(Integer knowledgeId) {
        this.knowledgeId = knowledgeId;
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

    public BscKnowledgePic(Integer knowledgeId, String picMini,
                           String pic) {
        this.knowledgeId = knowledgeId;
        this.picMini = picMini;
        this.pic = pic;
    }

    public BscKnowledgePic() {
        super();
        // TODO Auto-generated constructor stub
    }


}
