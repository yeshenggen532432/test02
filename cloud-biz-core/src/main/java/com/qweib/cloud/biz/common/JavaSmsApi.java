package com.qweib.cloud.biz.common;


import lombok.extern.slf4j.Slf4j;
import org.apache.http.HttpEntity;
import org.apache.http.NameValuePair;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.util.EntityUtils;

import java.io.IOException;
import java.net.URISyntaxException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.Callable;

/**
 * 短信http接口的java代码调用示例
 * 基于Apache HttpClient 4.3
 *
 * @author songchao
 * @since 2015-04-03
 */
@Slf4j
public class JavaSmsApi {

    // 查账户信息的http地址
    private static String URI_GET_USER_INFO = "http://yunpian.com/v1/user/get.json";

    //通用发送接口的http地址
    private static String URI_SEND_SMS = "http://yunpian.com/v1/sms/send.json";

    // 模板发送接口的http地址
    private static String URI_TPL_SEND_SMS = "http://yunpian.com/v1/sms/tpl_send.json";

    // 发送语音验证码接口的http地址
    private static String URI_SEND_VOICE = "http://yunpian.com/v1/voice/send.json";

    //批量发送接口
    private static final String BATCH_SEND_URL = "https://sms.yunpian.com/v2/sms/batch_send.json";

    //编码格式。发送编码格式统一用UTF-8
    private static String ENCODING = "UTF-8";

    //apikey
    //private static String apikey = "f03f6d8494737a50e6052a3d368d9719";
    private static String apikey = "e03928bd964796248bc74f39cbfc7cc6";

    public static final String sign = "【驰用T3】";

    /**
     * 取账户信息
     *
     * @return json格式字符串
     * @throws IOException
     */
    public static String getUserInfo(String apikey) throws IOException, URISyntaxException {
        Map<String, String> params = new HashMap<String, String>();
        params.put("apikey", apikey);
        return post(URI_GET_USER_INFO, params);
    }

    /**
     * 通用接口发短信
     *
     * @param text   　短信内容
     * @param mobile 　接受的手机号
     * @return json格式字符串
     * @throws IOException
     */
    public static String sendSms(String text, String mobile) throws IOException {
        Map<String, String> params = new HashMap<String, String>();
        params.put("apikey", apikey);
        params.put("text", text);
        params.put("mobile", mobile);
        return post(URI_SEND_SMS, params);
    }

    /**
     * 通过模板发送短信(不推荐)
     *
     * @param apikey    apikey
     * @param tpl_id    　模板id
     * @param tpl_value 　模板变量值
     * @param mobile    　接受的手机号
     * @return json格式字符串
     * @throws IOException
     */
    public static String tplSendSms(String apikey, long tpl_id, String tpl_value, String mobile) throws IOException {
        Map<String, String> params = new HashMap<String, String>();
        params.put("apikey", apikey);
        params.put("tpl_id", String.valueOf(tpl_id));
        params.put("tpl_value", tpl_value);
        params.put("mobile", mobile);
        return post(URI_TPL_SEND_SMS, params);
    }

    /**
     * 通过接口发送语音验证码
     *
     * @param apikey apikey
     * @param mobile 接收的手机号
     * @param code   验证码
     * @return
     */
    public static String sendVoice(String apikey, String mobile, String code) {
        Map<String, String> params = new HashMap<String, String>();
        params.put("apikey", apikey);
        params.put("mobile", mobile);
        params.put("code", code);
        return post(URI_SEND_VOICE, params);
    }

    /**
     * 基于HttpClient 4.3的通用POST方法
     *
     * @param url       提交的URL
     * @param paramsMap 提交<参数，值>Map
     * @return 提交响应
     */
    public static String post(String url, Map<String, String> paramsMap) {
        CloseableHttpClient client = HttpClients.createDefault();
        String responseText = "";
        CloseableHttpResponse response = null;
        try {
            HttpPost method = new HttpPost(url);
            if (paramsMap != null) {
                List<NameValuePair> paramList = new ArrayList<NameValuePair>();
                for (Map.Entry<String, String> param : paramsMap.entrySet()) {
                    NameValuePair pair = new BasicNameValuePair(param.getKey(), param.getValue());
                    paramList.add(pair);
                }
                method.setEntity(new UrlEncodedFormEntity(paramList, ENCODING));
            }
            response = client.execute(method);
            HttpEntity entity = response.getEntity();
            if (entity != null) {
                responseText = EntityUtils.toString(entity);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                response.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return responseText;
    }


    public static void main(String[] args) throws IOException, URISyntaxException {
        //修改为您的apikey.apikey可在官网（http://www.yuanpian.com)登录后用户中心首页看到
        //修改为您要发送的手机号
        //String mobile = "13950101145";

        /**************** 查账户信息调用示例 *****************/
//        System.out.println(JavaSmsApi.getUserInfo(apikey));

        /**************** 使用通用接口发短信(推荐) *****************/
        //设置您要发送的内容(内容必须和某个模板匹配。以下例子匹配的是系统提供的1号模板）
        String text = "【驰用T3】您的验证码是623598";
        //发短信调用示例
        //String sendSms = JavaSmsApi.sendSms(text, mobile);
        //System.out.println(sendSms);
        //JSONObject obj = JSONObject.fromObject(sendSms);

//		  System.out.println(obj.get("code"));

        /* *//**************** 使用模板接口发短信(不推荐，建议使用通用接口) *****************//*
        //设置模板ID，如使用1号模板:【#company#】您的验证码是#code#
        long tpl_id = 1;
        //设置对应的模板变量值
        //如果变量名或者变量值中带有#&=%中的任意一个特殊符号，需要先分别进行urlencode编码
        //如code值是#1234#,需作如下编码转换
        String codeValue = URLEncoder.encode("#1234#", ENCODING);
        String tpl_value = "#code#=" + codeValue + "&#company#=云片网";
        //模板发送的调用示例
        System.out.println(JavaSmsApi.tplSendSms(apikey, tpl_id, tpl_value, mobile));

        *//**************** 使用接口发语音验证码 *****************//*
        String code = "1234";
        System.out.println(JavaSmsApi.sendVoice(apikey, mobile ,code));*/
        //System.out.println(batchSend("【驰用T3】会员:xxx,订单支付成功订单号:xxx", "15959295957"));
        List<String> list = new ArrayList<>();
        list.add("aa");
        list.add("bb");
        list.add("cc");
        System.out.println(String.join(",", list));
    }

    /**
     * 批量发送短信,相同内容多个号码,智能匹配短信模板
     *
     * @param text   需要使用已审核通过的模板或者默认模板
     * @param mobile 接收的手机号,多个手机号用英文逗号隔开
     * @return json格式字符串
     */
    public static void batchSend(String text, String mobile) {
        Map<String, String> params = new HashMap<String, String>();//请求参数集合
        params.put("apikey", apikey);
        params.put("text", text);
        params.put("mobile", mobile);
        //return post(BATCH_SEND_URL, params);//请自行使用post方式请求,可使用Apache HttpClient
        SysThreadPool.threadPool.submit(new SmsThread(BATCH_SEND_URL, params));
    }

    public static class SmsThread implements Callable<String> {
        private Map<String, String> params;
        private String url;

        public SmsThread(String url, Map<String, String> params) {
            this.params = params;
            this.url = url;
        }

        @Override
        public String call() throws Exception {
            String str = post(url, params);
            log.info("短信返回：" + str);
            return str;
        }
    }
}