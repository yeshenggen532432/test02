package com.qweib.cloud.biz.system.service;

import com.qweib.cloud.repository.SysKhlevelDao;
import com.qweib.cloud.core.domain.SysKhlevel;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.utils.Page;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service
public class SysKhlevelService {
    @Resource
    private SysKhlevelDao khlevelDao;
    @Resource
    private SysCustomerLevelPriceService customerLevelPriceService;

    /**
     * 说明：分页查询客户等级
     *
     * @创建：作者:llp 创建时间：2016-7-23
     * @修改历史： [序号](llp 2016 - 7 - 23)<修改说明>
     */
    public Page queryKhlevelPage(SysKhlevel khlevel, String database, Integer page, Integer limit) {
        try {
            return this.khlevelDao.queryKhlevelPage(khlevel, database, page, limit);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    public List<SysKhlevel> queryList(SysKhlevel khlevel, String database) {
        return this.khlevelDao.queryList(khlevel, database);
    }

    /**
     * 说明：添加客户等级
     *
     * @创建：作者:llp 创建时间：2016-7-23
     * @修改历史： [序号](llp 2016 - 7 - 23)<修改说明>
     */
    public int addkhlevel(SysKhlevel khlevel, String database) {
        try {
            return this.khlevelDao.addkhlevel(khlevel, database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 说明：修改客户等级
     *
     * @创建：作者:llp 创建时间：2016-7-23
     * @修改历史： [序号](llp 2016 - 7 - 23)<修改说明>
     */
    public int updatekhlevel(SysKhlevel khlevel, String database) {
        try {
            return this.khlevelDao.updatekhlevel(khlevel, database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 说明：获取客户等级
     *
     * @创建：作者:llp 创建时间：2016-7-23
     * @修改历史： [序号](llp 2016 - 7 - 23)<修改说明>
     */
    public SysKhlevel querykhlevelById(Integer Id, String database) {
        try {
            return this.khlevelDao.querykhlevelById(Id, database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 说明：删除客户等级
     *
     * @创建：作者:llp 创建时间：2016-7-23
     * @修改历史： [序号](llp 2016 - 7 - 23)<修改说明>
     */
    public int deletekhlevelById(Integer Id, String database) {
        try {
            customerLevelPriceService.deleteByLevelId(Id, database);
            return this.khlevelDao.deletekhlevelById(Id, database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 说明：根据等级名称获取客户等级
     */
    public SysKhlevel querykhlevelByName(String name, String database) {
        try {
            return this.khlevelDao.querykhlevelByName(name, database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

}
