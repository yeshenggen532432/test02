package com.qweib.cloud.biz.system.controller.ws;

import com.qweib.cloud.biz.system.BaseWebService;
import com.qweib.cloud.biz.system.TokenServer;
import com.qweib.cloud.biz.system.service.ws.BscEmpGroupWebService;
import com.qweib.cloud.biz.system.service.ws.BscKnowledgeService;
import com.qweib.cloud.core.domain.*;

import com.qweib.cloud.utils.DateTimeUtil;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.json.JSONObject;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Date;
import java.util.List;

@Controller
@RequestMapping("/web/")
public class BscKnowledgeControl extends BaseWebService {
    @Resource
    private BscKnowledgeService knowledgeService;
    @Resource
    private BscEmpGroupWebService empGroupWebService;


    /**
     * @param response
     * @param request
     * @param token
     * @创建：作者:YYP 创建时间：2015-2-11
     * @see 查询员工圈知识库所有分类
     */
    @RequestMapping("sortList")
    public void sortList(HttpServletResponse response, HttpServletRequest request, String token, Integer groupId, Integer pageNo, String searchContent) {
        if (!checkParam(response, token, groupId))
            return;
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
            Page sortPage = knowledgeService.querySortPage(groupId, searchContent, onlineUser.getDatabase(), pageNo, 20);
            JSONObject json = new JSONObject();
            json.put("sortList", sortPage.getRows());
            json.put("totalPage", sortPage.getTotalPage());
            json.put("state", true);
            json.put("msg", "查询成功");
            sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            sendException(response, e);
        }
    }

    /**
     * @param request
     * @param response
     * @param token
     * @param topicId
     * @param sortId
     * @创建：作者:YYP 创建时间：2015-2-11
     * @see 设置成知识点
     */
    @RequestMapping("setKnowledge")
    public void setKnowledge(HttpServletRequest request, HttpServletResponse response, String token, Integer topicId, Integer sortId) {
        if (!checkParam(response, token, topicId, sortId))
            return;
        try {
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            OnlineUser onlineUser = message.getOnlineMember();
            String datasource = onlineUser.getDatabase();
            Integer info = knowledgeService.queryIsExit(topicId, sortId, datasource);
            if (info > 0) {
                sendWarm(response, "分类中已存在该条帖子");
                return;
            }
            knowledgeService.addKnowledge(topicId, sortId, datasource, onlineUser.getMemId());
            sendSuccess(response, "成功分享至知识库");
        } catch (Exception e) {
            sendException(response, e);
        }
    }

    /**
     * @param response
     * @param token
     * @param sortId
     * @param url
     * @param tp       类型 2 url 3 附件
     * @创建：作者:YYP 创建时间：2015-5-21
     * @see 添加知识库（外部来源）
     */
    @RequestMapping("addKnowledge")
    public void addKnowledge(HttpServletResponse response, String token, Integer sortId, String url, String tp) {
        if (!checkParam(response, token, sortId, tp))
            return;
        try {
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            OnlineUser onlineUser = message.getOnlineMember();
            BscKnowledge knowledge = new BscKnowledge();
            knowledge.setSortId(sortId);
            knowledge.setOperateId(onlineUser.getMemId());
            knowledge.setTopicTime(DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd HH:mm:ss"));
            knowledge.setMemberId(onlineUser.getMemId());//添加人
            if ("2".equals(tp)) {
                Document doc = null;
                try {
                    doc = Jsoup.connect(url + "/")
                            .data("jquery", "java")
                            .userAgent("Mozilla")
                            .cookie("auth", "token")
                            .timeout(50000)
                            .get();
                } catch (Exception e) {
                    try {//如果网址解析错误，加“/”再次解析
                        doc = Jsoup.connect(url + "/")
                                .data("jquery", "java")
                                .userAgent("Mozilla")
                                .cookie("auth", "token")
                                .timeout(50000)
                                .get();
                    } catch (Exception ex) {//网站的bug,跳过该问题
                        try {
                            doc = Jsoup.connect(url).header("User-Agent", "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/40.0.2214.111 Safari/537.36").get();
                        } catch (IOException ioex) {
                            sendWarm(response, "网址错误");
                            return;
                        }
                    }
                }
                String title = doc.title();
                if ("".equals(title.trim())) {
                    title = "详情";
                }
                knowledge.setTopicTitle(title);
                knowledge.setTopiContent(url);
                knowledge.setTp(tp);
            } else if ("3".equals(tp)) {

            }
            knowledgeService.addOutKnowledge(knowledge, onlineUser.getDatabase());
            sendSuccess(response, "添加外部知识库成功");
        } catch (Exception e) {
            sendException(response, e);
        }
    }

    /**
     * @param request
     * @param response
     * @param token
     * @param groupId
     * @param sortId
     * @创建：作者:YYP 创建时间：2015-3-2
     * @see 查询知识点列表
     */
    @RequestMapping("knowledgeList")
    public void knowledgeList(HttpServletRequest request, HttpServletResponse response, String token, Integer sortId, Integer groupId, Integer pageNo, String searchContent) {
        if (!checkParam(response, token))
            return;
        if (StrUtil.isNull(pageNo)) {
            pageNo = 1;
        }
        try {
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            OnlineUser onlineUser = message.getOnlineMember();
            Page p = knowledgeService.queryKnowledge(sortId, searchContent, groupId, onlineUser.getDatabase(), pageNo, 10);
            JSONObject json = new JSONObject();
            json.put("list", p.getRows());
            json.put("state", true);
            json.put("msg", "查询成功");
            sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            sendException(response, e);
        }
    }

    /**
     * @param response
     * @param request
     * @param sort     groupId,sortNm
     * @创建：作者:YYP 创建时间：2015-3-3
     * @see 添加分类
     */
    @RequestMapping("addSort")
    public void addSort(HttpServletResponse response, HttpServletRequest request, String token, String sortNm, Integer groupId) {
        if (!checkParam(response, token, sortNm, groupId))
            return;
        try {
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            OnlineUser onlineUser = message.getOnlineMember();
            String datasource = onlineUser.getDatabase();
            Integer info = knowledgeService.querySortNmAppear(sortNm, null, groupId, datasource);
            if (info > 0) {
                sendWarm(response, "该分类名已存在");
                return;
            }
            BscSort sort = new BscSort();
            sort.setGroupId(groupId);
            sort.setSortNm(sortNm);
            sort.setCreateTime(DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd HH:mm:ss"));
            sort.setMemberId(onlineUser.getMemId());
            knowledgeService.addSort(sort, datasource);
            sendSuccess(response, "添加分类成功");
        } catch (Exception e) {
            sendException(response, e);
        }
    }

    /**
     * @param response
     * @param request
     * @param token
     * @param sortId
     * @创建：作者:YYP 创建时间：2015-3-4
     * @see 删除分类
     */
    @RequestMapping("delSort")
    public void delSort(HttpServletResponse response, HttpServletRequest request, String token, Integer sortId) {
        if (!checkParam(response, token, sortId))
            return;
        try {
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            OnlineUser onlineUser = message.getOnlineMember();
            knowledgeService.deleteSort(sortId, onlineUser.getDatabase());
            sendSuccess(response, "成功删除分类");
        } catch (Exception e) {
            sendException(response, e);
        }
    }

    /**
     * @param request
     * @param response
     * @param token
     * @param sortId
     * @param sortNm
     * @创建：作者:YYP 创建时间：2015-3-4
     * @see 修改分类
     */
    @RequestMapping("updateSort")
    public void updateSort(HttpServletRequest request, HttpServletResponse response, String token, Integer sortId, String sortNm) {
        if (!checkParam(response, token, sortId, sortNm))
            return;
        try {
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            OnlineUser onlineUser = message.getOnlineMember();
            String datasource = onlineUser.getDatabase();
            Integer info = knowledgeService.querySortNmAppear(sortNm, sortId, null, datasource);
            if (info > 0) {
                sendWarm(response, "该分类名已存在");
                return;
            }
            knowledgeService.updateSort(sortId, sortNm, datasource);
            sendSuccess(response, "修改分类成功");
        } catch (Exception e) {
            sendException(response, e);
        }
    }

    /**
     * @param request
     * @param response
     * @param token
     * @param pageNo
     * @param searchContent
     * @创建：作者:YYP 创建时间：2015-5-21
     * @see 知识库列表
     */
    @RequestMapping("knowledgePage")
    public void knowledgePage(HttpServletRequest request, HttpServletResponse response, String token, Integer pageNo, String searchContent) {
        if (!checkParam(response, token))
            return;
        if (StrUtil.isNull(pageNo)) {
            pageNo = 1;
        }
        try {
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            OnlineUser onlineUser = message.getOnlineMember();
            Page p = empGroupWebService.queryGroupKnowledge(onlineUser.getMemId(), onlineUser.getDatabase(), searchContent, pageNo, 10);
            JSONObject json = new JSONObject();
            json.put("groups", p.getRows());
            json.put("total", p.getTotalPage());
            json.put("state", true);
            json.put("msg", "查询成功");
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            sendException(response, e);
        }
    }

    /**
     * @param response
     * @param token
     * @param knowledgeId
     * @创建：作者:YYP 创建时间：2015-5-21
     * @see 删除知识点
     */
    @RequestMapping("delKnowledge")
    public void delKnowledge(HttpServletResponse response, String token, Integer knowledgeId) {
        if (!checkParam(response, token, knowledgeId))
            return;
        try {
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            OnlineUser onlineUser = message.getOnlineMember();
            knowledgeService.deleteKnowledge(knowledgeId, onlineUser.getDatabase());
            sendSuccess(response, "知识点删除成功");
        } catch (Exception e) {
            sendException(response, e);
        }
    }

    /**
     * @param response
     * @param token
     * @param knowledgeId
     * @创建：作者:YYP 创建时间：2015-5-22
     * @see 查询知识库(帖子)详情
     */
    @RequestMapping("knowledgeDetail")
    public void knowledgeDetail(HttpServletResponse response, String token, Integer knowledgeId) {
        if (!checkParam(response, token, knowledgeId))
            return;
        try {
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            String datasource = message.getOnlineMember().getDatabase();
            BscKnowledgeFactoryDTO knowledge = knowledgeService.queryKnowledgeDetail(knowledgeId, datasource);
            JSONObject json = new JSONObject(knowledge);
            json.put("msg", "查询成功");
            json.put("state", true);
            sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            sendException(response, e);
        }
    }

    /**
     * @param response
     * @param token
     * @param knowledgeId
     * @创建：作者:YYP 创建时间：Aug 28, 2015
     * @see 获取知识库文件
     */
    @RequestMapping("knowdgeFile")
    public void knowdgeFile(HttpServletResponse response, String token, Integer knowledgeId) {
        try {
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            String datasource = message.getOnlineMember().getDatabase();
            List<SysTaskAttachment> fileList = knowledgeService.queryKnowledgeFile(knowledgeId, datasource);
            JSONObject json = new JSONObject();
            json.put("fileList", fileList);
            json.put("msg", "查询成功");
            json.put("state", true);
            sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            sendException(response, e);
        }
    }
}
