package com.qweib.cloud.biz.attendance.service;


import com.qweib.cloud.biz.attendance.dao.KqBcDao;
import com.qweib.cloud.biz.attendance.dao.KqCheckInDao;
import com.qweib.cloud.biz.attendance.model.KqBc;
import com.qweib.cloud.biz.system.service.plat.SysDeptmempowerService;
import com.qweib.cloud.core.domain.OnlineUser;
import com.qweib.cloud.core.domain.SysCheckIn;
import com.qweib.cloud.core.domain.SysCheckInConform;
import com.qweib.cloud.core.domain.SysCheckinPic;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.repository.ws.SysCheckinPicWebDao;
import com.qweib.cloud.utils.Page;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class KqCheckService {

    @Resource
    private KqCheckInDao checkInDao;
    @Resource
    private SysCheckinPicWebDao sysCheckinPicWebDao;
    @Resource
    private SysDeptmempowerService deptmempowerService;

    @Resource
    private KqBcDao bcDao;

    @Resource
    private KqDetailService detailService;


    /**
     * 通过人员id和时间查询记录
     */
    public Integer queryCheckByMidAndTime(Integer memberId, String checkTime, String database, String tp) {
        try {
            return this.checkInDao.queryCheckByMidAndTime(memberId, checkTime, database, tp);
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
            int id = this.checkInDao.addCheck(checkin, database);
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
                this.checkInDao.deleteCheckById(id, database);
            }

            return 1;
        } catch (Exception ex) {
            throw new ServiceException(ex);
        }
    }

    public int updateCheck(Integer checkId, String database) {

        SysCheckIn checkIn = this.checkInDao.queryCheckById1(checkId, database);
        if (checkIn == null) return 0;
        String ymd = checkIn.getCheckTime().substring(0, 10);
        KqBc bc = this.detailService.getEmpBcByDate(checkIn.getPsnId(), ymd, database);
        if (bc == null) return 0;
        //if(checkIn.getSbType() == null)checkIn.setSbType(sbType);
        String latitude = bc.getLatitude();
        if (latitude.length() > 0) checkIn.setLatitude(Double.parseDouble(latitude));
        String longitude = bc.getLongitude();
        if (longitude.length() > 0) checkIn.setLongitude(Double.parseDouble(longitude));
        checkIn.setLocation(bc.getAddress());
        String cdzt = "";
        if (checkIn.getCdzt().indexOf("补签") > 0) cdzt = "补签 ";
        checkIn.setCdzt(cdzt + "校正");
        int ret = this.checkInDao.updateCheck(checkIn, database);

        return ret;
    }

    /**
     * 公告分页查询(旧)
     */
    public Page page(SysCheckIn checkin, Integer page, Integer rows, String database, Integer memberId, String tp) {
        try {
            return checkInDao.page(checkin, page, rows, database, memberId, tp);
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
     * @see 公告分页查询（新）
     */
    public Page pageList(Integer pageNo, Integer pageSize, String database,
                         Integer memId) {
        try {
            return checkInDao.pageList(pageNo, pageSize, database, memId);
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
            return checkInDao.pageCheckInDate(pageNo, pageSize, database, psnId, dates);
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
            return checkInDao.pageCheckInDate2(pageNo, pageSize, datasource, psnIds, dates, map);
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
            return checkInDao.queryCheckInConformLs(database, psnId, checkTime);
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
            return checkInDao.queryCheckInConformLs2(database, psnId, dates);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 通过id查询记录
     */
    public SysCheckIn queryCheckById(Integer id, String database) {
        try {
            SysCheckIn checkIn = this.checkInDao.queryCheckById(id, database);
            //获取图片
            List<SysCheckinPic> picList = checkInDao.queryPics(id, database);
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
            return this.checkInDao.queryCheckBydqdate(database, psnId);
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
            return this.checkInDao.queryCheckBydqdate2(database, psnId);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

}
