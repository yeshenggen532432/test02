package com.qweib.cloud.biz.attendance.service;

import com.qweib.cloud.biz.attendance.dao.*;
import com.qweib.cloud.biz.attendance.model.*;
import com.qweib.cloud.core.domain.SysCheckIn;
import com.qweib.cloud.utils.Collections3;
import com.qweib.cloud.utils.DateTimeUtil;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.joda.time.DateTime;
import org.joda.time.DateTimeUtils;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Service
public class KqDetailService {

    @Resource
    private KqDetailDao detailDao;

    @Resource
    private KqEmpRuleDao empRuleDao;

    @Resource
    private KqPbDao pbDao;

    @Resource
    private KqRuleDao ruleDao;

    @Resource
    private KqBcDao bcDao;

    @Resource
    private KqRemarksDao remarksDao;

    @Resource
    private KqStatDao statDao;

    @Resource
    private KqHolidayDao holidayDao;

    @Resource
    private KqJiaDao kqJiaDao;

    public Page queryKqDetailPage(KqEmpRule bo, String database, Integer page, Integer limit) {
        Page p = this.detailDao.queryKqDetailPage(bo, database, page, limit);
        List<KqDetail> list = p.getRows();
        List<KqRemarks> remarksList = this.remarksDao.queryRemarksList(bo, database);
        for (KqDetail vo : list) {
            if (vo.getBcId().intValue() == -1) vo.setBcName("不排班");
            if (vo.getBcId().intValue() == 0) vo.setBcName("休");
            for (KqRemarks mk : remarksList) {
                if (vo.getMemberId().intValue() == mk.getMemberId().intValue() && vo.getKqDate().equals(mk.getKqDate())) {
                    vo.setRemarks1(mk.getRemarks());
                }
            }
        }
        return p;
    }

    private KqRuleDetail getRuleBc(Date curDate, KqRule rule) {
        if (rule.getRuleUnit().intValue() == 0)//天
        {
            int day = DateTimeUtil.getDay(curDate);
            if (rule.getDays().intValue() == 0) return null;
            int cur = day % rule.getDays().intValue();
            if (cur == 0) cur = rule.getDays().intValue();
            for (KqRuleDetail detl : rule.getSubList()) {
                if (detl.getSeqNo().intValue() == cur) {
                    return detl;
                }
            }
            return null;

        }
        if (rule.getRuleUnit().intValue() == 1)//周
        {
            int week = DateTimeUtil.getWeekByDate(curDate);
            if (week == 1) week = 7;
            else week--;
            for (KqRuleDetail detl : rule.getSubList()) {
                if (detl.getSeqNo().intValue() == week) {
                    return detl;
                }
            }
            return null;

        }
        if (rule.getRuleUnit().intValue() == 2)//月
        {
            int day = DateTimeUtil.getDay(curDate);
            for (KqRuleDetail detl : rule.getSubList()) {
                if (detl.getSeqNo().intValue() == day) {
                    return detl;
                }
            }
            return null;

        }
        return null;
    }

    public KqRule getKqRuleById(Integer id, List<KqRule> ruleList) {
        if (id == null) return null;
        for (KqRule rule : ruleList) {
            if (id.intValue() == rule.getId().intValue()) return rule;
        }

        return null;
    }

    public KqBc getBcById(Integer id, List<KqBc> bcList) {
        for (KqBc bc : bcList) {
            if (id.intValue() == bc.getId().intValue()) return bc;
        }
        return null;
    }

    public KqBc getBcById1(Integer id, String database) {
        KqBc bc = this.bcDao.getKqBcById(id, database);
        if (bc == null) return null;
        List<KqBcTimes> subList = this.bcDao.queryBcTimes(bc.getId().toString(), database);
        bc.setSubList(subList);
        return bc;
    }

    public KqPb getPbByDate(String curDate, List<KqPb> pbList) {
        for (KqPb pb : pbList) {
            if (pb.getBcDate().equals(curDate)) {
                return pb;
            }
        }
        return null;
    }

    private boolean checkHaveData(Integer memberId, List<SysCheckIn> checkInList) {
        for (SysCheckIn vo : checkInList) {
            if (vo.getPsnId().intValue() == memberId.intValue()) return true;
        }
        return false;
    }

    private boolean checkInArea(SysCheckIn checkIn, KqBc bc) {
        if (bc.getOutOf().intValue() == 1) return true;
        if (bc.getLatitude().length() == 0) return true;
        if (bc.getLongitude().length() == 0) return true;
        double longitude = Double.parseDouble(bc.getLongitude());
        double latitude = Double.parseDouble(bc.getLatitude());
        if (longitude == 0 || latitude == 0) return true;
        if (checkIn.getCdzt().equals("补签")) return true;
        if (bc.getAreaLong().intValue() == 0) return true;
        int cd = StrUtil.GetDistance(longitude, latitude, checkIn.getLongitude(), checkIn.getLatitude());
        if (bc.getAreaLong().intValue() < cd) {
            return false;
        }
        return true;
    }

