package com.qweib.cloud.web;

import com.qweib.cloud.biz.system.UserContext;
import com.qweib.cloud.core.domain.SysLoginInfo;
import com.qweib.cloud.support.rongcloud.RongCloudTemplate;
import com.qweib.commons.StringUtils;
import com.qweibframework.commons.web.BaseController;
import com.qweibframework.commons.web.dto.Response;
import io.rong.models.response.TokenResult;
import io.rong.models.user.UserModel;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * @author: jimmy.lin
 * @time: 2019/12/18 17:07
 * @description:
 */
@RestController
@RequestMapping({"manager/rongcloud", "web/rongcloud"})
public class RongCloudApiController extends BaseController {

    @Autowired
    private RongCloudTemplate rongCloud;
    @Autowired
    @Qualifier("stringRedisTemplate")
    private StringRedisTemplate redisTemplate;


    @GetMapping("token")
    public Response getToken() {
        SysLoginInfo principal = UserContext.getLoginInfo();
        Integer id = principal.getIdKey();
        String token = redisTemplate.opsForValue().get("rongcloud:token:" + id);
        if (StringUtils.isEmpty(token)) {
            UserModel user = new UserModel(
                    String.valueOf(id),
                    principal.getUsrNm(),
                    "http://static.t.qweib.com/publicplat/app-logo.png"
            );
            TokenResult tokenResult = rongCloud.execute(rc -> rc.user.register(user));
            token = tokenResult.getToken();
            redisTemplate.opsForValue().set("rongcloud:token:" + id, token);
        }
        return success(token);
    }


}
