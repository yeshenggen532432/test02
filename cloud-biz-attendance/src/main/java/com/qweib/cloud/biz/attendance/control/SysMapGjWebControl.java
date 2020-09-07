package com.qweib.cloud.biz.attendance.control;


import com.qweib.cloud.biz.attendance.service.KqDetailService;
import com.qweib.cloud.biz.system.BaseWebService;
import com.qweib.cloud.biz.system.QiniuControl;
import com.qweib.cloud.biz.system.TokenServer;
import com.qweib.cloud.biz.system.service.SysZcusrService;
import com.qweib.cloud.biz.system.service.plat.SysCorporationService;
import com.qweib.cloud.biz.system.service.plat.SysMemberService;
import com.qweib.cloud.biz.system.service.ws.SysCheckInService;
import com.qweib.cloud.biz.system.service.ws.SysMemberWebService;
import com.qweib.cloud.core.domain.*;
import com.qweib.cloud.utils.DateTimeUtil;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Controller
@RequestMapping("/web")
public class SysMapGjWebControl extends BaseWebService {
    @Resource
    private SysMemberService memberService;
    @Resource
    private SysCheckInService checkInService;
    @Resource
    private SysZcusrService zcusrService;
    @Resource
    private SysCorporationService corporationService;
    @Resource
    private SysMemberWebService memberWebService;

    @Resource
    private KqDetailService kqDetailService;

    /**
     * 说明：分页查询所有成员最新轨迹
     *
     * @创建：作者:llp 创建时间：2016-3-3
     * @修改历史： [序号](llp 2016 - 3 - 3)<修改说明>
     */
    @RequestMapping("queryMapGjLs")
    public void queryMapGjLs(HttpServletResponse response, String token, Integer pageNo, Integer pageSize) {
        StringBuffer sb = new StringBuffer();
        List<MapGjMd> infoList = new ArrayList<MapGjMd>();
        try {
            if (!checkParam(response, token))
                return;
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            if (pageSize == null) {
                pageSize = 15;
            }
            OnlineUser onlineUser = message.getOnlineMember();
            String entityNms = String.valueOf(onlineUser.getMemId());
            SysZcusr zcusr = this.zcusrService.querycusrIds(onlineUser.getDatabase(), onlineUser.getMemId());
            String zt = "1";
            if (!StrUtil.isNull(zcusr)) {
                if (!StrUtil.isNull(zcusr.getCusrIds())) {
                    entityNms = zcusr.getCusrIds() + "," + entityNms;
                    zt = "2";
                }
            }
            URL url = new URL("http://api.map.baidu.com/trace/v2/entity/list?ak=gIzggYvrqG7zD5MCsFwSjKOkU8yv8SsC&service_id=117170&page_index=" + pageNo + "&page_size=" + pageSize + "&entity_names=" + entityNms + "");
            HttpURLConnection httpUrlConn = (HttpURLConnection) url.openConnection();
            httpUrlConn.setDoOutput(false);
            httpUrlConn.setDoInput(true);
            httpUrlConn.setUseCaches(false);
            httpUrlConn.setRequestMethod("GET");
            httpUrlConn.connect();
            // 将返回的输入流转换成字符串  
            InputStream inputStream = httpUrlConn.getInputStream();
            InputStreamReader isr = new InputStreamReader(inputStream, "UTF-8");
            char[] buffer = new char[1];
            while (isr.read(buffer) != -1) {
                sb.append(buffer);
            }
            isr.close();
            // 释放资源  
            inputStream.close();
            inputStream = null;
            httpUrlConn.disconnect();
            String js = sb.toString();
            JSONObject dataJson = new JSONObject(js);
            JSONArray data = dataJson.getJSONArray("entities");
            for (int i = 0; i < data.length(); i++) {
                JSONObject info = data.getJSONObject(i);
                MapGjMd md = new MapGjMd();
                Integer userId = Integer.parseInt(info.getString("entity_name"));
                String location = info.getJSONObject("realtime_point").get("location").toString();
                md.setUserId(userId);
                SysMember member = this.memberService.querySysMemberById(userId);
                String memberUse = "";
                if (!StrUtil.isNull(member)) {
                    md.setUserNm(member.getMemberNm());
                    md.setUserTel(member.getMemberMobile());
                    md.setUserHead(member.getMemberHead());
                    memberUse = member.getMemberUse();
                }
                //转换地址
                StringBuffer sb2 = new StringBuffer();
                String lng = location.substring(1, location.indexOf(","));//
                String lat = location.substring(location.indexOf(",") + 1, location.length() - 1);//纬度
                URL url2 = new URL("http://api.map.baidu.com/geocoder/v2/?ak=gIzggYvrqG7zD5MCsFwSjKOkU8yv8SsC&location=" + lat + "," + lng + "&output=json&pois=1");
                HttpURLConnection httpUrlConn2 = (HttpURLConnection) url2.openConnection();
                httpUrlConn2.setDoOutput(false);
                httpUrlConn2.setDoInput(true);
                httpUrlConn2.setUseCaches(false);
                httpUrlConn2.setRequestMethod("GET");
                httpUrlConn2.connect();
                // 将返回的输入流转换成字符串
                InputStream inputStream2 = httpUrlConn2.getInputStream();
                InputStreamReader isr2 = new InputStreamReader(inputStream2, "UTF-8");
                char[] buffer2 = new char[1];
                while (isr2.read(buffer2) != -1) {
                    sb2.append(buffer2);
                }
                isr2.close();
                // 释放资源
                inputStream2.close();
                inputStream2 = null;
                httpUrlConn2.disconnect();
                String js2 = sb2.toString();
                JSONObject dataJson2 = new JSONObject(js2);
                String s2 = dataJson2.getJSONObject("result").getString("formatted_address");
                md.setLocation(location);
                String times = info.getString("modify_time");
                md.setTimes(times);
                SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                Date d1 = format.parse(times);
                Date d2 = format.parse(DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd HH:mm:ss"));
                long diff = d2.getTime() - d1.getTime();
                long Days = diff / (24 * 60 * 60 * 1000);
                long Hours = diff / (60 * 60 * 1000) % 24;
                long Minutes = diff / (60 * 1000) % 60 + (Hours * 60) + (Days * 24 * 60);
                SysCheckIn checkIn = this.checkInService.queryCheckBydqdate(onlineUser.getDatabase(), userId);
                SysCheckIn checkIn2 = this.checkInService.queryCheckBydqdate2(onlineUser.getDatabase(), userId);
                if (memberUse.equals("2")) {
                    md.setZt("离职");
                    if (StrUtil.isNull(s2)) {
                        md.setAddress("暂无轨迹信息");
                    } else {
                        md.setAddress(s2);
                    }
                } else {
                    if (!StrUtil.isNull(checkIn)) {
                        if (checkIn.getTp().equals("1-2")) {
                            md.setZt("下班");
                            if (StrUtil.isNull(s2)) {
                                md.setAddress("暂无轨迹信息");
                            } else {
                                md.setAddress(s2);
                            }
                        } else {
                            if (Minutes <= 30) {
                                md.setZt("在线");
                                if (StrUtil.isNull(s2)) {
                                    if (Minutes <= 5) {
                                        md.setAddress("正在定位中,请稍后..");
                                    } else {
                                        md.setAddress("暂无轨迹信息");
                                    }
                                } else {
                                    md.setAddress(s2);
                                }
                            } else {
                                md.setZt("异常");
                                if (StrUtil.isNull(s2)) {
                                    md.setAddress("暂无轨迹信息");
                                } else {
                                    md.setAddress(s2);
                                }
                            }
                        }
                    } else {
                        if (Minutes <= 30) {
                            md.setZt("在线");
                            if (StrUtil.isNull(s2)) {
                                if (Minutes <= 5) {
                                    md.setAddress("正在定位中,请稍后..");
                                } else {
                                    md.setAddress("暂无轨迹信息");
                                }
                            } else {
                                md.setAddress(s2);
                            }
                        } else {
                            md.setZt("异常");
                            if (StrUtil.isNull(s2)) {
                                md.setAddress("暂无轨迹信息");
                            } else {
                                md.setAddress(s2);
                            }
                        }
                        if (!StrUtil.isNull(checkIn2)) {
                            if (checkIn2.getTp().equals("1-2")) {
                                md.setZt("下班");
                                if (StrUtil.isNull(s2)) {
                                    md.setAddress("暂无轨迹信息");
                                } else {
                                    md.setAddress(s2);
                                }
                            }
                        }
                    }
                    infoList.add(md);
                }
            }
            Page p = new Page();
            p.setRows(infoList);
            p.setTotal(dataJson.getInt("total"));
            p.setPageSize(pageSize);
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "获取所有成员最新轨迹列表成功");
            json.put("zt", zt);
            json.put("pageNo", pageNo);
            json.put("pageSize", pageSize);
            json.put("total", p.getTotal());
            json.put("totalPage", p.getTotalPage());
            json.put("rows", p.getRows());
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            this.sendWarm(response, "获取所有成员最新轨迹列表失败");
        }
    }

