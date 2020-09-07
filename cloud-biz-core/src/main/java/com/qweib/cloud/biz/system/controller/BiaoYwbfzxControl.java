package com.qweib.cloud.biz.system.controller;

import com.qweib.cloud.biz.system.service.BiaoYwbfzxService;
import com.qweib.cloud.biz.system.service.SysKhgxsxService;
import com.qweib.cloud.biz.system.service.ws.*;
import com.qweib.cloud.core.domain.*;

import com.qweib.cloud.biz.common.GeneralControl;
import com.qweib.cloud.utils.DateTimeUtil;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Controller
@RequestMapping("/manager")
public class BiaoYwbfzxControl extends GeneralControl{
	@Resource
	private BiaoYwbfzxService ywbfzxService;
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
	private SysKhgxsxService khgxsxService;
	
	/**
	 *说明：到业务拜访执行表主页
	 *@创建：作者:llp		创建时间：2016-7-5
	 *@修改历史：
	 *		[序号](llp	2016-7-5)<修改说明>
	 */
	@RequestMapping("/queryYwbfzx")
	public String queryYwbfzx(Model model, HttpServletRequest request, String dataTp){
		try {
			SysLoginInfo info = this.getLoginInfo(request);
			List<SysKhlevel> list=this.khgxsxService.queryKhlevells(null,info.getDatasource());
			model.addAttribute("list", list);
			model.addAttribute("qddate", DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd"));
			model.addAttribute("dataTp", dataTp);
		} catch (Exception e) {
			// TODO: handle exception
		}
		return "/uglcw/Biao/ywbfzx";
	}
	/**
	 *说明：分页查询业务拜访执行表
	 *@创建：作者:llp		创建时间：2016-7-5
	 *@修改历史：
	 *		[序号](llp	2016-7-5)<修改说明>
	 */
	@RequestMapping("/ywbfzxPage")
	public void ywbfzxPage(HttpServletRequest request, HttpServletResponse response, BiaoYwbfzx Ywbfzx, String dataTp, Integer page, Integer rows){
		try{
			SysLoginInfo info = this.getLoginInfo(request);
			if(StrUtil.isNull(Ywbfzx.getQddate())){
				Ywbfzx.setQddate(DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd"));
			}
			Page p = this.ywbfzxService.queryBiaoYwbfzx(Ywbfzx, info, dataTp, page, rows);
			List<BiaoYwbfzx> vlist=(List<BiaoYwbfzx>)p.getRows();
			for (BiaoYwbfzx biaoYwbfzx : vlist) {
				  Integer bfbz=1;
				  //签到图片数量
                  biaoYwbfzx.setQdtpNum(this.bfxgPicWebService.queryBfxgPicCount1(info.getDatasource(), biaoYwbfzx.getId(), 1));
                  //生动化图片数量
                  SysBfsdhjc bfsdhjc=this.bfsdhjcService.queryBfsdhjcOne(info.getDatasource(), biaoYwbfzx.getMid(), biaoYwbfzx.getCid(),biaoYwbfzx.getQddate());
                  if(!StrUtil.isNull(bfsdhjc)){
                     biaoYwbfzx.setSdhtpNum(this.bfxgPicWebService.queryBfxgPicCount2(info.getDatasource(), bfsdhjc.getId()));
      			     bfbz=bfbz+1;
                  }else{
                	 biaoYwbfzx.setSdhtpNum(0);
                  }
                  //陈列检查采集
                  List<SysBfcljccj> list=this.bfcljccjWebService.queryBfcljccjOne(info.getDatasource(), biaoYwbfzx.getMid(), biaoYwbfzx.getCid(),biaoYwbfzx.getQddate());
                  int count=0;
                  if(list.size()>0){
                	  for(int i=0;i<list.size();i++){
                	     count=count+this.bfxgPicWebService.queryBfxgPicCount1(info.getDatasource(), list.get(i).getId(), 4);
                	  }
                	  bfbz=bfbz+1;
                  }
                  biaoYwbfzx.setKcjctpNum(count);
                  //库存集合
                  List<SysBfxsxj> list2=this.bfxsxjWebService.queryBfxsxjOne(info.getDatasource(), biaoYwbfzx.getMid(), biaoYwbfzx.getCid(),biaoYwbfzx.getQddate());
                  if(list2.size()>0){
                	  bfbz=bfbz+1;
                  }
                  biaoYwbfzx.setList2(list2);
                  //订单集合
                  SysBforder bforder=this.bforderWebService.queryBforderOne(info.getDatasource(), biaoYwbfzx.getMid(), biaoYwbfzx.getCid(),biaoYwbfzx.getQddate());
                  List<SysBforderDetail> list1=new ArrayList<SysBforderDetail>();
                  if(!StrUtil.isNull(bforder)){
                	  list1=this.bforderWebService.queryBforderDetail(info.getDatasource(), bforder.getId());
                	  bfbz=bfbz+1;
                  }
                  //时间段
                  SysBfgzxc bfgzxc=this.bfgzxcWebService.queryBfgzxcOne(info.getDatasource(), biaoYwbfzx.getMid(), biaoYwbfzx.getCid(),biaoYwbfzx.getQddate());
                  if(!StrUtil.isNull(bfgzxc)){
                	  bfbz=bfbz+1;
                	  biaoYwbfzx.setTimed(biaoYwbfzx.getTimed()+"-"+bfgzxc.getDdtime());
                  }
                  biaoYwbfzx.setList1(list1);
                  biaoYwbfzx.setBfbz(bfbz);
            }
			JSONObject json = new JSONObject();
			json.put("total", p.getTotal());
			json.put("rows", p.getRows());
			this.sendJsonResponse(response, json.toString());
			p = null;
		}catch (Exception e) {
			log.error("分页查询业务拜访执行表出错", e);
		}
	}
	/**
	  *@说明：图片详情
	  *@创建：作者:llp		创建时间：2016-7-7
	  *@修改历史：
	  *		[序号](llp	2016-7-7)<修改说明>
	 */
	@RequestMapping("/bfcPicXq")
	public String bfcPicXq(Model model, Integer mid, Integer cid, String tp, String qddate, HttpServletRequest request){
		SysLoginInfo info = this.getLoginInfo(request);
		if(tp.equals("1")){
	        //1拜访签到拍照
			SysBfqdpz bfqdpz=this.bfqdpzWebService.queryBfqdpzOne(info.getDatasource(), mid, cid,qddate);
			List<SysBfxgPic> bfqdpzPic=null;
			if(!StrUtil.isNull(bfqdpz)){
				bfqdpzPic=this.bfxgPicWebService.queryBfxgPicls(info.getDatasource(), bfqdpz.getId(), 1,null);
			}
			model.addAttribute("bfqdpzPic", bfqdpzPic);
		}else if(tp.equals("2")){ 
			//2生动化检查
			SysBfsdhjc bfsdhjc=this.bfsdhjcService.queryBfsdhjcOne(info.getDatasource(), mid, cid,qddate);
			List<SysBfxgPic> bfsdhjcPic1=null;
			List<SysBfxgPic> bfsdhjcPic2=null;
			if(!StrUtil.isNull(bfsdhjc)){
				bfsdhjcPic1=this.bfxgPicWebService.queryBfxgPicls(info.getDatasource(), bfsdhjc.getId(), 2,null);
				bfsdhjcPic2=this.bfxgPicWebService.queryBfxgPicls(info.getDatasource(), bfsdhjc.getId(), 3,null);
			}
	        model.addAttribute("bfsdhjcPic1", bfsdhjcPic1);
			model.addAttribute("bfsdhjcPic2", bfsdhjcPic2);
		}else{
			List<SysBfcljccj> list1=this.bfcljccjWebService.queryBfcljccjOne(info.getDatasource(), mid, cid,qddate);
			List<SysBfxgPic> cljccjPic=new ArrayList<SysBfxgPic>();
			if(list1.size()>0){
		    	for(int i=0;i<list1.size();i++){
		    		List<SysBfxgPic> cljccjPic4=this.bfxgPicWebService.queryBfxgPicls(info.getDatasource(), list1.get(i).getId(), 4, null);
		    		for(int j=0;j<cljccjPic4.size();j++){
		    			SysBfxgPic BfxgPic=new SysBfxgPic();
		    			BfxgPic.setPic(cljccjPic4.get(j).getPic());
		    			BfxgPic.setPicMini(cljccjPic4.get(j).getPicMini());
		    			cljccjPic.add(BfxgPic);
					}
				}
			}
			model.addAttribute("cljccjPic", cljccjPic);
		}
		model.addAttribute("tp", tp);
	    return "/uglcw/Biao/bfcPicXq";
	}
}
