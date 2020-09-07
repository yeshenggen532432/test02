package com.qweib.cloud.web;

import com.qweib.cloud.biz.system.UserContext;
import com.qweib.cloud.biz.system.support.DevicePresenceHelper;
import com.qweib.cloud.biz.system.support.TokenServerAdapter;
import com.qweib.cloud.core.domain.OnlineUser;
import com.qweib.cloud.core.domain.SysLoginInfo;
import com.qweib.commons.Identities;
import com.qweib.commons.mapper.BeanMapper;
import com.qweib.commons.mapper.JsonMapper;
import com.qweibframework.commons.web.BaseController;
import com.qweibframework.commons.web.dto.Response;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * @author jimmy.lin
 * create at 2020/3/9 15:49
 */
@RestController
@RequestMapping({"manager/user", "web/user"})
public class UserApiController extends BaseController {

    @Autowired
    private TokenServerAdapter tokenServerAdapter;

    @GetMapping("principal")
    public Response principal() {
        return success(UserContext.getLoginInfo());
    }

    @GetMapping("token")
    public Response cookieToToken(){
        SysLoginInfo info = UserContext.getLoginInfo();
        OnlineUser onlineUser = BeanMapper.map(info, OnlineUser.class);
        onlineUser.setMemId(info.getIdKey());
        onlineUser.setMemberNm(info.getUsrNm());
        onlineUser.setDatabase(info.getDatasource());
        onlineUser.setCompanys(JsonMapper.toJsonString(info.getCompanyList()));
        onlineUser.setToken(Identities.uuid());
        tokenServerAdapter.tokenCreated(onlineUser, DevicePresenceHelper.DEVICE_H5);
        return success(onlineUser);
    }

}