    /**
     * 说明：分页查询所有成员最新轨迹2
     *
     * @创建：作者:llp 创建时间：2016-7-1
     * @修改历史： [序号](llp 2016 - 7 - 1)<修改说明>
     */
    @RequestMapping("queryMapGjLs2")
    public void queryMapGjLs2(HttpServletResponse response, String token, Integer pageNo, Integer pageSize, String entityNms) {
        StringBuffer sb = new StringBuffer();
        List<MapGjMd> infoList = new ArrayList<MapGjMd>();
        try {
            if (!checkParam(response, token))
                return;
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            if (pageSize == null) {
                pageSize = 15;
            }
            OnlineUser onlineUser = message.getOnlineMember();
            URL url = null;
            String zt = "1";
            if (!StrUtil.isNull(entityNms)) {
                entityNms = entityNms + "," + String.valueOf(onlineUser.getMemId());
                zt = "2";
                url = new URL("http://api.map.baidu.com/trace/v2/entity/list?ak=gIzggYvrqG7zD5MCsFwSjKOkU8yv8SsC&service_id=117170&page_index=" + pageNo + "&page_size=" + pageSize + "&entity_names=" + entityNms + "");
            } else {
                entityNms = String.valueOf(onlineUser.getMemId());
                SysZcusr zcusr = this.zcusrService.querycusrIds(onlineUser.getDatabase(), onlineUser.getMemId());
                if (!StrUtil.isNull(zcusr)) {
                    if (!StrUtil.isNull(zcusr.getCusrIds())) {
                        entityNms = zcusr.getCusrIds() + "," + entityNms;
                        zt = "2";
                    }
                }
                url = new URL("http://api.map.baidu.com/trace/v2/entity/list?ak=gIzggYvrqG7zD5MCsFwSjKOkU8yv8SsC&service_id=117170&page_index=" + pageNo + "&page_size=" + pageSize + "&entity_names=" + entityNms + "");
            }
            HttpURLConnection httpUrlConn = (HttpURLConnection) url.openConnection();
            httpUrlConn.setDoOutput(false);
            httpUrlConn.setDoInput(true);
            httpUrlConn.setUseCaches(false);
            httpUrlConn.setRequestMethod("GET");
            httpUrlConn.connect();
            // 将返回的输入流转换成字符串  
            InputStream inputStream = httpUrlConn.getInputStream();
            InputStreamReader isr = new InputStreamReader(inputStream, "UTF-8");
            char[] buffer = new char[1];
            while (isr.read(buffer) != -1) {
                sb.append(buffer);
            }
            isr.close();
            // 释放资源  
            inputStream.close();
            inputStream = null;
            httpUrlConn.disconnect();
            String js = sb.toString();
            JSONObject dataJson = new JSONObject(js);
            JSONArray data = dataJson.getJSONArray("entities");
            for (int i = 0; i < data.length(); i++) {
                JSONObject info = data.getJSONObject(i);
                Integer userId = Integer.parseInt(info.getString("entity_name"));
                SysMember member = this.memberService.querySysMemberById1(onlineUser.getDatabase(), userId);
                if (!StrUtil.isNull(member)) {
                    String location = info.getJSONObject("realtime_point").get("location").toString();
                    MapGjMd md = new MapGjMd();
                    md.setUserId(userId);
                    String memberUse = "";
                    md.setUserNm(member.getMemberNm());
                    md.setUserTel(member.getMemberMobile());
                    md.setUserHead(member.getMemberHead());
                    memberUse = member.getMemberUse();

                    //转换地址
                    StringBuffer sb2 = new StringBuffer();
                    String lng = location.substring(1, location.indexOf(","));//
                    String lat = location.substring(location.indexOf(",") + 1, location.length() - 1);//纬度
                    URL url2 = new URL("http://api.map.baidu.com/geocoder/v2/?ak=gIzggYvrqG7zD5MCsFwSjKOkU8yv8SsC&location=" + lat + "," + lng + "&output=json&pois=1");
                    HttpURLConnection httpUrlConn2 = (HttpURLConnection) url2.openConnection();
                    httpUrlConn2.setDoOutput(false);
                    httpUrlConn2.setDoInput(true);
                    httpUrlConn2.setUseCaches(false);
                    httpUrlConn2.setRequestMethod("GET");
                    httpUrlConn2.connect();
                    // 将返回的输入流转换成字符串
                    InputStream inputStream2 = httpUrlConn2.getInputStream();
                    InputStreamReader isr2 = new InputStreamReader(inputStream2, "UTF-8");
                    char[] buffer2 = new char[1];
                    while (isr2.read(buffer2) != -1) {
                        sb2.append(buffer2);
                    }
                    isr2.close();
                    // 释放资源
                    inputStream2.close();
                    inputStream2 = null;
                    httpUrlConn2.disconnect();
                    String js2 = sb2.toString();
                    JSONObject dataJson2 = new JSONObject(js2);
                    String s2 = dataJson2.getJSONObject("result").getString("formatted_address");
                    md.setLocation(location);
                    String times = StrUtil.stampToDate(Long.parseLong(info.getJSONObject("realtime_point").get("loc_time").toString()));
                    md.setTimes(times);
                    SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                    Date d1 = format.parse(times);
                    Date d2 = format.parse(DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd HH:mm:ss"));
                    long diff = d2.getTime() - d1.getTime();
                    long Days = diff / (24 * 60 * 60 * 1000);
                    long Hours = diff / (60 * 60 * 1000) % 24;
                    long Minutes = diff / (60 * 1000) % 60 + (Hours * 60) + (Days * 24 * 60);
                    SysCheckIn checkIn = this.checkInService.queryCheckBydqdate(onlineUser.getDatabase(), userId);
                    SysCheckIn checkIn2 = this.checkInService.queryCheckBydqdate2(onlineUser.getDatabase(), userId);
                    if (memberUse.equals("2")) {
                        md.setZt("离职");
                        if (StrUtil.isNull(s2)) {
                            md.setAddress("暂无轨迹信息");
                        } else {
                            md.setAddress(s2);
                        }
                    } else {
                        if (!StrUtil.isNull(checkIn)) {
                            if (checkIn.getTp().equals("1-2")) {
                                md.setZt("下班");
                                if (StrUtil.isNull(s2)) {
                                    md.setAddress("暂无轨迹信息");
                                } else {
                                    md.setAddress(s2);
                                }
                            } else {
                                if (Minutes <= 30) {
                                    md.setZt("在线");
                                    if (StrUtil.isNull(s2)) {
                                        if (Minutes <= 5) {
                                            md.setAddress("正在定位中,请稍后..");
                                        } else {
                                            md.setAddress("暂无轨迹信息");
                                        }
                                    } else {
                                        md.setAddress(s2);
                                    }
                                } else {
                                    md.setZt("异常");
                                    if (StrUtil.isNull(s2)) {
                                        md.setAddress("暂无轨迹信息");
                                    } else {
                                        md.setAddress(s2);
                                    }
                                }
                            }
                        } else {
                            if (Minutes <= 30) {
                                md.setZt("在线");
                                if (StrUtil.isNull(s2)) {
                                    if (Minutes <= 5) {
                                        md.setAddress("正在定位中,请稍后..");
                                    } else {
                                        md.setAddress("暂无轨迹信息");
                                    }
                                } else {
                                    md.setAddress(s2);
                                }
                            } else {
                                md.setZt("异常");
                                if (StrUtil.isNull(s2)) {
                                    md.setAddress("暂无轨迹信息");
                                } else {
                                    md.setAddress(s2);
                                }
                            }
                            if (!StrUtil.isNull(checkIn2)) {
                                if (checkIn2.getTp().equals("1-2")) {
                                    md.setZt("下班");
                                    if (StrUtil.isNull(s2)) {
                                        md.setAddress("暂无轨迹信息");
                                    } else {
                                        md.setAddress(s2);
                                    }
                                }
                            }
                        }
                        infoList.add(md);
                    }
                }
            }
            Page p = new Page();
            p.setRows(infoList);
            p.setTotal(dataJson.getInt("total"));
            p.setPageSize(pageSize);
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "获取所有成员最新轨迹列表成功");
            json.put("zt", zt);
            json.put("pageNo", pageNo);
            json.put("pageSize", pageSize);
            json.put("total", p.getTotal());
            json.put("totalPage", p.getTotalPage());
            json.put("rows", p.getRows());
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            this.sendWarm(response, "获取所有成员最新轨迹列表失败");
        }
    }

