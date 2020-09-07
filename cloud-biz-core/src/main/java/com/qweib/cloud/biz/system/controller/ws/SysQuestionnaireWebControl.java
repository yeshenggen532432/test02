package com.qweib.cloud.biz.system.controller.ws;

import com.qweib.cloud.biz.system.BaseWebService;
import com.qweib.cloud.biz.system.TokenServer;
import com.qweib.cloud.biz.system.service.ws.SysMemWebService;
import com.qweib.cloud.biz.system.service.ws.SysQuestionnaireWebService;
import com.qweib.cloud.core.domain.*;

import com.qweib.cloud.utils.DateTimeUtil;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 *说明：问卷接口Control
 *@创建：作者:zrp		创建时间：2015-02-03
 *@修改历史：
 *		[序号](zrp	2015-02-03)<修改说明>
 */
@Controller
@RequestMapping("/web")
public class SysQuestionnaireWebControl  extends BaseWebService {

	@Resource
	private SysQuestionnaireWebService sysQuestionnaireWebService;
	@Resource
	private SysMemWebService sysMemWebService;
	
	/**
	 * 分页查询问卷
	 */
	@RequestMapping("pageQuestionnaire")
	public String queryNewQuestionnaire(HttpServletRequest request, HttpServletResponse response,
                                        String token, Integer pageNo, Model model){
		Page page = null;
		try{
			if(!StrUtil.isNull(token)){
				Cookie cookie = new Cookie("token", token);
				response.addCookie(cookie);
			}else{
				Cookie[] cookie = request.getCookies();
				for(Cookie kie : cookie){
					if(kie.getName().equals("token")){
						token = kie.getValue();
					}
				}
			}
			OnlineMessage message = TokenServer.tokenCheck(token);
			if(message.isSuccess()==true){
				OnlineUser onlineUser = message.getOnlineMember();
				String database = onlineUser.getDatabase();
				SysMember mem = this.sysMemWebService.queryMemBypid(onlineUser.getMemId(), database);
				Integer branchId = mem.getBranchId();
				List<Map<String, Object>> isVote = sysQuestionnaireWebService.queryCountByMemId(onlineUser.getMemId(),branchId,database);//判断是否全部投过票
				if(Integer.parseInt(isVote.get(0).get("tmcount").toString())<1){
					model.addAttribute("msg","暂无问卷调查");
					model.addAttribute("state",false);
					return "questionPage/wenjuan";
				}else if(0==Integer.parseInt(isVote.get(0).get("count").toString())){
					list(request, response, token, 1, model);
					return "questionPage/jieguo";
				} else{
					if(StrUtil.isNull(pageNo))pageNo=1;
					Integer pageSize = 50;
					page = this.sysQuestionnaireWebService.queryAllPage(pageNo,pageSize,database,branchId,mem.getMemberId());
					/*List<SysQuestionnaireDetail> list = null;
					if(page.getTotal()>0){
						list=this.sysQuestionnaireWebService.queryByQuestId(onlineUser.getMemId(),((SysQuestionnaire)page.getRows().get(0)).getQid(),database);
						model.addAttribute("quests",(SysQuestionnaire)page.getRows().get(0));
						int i = 0;
						for(SysQuestionnaireDetail sq : list){
							if(sq.getIsCheck()>0){
								i++;
							}
						}
						model.addAttribute("size", i);
					}*/
					model.addAttribute("pageCount", page.getTotalPage());
					model.addAttribute("list",page.getRows());
					model.addAttribute("pageNo",pageNo);
					model.addAttribute("token",token);
					return "questionPage/wenjuan";
				}
			}else{
				model.addAttribute("msg","登录异常");
				model.addAttribute("state",false);
				return "questionPage/wenjuan";
			}
		}catch (Exception e) {
			e.printStackTrace();
			log.error("查询失败：", e);
		}
		return "";
	}
	//结果列表
	@RequestMapping("listQuestionnaire")
	public String list(HttpServletRequest request, HttpServletResponse response,
                       String token, Integer pageNo, Model model){
		try{
			/*Cookie[] cookie = request.getCookies();
			for(Cookie kie : cookie){
				if(kie.getName().equals("token")){
					token = kie.getValue();
				}
			}*/
			if(StrUtil.isNull(token)){
				Cookie[] cookie = request.getCookies();
				for(Cookie kie : cookie){
					if(kie.getName().equals("token")){
						token = kie.getValue();
					}
				}
			}
			OnlineMessage message = TokenServer.tokenCheck(token);
			if(message.isSuccess()==true){
				OnlineUser onlineUser = message.getOnlineMember();
				String database = onlineUser.getDatabase();
				if(StrUtil.isNull(pageNo))pageNo=1;
				Integer pageSize = 50;
				SysMember mem = this.sysMemWebService.queryMemBypid(onlineUser.getMemId(), database);
				Page page = this.sysQuestionnaireWebService.queryResultList(pageNo,pageSize,database,mem.getBranchId(),mem.getMemberId());
				model.addAttribute("pageCount", page.getTotalPage());
				model.addAttribute("rows", page.getRows());
				model.addAttribute("pageNo",pageNo);
				model.addAttribute("token",token);
			}
			return "questionPage/jieguo";
		}catch (Exception e) {
			e.printStackTrace();
			log.error("查询失败：", e);
		}
		return "";
	}
	/**
	 * 添加
	 */
	@RequestMapping("addvote")
	public String addVote(HttpServletRequest request, HttpServletResponse response, String token, String ids,
                          Integer problemId, Integer dsck, ArrayVote voteList, Model model){
		List<SysQuestionnaireVote> questionVotes = new ArrayList<SysQuestionnaireVote>();
		try{
			if(StrUtil.isNull(token)){
				Cookie[] cookie = request.getCookies();
				for(Cookie kie : cookie){
					if(kie.getName().equals("token")){
						token = kie.getValue();
					}
				}
			}
			OnlineMessage message = TokenServer.tokenCheck(token);
			if(message.isSuccess()==true){
				OnlineUser onlineUser = message.getOnlineMember();
				String database = onlineUser.getDatabase();
				List<SysQuestionnaireVote> votes = voteList.getVoteList();
				String addTime = DateTimeUtil.getDateToStr(new Date(),"yyyy-MM-dd HH:mm:ss");
				for(int i=1;i<votes.size();i++){
					SysQuestionnaireVote vote = votes.get(i);
					Integer promblemId = vote.getProblemId();
					String str = vote.getIds().substring(0,vote.getIds().length()-1);
					String[] optionIds = str.split(",");
					for (String optionId : optionIds) {
						SysQuestionnaireVote v = new SysQuestionnaireVote();
						v.setProblemId(promblemId);
						v.setMemberId(onlineUser.getMemId());
						v.setOptionId(Integer.parseInt(optionId));
						v.setAddTime(addTime);
						questionVotes.add(v);
					}
				}
				this.sysQuestionnaireWebService.addVote(database, questionVotes);
				/*if(ids.length()>0){
					String [] id=ids.split(",");
					if(dsck==1){
						this.sysQuestionnaireWebService.deleteByQid(database,problemId,onlineUser.getMemId());
						for(String str : id){
							vote.setOptionId(Integer.valueOf(str));
							this.sysQuestionnaireWebService.addVote(database, vote);
						}
					}else{
						for(String str : id){
							vote.setOptionId(Integer.valueOf(str));
							this.sysQuestionnaireWebService.addVote(database, vote);
						}
					}
				}*/
//				this.sendHtmlResponse(response, "1");
				list(request, response, token, 1, model);
			}
			return "questionPage/jieguo";
		}catch (Exception e) {
			log.error("查询失败：", e);
			this.sendHtmlResponse(response, "-1");
			return null;
		}
	}
	/**
	 * 删除
	 */
	@RequestMapping("delvote")
	public void delVote(HttpServletRequest request, HttpServletResponse response, String token, Integer id,
                        Integer problemId, Integer dsck){
		try{
			if(StrUtil.isNull(token)){
				Cookie[] cookie = request.getCookies();
				for(Cookie kie : cookie){
					if(kie.getName().equals("token")){
						token = kie.getValue();
					}
				}
			}
			OnlineMessage message = TokenServer.tokenCheck(token);
			if(message.isSuccess()==true){
				OnlineUser onlineUser = message.getOnlineMember();
				String database = onlineUser.getDatabase();
				
				this.sysQuestionnaireWebService.deleteById(database,problemId,onlineUser.getMemId(),id);
				this.sendHtmlResponse(response, "1");
			}
		}catch (Exception e) {
			log.error("删除失败：", e);
			this.sendHtmlResponse(response, "-1");
		}
	}
	/**
	 * 查询投票结果
	 */
	@RequestMapping("toqueryratio")
	public String toqueryratio(HttpServletRequest request, HttpServletResponse response, String token, Integer problemId
			, Model model){
		try{
			if(StrUtil.isNull(token)){
				Cookie[] cookie = request.getCookies();
				for(Cookie kie : cookie){
					if(kie.getName().equals("token")){
						token = kie.getValue();
					}
				}
			}
			OnlineMessage message = TokenServer.tokenCheck(token);
			if(message.isSuccess()==true){
				OnlineUser onlineUser = message.getOnlineMember();
				String database = onlineUser.getDatabase();
				//查询当前登陆人的答案
				Map<String,Object> map = this.sysQuestionnaireWebService.queryCheckAll(database,onlineUser.getMemId(),problemId);
				//查询比率
				List<SysQuestionnaireDetail> ratios = this.sysQuestionnaireWebService.queryByRatio(problemId,database);
				String str = map.get("no").toString();
				String[]  strArray = str.split(",");
				model.addAttribute("strArray", strArray);
				model.addAttribute("ratios", ratios);
				model.addAttribute("state",true);
				return "questionPage/xuanze";
			}else{
				model.addAttribute("state",false);
				model.addAttribute("msg","登录异常");
				return "questionPage/xuanze";
			}
		}catch (Exception e) {
			log.error("查询投票结果失败：", e);
		}
		model.addAttribute("state",false);
		model.addAttribute("msg","查询失败");
		return "questionPage/xuanze";
	}
	
}
