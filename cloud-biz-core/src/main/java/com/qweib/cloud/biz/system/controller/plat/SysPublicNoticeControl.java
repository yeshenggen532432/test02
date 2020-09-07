package com.qweib.cloud.biz.system.controller.plat;

import com.qweib.cloud.biz.common.CnlifeConstants;
import com.qweib.cloud.biz.common.GeneralControl;
import com.qweib.cloud.biz.system.jpush.JpushClassifies;
import com.qweib.cloud.biz.system.jpush.JpushClassifies2;
import com.qweib.cloud.biz.system.service.plat.SysMemService;
import com.qweib.cloud.biz.system.service.plat.SysMemberService;
import com.qweib.cloud.biz.system.service.plat.SysPublicNoticeService;
import com.qweib.cloud.biz.system.service.ws.SysChatMsgService;
import com.qweib.cloud.core.domain.SysChatMsg;
import com.qweib.cloud.core.domain.SysLoginInfo;
import com.qweib.cloud.core.domain.SysMemDTO;
import com.qweib.cloud.core.domain.SysNotice;
import com.qweib.cloud.utils.*;
import org.json.JSONObject;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * 公共平台公告系统
 *
 * @author guojp
 */
//@Controller
//@RequestMapping("/manager")
public class SysPublicNoticeControl extends GeneralControl {
    @Resource
    private SysPublicNoticeService sysPublicNoticeService;
    @Resource
    private SysMemberService sysMemberService;
    @Resource
    private SysMemService sysMemService;
    @Resource
    private SysChatMsgService sysChatMsgWebService;
    @Resource
    private JpushClassifies jpushClassifies;
    @Resource
    private JpushClassifies2 jpushClassifies2;

    StringBuffer result = new StringBuffer();

    /**
     * 公告页面
     */
    @RequestMapping("tonotice")
    public String tonotice(HttpServletRequest request, HttpServletResponse response, Model model) {
		/*SysLoginInfo info = getInfo(request);
		List<SysMember> mem = null;
		if(null==info.getDatasource() || "".equals(info.getDatasource())){
			mem = this.sysMemberService.mName();
		}else{
			mem =this.sysMemService.mName(info.getDatasource());
		}
		model.addAttribute("mem", mem);*/
        return "/publicplat/notice/notice";
    }

    /**
     * 公告分页查询
     */
    @RequestMapping("pnoticePage")
    public void page(HttpServletRequest request, HttpServletResponse response, SysNotice notice, Integer page, Integer rows) {
        try {
            SysLoginInfo info = getInfo(request);
            Page p = this.sysPublicNoticeService.page(notice, page, rows, info);
            JSONObject json = new JSONObject();
            json.put("total", p.getTotal());
            json.put("rows", p.getRows());
            this.sendJsonResponse(response, json.toString());
            p = null;
        } catch (Exception e) {
            log.error("公告数据查询出错:", e);
        }
    }

    /**
     * 到(添加/修改)页面
     */
    @RequestMapping("ptoOperNotice")
    public String toOperNotice(HttpServletRequest request, HttpServletResponse response, Model model, Integer id) {
        if (!StrUtil.isNull(id)) {
            SysNotice notice = this.sysPublicNoticeService.queryNoticeById(id);
            model.addAttribute("notice", notice);
        }
        SysLoginInfo info = getInfo(request);
        model.addAttribute("isAdmin", info.getIdKey());
        return "/publicplat/notice/noticeoper";
    }

