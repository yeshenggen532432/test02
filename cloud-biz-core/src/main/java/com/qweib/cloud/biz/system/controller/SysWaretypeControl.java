package com.qweib.cloud.biz.system.controller;

import com.google.common.collect.Lists;
import com.qweib.cloud.biz.common.GeneralControl;
import com.qweib.cloud.biz.system.UploadFile;
import com.qweib.cloud.biz.system.UserContext;
import com.qweib.cloud.biz.system.controller.vo.TreeNodeVo;
import com.qweib.cloud.biz.system.service.SysWaretypePicService;
import com.qweib.cloud.biz.system.service.SysWaretypeService;
import com.qweib.cloud.core.domain.SysLoginInfo;
import com.qweib.cloud.core.domain.SysWaretype;
import com.qweib.cloud.core.domain.SysWaretypePic;
import com.qweib.cloud.utils.Collections3;
import com.qweib.cloud.utils.StrUtil;
import com.qweibframework.commons.StringUtils;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.stream.Collectors;


@Controller
@RequestMapping("/manager")
public class SysWaretypeControl extends GeneralControl {
    @Resource
    private SysWaretypeService waretypeService;
    @Resource
    private SysWaretypePicService waretypePicService;

    /**
     * @说明：分类主页
     */
    @RequestMapping("/querywaretype")
    public String queryWaretype() {
        return "/uglcw/waretype/waretype";
    }

    /**
     * @说明：查询分类树
     */
    @RequestMapping("/waretypes")
    public void waretypes(Integer id, HttpServletResponse response, HttpServletRequest request) {
        SysLoginInfo info = this.getLoginInfo(request);
        try {
            if (null == id) {
                id = 0;
            }
            String isType = request.getParameter("isType");
            SysWaretype type = new SysWaretype();
            type.setWaretypeId(id);
            type.setNoCompany(1);
            if (!StrUtil.isNull(isType)) {
                type.setIsType(Integer.valueOf(isType));
            }
            List<SysWaretype> waretypes = this.waretypeService.queryWaretype(type, info.getDatasource());
            dealWaretypesToJson(waretypes, id, response);
        } catch (Exception e) {
            log.error("查询分类树出错：", e);
        }
    }

    @RequestMapping("/syswaretypes")
    @ResponseBody
    public List<TreeNodeVo> syswaretypes(@RequestParam(defaultValue = "0") Integer id, String isType, Integer noCompany) {
        SysLoginInfo info = UserContext.getLoginInfo();
        SysWaretype type = new SysWaretype();
        type.setWaretypeId(id);
        if (!StrUtil.isNull(isType)) {
            type.setIsType(Integer.valueOf(isType));
        }
        if (Objects.nonNull(noCompany)) {
            type.setNoCompany(noCompany);
        }
        List<SysWaretype> waretypes = this.waretypeService.queryWaretype(type, info.getDatasource());
        return toTree(waretypes, id);
    }

    private List<TreeNodeVo> toTree(List<SysWaretype> wareTypes, Integer pid) {
        List<TreeNodeVo> nodes = Lists.newArrayList();
        if (Collections3.isNotEmpty(wareTypes)) {
            List<TreeNodeVo> types = wareTypes.stream().map(
                    type -> TreeNodeVo.builder()
                            .id(type.getWaretypeId())
                            .text(type.getWaretypeNm())
                            .path(type.getWaretypePath())
                            .pid(type.getWaretypePid())
                            .leaf(type.getWaretypeLeaf())
                            .state(StringUtils.equals("0", type.getWaretypeLeaf()) ? "closed" : "open")
                            .build()
            ).collect(Collectors.toList());
            if (Objects.equals(pid, 0)) {
                TreeNodeVo root = TreeNodeVo.builder()
                        .id(0)
                        .text("根节点")
                        .state("open")
                        .children(types)
                        .build();
                nodes.add(root);
            } else {
                nodes.addAll(types);
            }
        }else{
            TreeNodeVo root = TreeNodeVo.builder()
                    .id(0)
                    .text("根节点")
                    .state("closed")
                    .build();
            nodes.add(root);
        }
        return nodes;
    }


    /**
     * @说明：获取商品分类
     */
    @RequestMapping("/getwaretype")
    public void getwaretype(Integer id, HttpServletResponse response, HttpServletRequest request) {
        SysLoginInfo info = this.getLoginInfo(request);
        String isType = request.getParameter("isType");
        try {
            if (StrUtil.isNull(id)) {
                SysWaretype type = new SysWaretype();
                id = this.waretypeService.queryOneWaretype(type, info.getDatasource());
            }
            if (StrUtil.isNull(id)) {
                return;
            }
            SysWaretype waretype = this.waretypeService.queryWaretypeById(id, info.getDatasource());
            //添加图片
            SysWaretypePic model = new SysWaretypePic();
            model.setWaretypeId(waretype.getWaretypeId());
            List<SysWaretypePic> waretypePicList = this.waretypePicService.queryList(model, info.getDatasource());
            waretype.setWaretypePicList(waretypePicList);
            JSONObject json = new JSONObject(waretype);
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            log.error("获取商品分类出错：", e);
        }
    }

