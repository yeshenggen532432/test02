package com.qweib.cloud.core.domain;


import com.qweib.cloud.utils.TableAnnotation;

/**
 * 说明：任务表模型
 *
 * @创建：作者:zrp 创建时间：2015-1-26
 * @修改历史： [序号](zrp 2015 - 1 - 26)<修改说明>
 */
public class SysTaskIng {

    private Integer id;
    private Integer taskId;//对应的任务id
    private String taskTitle; // 任务标题
    private String createTime;//创建时间
    private String startTime; // 开始时间
    private String endTime; // 完成时间
    private Integer parentId; // 父任务ID
    private Integer createBy; // 创建人
    private String time1;//提醒时间1
    private String time2;//提醒时间2
    private String time3;//提醒时间3
    private String time4;//提醒时间4
    private String time5;//提醒时间5
    private Integer remind1;//提醒1
    private Integer remind2;//提醒2
    private Integer remind3;//提醒3
    private Integer remind4;//提醒4


    ///////不在数据库
    private String premind;
    private String memberMobile;


    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getTaskId() {
        return taskId;
    }

    public void setTaskId(Integer taskId) {
        this.taskId = taskId;
    }

    public String getTaskTitle() {
        return taskTitle;
    }

    public void setTaskTitle(String taskTitle) {
        this.taskTitle = taskTitle;
    }

    public String getCreateTime() {
        return createTime;
    }

    public void setCreateTime(String createTime) {
        this.createTime = createTime;
    }

    public String getStartTime() {
        return startTime;
    }

    public void setStartTime(String startTime) {
        this.startTime = startTime;
    }

    public String getEndTime() {
        return endTime;
    }

    public void setEndTime(String endTime) {
        this.endTime = endTime;
    }

    public Integer getParentId() {
        return parentId;
    }

    public void setParentId(Integer parentId) {
        this.parentId = parentId;
    }

    public Integer getCreateBy() {
        return createBy;
    }

    public void setCreateBy(Integer createBy) {
        this.createBy = createBy;
    }

    public String getTime1() {
        return time1;
    }

    public void setTime1(String time1) {
        this.time1 = time1;
    }

    public String getTime2() {
        return time2;
    }

    public void setTime2(String time2) {
        this.time2 = time2;
    }

    public String getTime3() {
        return time3;
    }

    public void setTime3(String time3) {
        this.time3 = time3;
    }

    public String getTime4() {
        return time4;
    }

    public void setTime4(String time4) {
        this.time4 = time4;
    }

    public String getTime5() {
        return time5;
    }

    public void setTime5(String time5) {
        this.time5 = time5;
    }

    public Integer getRemind1() {
        return remind1;
    }

    public void setRemind1(Integer remind1) {
        this.remind1 = remind1;
    }

    public Integer getRemind2() {
        return remind2;
    }

    public void setRemind2(Integer remind2) {
        this.remind2 = remind2;
    }

    public Integer getRemind3() {
        return remind3;
    }

    public void setRemind3(Integer remind3) {
        this.remind3 = remind3;
    }

    public Integer getRemind4() {
        return remind4;
    }

    public void setRemind4(Integer remind4) {
        this.remind4 = remind4;
    }

    @TableAnnotation(insertAble = false, updateAble = false, nullToUpdate = false)
    public String getPremind() {
        return premind;
    }

    public void setPremind(String premind) {
        this.premind = premind;
    }

    @TableAnnotation(insertAble = false, updateAble = false, nullToUpdate = false)
    public String getMemberMobile() {
        return memberMobile;
    }

    public void setMemberMobile(String memberMobile) {
        this.memberMobile = memberMobile;
    }


}
