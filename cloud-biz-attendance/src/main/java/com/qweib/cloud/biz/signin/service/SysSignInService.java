package com.qweib.cloud.biz.signin.service;

import com.qweib.cloud.biz.attendance.dao.KqCheckInDao;
import com.qweib.cloud.biz.signin.dao.SysSignDetailDao;
import com.qweib.cloud.biz.signin.dao.SysSignInDao;
import com.qweib.cloud.biz.signin.model.SysSignDetail;
import com.qweib.cloud.biz.signin.model.SysSignImgVo;
import com.qweib.cloud.biz.signin.model.SysSignIn;
import com.qweib.cloud.core.domain.SysCheckIn;
import com.qweib.cloud.core.domain.SysCustomerTmp;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.repository.SysCustomerTmpDao;
import com.qweib.cloud.utils.ChineseCharToEnUtil;
import com.qweib.cloud.utils.DateTimeUtil;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.*;

@Service
public class SysSignInService {

    @Resource
    private SysSignInDao sysSignInDao;
    @Resource
    private SysSignDetailDao sysSignDetailDao;
    @Resource
    private KqCheckInDao kqCheckInDao;
    @Resource
    private SysCustomerTmpDao sysCustomerTmpDao;

    public int addSignIn(SysSignIn bo, String database, String khNm, Integer mid, Integer branchId) {
        try {
            int ret = this.sysSignInDao.addData(bo, database);
            if (ret == 0) return ret;
            List<SysSignDetail> detailList = bo.getDetailList();
            for (SysSignDetail dtl : detailList) {
                dtl.setSignId(ret);
                int i = this.sysSignDetailDao.addData(dtl, database);
                if (i == 0) {
                    throw new ServiceException("保存明细失败");
                }
            }
            //添加临时客户
            if(!StrUtil.isNull(khNm)){
                SysCustomerTmp bean = new SysCustomerTmp();
                bean.setKhNm(khNm);
                bean.setAddress(bo.getAddress());
                bean.setLongitude(bo.getLongitude());
                bean.setLatitude(bo.getLatitude());
                bean.setMemId(mid);
                bean.setBranchId(branchId);
                bean.setIsDb(0);//0:正常   1:倒闭
                bean.setPy(ChineseCharToEnUtil.getFirstSpell(khNm));
                bean.setCreateTime(DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd HH:mm:ss"));
                this.sysCustomerTmpDao.addTmpCustomer(bean, database);
            }
            return ret;
        }catch (Exception e){
            throw new ServiceException(e);
        }
    }

    public Page querySignInPage(SysSignIn vo, String database, Integer page, Integer limit) {
        Page p = this.sysSignInDao.querySignInPage(vo, database, page, limit);
        List<SysSignIn> list = p.getRows();
        for (SysSignIn vo1 : list) {
            List<SysSignDetail> subList = this.sysSignDetailDao.queryDetailList(vo1.getId(), database);
            vo1.setDetailList(subList);
        }
        return p;
    }

    public Page querySignInPage1(SysSignIn vo, String database, Integer page, Integer limit) {
        Page p = this.sysSignInDao.querySignInPage(vo, database, page, limit);
        List<SysSignIn> list = p.getRows();
        for (SysSignIn vo1 : list) {
            List<SysSignDetail> subList = this.sysSignDetailDao.queryDetailList(vo1.getId(), database);
            List<SysSignImgVo> imgList = new ArrayList<SysSignImgVo>();
            for (SysSignDetail img : subList) {
                if (img.getObjType().intValue() == 1) {
                    vo1.setVoiceUrl(img.getPic());
                    continue;
                }
                SysSignImgVo vo2 = new SysSignImgVo();
                vo2.setPic(img.getPic());
                vo2.setPicMin(img.getPicMini());
                imgList.add(vo2);
            }
            vo1.setListpic(imgList);
        }
        return p;
    }

    /**
     * 类似：手机端拜访地图中的拜访回放
     * 流动打卡 + 上下班
     */
    public List<SysSignIn> querySignInBfhf(String database, Integer mid, String date) {
        //流动打卡
        List<SysSignIn> list = this.sysSignInDao.querySignInList(database, mid, date);
        if (list == null) {
            list = new ArrayList<>();
        }
        for (SysSignIn signIn : list) {
            signIn.setSignType("3");
            //查询：图片和语音，这边主要设置语音
            List<SysSignDetail> subList = this.sysSignDetailDao.queryDetailList(signIn.getId(), database);
            for (SysSignDetail img : subList) {
                if (img.getObjType().intValue() == 1) {
                    signIn.setVoiceUrl(img.getPic());
                    break;
                }
            }
        }

        //上下班：SysCheckIn转为SysSignIn
        List<SysCheckIn> checkinList = this.kqCheckInDao.queryCheckInList(database, mid, date);
        for (SysCheckIn checkIn : checkinList) {
            SysSignIn signIn = new SysSignIn();
            signIn.setId(checkIn.getId());
            signIn.setMid(checkIn.getPsnId());
            signIn.setLongitude("" + checkIn.getLongitude());
            signIn.setLatitude("" + checkIn.getLatitude());
            signIn.setAddress(checkIn.getLocation());
            signIn.setSignTime(checkIn.getCheckTime());
            signIn.setRemarks(checkIn.getRemark());
            //tp:1-1上班；1-2：下班
            String tp = checkIn.getTp();
            if ("1-1".equals(tp)) {
                signIn.setSignType("1");
            } else if ("1-2".equals(tp)) {
                signIn.setSignType("2");
            }
            list.add(signIn);
        }

        //排序：按时间升序
        Collections.sort(list, new Comparator<SysSignIn>() {
            @Override
            public int compare(SysSignIn o1, SysSignIn o2) {
                if (!o1.getSignTime().equals(o2.getSignTime())) {
                    return o1.getSignTime().compareTo(o2.getSignTime());
                }
                return 0;
            }
        });

        return list;
    }


}
