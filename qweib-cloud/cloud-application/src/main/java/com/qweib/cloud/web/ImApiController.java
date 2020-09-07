package com.qweib.cloud.web;

import com.qweib.cloud.biz.system.UserContext;
import com.qweib.cloud.biz.system.service.plat.SysCompanyRoleService;
import com.qweib.cloud.biz.system.service.plat.SysMemberService;
import com.qweib.cloud.biz.system.utils.RoleUtils;
import com.qweib.cloud.core.domain.SysLoginInfo;
import com.qweib.cloud.core.domain.SysMember;
import com.qweib.cloud.service.member.retrofit.SysMemberRequest;
import com.qweib.cloud.utils.Collections3;
import com.qweib.cloud.web.dto.ServiceDTO;
import com.qweib.commons.StringUtils;
import com.qweib.commons.mapper.BeanMapper;
import com.qweib.fs.AbstractFileService;
import com.qweib.fs.FileInfo;
import com.qweib.fs.FileService;
import com.qweib.fs.local.LocalFileService;
import com.qweib.im.api.MessageApi;
import com.qweib.im.api.ServiceApi;
import com.qweib.im.api.UserApi;
import com.qweib.im.api.dto.*;
import com.qweibframework.commons.http.ResponseUtils;
import com.qweibframework.commons.web.BaseController;
import com.qweibframework.commons.web.dto.Response;
import jdk.nashorn.internal.ir.annotations.Reference;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import retrofit2.Call;

import javax.validation.Valid;
import java.util.List;
import java.util.stream.Collectors;

/**
 * @author jimmy.lin
 * create at 2020/2/17 1:54
 */
@RestController
@RequestMapping({"manager/im", "web/im"})
public class ImApiController extends BaseController {
//    @Autowired
//    private UserApi userApi;
//    @Autowired
//    private ServiceApi serviceApi;
//    @Autowired
//    private MessageApi messageApi;
    @Autowired
    private SysMemberService memberService;
    @Autowired
    private SysCompanyRoleService roleService;
    @Autowired
    private FileService fileService;
//    @Autowired
//    private SysMemberRequest memberApi;


    @GetMapping("token")
    public Response token() {
        SysLoginInfo loginInfo = UserContext.getLoginInfo();
        User user = new User();
        user.setName(loginInfo.getUsrNm());

        String userId;
        if (loginInfo.getIdKey() == null) {
            Integer shopMemberId = loginInfo.getShopMemberId();
            if (shopMemberId == null) {
                AnonymousUser anonymousUser = new AnonymousUser();
                anonymousUser.setTenantId(loginInfo.getFdCompanyId());
                return success("");//ResponseUtils.convertResponse(userApi.bindAnonymous(anonymousUser)));
            } else {
                userId = loginInfo.getFdCompanyId() + "_" + shopMemberId;
            }
        } else {
            userId = String.valueOf(loginInfo.getIdKey());
        }
        user.setUserId(userId);
        user.setTenantId(loginInfo.getFdCompanyId());
        String token = "";//ResponseUtils.convertResponse(userApi.bind(user));
        return success(token);
    }

    @GetMapping("service")
    public Response listService() {
        SysLoginInfo loginInfo = UserContext.getLoginInfo();
        List<ServiceDTO> services = getService(loginInfo);
        if (Collections3.isEmpty(services)) {
            boolean isAdmin = RoleUtils.hasCompanyAdmin(loginInfo.getUsrRoleIds(), roleService, loginInfo.getDatasource());
            if (isAdmin) {
                Service service = new Service();
                service.setTenantId(loginInfo.getFdCompanyId());
                service.setUserId(String.valueOf(loginInfo.getIdKey()));
                service.setAlias(loginInfo.getUsrNm());
                //ResponseUtils.convertResponse(serviceApi.save(service));
                return success("");//getService(loginInfo));
            }
        }
        return success(services);
    }

    private List<ServiceDTO> getService(SysLoginInfo loginInfo) {
//        Call<Response<List<Service>>> call = serviceApi.list(loginInfo.getFdCompanyId());
//        List<Service> services = ResponseUtils.convertResponse(call);
//        if (Collections3.isNotEmpty(services)) {
//            return services.stream().map(service -> {
//                ServiceDTO dto = BeanMapper.map(service, ServiceDTO.class);
//                SysMember sysMember = memberService.querySysMemberById(Integer.valueOf(service.getUserId()));
//                if (sysMember != null) {
//                    if (StringUtils.isEmpty(dto.getName())) {
//                        dto.setName(sysMember.getMemberNm());
//                    }
//                    dto.setBranchName(sysMember.getBranchName());
//                }
//                return dto;
//            }).collect(Collectors.toList());
//        }
        return null;
    }

    @PostMapping("service")
    public Response addService(@RequestBody @Valid Service service) {
//        SysLoginInfo loginInfo = UserContext.getLoginInfo();
//        service.setTenantId(loginInfo.getFdCompanyId());
//        String id = ResponseUtils.convertResponseNull(serviceApi.save(service));
        return success("");//.data(id).message("添加客服成功");
    }

    @PostMapping("service/remove/{userId}")
    public Response removeService(@PathVariable String userId) {
//        SysLoginInfo loginInfo = UserContext.getLoginInfo();
//        Id id = new Id();
//        id.setUserId(userId);
//        id.setTenantId(loginInfo.getFdCompanyId());
//        String result = ResponseUtils.convertResponseNull(serviceApi.remove(id));
        return success("");//.message("删除客服成功");
    }


    @PostMapping("message")
    public Response sendMessage(@RequestBody @Valid Message message) {
        return success().message("发送成功");
    }

    @RequestMapping("upload")
    public Response upload(MultipartFile file) throws Exception {
        SysLoginInfo loginInfo = UserContext.getLoginInfo();
        FileInfo info = fileService.store(loginInfo.getDatasource(), "im/avatar", file.getInputStream(), file.getOriginalFilename());
        return success().data(info);
    }

    @GetMapping("assistance")
    public Response checkAssistance() {
        SysLoginInfo info = UserContext.getLoginInfo();
        return success("");//ResponseUtils.convertResponse(memberApi.existTmpAccount(Integer.parseInt(info.getFdCompanyId()))));
    }

}
