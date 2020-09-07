package com.qweib.cloud.biz.api.myzone;

import com.qweib.cloud.biz.system.UserContext;
import com.qweib.cloud.core.domain.SysLoginInfo;
import com.qweib.cloud.repository.utils.HttpResponseUtils;
import com.qweib.cloud.service.member.domain.member.SysMemberCompanyQuery;
import com.qweib.cloud.service.member.retrofit.ShopMemberCompanyRetrofitApi;
import com.qweib.cloud.service.member.retrofit.SysMemberCompanyRequest;
import com.qweibframework.commons.web.BaseController;
import com.qweibframework.commons.web.dto.Response;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * @author: jimmy.lin
 * @time: 2019/11/5 17:30
 * @description:
 */
@Slf4j
@RestController
@RequestMapping({"api/profile", "web/profile"})
public class ProfileApiController extends BaseController {
//    @Autowired
//    private SysMemberCompanyRequest memberCompanyApi;
//    @Autowired
//    private ShopMemberCompanyRetrofitApi memberShopApi;

    @GetMapping("companies")
    public Response companies() {
        SysLoginInfo loginInfo = UserContext.getLoginInfo();
        SysMemberCompanyQuery query = new SysMemberCompanyQuery();
        query.setMemberId(loginInfo.getIdKey());
        query.setDimission(false);
        return success();//.data(HttpResponseUtils.convertResponse(memberCompanyApi.list(query)));
    }

    @GetMapping("follows")
    public Response follows() {
        SysLoginInfo info = UserContext.getLoginInfo();
        return success();//.data(HttpResponseUtils.convertResponse(memberShopApi.listAll(info.getIdKey(), null, null, true)));
    }
}