    public KqBc getEmpBcByDate(Integer memberId, String ymd, String database) {
        KqPb pb = this.pbDao.getPbByEmpIdAndDate(ymd, memberId, database);
        if (pb != null) {
            KqBc bc = this.bcDao.getKqBcById(pb.getBcId(), database);
            if (bc == null) return null;
            List<KqBcTimes> subList = this.bcDao.queryBcTimes(bc.getId().toString(), database);
            bc.setSubList(subList);
            if (bc != null) return bc;
        }
        KqEmpRule empRule = this.empRuleDao.getRuleByEmpId(memberId, database);
        if (empRule == null) return null;
        KqRule rule = this.ruleDao.getRuleById(empRule.getRuleId(), database);
        if (rule == null) return null;
        try {
            Date curDate = DateTimeUtil.getStrToDate(ymd, "yyyy-MM-dd");


            KqRuleDetail ruleDetail = this.getRuleBc(curDate, rule);
            if (ruleDetail != null) {
                KqBc bc1 = this.bcDao.getKqBcById(ruleDetail.getBcId(), database);
                List<KqBcTimes> subList = this.bcDao.queryBcTimes(bc1.getId().toString(), database);
                bc1.setSubList(subList);
                return bc1;

            }

            return null;
        } catch (Exception e) {
            return null;
        }
    }

    public String getLastKqDate(Integer memberId, String endDate, String database) {
        return this.detailDao.getLastKqDate(memberId, endDate, database);
    }

    public  List<KqBcTimes> getBcTimes(Integer memberId,String database)
    {
        List<KqBcTimes> retList = new ArrayList<KqBcTimes>();
        try {
            String ymd = DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd");
            //先判断是否有排班
            KqPb pb = this.pbDao.getPbByEmpIdAndDate(ymd,memberId,database);
            if(pb!= null)
            {
                KqBc bc = this.bcDao.getKqBcById(pb.getBcId(),database);
                if(bc!= null)
                {
                    List<KqBcTimes> tmpList = this.bcDao.queryBcTimes(bc.getId().toString(),database);
                    return tmpList;
                }
            }
            KqEmpRule emprule = this.empRuleDao.getRuleByEmpId(memberId, database);
            if(emprule!= null)
            {
                KqRule rule = this.ruleDao.getRuleById(emprule.getRuleId(),database);
                if(rule!= null)
                {
                    List<KqRuleDetail> subList = this.ruleDao.queryDetailList(rule.getId().toString(),database);
                    rule.setSubList(subList);
                    KqRuleDetail detl = this.getRuleBc(new Date(),rule);
                    if(detl!= null)
                    {
                        KqBc bc = this.bcDao.getKqBcById(detl.getBcId(),database);
                        if(bc!= null)
                        {
                            List<KqBcTimes> tmpList = this.bcDao.queryBcTimes(bc.getId().toString(),database);
                            return tmpList;
                        }
                    }
                }
            }


        }
        catch (Exception e)
        {

        }
        return retList;
    }

    public boolean checkIsInClassTime(Integer memberId,String database)
    {
        List<KqBcTimes> list = this.getBcTimes(memberId,database);
        if(list.size() == 0)return true;
        KqBc bc = null;
        Date dtNow = new Date();
        if(list.size() > 0)
        {
            KqBcTimes sub = list.get(0);
            bc = this.bcDao.getKqBcById(sub.getBcId(),database);
        }
        try
        {
            String ymd = DateTimeUtil.getDateToStr(new Date(),"yyyy-MM-dd");
            Date dt = DateTimeUtil.addDay(new Date(),1);
            String ymd1 = DateTimeUtil.getDateToStr(dt,"yyyy-MM-dd");
            for(KqBcTimes vo: list)
            {
                Date startTime = DateTimeUtil.getStrToDate(ymd + " " + vo.getStartTime() + ":00","yyyy-MM-dd HH:mm:ss");
                Date endTime = DateTimeUtil.getStrToDate(ymd + " " + vo.getEndTime() + ":00","yyyy-MM-dd HH:mm:ss");
                if(bc != null)
                {
                    if(bc.getCrossDay() == null)bc.setCrossDay(0);
                    if(bc.getCrossDay().intValue() == 1)//跨天
                    {
                        endTime = DateTimeUtil.getStrToDate(ymd + " " + vo.getEndTime() + ":00","yyyy-MM-dd HH:mm:ss");
                    }
                }
                if(dtNow.compareTo(startTime)> 0&&dtNow.compareTo(endTime)< 0)
                {
                    return true;
                }

            }
        }
        catch (Exception e)
        {

        }
        return false;
    }

