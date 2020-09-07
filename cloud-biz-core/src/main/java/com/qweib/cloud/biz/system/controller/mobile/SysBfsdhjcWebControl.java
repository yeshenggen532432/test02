package com.qweib.cloud.biz.system.controller.mobile;


import com.qweib.cloud.biz.system.BaseWebService;
import com.qweib.cloud.biz.system.TokenServer;
import com.qweib.cloud.biz.system.UploadFile;
import com.qweib.cloud.biz.system.service.ws.SysBfsdhjcService;
import com.qweib.cloud.biz.system.service.ws.SysBfxgPicWebService;
import com.qweib.cloud.core.domain.OnlineMessage;
import com.qweib.cloud.core.domain.OnlineUser;
import com.qweib.cloud.core.domain.SysBfsdhjc;
import com.qweib.cloud.core.domain.SysBfxgPic;
import com.qweib.cloud.core.exception.BizException;
import com.qweib.cloud.utils.StrUtil;
import com.qweibframework.commons.redis.token.TokenCheckTag;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.text.SimpleDateFormat;
import java.util.*;

@Controller
@RequestMapping("/web")
public class SysBfsdhjcWebControl extends BaseWebService {
	@Resource
	private SysBfsdhjcService bfsdhjcService;
	@Resource
	private SysBfxgPicWebService bfxgPicWebService;
	/**
	 *说明：添加生动化检查
	 */
	@TokenCheckTag
	@ResponseBody
	@RequestMapping("addBfsdhjcWeb")
	public Map<String, Object> addBfsdhjcWeb(HttpServletResponse response,HttpServletRequest request,String token,Integer cid,String pophb,String cq,
			String wq,String remo1,String isXy,String remo2,String date){
			if(StrUtil.isNull(date)){
				date=new SimpleDateFormat("yyyy-MM-dd").format(new Date());
			}
			OnlineMessage message = TokenServer.tokenCheck(token);
			OnlineUser onlineUser = message.getOnlineMember();
			SysBfsdhjc bfsdhjc=new SysBfsdhjc();
			bfsdhjc.setCid(cid);
			bfsdhjc.setCq(cq);
			bfsdhjc.setIsXy(isXy);
			bfsdhjc.setMid(onlineUser.getMemId());
			bfsdhjc.setPophb(pophb);
			bfsdhjc.setRemo1(remo1);
			bfsdhjc.setRemo2(remo2);
			bfsdhjc.setWq(wq);
			bfsdhjc.setSddate(date);
           //----------生动化----------------
		    List<SysBfxgPic> bfxgPicLs1=new ArrayList<SysBfxgPic>();
           //使用request取
			Map<String, Object> map1 = UploadFile.updatePhotosdg(request,onlineUser.getDatabase(), "bfkh/sdh",1,"1");
			if("1".equals(map1.get("state"))){
				if("1".equals(map1.get("ifImg"))){//是否有图片
					SysBfxgPic btp = new SysBfxgPic();
					List<String> pic = (List<String>)map1.get("fileNames");
					List<String> picMini = (List<String>)map1.get("smallFile");
					for (int i = 0; i < pic.size(); i++) {
						btp = new SysBfxgPic();
						btp.setPicMini(picMini.get(i));
						btp.setPic(pic.get(i));
						bfxgPicLs1.add(btp);
					}
				}
			}else{
				throw new BizException("生动化图片上传失败");
			}
           //----------堆头----------------
		    List<SysBfxgPic> bfxgPicLs2=new ArrayList<SysBfxgPic>();
           //使用request取
			Map<String, Object> map2 = UploadFile.updatePhotosdg(request,onlineUser.getDatabase(), "bfkh/dt",1,"2");
			if("1".equals(map2.get("state"))){
				if("1".equals(map2.get("ifImg"))){//是否有图片
					SysBfxgPic btp = new SysBfxgPic();
					List<String> pic = (List<String>)map2.get("fileNames");
					List<String> picMini = (List<String>)map2.get("smallFile");
					for (int i = 0; i < pic.size(); i++) {
						btp = new SysBfxgPic();
						btp.setPicMini(picMini.get(i));
						btp.setPic(pic.get(i));
						bfxgPicLs2.add(btp);
					}
				}
			}else{
				throw new BizException("生动化图片上传失败");
			}
			this.bfsdhjcService.addBfsdhjc(bfsdhjc, bfxgPicLs1, bfxgPicLs2, onlineUser.getDatabase());
			Map<String,Object> json = new HashMap<>();
			json.put("state",true);
			json.put("msg", "添加生动化检查成功");
			return json;
	}
	/**
	 *说明：修改生动化检查
	 *@创建：作者:llp		创建时间：2016-3-24
	 *@修改历史：
	 *		[序号](llp	2016-3-24)<修改说明>
	 */
	@RequestMapping("updateBfsdhjcWeb")
	public void updateBfsdhjcWeb(HttpServletResponse response,HttpServletRequest request,String token,Integer id,Integer cid,String pophb,String cq,
			String wq,String remo1,String isXy,String remo2,String date){
		try{
			if(!checkParam(response, token,id,cid)){
				return;
			}
			if(StrUtil.isNull(date)){
				date=new SimpleDateFormat("yyyy-MM-dd").format(new Date());
			}
			OnlineMessage message = TokenServer.tokenCheck(token);
			if(message.isSuccess()==false){
				sendWarm(response, message.getMessage());
				return;
			}
			OnlineUser onlineUser = message.getOnlineMember();
			SysBfsdhjc bfsdhjc=new SysBfsdhjc();
			bfsdhjc.setId(id);
			bfsdhjc.setCid(cid);
			bfsdhjc.setCq(cq);
			bfsdhjc.setIsXy(isXy);
			bfsdhjc.setMid(onlineUser.getMemId());
			bfsdhjc.setPophb(pophb);
			bfsdhjc.setRemo1(remo1);
			bfsdhjc.setRemo2(remo2);
			bfsdhjc.setWq(wq);
			bfsdhjc.setSddate(date);
           //----------生动化----------------
		    List<SysBfxgPic> bfxgPicLs1=new ArrayList<SysBfxgPic>();
           //使用request取
			Map<String, Object> map1 = UploadFile.updatePhotosdg(request, onlineUser.getDatabase(), "bfkh/sdh",1,"1");
			if("1".equals(map1.get("state"))){
				if("1".equals(map1.get("ifImg"))){//是否有图片
					SysBfxgPic btp = new SysBfxgPic();
					List<String> pic = (List<String>)map1.get("fileNames");
					List<String> picMini = (List<String>)map1.get("smallFile");
					for (int i = 0; i < pic.size(); i++) {
						btp = new SysBfxgPic();
						btp.setPicMini(picMini.get(i));
						btp.setPic(pic.get(i));
						bfxgPicLs1.add(btp);
					}
				}
			}else{
				sendWarm(response, "生动化图片上传失败");
				return;
			}
           //----------堆头----------------
		    List<SysBfxgPic> bfxgPicLs2=new ArrayList<SysBfxgPic>();
           //使用request取
			Map<String, Object> map2 = UploadFile.updatePhotosdg(request,onlineUser.getDatabase(), "bfkh/dt",1,"2");
			if("1".equals(map2.get("state"))){
				if("1".equals(map2.get("ifImg"))){//是否有图片
					SysBfxgPic btp = new SysBfxgPic();
					List<String> pic = (List<String>)map2.get("fileNames");
					List<String> picMini = (List<String>)map2.get("smallFile");
					for (int i = 0; i < pic.size(); i++) {
						btp = new SysBfxgPic();
						btp.setPicMini(picMini.get(i));
						btp.setPic(pic.get(i));
						bfxgPicLs2.add(btp);
					}
				}
			}else{
				sendWarm(response, "堆头图片上传失败");
				return;
			}
			this.bfsdhjcService.updateBfsdhjc(bfsdhjc, bfxgPicLs1, bfxgPicLs2, onlineUser.getDatabase());
			JSONObject json = new JSONObject();
			json.put("state",true);
			json.put("msg", "修改生动化检查成功");
			this.sendJsonResponse(response, json.toString());
		} catch (Exception e) {
			this.sendWarm(response, "修改生动化检查失败");
		}
	}
	/**
	 *说明：获取生动化检查信息
	 *@创建：作者:llp		创建时间：2016-3-24
	 *@修改历史：
	 *		[序号](llp	2016-3-24)<修改说明>
	 */
	@RequestMapping("queryBfsdhjcWeb")
	public void queryBfsdhjcWeb(HttpServletResponse response,HttpServletRequest request,String token,Integer cid,String date){
		try{
			if(!checkParam(response, token,cid)){
				return;
			}
			if(StrUtil.isNull(date)){
				date=new SimpleDateFormat("yyyy-MM-dd").format(new Date());
			}
			OnlineMessage message = TokenServer.tokenCheck(token);
			if(message.isSuccess()==false){
				sendWarm(response, message.getMessage());
				return;
			}
			OnlineUser onlineUser = message.getOnlineMember();
			SysBfsdhjc bfsdhjc=this.bfsdhjcService.queryBfsdhjcOne(onlineUser.getDatabase(), onlineUser.getMemId(), cid,date);
			JSONObject json = new JSONObject();
			if(!StrUtil.isNull(bfsdhjc)){
				List<SysBfxgPic> list1=this.bfxgPicWebService.queryBfxgPicls(onlineUser.getDatabase(), bfsdhjc.getId(), 2,null);
				List<SysBfxgPic> list2=this.bfxgPicWebService.queryBfxgPicls(onlineUser.getDatabase(), bfsdhjc.getId(), 3,null);
				json.put("state",true);
				json.put("msg", "获取生动化检查信息成功");
				json.put("id",bfsdhjc.getId());
				json.put("cid",bfsdhjc.getCid());
				json.put("pophb",bfsdhjc.getPophb());
				json.put("cq",bfsdhjc.getCq());
				json.put("wq",bfsdhjc.getWq());
				json.put("remo1",bfsdhjc.getRemo1());
				json.put("isXy",bfsdhjc.getIsXy());
				json.put("remo2",bfsdhjc.getRemo2());
				json.put("list1",list1);
				json.put("list2",list2);
			}else{
				json.put("state",false);
				json.put("msg", "暂无记录");
			}
			this.sendJsonResponse(response, json.toString());
		} catch (Exception e) {
			this.sendWarm(response, "获取生动化检查信息失败");
		}
	}
}