    /**
     * 说明：分页查询所有成员最新轨迹2(长链接)
     *
     * @创建：作者:llp 创建时间：2017-3-18
     * @修改历史： [序号](llp 2017 - 3 - 18)<修改说明>
     */
    @RequestMapping("queryMapGjLsClj2")
    public void queryMapGjLsClj2(HttpServletResponse response, String token, Integer pageNo, Integer pageSize,
                                 String entityNms, @RequestParam(defaultValue = "3") String dataTp, String mids) {
        StringBuffer sb = new StringBuffer();
        List<MapGjMd> infoList = new ArrayList<MapGjMd>();
        try {
            if (!checkParam(response, token))
                return;
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
//			if (StrUtil.isNull(dataTp)) {
//				sendWarm(response, CnlifeConstants.VIEW_MESSAGE);
//				return;
//			}
            if (pageSize == null) {
                pageSize = 15;
            }
            OnlineUser onlineUser = message.getOnlineMember();
            SysCorporation corporation = this.corporationService.queryCorporationBydata(onlineUser.getDatabase());
            URL url = null;
            String zt = "1";
            if (!StrUtil.isNull(entityNms)) {//查询的用户不为空，根据条件查询
                entityNms = entityNms + "," + String.valueOf(onlineUser.getMemId());
                zt = "2";
            } else {//查询用户为空，则根据不同的角色数据展示
//				entityNms=String.valueOf(onlineUser.getMemId());
//				SysZcusr zcusr=this.zcusrService.querycusrIds(onlineUser.getDatabase(),onlineUser.getMemId());
//				if(!StrUtil.isNull(zcusr)){
//					if(!StrUtil.isNull(zcusr.getCusrIds())){
//						entityNms=zcusr.getCusrIds()+","+entityNms;
//						zt="2";
//					}
//				}
                entityNms = "";
                if ("2".equals(dataTp)) {//部门以及子部门数据
                    SysMember m = this.memberWebService.queryAllById(onlineUser.getMemId());
                    String str = this.memberWebService.queryMidStr(onlineUser.getDatabase(), m.getBranchId()).get("str").toString();
                    entityNms = str;
                    zt = "2";
                } else if ("3".equals(dataTp)) {//个人数据
                    entityNms = String.valueOf(onlineUser.getMemId());
                }
                if (!StrUtil.isNull(mids)) {
                    entityNms = mids + "," + onlineUser.getMemId();
                }
            }
            if (StrUtil.isNull(entityNms)) {//dataTp=1的情况
                url = new URL(QiniuControl.GPS_SERVICE_URL + "/Company/getLastLocation?company_id=" + corporation.getDeptId() + "&page=" + pageNo + "&page_size=" + pageSize);
            } else {
                url = new URL(QiniuControl.GPS_SERVICE_URL + "/Company/getLastLocation?company_id=" + corporation.getDeptId() + "&page=" + pageNo + "&page_size=" + pageSize + "&user_id=" + entityNms + "");
            }
//			url = new URL("http://103.27.7.117/Company/getLastLocation?company_id="+corporation.getDeptId()+"&page="+pageNo+"&page_size="+pageSize+"&user_id="+entityNms+"");
            HttpURLConnection httpUrlConn = (HttpURLConnection) url.openConnection();
            httpUrlConn.setDoOutput(false);
            httpUrlConn.setDoInput(true);
            httpUrlConn.setUseCaches(false);
            httpUrlConn.setRequestMethod("GET");
            httpUrlConn.connect();
            // 将返回的输入流转换成字符串  
            InputStream inputStream = httpUrlConn.getInputStream();
            InputStreamReader isr = new InputStreamReader(inputStream, "UTF-8");
            char[] buffer = new char[1];
            while (isr.read(buffer) != -1) {
                sb.append(buffer);
            }
            isr.close();
            // 释放资源  
            inputStream.close();
            inputStream = null;
            httpUrlConn.disconnect();
            String js = sb.toString();
            JSONObject dataJson = new JSONObject(js);
            JSONArray data = dataJson.getJSONArray("user");
            for (int i = 0; i < data.length(); i++) {
                JSONObject info = data.getJSONObject(i);
                Integer userId = info.getInt("user_id");
                SysMember member = this.memberService.querySysMemberById1(onlineUser.getDatabase(), userId);
                if (!StrUtil.isNull(member)) {
                    MapGjMd md = new MapGjMd();
                    md.setUserId(userId);
                    String memberUse = "";
                    md.setUserNm(member.getMemberNm());
                    md.setUserTel(member.getMemberMobile());
                    md.setUserHead(member.getMemberHead());
                    md.setMemberJob(member.getMemberJob());
                    memberUse = member.getMemberUse();
                    Double lng = info.getDouble("longitude");
                    Double lat = info.getDouble("latitude");//纬度
                    String s2 = "";
                    if (info.has("address")) {
                        s2 = info.getString("address");
                    }
                    md.setLocation("[" + lng + "," + lat + "]");
                    String times = StrUtil.stampToDate(info.getLong("location_time"));
                    md.setTimes(times);
                    SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                    Date d1 = format.parse(times);
                    Date d2 = format.parse(DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd HH:mm:ss"));
                    long diff = d2.getTime() - d1.getTime();
                    long Days = diff / (24 * 60 * 60 * 1000);
                    long Hours = diff / (60 * 60 * 1000) % 24;
                    long Minutes = diff / (60 * 1000) % 60 + (Hours * 60) + (Days * 24 * 60);
                    SysCheckIn checkIn = this.checkInService.queryCheckBydqdate(onlineUser.getDatabase(), userId);
                    SysCheckIn checkIn2 = this.checkInService.queryCheckBydqdate2(onlineUser.getDatabase(), userId);
                    if (memberUse.equals("2")) {
                        md.setZt("离职");
                        if (StrUtil.isNull(s2)) {
                            md.setAddress("暂无轨迹信息");
                        } else {
                            md.setAddress(s2);
                        }
                    } else {
                        //有考勤记录
                        if (!StrUtil.isNull(checkIn)) {
                            if (checkIn.getTp().equals("1-2")) {
                                md.setZt("下班");
                                if (StrUtil.isNull(s2)) {
                                    md.setAddress("暂无轨迹信息");
                                } else {
                                    md.setAddress(s2);
                                }
                            } else {
                                if (checkIn.getSbType() == null) checkIn.setSbType(0);
                                if (checkIn.getSbType().intValue() == 1) {
                                    md.setZt("上班");
                                    if (StrUtil.isNull(s2)) {
                                        md.setAddress("暂无轨迹信息");
                                    } else {
                                        md.setAddress(s2);
                                    }
                                    if(!this.kqDetailService.checkIsInClassTime(md.getUserId(),onlineUser.getDatabase()))
                                    {
                                        md.setZt("下班");
                                    }

                                } else {
                                    if (Minutes <= 30) {
                                        md.setZt("在线");
                                        if (StrUtil.isNull(s2)) {
                                            if (Minutes <= 5) {
                                                md.setAddress("正在定位中,请稍后..");
                                            } else {
                                                md.setAddress("暂无轨迹信息");
                                            }
                                        } else {
                                            md.setAddress(s2);
                                        }
                                    } else {
//                                        md.setZt("异常");
                                        md.setZt("上班");
                                        if (StrUtil.isNull(s2)) {
                                            md.setAddress("暂无轨迹信息");
                                        } else {
                                            md.setAddress(s2);
                                        }
                                        if(!this.kqDetailService.checkIsInClassTime(md.getUserId(),onlineUser.getDatabase()))
                                        {
                                            md.setZt("下班");
                                        }
                                    }
                                }
                            }
                        } else {
                            //没考勤记录
                            if (Minutes <= 30) {
                                md.setZt("在线");
                                if (StrUtil.isNull(s2)) {
                                    if (Minutes <= 5) {
                                        md.setAddress("正在定位中,请稍后..");
                                    } else {
                                        md.setAddress("暂无轨迹信息");
                                    }
                                } else {
                                    md.setAddress(s2);
                                }
                            } else {
//                                md.setZt("异常");
                                md.setZt("上班");
                                if (StrUtil.isNull(s2)) {
                                    md.setAddress("暂无轨迹信息");
                                } else {
                                    md.setAddress(s2);
                                }
                                if(!this.kqDetailService.checkIsInClassTime(md.getUserId(),onlineUser.getDatabase()))
                                {
                                    md.setZt("下班");
                                }
                            }
                            if (!StrUtil.isNull(checkIn2)) {
                                if (checkIn2.getTp().equals("1-2")) {
                                    md.setZt("下班");
                                    if (StrUtil.isNull(s2)) {
                                        md.setAddress("暂无轨迹信息");
                                    } else {
                                        md.setAddress(s2);
                                    }
                                } else {
                                    if (checkIn2.getSbType() == null) checkIn2.setSbType(0);
                                    if (checkIn2.getSbType().intValue() == 1) {
                                        md.setZt("上班");
                                        if (StrUtil.isNull(s2)) {
                                            md.setAddress("暂无轨迹信息");
                                        } else {
                                            md.setAddress(s2);
                                        }
                                        if(!this.kqDetailService.checkIsInClassTime(md.getUserId(),onlineUser.getDatabase()))
                                        {
                                            md.setZt("下班");
                                        }
                                    }
                                }
                            }
                        }
                        infoList.add(md);
                    }
                }
            }
            Page p = new Page();
            p.setRows(infoList);
            p.setTotal(dataJson.getInt("total"));
            p.setPageSize(pageSize);
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "获取所有成员最新轨迹列表成功");
            json.put("zt", zt);
            json.put("pageNo", pageNo);
            json.put("pageSize", pageSize);
            json.put("total", p.getTotal());
            json.put("totalPage", p.getTotalPage());
            json.put("rows", p.getRows());
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            this.sendWarm(response, "获取所有成员最新轨迹列表失败");
        }
    }


