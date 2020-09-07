package com.qweib.cloud.biz.system.service.ws;

import com.qweib.cloud.core.domain.SysMemBind;
import com.qweib.cloud.core.domain.SysMember;
import com.qweib.cloud.core.domain.SysOftenuser;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.repository.ws.SysMemBindDao;
import com.qweib.cloud.repository.ws.SysMemWebDao;
import com.qweib.cloud.repository.ws.SysOftenuserDao;
import com.qweib.cloud.utils.Page;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.List;

/**
 * @说明：成员关系webService
 * @创建者： 作者：YJP 创建时间：2014-4-23
 */
@Service
public class SysMemBindService {

    @Resource
    private SysMemBindDao sysMemBindDao;
    @Resource
    private SysOftenuserDao sysOftenuserDao;
    @Resource
    private SysMemWebDao memWebDao;

    /**
     * 摘要：查找我的粉丝
     *
     * @param @param  memberId
     * @param @return
     * @说明：
     * @创建：作者:YYP 创建时间：2014-9-14
     * @修改历史： [序号](YYP 2014 - 9 - 14)<修改说明>
     */
    public List<SysMember> queryMyfs(Integer memberId, String datasource) {
        return this.sysMemBindDao.queryMyfs(memberId, datasource);
    }

    /**
     * @return
     * @说明：1我的好友/2常用好友/3黑名单
     * @创建者： 作者： llp  创建时间：2015-2-6
     */
    public Page queryMyMember(Integer pageNo, Integer pageSize, Integer queryMemberId, String tp) {
        return this.sysMemBindDao.queryMyMember(pageNo, pageSize, queryMemberId, tp);
    }

    /**
     * 查询常用好友
     */
    public List<SysMemBind> queryCy(Integer memberid, String datasource, String ybs) {
        List<SysMemBind> list = new ArrayList<SysMemBind>();
        try {
            if ("1".equals(ybs)) {
                list = sysOftenuserDao.queryCyMember(datasource, memberid, null);
            } else {
                list = sysMemBindDao.queryCy(memberid);
                String mems = (String) sysMemBindDao.queryoftenMems(memberid).get(0).get("mems");
                List<SysMemBind> list2 = sysOftenuserDao.queryCyMember(datasource, memberid, mems);
                list.addAll(list2);
            }
        } catch (Exception e) {
            new ServiceException(e);
        }
        return list;
    }

    /**
     * @return
     * @说明：设置好友常用状态
     * @创建者： 作者： llp  创建时间：2015-2-9
     */
    public void updateMemberbindByused(String tp, Integer memberId, Integer bindMemberId, String datasource) {
        try {
            this.sysMemBindDao.updateMemberbindByused(tp, memberId, bindMemberId);
            if (null != datasource) {
                Integer info = memWebDao.queryIsSameCompany(bindMemberId, datasource);
                if (info > 0) {//同一个公司（即时公司同事又是好友）
                    if ("1".equals(tp)) {//设置常用
                        SysOftenuser oftenuser = new SysOftenuser();
                        oftenuser.setMemberId(memberId);
                        oftenuser.setBindMemberId(bindMemberId);
                        sysOftenuserDao.deleteCyuser(datasource, memberId, bindMemberId);
                        sysOftenuserDao.addCyuser(datasource, oftenuser);
                    } else if ("2".equals(tp)) {//取消常用
                        sysOftenuserDao.deleteCyuser(datasource, memberId, bindMemberId);
                    }
                }
            }
        } catch (Exception e) {
            new ServiceException(e);
        }
    }

    /**
     * @return
     * @说明：设置好友关系状态
     * @创建者： 作者： llp  创建时间：2015-2-11
     */
    public int updateMemberbindByzt(String tp, Integer memberId, Integer memberBindId) {
        return this.sysMemBindDao.updateMemberbindByzt(tp, memberId, memberBindId);
    }

    /**
     * @return int
     * @说明：删除我的好友
     * @创建者： 作者： llp  创建时间：2015-2-11
     */
    public int deleteMemberAttention(Integer memberId, Integer memberBindId) {
        return this.sysMemBindDao.deleteMemberAttention(memberId, memberBindId);
    }

    /**
     * @说明：添加好友
     * @创建者： 作者： llp  创建时间：2015-2-11
     */
    public int addMemberAttention(SysMemBind sb) {
        return this.sysMemBindDao.addMemberAttention(sb);
    }

    /**
     * @说明：判断该成员是否已成为好友
     * @创建者： 作者:llp  创建时间：2015-2-11
     */
    public int queryIsMyFriends(Integer memberId, Integer bindId, Integer bindTp) {
        return sysMemBindDao.queryIsMyFriends(memberId, bindId, bindTp);
    }
}
