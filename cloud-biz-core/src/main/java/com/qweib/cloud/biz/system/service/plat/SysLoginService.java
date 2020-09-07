package com.qweib.cloud.biz.system.service.plat;

import com.qweib.cloud.core.domain.SysLoginInfo;
import com.qweib.cloud.core.domain.SysMember;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.repository.plat.SysLoginDao;
import com.qweib.cloud.repository.plat.SysMemberDao;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

import static com.qweib.cloud.service.member.common.CertifyStateEnum.CERTIFIED;

@Service
public class SysLoginService {
    @Resource
    private SysLoginDao loginDao;

    @Resource
    private SysMemberDao memberDao;

    /**
     * 摘要：
     *
     * @param userNo
     * @return
     * @说明：根据用户编号查询用户
     * @创建：作者:yxy 创建时间：2012-1-12
     * @修改历史： [序号](yxy 2012 - 1 - 12)<修改说明>
     */
    public SysLoginInfo queryLoginInfo(String userNo) {
        try {
            SysLoginInfo info= this.loginDao.queryLoginInfo(userNo);
            info.setCertifyState(CERTIFIED);
            return info;
        } catch (Exception ex) {
            ex.printStackTrace();
            throw new ServiceException(ex);
        }
    }

    public SysLoginInfo queryByMemberId(Integer memberId) {
        return this.loginDao.queryById(memberId);
    }

    /**
     * @param userId
     * @return
     * @说明：根据用户id查询该用户的角色
     * @创建：作者:yxy 创建时间：2012-3-24
     * @修改历史： [序号](yxy 2012 - 3 - 24)<修改说明>
     */
    public List<Integer> queryRoleIdByUsr(int userId, String datasource) {
        try {
            return this.loginDao.queryRoleIdByUsr(userId, datasource);
        } catch (Exception ex) {
            throw new ServiceException(ex);
        }
    }

    /**
     * 摘要：
     *
     * @param id
     * @param oldPwd
     * @param newPwd
     * @说明：修改密码
     * @创建：作者:yxy 创建时间：2012-3-24
     * @修改历史： [序号](yxy 2012 - 3 - 24)<修改说明>
     */
    public Boolean updatePwd(Integer id, String oldPwd, String newPwd) {
        return this.loginDao.updatePwd(id, oldPwd, newPwd);
    }

    public SysMember querySysMemberById1(String datasource, Integer Id) {
        return this.memberDao.querySysMemberById1(datasource, Id);
    }
}
