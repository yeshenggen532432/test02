package com.qweib.cloud.core.domain;
import java.util.HashMap;
import java.util.Map;


public class SnCal {
	public Map<String, String> onTrackAttrCallback() {
		Map<String, String> paramsMap = new HashMap<String, String>();
		paramsMap.put("address", "百度大厦");
        //method()为开发者自定义方法，返回实时轨迹属性数据
	    return paramsMap;
	}
}
