package com.qweib.cloud.biz.system.controller.ws;

import com.qweib.cloud.biz.system.BaseWebService;
import com.qweib.cloud.biz.system.TokenServer;
import com.qweib.cloud.biz.system.service.plat.SysCompanyRoleService;
import com.qweib.cloud.biz.system.service.ws.SysWebNoticeService;
import com.qweib.cloud.biz.system.utils.RoleUtils;
import com.qweib.cloud.core.domain.OnlineMessage;
import com.qweib.cloud.core.domain.OnlineUser;
import com.qweib.cloud.core.domain.SysNotice;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;

/**
 * 公告数据操作
 *
 * @author guojp
 */
@Controller
@RequestMapping("/web")
public class NoticeWebControl extends BaseWebService {
    @Resource
    private SysWebNoticeService sysWebNoticeService;
    @Resource
    private SysCompanyRoleService companyRoleService;

    @RequestMapping("testApi1")
    public void testApi1(HttpServletResponse response, String token)
    {
        try
        {
            JSONObject json = new JSONObject();
            json.put("state",true);
            sendJsonResponse(response, json.toString());

        }
        catch (Exception e)
        {

        }
    }

    /**
     * 查询系统公告(分页)
     *
     * @param response
     * @param token    令牌(必选项)
     * @param pageNo   当前的页数(必选项，默认第1页)
     * @param pageSize 每页的记录条数(必选项,默认10条)
     */
    @RequestMapping("noticelists")
    public void noticeList(HttpServletResponse response, String token, Integer pageNo, Integer pageSize) {
        if (!checkParam(response, token)) {
            return;
        }

        if (null == pageSize) {
            pageSize = 10;
        }
        if (null == pageNo) {
            pageNo = 1;
        }
        try {
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            OnlineUser onlineUser = message.getOnlineMember();
            final boolean hasAdmin = RoleUtils.hasCompanyAdmin(onlineUser.getUsrRoleIds(), companyRoleService, onlineUser.getDatabase());
            Page page = this.sysWebNoticeService.page(onlineUser.getFdCompanyId(), onlineUser.getMemId().toString(), hasAdmin, pageNo - 1, pageSize);
            if (page.getTotal() == 0) {
                sendSuccess(response, "暂时没有系统公告");
                return;
            }
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "查询成功");
            json.put("rows", page.getRows());
            json.put("pageNo", page.getCurPage());
            json.put("pageSize", page.getPageSize());
            json.put("totalCount", page.getTotal());
            boolean b = false;
            if(page.getTotalPage()>page.getCurPage())b = true;
            json.put("hasNext", b);
            sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            sendException(response, e);
        }
    }

    /**
     * 购划算(分页)
     *
     * @param response
     * @param token    令牌(必选项)
     * @param pageNo   当前的页数(必选项，默认第1页)
     * @param pageSize 每页的记录条数(必选项,默认10条)
     */
    /*@RequestMapping("ghslists")
    public void ghslists(HttpServletResponse response, Integer pageNo, Integer pageSize) {
        if (null == pageSize) {
            pageSize = 10;
        }
        if (null == pageNo) {
            pageNo = 1;
        }
        try {
            Page page = this.sysWebNoticeService.page(null, pageNo, pageSize, null, "4");
            if (page.getTotal() == 0) {
                sendSuccess(response, "暂时没有购开心公告");
                return;
            }
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "查询成功");
            json.put("rows", page.getRows());
            json.put("pageNo", page.getCurPage());
            json.put("pageSize", page.getPageSize());
            json.put("totalCount", page.getTotal());
            json.put("hasNext", page.getTotalPage() <= page.getCurPage() ? false : true);
            sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            sendException(response, e);
        }
    }*/
    /**
     * 查询系统公告详情
     * @param response
     * @param token    令牌(必选项)
     * @param noticeId    公告的id(必选项)
     */
	/*@RequestMapping("noticedetails")
	public void noticeDetail(HttpServletResponse response,String token,Integer noticeId){
		if (!checkParam(response,noticeId,token))
			return;
		try{
			OnlineMessage message = TokenServer.tokenCheck(token);
			if(message.isSuccess()==false){
				sendWarm(response, message.getMessage());
				return;
			}
			OnlineUser onlineUser = message.getOnlineMember();
			SysNotice notice = this.sysWebNoticeService.queryNoticeById(noticeId,onlineUser.getDatabase());
			if(null == notice){
				sendWarm(response, "此公告已删除");
				return;
			}
			sendSuccess(response, "查询成功");
		}catch (Exception e) {
			sendException(response, e);
		}	
	}*/

    /**
     * 跳转到系统公告详情页面
     *
     * @param model
     * @param token
     * @param noticeId
     * @param tp       12 企业公告 13 系统公告
     * @return
     */
    @RequestMapping("noticedetailpage")
    public String noticeDetailPage(Model model, String token, Integer noticeId, String tp) {
        if (StrUtil.isNull(token) || null == noticeId || null == tp) {
            model.addAttribute("state", false);
            model.addAttribute("msg", "参数不完整");
            return "publicplat/notice/phonedetail";
        }

        OnlineMessage message = TokenServer.tokenCheck(token);
        if (!message.isSuccess()) {
            model.addAttribute("state", false);
            model.addAttribute("msg", "请先登录系统!");
            return "publicplat/notice/phonedetail";
        }

        try {
            OnlineUser onlineUser = message.getOnlineMember();
            SysNotice notice = new SysNotice();
            if ("12".equals(tp)) {//企业公告
                if (null == onlineUser.getDatabase() || "".equals(onlineUser.getDatabase())) {
                    model.addAttribute("state", false);
                    model.addAttribute("msg", "您已不在该公司下，不能查看该公司公告！");
                    return "publicplat/notice/phonedetail";
                } else {
                    notice = this.sysWebNoticeService.queryNoticeById(noticeId, onlineUser.getDatabase());
                }
            } else if ("13".equals(tp) || "29".equals(tp)) {
                notice = this.sysWebNoticeService.queryNoticeById(noticeId, null);
            }
            if (null == notice) {
                model.addAttribute("state", false);
                model.addAttribute("msg", "此公告已删除");
                return "publicplat/notice/phonedetail";
            }
            model.addAttribute("state", true);
            model.addAttribute("msg", "查询成功!");
            model.addAttribute("notice", notice);
            return "publicplat/notice/phonedetail";
        } catch (Exception e) {
            model.addAttribute("state", false);
            model.addAttribute("msg", "操作出现异常(详细：" + e.getMessage() + ")");
            this.log.error("操作出现异常", e);
            return "publicplat/notice/phonedetail";
        }
    }

}
