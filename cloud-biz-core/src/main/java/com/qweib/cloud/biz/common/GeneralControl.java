package com.qweib.cloud.biz.common;

import com.qweib.cloud.core.domain.PushMsg;
import com.qweib.cloud.core.domain.SysLoginInfo;
import com.qweib.cloud.utils.JsonUtil;
import com.qweib.cloud.utils.StrUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * 说明：
 *
 * @创建：作者:yxy 创建时间：2013-4-8
 * @修改历史： [序号](yxy 2013 - 4 - 8)<修改说明>
 */
public class GeneralControl {

    public Logger log = LoggerFactory.getLogger(GeneralControl.class);

    @Autowired
    public RedisTemplate redisTemplate;

    private static PushMsg pushMsg = new PushMsg();

    /**
     * 摘要：
     *
     * @param request
     * @return
     * @说明：获取登录信息
     * @创建：作者:yxy 创建时间：2013-4-11
     * @修改历史： [序号](yxy 2013 - 4 - 11)<修改说明>
     */
    public SysLoginInfo getLoginInfo(HttpServletRequest request) {
        SysLoginInfo vo1 =  (SysLoginInfo) request.getSession().getAttribute("usr");
        SysLoginInfo vo2 = getLoginVo(vo1.getToken());
        if(vo2 == null)
        {
            request.getSession().invalidate();
            //return null;
        }
        return vo1;
    }

    protected void setLoginInfo(HttpServletRequest request, SysLoginInfo info) {
        request.getSession().setAttribute("usr", info);
        setLoginVo(info);
    }

    public void setLoginVo(SysLoginInfo vo)
    {
        String keyName = "APILogin";
        this.redisTemplate.opsForZSet().removeRangeByScore(keyName, vo.getIdKey(), vo.getIdKey());
        this.redisTemplate.opsForZSet().add(keyName, vo,vo.getIdKey());
    }

    public SysLoginInfo getLoginVo(String token)
    {
        String []str = token.split("-");
        if(str.length!= 2)
        {
            return null;
        }
        Long memId = Long.parseLong(str[1]);
        String keyName = "APILogin";

        Integer maxId = 999999;
        Set<Object> loginList = redisTemplate.opsForZSet().rangeByScore(keyName, memId, memId);
        for(Object obj: loginList)
        {
            SysLoginInfo vo = (SysLoginInfo)obj;
            if(vo.getToken().equals(token))
            {
                return vo;
            }
        }
        return null;
    }

    // 向页面发送信息HTML格式
    public void sendHtmlResponse(HttpServletResponse response, String html) {
        response.setContentType("text/html;charset=UTF-8");
        try {
            PrintWriter pw = response.getWriter();
            pw.print(html);
            pw.flush();
            pw.close();
        } catch (IOException e) {
            log.error("sendHtmlResponse error", e);
        }
    }

    // 向页面发送信息JSON格式
    public void sendJsonResponse(HttpServletResponse response, String str) {
        try {
            response.setContentType("application/json;charset=UTF-8");
            PrintWriter out = response.getWriter();
            out.println(str);
            out.flush();
            out.close();
        } catch (IOException e) {
            log.error("sendJsonResponse error", e);
            throw new RuntimeException(e.getMessage(), e);
        }
    }

    /**
     * 获得响应返回的信息（json格式字符串）
     *
     * @param state 转态（true:成功  false:失败）
     * @param msg   提示信息
     * @param key   参数的键
     * @param value 参数的值
     *              备注：key与value要一一对应
     * @return
     */
    @SuppressWarnings("unchecked")
    public String getJsonResponseStr(boolean state, String msg, String[] key, Object[] value) {
        try {
            Map map = new HashMap();
            map.put("state", state);
            map.put("msg", msg);
            if (key != null && value != null && key.length == value.length) {
                for (int i = 0; i < key.length; i++) {
                    map.put(key[i], value[i]);
                }
            }
            return JsonUtil.getJsonStringFromMap(map);
        } catch (Exception e) {
            log.error("error", e);
            return "{\"state\":false,\"msg\":\"调用出错！\"}";
        }
    }