    @RequestMapping("/checkWareTypeLeaf")
    public void checkWareTypeLeaf(Integer id, HttpServletResponse response, HttpServletRequest request) {
        SysLoginInfo info = this.getLoginInfo(request);
        try {
            JSONObject json = new JSONObject();
            if (StrUtil.isNull(id)) {
                json.put("state", false);
                this.sendJsonResponse(response, json.toString());
                return;
            }

            int count = this.waretypeService.queryWaretypeInt(id, info.getDatasource());

            //SysWaretype waretype = this.waretypeService.queryWaretypeById(id,info.getDatasource());
            if (count == 0) {
                json.put("state", true);
            } else {
                json.put("state", false);
            }
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            log.error("获取商品分类出错：", e);
        }
    }


    /**
     * @说明：操作商品分类
     */
    @RequestMapping("/operwaretype")
    public void operwaretype(HttpServletResponse response, HttpServletRequest request, SysWaretype waretype, String delPicIds) {
        SysLoginInfo info = this.getLoginInfo(request);
        try {
            if (null == waretype.getWaretypeId() || waretype.getWaretypeId() == 0) {
                //===================添加=====================
                int count = this.waretypeService.queryWaretypeNmCount(waretype.getWaretypeNm(), info.getDatasource());
                if (count > 0) {
                    this.sendHtmlResponse(response, "-3");
                    return;
                }
                if (null != waretype.getWaretypePid() && waretype.getWaretypePid() > 0) {
                    //获取父级商品分类
                    SysWaretype temp = this.waretypeService.queryWaretypeById(waretype.getWaretypePid(), info.getDatasource());
                    if(temp.getWaretypePid() == 0){
                        //一级商品分类是否存在商品
                        boolean bool = this.waretypeService.existWareInType(temp.getWaretypeId(), info.getDatasource());
                        if (bool) {
                            this.sendHtmlResponse(response, "-4");
                            return;
                        }
                    }
                    if (temp.getWaretypePid() > 0) {
                        this.sendHtmlResponse(response, "-2");
                        return;
                    }
                } else {
                    waretype.setWaretypePid(0);
                }
                waretype.setWaretypeLeaf("1");
                //图片
                Map<String, Object> map = UploadFile.updatePhotos(request, info.getDatasource(), "waretype/pic", 1);
                List<SysWaretypePic> waretypePicList = new ArrayList<SysWaretypePic>();
                if ("1".equals(map.get("state"))) {
                    if ("1".equals(map.get("ifImg"))) {//是否有图片
                        SysWaretypePic swp = new SysWaretypePic();
                        List<String> pic = (List<String>) map.get("fileNames");
                        List<String> picMini = (List<String>) map.get("smallFile");
                        for (int i = 0; i < pic.size(); i++) {
                            swp = new SysWaretypePic();
                            swp.setPicMini(picMini.get(i));
                            swp.setPic(pic.get(i));
                            waretypePicList.add(swp);
                        }
                        waretype.setWaretypePicList(waretypePicList);
                    }
                }
                this.waretypeService.addWaretype(waretype, info.getDatasource());
                this.sendHtmlResponse(response, waretype.getWaretypeId().toString());
            } else {
                //===================修改=====================
                SysWaretype oldWaretype = this.waretypeService.queryWaretypeById(waretype.getWaretypeId(), info.getDatasource());
                if (!oldWaretype.getWaretypeNm().equals(waretype.getWaretypeNm())) {
                    int count = this.waretypeService.queryWaretypeNmCount(waretype.getWaretypeNm(), info.getDatasource());
                    if (count > 0) {
                        this.sendHtmlResponse(response, "-3");
                        return;
                    }
                }
                //图片
                Map<String, Object> map = UploadFile.updatePhotos(request, info.getDatasource(), "waretype/pic", 1);
                List<SysWaretypePic> waretypePicList = new ArrayList<SysWaretypePic>();
                if ("1".equals(map.get("state"))) {
                    if ("1".equals(map.get("ifImg"))) {//是否有图片
                        SysWaretypePic swp = new SysWaretypePic();
                        List<String> pic = (List<String>) map.get("fileNames");
                        List<String> picMini = (List<String>) map.get("smallFile");
                        for (int i = 0; i < pic.size(); i++) {
                            swp = new SysWaretypePic();
                            swp.setPicMini(picMini.get(i));
                            swp.setPic(pic.get(i));
                            waretypePicList.add(swp);
                        }
                        oldWaretype.setWaretypePicList(waretypePicList);
                    }
                }
                //这边有修改图片，名称，非公司产品，
                oldWaretype.setWaretypeNm(waretype.getWaretypeNm());
                oldWaretype.setNoCompany(waretype.getNoCompany());
                oldWaretype.setIsType(waretype.getIsType());
                oldWaretype.setSort(waretype.getSort());
                this.waretypeService.updateWaretype(oldWaretype, delPicIds, info.getDatasource());
                this.sendHtmlResponse(response, "2");
            }
        } catch (Exception e) {
            log.error("操作商品分类出错：", e);
            this.sendHtmlResponse(response, "-1");
        }
    }