    /**
     * 添加、修改
     */
    @RequestMapping("poperNotice")
    public void operNotice(SysNotice notice, HttpServletResponse response, HttpServletRequest request, String ists, String oldpic) {
        String belongMsg = null;
        String path = request.getSession().getServletContext().getRealPath("/upload");//照片路径
        String folderPath = path + "/publicplat/notice";//文件目录
        try {
            SysLoginInfo info = getInfo(request);
            String noticePic = notice.getNoticePic();
            if (StrUtil.isNull(notice.getNoticeId())) {//添加
                notice.setMemberId(info.getIdKey());
                notice.setNoticeTime(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()));
                notice.setIsPush(ists);//是否推送1：是2：否
                String noticeContent = notice.getNoticeContent();
                if (noticeContent.contains("<img ")) {//包含图片
                    stringNumbers(noticeContent, 0); //在图片的额样式后面添加样式
                    notice.setNoticeContent(result.toString());
                }
                if (!"".equals(info.getDatasource()) || null == info.getDatasource()) {//企业平台上
                    notice.setNoticeTp("2");//通知类型 1系统公告 2企业公告3园区公告 4 购划算
                    notice.setDatasource(info.getDatasource());
                }
                //移动图片
                if (!StrUtil.isNull(noticePic)) {
                    StrUtil.renameFile(path + "/temp", noticePic, folderPath, noticePic);
                }
                Integer id = this.sysPublicNoticeService.addNotice(notice);
                if ("1".equals(ists)) {//推送
                    List<SysMemDTO> memList = sysMemberService.querypMems();
                    List<SysChatMsg> sys = new ArrayList<SysChatMsg>();
                    StringBuffer str = new StringBuffer();
                    String tp = null;
                    if ("".equals(info.getDatasource()) || null == info.getDatasource()) {//查询系统全部成员
                        memList = sysMemberService.querypMems();
                        if ("1".equals(notice.getNoticeTp())) {
                            tp = "13";
                            belongMsg = "系统公告";
                        } else if ("4".equals(notice.getNoticeTp())) {
                            tp = "29";
                            belongMsg = "购开心公告";
                        }
                    } else {//查询公司成员
                        memList = this.sysMemService.querycMems(info.getDatasource());
                        tp = "12";
                        belongMsg = "企业公告";
                    }
                    if (memList.size() > 0) {
                        for (SysMemDTO memberDTO : memList) {
                            if (!memberDTO.getMemberMobile().equals(info.getUsrNo())) {
                                SysChatMsg scm = new SysChatMsg();
                                scm.setAddtime(DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd HH:mm:ss"));
                                scm.setMemberId(info.getIdKey());
                                scm.setReceiveId(memberDTO.getMemberId());
                                scm.setMsg(notice.getNoticeTitle());
                                scm.setTp(tp);
                                scm.setBelongId(id);//公告id
                                scm.setBelongMsg(belongMsg);
                                scm.setMsgTp("1");// 发表类型1.文字2.图片3.语音;
                                sys.add(scm);
                                str.append(memberDTO.getMemberMobile() + ",");
                            }
                        }
                        this.sysChatMsgWebService.addChatMsg(sys, null);
                        String remind = str.substring(0, str.length() - 1);
                        jpushClassifies.toJpush(remind, CnlifeConstants.MODE5, CnlifeConstants.NEWMSG, null, null, "公告推送", "2");//不屏蔽
                        jpushClassifies2.toJpush(remind, CnlifeConstants.MODE5, CnlifeConstants.NEWMSG, null, null, "公告推送", "2");//不屏蔽
                    }
                }
                this.sendHtmlResponse(response, "1");
            } else {//修改
                if (!oldpic.equals(noticePic)) {
                    StrUtil.renameFile(path + "/temp", noticePic, folderPath, noticePic);
                    File renameFile = new File(folderPath + "/" + oldpic);
                    if (renameFile.exists()) {
                        this.deletepic(new File(request.getSession().getServletContext().getRealPath("/upload/public/notice")), oldpic);
                    }
                }
                this.sysPublicNoticeService.updateNotice(notice);
                this.sendHtmlResponse(response, "2");
            }
        } catch (Exception e) {
            log.error("操作失败", e);
            this.sendHtmlResponse(response, "-1");
        }
    }

    //删除照片
    private void deletepic(File file, String photo) {
        if (file.isDirectory()) {
            File[] files = file.listFiles();
            for (File file2 : files) {
                deletepic(file2, photo);
            }
        } else {
            String name = file.getName();
            if (photo.equals(name)) {
                file.delete();
            }

        }
    }

    //在img的后面添加css样式
    public void stringNumbers(String str, int o) {
        StringBuffer b = new StringBuffer();
        StringBuffer c = new StringBuffer();
        if (str.indexOf("<img ", o) != -1) {//存在img
            int i = str.indexOf("<img ", o);//img的位置
            int j = str.indexOf("/>", i);//img结束的位置
            String info = str.substring(i, j);//截取img段代码
            int indexOf = info.indexOf("style=\"");//判断img是否有style
            if (indexOf > 0) {
                int jrPosition = str.indexOf("style=", i);
                int jStr = str.indexOf("\"", jrPosition + 1);
                b = new StringBuffer(str);
                c = b.insert(jStr, " width:100%;height:200px; ");
            } else {
                b = new StringBuffer(str);
                c = b.insert(j, " style=\"width:100%;height:200px; \"");
            }
            result = c;
            stringNumbers(c.toString(), j);
        }
    }

    /**
     * 批量删除
     */
    @RequestMapping("pdelNotice")
    public void deletenotice(HttpServletRequest request, HttpServletResponse response, Integer[] ids) {
        try {
            int[] result = this.sysPublicNoticeService.deletenotice(ids);
            this.sendHtmlResponse(response, "1");
        } catch (Exception e) {
            log.error("删除公告记录出错：", e);
            this.sendHtmlResponse(response, "-1");
        }
    }

    /**
     * 详情
     */
    @RequestMapping("pdetailNotice")
    public String detailNotice(HttpServletRequest request, Model model, Integer id) {
        try {
            SysNotice notice = this.sysPublicNoticeService.queryNoticeById(id);
            model.addAttribute("notice", notice);
        } catch (Exception e) {
            log.error("查看失败", e);
        }
        return "/publicplat/notice/noticedetail";
    }

