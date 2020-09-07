package com.qweib.cloud.biz.system.support;

import cn.jpush.api.utils.StringUtils;
import com.qweib.cloud.biz.common.TokenContext;
import com.qweib.cloud.core.domain.OnlineMessage;
import com.qweib.cloud.core.domain.OnlineUser;
import com.qweib.cloud.core.domain.constants.Global;
import com.qweib.cloud.utils.Collections3;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.data.redis.core.RedisTemplate;

import java.util.Date;
import java.util.Objects;
import java.util.Set;
import java.util.concurrent.TimeUnit;

public class InRedisTokenServerAdapter implements TokenServerAdapter {
    private static final String TOKEN_PREFIX = "tokens:";
    private static final String USER_TOKEN_PREFIX = "user_tokens:";

    @Autowired
    @Qualifier("jsonRedisTemplate")
    private RedisTemplate redisTemplate;

    private String getKey(OnlineUser user) {
        if (user.getMemId() != null) {
            return String.valueOf(user.getMemId());
        }
        return user.getOpenId();
    }

    @Override
    public void tokenCreated(OnlineUser onlineMember, String type) {
        onlineMember.setAccessTime(new Date());
        removeIndex(onlineMember);

        boolean needSso = DevicePresenceHelper.needSso(type);
        if (needSso) {
            Set<String> previousTokens = redisTemplate.opsForSet().members(USER_TOKEN_PREFIX + getKey(onlineMember));
            if (Collections3.isNotEmpty(previousTokens)) {
                for (String previousToken : previousTokens) {
                    OnlineUser previewLoginUser = (OnlineUser) redisTemplate.opsForValue().get(TOKEN_PREFIX + previousToken);
                    //标记token已失效
                    if (previewLoginUser != null) {
                        previewLoginUser.setTel(null);
                        previewLoginUser.setPresence(Global.PRESENCE_KICKED_OFF);
                        redisTemplate.opsForValue().set(TOKEN_PREFIX + previousToken, previewLoginUser, 1, TimeUnit.DAYS);
                    }
                    //移除token
                    redisTemplate.opsForSet().remove(USER_TOKEN_PREFIX + getKey(onlineMember), previousToken);
                }
            }
        }
        redisTemplate.opsForValue().set(TOKEN_PREFIX + onlineMember.getToken(), onlineMember, 7, TimeUnit.DAYS);
        if(needSso) {
            redisTemplate.opsForSet().add(USER_TOKEN_PREFIX + getKey(onlineMember), onlineMember.getToken());
        }
    }

    @Override
    public void tokenDestroyed(Integer memId) {
        Set<String> previousTokens = redisTemplate.opsForSet().members(USER_TOKEN_PREFIX + memId);
        if (Collections3.isNotEmpty(previousTokens)) {
            for (String previousToken : previousTokens) {
                redisTemplate.delete(TOKEN_PREFIX + previousToken);
                redisTemplate.opsForSet().remove(USER_TOKEN_PREFIX + memId, previousToken);
            }
        }
    }

    //尝试清除未注册前的token索引
    private void removeIndex(OnlineUser user) {
        if (user != null && user.getMemId() != null && StringUtils.isNotEmpty(user.getOpenId())) {
            redisTemplate.delete(USER_TOKEN_PREFIX + user.getOpenId());
        }
    }


    @Override
    public void tokenDestroyed(OnlineUser member) {

        redisTemplate.delete(TOKEN_PREFIX + member.getToken());
        redisTemplate.opsForSet().remove(USER_TOKEN_PREFIX + member.getMemId(), member.getToken());
        //onlineUserList.remove(member);
    }

    @Override
    public OnlineMessage tokenCheck(String token) {
        OnlineMessage onlineMessage = new OnlineMessage();
        onlineMessage.setSuccess(false);

        if (StringUtils.isEmpty(token)) {
            OnlineMessage existToken = TokenContext.getToken();
            return existToken == null ? onlineMessage : existToken;
        }

        OnlineUser user = (OnlineUser) redisTemplate.opsForValue().get(TOKEN_PREFIX + token);
        if (user == null) {
            onlineMessage.setMessage("请先登录系统");
            return onlineMessage;
        }


        if (Objects.equals(user.getPresence(), Global.PRESENCE_KICKED_OFF)) {
            onlineMessage.setMessage("此账号在异地登陆");
            //删除当前token
            redisTemplate.delete(TOKEN_PREFIX + token);
            return onlineMessage;
        }

        onlineMessage.setSuccess(true);
        onlineMessage.setOnlineMember(user);
        return onlineMessage;
    }

    @Override
    public boolean checkLoginState(Integer usrId) {
        //no need to check this
        return true;
    }

    @Override
    public void updateToken(OnlineUser onlineUser) {
        redisTemplate.opsForValue().set(TOKEN_PREFIX + onlineUser.getToken(), onlineUser, 7, TimeUnit.DAYS);
    }

    @Override
    public void updateToken(String token, String database, String memberNm, String memberMobile) {
        OnlineUser onlineMember = (OnlineUser) redisTemplate.opsForValue().get(TOKEN_PREFIX + token);
        if (onlineMember != null) {
            if (null != database) {
                if (null == onlineMember.getDatabase() || !onlineMember.getDatabase().equals(database)) {
                    onlineMember.setDatabase(database);
                }
            }
            if (null != memberNm) {
                onlineMember.setMemberNm(memberNm);
            }
            if (null != memberMobile) {
                onlineMember.setTel(memberMobile);
            }
            redisTemplate.opsForValue().set(TOKEN_PREFIX + token, onlineMember, 7, TimeUnit.DAYS);
        }
    }

    @Override
    public void updateDatasource(String database, Integer memId) {
        Set<String> tokens = redisTemplate.opsForSet().members(USER_TOKEN_PREFIX + memId);
        if (Collections3.isNotEmpty(tokens)) {
            for (String token : tokens) {
                OnlineUser onlineMember = (OnlineUser) redisTemplate.opsForValue().get(TOKEN_PREFIX + token);
                if (onlineMember != null) {
                    onlineMember.setDatabase(database);
                    redisTemplate.opsForValue().set(TOKEN_PREFIX + token, onlineMember, 7, TimeUnit.DAYS);
                }
            }
        }
    }
}
