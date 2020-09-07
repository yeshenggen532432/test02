package com.qweib.cloud.biz.attendance.model;

import com.qweib.cloud.utils.TableAnnotation;

public class KqDetail {
	private Integer id;
	private Integer memberId;//员工ID
	private String kqDate;//考勤日期
	private String kqStatus;//状态
	private Integer bcId;//班次ID如果有排班以排班的班次ID为准，否则以规律班
	private String bcName;//班次名称
	private String tfrom1;//班次时间-实际签到时间
	private String dto1;//班次下班时间-实际下班时间
	private String tfrom2;//班次时间-实际签到时间
	private String dto2;//班次下班时间-实际下班时间
	private String remarks;//备注
	private Integer minute1;//班次的上班时间单位分钟
	private Integer minute2;//实际的上班时间 单位分钟
	private Integer dis1;//提早上班分钟数
	private Integer dis2;//晚下班分钟数
	private Integer dis11;//第二个班次提早上班分钟数
	private Integer dis22;//第二个班次晚下班分钟数
	private Integer cdMinute;
	private Integer ztMinute;
	/////////////////////////////////////////////
	private String memberNm;
	private String sdate;
	private String edate;
	private Integer branchId;
	private String remarks1;
	private KqBc bc;
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public Integer getMemberId() {
		return memberId;
	}
	public void setMemberId(Integer memberId) {
		this.memberId = memberId;
	}
	public String getKqDate() {
		return kqDate;
	}
	public void setKqDate(String kqDate) {
		this.kqDate = kqDate;
	}
	public String getKqStatus() {
		return kqStatus;
	}
	public void setKqStatus(String kqStatus) {
		this.kqStatus = kqStatus;
	}
	public Integer getBcId() {
		return bcId;
	}
	public void setBcId(Integer bcId) {
		this.bcId = bcId;
	}
	public String getBcName() {
		return bcName;
	}
	public void setBcName(String bcName) {
		this.bcName = bcName;
	}
	public String getTfrom1() {
		return tfrom1;
	}
	public void setTfrom1(String tfrom1) {
		this.tfrom1 = tfrom1;
	}
	public String getDto1() {
		return dto1;
	}
	public void setDto1(String dto1) {
		this.dto1 = dto1;
	}
	public String getTfrom2() {
		return tfrom2;
	}
	public void setTfrom2(String tfrom2) {
		this.tfrom2 = tfrom2;
	}
	public String getDto2() {
		return dto2;
	}
	public void setDto2(String dto2) {
		this.dto2 = dto2;
	}
	public String getRemarks() {
		return remarks;
	}
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
	public Integer getMinute1() {
		return minute1;
	}
	public void setMinute1(Integer minute1) {
		this.minute1 = minute1;
	}
	public Integer getMinute2() {
		return minute2;
	}
	public void setMinute2(Integer minute2) {
		this.minute2 = minute2;
	}
	public Integer getDis1() {
		return dis1;
	}
	public void setDis1(Integer dis1) {
		this.dis1 = dis1;
	}
	public Integer getDis2() {
		return dis2;
	}
	public void setDis2(Integer dis2) {
		this.dis2 = dis2;
	}
	public Integer getDis11() {
		return dis11;
	}
	public void setDis11(Integer dis11) {
		this.dis11 = dis11;
	}
	public Integer getDis22() {
		return dis22;
	}
	public void setDis22(Integer dis22) {
		this.dis22 = dis22;
	}
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getMemberNm() {
		return memberNm;
	}
	public void setMemberNm(String memberNm) {
		this.memberNm = memberNm;
	}
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getSdate() {
		return sdate;
	}
	public void setSdate(String sdate) {
		this.sdate = sdate;
	}
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getEdate() {
		return edate;
	}
	public void setEdate(String edate) {
		this.edate = edate;
	}
	@TableAnnotation(insertAble=false,updateAble=false)
	public Integer getBranchId() {
		return branchId;
	}
	public void setBranchId(Integer branchId) {
		this.branchId = branchId;
	}
	@TableAnnotation(insertAble=false,updateAble=false)
	public KqBc getBc() {
		return bc;
	}
	public void setBc(KqBc bc) {
		this.bc = bc;
	}
	public Integer getCdMinute() {
		return cdMinute;
	}
	public void setCdMinute(Integer cdMinute) {
		this.cdMinute = cdMinute;
	}
	public Integer getZtMinute() {
		return ztMinute;
	}
	public void setZtMinute(Integer ztMinute) {
		this.ztMinute = ztMinute;
	}
	@TableAnnotation(insertAble=false,updateAble=false)
	public String getRemarks1() {
		return remarks1;
	}
	public void setRemarks1(String remarks1) {
		this.remarks1 = remarks1;
	}
	
	

}
