package com.qweib.cloud.biz.system.controller.plat;

import com.qweib.cloud.biz.common.GeneralControl;
import com.qweib.cloud.biz.system.service.plat.BscKnowledgePcService;
import com.qweib.cloud.biz.system.service.plat.SysTaskAttachmentService;
import com.qweib.cloud.biz.system.service.ws.BscEmpGroupWebService;
import com.qweib.cloud.biz.system.service.ws.BscKnowledgeService;
import com.qweib.cloud.core.domain.*;

import com.qweib.cloud.utils.DateTimeUtil;
import com.qweib.cloud.utils.Page;
import org.apache.commons.fileupload.util.Streams;
import org.json.JSONObject;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.util.Date;
import java.util.List;

@Controller
@RequestMapping("manager")
public class BscKnowledgePcControl extends GeneralControl {
	@Resource
	private BscKnowledgePcService knowledgePcService;
	@Resource
	private BscEmpGroupWebService empGroupWebService;
	@Resource
	private BscKnowledgeService knowledgeService;
	@Resource
	private SysTaskAttachmentService sysTaskAttachmentService;

	@RequestMapping("knowledgemng")
	public String knowledgemng(){
		return "/companyPlat/knowledge/knowledge";
	}
	/**
	 * 查询知识库分类树
	  *@see
	  *@param request
	  *@param response
	  *@创建：作者:YYP		创建时间：Aug 24, 2015
	 */
	@RequestMapping("knowledges")
	public void knowledges(HttpServletRequest request, HttpServletResponse response, Integer id){
		SysLoginInfo info = getLoginInfo(request);
		StringBuilder str = new StringBuilder();
		try {
			if(null==id){//查询知识库
				List<BscEmpgroup> knowledges = this.knowledgePcService.queryKnowledges(info);
				if(null!=knowledges && knowledges.size()>0){
					str.append("[");
					String sp="";
					for (BscEmpgroup empgroup : knowledges) {
						Integer groupId = empgroup.getGroupId();
						String groupNm = empgroup.getGroupNm()+"知识库";
//						String leaf = "1";
						String state = "closed";
						String tp="1";
//						if("0".equals(leaf)){
//							state = "closed";
//						}
						str.append(sp).append("{\"id\":").append(groupId).append(",\"text\":\"")
						.append(groupNm).append("\",\"state\":\"").append(state).append("\",\"attributes\":\"").append(tp).append("\"}");
						sp=",";
					}
					str.append("]");
				}
			}else{//查询知识库下的分类
				List<BscSort> sortList = knowledgePcService.querySortList(id,info.getDatasource());
				if(null!=sortList && sortList.size()>0){
					str.append("[");
					String sp="";
					for (BscSort sort : sortList) {
						Integer sortId = sort.getSortId();
						String sortNm = sort.getSortNm();
//						String leaf = "1";
						String state = "open";
						String tp="2";
//						if("0".equals(leaf)){
//							state = "closed";
//						}
						str.append(sp).append("{\"id\":").append(sortId).append(",\"text\":\"")
						.append(sortNm).append("\",\"state\":\"").append(state).append("\",\"attributes\":\"").append(tp).append("\"}");
						sp=",";
					}
					str.append("]");
				}
			}
			this.sendHtmlResponse(response, str.toString());
		} catch (Exception e) {
			log.error("查询知识库分类树出错：", e);
		}
	}
	/**
	  *@see 到分类页面
	  *@param id
	  *@param model
	  *@return
	  *@创建：作者:YYP		创建时间：Aug 25, 2015
	 */
	@RequestMapping("querySortPage")
	public String  querySortPage(Integer id, Model model, HttpServletRequest request){
		SysLoginInfo info = getLoginInfo(request);
		if(null==id){//查询第一个知识库
			BscEmpgroup group =  knowledgePcService.queryFirstGroup(info.getIdKey(),info.getDatasource());//查询第一个员工圈信息
			id=group.getGroupId();
		}
		BscEmpGroupMember gmem = empGroupWebService.queryGroupMem(info.getIdKey(), id, info.getDatasource());//查询员工圈成员信息
		if(null!=gmem){
			model.addAttribute("usrRole", gmem.getRole());//保存session
		}else{
			model.addAttribute("usrRole", "3");//保存session
		}
		model.addAttribute("groupId", id);
		return "/companyPlat/knowledge/sortPage";
	}
	/**
	  *@see 分页查询分类
	  *@创建：作者:YYP		创建时间：Aug 24, 2015
	 */
	@RequestMapping("sortPage")
	public void sortPage(HttpServletRequest request, HttpServletResponse response, Integer groupId, Integer page, Integer rows, String sortNm){
		try{
			SysLoginInfo info = getLoginInfo(request);
			Integer memId = info.getIdKey();
			String datasource = info.getDatasource();
			Page p = knowledgePcService.querysortForPage(groupId,memId,sortNm,datasource,page,rows);
//			BscEmpGroupMember gmem = empGroupWebService.queryGroupMem(memId, groupId, datasource);//查询员工圈成员信息
//			if(null!=gmem.getRole()){
//				request.getSession().setAttribute("usrRole", gmem.getRole());//保存session
//			}else{
//				request.getSession().setAttribute("usrRole", "3");//保存session
//			}
			JSONObject json = new JSONObject();
			json.put("total",p.getTotal());
			json.put("rows",p.getRows());
			sendJsonResponse(response, json.toString());
		}catch (Exception e) {
			log.error("分页查询分类出错：", e);
		}
	}
	/**
	  *@see 到知识点页面
	  *@param id
	  *@param model
	  *@return
	  *@创建：作者:YYP		创建时间：Aug 25, 2015
	 */
	@RequestMapping("toKnowledgePage")
	public String toKnowledgePage(HttpServletRequest request, Integer id, Model model){
		SysLoginInfo info = getLoginInfo(request);
		BscEmpGroupMember gmem = empGroupWebService.queryGroupBySortid(info.getIdKey(),id, info.getDatasource());//查询员工圈成员信息
		if(null!=gmem){
			model.addAttribute("usrRole", gmem.getRole());//保存session
		}else{
			model.addAttribute("usrRole", "3");//保存session
		}
		model.addAttribute("sortId",id);
		return "/companyPlat/knowledge/knowPointPage";
	}
	/**
	  *@see 分页查询知识点
	  *@param request
	  *@param response
	  *@param sortId
	  *@param page
	  *@param rows
	  *@param topicTitle
	  *@创建：作者:YYP		创建时间：Aug 25, 2015
	 */
	@RequestMapping("pointPage")
	public void pointPage(HttpServletRequest request, HttpServletResponse response, Integer sortId, Integer page, Integer rows, String topicTitle){
		try{
			SysLoginInfo info = getLoginInfo(request);
			Page p = knowledgePcService.queryPointForPage(sortId,topicTitle,info.getDatasource(),page,rows);
			JSONObject json = new JSONObject();
			json.put("total",p.getTotal());
			json.put("rows",p.getRows());
			sendJsonResponse(response, json.toString());
		}catch (Exception e) {
			log.error("分页查询知识点出错：", e);
		}
	}
	/**
	  *@see 查询知识点详情
	  *@param request
	  *@param response
	  *@param knowledgeId
	  *@创建：作者:YYP		创建时间：Aug 25, 2015
	 */
	@RequestMapping("queryKnowledgeDetail")
	public String queryKnowledgeDetail(HttpServletRequest request, HttpServletResponse response, Model model, Integer knowledgeId){
		try{
			SysLoginInfo info = getLoginInfo(request);
			BscKnowledgeFactoryDTO knowledge = knowledgeService.queryKnowledgeDetail(knowledgeId,info.getDatasource());
			model.addAttribute("knowledge", knowledge);
		}catch (Exception e) {
			log.error("分页查询知识点出错：", e);
		}
		return "/companyPlat/knowledge/knowledgeDetail";
	}
	/**
	  *@see 添加知识库分类
	  *@param request
	  *@param response
	  *@param sortNm
	  *@创建：作者:YYP		创建时间：Aug 26, 2015
	 */
	@RequestMapping("addSort")
	public void addSort(HttpServletRequest request, HttpServletResponse response, String sortNm, Integer groupId){
		try{
			SysLoginInfo info = getLoginInfo(request);
			String datasource = info.getDatasource();
			Integer isExist = knowledgeService.querySortNmAppear(sortNm,null,groupId,datasource);
			if(isExist>0){
				sendHtmlResponse(response, "-2");
				return;
			}
			BscSort sort = new BscSort();
			sort.setGroupId(groupId);
			sort.setSortNm(sortNm);
			sort.setCreateTime(DateTimeUtil.getDateToStr(new Date(),"yyyy-MM-dd HH:mm:ss"));
			sort.setMemberId(info.getIdKey());
			knowledgeService.addSort(sort,datasource);
			sendHtmlResponse(response, "1");
		}catch (Exception e) {
			log.error("添加知识库分类出错：", e);
			sendHtmlResponse(response, "-1");
			return;
		}
	}
	/**
	  *@see 批量删除分类
	  *@param request
	  *@param response
	  *@param ids
	  *@创建：作者:YYP		创建时间：Aug 26, 2015
	 */
	@RequestMapping("delSort")
	public void delSort(HttpServletRequest request, HttpServletResponse response, String ids){
		try{
			SysLoginInfo info = getLoginInfo(request);
			knowledgePcService.deleteSorts(ids,info.getDatasource());
			sendHtmlResponse(response, "1");
			return;
		}catch (Exception e) {
			log.error("添加知识库分类出错：", e);
			sendHtmlResponse(response, "-1");
			return;
		}
	}
	/**
	  *@see 批量删除知识点
	  *@param request
	  *@param response
	  *@param ids
	  *@创建：作者:YYP		创建时间：Aug 26, 2015
	 */
	@RequestMapping("delknowledge")
	public void delknowledge(HttpServletRequest request, HttpServletResponse response, String ids){
		try{
			SysLoginInfo info = getLoginInfo(request);
			knowledgePcService.deleteknowledges(ids,info.getDatasource());
			sendHtmlResponse(response, "1");
			return;
		}catch (Exception e) {
			log.error("删除知识点出错：", e);
			sendHtmlResponse(response, "-1");
			return;
		}
	}
	/**
	  *@see 添加知识点
	  *@param request
	  *@param response
	  *@param knowledge
	  *@创建：作者:YYP		创建时间：Aug 27, 2015
	 */
	@RequestMapping("addPoint")
	public void addPoint(HttpServletRequest request, HttpServletResponse response, BscKnowledge knowledge, String attTempId){
		try{
			SysLoginInfo info = getLoginInfo(request);
			knowledge.setTopicTime(DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd HH:mm:ss"));
			knowledge.setMemberId(info.getIdKey());
			String datasource = info.getDatasource();
			if("2".equals(knowledge.getTp())){
				Document doc = null;
				String url = knowledge.getTopiContent();
				try{
					doc=Jsoup.connect(url+"/")
					.data("jquery", "java")
					.userAgent("Mozilla")
					.cookie("auth", "token")
					.timeout(50000)
					.get();
				}catch (Exception e) {
					try{//如果网址解析错误，加“/”再次解析
						doc=Jsoup.connect(url+"/")
						.data("jquery", "java")
						.userAgent("Mozilla")
						.cookie("auth", "token")
						.timeout(50000)
						.get();
					}catch (Exception ex) {
						try{//网站的bug,跳过该问题
							doc=Jsoup.connect(url).header("User-Agent","Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/40.0.2214.111 Safari/537.36").get();
						}catch (IOException ioex) {
							sendHtmlResponse(response, "-2");
							return;
						}
					}
				}
				String title = doc.title();
				if("".equals(title.trim())){
					title="详情";
				}
				knowledge.setTopicTitle(title);
				knowledgeService.addOutKnowledge(knowledge,datasource);
			}else if("3".equals(knowledge.getTp())){
				Integer kId = knowledgeService.addOutKnowledge(knowledge,datasource);
				sysTaskAttachmentService.updateAttForRefId(attTempId,kId,datasource);//更新附件对应的任务id
			}
			sendHtmlResponse(response, "1");
		}catch (Exception e) {
			log.error("添加知识点出错：", e);
			sendHtmlResponse(response, "-1");
		}
	}
	/**
	  *@see 查看文件
	  *@param request
	  *@param response
	  *@param path
	  *@param filename
	  *@创建：作者:YYP		创建时间：Sep 15, 2015
	 */
	@RequestMapping("lookFile")
	public void lookFile(HttpServletRequest request, HttpServletResponse response, String path, String name){
		URL url = null;
		try{
			//1.获取指定地址的输入流.
			StringBuffer requestURL = request.getRequestURL();
			String urlstr = requestURL.substring(0,requestURL.indexOf("/cnlife")+8)+"upload/"+path;
			try{
				url = new URL(urlstr);
			}catch (Exception e) {
				sendHtmlResponse(response, "-2");//找不到文件
				return;
			}
			InputStream in = url.openStream();
			//2.在指定文件夹下创建文件。
			String fileName = path.substring(path.lastIndexOf("/")+1,path.length());
			if(null!=fileName){
				File dir = new File("d:\\cnlife");
				if(!dir .exists()  && !dir .isDirectory()){
					dir.mkdir();
				}
				File file = new File(dir,fileName);
				//3.将下载保存到文件。
				if(!file.exists()){//文件不存在保存再打开，已存在直接打开
					FileOutputStream out = new FileOutputStream(file);

					Streams.copy(in, out, true);
				}
				Runtime.getRuntime().exec("cmd.exe /c start d:\\cnlife\\"+fileName+"");
			}else{
				sendHtmlResponse(response, "-3");//path路径不正确
			}
		}catch (Exception e) {
			log.error("查看文件失败：", e);
			sendHtmlResponse(response, "-1");
		}
	}
	
//	public static void main(String[] args) {
//		Document doc = null;
//		String url ="http://news.163.com/15/0831/02/B2AGUD1P00014AED.html";
//		try{
//			
//			doc=Jsoup.connect(url+"/")
//			.data("jquery", "java")
//			.userAgent("Mozilla")
//			.cookie("auth", "token")
//			.timeout(50000)
//			.get();
//		}catch (Exception e) {
//			try{//如果网址解析错误，加“/”再次解析
//				doc=Jsoup.connect(url+"/")
//				.data("jquery", "java")
//				.userAgent("Mozilla")
//				.cookie("auth", "token")
//				.timeout(50000)
//				.get();
//			}catch (Exception ex) {
//				try{
//					doc=Jsoup.connect(url).header("User-Agent","Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/40.0.2214.111 Safari/537.36").get();
//				}catch (IOException ioex) {
//					// TODO: handle exception
//				}
//			}
//		}
//		String title = doc.title();
//		System.out.println(title);
//	}
}