    @RequestMapping("checkWorkStatus")
    public void checkWorkStatus(HttpServletResponse response, String token, Integer userId) {
        StringBuffer sb = new StringBuffer();
        try {
            if (!checkParam(response, token))
                return;
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
//
            OnlineUser onlineUser = message.getOnlineMember();
            SysCorporation corporation = this.corporationService.queryCorporationBydata(onlineUser.getDatabase());
            MapGjMd md = new MapGjMd();
            md.setZt("下班");
            SysMember member = this.memberService.querySysMemberById1(onlineUser.getDatabase(), userId);
            if (!StrUtil.isNull(member)) {

                md.setUserId(userId);
                String memberUse = "";

                memberUse = member.getMemberUse();
                SysCheckIn checkIn = this.checkInService.queryCheckBydqdate(onlineUser.getDatabase(), userId);
                SysCheckIn checkIn2 = this.checkInService.queryCheckBydqdate2(onlineUser.getDatabase(), userId);
                if (memberUse.equals("2")) {
                    md.setZt("离职");

                } else {
                    //有考勤记录
                    if (!StrUtil.isNull(checkIn)) {
                        if (checkIn.getTp().equals("1-2")) {
                            md.setZt("下班");

                        } else {
                            if (checkIn.getSbType() == null) checkIn.setSbType(0);
                            if (checkIn.getSbType().intValue() == 1) {
                                md.setZt("上班");

                                if (!this.kqDetailService.checkIsInClassTime(md.getUserId(), onlineUser.getDatabase())) {
                                    md.setZt("下班");
                                }

                            } else {

//                                        md.setZt("异常");
                                md.setZt("上班");

                                if (!this.kqDetailService.checkIsInClassTime(md.getUserId(), onlineUser.getDatabase())) {
                                    md.setZt("下班");
                                }
                            }

                        }
                    } else {
                        md.setZt("下班");
                    }
                    if (!StrUtil.isNull(checkIn2)) {
                        if (checkIn2.getTp().equals("1-2")) {
                            md.setZt("下班");

                        } else {
                            if (checkIn2.getSbType() == null) checkIn2.setSbType(0);
                            if (checkIn2.getSbType().intValue() == 1) {
                                md.setZt("上班");

                                if (!this.kqDetailService.checkIsInClassTime(md.getUserId(), onlineUser.getDatabase())) {
                                    md.setZt("下班");
                                }
                            }
                        }
                    }
                }

            }

            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("workSts",md.getZt());
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            this.sendWarm(response, "获取所有成员最新轨迹列表失败");
        }
    }


