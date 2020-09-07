package com.qweib.cloud.biz.system.service.member;

import com.qweib.cloud.core.domain.dto.MemberLoginShowDTO;
import com.qweib.cloud.service.member.domain.member.login.MemberLoginQuery;
import com.qweib.cloud.service.member.domain.member.login.MemberLoginSave;
import com.qweibframework.commons.page.Page;

/**
 * Summary:
 *
 * @Author zeng.gui.
 * Created on 2020/2/14 - 20:39.
 */
public interface MemberLoginService {

    void pushMemberLogin(MemberLoginSave input);

    Page<MemberLoginShowDTO> page(MemberLoginQuery query, Integer pageNo, Integer pageSize);
}
