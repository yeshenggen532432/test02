package com.qweib.cloud.biz.system.controller.ws;

import com.qweib.cloud.biz.system.UserContext;
import com.qweib.cloud.biz.system.service.plat.SysMemberService;
import com.qweib.cloud.core.domain.SysBrand;
import com.qweib.cloud.core.domain.SysLoginInfo;
import com.qweib.cloud.core.domain.SysMember;
import com.qweibframework.commons.web.BaseController;
import com.qweibframework.commons.web.dto.Response;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.List;

/**
 * 企业员工API
 */
@RestController
@RequestMapping("web/sys/member")
public class SysMemberApiController extends BaseController {

    @Autowired
    private SysMemberService sysMemberService;

    private String getTenant() {
        SysLoginInfo loginInfo = UserContext.getLoginInfo();
        return loginInfo.getDatasource();
    }

    @GetMapping
    public Response list() {
        SysMember member  = new SysMember();
        member.setMemberUse("1");
        List<SysMember> members = sysMemberService.queryCompanyMemberList(member,getTenant());
        return success(members);
    }


    @GetMapping("{id}")
    public Response getMember(@PathVariable Integer id){
        SysMember member =  sysMemberService.querySysMemberById1(getTenant(),id);
        return success(member);
    }

}