    @RequestMapping("postLocation")
    public void postLocation(HttpServletResponse response, String token, Integer user_id,String location) {
        StringBuffer sb = new StringBuffer();
        try {
            if (!checkParam(response, token))
                return;
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
//
            OnlineUser onlineUser = message.getOnlineMember();
            SysCorporation corporation = this.corporationService.queryCorporationBydata(onlineUser.getDatabase());
            MapGjMd md = new MapGjMd();
            md.setZt("下班");
            Integer userId = user_id;
            SysMember member = this.memberService.querySysMemberById1(onlineUser.getDatabase(), userId);
            if (!StrUtil.isNull(member)) {

                md.setUserId(userId);
                String memberUse = "";

                memberUse = member.getMemberUse();
                SysCheckIn checkIn = this.checkInService.queryCheckBydqdate(onlineUser.getDatabase(), userId);
                SysCheckIn checkIn2 = this.checkInService.queryCheckBydqdate2(onlineUser.getDatabase(), userId);
                if (memberUse.equals("2")) {
                    md.setZt("离职");

                } else {
                    //有考勤记录
                    if (!StrUtil.isNull(checkIn)) {
                        if (checkIn.getTp().equals("1-2")) {
                            md.setZt("下班");

                        } else {
                            if (checkIn.getSbType() == null) checkIn.setSbType(0);
                            if (checkIn.getSbType().intValue() == 1) {
                                md.setZt("上班");

                                if (!this.kqDetailService.checkIsInClassTime(md.getUserId(), onlineUser.getDatabase())) {
                                    md.setZt("下班");
                                }

                            } else {

//                                        md.setZt("异常");
                                md.setZt("上班");

                                if (!this.kqDetailService.checkIsInClassTime(md.getUserId(), onlineUser.getDatabase())) {
                                    md.setZt("下班");
                                }
                            }

                        }
                    } else {
                        md.setZt("下班");
                    }
                    if (!StrUtil.isNull(checkIn2)) {
                        if (checkIn2.getTp().equals("1-2")) {
                            md.setZt("下班");

                        } else {
                            if (checkIn2.getSbType() == null) checkIn2.setSbType(0);
                            if (checkIn2.getSbType().intValue() == 1) {
                                md.setZt("上班");

                                if (!this.kqDetailService.checkIsInClassTime(md.getUserId(), onlineUser.getDatabase())) {
                                    md.setZt("下班");
                                }
                            }
                        }
                    }
                }

            }


            URL url = new URL(QiniuControl.GPS_SERVICE_URL + "/User/postLocation");//
            String param ="company_id=" + corporation.getDeptId() + "&user_id=" + user_id.toString() + "&location=" + location;

//			url = new URL("http://103.27.7.117/Company/getLastLocation?company_id="+corporation.getDeptId()+"&page="+pageNo+"&page_size="+pageSize+"&user_id="+entityNms+"");
            HttpURLConnection httpUrlConn = (HttpURLConnection) url.openConnection();
            httpUrlConn.setDoOutput(true);
            httpUrlConn.setDoInput(true);
            httpUrlConn.setUseCaches(false);
            httpUrlConn.setRequestMethod("POST");
            httpUrlConn.connect();
            PrintWriter out = new PrintWriter(new OutputStreamWriter(httpUrlConn.getOutputStream(), "utf-8"));;
            out.print(param);
            // flush输出流的缓冲
            out.flush();
            // 将返回的输入流转换成字符串
            InputStream inputStream = httpUrlConn.getInputStream();
            InputStreamReader isr = new InputStreamReader(inputStream, "UTF-8");
            char[] buffer = new char[1];
            while (isr.read(buffer) != -1) {
                sb.append(buffer);
            }
            isr.close();
            // 释放资源
            inputStream.close();
            inputStream = null;
            httpUrlConn.disconnect();
            String js = sb.toString();
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("workSts",md.getZt());
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            this.sendWarm(response, "获取所有成员最新轨迹列表失败");
        }
    }

