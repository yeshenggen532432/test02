package com.qweib.cloud.biz.system.service.ws;

import com.qweib.cloud.biz.system.service.plat.SysDeptmempowerService;
import com.qweib.cloud.core.domain.OnlineUser;
import com.qweib.cloud.core.domain.SysCustomer;
import com.qweib.cloud.core.domain.SysLoginInfo;
import com.qweib.cloud.repository.SysCustomerWebDao;
import com.qweib.cloud.core.domain.SysCustomerWeb;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.utils.Page;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

@Service
public class SysCustomerWebService {
    @Resource
    private SysCustomerWebDao customerWebDao;
    @Resource
    private SysDeptmempowerService deptmempowerService;

    /**
     * 说明：分页查询我周边客户
     *
     * @创建：作者:llp 创建时间：2016-2-19
     * @修改历史： [序号](llp 2016 - 2 - 19)<修改说明>
     */
    public Page queryCustomerWebZb(SysLoginInfo user, Integer khTp, Double longitude, Double latitude, Integer page, Integer limit, String khNm, String mids, String pxtp, String regionIds) {
        try {
            String datasource = user.getDatasource();
            Integer memberId = user.getIdKey();
            return this.customerWebDao.queryCustomerWebZb(datasource, memberId, khTp, longitude, latitude, page, limit, khNm, mids, pxtp, regionIds);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 说明：分页查询我的客户
     */
    public Page queryCustomerWeb(SysLoginInfo user, Integer khTp, String dataTp, Integer page, Integer limit, String khNm,
                                 Double longitude, Double latitude, String qdtpNms, String khdjNms, Integer xlId, String mids, String pxtp, String regionIds) {
        try {
            String datasource = user.getDatasource();
            Integer memberId = user.getIdKey();
            mids = deptmempowerService.getMemberIds(dataTp,memberId,datasource, mids);
            return this.customerWebDao.queryCustomerPage(datasource,page, limit, khNm, longitude, latitude, qdtpNms, khdjNms, xlId, mids, pxtp, regionIds);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 说明：列表查经销商
     */
    public List<SysCustomerWeb> queryCustomerls1(String database) {
        try {
            return this.customerWebDao.queryCustomerls1(database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 说明：修改经销商
     *
     * @创建：作者:llp 创建时间：2016-3-10
     * @修改历史： [序号](llp 2016 - 3 - 10)<修改说明>
     */
    public void updateCustomerSj1(String database, Integer id, String khNm, String jxsflNm, String jxsztNm,
                                  String jxsjbNm, String bfpcNm, String fgqy, String linkman, String mobile, String tel, String mobileCx,
                                  String province, String city, String area, String address, String longitude, String latitude,
                                  String qq, String wxCode, String fman, String ftel, String openDate, String remo) {
        try {
            this.customerWebDao.updateCustomerSj1(database, id, khNm, jxsflNm, jxsztNm, jxsjbNm, bfpcNm, fgqy, linkman, mobile, tel, mobileCx, province, city, area, address, longitude, latitude, qq, wxCode, fman, ftel, openDate, remo);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 说明：修改客户
     *
     * @创建：作者:llp 创建时间：2016-3-10
     * @修改历史： [序号](llp 2016 - 3 - 10)<修改说明>
     */
    public void updateCustomerSj2(String database, Integer id, String khNm, String linkman, String mobile, String tel,
                                  String province, String city, String area, String address, String longitude, String latitude,
                                  String qdtpNm, String khdjNm,Integer qdtypeId, Integer khlevelId, String xsjdNm, String bfpcNm,
                                  String qq, String wxCode, Integer khPid, String fgqy, String openDate, String remo, String hzfsNm, Integer regionId) {
        try {
            this.customerWebDao.updateCustomerSj2(database, id, khNm, linkman, mobile, tel, province, city, area, address, longitude, latitude, qdtpNm, khdjNm,qdtypeId,khlevelId, xsjdNm, bfpcNm, qq, wxCode, khPid, fgqy, openDate, remo, hzfsNm,regionId);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 说明：根据客户id修改客户状态，拜访分类
     *
     * @创建：作者:llp 创建时间：2016-3-28
     * @修改历史： [序号](llp 2016 - 3 - 28)<修改说明>
     */
    public void updateCustomerZF(String database, String xsjdNm, String bfflNm, Integer cid) {
        try {
            this.customerWebDao.updateCustomerZF(database, xsjdNm, bfflNm, cid);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 说明：根据客户id修改上次拜访日期
     *
     * @创建：作者:llp 创建时间：2016-3-28
     * @修改历史： [序号](llp 2016 - 3 - 28)<修改说明>
     */
    public void updateCustomerScbfDate(String database, Integer cid) {
        try {
            this.customerWebDao.updateCustomerScbfDate(database, cid);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 分页查询供应商
     */
    public Page queryProviderPage(String proName, int page, int rows, String database) {
        try {
            return this.customerWebDao.queryProviderPage(proName, page, rows, database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     *
     */
    public List<SysCustomer> queryNearCustomerListByLatLng(String database,Integer mid, String latitude, String longitude,String dataTp, String customerType) {
        try {
            String mIds = deptmempowerService.getMemberIds(dataTp,mid,database, null);
            return this.customerWebDao.queryNearCustomerListByLatLng(database, latitude, longitude, mIds, customerType);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    public Page queryCustomerPageEx(SysCustomer customer,Integer page,Integer limit,String database)
    {
        return this.customerWebDao.queryCustomerPageEx(customer,page,limit,database);
    }

}
