package com.qweib.cloud.biz.system.job;

import com.qweib.cloud.biz.common.SysThreadPool;
import com.xxl.job.core.biz.model.ReturnT;
import lombok.extern.slf4j.Slf4j;
import net.sf.cglib.beans.BeanMap;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.http.*;
import org.springframework.http.converter.StringHttpMessageConverter;
import org.springframework.stereotype.Service;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;

import java.nio.charset.StandardCharsets;
import java.util.List;


/**
 * 定时任务服务
 */
@Slf4j
@Service
public class XxlJobService implements InitializingBean {

    @Value("${xxl.job.group}")
    private Integer xxl_job_group = 1;

    @Value("${xxl.job.login.username}")
    private String xxl_user_name = "admin";

    @Value("${xxl.job.login.password}")
    private String xxl_user_password = "123456";

    @Value("${xxl.job.admin.addresses}")
    private String xxl_job_admin_addresses = "";

    //域名
    private String xxl_host = "";
    //登陆接口
    private static final String xxl_host_login = "/login";
    //编辑并启动任务
    private static final String xxl_host_edit_start = "/jobinfo/editAndStart";
    //删除任务
    private static final String xxl_host_remove = "/jobinfo/removeByJobDescExecutorHandler";
    //获取执行器对象
    private static final String xxl_get_group_url = "/jobgroup/getByName?appName=";
    //cookie
    private List<String> cookieList = null;


    /**
     * 删除任务
     *
     * @param jobDesc         描述
     * @param executorHandler 处理类名称extends IJobHandler
     */
    public void removeJob(String jobDesc, String executorHandler) {
        SysThreadPool.threadPool.execute(new Runnable() {
            @Override
            public void run() {
                try {
                    MultiValueMap<String, Object> parameters = new LinkedMultiValueMap<String, Object>();
                    parameters.add("jobGroup", xxl_job_group);
                    parameters.add("jobDesc", jobDesc);
                    parameters.add("executorHandler", executorHandler);
                    //executionRequest(xxl_host_remove, parameters);
                    executionRequest(xxl_host_remove, parameters);
                } catch (Exception e) {
                    log.error("定时任务出现错误", e);
                }
            }
        });

    }

    /**
     * 增加任务
     *
     * @param jobDesc    描述
     * @param time       延时几秒处理
     * @param jobHandler 器处理类名称extends IJobHandler
     * @param param      参数回调时返回
     */
    public void addJob(String jobDesc, Long time, String jobHandler, String param) {
        SysThreadPool.threadPool.execute(new Runnable() {
            @Override
            public void run() {
                try {
                    XxlJobInfo info = new XxlJobInfo();
                    info.setJobGroup(xxl_job_group);
                    //info.setExecutorRouteStrategy("LEAST_FREQUENTLY_USED");//最不经常使用
                    info.setExecutorRouteStrategy("FAILOVER");//故障转移
                    info.setGlueType("BEAN");//运行模式
                    info.setExecutorBlockStrategy("SERIAL_EXECUTION");//单机串行
                    info.setExecutorTimeout(30);//任务执行超时时间，单位秒
                    info.setExecutorFailRetryCount(3);//失败重试次数
                    info.setGlueRemark(" GLUE代码初始化");
                    info.setAuthor("xxl");

                    info.setJobDesc(jobDesc);
                    info.setJobCron(CronDateUtil.getCron(time));
                    info.setExecutorHandler(jobHandler);
                    info.setExecutorParam(param);
                    executionRequest(xxl_host_edit_start, beanToMap(info));
                } catch (Exception e) {
                    log.error("定时任务出现错误", e);
                }
            }
        });
    }

    /**
     * 获取执行器对象
     *
     * @param appName
     */
    public void getGroupId(String appName) {
        //MultiValueMap<String, Object> parameters = new LinkedMultiValueMap<String, Object>();
        //parameters.add("appName", appName);
        ReturnT<String> result = executionRequest(xxl_get_group_url + appName, null);
        System.out.println(result);
    }

