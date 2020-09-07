package com.qweib.cloud.biz.system.controller.mobile;


import com.qweib.cloud.biz.system.BaseWebService;
import com.qweib.cloud.biz.system.TokenServer;
import com.qweib.cloud.biz.system.service.plat.SysMemberService;
import com.qweib.cloud.biz.system.service.ws.BscCheckRuleWebService;
import com.qweib.cloud.core.domain.BscCheckRule;
import com.qweib.cloud.core.domain.OnlineMessage;
import com.qweib.cloud.core.domain.OnlineUser;
import com.qweib.cloud.core.domain.SysMember;
import com.qweib.cloud.utils.DateTimeUtil;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;
import java.util.Date;
import java.util.List;

@Controller
@RequestMapping("/web")
public class BscCheckRuleWebControl extends BaseWebService {
    @Resource
    private BscCheckRuleWebService bheckRuleWebService;
    @Resource
    private SysMemberService memberService;

    /**
     * 说明：分页查询考勤规则
     *
     * @创建：作者:llp 创建时间：2017-2-22
     * @修改历史： [序号](llp 2017 - 2 - 22)<修改说明>
     */
    @RequestMapping("queryCheckRuleWeb")
    public void queryCheckRuleWeb(HttpServletResponse response, String token, Integer pageNo, Integer pageSize) {
        try {
            if (!checkParam(response, token, pageNo))
                return;
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            if (pageSize == null) {
                pageSize = 10;
            }
            OnlineUser onlineUser = message.getOnlineMember();
            Page p = this.bheckRuleWebService.queryCheckRuleWeb(onlineUser.getDatabase(), onlineUser.getMemId(), pageNo, pageSize);
            List<BscCheckRule> vlist = (List<BscCheckRule>) p.getRows();
            for (BscCheckRule checkRule : vlist) {
                if (StrUtil.isNull(checkRule.getSyMids1())) {
                    checkRule.setMnum1(0);
                } else {
                    checkRule.setMnum1(checkRule.getSyMids1().split(",").length);
                }
                if (checkRule.getMemberId().equals(onlineUser.getMemId())) {
                    checkRule.setIsMy(1);
                } else {
                    checkRule.setIsMy(2);
                }
            }
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "获取考勤规则列表成功");
            json.put("pageNo", pageNo);
            json.put("pageSize", pageSize);
            json.put("total", p.getTotal());
            json.put("totalPage", p.getTotalPage());
            json.put("rows", p.getRows());
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            this.sendWarm(response, "获取考勤规则列表失败");
        }
    }

    /**
     * 说明：添加考勤规则
     *
     * @创建：作者:llp 创建时间：2017-2-22
     * @修改历史： [序号](llp 2017 - 2 - 22)<修改说明>
     */
    @RequestMapping("addCheckRuleWeb")
    public void addCheckRuleWeb(HttpServletResponse response, String token, String kqgjNm, String tp, String checkWeeks, String checkTimes, String address
            , String longitude, String latitude, Integer yxMeter, Integer zzsbTime, Integer zwxbTime, Integer sxbtxTime, Integer isQd) {
        try {
            if (!checkParam(response, token))
                return;
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            OnlineUser onlineUser = message.getOnlineMember();
            BscCheckRule checkRule = new BscCheckRule();
            checkRule.setMemberId(onlineUser.getMemId());
            checkRule.setKqgjNm(kqgjNm);
            checkRule.setTp(tp);
            checkRule.setCheckWeeks(checkWeeks);
            checkRule.setCheckTimes(checkTimes);
            checkRule.setAddress(address);
            checkRule.setLongitude(longitude);
            checkRule.setLatitude(latitude);
            checkRule.setYxMeter(yxMeter);
            checkRule.setZzsbTime(zzsbTime);
            checkRule.setZwxbTime(zwxbTime);
            checkRule.setSxbtxTime(sxbtxTime);
            checkRule.setIsQd(isQd);
            checkRule.setFbTime(DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd HH:mm:ss"));
            int id = this.bheckRuleWebService.addCheckRuleWeb(checkRule, onlineUser.getDatabase());
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "添加考勤规则成功");
            json.put("id", id);
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            System.out.println(e);
            this.sendWarm(response, "添加考勤规则失败");
        }
    }

    /**
     * 说明：获取考勤规则
     *
     * @创建：作者:llp 创建时间：2017-2-22
     * @修改历史： [序号](llp 2017 - 2 - 22)<修改说明>
     */
    @RequestMapping("queryCheckRuleWebOne")
    public void queryCheckRuleWebOne(HttpServletResponse response, String token, Integer id) {
        try {
            if (!checkParam(response, token, id))
                return;
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            OnlineUser onlineUser = message.getOnlineMember();
            BscCheckRule checkRule = this.bheckRuleWebService.queryCheckRuleWebOne(onlineUser.getDatabase(), id);
            List<SysMember> lsit1 = null;
            List<SysMember> lsit2 = null;
            //List<SysMember> lsit3=null;
            if (!StrUtil.isNull(checkRule.getSyMids1())) {
                lsit1 = this.bheckRuleWebService.queryMemberByMids(onlineUser.getDatabase(), checkRule.getSyMids1());
            }
            if (!StrUtil.isNull(checkRule.getGlMids1())) {
                lsit2 = this.bheckRuleWebService.queryMemberByMids(onlineUser.getDatabase(), checkRule.getGlMids1());
            }
//            if(!StrUtil.isNull(checkRule.getCkMids1())){
//            	lsit3=this.bheckRuleWebService.queryMemberByMids(onlineUser.getDatabase(), checkRule.getCkMids1());
//			}
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "获取考勤规则成功");
            json.put("id", checkRule.getId());
            json.put("kqgjNm", checkRule.getKqgjNm());
            json.put("tp", checkRule.getTp());
            json.put("checkWeeks", checkRule.getCheckWeeks());
            json.put("checkTimes", checkRule.getCheckTimes());
            json.put("address", checkRule.getAddress());
            json.put("longitude", checkRule.getLongitude());
            json.put("latitude", checkRule.getLatitude());
            json.put("yxMeter", checkRule.getYxMeter());
            json.put("isQd", checkRule.getIsQd());
            json.put("zzsbTime", checkRule.getZzsbTime());
            json.put("zwxbTime", checkRule.getZwxbTime());
            json.put("sxbtxTime", checkRule.getSxbtxTime());
            json.put("lsit1", lsit1);
            json.put("lsit2", lsit2);
            //json.put("lsit3", lsit3);
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            this.sendWarm(response, "获取考勤规则失败");
        }
    }

    /**
     * 说明：修改考勤规则人员权限
     *
     * @创建：作者:llp 创建时间：2017-2-22
     * @修改历史： [序号](llp 2017 - 2 - 22)<修改说明>
     */
    @RequestMapping("updateCheckRuleWebRy")
    public void updateCheckRuleWebRy(HttpServletResponse response, String token, Integer id, String syMids1, String glMids1) {
        try {
            if (!checkParam(response, token, id))
                return;
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            OnlineUser onlineUser = message.getOnlineMember();
            String[] ss = syMids1.split(",");
            for (int i = 0; i < ss.length; i++) {
                int mid = Integer.parseInt(ss[i]);
                BscCheckRule checkRule = this.bheckRuleWebService.queryCheckRuleWebBysyMid(onlineUser.getDatabase(), mid);
                if (!StrUtil.isNull(checkRule)) {
                    if (!id.equals(checkRule.getId())) {
                        String memberNm = this.memberService.querySysMemberById1(onlineUser.getDatabase(), mid).getMemberNm();
                        sendWarm(response, memberNm + ":该用户已经有考勤规则了");
                        return;
                    }
                }
            }
            this.bheckRuleWebService.updateCheckRuleWebRy(onlineUser.getDatabase(), id, syMids1, "-" + syMids1.replace(",", "-") + "-", glMids1, "-" + glMids1.replace(",", "-") + "-");
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "修改考勤规则人员权限成功");
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            System.out.println(e);
            this.sendWarm(response, "修改考勤规则人员权限失败");
        }
    }

    /**
     * 说明：修改考勤规则详情
     *
     * @创建：作者:llp 创建时间：2017-2-22
     * @修改历史： [序号](llp 2017 - 2 - 22)<修改说明>
     */
    @RequestMapping("updateCheckRuleWebXq")
    public void updateCheckRuleWebXq(HttpServletResponse response, String token, Integer id, String kqgjNm, String checkWeeks, String checkTimes, String address, String longitude, String latitude,
                                     Integer yxMeter, Integer zzsbTime, Integer zwxbTime, Integer sxbtxTime, Integer isQd) {
        try {
            if (!checkParam(response, token, id))
                return;
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            OnlineUser onlineUser = message.getOnlineMember();
            this.bheckRuleWebService.updateCheckRuleWebXq(onlineUser.getDatabase(), id, kqgjNm, checkWeeks, checkTimes, address, longitude, latitude, yxMeter, zzsbTime, zwxbTime, sxbtxTime, isQd);
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "修改考勤规则详情成功");
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            this.sendWarm(response, "修改考勤规则详情失败");
        }
    }

    /**
     * 说明：删除考勤规则
     *
     * @创建：作者:llp 创建时间：2017-2-22
     * @修改历史： [序号](llp 2017 - 2 - 22)<修改说明>
     */
    @RequestMapping("deleteCheckRuleWeb")
    public void deleteCheckRuleWeb(HttpServletResponse response, String token, Integer id) {
        try {
            if (!checkParam(response, token, id))
                return;
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            this.bheckRuleWebService.deleteCheckRuleWeb(message.getOnlineMember().getDatabase(), id);
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "删除考勤规则成功");
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            this.sendWarm(response, "删除考勤规则失败");
        }
    }

    /**
     * 说明：获取我的考勤规则说明
     *
     * @创建：作者:llp 创建时间：2017-2-22
     * @修改历史： [序号](llp 2017 - 2 - 22)<修改说明>
     */
    @RequestMapping("queryCheckRuleWebMy")
    public void queryCheckRuleWebMy(HttpServletResponse response, String token) {
        try {
            if (!checkParam(response, token))
                return;
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            OnlineUser onlineUser = message.getOnlineMember();
            BscCheckRule checkRule = this.bheckRuleWebService.queryCheckRuleWebBysyMid(onlineUser.getDatabase(), onlineUser.getMemId());
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "获取我的考勤规则说明成功");
            json.put("kqgjNm", checkRule.getKqgjNm());
            json.put("checkWeeks", checkRule.getCheckWeeks());
            json.put("checkTimes", checkRule.getCheckTimes());
            json.put("address", checkRule.getAddress());
            json.put("zzsbTime", checkRule.getZzsbTime());
            json.put("zwxbTime", checkRule.getZwxbTime());
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            this.sendWarm(response, "获取我的考勤规则说明失败");
        }
    }

    /**
     * 说明：考勤(团队)
     *
     * @创建：作者:llp 创建时间：2017-3-2
     * @修改历史： [序号](llp 2017 - 3 - 2)<修改说明>
     */
    @RequestMapping("queryCheckTd")
    public void queryCheckTd(HttpServletResponse response, String token, String sdate, String edate) {
        try {
            if (!checkParam(response, token, sdate, edate))
                return;
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            OnlineUser onlineUser = message.getOnlineMember();
            int num1 = 0;
            int num2 = 0;
            int num3 = 0;
            int num4 = 0;
            int num5 = 0;
            int num6 = 0;
            BscCheckRule checkRule = this.bheckRuleWebService.queryCheckRuleWebByMid(onlineUser.getDatabase(), onlineUser.getMemId());
            if (!StrUtil.isNull(checkRule)) {
                if (!StrUtil.isNull(checkRule.getMids())) {
                    String mids[] = checkRule.getMids().split(",");
                    num1 = mids.length;
                    num3 = this.bheckRuleWebService.queryCheckInCDrs(onlineUser.getDatabase(), checkRule.getMids(), sdate, edate, "迟到").size();
                    num4 = this.bheckRuleWebService.queryCheckInCDrs(onlineUser.getDatabase(), checkRule.getMids(), sdate, edate, "早退").size();
                    for (int i = 0; i < mids.length; i++) {
                        BscCheckRule checkRule2 = this.bheckRuleWebService.queryCheckRuleWebBysyMid(onlineUser.getDatabase(), Integer.parseInt(mids[i]));
                        int count1 = 0;
                        int count2 = 0;
                        if (!StrUtil.isNull(checkRule2)) {
                            String str[] = StrUtil.GetSbTs2(sdate, edate, checkRule2.getCheckWeeks()).split(",");
                            for (int j = 0; j < str.length; j++) {
                                count1 = count1 + this.bheckRuleWebService.queryIsAuditqJ(onlineUser.getDatabase(), Integer.parseInt(mids[i]), str[j].substring(0, str[j].indexOf(":")));
                                if (!str[j].substring(0, str[j].indexOf(":")).equals(DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd"))) {
                                    count2 = count2 + this.bheckRuleWebService.queryIsCheckinDk(onlineUser.getDatabase(), Integer.parseInt(mids[i]), str[j].substring(0, str[j].indexOf(":")));
                                }

                            }
                        }
                        if (count1 > 0) {
                            num6 = num6 + 1;
                        }
                        if (count2 % 2 != 0) {
                            num5 = num5 + 1;
                        }
                    }
                }
            }
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "获取考勤(团队)数据成功");
            json.put("num1", num1);
            json.put("num2", num1 - num6);
            json.put("num3", num3);
            json.put("num4", num4);
            json.put("num5", num5);
            json.put("num6", num6);
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            this.sendWarm(response, "获取考勤(团队)数据失败");
        }
    }

    /**
     * 说明：考勤(我的)
     *
     * @创建：作者:llp 创建时间：2017-3-2
     * @修改历史： [序号](llp 2017 - 3 - 2)<修改说明>
     */
    @RequestMapping("queryCheckMy")
    public void queryCheckMy(HttpServletResponse response, String token, String sdate, String edate) {
        try {
            if (!checkParam(response, token, sdate, edate))
                return;
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            OnlineUser onlineUser = message.getOnlineMember();
            int num1 = 0;
            int num2 = 0;
            int num3 = 0;
            int num4 = 0;
            int num5 = 0;
            int num6 = 0;
            BscCheckRule checkRule = this.bheckRuleWebService.queryCheckRuleWebBysyMid(onlineUser.getDatabase(), onlineUser.getMemId());
            if (!StrUtil.isNull(checkRule)) {
                num2 = StrUtil.GetSbTs(sdate, edate, checkRule.getCheckWeeks());
                String str[] = StrUtil.GetSbTs2(sdate, edate, checkRule.getCheckWeeks()).split(",");
                if (!StrUtil.isNull(str[0])) {
                    int no1 = 0;
                    for (int j = 0; j < str.length; j++) {
                        int no2 = 0;
                        int n3 = this.bheckRuleWebService.queryIsCheckinCdZt(onlineUser.getDatabase(), onlineUser.getMemId(), str[j].substring(0, str[j].indexOf(":")), "迟到");
                        if (n3 > 0) {
                            num3 = num3 + n3;
                            no2 = no2 + 1;
                        }
                        int n4 = this.bheckRuleWebService.queryIsCheckinCdZt(onlineUser.getDatabase(), onlineUser.getMemId(), str[j].substring(0, str[j].indexOf(":")), "早退");
                        if (n4 > 0) {
                            num4 = num4 + n4;
                            no2 = no2 + 1;
                        }
                        if (!str[j].substring(0, str[j].indexOf(":")).equals(DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd"))) {
                            String s[] = checkRule.getCheckWeeks().split(",");
                            String s1[] = checkRule.getCheckTimes().split(",");
                            for (int i = 0; i < s.length; i++) {
                                if (s[i].equals(str[j].substring(str[j].indexOf(":") + 1, str[j].length()))) {
                                    int zhi = s1[i].split(" ").length * 2;
                                    int zhi2 = this.bheckRuleWebService.queryIsCheckinDk(onlineUser.getDatabase(), onlineUser.getMemId(), str[j].substring(0, str[j].indexOf(":")));
                                    int zhi3 = zhi - zhi2;
                                    if (zhi2 != 0) {
                                        num5 = num5 + zhi3;
                                        no2 = no2 + 1;
                                    }
                                }
                            }
                        }
                        if (no2 > 0) {
                            no1 = no1 + 1;
                        }
                    }
                    num6 = this.bheckRuleWebService.queryAuditQjCount(onlineUser.getDatabase(), onlineUser.getMemId(), sdate, edate);
                    num1 = num2 - no1 - num6;
                }
            }
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "获取考勤(我的)数据成功");
            json.put("num1", num1);
            json.put("num2", num2);
            json.put("num3", num3);
            json.put("num4", num4);
            json.put("num5", num5);
            json.put("num6", num6);
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            this.sendWarm(response, "获取考勤(我的)数据失败");
        }
    }

    public static void main(String[] args) {
        String s = "1";
        String[] ss = s.split(",");
        for (int i = 0; i < ss.length; i++) {
            System.out.println(ss[i]);
        }

    }
}
