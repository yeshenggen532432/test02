package com.qweib.cloud.biz.system.service.ws;


import com.qweib.cloud.core.domain.SysMemDTO;
import com.qweib.cloud.core.domain.SysMember;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.repository.plat.ws.SysMemberWebDao;
import com.qweib.cloud.repository.ws.SysMemWebDao;
import com.qweib.cloud.utils.MemberConstants;
import com.qweib.cloud.utils.Page;
import com.qweib.commons.StringUtils;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.Map;

@Service
public class SysMemberWebService {
    @Resource
    private SysMemberWebDao memberWebDao;
    @Resource
    private SysMemWebDao memWebDao;

    public SysMember queryMemberByMobile(String mobile) {
        try {
            return memberWebDao.queryMemberByMobile(mobile);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    public SysMember queryMemberByunId(String unId) {
        try {
            return memberWebDao.queryMemberByunId(unId);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 添加 pos 会员
     */
    public int addMember(SysMember sysmeber) {
        return addMember(sysmeber, "pos");
    }

    public int addMember(SysMember sysmeber, String type) {
        try {
            if (StringUtils.isBlank(sysmeber.getMemberNm()))
                sysmeber.setMemberNm("未设置" + type);

            if (StringUtils.isNotBlank(type)) {
                switch (type) {
                    case "reg":
                    case "regnew": {
                        sysmeber.setRegisterSource(MemberConstants.REGISTER_SOURCE_WEIXIN);
                        break;
                    }
                    case "addWeixin": {
                        sysmeber.setRegisterSource(MemberConstants.REGISTER_SOURCE_WEIXIN);
                        break;
                    }
                    case "addCorporation": {
                        sysmeber.setRegisterSource(MemberConstants.REGISTER_SOURCE_COMPANY_MEMBER);
                        break;
                    }
                }
            }

            if (StringUtils.isBlank(sysmeber.getRegisterSource())) {
                sysmeber.setRegisterSource(MemberConstants.REGISTER_SOURCE_OTHER + 1);
            }
            int i = this.memberWebDao.addMember(sysmeber);
            return i;
        } catch (Exception ex) {
            throw new ServiceException(ex);
        }
    }

    /**
     * 查询用户信息
     *
     * @param memberId
     * @return
     * @创建：作者:YYP 创建时间：2015-1-29
     */
    public SysMember queryMemById(Integer memberId) {
        try {
            return memberWebDao.queryMemById(memberId);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 查询用户所有信息
     */
    public SysMember queryAllById(Integer memberId) {
        return queryMemById(memberId);
    }

    /**
     * 修改会员
     */
    public int updateMember(SysMember sysmember) {
        try {
            int i = this.memberWebDao.updateMember(sysmember);
            if (i != 1) {
                throw new ServiceException("修改出错");
            }
            return i;
        } catch (Exception ex) {
            throw new ServiceException(ex);
        }
    }

    /**
     * 说明：根据手机号码判断有没有被公司邀请
     *
     * @创建：作者:llp 创建时间：2015-2-5
     * @修改历史： [序号](llp 2015 - 2 - 5)<修改说明>
     */
    public int querySysMemberByTel(String tel) {
        try {
            return this.memberWebDao.querySysMemberByTel(tel);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 说明：根据成员id判断有没有加入部门
     *
     * @创建：作者:llp 创建时间：2015-2-5
     * @修改历史： [序号](llp 2015 - 2 - 5)<修改说明>
     */
    public int queryMemberByBmAndId(Integer mbId) {
        try {
            return this.memberWebDao.queryMemberByBmAndId(mbId);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 说明：根据手机号码查找信息
     *
     * @创建：作者:llp 创建时间：2015-2-5
     * @修改历史： [序号](llp 2015 - 2 - 5)<修改说明>
     */
    public SysMember queryMemberByTel(String tel) {
        try {
            return this.memberWebDao.queryMemberByTel(tel);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 说明：根据id修改公司名称,公司id,部门id
     *
     * @创建：作者:llp 创建时间：2015-2-5
     * @修改历史： [序号](llp 2015 - 2 - 5)<修改说明>
     */
    public void updateMemBycompanyAndBm(String company, Long unitid, Integer branchId, Integer memberid) {
        try {
            this.memberWebDao.updateMemBycompanyAndBm(company, unitid, branchId, memberid);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 说明：根据id修改公司名称,公司id,部门id
     *
     * @创建：作者:llp 创建时间：2015-2-5
     * @修改历史： [序号](llp 2015 - 2 - 5)<修改说明>
     */
    public void updateMemBycompanyAndBm1(String company, Long unitid, Integer branchId, Integer memberid, String datasource) {
        try {
            this.memberWebDao.updateMemBycompanyAndBm1(company, unitid, branchId, memberid, datasource);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 根据id查询用户信息
     *
     * @param memId
     * @return
     * @创建：作者:YYP 创建时间：2015-2-10
     */
    public SysMemDTO queryMemByMemId(Integer memId) {
        try {
            return this.memberWebDao.queryMemByMemId(memId);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 判断是否为好友
     *
     * @param memberId
     * @param memId
     * @return
     * @创建：作者:YYP 创建时间：2015-2-10
     */
    public Integer queryIsFriend(Integer memberId, Integer memId) {
        return Integer.parseInt(memberWebDao.queryIsFriend(memberId, memId).get("count").toString());
    }

    /**
     * 根据条件查询用户信息
     */
    public SysMember queryMember(Integer memberId) {
        return this.memberWebDao.queryMember(SysMember.class, memberId, null);
    }

    /**
     * 按memberId更新头像文件名称
     *
     * @param fileName
     * @param memberId
     */
    public void updatePhoto(String fileName, String fileBg, Integer memberId) {
        memberWebDao.updatePhoto(fileName, fileBg, memberId);
    }

    /**
     * 根据用户查询名单
     */
    public Page queryBlacklistByMid(Integer memId, Integer pageNo, Integer pageSize) {
        return memberWebDao.queryBlacklistByMid(memId, pageNo, pageSize);
    }

    /**
     * 根据黑名单用户ID移除黑名单
     */
    public void deleteBlacklist(Integer memId, Integer bindId) {
        try {
            int i = this.memberWebDao.deleteBlacklist(memId, bindId);
            if (i > 0) {
                this.memberWebDao.updateMemberBlacklist(memId);
            } else {
                throw new DaoException("移除黑名单失败");
            }
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public SysMember querymemCompany(Integer memId) {
        return memberWebDao.querymemCompany(memId);
    }

    /**
     * 通过id查询会员信息和部门名称
     */
    public SysMember queryMemAndDeptById(String database, Integer memberId) {
        return memberWebDao.queryMemAndDeptById(database, memberId);
    }

    /**
     * 删除成员时修改成员信息
     *
     * @param memId
     * @param database
     * @创建：作者:YYP 创建时间：2015-4-7
     */
    public void updateMemberCompany(Integer memId, String database) {
        try {
            memWebDao.deleteMemById(memId, database);
            //修改成员公司部门等信息
            memberWebDao.updateMemberBycompany(null, null, null, memId, null);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    public Integer updateMemberPwd(SysMember member, String newpwd) {
        try {
//            if (null != member.getDatasource() && !"".equals(member.getDatasource())) {//没有所属公司
//                memWebDao.updateMemPwd(member.getDatasource(), member.getMemberId(), newpwd);
//            }
            return memberWebDao.updateMemberPwd(member.getMemberId(), newpwd);//修改公共平台成员密码
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 更新公共平台及企业平台成员信息
     *
     * @param member
     * @param datasource
     * @创建：作者:YYP 创建时间：Sep 18, 2015
     */
    public void updateMemberAndMem(SysMember member, String datasource) {
        try {
            memberWebDao.updateMember(member);
            if (null != datasource) {
                memWebDao.updateMem(member, datasource);
            }
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    //修改唯一码
    public void updateunId(String database, String unId, Integer memberId) {
        try {
            memberWebDao.updateunId(database, unId, memberId);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    //获取公司所有人数
    public int queryMemCount(String database) {
        try {
            return this.memberWebDao.queryMemCount(database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    public SysMember queryCompanySysMemberById(String datasource, Integer Id) {
        try {
            return this.memWebDao.queryCompanySysMemberById(datasource, Id);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 说明：获取部门下的用户id
     *
     * @创建：作者:llp 创建时间：2016-7-28
     * @修改历史： [序号](llp 2016 - 7 - 28)<修改说明>
     */
    public Map<String, Object> queryMidStr(String database, Integer branchId) {
        try {
            return this.memberWebDao.queryMidStr(database, branchId);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 说明：根据手机号修改密码
     *
     * @创建：作者:llp 创建时间：2017-11-7
     * @修改历史： [序号](llp 2017 - 11 - 7)<修改说明>
     */
    public void updateUerPwd(String database, String memberPwd, String memberMobile) {
        try {
            this.memberWebDao.updateUerPwd(database, memberPwd, memberMobile);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

}
