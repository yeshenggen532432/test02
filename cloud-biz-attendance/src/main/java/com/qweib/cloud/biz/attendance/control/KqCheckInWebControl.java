package com.qweib.cloud.biz.attendance.control;


import com.qweib.cloud.biz.attendance.model.KqBc;
import com.qweib.cloud.biz.attendance.model.KqEmpRule;
import com.qweib.cloud.biz.attendance.service.KqDetailService;
import com.qweib.cloud.biz.system.BaseWebService;
import com.qweib.cloud.biz.system.TokenServer;
import com.qweib.cloud.biz.system.UploadFile;
import com.qweib.cloud.biz.system.job.CronJobService;
import com.qweib.cloud.biz.system.service.ws.BscCheckRuleWebService;
import com.qweib.cloud.biz.system.service.ws.SysCheckInService;
import com.qweib.cloud.biz.system.service.ws.SysDepartService;
import com.qweib.cloud.biz.system.service.ws.SysMemWebService;
import com.qweib.cloud.core.domain.*;
import com.qweib.cloud.utils.DateTimeUtil;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/web")
public class KqCheckInWebControl extends BaseWebService {

    @Resource
    private SysCheckInService sysCheckInService;
    @Resource
    private SysMemWebService memWebService;
    @Resource
    private KqDetailService detailService;
    @Resource
    private CronJobService cronJobService;


