package com.qweib.cloud.biz.system.service;

import com.qweib.cloud.biz.system.service.plat.SysDeptmempowerService;
import com.qweib.cloud.core.domain.SysCustomer;
import com.qweib.cloud.core.domain.SysLoginInfo;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.repository.SysCustomerTmpDao;
import com.qweib.cloud.core.domain.SysCustomerTmp;
import com.qweib.cloud.utils.Page;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

@Service
public class SysCustomerTmpService {

    @Resource
    private SysCustomerTmpDao sysCustomerTmpDao;
    @Resource
    private SysDeptmempowerService deptmempowerService;

    public int addTmpCustomer(SysCustomerTmp bean, String database) {
        return this.sysCustomerTmpDao.addTmpCustomer(bean, database);
    }

    public int updateTmpCustomer(SysCustomerTmp bean, String database) {
        return this.sysCustomerTmpDao.updateTmpCustomer(bean, database);
    }

    public int deleteTmpCustomer(Integer id, String database) {
        return this.sysCustomerTmpDao.deleteTmpCustomer(id, database);
    }

    public SysCustomerTmp queryTmpCustomer(SysCustomerTmp bean, String database) {
        return this.sysCustomerTmpDao.queryTmpCustomer(bean, database);
    }

    public SysCustomerTmp queryTmpCustomerByKhNm(String khNm, String database) {
        return this.sysCustomerTmpDao.queryTmpCustomerByKhNm(khNm, database);
    }

    public Page queryTmpCustomerPageWeb(String database, Integer pageNo, Integer pageSize, int memberId, String dataTp, String mids,
                                        String khNm, Double longitude, Double latitude) {
        //根据id查询可见mids,可见部门，不可见部门
        Map<String, Object> map = deptmempowerService.getPowerDept(dataTp, memberId, database);
        return this.sysCustomerTmpDao.queryTmpCustomerPageWeb(database, pageNo, pageSize, map, mids, khNm, longitude, latitude);
    }

    public List<SysCustomerTmp> queryTmpCustomerList(String database, int memberId, String dataTp,String mids,
                                                     String khNm, Double longitude, Double latitude) {
        //根据id查询可见mids,可见部门，不可见部门
        Map<String, Object> map = deptmempowerService.getPowerDept(dataTp, memberId, database);
        return this.sysCustomerTmpDao.queryTmpCustomerList(database,map, mids, khNm, longitude, latitude);
    }

    /**
     * 说明：分页查询客户
     */
    public Page queryCustomerTmpPage(SysCustomerTmp bean, String dataTp, SysLoginInfo info, Integer page, Integer limit) {
        try {
            String datasource = info.getDatasource();
            Integer memberId = info.getIdKey();
            //根据id查询可见mids,可见部门，不可见部门
            Map<String, Object> map = deptmempowerService.getPowerDept(dataTp, memberId, datasource);
            return this.sysCustomerTmpDao.queryCustomerTmpPage(datasource, page, limit, map, bean);
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServiceException(e);
        }
    }

}
