package com.qweib.cloud.biz.system.service.plat;


import com.qweib.cloud.core.domain.SysCorporationRenew;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.repository.plat.SysCorporationRenewDao;
import com.qweib.cloud.utils.Page;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

@Service
public class SysCorporationRenewService {
    @Resource
    private SysCorporationRenewDao corporationRenewDao;

    /**
     * 说明：分页查询公司续费记录
     *
     * @创建：作者:llp 创建时间：2016-7-20
     * @修改历史： [序号](llp 2016 - 7 - 20)<修改说明>
     */
    public Page queryCorporationRenew(SysCorporationRenew corporationRenew, Integer pageNo, Integer limit) {
        try {
            return this.corporationRenewDao.queryCorporationRenew(corporationRenew, pageNo, limit);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }
}