    /**
     * 执行请求
     *
     * @param url
     * @param parameters
     * @return
     */
    public ReturnT<String> executionRequest(String url, MultiValueMap<String, Object> parameters) {
        return executionRequest(url, parameters, 0);
    }

    public ReturnT<String> executionRequest(String url, MultiValueMap<String, Object> parameters, int count) {
        HttpHeaders headers = new HttpHeaders();
        //headers.setContentType(MediaType.APPLICATION_JSON_UTF8);
        headers.put(HttpHeaders.COOKIE, login());
        if (headers.get("Cookie") == null)
            throw new RuntimeException("定时任务-登陆失败");
        HttpEntity<MultiValueMap<String, Object>> httpEntity = new HttpEntity(parameters, headers);
        ResponseEntity<ReturnT> resp = getRestTemplate().exchange(xxl_host + url, HttpMethod.POST, httpEntity, ReturnT.class);
        if (resp == null) return null;
        log.info(resp.getBody().toString());
        if (resp.getStatusCode() == HttpStatus.OK)
            return resp.getBody();
        else if (resp.getStatusCode() == HttpStatus.FOUND)//如果出现302跳转时去除cookie重新获取
            setNull();
        if (count < 3) {//出现错误重新次数
            return executionRequest(url, parameters, count++);
        }
        return null;
    }

    /**
     * 将对象装换为map
     *
     * @param bean
     * @return
     */
    public static <T> MultiValueMap<String, Object> beanToMap(T bean) {
        MultiValueMap<String, Object> map = new LinkedMultiValueMap<String, Object>();
        if (bean != null) {
            BeanMap beanMap = BeanMap.create(bean);
            for (Object key : beanMap.keySet()) {
                map.add(key + "", beanMap.get(key));
            }
        }
        return map;
    }


    /**
     * 登陆获取cookie
     *
     * @return
     */
    public List<String> login() {
        if (cookieList != null) return cookieList;
        synchronized (this) {
            try {
                if (cookieList != null) return cookieList;
                HttpHeaders headers = new HttpHeaders();
                headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);
                MultiValueMap<String, String> parameters = new LinkedMultiValueMap<String, String>();
                parameters.add("userName", xxl_user_name);
                parameters.add("password", xxl_user_password);
                RestTemplate restTemplate = new RestTemplate();
                HttpEntity<MultiValueMap<String, Object>> httpEntity = new HttpEntity(parameters, headers);
                ResponseEntity<String> resp = restTemplate.exchange(xxl_host + xxl_host_login, HttpMethod.POST, httpEntity, String.class);
                if (resp.getStatusCode() == HttpStatus.OK)
                    cookieList = resp.getHeaders().get("Set-Cookie");
                else {
                    log.error(resp.getBody());
                }
            } catch (Exception e) {
                log.error("登陆订单任务时出现错误:" + e.getMessage());
            }
        }
        return cookieList;
    }

    /**
     * 如果过期删除cookie
     */
    public void setNull() {
        cookieList = null;
    }

    @Bean
    public RestTemplate getRestTemplate() {
        RestTemplate restTemplate = new RestTemplate();
        //解决中文乱码
        restTemplate.getMessageConverters().set(1, new StringHttpMessageConverter(StandardCharsets.UTF_8));
        return restTemplate;
    }

    /**
     * 加载成功后接口上加上域名
     *
     * @throws Exception
     */
    @Override
    public void afterPropertiesSet() throws Exception {
        xxl_host = xxl_job_admin_addresses.split(",")[0];
        /*xxl_host_login = host + xxl_host_login;
        xxl_host_edit_start = host + xxl_host_edit_start;
        xxl_host_remove = host + xxl_host_remove;*/
        //getGroupId("uglcw-job");
    }
}
