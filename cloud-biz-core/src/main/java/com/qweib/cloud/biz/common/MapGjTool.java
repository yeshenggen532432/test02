package com.qweib.cloud.biz.common;


import com.qweib.cloud.utils.StrUtil;
import org.springframework.http.*;
import org.springframework.web.client.RestTemplate;

import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;

final public class MapGjTool {
	/**
	 *
	  *摘要：百度轨迹post请求地址
	  *@说明：urls：地址；parameters：参数
	  *@创建：作者:llp		创建时间：2016-3-4
	  *@修改历史：
	  *		[序号](llp	2016-3-4)<修改说明>
	 */
	public static void postMapGjurl(String urls,String parameters){
		try {
			StringBuffer sb = new StringBuffer();
			URL url = new URL(urls);
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
            conn.setRequestProperty("Connection", "Keep-Alive");
            conn.setUseCaches(false);
            conn.setDoOutput(true);
            OutputStreamWriter out = new OutputStreamWriter(conn.getOutputStream(), "UTF-8");
            out.write(parameters);
            out.flush();
            out.close();
            InputStreamReader isr = new InputStreamReader(conn.getInputStream(), "utf-8");
			char[] buffer = new char[10];
			while(isr.read(buffer)!=-1){
				sb.append(buffer);
		    }
		}catch (Exception e) {
			e.printStackTrace();
		}
	}
	/**
	 *
	  *摘要：轨迹post请求地址2
	  *@说明：urls：地址；parameters：参数
	  *@创建：作者:llp		创建时间：2016-3-4
	  *@修改历史：
	  *		[序号](llp	2016-3-4)<修改说明>
	 */
	public static void postMapGjurl2(String urls,String parameters){
		try {
			StringBuilder sb = new StringBuilder();
			URL url = new URL(urls);
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
            conn.setRequestProperty("Connection", "Keep-Alive");
            conn.setUseCaches(false);
            conn.setDoOutput(true);
            OutputStreamWriter out = new OutputStreamWriter(conn.getOutputStream(), "UTF-8");
            out.write(parameters);
            out.flush();
            out.close();
            InputStreamReader isr = new InputStreamReader(conn.getInputStream(), "utf-8");
			char[] buffer = new char[10];
			while(isr.read(buffer)!=-1){
				sb.append(buffer);
		    }

			System.out.println(sb.toString());
		}catch (Exception e) {
			e.printStackTrace();
		}
	}

	public static String postqq(String url,String reqJsonStr){
		try {
			String timestamp=System.currentTimeMillis()+"";
			String noncestr= StrUtil.generateRandomString(16,1);
			String sign="js_ticket="+ StrUtil.encode("MD5", "bb7a1258ecead3f927cf79295165dabb|6f9b9af3cd6e8b8a73c2cdced37fe9f59226e27d")+"&noncestr="+noncestr+"&sign_timestamp="+timestamp+"";
			RestTemplate restTemplate=new RestTemplate();
			HttpHeaders headers = new HttpHeaders();
	        headers.set("X-App-id", "bb7a1258ecead3f927cf79295165dabb");
	        headers.set("X-App-sign", StrUtil.encode("SHA1",sign));
	        headers.set("X-Sign-timestamp", timestamp);
	        headers.set("X-Sign-noncestr", noncestr);
	        MediaType type2 = MediaType.parseMediaType("application/json; charset=UTF-8");
	        headers.setContentType(type2);
	        HttpEntity<String> entity = new HttpEntity<String>(reqJsonStr,headers);
	        ResponseEntity<String> resp = restTemplate.exchange(url, HttpMethod.POST, entity, String.class);//这里放JSONObject, String 都可以。因为JSONObject返回的时候其实也就是string
	        return resp.getBody().toString();
		}catch (Exception e) {
			e.printStackTrace();
		}
		return "";
	}
	public static void main(String[] args) {
		try {
		//String reqJsonStr="{\"username\":\"13500008899\", \"password\":\"123456\"}";
		//System.out.println(postqq("http://openapi.uglcw.datasir.com/cli/user/login",reqJsonStr));
		//String reqJsonStr="{\"user_id\":\"13500008899\", \"token\":\"be96771a02ff6125d544447863b40937\"}";
		//System.out.println(postqq("http://openapi.uglcw.datasir.com/index/checkUserToken",reqJsonStr));
		//System.out.println((new sun.misc.BASE64Encoder()).encode("测试".getBytes()));
		}catch (Exception e) {
			e.printStackTrace();
		}
	}
}
