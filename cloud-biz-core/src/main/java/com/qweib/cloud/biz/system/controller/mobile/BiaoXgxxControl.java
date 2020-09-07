package com.qweib.cloud.biz.system.controller.mobile;


import com.qweib.cloud.biz.system.BaseWebService;
import com.qweib.cloud.biz.system.TokenServer;
import com.qweib.cloud.biz.system.service.BiaoCpddtjService;
import com.qweib.cloud.biz.system.service.BiaoKhbftjService;
import com.qweib.cloud.biz.system.service.BiaoXsddtjService;
import com.qweib.cloud.biz.system.service.BiaoYwbfzxService;
import com.qweib.cloud.biz.system.service.ws.*;
import com.qweib.cloud.core.domain.*;
import com.qweib.cloud.utils.DateTimeUtil;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;


@Controller
@RequestMapping("/web")
public class BiaoXgxxControl extends BaseWebService {
    @Resource
    private BiaoCpddtjService cpddtjService;
    @Resource
    private BiaoYwbfzxService ywbfzxService;
    @Resource
    private BiaoKhbftjService khbftjService;
    @Resource
    private BiaoXsddtjService xsddtjService;
    @Resource
    private SysBfxgPicWebService bfxgPicWebService;//图片
    @Resource
    private SysBfqdpzWebService bfqdpzWebService;//签到拍照
    @Resource
    private SysBfsdhjcService bfsdhjcService;//生动化检查
    @Resource
    private SysBfcljccjWebService bfcljccjWebService;//陈列检查采集
    @Resource
    private SysBfxsxjWebService bfxsxjWebService;//销售小结
    @Resource
    private SysBforderWebService bforderWebService;//供货下单
    @Resource
    private SysBfgzxcWebService bfgzxcWebService;//道谢并告知下次拜访
    @Resource
    private SysMemberWebService memberWebService;