    public List<KqDetail> addKqDetail(KqEmpRule empRule, String database) throws Exception {
        Page p = this.empRuleDao.queryKqEmpRulePage(empRule, database, 1, 9999);
        List<KqEmpRule> empList = p.getRows();
        //获取规律班
        Page p1 = this.ruleDao.queryKqRulePage(null, database, 1, 9999);
        List<KqRule> ruleList = p1.getRows();
        String ids = "";
        for (KqRule rule : ruleList) {
            if (ids.length() == 0) ids = rule.getId().toString();
            else ids = ids + "," + rule.getId();
        }
        if (ids.length() == 0) ids = "0";
        List<KqRuleDetail> detailList = this.ruleDao.queryDetailList(ids, database);
        for (KqRule rule : ruleList) {
            List<KqRuleDetail> subList = new ArrayList<KqRuleDetail>();
            for (KqRuleDetail detail : detailList) {
                if (rule.getId().intValue() == detail.getRuleId().intValue()) subList.add(detail);
            }
            rule.setSubList(subList);
        }
        KqBc bc = new KqBc();
        Page p2 = this.bcDao.queryKqBc(bc, database, 1, 9999);
        String bcIds = "";
        List<KqBc> bcList = p2.getRows();
        for (KqBc vo : bcList) {
            if (bcIds.length() == 0) bcIds = vo.getId().toString();
            else bcIds = bcIds + "," + vo.getId().toString();
        }
        if (bcIds.length() == 0) bcIds = "0";
        List<KqBcTimes> subList = this.bcDao.queryBcTimes(bcIds, database);
        for (KqBc vo : bcList) {
            List<KqBcTimes> subList1 = new ArrayList<KqBcTimes>();
            for (KqBcTimes time : subList) {
                if (time.getBcId().intValue() == vo.getId().intValue()) {
                    subList1.add(time);
                }
            }
            vo.setSubList(subList1);
        }
        SysCheckIn checkIn = new SysCheckIn();
        //获取签到记录
        KqDetail queryBo = new KqDetail();
        queryBo.setBranchId(empRule.getBranchId());
        queryBo.setMemberId(empRule.getMemberId());
        queryBo.setMemberNm(empRule.getMemberNm());
        Date tmpDate = DateTimeUtil.getStrToDate(empRule.getEdate(), "yyyy-MM-dd");
        tmpDate = DateTimeUtil.dateTimeAdd(tmpDate, 5, 1);//增加一天
        String tmpstr = DateTimeUtil.getDateToStr(tmpDate, "yyyy-MM-dd");
        queryBo.setSdate(empRule.getSdate());
        queryBo.setEdate(tmpstr);
        List<SysCheckIn> checkInList = this.detailDao.getCheckInList(queryBo, database);

        Date startDate = DateTimeUtil.getStrToDate(empRule.getSdate(), "yyyy-MM-dd");
        Date endDate = DateTimeUtil.getStrToDate(empRule.getEdate(), "yyyy-MM-dd");
        Integer days = DateTimeUtil.getDaysDiff(startDate, endDate) - 1;
        List<KqDetail> kqList = new ArrayList<KqDetail>();
        for (KqEmpRule emp : empList) {
            if (emp.getMemberUse().intValue() == 2)//离职
            {
                if (!checkHaveData(emp.getMemberId(), checkInList))
                    continue;
            }
            KqPb pb1 = new KqPb();
            pb1.setMemberId(emp.getMemberId());
            pb1.setSdate(empRule.getSdate());
            pb1.setEdate(empRule.getEdate());
            Page pPb = this.pbDao.queryKqPbPage(pb1, database, 1, 9999);
            List<KqPb> pbList = pPb.getRows();
            for (int i = 0; i < days; i++) {
                Date curDate = DateTimeUtil.dateTimeAdd(startDate, 5, i);
                String yymmdd = DateTimeUtil.getDateToStr(curDate, "yyyy-MM-dd");
                KqDetail kqRec = new KqDetail();
                kqRec.setBranchId(emp.getBranchId());
                kqRec.setDis1(0);
                kqRec.setDis2(0);
                kqRec.setDis11(0);
                kqRec.setDis22(0);
                kqRec.setDto1("");
                kqRec.setDto2("");
                kqRec.setKqDate(yymmdd);
                kqRec.setKqStatus("");
                kqRec.setMemberId(emp.getMemberId());
                kqRec.setMemberNm(emp.getMemberNm());
                kqRec.setMinute1(0);
                kqRec.setMinute2(0);
                kqRec.setRemarks("");
                kqRec.setTfrom1("");
                kqRec.setTfrom2("");
                kqRec.setBcId(-1);
                kqRec.setBcName("不排班");
                kqRec.setBc(null);
                kqRec.setCdMinute(0);
                kqRec.setZtMinute(0);
                KqRule rule = this.getKqRuleById(emp.getRuleId(), ruleList);
                if (rule != null) {
                    KqRuleDetail ruleDetail = this.getRuleBc(curDate, rule);
                    if (ruleDetail != null) {
                        KqBc bc1 = this.getBcById(ruleDetail.getBcId(), bcList);
                        if (bc1 != null) {
                            kqRec.setBcId(bc1.getId());
                            kqRec.setBcName(bc1.getBcName());
                            kqRec.setBc(bc1);

                        } else {
                            kqRec.setBcId(ruleDetail.getBcId());
                            kqRec.setBcName(ruleDetail.getBcName());
                        }
                    }
                }
                //如果有排班，取排班时间
                KqPb pb = this.getPbByDate(yymmdd, pbList);
                if (pb != null) {
                    KqBc bc1 = this.getBcById(pb.getBcId(), bcList);
                    if (bc1 != null) {
                        kqRec.setBcId(bc1.getId());
                        kqRec.setBcName(bc1.getBcName());
                        kqRec.setBc(bc1);
                    } else {
                        kqRec.setBcId(pb.getBcId());
                        kqRec.setBcName(pb.getBcName());
                    }
                }
                //计算班次上班时间，分钟数
                if (kqRec.getBcId().intValue() > 0 && kqRec.getBc() != null) {
                    List<KqBcTimes> timeList = kqRec.getBc().getSubList();
                    Integer minutes = 0;
                    if (timeList.size() > 0) {
                        KqBcTimes t1 = timeList.get(0);
                        Date bcStart = DateTimeUtil.getStrToDate(yymmdd + " " + t1.getStartTime() + ":00", "yyyy-MM-dd HH:mm:ss");
                        String startStr = t1.getStartTime() + "(规)";
                        kqRec.setTfrom1(startStr);
                        Date bcEnd = DateTimeUtil.getStrToDate(yymmdd + " " + t1.getEndTime() + ":00", "yyyy-MM-dd HH:mm:ss");
                        String endStr = t1.getEndTime() + "(规)";
                        kqRec.setDto1(endStr);
                        minutes += getMinutes(bcStart, bcEnd);
                        //FIXME NPE
                        if (kqRec.getBc().getCrossDay().intValue() == 1 && bcEnd.getTime() < bcStart.getTime())//跨天
                        {
                            minutes += 1440;
                            bcEnd = DateTimeUtil.dateTimeAdd(bcEnd, 5, 1);//增加一天
                        }
                        kqRec.setMinute1(minutes);
                        Date dayStart = DateTimeUtil.decMinute(bcStart, kqRec.getBc().getBeforeMinute());//DateTimeUtil.getStrToDate(yymmdd + " 00:00:00", "yyyy-MM-dd HH:mm:ss");
                        Date dayEnd = DateTimeUtil.addMinute(bcEnd, kqRec.getBc().getAfterMinute());//DateTimeUtil.dateTimeAdd(startDate, 5, 1);
                        Date checkin1 = null;
                        Date checkout1 = null;
                        String timeType1 = "实";
                        String timeType2 = "实";
                        for (SysCheckIn checkin : checkInList) {
                            if (checkin.getPsnId().intValue() == kqRec.getMemberId().intValue()) {
                                Date checkTime = DateTimeUtil.getStrToDate(checkin.getCheckTime(), "yyyy-MM-dd HH:mm:ss");
                                if (checkTime.getTime() > dayStart.getTime() && checkTime.getTime() < dayEnd.getTime()) {
                                    if (checkin.getTp().equals("1-1"))//上班以第一次上班为准
                                    {
                                        if (checkin1 == null) {
                                            checkin1 = checkTime;
                                            if (checkin.getCdzt().equals("补签")) timeType1 = "补";
                                        }


                                    }
                                    if (checkin.getTp().equals("1-2"))//以最后下班为准
                                    {
                                        checkout1 = checkTime;
                                        if (checkin.getCdzt().equals("补签")) timeType2 = "补";
                                    }
                                    //if(!this.checkInArea(checkin, kqRec.getBc()))
                                    if (checkin.getCdzt().indexOf("考勤位置错误") > -1) {
                                        if (kqRec.getKqStatus().indexOf("考勤位置错误") == -1) {
                                            String tmpS = kqRec.getKqStatus();
                                            if (tmpS.length() == 0) tmpS = "考勤位置错误";
                                            else tmpS = tmpS + " 考勤位置错误";
                                            kqRec.setKqStatus(tmpS);
                                        }
                                    }

                                }
                            }
                        }
                        if (checkin1 == null && checkout1 == null) {
                            kqRec.setKqStatus("缺勤");
                        } else {
                            if (checkin1 == null || checkout1 == null) {
                                kqRec.setKqStatus("漏卡");
                            } else {
                                Date cdTime = DateTimeUtil.addMinute(bcStart, kqRec.getBc().getEarlyMinute());
                                Date ztTime = DateTimeUtil.decMinute(bcEnd, kqRec.getBc().getLateMinute());
                                if (checkin1.getTime() > cdTime.getTime()) {
                                    kqRec.setKqStatus("迟到");
                                    Integer cdMinutes = DateTimeUtil.getMinutes(cdTime, checkin1);
                                    kqRec.setCdMinute(cdMinutes);
                                }
                                String status = kqRec.getKqStatus();
                                if (checkout1.getTime() < ztTime.getTime()) {
                                    if (status.length() == 0) status = "早退";
                                    else status = status + " 早退";
                                    Integer ztMinutes = DateTimeUtil.getMinutes(checkout1, ztTime);
                                    kqRec.setZtMinute(ztMinutes);
                                    kqRec.setKqStatus(status);
                                }
                                Integer sbminutes = this.getMinutes(checkin1, checkout1);
                                kqRec.setMinute2(sbminutes);
                            }
                            if (checkin1 != null) {
                                String tfrom = kqRec.getTfrom1() + "-" + DateTimeUtil.getDateToStr(checkin1, "HH:mm:ss") + "(" + timeType1 + ")";
                                kqRec.setTfrom1(tfrom);
                                int disminute1 = this.getMinutes(checkin1, bcStart);
                                if (disminute1 < 0) disminute1 = 0;
                                kqRec.setDis1(disminute1);
                            }
                            if (checkout1 != null) {
                                String dto = kqRec.getDto1() + "-" + DateTimeUtil.getDateToStr(checkout1, "HH:mm:ss") + "(" + timeType2 + ")";
                                kqRec.setDto1(dto);
                                int disminute2 = this.getMinutes(bcEnd, checkout1);
                                if (disminute2 < 0) disminute2 = 0;
                                kqRec.setDis2(disminute2);
                            }
                        }


                    }
                    if (timeList.size() > 1) {
                        KqBcTimes t1 = timeList.get(1);
                        Date bcStart = DateTimeUtil.getStrToDate(yymmdd + " " + t1.getStartTime() + ":00", "yyyy-MM-dd HH:mm:ss");
                        String startStr = t1.getStartTime() + "(规)";
                        kqRec.setTfrom2(startStr);
                        Date bcEnd = DateTimeUtil.getStrToDate(yymmdd + " " + t1.getEndTime() + ":00", "yyyy-MM-dd HH:mm:ss");
                        String endStr = t1.getEndTime() + "(规)";
                        kqRec.setDto2(endStr);
                        minutes += getMinutes(bcStart, bcEnd);
                        if (kqRec.getBc().getCrossDay().intValue() == 1 && bcEnd.getTime() < bcStart.getTime())//跨天
                        {
                            minutes += 1440;
                            bcEnd = DateTimeUtil.dateTimeAdd(bcEnd, 5, 1);//增加一天
                        }
                        Date checkin2 = null;
                        Date checkout2 = null;
                        String timeType1 = "实";
                        String timeType2 = "实";
                        Date dayStart = DateTimeUtil.decMinute(bcStart, kqRec.getBc().getBeforeMinute());//DateTimeUtil.getStrToDate(yymmdd + " 00:00:00", "yyyy-MM-dd HH:mm:ss");
                        Date dayEnd = DateTimeUtil.addMinute(bcEnd, kqRec.getBc().getAfterMinute());//DateTimeUtil.dateTimeAdd(startDate, 5, 1);

                        for (SysCheckIn checkin : checkInList) {
                            if (checkin.getPsnId().intValue() == kqRec.getMemberId().intValue()) {
                                Date checkTime = DateTimeUtil.getStrToDate(checkin.getCheckTime(), "yyyy-MM-dd HH:mm:ss");
                                if (checkTime.getTime() > dayStart.getTime() && checkTime.getTime() < dayEnd.getTime()) {
                                    if (checkin.getTp().equals("1-1"))//上班以第一次上班为准
                                    {
                                        if (checkin2 == null) {
                                            checkin2 = checkTime;
                                            if (checkin.getCdzt().equals("补签")) timeType1 = "补";
                                        }
                                    }
                                    if (checkin.getTp().equals("1-2"))//以最后下班为准
                                    {
                                        checkout2 = checkTime;
                                        if (checkin.getCdzt().equals("补签")) timeType2 = "补";
                                    }

                                    //if(!this.checkInArea(checkin, kqRec.getBc()))
                                    if (checkin.getCdzt().indexOf("考勤位置错误") > -1) {
                                        if (kqRec.getKqStatus().indexOf("考勤位置错误") == -1) {
                                            String tmpS = kqRec.getKqStatus();
                                            if (tmpS.length() == 0) tmpS = "考勤位置错误";
                                            else tmpS = tmpS + " 考勤位置错误";
                                            kqRec.setKqStatus(tmpS);
                                        }
                                    }
                                }
                            }
                        }
                        String status = kqRec.getKqStatus();

                        if (checkin2 == null && checkout2 == null) {
                            if (status.length() == 0) status = "缺勤";
                            else status = status + " 缺勤";
                            kqRec.setKqStatus(status);
                        } else {
                            if (checkin2 == null || checkout2 == null) {
                                if (status.length() == 0) status = "漏卡";
                                else status = status + " 漏卡";
                                kqRec.setKqStatus(status);

                            } else {
                                Date cdTime = DateTimeUtil.addMinute(bcStart, kqRec.getBc().getEarlyMinute());
                                Date ztTime = DateTimeUtil.decMinute(bcEnd, kqRec.getBc().getLateMinute());
                                if (checkin2.getTime() > cdTime.getTime()) {
                                    kqRec.setKqStatus("迟到");
                                    Integer cdMinutes = DateTimeUtil.getMinutes(cdTime, checkin2);
                                    kqRec.setCdMinute(kqRec.getCdMinute() + cdMinutes);
                                }
                                status = kqRec.getKqStatus();
                                if (checkout2.getTime() < ztTime.getTime()) {
                                    if (status.length() == 0) status = "早退";
                                    else status = status + " 早退";
                                    Integer ztMinutes = DateTimeUtil.getMinutes(checkout2, ztTime);
                                    kqRec.setZtMinute(kqRec.getZtMinute() + ztMinutes);
                                    kqRec.setKqStatus(status);
                                }
                                int sbminutes = this.getMinutes(checkin2, checkout2);
                                sbminutes += kqRec.getMinute2();
                                kqRec.setMinute2(sbminutes);
                            }
                            if (checkin2 != null) {
                                String tfrom = kqRec.getTfrom2() + "-" + DateTimeUtil.getDateToStr(checkin2, "HH:mm:ss") + "(" + timeType1 + ")";
                                kqRec.setTfrom2(tfrom);
                                int disminute2 = this.getMinutes(checkin2, bcStart);
                                if (disminute2 < 0) disminute2 = 0;
                                kqRec.setDis11(disminute2);
                            }
                            if (checkout2 != null) {
                                String dto = kqRec.getDto2() + "-" + DateTimeUtil.getDateToStr(checkout2, "HH:mm:ss") + "(" + timeType2 + ")";
                                kqRec.setDto2(dto);
                                int disminute22 = this.getMinutes(bcEnd, checkout2);
                                if (disminute22 < 0) disminute22 = 0;
                                kqRec.setDis22(disminute22);
                            }

                        }
                    }
                    kqRec.setMinute1(minutes);

                }
                if (kqRec.getBcId().intValue() == -1)//未排班，并看下是否有刷卡
                {
                    Date dayStart = DateTimeUtil.getStrToDate(kqRec.getKqDate() + " 00:00:00", "yyyy-MM-dd HH:mm:ss");//DateTimeUtil.getStrToDate(yymmdd + " 00:00:00", "yyyy-MM-dd HH:mm:ss");
                    Date dayEnd = DateTimeUtil.dateTimeAdd(dayStart, 5, 1);
                    Date start1 = null;
                    for (SysCheckIn checkin : checkInList) {
                        if (checkin.getPsnId().intValue() == kqRec.getMemberId().intValue()) {
                            Date checkTime = DateTimeUtil.getStrToDate(checkin.getCheckTime(), "yyyy-MM-dd HH:mm:ss");
                            if (checkTime.getTime() > dayStart.getTime() && checkTime.getTime() < dayEnd.getTime()) {
                                String tmpTime = DateTimeUtil.getDateToStr(checkTime, "HH:mm:ss") + "(实)";
                                if (checkin.getTp().equals("1-1"))//上班以第一次上班为准
                                {
                                    if (kqRec.getTfrom1().length() == 0) kqRec.setTfrom1(tmpTime);
                                    else if (kqRec.getTfrom2().length() == 0) kqRec.setTfrom2(tmpTime);
                                    start1 = checkTime;
                                }
                                if (checkin.getTp().equals("1-2"))//以最后下班为准
                                {
                                    if (kqRec.getDto1().length() == 0) kqRec.setDto1(tmpTime);
                                    else if (kqRec.getDto2().length() == 0) kqRec.setDto2(tmpTime);
                                    if (start1 != null) {
                                        Integer workMinutes = DateTimeUtil.getMinutes(start1, checkTime);
                                        if (workMinutes < 0) workMinutes = 0;
                                        kqRec.setMinute2(kqRec.getMinute2() + workMinutes);
                                        start1 = null;
                                    }
                                }
                            }
                        }
                    }
                    if (kqRec.getTfrom1().length() > 0 && kqRec.getDto1().length() == 0) {
                        kqRec.setKqStatus("漏卡");
                    }
                    if (kqRec.getTfrom1().length() == 0 && kqRec.getDto1().length() > 0) {
                        kqRec.setKqStatus("漏卡");
                    }
                    if (kqRec.getTfrom1().length() == 0 && kqRec.getDto1().length() == 0 && kqRec.getTfrom2().length() == 0 && kqRec.getDto2().length() == 0) {
                        kqRec.setKqStatus("缺勤");
                    }
                }
                if (kqRec.getKqStatus().length() == 0) kqRec.setKqStatus("正常");
                if (kqRec.getBcId().intValue() == 0) kqRec.setKqStatus("休息");
                if (this.holidayDao.isInJieJia(kqRec.getKqDate(), database)) {
                    kqRec.setKqStatus("正常(节假日)");
                }
                kqList.add(kqRec);

            }
        }
        this.detailDao.deleteDetail(empRule, database);
        for (KqDetail bo : kqList) {
            this.detailDao.addDetail(bo, database);
        }
        return kqList;
    }


