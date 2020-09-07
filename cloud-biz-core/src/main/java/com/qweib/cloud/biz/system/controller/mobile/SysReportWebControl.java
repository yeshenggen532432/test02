package com.qweib.cloud.biz.system.controller.mobile;


import com.qweib.cloud.biz.common.CnlifeConstants;
import com.qweib.cloud.biz.system.BaseWebService;
import com.qweib.cloud.biz.system.TokenServer;
import com.qweib.cloud.biz.system.UploadFile;
import com.qweib.cloud.biz.system.jpush.JpushClassifies;
import com.qweib.cloud.biz.system.jpush.JpushClassifies2;
import com.qweib.cloud.biz.system.service.SysReportCdService;
import com.qweib.cloud.biz.system.service.ws.SysChatMsgService;
import com.qweib.cloud.biz.system.service.ws.SysMemWebService;
import com.qweib.cloud.biz.system.service.ws.SysMemberWebService;
import com.qweib.cloud.biz.system.service.ws.SysReportWebService;
import com.qweib.cloud.core.domain.*;
import com.qweib.cloud.core.exception.BizException;
import com.qweib.cloud.utils.DateTimeUtil;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import com.qweibframework.commons.redis.token.TokenCheckTag;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.*;

@Controller
@RequestMapping("/web")
public class SysReportWebControl extends BaseWebService {
    @Resource
    private SysReportWebService reportWebService;
    @Resource
    private SysMemberWebService memberWebService;
    @Resource
    private SysChatMsgService chatMsgService;
    @Resource
    private SysMemWebService memWebService;
    @Resource
    private JpushClassifies jpushClassifies;
    @Resource
    private JpushClassifies2 jpushClassifies2;
    @Resource
    private SysReportCdService reportCdService;

