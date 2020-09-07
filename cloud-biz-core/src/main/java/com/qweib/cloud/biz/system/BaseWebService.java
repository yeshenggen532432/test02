package com.qweib.cloud.biz.system;


import com.qweib.cloud.biz.common.GeneralControl;
import com.qweib.cloud.core.domain.OnlineMessage;
import org.apache.poi.ss.formula.functions.T;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.http.HttpServletResponse;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


/**
 * 基础相应类
 *
 * @author hanwei
 */
public class BaseWebService extends GeneralControl {
    public final static String ERROR_PARAM = "参数不完整";
    public Logger log = LoggerFactory.getLogger(BaseWebService.class.getName());

    public Map<String, Object> sendWarm(String msg) {
        Map<String, Object> result = new HashMap<>();
        result.put("state", false);
        result.put("msg", msg);
        return result;
    }

    public Map<String, Object> sendSuccess(String msg) {
        Map<String, Object> result = new HashMap<>();
        result.put("state", true);
        result.put("msg", msg);
        return result;
    }

    public Map<String, Object> sendSuccess(String msg, Object o) {
        Map<String, Object> result = new HashMap<>();
        result.put("state", true);
        result.put("msg", msg);
        result.put("data", o);
        return result;
    }

    public Map<String, Object> sendSuccess(String msg, List list) {
        Map<String, Object> result = new HashMap<>();
        result.put("state", true);
        result.put("msg", msg);
        result.put("list", list);
        return result;
    }

    public void sendWarm(HttpServletResponse response, String msg) {
        this.sendJsonResponse(response, "{\"state\":false,\"msg\":\"" + msg + "\"}");
    }

    public void sendException(HttpServletResponse response, Exception e) {
        this.log.error("操作异常", e);
        this.sendJsonResponse(response, "{\"state\":false,\"msg\":\"操作出现异常(详细："
                + e.getMessage() + ")\"}");
    }

    public boolean checkParam(HttpServletResponse response, Object... params) {
        for (Object object : params) {
            if (object instanceof String) {
                if (null == object || "".equals(object.toString().trim())) {
                    this.sendJsonResponse(response, "{\"state\":false,\"msg\":\"" + ERROR_PARAM + "\",\"message\":\"" + ERROR_PARAM + "\"}");
                    return false;
                }
            } else {
                if (null == object) {
                    this.sendJsonResponse(response, "{\"state\":false,\"msg\":\"" + ERROR_PARAM + "\",,\"message\\\":\"" + ERROR_PARAM + "\"}");
                    return false;
                }
            }
        }
        return true;
    }

    public boolean checkLoginState(HttpServletResponse response, String token) {
        OnlineMessage message = TokenServer.tokenCheck(token);
        if (message.isSuccess()) {
            return true;
        } else {
            sendWarm(response, message.getMessage());
            return false;
        }
    }

    public void sendSuccess(HttpServletResponse response, String msg) {
        this.sendJsonResponse(response, "{\"state\":true,\"msg\":\"" + msg + "\"}");
    }
	/*public String getDateBase(String token){
		OnlineUser user = TokenServer.tokenCheck(token).getOnlineMember();
		return user==null?null:user.getDatabase();
	}*/
}
