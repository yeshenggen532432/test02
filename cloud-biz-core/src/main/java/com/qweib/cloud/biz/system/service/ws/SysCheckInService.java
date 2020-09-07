package com.qweib.cloud.biz.system.service.ws;

import com.qweib.cloud.biz.system.service.plat.SysDeptmempowerService;
import com.qweib.cloud.core.domain.OnlineUser;
import com.qweib.cloud.core.domain.SysCheckIn;
import com.qweib.cloud.core.domain.SysCheckinPic;
import com.qweib.cloud.repository.ws.SysCheckInDao;
import com.qweib.cloud.repository.ws.SysCheckinPicWebDao;
import com.qweib.cloud.core.domain.SysCheckInConform;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.utils.Page;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class SysCheckInService {
    @Resource
    private SysCheckInDao sysCheckInDao;
    @Resource
    private SysCheckinPicWebDao sysCheckinPicWebDao;
    @Resource
    private SysDeptmempowerService deptmempowerService;


    /**
     * 通过人员id和时间查询记录
     */
    public Integer queryCheckByMidAndTime(Integer memberId, String checkTime, String database, String tp) {
        try {
            return this.sysCheckInDao.queryCheckByMidAndTime(memberId, checkTime, database, tp);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 添加签到记录
     *
     * @param picList
     */
    public int addCheck(SysCheckIn checkin, String database, List<SysCheckinPic> picList) {
        try {
            int id = this.sysCheckInDao.addCheck(checkin, database);
            if (null != picList && picList.size() != 0) {
                for (SysCheckinPic pic : picList) {
                    pic.setCheckinId(id);
                    this.sysCheckinPicWebDao.addPic(pic, database);
                }
            }
            return id;
        } catch (Exception ex) {
            throw new ServiceException(ex);
        }

    }

    public int deleteCheck(String ids, String database) {
        try {
            String[] idStr = ids.split(",");
            if (idStr.length == 0) return 1;
            for (int i = 0; i < idStr.length; i++) {
                Integer id = Integer.parseInt(idStr[i]);
                this.sysCheckInDao.deleteCheckById(id, database);
            }

            return 1;
        } catch (Exception ex) {
            throw new ServiceException(ex);
        }
    }

    /**
     * 公告分页查询(旧)
     */
    public Page page(SysCheckIn checkin, Integer page, Integer rows, String database, Integer memberId, String tp) {
        try {
            return sysCheckInDao.page(checkin, page, rows, database, memberId, tp);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * @param pageNo
     * @param pageSize
     * @param database
     * @param memId
     * @return
     * @创建：作者:YYP 创建时间：Oct 10, 2015
     */
    public Page pageList(Integer pageNo, Integer pageSize, String database,
                         Integer memId) {
        try {
            return sysCheckInDao.pageList(pageNo, pageSize, database, memId);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 说明：签到时间分页
     *
     * @创建：作者:llp 创建时间：2016-4-20
     * @修改历史： [序号](llp 2016 - 4 - 20)<修改说明>
     */
    public Page pageCheckInDate(Integer pageNo, Integer pageSize, String database,
                                Integer psnId, String dates) {
        try {
            return sysCheckInDao.pageCheckInDate(pageNo, pageSize, database, psnId, dates);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 说明：签到时间分页2
     *
     * @创建：作者:llp 创建时间：2016-4-20
     * @修改历史： [序号](llp 2016 - 4 - 20)<修改说明>
     */
    public Page pageCheckInDate2(Integer pageNo, Integer pageSize, OnlineUser user,
                                 String psnIds, String dates, String dataTp) {
        try {
            String datasource = user.getDatabase();
            Integer memberId = user.getMemId();
            Map<String, Object> map = new HashMap<String, Object>();
            if (psnIds.indexOf("全部") >= 0) {
                map = deptmempowerService.getPowerDept(dataTp, memberId, datasource);
            }
            return sysCheckInDao.pageCheckInDate2(pageNo, pageSize, datasource, psnIds, dates, map);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 说明：签到时间分页2
     */
    public Page pageCheckInDate3(Integer pageNo, Integer pageSize, OnlineUser user, String mids, String sdate, String edate, String dataTp) {
        try {
            String datasource = user.getDatabase();
            Map<String, Object> map = deptmempowerService.getPowerDept(dataTp, user.getMemId(), datasource);
            return sysCheckInDao.pageCheckInDate3(pageNo, pageSize, datasource, mids, sdate, edate,map);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 说明：签到信息集合
     *
     * @创建：作者:llp 创建时间：2016-4-20
     * @修改历史： [序号](llp 2016 - 4 - 20)<修改说明>
     */
    public List<SysCheckInConform> queryCheckInConformLs(String database, Integer psnId, String checkTime) {
        try {
            return sysCheckInDao.queryCheckInConformLs(database, psnId, checkTime);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 说明：签到信息集合
     *
     * @创建：作者:llp 创建时间：2016-4-20
     * @修改历史： [序号](llp 2016 - 4 - 20)<修改说明>
     */
    public List<SysCheckInConform> queryCheckInConformLs2(String database, Integer psnId, String dates) {
        try {
            return sysCheckInDao.queryCheckInConformLs2(database, psnId, dates);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }
    /**
     * 说明：签到信息集合
     *
     * @创建：作者:llp 创建时间：2016-4-20
     * @修改历史： [序号](llp 2016 - 4 - 20)<修改说明>
     */
    public List<SysCheckInConform> queryCheckInConformLs3(String database, Integer psnId, String sdate, String edate) {
        try {
            return sysCheckInDao.queryCheckInConformLs3(database, psnId, sdate, edate);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 通过id查询记录
     */
    public SysCheckIn queryCheckById(Integer id, String database) {
        try {
            SysCheckIn checkIn = this.sysCheckInDao.queryCheckById(id, database);
            //获取图片
            List<SysCheckinPic> picList = sysCheckInDao.queryPics(id, database);
            checkIn.setPicList(picList);
            return checkIn;
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 说明：根据用户id，当前日期，下班查询记录是否存在
     *
     * @创建：作者:llp 创建时间：2016-4-28
     * @修改历史： [序号](llp 2016 - 4 - 28)<修改说明>
     */
    public SysCheckIn queryCheckBydqdate(String database, Integer psnId) {
        try {
            return this.sysCheckInDao.queryCheckBydqdate(database, psnId);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 说明：根据用户id，下班查询记录是否存在
     *
     * @创建：作者:llp 创建时间：2016-4-28
     * @修改历史： [序号](llp 2016 - 4 - 28)<修改说明>
     */
    public SysCheckIn queryCheckBydqdate2(String database, Integer psnId) {
        try {
            return this.sysCheckInDao.queryCheckBydqdate2(database, psnId);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }
}
