package com.qweib.cloud.biz.system.controller.ws;

import com.qweib.cloud.biz.system.BaseWebService;
import com.qweib.cloud.biz.system.TokenServer;
import com.qweib.cloud.biz.system.UploadFile;
import com.qweib.cloud.biz.system.service.SysConfigService;
import com.qweib.cloud.biz.system.service.SysWareService;
import com.qweib.cloud.biz.system.service.SysWaresService;
import com.qweib.cloud.biz.system.service.SysWaretypeService;
import com.qweib.cloud.biz.system.service.ws.SysWareWebService;
import com.qweib.cloud.core.domain.*;
import com.qweib.cloud.utils.StrUtil;
import com.qweib.commons.StringUtils;
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
@RequestMapping("/web")
public class SysWareWebControl extends BaseWebService {
	@Resource
	private SysWareWebService wareWebService;
	@Resource
	private SysWareService wareService;
	@Resource
	private SysWaresService sysWaresService;

	@Resource
	private SysWaretypeService waretypeService;
	@Resource
	private SysConfigService configService;

	@RequestMapping("updateWareWeb")
	public void updateWareWeb(HttpServletResponse response,HttpServletRequest request,String token,Integer wareId,String delPicIds){
		try{
			if(!checkParam(response, token)){
				return;
			}
			OnlineMessage message = TokenServer.tokenCheck(token);
			if(message.isSuccess()==false){
				sendWarm(response, message.getMessage());
				return;
			}
			OnlineUser onlineUser = message.getOnlineMember();
			List<SysWarePic> warePicList=new ArrayList<SysWarePic>();
			SysWare sysWare  = this.wareService.queryWareById(wareId, onlineUser.getDatabase());
           //使用request取
			Map<String, Object> map = UploadFile.updatePhotos(request,onlineUser.getDatabase(), "ware/pic",1);
			if("1".equals(map.get("state"))){
				if("1".equals(map.get("ifImg"))){//是否有图片
					SysWarePic swp = new SysWarePic();
					List<String> pic = (List<String>)map.get("fileNames");
					List<String> picMini = (List<String>)map.get("smallFile");
					for (int i = 0; i < pic.size(); i++) {
						swp = new SysWarePic();
						swp.setPicMini(picMini.get(i));
						swp.setPic(pic.get(i));
						warePicList.add(swp);
					}
				}
			}else{
				sendWarm(response, "图片上传失败");
				return;
			}
			this.wareWebService.updateWare(sysWare, warePicList,delPicIds, onlineUser.getDatabase());
			JSONObject json = new JSONObject();
			json.put("state",true);
			json.put("msg", "修改商品照片成功");
			this.sendJsonResponse(response, json.toString());
		} catch (Exception e) {
			log.error("修改品照片失败", e);
			e.printStackTrace();
			this.sendWarm(response, "修改品照片失败");
		}
	}


