package com.qweib.cloud.biz.system.service.common;

import com.qweib.cloud.biz.system.service.common.dto.MemberBaseDTO;
import com.qweib.cloud.core.domain.SysBforder;

/**
 * @author zzx
 * @version 1.1 2019/11/9
 * @description:
 */
public interface OrderBaseService {
    MemberBaseDTO getSalesman(String database, SysBforder order);

    MemberBaseDTO getCustomer(String database, SysBforder order);

}
