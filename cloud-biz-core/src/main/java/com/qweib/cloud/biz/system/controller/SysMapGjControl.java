package com.qweib.cloud.biz.system.controller;

import com.qweib.cloud.biz.system.QiniuControl;
import com.qweib.cloud.biz.system.service.SysZcusrService;
import com.qweib.cloud.biz.system.service.plat.SysMemberService;
import com.qweib.cloud.biz.system.service.ws.SysCheckInService;
import com.qweib.cloud.core.domain.*;

import com.qweib.cloud.biz.common.GeneralControl;
import com.qweib.cloud.repository.utils.HttpUrlUtils;
import com.qweib.cloud.utils.DateTimeUtil;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Controller
@RequestMapping("/manager")
public class SysMapGjControl extends GeneralControl {
    @Resource
    private SysMemberService memberService;
    @Resource
    private SysCheckInService checkInService;
    @Resource
    private SysZcusrService zcusrService;

    /**
     * 摘要：
     *
     * @说明：到实时查岗页面
     * @创建：作者:llp 创建时间：2016-4-7
     * @修改历史： [序号](llp 2016 - 4 - 7)<修改说明>
     */
    @RequestMapping("/queryMapGj")
    public String queryMapGj(String dataTp, Model model) {
        model.addAttribute("dataTp", dataTp);
        return "/uglcw/mapgj/mapgj";
    }

