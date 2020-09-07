package com.qweib.cloud.biz.system.controller.plat;

import com.qweib.cloud.biz.system.service.plat.SysQuestionnaireServiceHt;
import com.qweib.cloud.core.domain.ArrayQuestionnaireDetail;
import com.qweib.cloud.core.domain.SysQuestionnaire;
import com.qweib.cloud.core.domain.SysQuestionnaireDetail;
import com.qweib.cloud.core.domain.SysLoginInfo;
import com.qweib.cloud.biz.common.GeneralControl;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@Controller
@RequestMapping("/manager")
public class SysQuestionnaireControlHt extends GeneralControl {
    @Resource
    private SysQuestionnaireServiceHt questionnaireService;

    /**
     * 摘要：
     *
     * @说明：问卷主页
     * @创建：作者:llp 创建时间：2015-2-10
     * @修改历史：
     */
    @RequestMapping("/queryquestionnaire")
    public String queryquestionnaire() {
        return "/companyPlat/questionnaire/questionnaire";
    }

    /**
     * 摘要：
     *
     * @说明：问卷分页
     * @创建：作者:llp 创建时间：2015-2-10
     * @修改历史：
     */
    @RequestMapping("/questionnairepages")
    public void questionnaire(HttpServletResponse response, HttpServletRequest request, SysQuestionnaire questionnaire, Integer page, Integer rows) {
        SysLoginInfo info = getLoginInfo(request);
        try {
            Page p = this.questionnaireService.queryQuestionnaire(questionnaire, info.getDatasource(), page, rows);
            JSONObject json = new JSONObject();
            json.put("total", p.getTotal());
            json.put("rows", p.getRows());
            this.sendJsonResponse(response, json.toString());
            p = null;
        } catch (Exception e) {
            log.error("问卷分页出错：", e);
        }
    }

    /**
     * @说明：到添加/修改页面
     * @创建：作者:llp 创建时间：2015-2-10
     * @修改历史： [序号](llp 2015 - 2 - 10)<修改说明>
     */
    @RequestMapping("/tooperquestionnaire")
    public String tooperquestionnaire(HttpServletRequest request, Model model, Integer qid, String tp) {
        SysLoginInfo info = getLoginInfo(request);
        if (null != qid) {
            try {
                //根据ID获取问卷
                SysQuestionnaire questionnaire = this.questionnaireService.queryQuestionnaireById(qid, info.getDatasource());
                model.addAttribute("questionnaire", questionnaire);
                //获取卡问卷对应的选项
                List<SysQuestionnaireDetail> details = this.questionnaireService.queryQuestionnaireDetail(qid, info.getDatasource());
                model.addAttribute("details", details);
                model.addAttribute("detailCount", details.size());
            } catch (Exception e) {
                log.error("查询问卷信息出错：", e);
                model.addAttribute("detailCount", 1);
            }
        } else {
            model.addAttribute("detailCount", 1);
        }
        if (StrUtil.isNull(tp)) {
            return "/companyPlat/questionnaire/questionnaireoper";
        } else {
            return "/companyPlat/questionnaire/questionnairexq";
        }

    }

    /**
     * 摘要：
     *
     * @说明：操作问卷信息
     * @创建：作者:llp 创建时间：2015-2-10
     * @修改历史： [序号](llp 2015 - 2 - 10)<修改说明>
     */
    @RequestMapping("/operquestionnaire")
    public void operquestionnaire(SysQuestionnaire questionnaire, HttpServletResponse response, HttpServletRequest request, ArrayQuestionnaireDetail lsQuestionnaireDetail) {
        SysLoginInfo info = getLoginInfo(request);
        if (null != questionnaire) {
            try {
                if (StrUtil.isNull(questionnaire.getQid())) {//添加问卷信息
                    questionnaire.setMemberId(info.getIdKey());
                    questionnaire.setStime(new SimpleDateFormat("yyyy-MM-dd").format(new Date()));
                    this.questionnaireService.addQuestionnaire(questionnaire, info.getDatasource(), lsQuestionnaireDetail.getLsQuestionnaireDetail());
                    this.sendHtmlResponse(response, "1");
                } else {
                    this.questionnaireService.updateQuestionnaire(questionnaire, info.getDatasource(), lsQuestionnaireDetail.getLsQuestionnaireDetail());
                    this.sendHtmlResponse(response, "2");
                }

            } catch (Exception e) {
                log.error("操作问卷出错：", e);
                this.sendHtmlResponse(response, "-1");
            }
        }
    }

    /**
     * 摘要：
     *
     * @说明：删除问卷信息
     * @创建：作者:llp 创建时间：2015-2-10
     * @修改历史： [序号](llp 2015 - 2 - 10)<修改说明>
     */
    @RequestMapping("/delquestionnaire")
    public void delquestionnaire(Integer qid, HttpServletResponse response, HttpServletRequest request) {
        SysLoginInfo info = getLoginInfo(request);
        try {
            this.questionnaireService.deleteQuestionnaire(qid, info.getDatasource());
            this.sendHtmlResponse(response, "1");
        } catch (Exception e) {
            log.error("删除问卷信息出错：", e);
            this.sendHtmlResponse(response, "-1");
        }
    }

    /**
     * 投票统计
     *
     * @author guojp
     */
    @RequestMapping("/counting")
    public String counting(HttpServletRequest request, HttpServletResponse response, Model model, Integer qid) {
        SysLoginInfo info = getLoginInfo(request);
        //查询比率
        List<SysQuestionnaireDetail> ratios = this.questionnaireService.queryByRatio(qid, info.getDatasource());
        String nos = "[";
        String ratio = "[";
        for (SysQuestionnaireDetail detail : ratios) {
            nos += "'" + detail.getNo() + "',";
            ratio += "{value:" + detail.getRatio() + ", name:'" + detail.getNo() + "'},";
        }
        nos = nos.substring(0, nos.length() - 1) + "]";
        ratio = ratio.substring(0, ratio.length() - 1) + "]";
        model.addAttribute("ratio", ratio);
        model.addAttribute("nos", nos);
        return "questionnaire/wenjuantj";
    }
}
