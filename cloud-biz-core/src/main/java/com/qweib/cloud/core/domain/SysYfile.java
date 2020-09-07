package com.qweib.cloud.core.domain;
/**
 *说明：云文件表
 *@创建：作者:llp		创建时间：2016-11-04
 *@修改历史：
 *		[序号](llp	2016-11-04)<修改说明>
 */
public class SysYfile {
	private Integer id;//文件id
	private Integer pid;//上级id
	private Integer memberId;//用户id
	private String fileNm;//文件夹/文件名
	private String tp1;//文件类型(如：mp3,mp4)
	private Integer tp2;//文件位置类型（1自己；2公司;3隐私）
	private Integer tp3;//1文件夹；2文件
	private String ftime;//时间
	
	
	public String getFileNm() {
		return fileNm;
	}
	public void setFileNm(String fileNm) {
		this.fileNm = fileNm;
	}
	public Integer getPid() {
		return pid;
	}
	public void setPid(Integer pid) {
		this.pid = pid;
	}
	public String getTp1() {
		return tp1;
	}
	public void setTp1(String tp1) {
		this.tp1 = tp1;
	}
	public Integer getTp2() {
		return tp2;
	}
	public void setTp2(Integer tp2) {
		this.tp2 = tp2;
	}
	public Integer getTp3() {
		return tp3;
	}
	public void setTp3(Integer tp3) {
		this.tp3 = tp3;
	}
	public String getFtime() {
		return ftime;
	}
	public void setFtime(String ftime) {
		this.ftime = ftime;
	}
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
	
	
}
