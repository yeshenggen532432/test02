package com.qweib.cloud.biz.system.controller.plat;

import com.qweib.cloud.biz.common.CnlifeConstants;
import com.qweib.cloud.biz.system.jpush.JpushClassifies;
import com.qweib.cloud.biz.system.jpush.JpushClassifies2;
import com.qweib.cloud.biz.system.service.plat.SysMemService;
import com.qweib.cloud.biz.system.service.plat.SysMenuApplyService;
import com.qweib.cloud.biz.system.service.ws.SysChatMsgService;
import com.qweib.cloud.core.domain.SysChatMsg;

import com.qweib.cloud.core.domain.SysLoginInfo;

import com.qweib.cloud.biz.common.GeneralControl;
import com.qweib.cloud.core.domain.SysMemDTO;
import com.qweib.cloud.utils.DateTimeUtil;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;


@Controller
@RequestMapping("/manager")
public class SysMenuApplyControl extends GeneralControl {
    @Resource
    private SysMenuApplyService sysMenuApplyService;
    @Resource
    private JpushClassifies jpushClassifies;
    @Resource
    private JpushClassifies2 jpushClassifies2;
    @Resource
    private SysMemService sysMemService;
    @Resource
    private SysChatMsgService sysChatMsgWebService;

    /**
     * 公司分配菜单应用
     *
     * @param deptId
     * @param menuid
     * @param response
     */
    @RequestMapping("saveCompanyMenuApply")
    public void saveCompanyMenuApply(Integer deptId, Integer[] menuid, HttpServletResponse response, HttpServletRequest request, String menuapplytp) {
        try {
            String dataSource = this.sysMenuApplyService.updateCompanyMenuApply(menuid, deptId, menuapplytp);
            SysLoginInfo info = getInfo(request);
            if (!StrUtil.isNull(deptId) && "2".equals(menuapplytp)) {//公司分配应用成功,通知移动端
                List<SysChatMsg> sys = new ArrayList<SysChatMsg>();
                StringBuffer str = new StringBuffer();
                //查询公司全部成员
                List<SysMemDTO> memList = this.sysMemService.querycMems(dataSource);
                //推送消息
                if (memList.size() > 0) {
                    for (SysMemDTO memberDTO : memList) {
                        SysChatMsg scm = new SysChatMsg();
                        scm.setAddtime(DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd HH:mm:ss"));
                        scm.setMemberId(info.getIdKey());
                        scm.setReceiveId(memberDTO.getMemberId());
                        scm.setMsg("应用菜单变更，请重新登录");
                        scm.setTp("35");
                        scm.setMsgTp("1");// 发表类型1.文字2.图片3.语音;
                        sys.add(scm);
                        str.append(memberDTO.getMemberMobile() + ",");
                    }
                    this.sysChatMsgWebService.addChatMsg(sys, null);
                    String remind = str.substring(0, str.length() - 1);
                    jpushClassifies.toJpush(remind, CnlifeConstants.MODE6, CnlifeConstants.NEWMSG, null, null, "应用菜单变更推送", "2");//不屏蔽
                    jpushClassifies2.toJpush(remind, CnlifeConstants.MODE6, CnlifeConstants.NEWMSG, null, null, "应用菜单变更推送", "2");//不屏蔽
                }
            }
            this.sendHtmlResponse(response, "2");
        } catch (Exception ex) {
            log.error("公司分配菜单应用出错:" + ex);
            this.sendHtmlResponse(response, "4");
        }
    }
}
