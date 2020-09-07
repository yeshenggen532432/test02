package com.qweib.cloud.biz.signin.webservice;

import com.qweib.cloud.biz.signin.model.SysSignDetail;
import com.qweib.cloud.biz.signin.model.SysSignIn;
import com.qweib.cloud.biz.signin.service.SysSignInService;
import com.qweib.cloud.biz.system.BaseWebService;
import com.qweib.cloud.biz.system.TokenServer;
import com.qweib.cloud.biz.system.UploadFile;
import com.qweib.cloud.biz.system.service.SysCustomerTmpService;
import com.qweib.cloud.biz.system.service.ws.SysMemberWebService;
import com.qweib.cloud.core.domain.OnlineMessage;
import com.qweib.cloud.core.domain.OnlineUser;
import com.qweib.cloud.core.domain.SysCustomerTmp;
import com.qweib.cloud.core.domain.SysMember;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/web/sign")
public class SysSignInWebControl extends BaseWebService {

    @Resource
    private SysSignInService sysSignInService;
    @Resource
    private SysCustomerTmpService customerTmpService;
    @Resource
    private SysMemberWebService memberWebService;

    /**
     * 添加流动打卡
     */
    @RequestMapping("addSignIn")
    public void addSignIn(HttpServletResponse response, HttpServletRequest request, String token, SysSignIn bo, String khNm) {
        try {
            if (!checkParam(response, token, bo.getMid())) {
                return;
            }
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            OnlineUser onlineUser = message.getOnlineMember();

            if (StrUtil.isNull(bo.getSignTime())) {
                String ymd = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date());
                bo.setSignTime(ymd);
            }

            List<SysSignDetail> imgList = new ArrayList<SysSignDetail>();
            if (!StrUtil.isNull(bo.getVoiceTime())) {
                String voicePath = UploadFile.saveVoice(request, response, "sign/voice", onlineUser.getDatabase());
                SysSignDetail dtl = new SysSignDetail();
                dtl.setPic(voicePath);
                dtl.setPicMini("");
                dtl.setObjType(1);
                dtl.setSignId(0);
                imgList.add(dtl);
            }
            //使用request取
            Map<String, Object> map = UploadFile.updatePhotos(request, onlineUser.getDatabase(), "sign/imags", 1);
            if ("1".equals(map.get("state"))) {
                if ("1".equals(map.get("ifImg"))) {//是否有图片
                    SysSignDetail btp = new SysSignDetail();
                    List<String> pic = (List<String>) map.get("fileNames");
                    List<String> picMini = (List<String>) map.get("smallFile");
                    for (int i = 0; i < pic.size(); i++) {
                        btp = new SysSignDetail();
                        btp.setPicMini(picMini.get(i));
                        btp.setPic(pic.get(i));
                        btp.setObjType(0);
                        imgList.add(btp);
                    }
                }
            } else {
                sendWarm(response, "图片上传失败");
                return;
            }

            SysMember member = this.memberWebService.queryCompanySysMemberById(onlineUser.getDatabase(),onlineUser.getMemId());
            //添加临时客户，判断是否存在
            if(!StrUtil.isNull(khNm)){
                SysCustomerTmp oldBean = this.customerTmpService.queryTmpCustomerByKhNm(khNm, onlineUser.getDatabase());
                if(oldBean != null){
                    this.sendWarm(response, "该位置已命名");
                    return;
                }
            }

            bo.setDetailList(imgList);
            this.sysSignInService.addSignIn(bo, onlineUser.getDatabase(), khNm, onlineUser.getMemId(), member.getBranchId());
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "添加流动打卡成功");
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            e.printStackTrace();
            log.error("添加流动打卡失败", e);
            this.sendWarm(response, "添加流动打卡失败");
        }
    }

    @RequestMapping("querySignInPage")
    public void querySignInPage(HttpServletResponse response, HttpServletRequest request, String token, SysSignIn vo, Integer page, Integer rows) {
        try {
            if (!checkParam(response, token)) {
                return;
            }
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            OnlineUser onlineUser = message.getOnlineMember();
            if (!StrUtil.isNull(vo.getEdate())) {
                vo.setEdate(vo.getEdate() + " 23:59:59");
            }
            Page p = this.sysSignInService.querySignInPage1(vo, onlineUser.getDatabase(), page, rows);

            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "查询流动打卡成功");
            json.put("rows", p.getRows());
            json.put("total", p.getTotal());
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            log.error("查询流动打卡失败");
            this.sendWarm(response, "查询流动打卡失败");
        }
    }

    /**
     * 类似：手机端拜访地图中的拜访回放
     * 流动打卡 + 上下班
     */
    @RequestMapping("querySignInBfhf")
    public void querySignInBfhf(HttpServletResponse response, HttpServletRequest request, String token, Integer mid, String date) {
        try {
            if (!checkParam(response, token)) {
                return;
            }
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            OnlineUser onlineUser = message.getOnlineMember();
            List<SysSignIn> list = this.sysSignInService.querySignInBfhf(onlineUser.getDatabase(), mid, date);
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "查询流动打卡~拜访回放成功");
            json.put("list", list);
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            log.error("查询流动打卡~拜访回放失败");
            this.sendWarm(response, "查询流动打卡~拜访回放失败");
        }
    }


}