    public Integer getMinutes(Date d1, Date d2) {
        long nm = 1000 * 60;
        long diff = d2.getTime() - d1.getTime();
        Long min = diff / nm;
        return min.intValue();
    }

    private KqDetail getDetail(List<KqDetail> list, Integer memberId, String ymd) {
        for (KqDetail vo : list) {
            if (vo.getMemberId().intValue() == memberId && vo.getKqDate().equals(ymd)) {
                return vo;
            }
        }
        return null;
    }

    private KqRemarks getRemarks(List<KqRemarks> list, Integer memberId, String ymd) {
        for (KqRemarks vo : list) {
            if (vo.getMemberId().intValue() == memberId && vo.getKqDate().equals(ymd)) {
                return vo;
            }
        }
        return null;
    }

    private boolean checkHaveDataInDetail(Integer memberId, List<KqDetail> detailList) {
        for (KqDetail vo : detailList) {
            if (vo.getMemberId().intValue() == memberId.intValue()) {
                return true;
            }
        }
        return false;
    }

    private boolean isKqJia(Integer memberId, String kqDate, List<KqJiaDetail> list) {
        for (KqJiaDetail vo : list) {
            if (vo.getMemberId().intValue() == memberId && vo.getKqDate().equals(kqDate)) {
                return true;
            }
        }
        return false;
    }