    /**
     * @说明：删除商品分类
     */
    @RequestMapping("/deletewaretype")
    public void deletewaretype(Integer id, HttpServletResponse response, HttpServletRequest request) {
        SysLoginInfo info = this.getLoginInfo(request);
        try {
            SysWaretype waretype = this.waretypeService.queryWaretypeById(id, info.getDatasource());
            //该商品分类是否存在商品
            boolean bool = this.waretypeService.existWareInType(waretype.getWaretypeId(), info.getDatasource());
            if (bool) {
                this.sendHtmlResponse(response, "2");
                return;
            }
            //父级商品分类不能删除
            if ("0".equals(waretype.getWaretypeLeaf())) {
                this.sendHtmlResponse(response, "3");
                return;
            }
            this.waretypeService.deleteWaretype(waretype, info.getDatasource());
            this.sendHtmlResponse(response, "1");
        } catch (Exception e) {
            log.error("删除商品分类出错：", e);
            this.sendHtmlResponse(response, "-1");
        }
    }


    /**
     * 查询公司类商品类别
     */
    @ResponseBody
    @RequestMapping("/companyWaretypes")
    public List<TreeNodeVo>  companyWaretypes(@RequestParam(defaultValue = "0") Integer id, String isType) {
        SysLoginInfo info = UserContext.getLoginInfo();
        SysWaretype type = new SysWaretype();
        type.setWaretypeId(id);
        type.setNoCompany(1);
        if (!StrUtil.isNull(isType)) {
            type.setIsType(Integer.valueOf(isType));
        }
        List<SysWaretype> waretypes = this.waretypeService.queryCompanyWaretypeList(type, info.getDatasource());
        return toTree(waretypes, id);
    }

    /**
     * 查询库存类公司类商品类别
     */
    @RequestMapping("/companyStockWaretypes")
    public void companyStockWaretypes(Integer id, HttpServletResponse response, HttpServletRequest request) {
        SysLoginInfo info = this.getLoginInfo(request);
        try {
            if (null == id) {
                id = 0;
            }
            SysWaretype type = new SysWaretype();
            type.setWaretypeId(id);
            List<SysWaretype> waretypes = this.waretypeService.queryCompanyStockWaretypeList(type, info.getDatasource());
            dealWaretypesToJson(waretypes, id, response);
        } catch (Exception e) {
            log.error("查询分类树出错：", e);
        }
    }


    private void dealWaretypesToJson(List<SysWaretype> waretypes, Integer id, HttpServletResponse response) {
        if (null != waretypes && waretypes.size() > 0) {
            StringBuilder str = new StringBuilder();
            str.append("[");
            String sp = "";
            for (SysWaretype waretype : waretypes) {
                long pid = waretype.getWaretypePid();
                if (id == pid) {
                    Integer waretypeId = waretype.getWaretypeId();
                    String waretypeNm = waretype.getWaretypeNm();

                    String leaf = waretype.getWaretypeLeaf();
                    String state = "open";
                    if ("0".equals(leaf)) {
                        state = "closed";
                    }
                    str.append(sp).append("{\"id\":").append(waretypeId).append(",\"text\":\"")
                            .append(waretypeNm).append("\",\"state\":\"").append(state).append("\"}");
                    sp = ",";
                }
            }
            str.append("]");
            if (id == 0) {
                String root = "[";
                root = root + "{";
                root = root + "\"id\":0,";
                root = root + "\"text\":\"根节点\",";
                root = root + "\"state\":\"open\",";
                root = root + "\"children\":" + str.toString() + "";
                root = root + "}";
                root = root + "]";
                this.sendHtmlResponse(response, root);
            } else {
                this.sendHtmlResponse(response, str.toString());

            }
        } else {
            String root = "[";
            root = root + "{";
            root = root + "\"id\":0,";
            root = root + "\"text\":\"根节点\",";
            root = root + "\"state\":\"open\",";
            root = root + "\"children\":[]";
            root = root + "}";
            root = root + "]";
            this.sendHtmlResponse(response, root);
        }
    }


}
