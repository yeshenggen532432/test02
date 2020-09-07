package com.qweib.cloud.core.domain;

public class TheSender {

	/**
	 * 发件人邮箱
	 */
	private String emails;
	/**
	 * 密码
	 */
	private String pwd;
	/**
	 * SMTP
	 */
	private String smtp;
	
	public String getSmtp() {
		return smtp;
	}

	public void setSmtp(String smtp) {
		this.smtp = smtp;
	}

	public String getEmails() {
		return emails;
	}

	public void setEmails(String emails) {
		this.emails = emails;
	}

	public String getPwd() {
		return pwd;
	}

	public void setPwd(String pwd) {
		this.pwd = pwd;
	}
	
	
}