    /**
     * 说明：分页查询产品订单统计表
     *
     * @创建：作者:llp 创建时间：2016-7-14
     * @修改历史： [序号](llp 2016 - 7 - 14)<修改说明>
     */
    @RequestMapping("queryCpddtjWeb")
    public void queryCpddtjWeb(HttpServletResponse response, String token, Integer pageNo, Integer pageSize,
                               String stime, String etime, String khNm, String xsTp, String pszd, @RequestParam(defaultValue = "3") String dataTp, String mids, Integer jepx) {
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
            BiaoCpddtj Cpddtj = new BiaoCpddtj();
            SysMember member = this.memberWebService.queryAllById(onlineUser.getMemId());
//			if(!StrUtil.isNull(member.getIsUnitmng())){
//				if(member.getIsUnitmng().equals("3")){
//					String str=this.memberWebService.queryMidStr(onlineUser.getDatabase(), member.getBranchId()).get("str").toString();
//					Cpddtj.setTp("2");
//					Cpddtj.setStr(str);
//				}else if(member.getIsUnitmng().equals("1")||member.getIsUnitmng().equals("2")){
//					Cpddtj.setTp("1");
//				}else if(member.getIsUnitmng().equals("0")){
//					Cpddtj.setTp("3");
//					Cpddtj.setStr(onlineUser.getMemId().toString());
//				}
//			}else{
//				Cpddtj.setTp("3");
//				Cpddtj.setStr(onlineUser.getMemId().toString());
//			}
            Cpddtj.setStime(stime);
            Cpddtj.setEtime(etime);
            Cpddtj.setKhNm(khNm);
            Cpddtj.setXsTp(xsTp);
            Cpddtj.setPszd(pszd);
            if (!StrUtil.isNull(mids)) {
                mids = mids + "," + onlineUser.getMemId();
            }
            Page p = this.cpddtjService.queryBiaoCpddtjWeb(Cpddtj, onlineUser, dataTp, pageNo, pageSize, mids, jepx);
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "获取产品订单统计表成功");
            json.put("pageNo", pageNo);
            json.put("pageSize", pageSize);
            json.put("total", p.getTotal());
            json.put("totalPage", p.getTotalPage());
            json.put("rows", p.getRows());
            List<ToolModel> toolModells = new ArrayList<ToolModel>();
            ToolModel toolModel = new ToolModel();
            toolModel.setNums(p.getTolnum());
            toolModel.setZjs(p.getTolprice());
            toolModells.add(toolModel);
            json.put("footer", toolModells);
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            this.sendWarm(response, "获取产品订单统计表失败");
        }
    }

    /**
     * 说明：分页查询业务拜访执行表
     *
     * @创建：作者:llp 创建时间：2016-7-14
     * @修改历史： [序号](llp 2016 - 7 - 14)<修改说明>
     */
    @RequestMapping("queryYwbfzxWeb")
    public void queryYwbfzxWeb(HttpServletResponse response, String token, Integer pageNo, Integer pageSize,
                               String qddate, String memberNm, String khdjNm, @RequestParam(defaultValue = "3") String dataTp, String mids) {
        try {
            if (!checkParam(response, token))
                return;
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
//			if (StrUtil.isNull(dataTp)) {//版本未更新提示
//				sendWarm(response, CnlifeConstants.VIEW_MESSAGE);
//				return;
//			}
            if (pageSize == null) {
                pageSize = 15;
            }
            OnlineUser onlineUser = message.getOnlineMember();
            BiaoYwbfzx Ywbfzx = new BiaoYwbfzx();
            SysMember member = this.memberWebService.queryAllById(onlineUser.getMemId());
//			if(!StrUtil.isNull(member.getIsUnitmng())){
//				if(member.getIsUnitmng().equals("3")){
//					String str=this.memberWebService.queryMidStr(onlineUser.getDatabase(), member.getBranchId()).get("str").toString();
//					Ywbfzx.setTp("2");
//					Ywbfzx.setStr(str);
//				}else if(member.getIsUnitmng().equals("1")||member.getIsUnitmng().equals("2")){
//					Ywbfzx.setTp("1");
//				}else if(member.getIsUnitmng().equals("0")){
//					Ywbfzx.setTp("3");
//					Ywbfzx.setStr(onlineUser.getMemId().toString());
//				}
//			}else{
//				Ywbfzx.setTp("3");
//				Ywbfzx.setStr(onlineUser.getMemId().toString());
//			}
            Ywbfzx.setMemberNm(memberNm);
            Ywbfzx.setKhdjNm(khdjNm);
            if (StrUtil.isNull(qddate)) {
                Ywbfzx.setQddate(DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd"));
            } else {
                Ywbfzx.setQddate(qddate);
            }
            if (!StrUtil.isNull(mids)) {
                mids = mids + "," + onlineUser.getMemId();
            }
            Page p = this.ywbfzxService.queryBiaoYwbfzxWeb(Ywbfzx, onlineUser, dataTp, pageNo, pageSize, mids);
            List<BiaoYwbfzx> vlist = (List<BiaoYwbfzx>) p.getRows();
            for (BiaoYwbfzx biaoYwbfzx : vlist) {
                Integer bfbz = 1;
                //签到图片数量
                //biaoYwbfzx.setQdtpNum(this.bfxgPicWebService.queryBfxgPicCount1(onlineUser.getDatabase(), biaoYwbfzx.getId(), 1));
                //生动化图片数量
                SysBfsdhjc bfsdhjc = this.bfsdhjcService.queryBfsdhjcOne(onlineUser.getDatabase(), biaoYwbfzx.getMid(), biaoYwbfzx.getCid(), biaoYwbfzx.getQddate());
                if (!StrUtil.isNull(bfsdhjc)) {
                    bfbz = bfbz + 1;
                }
                //陈列检查采集
                List<SysBfcljccj> list = this.bfcljccjWebService.queryBfcljccjOne(onlineUser.getDatabase(), biaoYwbfzx.getMid(), biaoYwbfzx.getCid(), biaoYwbfzx.getQddate());
                if (list.size() > 0) {
                    bfbz = bfbz + 1;
                }
                //库存集合
                List<SysBfxsxj> list2 = this.bfxsxjWebService.queryBfxsxjOne(onlineUser.getDatabase(), biaoYwbfzx.getMid(), biaoYwbfzx.getCid(), biaoYwbfzx.getQddate());
                if (list2.size() > 0) {
                    bfbz = bfbz + 1;
                }
                //订单集合
                SysBforder bforder = this.bforderWebService.queryBforderOne(onlineUser.getDatabase(), biaoYwbfzx.getMid(), biaoYwbfzx.getCid(), biaoYwbfzx.getQddate());
                if (!StrUtil.isNull(bforder)) {
                    bfbz = bfbz + 1;
                }
                //时间段
                SysBfgzxc bfgzxc = this.bfgzxcWebService.queryBfgzxcOne(onlineUser.getDatabase(), biaoYwbfzx.getMid(), biaoYwbfzx.getCid(), biaoYwbfzx.getQddate());
                if (!StrUtil.isNull(bfgzxc)) {
                    bfbz = bfbz + 1;
                    biaoYwbfzx.setTimed(biaoYwbfzx.getTimed() + "-" + bfgzxc.getDdtime());
                }
                biaoYwbfzx.setBfbz(bfbz);
            }
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "获取业务拜访执行表成功");
            json.put("pageNo", pageNo);
            json.put("pageSize", pageSize);
            json.put("total", p.getTotal());
            json.put("totalPage", p.getTotalPage());
            json.put("rows", p.getRows());
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            this.sendWarm(response, "获取业务拜访执行表失败");
        }
    }

    /**
     * 说明：分页查询客户拜访统计表
     *
     * @创建：作者:llp 创建时间：2016-7-14
     * @修改历史： [序号](llp 2016 - 7 - 14)<修改说明>
     */
    @RequestMapping("queryKhbftjWeb")
    public void queryKhbftjWeb(HttpServletResponse response, String token, Integer pageNo, Integer pageSize,
                               String stime, String etime, String memberNm, String khdjNm, Integer bfpl, @RequestParam(defaultValue = "3") String dataTp, String mids) {
        try {
            if (!checkParam(response, token))
                return;
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
//			if (StrUtil.isNull(dataTp)) {//为空
//				sendWarm(response, CnlifeConstants.VIEW_MESSAGE);
//				return;
//			}
            if (pageSize == null) {
                pageSize = 15;
            }
            OnlineUser onlineUser = message.getOnlineMember();
            BiaoKhbftj Khbftj = new BiaoKhbftj();
            SysMember member = this.memberWebService.queryAllById(onlineUser.getMemId());
//			if(!StrUtil.isNull(member.getIsUnitmng())){
//				if(member.getIsUnitmng().equals("3")){
//					String str=this.memberWebService.queryMidStr(onlineUser.getDatabase(), member.getBranchId()).get("str").toString();
//					Khbftj.setTp("2");
//					Khbftj.setStr(str);
//				}else if(member.getIsUnitmng().equals("1")||member.getIsUnitmng().equals("2")){
//					Khbftj.setTp("1");
//				}else if(member.getIsUnitmng().equals("0")){
//					Khbftj.setTp("3");
//					Khbftj.setStr(onlineUser.getMemId().toString());
//				}
//			}else{
//				Khbftj.setTp("3");
//				Khbftj.setStr(onlineUser.getMemId().toString());
//			}
            Khbftj.setBfpl(bfpl);
            Khbftj.setStime(stime);
            Khbftj.setEtime(etime);
            Khbftj.setMemberNm(memberNm);
            Khbftj.setKhdjNm(khdjNm);
            if (!StrUtil.isNull(mids)) {
                mids = mids + "," + onlineUser.getMemId();
            }
            Page p = this.khbftjService.queryBiaoKhbftjWeb(Khbftj, onlineUser, dataTp, pageNo, pageSize, mids);
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "获取客户拜访统计表成功");
            json.put("pageNo", pageNo);
            json.put("pageSize", pageSize);
            json.put("total", p.getTotal());
            json.put("totalPage", p.getTotalPage());
            json.put("rows", p.getRows());
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            this.sendWarm(response, "获取客户拜访统计表失败");
        }
    }

    /**
     * 说明：分页查询销售订单统计表
     *
     * @创建：作者:llp 创建时间：2016-7-22
     * @修改历史： [序号](llp 2016 - 7 - 22)<修改说明>
     */
    @RequestMapping("queryXsddtjWeb")
    public void queryXsddtjWeb(HttpServletResponse response, String token, Integer pageNo, Integer pageSize,
                               String stime, String etime, String khNm, String orderZt, String pszd, Integer cid, @RequestParam(defaultValue = "3") String dataTp, String mids) {
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
            BiaoXsddtj Xsddtj = new BiaoXsddtj();
//			if(!StrUtil.isNull(member.getIsUnitmng())){
//				if(member.getIsUnitmng().equals("3")){
//					String str=this.memberWebService.queryMidStr(onlineUser.getDatabase(), member.getBranchId()).get("str").toString();
//					Xsddtj.setTp("2");
//					Xsddtj.setStr(str);
//				}else if(member.getIsUnitmng().equals("1")||member.getIsUnitmng().equals("2")){
//					Xsddtj.setTp("1");
//				}else if(member.getIsUnitmng().equals("0")){
//					Xsddtj.setTp("3");
//					Xsddtj.setStr(onlineUser.getMemId().toString());
//				}
//			}else{
//				Xsddtj.setTp("3");
//				Xsddtj.setStr(onlineUser.getMemId().toString());
//			}
            Xsddtj.setStime(stime);
            Xsddtj.setEtime(etime);
            Xsddtj.setKhNm(khNm);
            Xsddtj.setOrderZt(orderZt);
            Xsddtj.setPszd(pszd);
            Xsddtj.setCid(cid);
            if (!StrUtil.isNull(mids)) {
                mids = mids + "," + onlineUser.getMemId();
            }
            Page p = this.xsddtjService.queryBiaoXsddtjWeb(Xsddtj, onlineUser, dataTp, pageNo, pageSize, mids);
            List<BiaoXsddtj> vlist = (List<BiaoXsddtj>) p.getRows();
            for (BiaoXsddtj biaoXsddtj : vlist) {
                List<SysBforderDetail> list = this.xsddtjService.queryOrderDetailS(onlineUser.getDatabase(), biaoXsddtj.getOrderIds());
                biaoXsddtj.setList1(list);
            }
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "获取销售订单统计表成功");
            json.put("pageNo", pageNo);
            json.put("pageSize", pageSize);
            json.put("total", p.getTotal());
            json.put("totalPage", p.getTotalPage());
            json.put("rows", p.getRows());
            List<ToolModel> toolModells = new ArrayList<ToolModel>();
            ToolModel toolModel = new ToolModel();
            toolModel.setNums(p.getTolnum());
            toolModel.setZjs(p.getTolprice());
            toolModells.add(toolModel);
            json.put("footer", toolModells);
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            this.sendWarm(response, "获取销售订单统计表失败");
        }
    }

    @RequestMapping("queryTolpricexs")
    public void queryTolpricexs(HttpServletResponse response, String token, String stime, String etime, String khNm, Integer cid, @RequestParam(defaultValue = "3") String dataTp, String mids) {
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
            BiaoXsddtj Xsddtj = new BiaoXsddtj();
            SysMember member = this.memberWebService.queryAllById(onlineUser.getMemId());
//			if(!StrUtil.isNull(member.getIsUnitmng())){
//				if(member.getIsUnitmng().equals("3")){
//					String str=this.memberWebService.queryMidStr(onlineUser.getDatabase(), member.getBranchId()).get("str").toString();
//					Xsddtj.setTp("2");
//					Xsddtj.setStr(str);
//				}else if(member.getIsUnitmng().equals("1")||member.getIsUnitmng().equals("2")){
//					Xsddtj.setTp("1");
//				}else if(member.getIsUnitmng().equals("0")){
//					Xsddtj.setTp("3");
//					Xsddtj.setStr(onlineUser.getMemId().toString());
//				}
//			}else{
//				Xsddtj.setTp("3");
//				Xsddtj.setStr(onlineUser.getMemId().toString());
//			}
            Xsddtj.setStime(stime);
            Xsddtj.setEtime(etime);
            Xsddtj.setKhNm(khNm);
            Xsddtj.setCid(cid);
            if (!StrUtil.isNull(mids)) {
                mids = mids + "," + onlineUser.getMemId();
            }
            Map<String, Object> temp = this.xsddtjService.queryTolprice(Xsddtj, onlineUser, dataTp, mids);
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "获取销售订单统计金额成功");
            json.put("tolprice", StrUtil.convertDouble(temp.get("tolprice")));
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            this.sendWarm(response, "获取销售订单统计金额失败");
        }
    }
}
