package com.qweib.cloud.biz.system.controller.ws;

import com.qweib.cloud.biz.system.BaseWebService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/web/")
public class BscCollectWebControl  extends BaseWebService {
	/*@Resource
	private BscCollectWebService bscCollectWebService;
	
	 *//**
	 * @说明：获取收藏列表
	 * @创建者： 作者：llp  创建时间：2015-2-27
	 * @return
	 *//*
	@RequestMapping("queryCollectPage")
	public void queryCollectPage(HttpServletResponse response,String token,Integer pageSize,Integer pageNo){
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
		    OnlineUser loginDto = message.getOnlineMember();
		    Page p=this.bscCollectWebService.queryBscCollectPage(loginDto.getDatabase(), pageNo, pageSize, loginDto.getMemId());
		    JSONObject json = new JSONObject();
			json.put("state", true);
			json.put("msg", "获取收藏列表成功");
			json.put("pageNo", pageNo);
			json.put("pageSize", pageSize);
			json.put("total", p.getTotal());
			json.put("totalPage", p.getTotalPage());
			json.put("rows", p.getRows());
			this.sendJsonResponse(response, json.toString());
		} catch (Exception e) {
			this.sendWarm(response, "获取收藏列表失败");
		}
	}
	 *//**
	 * @说明：获取收藏详情
	 * @创建者： 作者：llp  创建时间：2015-2-27
	 * @return
	 *//*
	@RequestMapping("queryBscCollect")
	public void queryBscCollect(HttpServletResponse response,String token,Integer topicId){
		try {
			if(!checkParam(response, token,topicId)){
				return;
			}
			OnlineMessage message = TokenServer.tokenCheck(token);
			if(message.isSuccess()==false){
				sendWarm(response, message.getMessage());
				return;
			}
		    OnlineUser loginDto = message.getOnlineMember();
		    BscTopicFactoryDTO bscTopicDTO=this.bscCollectWebService.queryBscCollect(loginDto.getDatabase(), topicId);
		    JSONObject json = new JSONObject();
		    json.put("state", true);
			json.put("msg", "获取收藏详情成功");
		    json.put("topicId", bscTopicDTO.getTopicId());
		    json.put("memberId", bscTopicDTO.getMemberId());
		    json.put("memberHead", bscTopicDTO.getMemberHead());
		    json.put("memberNm", bscTopicDTO.getMemberNm());
		    json.put("topicTitle", bscTopicDTO.getTopicTitle());
		    json.put("topicTime", bscTopicDTO.getTopicTime());
		    json.put("topiContent", bscTopicDTO.getTopiContent());
		    json.put("picList", bscTopicDTO.getPicList());
		    json.put("praiseList", bscTopicDTO.getPraiseList());
		    json.put("commentList", bscTopicDTO.getCommentList());
		    this.sendJsonResponse(response, json.toString());
		} catch (Exception e) {
			this.sendWarm(response, "获取收藏详情失败");
		}
	}
	*//**
	 * @说明：添加收藏
	 * @创建者： 作者：llp  创建时间：2015-2-27
	 * @return
	 *//*
	@RequestMapping("addBscCollect")
	public void addBscCollect(HttpServletResponse response,String token,Integer topicId){
		try {
			if(!checkParam(response, token,topicId)){
				return;
			}
			OnlineMessage message = TokenServer.tokenCheck(token);
			if(message.isSuccess()==false){
				sendWarm(response, message.getMessage());
				return;
			}
		    OnlineUser loginDto = message.getOnlineMember();
		    int count=this.bscCollectWebService.queryBscCollectByTpid(loginDto.getMemId(), topicId, loginDto.getDatabase());
			if(count>=1){
				JSONObject json = new JSONObject();
				json.put("state",false);
				json.put("msg", "该话题已经收藏过了");
				this.sendJsonResponse(response, json.toString());
				return;
			}else{
				BscCollect bscCollect=new BscCollect();
			    bscCollect.setTopicId(topicId);
			    bscCollect.setMemberId(loginDto.getMemId());
			    bscCollect.setCollecTime(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()));
			    this.bscCollectWebService.addBscCollect(bscCollect, loginDto.getDatabase());
			    JSONObject json = new JSONObject();
			    json.put("state",true);
				json.put("msg", "添加收藏成功");
				this.sendJsonResponse(response, json.toString());
			}
		} catch (Exception e) {
			this.sendWarm(response, "添加收藏失败");
		}
	}
	*//**
	 * @说明：删除收藏
	 * @创建者： 作者：llp  创建时间：2015-2-27
	 * @return
	 *//*
	@RequestMapping("deleteBscCollect")
	public void deleteBscCollect(HttpServletResponse response,String token,Integer topicId){
		try {
			if(!checkParam(response, token,topicId)){
				return;
			}
			OnlineMessage message = TokenServer.tokenCheck(token);
			if(message.isSuccess()==false){
				sendWarm(response, message.getMessage());
				return;
			}
		    OnlineUser loginDto = message.getOnlineMember();
		    this.bscCollectWebService.deleteBscCollect(loginDto.getMemId(), topicId, loginDto.getDatabase());
		    JSONObject json = new JSONObject();
		    json.put("state",true);
			json.put("msg", "删除收藏成功");
			this.sendJsonResponse(response, json.toString());
		} catch (Exception e) {
			this.sendWarm(response, "删除收藏失败");
		}
	}*/
}