    /**
     * 说明：分页查询所有成员最新轨迹（地图）
     *
     * @创建：作者:llp 创建时间：2016-3-3
     * @修改历史： [序号](llp 2016 - 3 - 3)<修改说明>
     */
    @RequestMapping("queryMapGjLsdt")
    public void queryMapGjLsdt(HttpServletResponse response, String token, String entityNms) {
        StringBuffer sb = new StringBuffer();
        List<MapGjMd> infoList = new ArrayList<MapGjMd>();
        try {
            if (!checkParam(response, token))
                return;
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            OnlineUser onlineUser = message.getOnlineMember();
            URL url = null;
            if (!StrUtil.isNull(entityNms)) {
                entityNms = entityNms + "," + String.valueOf(onlineUser.getMemId());
                url = new URL("http://api.map.baidu.com/trace/v2/entity/list?ak=gIzggYvrqG7zD5MCsFwSjKOkU8yv8SsC&service_id=117170&entity_names=" + entityNms + "");
            } else {
                entityNms = String.valueOf(onlineUser.getMemId());
                SysZcusr zcusr = this.zcusrService.querycusrIds(onlineUser.getDatabase(), onlineUser.getMemId());
                if (!StrUtil.isNull(zcusr)) {
                    if (!StrUtil.isNull(zcusr.getCusrIds())) {
                        entityNms = zcusr.getCusrIds() + "," + entityNms;
                    }
                }
                url = new URL("http://api.map.baidu.com/trace/v2/entity/list?ak=gIzggYvrqG7zD5MCsFwSjKOkU8yv8SsC&service_id=117170&entity_names=" + entityNms + "");
            }
            HttpURLConnection httpUrlConn = (HttpURLConnection) url.openConnection();
            httpUrlConn.setDoOutput(false);
            httpUrlConn.setDoInput(true);
            httpUrlConn.setUseCaches(false);
            httpUrlConn.setRequestMethod("GET");
            httpUrlConn.connect();
            // 将返回的输入流转换成字符串  
            InputStream inputStream = httpUrlConn.getInputStream();
            InputStreamReader isr = new InputStreamReader(inputStream, "UTF-8");
            char[] buffer = new char[1];
            while (isr.read(buffer) != -1) {
                sb.append(buffer);
            }
            isr.close();
            // 释放资源  
            inputStream.close();
            inputStream = null;
            httpUrlConn.disconnect();
            String js = sb.toString();
            JSONObject dataJson = new JSONObject(js);
            JSONArray data = dataJson.getJSONArray("entities");
            for (int i = 0; i < data.length(); i++) {
                JSONObject info = data.getJSONObject(i);
                MapGjMd md = new MapGjMd();
                Integer userId = Integer.parseInt(info.getString("entity_name"));
                String location = info.getJSONObject("realtime_point").get("location").toString();
                md.setUserId(userId);
                SysMember member = this.memberService.querySysMemberById(userId);
                String memberUse = "";
                if (!StrUtil.isNull(member)) {
                    md.setUserNm(member.getMemberNm());
                    md.setUserTel(member.getMemberMobile());
                    //md.setUserHead(member.getMemberHead());
                    memberUse = member.getMemberUse();
                }
                md.setLocation(location);
                String times = info.getString("modify_time");
                md.setTimes(times);
                SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                Date d1 = format.parse(times);
                Date d2 = format.parse(DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd HH:mm:ss"));
                long diff = d2.getTime() - d1.getTime();
                long Days = diff / (24 * 60 * 60 * 1000);
                long Hours = diff / (60 * 60 * 1000) % 24;
                long Minutes = diff / (60 * 1000) % 60 + (Hours * 60) + (Days * 24 * 60);
                SysCheckIn checkIn = this.checkInService.queryCheckBydqdate(onlineUser.getDatabase(), userId);
                SysCheckIn checkIn2 = this.checkInService.queryCheckBydqdate2(onlineUser.getDatabase(), userId);
                if (memberUse.equals("2")) {
                    md.setZt("离职");
                } else {
                    if (!StrUtil.isNull(checkIn)) {
                        if (checkIn.getTp().equals("1-2")) {
                            md.setZt("下班");
                        } else {
                            if (Minutes <= 30) {
                                md.setZt("在线");
                            } else {
                                md.setZt("异常");
                            }
                        }
                    } else {
                        if (Minutes <= 30) {
                            md.setZt("在线");
                        } else {
                            md.setZt("异常");
                        }
                        if (!StrUtil.isNull(checkIn2)) {
                            if (checkIn2.getTp().equals("1-2")) {
                                md.setZt("下班");
                            }
                        }
                    }
                    infoList.add(md);
                }
            }
            Page p = new Page();
            p.setRows(infoList);
            p.setTotal(dataJson.getInt("total"));
            p.setPageSize(100);
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "获取所有成员最新轨迹列表成功");
            json.put("pageNo", 1);
            json.put("pageSize", 100);
            json.put("total", p.getTotal());
            json.put("totalPage", p.getTotalPage());
            json.put("rows", p.getRows());
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            this.sendWarm(response, "获取所有成员最新轨迹列表失败");
        }
    }

