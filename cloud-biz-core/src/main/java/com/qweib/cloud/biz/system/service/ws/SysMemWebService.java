package com.qweib.cloud.biz.system.service.ws;

import com.qweib.cloud.core.domain.SysMemDTO;
import com.qweib.cloud.core.domain.SysMember;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.repository.ws.SysMemWebDao;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service
public class SysMemWebService {

    @Resource
    private SysMemWebDao sysMemWebDao;

    /**
     * 根据公共平台id(pId)查找企业会员记录
     */
    public SysMember queryMemBypid(Integer pid, String database) {
        try {
            return this.sysMemWebDao.queryMemBypid(pid, database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 修改企业平台会员
     */
    public int updateMem(SysMember sysMem, String database) {
        try {
            int i = this.sysMemWebDao.updateMem(sysMem, database);
            if (i != 1) {
                throw new ServiceException("修改出错");
            }
            return i;
        } catch (Exception ex) {
            throw new ServiceException(ex);
        }
    }

    /**
     * 摘要：
     *
     * @param atMobiles
     * @return SysMember
     * @说明：根据一批手机号码查找用户
     * @创建：作者:yxy 创建时间：2012-1-12
     * @修改历史： [序号](yxy 2012 - 1 - 12)<修改说明>
     */
    public List<SysMember> queryLoginInfo(String[] atMobiles, String database) {
        return this.sysMemWebDao.queryLoginInfo(atMobiles, database);
    }

    /**
     * 根据id查询员工信息
     *
     * @param memId
     * @return
     * @创建：作者:YYP 创建时间：2015-2-6
     */
    public SysMemDTO queryMemByMemId(Integer memId) {
        return sysMemWebDao.queryMemByMemId(memId);
    }

    /**
     * 通过会员id查找会员记录
     */
    public SysMember queryMemByMid(Integer memId, String database) {
        try {
            return sysMemWebDao.queryMemByMid(memId, database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 查找全部员工
     */
    public List<SysMember> queryMemberList(String database) {
        try {
            return sysMemWebDao.queryMemberList(database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 根据条件查询用户信息
     */
    public SysMember queryMember(Integer memberId, String database) {
        return this.sysMemWebDao.queryMember(SysMember.class, memberId, null, database);
    }

    /**
     * 按memberId更新头像文件名称
     *
     * @param fileName
     * @param memberId
     */
    public void updatePhoto(String fileName, String fileBg, Integer memberId, String database) {
        sysMemWebDao.updatePhoto(fileName, fileBg, memberId, database);
    }

    /**
     * 根据ids查询成员
     *
     * @param ids
     * @param database
     * @return
     * @创建：作者:YYP 创建时间：2015-3-3
     */
    public List<SysMemDTO> queryMemByIds(String ids, String database) {
        try {
            return sysMemWebDao.queryMemByIds(ids, database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 查询部门下（包括子部门）下的所有成员
     *
     * @param branchPath
     * @param database
     * @return
     * @创建：作者:YYP 创建时间：2015-3-12
     */
    public List<SysMemDTO> queryDeptMids(String branchPath, String database) {
        try {
            return sysMemWebDao.queryDeptMids(branchPath, database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 查询公司下成员
     *
     * @param database
     * @return
     * @创建：作者:YYP 创建时间：2015-3-17
     */
    public List<SysMemDTO> queryCompanyMids(String database) {
        try {
            return sysMemWebDao.queryDeptMids(database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 摘要：
     *
     * @说明：根据用户组id获取用户信息
     * @创建：作者:llp 创建时间：2017-1-21
     * @修改历史： [序号](llp 2017 - 1 - 21)<修改说明>
     */
    public List<SysMember> queryMemByMemIds(String memIds, String database) {
        try {
            return sysMemWebDao.queryMemByMemIds(memIds, database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 根据设备唯一识别号--查找企业会员记录
     */
    public SysMember queryMemByUnid(String unId, String database) {
        try {
            return this.sysMemWebDao.queryMemByUnid(unId, database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 根据手机号--查找企业会员记录
     */
    public SysMember queryMemByMobile(String mobile, String database) {
        try {
            return this.sysMemWebDao.queryMemByMobile(mobile, database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

}