    public Page queryKqResult(KqEmpRule emp, String database, Integer page, Integer limit) throws Exception {
        Page p = this.empRuleDao.queryKqEmpRulePage(emp, database, page, limit);
        List<KqEmpRule> empList = p.getRows();
        List<KqResultVo> retList = new ArrayList<KqResultVo>();
        Page detlP = this.detailDao.queryKqDetailPage(emp, database, 1, 9999);
        if (detlP.getTotal() == 0) {
            this.addKqDetail(emp, database);
            detlP = this.detailDao.queryKqDetailPage(emp, database, 1, 9999);
        }
        List<KqDetail> detailList = detlP.getRows();
        List<KqRemarks> remarksList = this.remarksDao.queryRemarksList(emp, database);
        List<KqJiaDetail> jiaDetail = this.kqJiaDao.queryJiaDetail(emp.getSdate(), emp.getEdate(), database);
        for (KqEmpRule empVo : empList) {
            if (empVo.getMemberUse().intValue() == 2) {
                if (!this.checkHaveDataInDetail(empVo.getMemberId(), detailList)) continue;
            }
            KqResultVo vo = new KqResultVo();
            vo.setMemberId(empVo.getMemberId());
            vo.setMemberNm(empVo.getMemberNm());
            Date startDate = DateTimeUtil.getStrToDate(emp.getSdate(), "yyyy-MM-dd");
            Date endDate = DateTimeUtil.getStrToDate(emp.getEdate(), "yyyy-MM-dd");
            Integer days = DateTimeUtil.getDaysDiff(startDate, endDate);
            List<String> strList = new ArrayList<String>();
            List<String> strList1 = new ArrayList<String>();
            List<String> titleList = new ArrayList<String>();
            for (int i = 0; i < days; i++) {
                Date curDate = DateTimeUtil.dateTimeAdd(startDate, 5, i);
                String yymmdd = DateTimeUtil.getDateToStr(curDate, "yyyy-MM-dd");
                KqDetail detail = this.getDetail(detailList, empVo.getMemberId(), yymmdd);
                String str = " ";
                String remarksStr = "";
                Integer seq = i + 1;
                String title = seq.toString();
                if (detail != null) {
                    str = "√";
                    if (detail.getKqStatus().indexOf("迟到") > -1) str = "L";
                    if (detail.getKqStatus().indexOf("早退") > -1) str = "E";
                    if (detail.getKqStatus().indexOf("漏卡") > -1) str = "■";
                    if (detail.getKqStatus().indexOf("缺勤") > -1) str = "×";
                    if (detail.getKqStatus().indexOf("考勤位置错误") > -1) str = "O";
                    if (!detail.getKqStatus().equals("休息") && !detail.getKqStatus().equals("正常")) {
                        KqRemarks remarks = this.getRemarks(remarksList, empVo.getMemberId(), yymmdd);
                        if (remarks != null) {
                            remarksStr = remarks.getRemarks();
                            str = "≠";
                        }
                    }
                    if (this.isKqJia(detail.getMemberId(), detail.getKqDate(), jiaDetail)) {
                        str = "请";
                    }
                    if (detail.getKqStatus().equals("休息")) str = "休";
                    if (detail.getKqStatus().indexOf("节假日") > -1) {
                        str = "节";
                    }
                }
                strList.add(str);
                strList1.add(remarksStr);
                titleList.add(title);
            }
            vo.setDayStr(strList);
            vo.setTitleList(titleList);
            vo.setRemarksList(strList1);
            retList.add(vo);

        }
        p.setRows(retList);
        return p;
    }