    /**
     * 上传图片保存
     *
     * @param request
     * @param savepath 文件保存路径
     * @return List上传的所有图片的路径
     * @throws Exception
     */
    public List<Map<String, String>> uploadFile(HttpServletRequest request, String savepath, String time) throws Exception {
        DecimalFormat df = new DecimalFormat("0.0");
        // 转型为MultipartHttpRequest：
        MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest) request;
        /**
         * 先检查保存的目录是否存在
         */
        File dirPath = new File(savepath);
        if (!dirPath.exists()) {
            dirPath.mkdirs();
        }
        List<Map<String, String>> pictures = new ArrayList<Map<String, String>>();
        for (Iterator it = multipartRequest.getFileNames(); it.hasNext(); ) {
            Map<String, String> map = new HashMap<String, String>();
            String key = (String) it.next();
            MultipartFile orderFile = multipartRequest.getFile(key);
            String realname = orderFile.getOriginalFilename();
            if (realname.length() > 0) {
                String ext = realname.substring(realname.lastIndexOf("."));
                String filename = System.currentTimeMillis() + StrUtil.generateRandomString(5, 2) + ext;
                String desc = dirPath + File.separator + filename;
                File destFile = new File(desc);
                orderFile.transferTo(destFile);
                File test = new File(desc);
                double fc = test.length();
                map.put("name", realname);
                map.put("path", time + "/" + filename);
                String fsize = null;
                if (fc / 1000 < 1) {
                    fsize = "1KB";
                } else if (fc / 1000 < 1000) {
                    fsize = String.valueOf(df.format(fc / 1000)) + "KB";
                } else if ((fc / 1000) / 1000 < 1000) {
                    fsize = String.valueOf(df.format((fc / 1000) / 1000)) + "MB";
                } else {
                    fsize = String.valueOf(df.format(((fc / 1000) / 1000) / 1000)) + "G";
                }
                map.put("fsize", fsize);
                pictures.add(map);
            }
        }
        return pictures;
    }

    /**
     * 删除图片
     */
    public void delFile(String path) {
        File file = new File(path);
        if (file != null) {
            if (file.exists()) {
                file.delete();
            }
        }
    }

    /**
     * 说明：获取ip地址
     * 作者：yxy       日期：2014-3-12
     *
     * @param request
     * @return
     */
    public String getIpAddr(HttpServletRequest request) {
        String ip = request.getHeader("x-forwarded-for");
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("Proxy-Client-IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("WL-Proxy-Client-IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getRemoteAddr();
        }
        return ip;
    }

    public String getPathTemporary(HttpServletRequest request) {
        return request.getSession().getServletContext().getRealPath("/temporary/");
    }

    public String getPathUpload(HttpServletRequest request) {
        return request.getSession().getServletContext().getRealPath("/upload/");
    }

    public SysLoginInfo getInfo(HttpServletRequest request) {
        return (SysLoginInfo) request.getSession().getAttribute("usr");
    }

    public String getDate() {
        return new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date());
    }

    public String getFilePath() {
        return "attachment";
    }

    /* @author吴进 by 20150714 ********************************/

    /**
     * 推送消息到客户端
     *
     * @param info
     * @param status
     * @return
     */
    public static PushMsg pushMsg(Object info, Boolean status) {
        pushMsg.setArg1(0);//默认值
        pushMsg.setInfo(info);
        pushMsg.setStatus(status);
        return pushMsg;
    }

    /**
     * 推送消息到客户端
     *
     * @param info
     * @param status
     * @param entrys 附加属性值，Key：Value
     * @return
     */
    public static PushMsg pushMsg(Object info, Boolean status, Object... entrys) {
        pushMsg.setArg1(0);//默认值
        pushMsg.setInfo(info);
        pushMsg.setStatus(status);
        for (int i = 0; i < entrys.length; i += 2) {
            pushMsg.getAttr().put(String.valueOf(entrys[i]), entrys[i + 1]);
        }
        return pushMsg;
    }

    /**
     * 推送消息到客户端
     *
     * @param info
     * @param status
     * @return
     */
    public static PushMsg pushMsg(Object info, Boolean status, int arg1) {
        pushMsg.setArg1(arg1);//自定义值
        pushMsg.setInfo(info);
        pushMsg.setStatus(status);
        return pushMsg;
    }
    /* @author吴进 by 20150714 End ********************************/

    /**
     * 成功返回
     *
     * @param response
     * @param msg
     */
    public void sendSuccess(HttpServletResponse response, String msg) {
        this.sendJsonResponse(response, "{\"state\":true,\"msg\":\"" + msg + "\"}");
    }

    /**
     * 失败返回
     *
     * @param response
     * @param msg
     */
    public void sendWarm(HttpServletResponse response, String msg) {
        this.sendJsonResponse(response, "{\"state\":false,\"msg\":\"" + msg + "\"}");
    }

}
