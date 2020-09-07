package com.qweib.cloud.biz.system.support;

import com.qweib.cloud.core.domain.OnlineMessage;
import com.qweib.cloud.core.domain.OnlineUser;

public interface TokenServerAdapter {

    void  tokenCreated(OnlineUser onlineMember, String type);
    void tokenDestroyed(OnlineUser member);
    void tokenDestroyed(Integer memId);
    OnlineMessage tokenCheck(String token);
    boolean checkLoginState(Integer usrId);
    void updateToken(OnlineUser onlineUser);
    void updateToken(String token, String database, String memberNm, String memberMobile);
    void updateDatasource(String database, Integer memId);

}
