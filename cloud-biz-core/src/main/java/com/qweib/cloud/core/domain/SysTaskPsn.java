package com.qweib.cloud.core.domain;


import com.qweib.cloud.utils.TableAnnotation;

/**
 * 说明：任务相关人员模型
 *
 * @创建：作者:zrp 创建时间：2015-1-26
 * @修改历史： [序号](zrp 2015 - 1 - 26)<修改说明>
 */
public class SysTaskPsn {

    public static Integer PSN_RESPONSIBILITY = 1;// 责任人
    public static Integer PSN_FOCUS_ON = 2;// 关注人
//	public static Integer PSN_FEEDBACK=3;// 反馈人

    private Integer id;
    private Integer psnType; // 类型
    private Integer psnId;// 人员ID
    private Integer nid;// 所属照片墙
    /**************************************/
    private String memberNm;

    @TableAnnotation(insertAble = false, updateAble = false, nullToUpdate = false)
    public String getMemberNm() {
        return memberNm;
    }

    public void setMemberNm(String memberNm) {
        this.memberNm = memberNm;
    }

    /**************************************/

    @TableAnnotation(updateAble = false, insertAble = false)
    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getPsnType() {
        return psnType;
    }

    public void setPsnType(Integer psnType) {
        this.psnType = psnType;
    }

    public Integer getPsnId() {
        return psnId;
    }

    public void setPsnId(Integer psnId) {
        this.psnId = psnId;
    }

    public Integer getNid() {
        return nid;
    }

    public void setNid(Integer nid) {
        this.nid = nid;
    }
}