    /**
     * 说明：分页查询所有成员最新轨迹（地图）长链接
     *
     * @创建：作者:llp 创建时间：2017-3-20
     * @修改历史： [序号](llp 2017 - 3 - 20)<修改说明>
     */
    @RequestMapping("queryMapGjLsdtClj")
    public void queryMapGjLsdtClj(HttpServletResponse response, String token, String entityNms, @RequestParam(defaultValue = "3") String dataTp, String mids) {
        StringBuffer sb = new StringBuffer();
        List<MapGjMd> infoList = new ArrayList<MapGjMd>();
        try {
            if (!checkParam(response, token))
                return;
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
//			if (StrUtil.isNull(dataTp)) {
//				sendWarm(response, CnlifeConstants.VIEW_MESSAGE);
//				return;
//			}
            OnlineUser onlineUser = message.getOnlineMember();
            SysCorporation corporation = this.corporationService.queryCorporationBydata(onlineUser.getDatabase());
            URL url = null;
//			if(!StrUtil.isNull(entityNms)){
//				entityNms=entityNms+","+String.valueOf(onlineUser.getMemId());
//				url = new URL("http://103.27.7.117/Company/getLastLocation?company_id="+corporation.getDeptId()+"&user_id="+entityNms+"");
//			}else{
//				entityNms=String.valueOf(onlineUser.getMemId());
//				SysZcusr zcusr=this.zcusrService.querycusrIds(onlineUser.getDatabase(),onlineUser.getMemId());
//				if(!StrUtil.isNull(zcusr)){
//					if(!StrUtil.isNull(zcusr.getCusrIds())){
//						entityNms=zcusr.getCusrIds()+","+entityNms;
//					}
//				}
//				url = new URL("http://103.27.7.117/Company/getLastLocation?company_id="+corporation.getDeptId()+"&user_id="+entityNms+"");
//			}
            if (!StrUtil.isNull(entityNms)) {//查询的用户不为空，根据条件查询
                entityNms = entityNms + "," + String.valueOf(onlineUser.getMemId());
            } else {//查询用户为空，则根据不同的角色数据展示
                entityNms = "";
                if ("2".equals(dataTp)) {//部门以及子部门数据
                    SysMember m = this.memberWebService.queryAllById(onlineUser.getMemId());
                    String str = this.memberWebService.queryMidStr(onlineUser.getDatabase(), m.getBranchId()).get("str").toString();
                    entityNms = str;
                } else if ("3".equals(dataTp)) {//个人数据
                    entityNms = String.valueOf(onlineUser.getMemId());
                }
                if (!StrUtil.isNull(mids)) {
                    entityNms = mids + "," + onlineUser.getMemId();
                }
            }
            if (StrUtil.isNull(entityNms)) {//dataTp=1的情况,查询公司所有用户
                url = new URL(QiniuControl.GPS_SERVICE_URL + "/Company/getLastLocation?company_id=" + corporation.getDeptId());
            } else {
                url = new URL(QiniuControl.GPS_SERVICE_URL + "/Company/getLastLocation?company_id=" + corporation.getDeptId() + "&user_id=" + entityNms + "");
            }
            HttpURLConnection httpUrlConn = (HttpURLConnection) url.openConnection();
            httpUrlConn.setDoOutput(false);
            httpUrlConn.setDoInput(true);
            httpUrlConn.setUseCaches(false);
            httpUrlConn.setRequestMethod("GET");
            httpUrlConn.connect();
            // 将返回的输入流转换成字符串  
            InputStream inputStream = httpUrlConn.getInputStream();
            InputStreamReader isr = new InputStreamReader(inputStream, "UTF-8");
            char[] buffer = new char[1];
            while (isr.read(buffer) != -1) {
                sb.append(buffer);
            }
            isr.close();
            // 释放资源  
            inputStream.close();
            inputStream = null;
            httpUrlConn.disconnect();
            String js = sb.toString();
            JSONObject dataJson = new JSONObject(js);
            JSONArray data = dataJson.getJSONArray("user");
            for (int i = 0; i < data.length(); i++) {
                JSONObject info = data.getJSONObject(i);
                MapGjMd md = new MapGjMd();
                Integer userId = info.getInt("user_id");
                Double lng = info.getDouble("longitude");
                Double lat = info.getDouble("latitude");//纬度
                md.setUserId(userId);
                SysMember member = this.memberService.querySysMemberById(userId);
                String memberUse = "";
                if (!StrUtil.isNull(member)) {
                    md.setUserNm(member.getMemberNm());
                    md.setUserTel(member.getMemberMobile());
                    //md.setUserHead(member.getMemberHead());
                    memberUse = member.getMemberUse();
                }
                md.setLocation("[" + lng + "," + lat + "]");
                String times = StrUtil.stampToDate(info.getLong("location_time"));
                md.setTimes(times);
                if (info.has("address")) {
                    md.setAddress(info.getString("address"));
                } else {
                    md.setAddress("");
                }
                if (info.has("location_from")) {
                    md.setLocationFrom(info.getString("location_from"));
                } else {
                    md.setLocationFrom("");
                }
                if (info.has("os")) {
                    md.setOs(info.getString("os"));
                } else {
                    md.setOs("");
                }
                if (info.has("heartbeat_span")) {
                    md.setHeartbeatSpan(String.valueOf(info.getInt("heartbeat_span")));
                } else {
                    md.setHeartbeatSpan("");
                }
                if (info.has("speed")) {
                    md.setSpeed(String.valueOf(info.getDouble("speed")));
                } else {
                    md.setSpeed("");
                }
                if (info.has("stay_ime")) {
                    md.setStayTime(String.valueOf(info.getLong("stay_time")));
                } else {
                    md.setStayTime("");
                }
                if (info.has("azimuth")) {
                    md.setAzimuth(String.valueOf(info.getDouble("azimuth")));
                } else {
                    md.setAzimuth("");
                }
                if (info.has("work_status")) {
                    md.setWorkStatus(String.valueOf(info.getInt("work_status")));
                } else {
                    md.setWorkStatus("");
                }
                if (info.has("working_distance")) {
                    md.setWorkingDistance(String.valueOf(info.getInt("working_distance")));
                } else {
                    md.setWorkingDistance("");
                }
                if (info.has("check_in_time")) {
                    md.setCheckInTime(String.valueOf(info.getLong("check_in_time")));
                } else {
                    md.setCheckInTime("");
                }
                if (info.has("visit_check_in_time")) {
                    md.setVisitCheckInTime(String.valueOf(info.getLong("visit_check_in_time")));
                } else {
                    md.setVisitCheckInTime("");
                }
                SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                Date d1 = format.parse(times);
                Date d2 = format.parse(DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd HH:mm:ss"));
                long diff = d2.getTime() - d1.getTime();
                long Days = diff / (24 * 60 * 60 * 1000);
                long Hours = diff / (60 * 60 * 1000) % 24;
                long Minutes = diff / (60 * 1000) % 60 + (Hours * 60) + (Days * 24 * 60);
                SysCheckIn checkIn = this.checkInService.queryCheckBydqdate(onlineUser.getDatabase(), userId);
                SysCheckIn checkIn2 = this.checkInService.queryCheckBydqdate2(onlineUser.getDatabase(), userId);
                if (memberUse.equals("2")) {
                    md.setZt("离职");
                } else {
                    if (!StrUtil.isNull(checkIn)) {
                        if (checkIn.getTp().equals("1-2")) {
                            md.setZt("下班");
                        } else {
                            if (Minutes <= 30) {
                                md.setZt("在线");
                            } else {
                                md.setZt("异常");
                            }
                        }
                    } else {
                        if (Minutes <= 30) {
                            md.setZt("在线");
                        } else {
                            md.setZt("异常");
                        }
                        if (!StrUtil.isNull(checkIn2)) {
                            if (checkIn2.getTp().equals("1-2")) {
                                md.setZt("下班");
                            }
                        }
                    }
                    infoList.add(md);
                }
            }
            Page p = new Page();
            p.setRows(infoList);
            p.setTotal(dataJson.getInt("total"));
            p.setPageSize(100);
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "获取所有成员最新轨迹列表成功");
            json.put("pageNo", 1);
            json.put("pageSize", 100);
            json.put("total", p.getTotal());
            json.put("totalPage", p.getTotalPage());
            json.put("rows", p.getRows());
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            this.sendWarm(response, "获取所有成员最新轨迹列表失败");
        }
    }

