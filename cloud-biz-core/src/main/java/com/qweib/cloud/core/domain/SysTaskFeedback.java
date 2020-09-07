package com.qweib.cloud.core.domain;


import com.qweib.cloud.utils.TableAnnotation;

import java.util.ArrayList;
import java.util.List;

/**
 * 说明：任务反馈模型
 *
 * @创建：作者:zrp 创建时间：2015-1-26
 * @修改历史： [序号](zrp 2015 - 1 - 26)<修改说明>
 */
public class SysTaskFeedback {
    private Integer id;
    private Integer nid; // 所属照片墙
    private Integer persent; // 进度
    private String remarks;// 进度描述
    private String dtDate;// 日期
    /**
     * *************************
     */
    private Integer aid; //附件ID
    private String apath;//附件地址
    private String aname;//附件名称

    private List<SysTaskAttachment> atts = new ArrayList<SysTaskAttachment>();

    @TableAnnotation(insertAble = false, updateAble = false, nullToUpdate = false)
    public List<SysTaskAttachment> getAtts() {
        return atts;
    }

    public void setAtts(List<SysTaskAttachment> atts) {
        this.atts = atts;
    }

    @TableAnnotation(insertAble = false, updateAble = false, nullToUpdate = false)
    public Integer getAid() {
        return aid;
    }

    public void setAid(Integer aid) {
        this.aid = aid;
    }

    @TableAnnotation(insertAble = false, updateAble = false, nullToUpdate = false)
    public String getApath() {
        return apath;
    }

    public void setApath(String apath) {
        this.apath = apath;
    }

    @TableAnnotation(insertAble = false, updateAble = false, nullToUpdate = false)
    public String getAname() {
        return aname;
    }

    public void setAname(String aname) {
        this.aname = aname;
    }

    /**
     * *************************
     */
    @TableAnnotation(updateAble = false)
    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getNid() {
        return nid;
    }

    public void setNid(Integer nid) {
        this.nid = nid;
    }

    public Integer getPersent() {
        return persent;
    }

    public void setPersent(Integer persent) {
        this.persent = persent;
    }

    public String getRemarks() {
        return remarks;
    }

    public void setRemarks(String remarks) {
        this.remarks = remarks;
    }

    public String getDtDate() {
        return dtDate;
    }

    public void setDtDate(String dtDate) {
        this.dtDate = dtDate;
    }

}