    /**
     * 说明：分页查询报(表)
     *
     * @创建：作者:llp 创建时间：2016-12-19
     * @修改历史： [序号](llp 2016 - 12 - 19)<修改说明>
     * yw 1 已写日报 2 未写日报  默认1
     */
    @RequestMapping("queryReportWebPage1")
    public void queryReportWebPage1(HttpServletResponse response, String token, Integer pageNo, Integer pageSize, Integer tp, String memberNm,
                                    String sdate, String edate, String fsMids, @RequestParam(defaultValue = "1") String yw, @RequestParam(defaultValue = "3") String dataTp, String mids) {
        try {
            if (!checkParam(response, token))
                return;
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
//			if (StrUtil.isNull(dataTp)) {//未传数据类型
//				sendWarm(response, CnlifeConstants.VIEW_MESSAGE);
//				return;
//			}
            if (pageSize == null) {
                pageSize = 10;
            }
            OnlineUser onlineUser = message.getOnlineMember();
            SysReport report = new SysReport();
//			if(!StrUtil.isNull(member.getIsUnitmng())){
//				if(member.getIsUnitmng().equals("3")){
//					String str=this.memberWebService.queryMidStr(onlineUser.getDatabase(), member.getBranchId()).get("str").toString();
//					report.setTp2("2");
//					report.setStr(str);
//				}else if(member.getIsUnitmng().equals("1")||member.getIsUnitmng().equals("2")){
//					report.setTp2("1");
//				}else if(member.getIsUnitmng().equals("0")){
//					report.setTp2("3");
//					report.setStr(onlineUser.getMemId().toString());
//				}
//			}else{
//				report.setTp2("3");
//				report.setStr(onlineUser.getMemId().toString());
//			}
            report.setTp(tp);
            report.setMemberNm(memberNm);
            report.setSdate(sdate);
            report.setEdate(edate);
            report.setFsMids(fsMids);
            if (!StrUtil.isNull(mids)) {
                mids = mids + "," + onlineUser.getMemId();
            }
            Page p = null;
            if ("1".equals(yw)) {
                p = this.reportWebService.queryReportWebPage1(report, onlineUser, dataTp, pageNo, pageSize, mids);
            } else {
                p = this.reportWebService.queryReportWebPage11(report, onlineUser, dataTp, pageNo, pageSize, mids);
            }
//			if(!StrUtil.isNull(yw)){
//				if(yw.equals("2")){
//					p=this.reportWebService.queryReportWebPage11(report, onlineUser.getDatabase(), pageNo, pageSize);
//				}else{
//					p=this.reportWebService.queryReportWebPage1(report, onlineUser.getDatabase(), pageNo, pageSize);
//				}
//			}else{
//				p=this.reportWebService.queryReportWebPage1(report, onlineUser.getDatabase(), pageNo, pageSize);
//			}
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "获报(表)列表成功");
            json.put("pageNo", pageNo);
            json.put("pageSize", pageSize);
            json.put("total", p.getTotal());
            json.put("totalPage", p.getTotalPage());
            json.put("rows", p.getRows());
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            this.sendWarm(response, "获取报(表)列表失败");
        }
    }

    /**
     * 说明：分页查询报(我发出的)
     *
     * @创建：作者:llp 创建时间：2016-12-19
     * @修改历史： [序号](llp 2016 - 12 - 19)<修改说明>
     */
    @RequestMapping("queryReportWebPage2")
    public void queryReportWebPage2(HttpServletResponse response, String token, Integer pageNo, Integer pageSize, Integer tp) {
        try {
            if (!checkParam(response, token))
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
            SysReport report = new SysReport();
            report.setMemberId(onlineUser.getMemId());
            report.setTp(tp);
            Page p = this.reportWebService.queryReportWebPage2(report, onlineUser.getDatabase(), pageNo, pageSize);
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "获报(我发出的)列表成功");
            json.put("pageNo", pageNo);
            json.put("pageSize", pageSize);
            json.put("total", p.getTotal());
            json.put("totalPage", p.getTotalPage());
            json.put("rows", p.getRows());
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            this.sendWarm(response, "获取报(我发出的)列表失败");
        }
    }

    /**
     * 说明：分页查询报(我收到的)
     *
     * @创建：作者:llp 创建时间：2016-12-19
     * @修改历史： [序号](llp 2016 - 12 - 19)<修改说明>
     */
    @RequestMapping("queryReportWebPage3")
    public void queryReportWebPage3(HttpServletResponse response, String token, Integer pageNo, Integer pageSize, Integer tp, String sdate, String edate, String fsMids) {
        try {
            if (!checkParam(response, token))
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
            SysReport report = new SysReport();
            report.setMemberId(onlineUser.getMemId());
            report.setTp(tp);
            report.setSdate(sdate);
            report.setEdate(edate);
            report.setFsMids(fsMids);
            Page p = this.reportWebService.queryReportWebPage3(report, onlineUser.getDatabase(), pageNo, pageSize);
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "获报(我收到的)列表成功");
            json.put("pageNo", pageNo);
            json.put("pageSize", pageSize);
            json.put("total", p.getTotal());
            json.put("totalPage", p.getTotalPage());
            json.put("rows", p.getRows());
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            this.sendWarm(response, "获取报(我收到的)列表失败");
        }
    }

    /**
     * 说明：添加报
     */
    @TokenCheckTag
    @ResponseBody
    @RequestMapping("addReport")
    public Map<String, Object> addReport(HttpServletResponse response, HttpServletRequest request, String token, Integer tp, String gzNr, String gzZj, String gzJh, String gzBz, String remo, String usrIds, String fileNms, String address) throws Exception {
        OnlineMessage message = TokenServer.tokenCheck(token);
        OnlineUser onlineUser = message.getOnlineMember();
        SysReport report = new SysReport();
        report.setMemberId(onlineUser.getMemId());
        report.setFbTime(DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd HH:mm:ss"));
        report.setGzBz(gzBz);
        report.setGzJh(gzJh);
        report.setGzNr(gzNr);
        report.setGzZj(gzZj);
        report.setRemo(remo);
        report.setTp(tp);
        report.setAddress(address);
        report.setFileNms(fileNms);
        //----------用户---------------
        List<SysReportYh> list1 = new ArrayList<SysReportYh>();
        String[] s1 = usrIds.split(",");
        for (int i = 0; i < s1.length; i++) {
            SysReportYh reportYh = new SysReportYh();
            reportYh.setFsMid(onlineUser.getMemId());
            reportYh.setJsMid(Integer.parseInt(s1[i]));
            list1.add(reportYh);
        }
        //----------图片---------------
        List<SysReportFile> list2 = new ArrayList<SysReportFile>();
        //使用request取
        Map<String, Object> map1 = UploadFile.updatePhotosdg(request, onlineUser.getDatabase(), "report", 1, "1");
        if ("1".equals(map1.get("state"))) {
            if ("1".equals(map1.get("ifImg"))) {//是否有图片
                SysReportFile ReportFile1 = new SysReportFile();
                List<String> pic = (List<String>) map1.get("fileNames");
                List<String> picMini = (List<String>) map1.get("smallFile");
                for (int i = 0; i < pic.size(); i++) {
                    ReportFile1 = new SysReportFile();
                    ReportFile1.setPicMini(picMini.get(i));
                    ReportFile1.setPic(pic.get(i));
                    list2.add(ReportFile1);
                }
            }
        } else {
            throw new BizException("图片上传失败");
        }
        //----------附件---------------
        String basePath = request.getSession().getServletContext().getRealPath("/upload/report/");
        List<SysReportFile> list3 = new ArrayList<SysReportFile>();
        int id = this.reportWebService.addReport(report, list1, list2, list3, onlineUser.getDatabase());
        if (id > 0) {
            for (int i = 0; i < s1.length; i++) {
                SysChatMsg scm = new SysChatMsg();
                scm.setAddtime(DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd HH:mm:ss"));
                scm.setMemberId(onlineUser.getMemId());
                scm.setReceiveId(Integer.parseInt(s1[i]));
                scm.setBelongId(id);
                scm.setBelongNm("工作汇报");
                scm.setBelongMsg(tp.toString());
                scm.setTp("34");//日志
                scm.setMsg(onlineUser.getMemberNm() + "的【" + gzNr + "】等待你查看");
                chatMsgService.addChatMsg(scm, onlineUser.getDatabase());
                SysMemDTO mem = memWebService.queryMemByMemId(Integer.parseInt(s1[i]));
                jpushClassifies.toJpush(mem.getMemberMobile(), CnlifeConstants.MODE8, CnlifeConstants.NEWMSG, null, null, "添加日志", null);//屏蔽
                jpushClassifies2.toJpush(mem.getMemberMobile(), CnlifeConstants.MODE8, CnlifeConstants.NEWMSG, null, null, "添加日志", null);//屏蔽
            }
        }
        Map<String, Object> json = new HashMap<>();
        json.put("state", true);
        json.put("msg", "添加报成功");
        return json;
    }

    /**
     * 说明：获取报详情
     *
     * @创建：作者:llp 创建时间：2016-12-20
     * @修改历史： [序号](llp 2016 - 12 - 20)<修改说明>
     */
    @RequestMapping("queryReportWeb")
    public void queryReportWeb(HttpServletResponse response, String token, Integer id) {
        try {
            if (!checkParam(response, token, id))
                return;
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            OnlineUser onlineUser = message.getOnlineMember();
            SysReport report = this.reportWebService.queryReportById(id, onlineUser.getDatabase());
            List<SysReportYh> list1 = this.reportWebService.queryReportYh(id, onlineUser.getDatabase());
            List<SysReportFile> list2 = this.reportWebService.queryReportFile(id, 1, onlineUser.getDatabase());
            //List<SysReportFile> list3=this.reportWebService.queryReportFile(id, 2, onlineUser.getDatabase());
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "获取报详情成功");
            json.put("gzNr", report.getGzNr());
            json.put("gzZj", report.getGzZj());
            json.put("gzJh", report.getGzJh());
            json.put("gzBz", report.getGzBz());
            json.put("remo", report.getRemo());
            json.put("address", report.getAddress());
            json.put("fileNms", report.getFileNms());
            json.put("list1", list1);
            json.put("list2", list2);
            //json.put("list3", list3);
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            this.sendWarm(response, "获取报详情失败");
        }
    }

    /**
     * 说明：添加报评论
     *
     * @创建：作者:llp 创建时间：2016-12-30
     * @修改历史： [序号](llp 2016 - 12 - 30)<修改说明>
     */
    @RequestMapping("addReportPl")
    public void addReportPl(HttpServletResponse response, String token, Integer bid, String content) {
        try {
            if (!checkParam(response, token, bid, content))
                return;
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            OnlineUser onlineUser = message.getOnlineMember();
            SysReport report = this.reportWebService.queryReportById(bid, onlineUser.getDatabase());
            SysReportPl reportPl = new SysReportPl();
            reportPl.setBid(bid);
            reportPl.setContent(content);
            reportPl.setMemberId(onlineUser.getMemId());
            reportPl.setPltime(DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd HH:mm:ss"));
            this.reportWebService.addReportPl(reportPl, onlineUser.getDatabase());
            if (!report.getMemberId().equals(onlineUser.getMemId())) {
                SysMemDTO mem = memWebService.queryMemByMemId(report.getMemberId());
                SysChatMsg scm = new SysChatMsg();
                scm.setAddtime(DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd HH:mm:ss"));
                scm.setMemberId(onlineUser.getMemId());
                scm.setReceiveId(report.getMemberId());
                scm.setBelongId(bid);
                scm.setBelongNm("工作汇报");
                scm.setBelongMsg(report.getTp().toString());
                scm.setTp("40");//日志评论
                scm.setMsg(onlineUser.getMemberNm() + "对您的工作汇报进行了评论！");
                chatMsgService.addChatMsg(scm, onlineUser.getDatabase());
                jpushClassifies.toJpush(mem.getMemberMobile(), "日志评论通知", CnlifeConstants.NEWMSG, null, null, "日志评论", null);//屏蔽
                jpushClassifies2.toJpush(mem.getMemberMobile(), "日志评论通知", CnlifeConstants.NEWMSG, null, null, "日志评论", null);//屏蔽
            }
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "添加报评论成功");
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            this.sendWarm(response, "获取报详情失败");
        }
    }

    /**
     * 说明：分页查询报评论
     *
     * @创建：作者:llp 创建时间：2016-12-30
     * @修改历史： [序号](llp 2016 - 12 - 30)<修改说明>
     */
    @RequestMapping("queryReportPlWebPage")
    public void queryReportPlWebPage(HttpServletResponse response, String token, Integer pageNo, Integer pageSize, Integer bid) {
        try {
            if (!checkParam(response, token))
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
            Page p = this.reportWebService.queryReportPlWebPage(bid, onlineUser.getDatabase(), pageNo, pageSize);
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "获报评论列表成功");
            json.put("pageNo", pageNo);
            json.put("pageSize", pageSize);
            json.put("total", p.getTotal());
            json.put("totalPage", p.getTotalPage());
            json.put("rows", p.getRows());
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            this.sendWarm(response, "获取报评论列表失败");
        }
    }

    /**
     * 说明：获取报文字长度信息
     *
     * @创建：作者:llp 创建时间：2016-12-30
     * @修改历史： [序号](llp 2016 - 12 - 30)<修改说明>
     */
    @RequestMapping("queryreportcdWeb")
    public void queryreportcdWeb(HttpServletResponse response, String token, Integer id) {
        try {
            if (!checkParam(response, token))
                return;
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            SysReportCd reportCd = this.reportCdService.queryReportCd(message.getOnlineMember().getDatabase(), id);
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "获取报文字长度信息成功");
            json.put("gzNrcd", reportCd.getGzNrcd());
            json.put("gzZjcd", reportCd.getGzZjcd());
            json.put("gzJhcd", reportCd.getGzJhcd());
            json.put("gzBzcd", reportCd.getGzBzcd());
            json.put("remocd", reportCd.getRemocd());
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            this.sendWarm(response, "获取日报文字长度信息失败");
        }
    }
}
