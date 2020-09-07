package com.qweib.cloud.biz.system.controller.plat;


import com.qweib.cloud.biz.system.BaseWebService;
import com.qweib.cloud.biz.system.TokenServer;
import com.qweib.cloud.biz.system.service.plat.GroupGoodsService;
import com.qweib.cloud.core.domain.GroupGoods;
import com.qweib.cloud.core.domain.GroupGoodsDetail;
import com.qweib.cloud.core.domain.OnlineMessage;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;
import java.util.List;


@Controller
@RequestMapping("/web/")
public class GroupGoodsSjControl  extends BaseWebService {
	@Resource
	private GroupGoodsService groupGoodsService;
	
	 /**
	 * @说明：获取购划算列表
	 * @创建者： 作者：llp  创建时间：2015-2-28
	 * @return
	 */
	@RequestMapping("/querygroupgoodssj")
	public void queryGroupGoods(HttpServletResponse response, String token, Integer pageSize, Integer pageNo, String tp){
		try {
			if(!checkParam(response, token,pageNo)){
				return;
			}
			if(StrUtil.isNull(pageSize)){
				pageSize=10;
			}
			OnlineMessage message = TokenServer.tokenCheck(token);
			if(message.isSuccess()==false){
				sendWarm(response, message.getMessage());
				return;
			}
			Page p = this.groupGoodsService.queryGroupGoodssj(tp, pageNo, pageSize);
			List<GroupGoods> gpls=p.getRows();
			for(int i=0;i<gpls.size();i++){
				gpls.get(i).setPic("groupgoods/"+gpls.get(i).getPic());
		    }
			p.setRows(gpls);
			JSONObject json = new JSONObject();
			json.put("state", true);
			json.put("msg", "获取购划算列表成功");
			json.put("pageNo", pageNo);
			json.put("pageSize", pageSize);
			json.put("total", p.getTotal());
			json.put("totalPage", p.getTotalPage());
			json.put("rows", p.getRows());
			this.sendJsonResponse(response, json.toString());
		} catch (Exception e) {
			this.sendWarm(response, "获取够购算列表失败");
		}
	}
	/**
	 * @说明：获取购划算详情
	 * @创建者： 作者：llp  创建时间：2015-2-28
	 * @return
	 */
	@RequestMapping("groupgoodssjxq")
	public void groupgoodsxq(HttpServletResponse response, String token, Integer Id){
		try {
			if(!checkParam(response, token,Id)){
				return;
			}
			OnlineMessage message = TokenServer.tokenCheck(token);
			if(message.isSuccess()==false){
				sendWarm(response, message.getMessage());
				return;
			}
			GroupGoods groupgoods=this.groupGoodsService.queryGroupGoodsById(Id);
		    List<GroupGoodsDetail> details=this.groupGoodsService.queryGroupGoodsDetail(Id);
		    for(int i=0;i<details.size();i++){
		    	details.get(i).setPic("groupgoodsdetail/"+details.get(i).getPic());
		    }
		    JSONObject json = new JSONObject();
			json.put("state", true);
			json.put("msg", "获取购划算详情成功");
			json.put("gname", groupgoods.getGname());
			json.put("yprice", groupgoods.getYprice());
			json.put("xprice", groupgoods.getXprice());
			json.put("url", groupgoods.getUrl());
			json.put("remark", groupgoods.getRemark());
			json.put("details", details);
			this.sendJsonResponse(response, json.toString());
		} catch (Exception e) {
			this.sendWarm(response, "获取购划算详情失败");
		}
		
    }
	
}