    /**
     * 说明：获取个人轨迹列表
     *
     * @创建：作者:llp 创建时间：2016-5-19
     * @修改历史： [序号](llp 2016 - 5 - 19)<修改说明>
     */
    @RequestMapping("queryMapGjOneWeb")
    public void queryMapGjOneWeb(HttpServletResponse response, String token, Integer pageNo, Integer pageSize, Integer mid, String cxtime) {
        List<SysGjOneMd> list = new ArrayList<SysGjOneMd>();
        try {
            if (!checkParam(response, token, mid))
                return;
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            if (pageSize == null) {
                pageSize = 20;
            }
            if (StrUtil.isNull(cxtime)) {
                cxtime = DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd");
            }
            String stime = Long.toString(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").parse(cxtime + " 00:00:00").getTime()).substring(0, 10);
            String etime = Long.toString(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").parse(cxtime + " 23:59:59").getTime()).substring(0, 10);
            StringBuffer sb = new StringBuffer();
            URL url = new URL("http://api.map.baidu.com/trace/v2/track/gethistory?ak=gIzggYvrqG7zD5MCsFwSjKOkU8yv8SsC&service_id=117170&page_index=" + pageNo + "&page_size=" + pageSize + "&is_processed=1&start_time=" + stime + "&end_time=" + etime + "&entity_name=" + mid);
            HttpURLConnection httpUrlConn = (HttpURLConnection) url.openConnection();
            httpUrlConn.setDoOutput(false);
            httpUrlConn.setDoInput(true);
            httpUrlConn.setUseCaches(false);
            httpUrlConn.setRequestMethod("GET");
            httpUrlConn.connect();
            // 将返回的输入流转换成字符串  
            InputStream inputStream = httpUrlConn.getInputStream();
            InputStreamReader isr = new InputStreamReader(inputStream, "UTF-8");
            char[] buffer = new char[1];
            while (isr.read(buffer) != -1) {
                sb.append(buffer);
            }
            isr.close();
            // 释放资源  
            inputStream.close();
            inputStream = null;
            httpUrlConn.disconnect();
            String js = sb.toString();
            JSONObject dataJson = new JSONObject(js);
            if (!dataJson.isNull("points")) {
                JSONArray data = dataJson.getJSONArray("points");
                for (int i = 0; i < data.length(); i++) {
                    SysGjOneMd gjOneMd = new SysGjOneMd();
                    JSONObject info = data.getJSONObject(i);
                    String location = info.getJSONArray("location").toString();
                    gjOneMd.setCreateTime(StrUtil.stampToDate(info.getLong("loc_time")));
                    //转换地址
                    StringBuffer sb2 = new StringBuffer();
                    String lng = location.substring(1, location.indexOf(","));//
                    String lat = location.substring(location.indexOf(",") + 1, location.length() - 1);//纬度
                    URL url2 = new URL("http://api.map.baidu.com/geocoder/v2/?ak=gIzggYvrqG7zD5MCsFwSjKOkU8yv8SsC&location=" + lat + "," + lng + "&output=json&pois=1");
                    HttpURLConnection httpUrlConn2 = (HttpURLConnection) url2.openConnection();
                    httpUrlConn2.setDoOutput(false);
                    httpUrlConn2.setDoInput(true);
                    httpUrlConn2.setUseCaches(false);
                    httpUrlConn2.setRequestMethod("GET");
                    httpUrlConn2.connect();
                    // 将返回的输入流转换成字符串
                    InputStream inputStream2 = httpUrlConn2.getInputStream();
                    InputStreamReader isr2 = new InputStreamReader(inputStream2, "UTF-8");
                    char[] buffer2 = new char[1];
                    while (isr2.read(buffer2) != -1) {
                        sb2.append(buffer2);
                    }
                    isr2.close();
                    // 释放资源
                    inputStream2.close();
                    inputStream2 = null;
                    httpUrlConn2.disconnect();
                    String js2 = sb2.toString();
                    JSONObject dataJson2 = new JSONObject(js2);
                    String s2 = dataJson2.getJSONObject("result").getString("formatted_address");
                    if (StrUtil.isNull(s2)) {
                        gjOneMd.setAddress("暂无轨迹信息");
                    } else {
                        gjOneMd.setAddress(s2);
                    }
                    list.add(gjOneMd);
                }
            }
            Page p = new Page();
            p.setRows(list);
            p.setTotal(dataJson.getInt("total"));
            p.setPageSize(pageSize);
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "获取个人轨迹列表成功");
            json.put("pageNo", pageNo);
            json.put("pageSize", pageSize);
            json.put("total", p.getTotal());
            json.put("totalPage", p.getTotalPage());
            json.put("rows", p.getRows());
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            this.sendWarm(response, "获取个人轨迹列表失败");
        }
    }

    /**
     * 说明：分页查询相关成员最新轨迹
     *
     * @创建：作者:llp 创建时间：2016-5-27
     * @修改历史： [序号](llp 2016 - 5 - 27)<修改说明>
     */
    @RequestMapping("queryMapGjLsEntityNms")
    public void queryMapGjLsEntityNms(HttpServletResponse response, String token, String entityNms) {
        StringBuffer sb = new StringBuffer();
        List<MapGjMd> infoList = new ArrayList<MapGjMd>();
        try {
            if (!checkParam(response, token))
                return;
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            OnlineUser onlineUser = message.getOnlineMember();
            URL url = new URL("http://api.map.baidu.com/trace/v2/entity/list?ak=gIzggYvrqG7zD5MCsFwSjKOkU8yv8SsC&service_id=117170&entity_names=" + entityNms + "");
            HttpURLConnection httpUrlConn = (HttpURLConnection) url.openConnection();
            httpUrlConn.setDoOutput(false);
            httpUrlConn.setDoInput(true);
            httpUrlConn.setUseCaches(false);
            httpUrlConn.setRequestMethod("GET");
            httpUrlConn.connect();
            // 将返回的输入流转换成字符串  
            InputStream inputStream = httpUrlConn.getInputStream();
            InputStreamReader isr = new InputStreamReader(inputStream, "UTF-8");
            char[] buffer = new char[1];
            while (isr.read(buffer) != -1) {
                sb.append(buffer);
            }
            isr.close();
            // 释放资源  
            inputStream.close();
            inputStream = null;
            httpUrlConn.disconnect();
            String js = sb.toString();
            JSONObject dataJson = new JSONObject(js);
            JSONArray data = dataJson.getJSONArray("entities");
            for (int i = 0; i < data.length(); i++) {
                JSONObject info = data.getJSONObject(i);
                MapGjMd md = new MapGjMd();
                Integer userId = Integer.parseInt(info.getString("entity_name"));
                String location = info.getJSONObject("realtime_point").get("location").toString();
                md.setUserId(userId);
                SysMember member = this.memberService.querySysMemberById(userId);
                String memberUse = "";
                if (!StrUtil.isNull(member)) {
                    md.setUserNm(member.getMemberNm());
                    md.setUserTel(member.getMemberMobile());
                    //md.setUserHead(member.getMemberHead());
                    memberUse = member.getMemberUse();
                }
                md.setLocation(location);
                String times = info.getString("modify_time");
                md.setTimes(times);
                SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                Date d1 = format.parse(times);
                Date d2 = format.parse(DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd HH:mm:ss"));
                long diff = d2.getTime() - d1.getTime();
                long Days = diff / (24 * 60 * 60 * 1000);
                long Hours = diff / (60 * 60 * 1000) % 24;
                long Minutes = diff / (60 * 1000) % 60 + (Hours * 60) + (Days * 24 * 60);
                SysCheckIn checkIn = this.checkInService.queryCheckBydqdate(onlineUser.getDatabase(), userId);
                SysCheckIn checkIn2 = this.checkInService.queryCheckBydqdate2(onlineUser.getDatabase(), userId);
                if (memberUse.equals("2")) {
                    md.setZt("离职");
                } else {
                    if (!StrUtil.isNull(checkIn)) {
                        if (checkIn.getTp().equals("1-2")) {
                            md.setZt("下班");
                        } else {
                            if (Minutes <= 30) {
                                md.setZt("在线");
                            } else {
                                md.setZt("异常");
                            }
                        }
                    } else {
                        if (Minutes <= 30) {
                            md.setZt("在线");
                        } else {
                            md.setZt("异常");
                        }
                        if (!StrUtil.isNull(checkIn2)) {
                            if (checkIn2.getTp().equals("1-2")) {
                                md.setZt("下班");
                            }
                        }
                    }
                    infoList.add(md);
                }
            }
            Page p = new Page();
            p.setRows(infoList);
            p.setTotal(dataJson.getInt("total"));
            p.setPageSize(100);
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "获取相关成员最新轨迹列表成功");
            json.put("pageNo", 1);
            json.put("pageSize", 100);
            json.put("total", p.getTotal());
            json.put("totalPage", p.getTotalPage());
            json.put("rows", p.getRows());
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            this.sendWarm(response, "获取相关成员最新轨迹列表失败");
        }
    }

}