    /**
     * 推送
     */
    @RequestMapping("pisPush")
    public void isPush(HttpServletRequest request, HttpServletResponse response, Integer id, String noticeTp) {
        List<SysMemDTO> memList = new ArrayList<SysMemDTO>();
        String tp = null;
        String belongMsg = null;
        try {
            SysNotice notice = this.sysPublicNoticeService.queryNoticeById(id);
            if ("2".equals(notice.getIsPush())) {
                this.sysPublicNoticeService.updatePush(id);
                this.sendHtmlResponse(response, "1");
            } else {
                this.sendHtmlResponse(response, "2");
            }
            SysLoginInfo info = getInfo(request);
            if ("".equals(info.getDatasource()) || null == info.getDatasource()) {//查询系统全部成员
                memList = sysMemberService.querypMems();
                if ("1".equals(noticeTp)) {
                    tp = "13";
                    belongMsg = "系统公告";
                } else if ("4".equals(noticeTp)) {
                    tp = "29";
                    belongMsg = "购开心公告";
                }
            } else {//查询公司成员
                memList = this.sysMemService.querycMems(info.getDatasource());
                tp = "12";
                belongMsg = "企业公告";
            }
            List<SysChatMsg> sys = new ArrayList<SysChatMsg>();
            StringBuffer str = new StringBuffer();
            if (memList.size() > 0) {
                String time = DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd HH:mm:ss");
                for (SysMemDTO memberDTO : memList) {
                    SysChatMsg scm = new SysChatMsg();
                    scm.setAddtime(time);
                    scm.setMemberId(info.getIdKey());
                    scm.setReceiveId(memberDTO.getMemberId());
                    scm.setMsg(notice.getNoticeTitle());
                    scm.setTp(tp);
                    scm.setBelongId(id);//公告id
                    scm.setBelongMsg(belongMsg);
                    scm.setMsgTp("1");// 发表类型1.文字2.图片3.语音;
                    sys.add(scm);
                    str.append(memberDTO.getMemberMobile() + ",");
                }
                if ("".equals(info.getDatasource()) || null == info.getDatasource()) {
                    this.sysChatMsgWebService.addChatMsg(sys, null);
                } else {
                    this.sysChatMsgWebService.addChatMsg(sys, info.getDatasource());
                }
                String remind = str.substring(0, str.length() - 1);
                jpushClassifies.toJpush(remind, CnlifeConstants.MODE5, CnlifeConstants.NEWMSG, null, null, "公告推送", "2");//不屏蔽
                jpushClassifies2.toJpush(remind, CnlifeConstants.MODE5, CnlifeConstants.NEWMSG, null, null, "公告推送", "2");//不屏蔽
            }
        } catch (Exception e) {
            log.error("推送失败", e);
            this.sendHtmlResponse(response, "-1");
        }
    }

    /**
     * @param model
     * @param imgsrc
     * @param width
     * @param height
     * @return
     * @创建：作者:YYP 创建时间：Sep 24, 2015
     * @see 到裁剪页面
     */
    @RequestMapping("noticeToImgCoord")
    public String noticeToImgCoord(Model model, String imgsrc, String width, String height) {
        model.addAttribute("imgsrc", imgsrc);
        model.addAttribute("width", width);
        model.addAttribute("height", height);
        return "/publicplat/notice/toImgCoord";
    }

    /**
     * 说明：图片剪裁
     *
     * @param x      开始(横坐标)
     * @param y      开始(纵坐标)
     * @param width  剪裁的宽度
     * @param height 剪裁的高度
     * @param folder 要保存的目录
     * @param imgNm  要保存的文件名称
     * @创建：yyp
     * @修改历史： [序号](llp 2013 - 8 - 23)<修改说明>
     */
    @RequestMapping("/noticeCoordinate")
    public void noticeCoordinate(ImgCoordinate imgc, HttpServletResponse response, HttpServletRequest request) {
        try {
            String path = request.getSession().getServletContext().getRealPath("/upload");
            String folder = path + "/temp";
            String fileName = imgc.getSrcpath();
            imgc.setSrcpath(folder + "/" + fileName);
            imgc.setFolder(folder);
            imgc.setImgNm("ntc" + System.currentTimeMillis());
            String srcPath = folder + "/s" + fileName;
            //图片缩放
            ImageUtil.scImgBySize(imgc.getSrcpath(), srcPath, imgc.getImgWidth(), imgc.getImgHeight());
            imgc.setSrcpath(srcPath);
            //图片剪裁
            String imgNm = ImageUtil.clipping(imgc);
            if (StrUtil.isNull(imgNm)) {
                this.sendHtmlResponse(response, "-1");
            } else {
                this.sendHtmlResponse(response, imgNm);
            }
        } catch (Exception e) {
            log.error("截图出错：", e);
            this.sendHtmlResponse(response, "-1");
        }
    }
}