    /**
     * 添加签到记录
     *
     * @param request
     * @param response
     * @param token      口令(必填)
     * @param jobContent 工作内容(必填)
     * @param location   位置 (必填)
     * @param remark     位置备注
     * @param tp         1-1 上班签到 2 外出考勤 1-2 下班签到
     */
    @RequestMapping("addCheckin")
    public void addCheckin(HttpServletRequest request, HttpServletResponse response, String token, String jobContent, String location, String remark, String tp, Double longitude, Double latitude) {
        String msg1 = "";
        String msg2 = "";
        String msg3 = "";
        try {
            if (!checkParam(response, location, tp, longitude, latitude))
                return;

            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            OnlineUser onlineUser = message.getOnlineMember();
            //判断当天不能重复签到，签退
			/*SysCheckIn sysCheckIn=this.sysCheckInService.queryCheckBydqdate(onlineUser.getDatabase(), onlineUser.getMemId());
			if(!StrUtil.isNull(sysCheckIn)){
				if(sysCheckIn.getTp().equals(tp)){
					if(tp.equals("1-1")){
						this.sendJsonResponse(response, "{\"state\":-1,\"msg\":\"您已经上班签到了不能再签到\"}");
						return;
					}else if(tp.equals("1-2")){
						this.sendJsonResponse(response, "{\"state\":-1,\"msg\":\"您已经下班签到了不能再签到\"}");
						return;
					}
				}
			}*/
            String kqSts = "";
            String ymd = DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd");
            KqBc bcRec = this.detailService.getEmpBcByDate(onlineUser.getMemId(), ymd, onlineUser.getDatabase());
            if (bcRec != null) {
                if (bcRec.getLatitude().length() > 1 && bcRec.getLongitude().length() > 1 && bcRec.getOutOf().intValue() == 0) {
                    double latitude1 = Double.valueOf(bcRec.getLatitude());
                    double longitude1 = Double.valueOf(bcRec.getLongitude());

                    int cd = StrUtil.GetDistance(longitude, latitude, longitude1, latitude1);
                    if (bcRec.getAreaLong().intValue() < cd) {
                        kqSts = "考勤位置错误";
                        //this.sendJsonResponse(response, "{\"state\":-1,\"msg\":\"您不在考勤范围内\"}");
                        //return;

                    }
                }
            }

            if (StrUtil.isNull(onlineUser.getDatabase())) {
                this.sendJsonResponse(response, "{\"state\":-1,\"msg\":\"您没有所属公司不能签到\"}");
                return;
            }
            if ("2".equals(tp)) {
                if (StrUtil.isNull(jobContent)) {
                    this.sendJsonResponse(response, "{\"state\":-1,\"msg\":\"工作内容必填\"}");
                    return;
                }
                msg1 = "反馈成功";
                msg2 = "反馈失败";
//				msg3="已反馈";
            } else if ("1".equals(tp.substring(0, 1))) {
                msg1 = "考勤成功";
                msg2 = "考勤失败";
                msg3 = "请勿重复考勤";
                if (StrUtil.isNull(jobContent)) {
                    jobContent = "";
                }
                //String t = new SimpleDateFormat("yyyy-MM-dd").format(new Date());
                //Integer temp = this.sysCheckInService.queryCheckByMidAndTime(onlineUser.getMemId(),t,onlineUser.getDatabase(),tp);
                //if(temp>0){
                //this.sendJsonResponse(response, "{\"state\":-1,\"msg\":\""+msg3+"\"}");
                //return;
                //}
            }
            String checkTime = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date());
            String sftime = new SimpleDateFormat("HH:mm").format(new Date());
            List<SysCheckinPic> picList = new ArrayList<SysCheckinPic>();
            SysCheckIn checkin = new SysCheckIn();
            checkin.setPsnId(onlineUser.getMemId());
            checkin.setCheckTime(checkTime);
            checkin.setJobContent(jobContent);
            checkin.setTp(tp);
            checkin.setLongitude(longitude);
            checkin.setLatitude(latitude);
            Map<String, Object> map = UploadFile.updatePhotos(request, onlineUser.getDatabase(), "check", 1);
            if ("1".equals(map.get("state"))) {
                if ("1".equals(map.get("ifImg"))) {//是否有图片
                    SysCheckinPic btp = new SysCheckinPic();
                    List<String> pic = (List<String>) map.get("fileNames");
                    List<String> picMini = (List<String>) map.get("smallFile");
                    for (int i = 0; i < pic.size(); i++) {
                        btp = new SysCheckinPic();
                        btp.setPic(pic.get(i));
                        btp.setPicMini(picMini.get(i));
                        picList.add(btp);
                    }
                }
            } else {
                sendWarm(response, "图片上传失败");
            }
            checkin.setCdzt(kqSts);
            checkin.setLocation(location);
            checkin.setRemark(remark);
            String sbType = request.getParameter("sbType");//上报方式
            if (!StrUtil.isNull(sbType)) {
                checkin.setSbType(Integer.parseInt(sbType));
            }

            int id = sysCheckInService.addCheck(checkin, onlineUser.getDatabase(), picList);
            if("1-1".equals(checkin.getTp())){
                    cronJobService.workOvertimeAutoDown(onlineUser.getFdCompanyId(), onlineUser.getMemId(),onlineUser.getDatabase());
            }else {
                cronJobService.delWorkOvertimeAutoDown(onlineUser.getFdCompanyId(), onlineUser.getMemId());
            }
            if (!StrUtil.isNull(id)) {
                this.sendJsonResponse(response, "{\"state\":1,\"msg\":\"" + msg1 + "\"}");
            } else {
                this.sendJsonResponse(response, "{\"state\":-1,\"msg\":\"" + msg2 + "\"}");
            }
            String loc_time = Long.toString(System.currentTimeMillis()).substring(0, 10);
            String urls = "http://api.map.baidu.com/trace/v2/track/addpoint";
            String parameters = "ak=ak=gIzggYvrqG7zD5MCsFwSjKOkU8yv8SsC&service_id=117170&latitude=0&longitude=0&coord_type=1" +
                    "&loc_time=" + loc_time + "&entity_name=" + onlineUser.getMemId() + "";
            //MapGjTool.postMapGjurl(urls, parameters);
            if (checkin.getTp().equals("1-2")) {
                String endDate = checkin.getCheckTime().substring(0, 10);
                Date dt = DateTimeUtil.getStrToDate(endDate, "yyyy-MM-dd");
                dt = DateTimeUtil.addDay(dt, 1);
                endDate = DateTimeUtil.getDateToStr(dt, "yyyy-MM-dd");
                Date lastDt = DateTimeUtil.addMonth(dt, -1);
                String lastKqDate = this.detailService.getLastKqDate(checkin.getPsnId(), endDate, onlineUser.getDatabase());
                if (lastKqDate.length() == 0) lastKqDate = DateTimeUtil.getDateToStr(lastDt, "yyyy-MM-dd");
                KqEmpRule emp = new KqEmpRule();
                emp.setSdate(lastKqDate);
                emp.setEdate(endDate);
                emp.setMemberId(checkin.getPsnId());
                detailService.addKqDetail(emp, onlineUser.getDatabase());
            }
        } catch (Exception e) {
            sendException(response, e);
        }
    }


    /**
     * 签到分页（旧版本接口）
     *
     * @param token
     * @param pageNo   当前的页数(必选项，默认第1页)
     * @param pageSize 每页的记录条数(必选项,默认10条)
     * @param tp       1 签到 2 外出反馈
     */
    @RequestMapping("checkinList")
    public void checkinList(HttpServletResponse response, String token, Integer pageNo, Integer pageSize, String tp) {
        if (!checkParam(response, token))
            return;

        if (null == pageSize) {
            pageSize = 10;
        }
        if (null == pageNo) {
            pageNo = 1;
        }
        try {
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            OnlineUser onlineUser = message.getOnlineMember();
            Page page = this.sysCheckInService.page(null, pageNo, pageSize, onlineUser.getDatabase(), onlineUser.getMemId(), tp);
            if (page.getTotal() == 0) {
                sendSuccess(response, "暂时没有签到信息");
                return;
            }
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "查询成功");
            json.put("rows", page.getRows());
            sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            sendException(response, e);
        }
    }
    /**
     * 签到分页（新版本接口）
     * @param token
     * @param pageNo    当前的页数(必选项，默认第1页)
     * @param pageSize 每页的记录条数(必选项,默认10条)

     @RequestMapping("newCheckinlist") public void newCheckinlist(HttpServletResponse response,String token,Integer pageNo,Integer pageSize){
     if (!checkParam(response, token))
     return;

     if(null==pageSize){
     pageSize = 10;
     }
     if(null==pageNo){
     pageNo = 1;
     }
     try{
     OnlineMessage message = TokenServer.tokenCheck(token);
     if(message.isSuccess()==false){
     sendWarm(response, message.getMessage());
     return;
     }
     OnlineUser onlineUser = message.getOnlineMember();
     Page page = this.sysCheckInService.pageList(pageNo, pageSize,onlineUser.getDatabase(),onlineUser.getMemId());
     if(page.getTotal()==0){
     sendSuccess(response, "暂时没有签到信息");
     return;
     }
     JSONObject json = new JSONObject();
     json.put("state", true);
     json.put("msg", "查询成功");
     json.put("rows", page.getRows());
     sendJsonResponse(response, json.toString());
     }catch (Exception e) {
     sendException(response, e);
     }
     }*/
    /**
     * 签到分页（新版本接口）
     *
     * @param token
     * @param pageNo   当前的页数(必选项，默认第1页)
     * @param pageSize 每页的记录条数(必选项,默认10条)
     */
    @RequestMapping("newCheckinlist")
    public void newCheckinlist(HttpServletResponse response, String token, Integer pageNo, Integer pageSize, String dates, Integer mid) {
        if (!checkParam(response, token))
            return;

        if (null == pageSize) {
            pageSize = 10;
        }
        if (null == pageNo) {
            pageNo = 1;
        }
        try {
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            OnlineUser onlineUser = message.getOnlineMember();
            if (StrUtil.isNull(mid)) {
                mid = onlineUser.getMemId();
            }
            Page page = this.sysCheckInService.pageCheckInDate(pageNo, pageSize, onlineUser.getDatabase(), mid, dates);
            if (page.getTotal() == 0) {
                sendSuccess(response, "暂时没有签到信息");
                return;
            } else {
                List<SysCheckInDate> list = (List<SysCheckInDate>) page.getRows();
                for (SysCheckInDate checkInDate : list) {
                    checkInDate.setList(this.sysCheckInService.queryCheckInConformLs(onlineUser.getDatabase(), checkInDate.getPsnId(), checkInDate.getCheckTime()));
                }
            }
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "查询成功");
            json.put("rows", page.getRows());
            sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            sendException(response, e);
        }
    }

    /**
     * 签到分页（新版本接口）2
     *
     * @param token
     * @param pageNo   当前的页数(必选项，默认第1页)
     * @param pageSize 每页的记录条数(必选项,默认10条)
     */
    @RequestMapping("newCheckinlist2")
    public void newCheckinlist2(HttpServletResponse response, String token, Integer pageNo, Integer pageSize,
                                String dates, String mids, @RequestParam(defaultValue = "3") String dataTp) {
        if (!checkParam(response, token))
            return;
        if (null == pageSize) {
            pageSize = 10;
        }
        if (null == pageNo) {
            pageNo = 1;
        }
        try {
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            OnlineUser onlineUser = message.getOnlineMember();
            //SysMember member=this.memWebService.queryMember(onlineUser.getMemId(), onlineUser.getDatabase());
            if (!StrUtil.isNull(mids)) {
                mids = mids + "," + onlineUser.getMemId().toString();
            } else {
                mids = onlineUser.getMemId().toString();
            }
            SysMember member = this.memWebService.queryMemBypid(onlineUser.getMemId(), onlineUser.getDatabase());
//			if(member.getIsUnitmng().equals("0")){
//				mids=mids.replace("全部,", "");
//			}
            Page page = this.sysCheckInService.pageCheckInDate2(pageNo, pageSize, onlineUser, mids, dates, dataTp);
            if (page.getTotal() == 0) {
                sendSuccess(response, "暂时没有签到信息");
                return;
            } else {
                List<SysCheckInDate> list = (List<SysCheckInDate>) page.getRows();
                for (SysCheckInDate checkInDate : list) {
                    checkInDate.setList(this.sysCheckInService.queryCheckInConformLs2(onlineUser.getDatabase(), checkInDate.getPsnId(), dates));
                }
            }
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "查询成功");
            json.put("rows", page.getRows());
            sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            sendException(response, e);
        }
    }

    /**
     * 签到分页（新版本接口）3
     */
    @RequestMapping("newCheckinlist3")
    public void newCheckinlist3(HttpServletResponse response, String token, Integer pageNo, Integer pageSize,
                                String sdate, String edate, String mids, @RequestParam(defaultValue = "3") String dataTp) {
        if (!checkParam(response, token))
            return;
        try {
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            OnlineUser onlineUser = message.getOnlineMember();
            //mids:没有默认查自己
//            if (StrUtil.isNull(mids)) {
//                mids = onlineUser.getMemId().toString();
//            }
            if (null == pageSize) {
                pageSize = 10;
            }
            if (null == pageNo) {
                pageNo = 1;
            }
            Page page = this.sysCheckInService.pageCheckInDate3(pageNo, pageSize, onlineUser, mids, sdate, edate, dataTp);
            if (page.getTotal() == 0) {
                sendSuccess(response, "暂时没有签到信息");
                return;
            } else {
                List<SysCheckInDate> list = (List<SysCheckInDate>) page.getRows();
                for (SysCheckInDate checkInDate : list) {
                    checkInDate.setList(this.sysCheckInService.queryCheckInConformLs3(onlineUser.getDatabase(), checkInDate.getPsnId(), sdate, edate));
                }
            }
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "查询成功");
            json.put("rows", page.getRows());
            sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            e.printStackTrace();
            log.error("获取考勤列表失败", e);
            sendException(response, e);
        }
    }

    /**
     * 查询签到详情
     *
     * @param response
     * @param token    令牌(必选项)
     * @param id       公告的id(必选项)
     */
    @RequestMapping("checkinDetails")
    public void noticeDetail(HttpServletRequest request, HttpServletResponse response, String token, Integer id) {
        if (!checkParam(response, token, id))
            return;
        try {
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            OnlineUser onlineUser = message.getOnlineMember();
            SysCheckIn checkin = this.sysCheckInService.queryCheckById(id, onlineUser.getDatabase());
            if (null == checkin) {
                sendWarm(response, "没有找到对应的签到信息");
                return;
            }
            String checkTime = DateTimeUtil.getDateToStr(checkin.getCheckTime(), "yyyy-MM-dd HH:mm", "yyyy-MM-dd HH:mm");
            checkin.setCheckTime(checkTime);
            JSONObject json = new JSONObject(checkin);
            json.put("state", true);
            json.put("msg", "查询成功");
            sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            sendException(response, e);
        }
    }

    public static void main(String[] args) {

        //System.out.println(StrUtil.GetSbTs2("2017-02-15","2017-03-01","周一,周二,周三,周四"));
        //String s="2017-02-22:周三";
        //System.out.println(s.substring(0, s.indexOf(":")));
        //System.out.println(s.substring(s.indexOf(":")+1, s.length()));
        System.out.println(0 % 2);
    }


}
