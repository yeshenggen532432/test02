package com.qweib.cloud.biz.common;


import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.Map;


public class CnlifeThread implements Runnable {
	
	public static Logger log = LoggerFactory.getLogger(CnlifeThread.class.getName());
	
	private Long timemillis ;
	private String finalMobil;
	private String content;
	private Map<String, Object> map ;
	private Integer sleepTime;
	private String title;

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public CnlifeThread(Long timemillis, String finalMobil,
			String title,String content,Map<String, Object> map, Integer sleepTime) {
		this.timemillis = timemillis;
		this.finalMobil = finalMobil;
		this.content = content;
		this.map = map;
		this.title = title;
		this.sleepTime = sleepTime;
	}
	
	public CnlifeThread() {
		
	}

	public Integer getSleepTime() {
		return sleepTime;
	}
	public void setSleepTime(Integer sleepTime) {
		this.sleepTime = sleepTime;
	}

	public Long getTimemillis() {
		return timemillis;
	}

	public void setTimemillis(Long timemillis) {
		this.timemillis = timemillis;
	}

	public String getFinalMobil() {
		return finalMobil;
	}

	public void setFinalMobil(String finalMobil) {
		this.finalMobil = finalMobil;
	}


	public Map<String, Object> getMap() {
		return map;
	}

	public void setMap(Map<String, Object> map) {
		this.map = map;
	}

	public void run() {
		JPushClientUtil.jPushMessage(timemillis.intValue(), finalMobil, title, content, map,null);
		try {
			Thread.sleep(sleepTime);
		 log.info("线程"+Thread.currentThread().getName());
		} catch (InterruptedException e) {
			log.error("线程循环推送异常处理", e);
		}
	}

}
