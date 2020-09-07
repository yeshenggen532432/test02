package com.qweib.cloud.core.domain.dto;

import com.qweib.cloud.service.member.domain.member.login.MemberLoginDTO;
import lombok.Data;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2020/2/17 - 15:35
 */
@Data
public class MemberLoginShowDTO extends MemberLoginDTO {

    private String companyName;
}