	@RequestMapping("/saveWare")
	public void saveWare(HttpServletResponse response, HttpServletRequest request,String token, SysWare ware, String delPicIds) {
		if(!checkParam(response, token)){
			return;
		}
		OnlineMessage message = TokenServer.tokenCheck(token);
		if(message.isSuccess()==false){
			sendWarm(response, message.getMessage());
			return;
		}
		OnlineUser onlineUser = message.getOnlineMember();
		JSONObject json = new JSONObject();
		try {
			//====================================添加商品===================================
			//判断是否允许条码重复
			SysConfig config = this.configService.querySysConfigByCode("CONFIG_REPEAT_BE_BARCODE", onlineUser.getDatabase());
			if (config == null || "0".equals(config.getStatus())) {
				if (StringUtils.isNotEmpty(ware.getBeBarCode())) {
					Integer exists = this.wareService.queryWareByBeBarcode(ware.getBeBarCode(),  onlineUser.getDatabase());
					if (exists != null && !exists.equals(ware.getWareId())) {
						//该小单位条码已存在
						this.sendWarm(response, "该小单位条码已存在");
						return;
					}
				}

				if (StringUtils.isNotEmpty(ware.getPackBarCode())) {
					Integer exists = this.wareService.queryWareByPackBarcode(ware.getPackBarCode(),  onlineUser.getDatabase());
					if (exists != null && !exists.equals(ware.getWareId())) {
						//该大单位条码已存在
						this.sendWarm(response, "该大单位条码已存在");
						return;
					}
				}
			}

			int count1 = this.wareService.queryWareNmCount(ware.getWareNm(),  onlineUser.getDatabase());
			int count2 =0;
			if(!StrUtil.isNull(ware.getWareCode())){
				count2 = this.wareService.queryWareCodeCount(ware.getWareCode(),  onlineUser.getDatabase());
			}
			if(!StrUtil.isNull(ware.getWaretype())&&ware.getWaretype()==-1){
				SysWaretype sysWaretype =   this.waretypeService.getWareTypeByName("未分类", onlineUser.getDatabase());
				if(sysWaretype==null||StrUtil.isNull(sysWaretype.getWaretypeId())){
					sysWaretype = new SysWaretype();
					sysWaretype.setIsType(0);
					sysWaretype.setWaretypeNm("未分类");
					sysWaretype.setWaretypePid(0);
					sysWaretype.setShopQy(1);
					sysWaretype.setWaretypeLeaf("1");
					Integer id =  this.waretypeService.addWaretype(sysWaretype, onlineUser.getDatabase());
					sysWaretype.setWaretypeId(id);
				}
				ware.setWaretype(sysWaretype.getWaretypeId());
			}
			if (null == ware.getWareId()) {
				//该商品名称已存在了
				if (count1 > 0) {
					this.sendWarm(response, "该商品名称已存在了");
					return;
				}
				//该商品编码已存在了
				if (count2 > 0) {
					this.sendWarm(response, "该商品编码已存在了");
					return;
				}
				ware.setFbtime(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()));
				Map<String, Object> map = UploadFile.updatePhotos(request,  onlineUser.getDatabase(), "ware/pic", 1);
				List<SysWarePic> warePicList = new ArrayList<SysWarePic>();
				if ("1".equals(map.get("state"))) {
					if ("1".equals(map.get("ifImg"))) {//是否有图片
						SysWarePic swp = new SysWarePic();
						List<String> pic = (List<String>) map.get("fileNames");
						List<String> picMini = (List<String>) map.get("smallFile");
						for (int i = 0; i < pic.size(); i++) {
							swp = new SysWarePic();
							swp.setPicMini(picMini.get(i));
							swp.setPic(pic.get(i));
							warePicList.add(swp);
						}
						ware.setWarePicList(warePicList);
					}
				}
				config = this.configService.querySysConfigByCode("CONFIG_WARE_AUTO_CODE",  onlineUser.getDatabase());
				if (config != null && "1".equals(config.getStatus())) {
					if(StrUtil.isNull(ware.getWareCode())){
						Integer autoWareCode =  this.wareService.queryWareMaxId( onlineUser.getDatabase());
						ware.setWareCode("w"+autoWareCode);
					}
				}
				//换算比例
				Double bUnit = ware.getbUnit();
				if(StrUtil.isNumberNullOrZero(bUnit)){
					bUnit = 1.0;
				}
				Double sUnit = ware.getsUnit();
				if(StrUtil.isNumberNullOrZero(sUnit)){
					sUnit = 1.0;
				}
				Double hsNum = sUnit / bUnit;
				ware.setbUnit(bUnit);
				ware.setsUnit(sUnit);
				ware.setHsNum(hsNum);

				Integer id = 	this.wareService.addWare(ware,  onlineUser.getDatabase());
				json.put("state",true);
				json.put("msg", "新增商品信息成功");
				json.put("wareId",id);
				this.sendJsonResponse(response, json.toString());
			} else {

				//========================修改商品=========================
				SysWare oldWare = this.wareService.queryWareById(ware.getWareId(), onlineUser.getDatabase());
				if (count1 > 0) {
					if (!ware.getWareNm().equals(oldWare.getWareNm())) {
						//商品名称已存在
						this.sendWarm(response, "商品名称已存在");
						return;
					}
				}
				if (count2 > 0) {
					if (!ware.getWareCode().equals(oldWare.getWareCode())) {
						//商品编码已存在
						this.sendWarm(response, "商品编码已存在");
						return;
					}
				}
                oldWare.setWarePicList(null);//注意使用oldWare使用时，要先清空图片（因为warePicList在updateWare()中是添加图片的）
				Map<String, Object> map = UploadFile.updatePhotos(request,  onlineUser.getDatabase(), "ware/pic", 1);
				List<SysWarePic> warePicList = new ArrayList<>();
				if ("1".equals(map.get("state"))) {
					if ("1".equals(map.get("ifImg"))) {//是否有图片
						SysWarePic swp = new SysWarePic();
						List<String> pic = (List<String>) map.get("fileNames");
						List<String> picMini = (List<String>) map.get("smallFile");
						for (int i = 0; i < pic.size(); i++) {
							swp = new SysWarePic();
							swp.setPicMini(picMini.get(i));
							swp.setPic(pic.get(i));
							warePicList.add(swp);
						}
						oldWare.setWarePicList(warePicList);
					}
				}
				oldWare.setWareNm(ware.getWareNm());
				oldWare.setWaretype(ware.getWaretype());

				if(!StrUtil.isNumberNullOrZero(ware.getbUnit())){
					oldWare.setbUnit(ware.getbUnit());
				}

				if(!StrUtil.isNumberNullOrZero(ware.getsUnit())){
					oldWare.setsUnit(ware.getsUnit());
				}

				if(!StrUtil.isNumberNullOrZero(ware.getHsNum())){
					oldWare.setHsNum(ware.getHsNum());
				}

				//大单位
				oldWare.setWareDw(ware.getWareDw());
				oldWare.setWareGg(ware.getWareGg());
				oldWare.setWareDj(ware.getWareDj());
				if(StrUtil.isNull(ware.getWareDj())){
					//wareDj不为空，默认是0
					oldWare.setWareDj(0.0);
				}
				oldWare.setInPrice(ware.getInPrice());
				oldWare.setPackBarCode(ware.getPackBarCode());
				//小单位
                oldWare.setMinUnit(ware.getMinUnit());
                oldWare.setMinWareGg(ware.getMinWareGg());
                oldWare.setSunitPrice(ware.getSunitPrice());
                oldWare.setMinInPrice(ware.getMinInPrice());
                oldWare.setBeBarCode(ware.getBeBarCode());

				this.wareService.updateWare(oldWare, delPicIds, onlineUser.getDatabase());
				json.put("state",true);
				json.put("msg", "修改商品信息成功");
				this.sendJsonResponse(response, json.toString());
			}
		} catch (Exception e) {
			e.printStackTrace();
			log.error("新增或许修改商品信息错误", e);
			this.sendWarm(response, "新增或许修改商品信息错误");
		}
	}


	/**
	 * 查询单个类商品
	 * @param response
	 * @param request
	 * @param token
	 * @param wareId
	 */
	@RequestMapping("queryWareWeb")
	public void queryWareWeb(HttpServletResponse response,HttpServletRequest request,String token,Integer wareId){
		try{
			if(!checkParam(response, token,wareId)){
				return;
			}
			OnlineMessage message = TokenServer.tokenCheck(token);
			if(message.isSuccess()==false){
				sendWarm(response, message.getMessage());
				return;
			}
			OnlineUser onlineUser = message.getOnlineMember();
			SysWare sysWare  = this.wareService.queryWareById(wareId, onlineUser.getDatabase());
			JSONObject json = new JSONObject();
			if(!StrUtil.isNull(sysWare)){
				json.put("state",true);
				json.put("sysWare",new JSONObject(sysWare));
			}else{
				json.put("state",false);
				json.put("msg", "暂无记录");
			}
			this.sendJsonResponse(response, json.toString());
		} catch (Exception e) {
			this.sendWarm(response, "获取商品照片信息失败");
		}
	}

	/**
	 * 获取所有商品信息列表
	 * @param response
	 * @param request
	 * @param token
	 */
	@RequestMapping("queryCompanyStockWareList")
	public void queryCompanyStockWareList(HttpServletResponse response, HttpServletRequest request,String token){
		try{
			if(!checkParam(response, token)){
				return;
			}
			OnlineMessage message = TokenServer.tokenCheck(token);
			if(message.isSuccess()==false){
				sendWarm(response, message.getMessage());
				return;
			}
			OnlineUser onlineUser = message.getOnlineMember();
			JSONObject json = new JSONObject();
			List<SysWare> list = this.sysWaresService.queryCompanyStockWareList(null,onlineUser.getDatabase());
			json.put("msg", "获取所有商品列表");
			json.put("list",list);
			this.sendJsonResponse(response, json.toString());
		} catch (Exception e) {
			e.printStackTrace();
			this.sendWarm(response, "获取所有商品列表失败");
		}
	}

}