    public Page queryKqStatPage(KqEmpRule emp, String database, Integer page, Integer limit) {
        Page p = this.empRuleDao.queryKqEmpRulePage(emp, database, page, limit);
        Page p1 = this.detailDao.queryKqDetailPage(emp, database, 1, 9999);
        if (p1.getTotal() == 0) {

            try {
                this.addKqDetail(emp, database);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        List<KqStat> list = this.statDao.queryKqStatList(emp, p.getRows(), database);
        p.setRows(list);
        return p;
    }

    public Page queryKqRecordPage(KqEmpRule emp, String database, Integer page, Integer limit) throws Exception {
        Page p = this.empRuleDao.queryKqEmpRulePage1(emp, database, page, limit);
        String ids = "";
        List<KqEmpRule> empList = p.getRows();
        if (Collections3.isEmpty(empList)) {
            return p;
        }
        for (KqEmpRule vo : empList) {
            if (ids.length() == 0) ids = vo.getMemberId().toString();
            else ids = ids + "," + vo.getMemberId();
        }
        List<SysCheckIn> checkList = this.detailDao.getCheckInList1(emp.getSdate(), emp.getEdate(), ids, database);
        List<KqRecord> retList = new ArrayList<KqRecord>();
        Date startDate = DateTimeUtil.getStrToDate(emp.getSdate(), "yyyy-MM-dd");
        Date endDate = DateTimeUtil.getStrToDate(emp.getEdate(), "yyyy-MM-dd");
        Integer days = DateTimeUtil.getDaysDiff(startDate, endDate) - 1;
        for (KqEmpRule emp1 : empList) {
            if (emp1.getMemberUse().intValue() == 2) {
                if (!this.checkHaveData(emp1.getMemberId(), checkList)) continue;
            } else if (!this.checkHaveData(emp1.getMemberId(), checkList)) continue;
            for (int i = 0; i < days; i++) {
                Date curDate = DateTimeUtil.dateTimeAdd(startDate, 5, i);
                Date nextDate = DateTimeUtil.dateTimeAdd(curDate, 5, 1);
                String yymmdd = DateTimeUtil.getDateToStr(curDate, "yyyy-MM-dd");
                String week = DateTimeUtil.getWeekNameByDate(curDate);
                KqRecord vo = new KqRecord();
                vo.setMemberId(emp1.getMemberId());
                vo.setMemberNm(emp1.getMemberNm());

                vo.setKqDate(yymmdd + " " + week);
                vo.setTime1("");
                vo.setTime2("");
                vo.setTime3("");
                vo.setTime4("");
                int cur = 0;
                for (SysCheckIn checkin : checkList) {
                    Date checkTime = DateTimeUtil.getStrToDate(checkin.getCheckTime(), "yyyy-MM-dd HH:mm:ss");
                    if (checkTime.getTime() > curDate.getTime() && checkTime.getTime() < nextDate.getTime() && checkin.getPsnId().intValue() == vo.getMemberId().intValue()) {
                        String time = checkin.getCheckTime().substring(11, 16);
                        if (cur == 0) vo.setTime1(time);
                        if (cur == 1) vo.setTime2(time);
                        if (cur == 2) vo.setTime3(time);
                        if (cur == 3) vo.setTime4(time);//最多4次
                        cur++;
                    }
                    if (cur > 3) break;
                }
                if (StrUtil.isNull(vo.getTime1()) && StrUtil.isNull(vo.getTime2()) && StrUtil.isNull(vo.getTime3()) && StrUtil.isNull(vo.getTime4()))
                    continue;
                retList.add(vo);
            }
        }
        p.setRows(retList);
        return p;
    }

    public int addKqRemarks(KqRemarks bo, String database) {
        this.remarksDao.deleteRemarks1(bo, database);
        bo.setStatus(0);
        return this.remarksDao.addRemarks(bo, database);
    }

    public int deleteRemarks(KqRemarks bo, String database) {
        return this.remarksDao.deleteRemarks1(bo, database);
    }

}
