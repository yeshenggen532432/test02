package com.qweib.cloud.biz.system.service.member;

import com.qweib.cloud.service.member.common.DeviceEnum;
import com.qweib.cloud.service.member.common.LoginTypeEnum;
import com.qweib.cloud.service.member.domain.member.login.MemberLoginSave;

/**
 * Summary:
 *
 * @Author zeng.gui.
 * Created on 2020/2/14 - 20:48.
 */
public class MemberLoginUtils {

    public static MemberLoginSave makeLoginDTO(Integer memberId, Integer companyId, LoginTypeEnum loginType, DeviceEnum device,
                                               String ipAddress) {
        MemberLoginSave input = new MemberLoginSave();
        input.setMemberId(memberId);
        input.setCompanyId(companyId);
        input.setLoginType(loginType);
        input.setDevice(device);
        input.setIpAddress(ipAddress);

        return input;
    }
}
