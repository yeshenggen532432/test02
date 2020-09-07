package com.qweib.cloud.biz.system;


import com.qweib.cloud.biz.system.support.TokenServerAdapter;
import com.qweib.cloud.core.domain.OnlineMessage;
import com.qweib.cloud.core.domain.OnlineUser;
import com.qweib.cloud.core.domain.TheSender;
import com.qweib.cloud.utils.SpringContextHolder;

import java.io.IOException;
import java.io.InputStream;
import java.util.*;


/**
 * 客户端Token服务类.
 *
 * @author lhq
 * @see
 * @since JDK 1.6
 */
public class TokenServer {

    private static List<Map<String, Object>> codes = new ArrayList<Map<String, Object>>();
    private static TheSender emails;

    public static void tokenCreated(OnlineUser onlineMember, String type) {
        TokenServerAdapter adapter = SpringContextHolder.getBean(TokenServerAdapter.class);
        adapter.tokenCreated(onlineMember, type);
    }

    public static void tokenDestroyed(OnlineUser member) {
        TokenServerAdapter adapter = SpringContextHolder.getBean(TokenServerAdapter.class);
        adapter.tokenDestroyed(member);
    }

    public static void tokenDestroyed(Integer memId) {
        TokenServerAdapter adapter = SpringContextHolder.getBean(TokenServerAdapter.class);
        adapter.tokenDestroyed(memId);
    }
    
    
   /* public static boolean checkLoginState(OnlineUser onlineUser){
    	 if (onlineUserList != null && onlineUserList.size() > 0) {
             // 判断该用户是否已经登录
             for (OnlineUser onlineMember : onlineUserList) {
                 if (onlineMember != null && onlineMember.getId()!=null&&onlineMember.getId().intValue()==onlineUser.getId().intValue()){
                	 return false;
                 }
             }
         }
    	 return true;
    }*/

    public static OnlineMessage tokenCheck(String token) {
        TokenServerAdapter adapter = SpringContextHolder.getBean(TokenServerAdapter.class);
        return adapter.tokenCheck(token);
    }

    //登录时判断是否有重复登录，重复删除前一个登录记录
    public static boolean checkLoginState(Integer usrId) {
        TokenServerAdapter adapter = SpringContextHolder.getBean(TokenServerAdapter.class);
        return adapter.checkLoginState(usrId);
    }

    public static void updateToken(OnlineUser onlineUser){
        TokenServerAdapter adapter = SpringContextHolder.getBean(TokenServerAdapter.class);
        adapter.updateToken(onlineUser);
    }

    //修改token信息
    public static void updateToken(String token, String database, String memberNm, String memberMobile) {
        TokenServerAdapter adapter = SpringContextHolder.getBean(TokenServerAdapter.class);
        adapter.updateToken(token, database, memberNm, memberMobile);
    }

    //根据memId修改token信息
    public static void updateDatasource(String database, Integer memId) {
        TokenServerAdapter adapter = SpringContextHolder.getBean(TokenServerAdapter.class);
        adapter.updateDatasource(database, memId);
    }

    public static TheSender getEmail() {
        if (emails == null) {
            emails = new TheSender();
            Properties props = new Properties();
            InputStream inputStream = TokenServer.class
                    .getResourceAsStream("/" + "jdbc.properties");
            try {
                props.load(inputStream);
                String email = props.getProperty("EMAIL");
                String pwd = props.getProperty("EMAILPWD");
                String smtp = props.getProperty("SMTP");
                emails.setEmails(email);
                emails.setPwd(pwd);
                emails.setSmtp(smtp);
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                try {
                    inputStream.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
        return emails;
    }

    public static void addCode(String code, String mobile) {
        for (int i = 0; i < codes.size(); i++) {
            if (mobile.equals(codes.get(i).get("mobile"))) {
                codes.remove(i);
            }
        }
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("code", code);
        map.put("mobile", mobile);
        map.put("time", new Date());
        codes.add(map);
    }

    public static boolean checkCode(String code, String mobile) {
        boolean falg = false;
        Date startTime = new Date();
        if (codes != null && codes.size() > 0) {
            for (int i = 0; i < codes.size(); i++) {
                Date endTime = (Date) codes.get(i).get("time");
                long time = endTime.getTime() - startTime.getTime();
                long minutes = time / 60000;
                if (minutes > 10) {
                    codes.remove(i);
                    ;
                }
                if (code.equals(codes.get(i).get("code")) && mobile.equals(codes.get(i).get("mobile"))) {
                    falg = true;
                }
            }
        }
        return falg;
    }
}
