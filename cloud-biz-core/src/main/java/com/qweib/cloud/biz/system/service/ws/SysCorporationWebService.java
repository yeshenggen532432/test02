package com.qweib.cloud.biz.system.service.ws;


import com.qweib.cloud.core.domain.SysCorporation;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.repository.plat.ws.SysCorporationWebDao;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service
public class SysCorporationWebService {
    @Resource
    private SysCorporationWebDao sysCorporationWebDao;

    /**
     * 根据id查询公司所有信息
     */
    public SysCorporation queryCorporationById(Integer memberId) {
        try {
            return this.sysCorporationWebDao.queryCorporationById(memberId);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    //模糊查询公司
    public List<SysCorporation> queryCorporationByLikeNm(String content) {
        try {
            return this.sysCorporationWebDao.queryCorporationByLikeNm(content);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }
}
