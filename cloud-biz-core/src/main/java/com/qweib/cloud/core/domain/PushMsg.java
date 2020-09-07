package com.qweib.cloud.core.domain;

import java.util.HashMap;
import java.util.Map;

/**
 * 推送消息
 * @author 吴进 by 20150714
 *
 */
public class PushMsg {
	private Object info;		// 信息
	private Boolean status;		// 状态
	private int arg1;			// 附加值
	//test
	private Map<String, Object> attr = new HashMap<String, Object>();

	public PushMsg() {}

	public PushMsg(String info, Boolean status) {
		this.info = info;
		this.status = status;
	}

	public Object getInfo() {
		return info;
	}

	public void setInfo(Object info) {
		this.info = info;
	}

	public Boolean getStatus() {
		return status;
	}

	public void setStatus(Boolean status) {
		this.status = status;
	}

	public int getArg1() {
		return arg1;
	}

	public void setArg1(int arg1) {
		this.arg1 = arg1;
	}
	
	/** 
	 * 加入反馈属性
	 * @return
	 */
	public Map<String, Object> getAttr() {
		return attr;
	}

	public void setAttr(Map<String, Object> attr) {
		this.attr = attr;
	}

	/**
	 * 得到消息对象
	 * @param info
	 * @param status
	 * @return
	 */
	public static PushMsg getPushMsg(String info, Boolean status) {
		PushMsg msg = new PushMsg();
		msg.setInfo(info);
		msg.setStatus(status);
		return msg;
	}

}
