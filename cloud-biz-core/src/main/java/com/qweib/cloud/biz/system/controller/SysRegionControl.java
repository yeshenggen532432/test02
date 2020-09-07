package com.qweib.cloud.biz.system.controller;

import com.qweib.cloud.biz.common.GeneralControl;
import com.qweib.cloud.biz.system.service.SysCustomerService;
import com.qweib.cloud.biz.system.service.SysRegionService;
import com.qweib.cloud.core.domain.SysLoginInfo;
import com.qweib.cloud.core.domain.SysRegion;
import com.qweib.cloud.utils.StrUtil;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;


@Controller
@RequestMapping("/manager")
public class SysRegionControl extends GeneralControl {
    @Resource
    private SysRegionService regionService;
    @Resource
    private SysCustomerService sysCustomerService;


    @RequestMapping("/queryRegion")
    public String queryregion() {
        return "/uglcw/region/region";
    }

    @RequestMapping("/regions")
    public void regions(Integer id, HttpServletResponse response, HttpServletRequest request) {
        SysLoginInfo info = this.getLoginInfo(request);
        try {
            if (null == id) {
                id = 0;
            }
            SysRegion type = new SysRegion();
            type.setRegionId(id);
            List<SysRegion> regions = this.regionService.queryregion(type, info.getDatasource());

            StringBuilder str = new StringBuilder();
            str.append("[");
            String sp = "";
            if (null != regions && regions.size() > 0) {
                for (SysRegion region : regions) {
                    long pid = region.getRegionPid();
                    if (id == pid) {
                        Integer regionId = region.getRegionId();
                        String regionNm = region.getRegionNm();
                        String leaf = region.getRegionLeaf();
                        String state = "open";
                        if ("0".equals(leaf)) {
                            state = "closed";
                        }
                        str.append(sp).append("{\"id\":").append(regionId).append(",\"text\":\"")
                                .append(regionNm).append("\",\"state\":\"").append(state).append("\"}");
                        sp = ",";
                    }
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

        } catch (Exception e) {
            log.error("加载出错", e);
        }
    }

    @RequestMapping("/sysRegions")
    public void SysRegions(Integer id, HttpServletResponse response, HttpServletRequest request) {
        SysLoginInfo info = this.getLoginInfo(request);
        try {
            if (null == id) {
                id = 0;
            }
            SysRegion type = new SysRegion();
            type.setRegionId(id);
            List<SysRegion> regions = this.regionService.queryregion(type, info.getDatasource());

            StringBuilder str = new StringBuilder();

            str.append("[");
            String sp = "";
            if (null != regions && regions.size() > 0) {
                for (SysRegion region : regions) {
                    long pid = region.getRegionPid();
                    if (id == pid) {
                        Integer regionId = region.getRegionId();
                        String regionNm = region.getRegionNm();
                        String leaf = region.getRegionLeaf();
                        String state = "open";
                        if ("0".equals(leaf)) {
                            state = "closed";
                        }
                        str.append(sp).append("{\"id\":").append(regionId).append(",\"text\":\"")
                                .append(regionNm).append("\",\"state\":\"").append(state).append("\"}");
                        sp = ",";
                    }
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

        } catch (Exception e) {
            log.error("加载出错", e);
        }
    }


    @RequestMapping("/getRegion")
    public void getRegion(Integer id, HttpServletResponse response, HttpServletRequest request) {
        SysLoginInfo info = this.getLoginInfo(request);
        try {
            if (StrUtil.isNull(id)) {
                SysRegion type = new SysRegion();
                id = this.regionService.queryOneregion(type, info.getDatasource());
            }
            if (StrUtil.isNull(id)) {
                return;
            }
            SysRegion region = this.regionService.queryRegionById(id, info.getDatasource());
            JSONObject json = new JSONObject(region);
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            log.error(e + "");
        }
    }

    @RequestMapping("/operRegion")
    public void operregion(HttpServletResponse response, HttpServletRequest request, SysRegion region, String delPicIds) {
        SysLoginInfo info = this.getLoginInfo(request);
        try {
            if (null == region.getRegionId() || region.getRegionId() == 0) {
                //===================添加=====================
                int count = this.regionService.queryRegionNmCount(region.getRegionNm(), info.getDatasource());
                if (count > 0) {
                    this.sendHtmlResponse(response, "-3");
                    return;
                }
                if (null != region.getRegionPid() && region.getRegionPid() > 0) {
                    //获取父级商品分类
//					SysRegion temp = this.regionService.queryregionById(region.getRegionPid(),info.getDatasource());
//					if(temp.getRegionPid()>0){
//						this.sendHtmlResponse(response, "-2");
//						return;
//					}
                } else {
                    region.setRegionPid(0);
                }
                region.setRegionLeaf("1");

                this.regionService.addregion(region, info.getDatasource());
                this.sendHtmlResponse(response, region.getRegionId().toString());
            } else {
                //===================修改=====================
                SysRegion oldregion = this.regionService.queryRegionById(region.getRegionId(), info.getDatasource());
                if (!oldregion.getRegionNm().equals(region.getRegionNm())) {
                    int count = this.regionService.queryRegionNmCount(region.getRegionNm(), info.getDatasource());
                    if (count > 0) {
                        this.sendHtmlResponse(response, "-3");
                        return;
                    }
                }


                oldregion.setRegionNm(region.getRegionNm());

                this.regionService.updateRegion(oldregion, info.getDatasource());
                this.sendHtmlResponse(response, "2");
            }
        } catch (Exception e) {
            log.error(e + "");
            this.sendHtmlResponse(response, "-1");
        }
    }

    @RequestMapping("/deleteRegion")
    public void deleteRegion(Integer id, HttpServletResponse response, HttpServletRequest request) {
        SysLoginInfo info = this.getLoginInfo(request);
        try {

            SysRegion region = this.regionService.queryRegionById(id, info.getDatasource());
            if ("0".equals(region.getRegionLeaf())) {
                this.sendHtmlResponse(response, "3");
                return;
            }
           int count =this.sysCustomerService.queryRegionById(id,info.getDatasource());
            if(count>0){
                this.sendHtmlResponse(response, "2");
                return;
            }
            this.regionService.deleteRegion(region, info.getDatasource());
            this.sendHtmlResponse(response, "1");
        } catch (Exception e) {
            log.error(e + "");
            this.sendHtmlResponse(response, "-1");
        }
    }

}