    /**
     * 说明：分页查询所有成员最新轨迹
     *
     * @创建：作者:llp 创建时间：2016-3-3
     * @修改历史： [序号](llp 2016 - 3 - 3)<修改说明>
     */
    @RequestMapping("/queryMapGjPage")
    public void queryMapGjPage(HttpServletResponse response, HttpServletRequest request, int page, int rows, String dataTp) {
        StringBuffer sb = new StringBuffer();
        List<MapGjMd> infoList = new ArrayList<MapGjMd>();
        try {
            SysLoginInfo loginInfo = this.getLoginInfo(request);
            SysZcusr zcusr = this.zcusrService.querycusrIdsz(loginInfo, dataTp);//获取人员数组(根据条件查询)
            SysMember member1 = this.memberService.querySysMemberById(loginInfo.getIdKey());

            String CusrIds = zcusr.getCusrIds();
//				if(member1.getIsUnitmng().equals("3")){
//					CusrIds=this.memberService.queryBmMemberIds(member1.getBranchId(), loginInfo.getDatasource()).getMemberIds();
//				}
            URL url = new URL(QiniuControl.GPS_SERVICE_URL + "/Company/getLastLocation?company_id=" + member1.getUnitId() + "&page=" + page + "&page_size=" + rows + "&user_id=" + CusrIds + "");
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
                    md.setUserHead(member.getMemberHead());
                    memberUse = member.getMemberUse();
                }
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
                SysCheckIn checkIn = this.checkInService.queryCheckBydqdate(loginInfo.getDatasource(), userId);
                SysCheckIn checkIn2 = this.checkInService.queryCheckBydqdate2(loginInfo.getDatasource(), userId);
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
                                md.setZt("下线");
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
                            md.setZt("下线");
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
                }
                infoList.add(md);
            }
            Page p = new Page();
            p.setRows(infoList);
            p.setTotal(dataJson.getInt("total"));
            p.setPageSize(rows);
            JSONObject json = new JSONObject();
            json.put("total", p.getTotal());
            json.put("rows", p.getRows());
            this.sendJsonResponse(response, json.toString());
            p = null;

        } catch (Exception e) {
            log.error("分页实时查岗出错：", e);
        }
    }

    /**
     * 摘要：
     *
     * @说明：获取某个业务员轨迹地图
     * @创建：作者:llp 创建时间：2016-4-8
     * @修改历史： [序号](llp 2016 - 4 - 8)<修改说明>
     */
    @RequestMapping("/queryMapGjOne")
    public String queryMapGjOne(HttpServletRequest request, Model model, String cxtime, Integer mid) {
        try {
            if (StrUtil.isNull(cxtime)) {
                cxtime = DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd");
            }
            SysLoginInfo loginInfo = this.getLoginInfo(request);
            SysMember member1 = this.memberService.querySysMemberById(loginInfo.getIdKey());

            String url = QiniuControl.GPS_SERVICE_URL + "/User/getDailyLocation?company_id=" + member1.getUnitId() + "&user_id=" + mid + "&date=" + cxtime + "&field=longitude,latitude";
            String result = HttpUrlUtils.convertResponse(url);

            StringBuilder markerArr = new StringBuilder("[");
            JSONObject dataJson = new JSONObject(result);
            JSONArray data = dataJson.getJSONArray("location");
            for (int i = 0; i < data.length(); i++) {
                JSONObject info = data.getJSONObject(i);
                Double lng = info.getDouble("longitude");
                Double lat = info.getDouble("latitude");//纬度
                String jwd = lng + "&" + lat;
                if (i == data.length() - 1) {
                    markerArr.append("[point: " + jwd + "]");
                } else {
                    markerArr.append("[point: " + jwd + "],");
                }
            }
            markerArr.append("]");
            model.addAttribute("markerArr", markerArr.toString().replace("[point: 0&0],", "").replace(",[point: 0&0]", ""));

            model.addAttribute("cxtime", cxtime);
            model.addAttribute("mid", mid);
        } catch (Exception e) {
            log.error("获取某个业务员轨迹地图出错：", e);
        }
        return "/uglcw/mapgj/mapgjone";
    }

    /**
     * 摘要：
     *
     * @说明：业务员地图
     * @创建：作者:llp 创建时间：2016-4-5
     * @修改历史： [序号](llp 2016 - 4 - 5)<修改说明>
     */
    @RequestMapping("/querymmap")
    public String querymmap(HttpServletRequest request, Model model, String zhi, String dataTp) {
        Integer id = null;
        String longitude = "";
        String latitude = "";
        if (!StrUtil.isNull(zhi)) {
            id = Integer.parseInt(zhi.substring(0, zhi.indexOf(":")));
            longitude = zhi.substring(zhi.indexOf("[") + 1, zhi.indexOf(","));
            latitude = zhi.substring(zhi.indexOf(",") + 1, zhi.length() - 1);
        }
        SysLoginInfo infos = getInfo(request);
        StringBuffer sb = new StringBuffer();
        List<MapGjMd> infoList = new ArrayList<MapGjMd>();
        SysZcusr zcusr = this.zcusrService.querycusrIdsz(infos, dataTp);
        SysMember member1 = this.memberService.querySysMemberById(infos.getIdKey());
        String CusrIds = zcusr.getCusrIds();
        try {

            URL url = new URL(QiniuControl.GPS_SERVICE_URL + "/Company/getLastLocation?company_id=" + member1.getUnitId() + "&user_id=" + CusrIds + "");
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

                md.setUserId(userId);
                SysMember member = this.memberService.querySysMemberById(userId);
                md.setUserNm(member.getMemberNm());
                md.setUserTel(member.getMemberMobile());
                md.setUserHead(member.getMemberHead());
                Double lng = info.getDouble("longitude");
                Double lat = info.getDouble("latitude");//纬度
                String s2 = "";
                if (info.has("address")) {
                    s2 = info.getString("address");
                }
                md.setLocation("[" + lng + "," + lat + "]");
                String times = StrUtil.stampToDate(info.getLong("location_time"));
                md.setTimes(times);
                md.setAddress(s2);
                SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                Date d1 = format.parse(times);
                Date d2 = format.parse(DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd HH:mm:ss"));
                long diff = d2.getTime() - d1.getTime();
                long Days = diff / (24 * 60 * 60 * 1000);
                long Hours = diff / (60 * 60 * 1000) % 24;
                long Minutes = diff / (60 * 1000) % 60 + (Hours * 60) + (Days * 24 * 60);
                SysCheckIn checkIn = this.checkInService.queryCheckBydqdate(infos.getDatasource(), userId);
                SysCheckIn checkIn2 = this.checkInService.queryCheckBydqdate2(infos.getDatasource(), userId);
                if (!StrUtil.isNull(checkIn)) {
                    if (checkIn.getTp().equals("1-2")) {
                        md.setZt("下班");
                        md.setYs("red");
                    } else {
                        if (Minutes <= 30) {
                            md.setZt("在线");
                            md.setYs("green");
                        } else {
                            md.setZt("下线");
                            md.setYs("gray");
                        }
                    }
                } else {
                    if (Minutes <= 30) {
                        md.setZt("在线");
                        md.setYs("green");
                    } else {
                        md.setZt("下线");
                        md.setYs("gray");
                    }
                    if (!StrUtil.isNull(checkIn2)) {
                        if (checkIn2.getTp().equals("1-2")) {
                            md.setZt("下班");
                            md.setYs("red");
                        }
                    }
                }
                infoList.add(md);
            }
            isr.close();

        } catch (Exception e) {
            log.error("获取业务员地图信息出错：", e);
        }
        StringBuilder markerArr = new StringBuilder("[");
        for (int i = 0; i < infoList.size(); i++) {
            String s = infoList.get(i).getLocation();
            String jwd = s.substring(1, s.indexOf(",") - 1) + "&" + s.substring(s.indexOf(",") + 1, s.length() - 1);
            if (i == infoList.size() - 1) {
                markerArr.append("[ usrNm: " + infoList.get(i).getUserNm() + ", point: " + jwd + ", address: " + infoList.get(i).getAddress() + ", tel: " + infoList.get(i).getUserTel() + ", times: " + infoList.get(i).getTimes() + ", zt: " + infoList.get(i).getZt() + ", ys: " + infoList.get(i).getYs() + "]");
            } else {
                markerArr.append("[ usrNm: " + infoList.get(i).getUserNm() + ", point: " + jwd + ", address: " + infoList.get(i).getAddress() + ", tel: " + infoList.get(i).getUserTel() + ", times: " + infoList.get(i).getTimes() + ", zt: " + infoList.get(i).getZt() + ", ys: " + infoList.get(i).getYs() + "],");
            }
        }
        markerArr.append("]");
        model.addAttribute("markerArr", markerArr.toString());
        model.addAttribute("infoList", infoList);
        model.addAttribute("id", id);
        model.addAttribute("longitude", longitude);
        model.addAttribute("latitude", latitude);
        return "/uglcw/mapgj/membermap";
    }

    public static void main(String[] args) {
        String s = "3:[118.12504642737,24.480696019908]";
        System.out.println(s.substring(0, s.indexOf(":")));
        System.out.println(s.substring(s.indexOf("[") + 1, s.indexOf(",")));
        System.out.println(s.substring(s.indexOf(",") + 1, s.length() - 1));
    }
}
