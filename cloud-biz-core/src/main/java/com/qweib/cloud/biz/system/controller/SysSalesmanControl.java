package com.qweib.cloud.biz.system.controller;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.qweib.cloud.biz.common.GeneralControl;
import com.qweib.cloud.biz.common.Response;
import com.qweib.cloud.biz.system.controller.dto.SalesmanMenusSave;
import com.qweib.cloud.biz.system.service.SysSalesmanService;
import com.qweib.cloud.biz.system.service.plat.SysCompanyRoleService;
import com.qweib.cloud.biz.system.service.plat.SysMemberService;
import com.qweib.cloud.core.domain.SysLoginInfo;
import com.qweib.cloud.core.domain.SysMember;
import com.qweib.cloud.core.domain.SysSalesman;
import com.qweib.cloud.core.domain.dto.SysMenuDTO;
import com.qweib.cloud.service.basedata.common.FuncSpecificTagEnum;
import com.qweib.cloud.service.initial.domain.company.SalesmanStatusEnum;
import com.qweib.cloud.utils.Collections3;
import com.qweib.cloud.utils.Page;
import com.qweib.commons.MathUtils;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Objects;


/**
 * @author: yueji.hu
 * @time: 2019-08-07 10:00
 * @description:
 */
@Controller
@RequestMapping("/manager")
public class SysSalesmanControl extends GeneralControl {
    @Resource
    private SysSalesmanService sysSalesmanService;
    @Resource
    private SysCompanyRoleService companyRoleService;
    @Resource
    private SysMemberService memberService;

    @RequestMapping("/salesman/page")
    public String salesmanPage() {
        return "uglcw/salesman/index";
    }


    @RequestMapping("/querySalesmanPage")
    public void queryDriverPage(HttpServletRequest request, HttpServletResponse response, SysSalesman bo, Integer page, Integer rows) {
        try {
            SysLoginInfo info = this.getLoginInfo(request);
            bo.setStatus(1);
            Page p = this.sysSalesmanService.queryData(bo, page, rows, info.getDatasource());
            JSONObject json = new JSONObject();
            json.put("total", p.getTotal());
            json.put("rows", p.getRows());

            this.sendJsonResponse(response, json.toString());
            p = null;
        } catch (Exception e) {
            log.error("分页查询成员出错", e);
        }
    }

    @ResponseBody
    @RequestMapping("/saveSalesman")
    public Response<String> saveDriver(HttpServletRequest request, SysSalesman pro) {
        SysLoginInfo info = this.getLoginInfo(request);
        if (!MathUtils.valid(pro.getId())) {
            return Response.createError("请选择业务员");
        }

        SysSalesman salesman = this.sysSalesmanService.queryById(pro.getId(), info.getDatasource());
        if (Objects.isNull(salesman)) {
            return Response.createError("该业务员不存在");
        }
        if (!SalesmanStatusEnum.isEnabled(salesman.getStatus())) {
            return Response.createError("该业务员已被禁用，不能修改");
        }

        String tel = null;
        if (MathUtils.valid(pro.getMemberId())) {
            SysMember member = this.memberService.querySysMemberById1(info.getDatasource(), pro.getMemberId());
            tel = member.getMemberMobile();
        }

        this.sysSalesmanService.updateMemberId(pro.getId(), tel, pro.getMemberId(), info.getDatasource());
        return Response.createSuccess().setMessage("更新成功");

//        try {
//            if (null == pro.getId() || pro.getId() == 0) {
//                SysSalesman vo = this.sysSalesmanService.findByName(pro.getSalesmanName(), info.getDatasource());
//                if (vo != null) {
//                    this.sendHtmlResponse(response, "-2");
//                    return;
//                }
//                this.sysSalesmanService.addData(pro, info.getDatasource());
//                this.sendHtmlResponse(response, "1");
//
//            } else {
//                SysSalesman vo = this.sysSalesmanService.findByName(pro.getSalesmanName(), info.getDatasource());
//                if (vo != null && !vo.getId().equals(pro.getId())) {
//                    this.sendHtmlResponse(response, "-2");
//                    return;
//                }
//                this.sysSalesmanService.updateData(pro, info.getDatasource());
//                this.sendHtmlResponse(response, "2");
//            }
//        } catch (Exception e) {
//            log.error("添加/修改业务员出错：", e);
//        }
    }

//    @RequestMapping("/deleteSalesman")
//    public void deleteSalesman(Integer[] ids, HttpServletRequest request, HttpServletResponse response) {
//        SysLoginInfo info = this.getLoginInfo(request);
//        try {
//            for (int i = 0; i < ids.length; i++) {
//                this.sysSalesmanService.deleteData(ids[i], info.getDatasource());
//                this.sendHtmlResponse(response, "1");
//            }
//        } catch (Exception e) {
//            log.error("删除失败", e);
//            this.sendHtmlResponse(response, "-1");
//        }
//
//
//    }
//
//    @RequestMapping("/updateSalesmanStatus")
//    public void updateSalesmanStatus(HttpServletResponse response,HttpServletRequest request,Integer id,Integer status){
//        SysLoginInfo loginInfo = this.getLoginInfo(request);
//        try{
//            SysSalesman bo= this.sysSalesmanService.queryById(id,loginInfo.getDatasource());
//            if(bo != null){
//                bo.setStatus(status);
//                this.sysSalesmanService.updateData(bo,loginInfo.getDatasource());
//            }
//            this.sendHtmlResponse(response, "1");
//        }catch (Exception e){
//            log.error("状态修改出错：", e);
//
//        }
//    }

    @ResponseBody
    @GetMapping("salesman/menus")
    public Response querySalesmanMenus(@RequestParam Integer memberId, @RequestParam String type, HttpServletRequest request) {
        SysLoginInfo loginUser = this.getLoginInfo(request);
        List<Map<String, Object>> list = companyRoleService.querySpecificTagMenus(loginUser.getDatasource(), memberId, null, type, FuncSpecificTagEnum.SALESMAN);
        if (Collections3.isNotEmpty(list)) {
            Map<String, byte[]> menuIdCache = Maps.newHashMap();
            List<Map<String, Object>> resultList = Lists.newArrayList();
            for (Map<String, Object> map : list) {
                Map<String, Object> data = Maps.newHashMap();
                data.put("pid", map.get("p_id"));
                data.put("applyName", map.get("menu_nm"));
                data.put("applyCode", map.get("apply_code"));
                data.put("id", map.get("id_key"));
                data.put("authorityId", map.get("authority_id"));
                data.put("menuTp", map.get("menu_tp"));
                data.put("menuLeaf", map.get("data_tp"));
                data.put("specific_tag", map.get("specific_tag"));
                data.put("ifChecked", map.get("if_checked"));
                resultList.add(data);
                menuIdCache.put(data.get("id").toString(), TAG);
            }

            completionMenu(loginUser.getDatasource(), type, resultList, menuIdCache);

            return Response.createSuccess(resultList);
        } else {
            return Response.createSuccess(list);
        }
    }

    private void completionMenu(String database, String type, List<Map<String, Object>> list, Map<String, byte[]> menuIdCache) {
        List<Map<String, Object>> insertList = Lists.newArrayList();
        Iterator<Map<String, Object>> iterator = list.iterator();
        while (iterator.hasNext()) {
            Map<String, Object> menu = iterator.next();
            Integer parentId = (Integer) menu.get("pid");
            getParentMenu(database, parentId, type, menuIdCache, insertList);
        }

        if (Collections3.isNotEmpty(insertList)) {
            list.addAll(insertList);
        }
    }

    private static final byte[] TAG = new byte[0];

    private void getParentMenu(String database, Integer menuId, String type, Map<String, byte[]> menuIdCache, List<Map<String, Object>> insertList) {
        while (MathUtils.valid(menuId)) {
            byte[] tag = menuIdCache.get(menuId.toString());
            if (Objects.nonNull(tag)) {
                return;
            }
            menuIdCache.put(menuId.toString(), TAG);
            SysMenuDTO menuDTO = this.companyRoleService.getMenu(database, menuId, type);
            if (Objects.nonNull(menuDTO)) {
                Map<String, Object> data = Maps.newHashMap();
                data.put("id", menuDTO.getId());
                data.put("pid", menuDTO.getParentId());
                data.put("applyName", menuDTO.getName());
                data.put("menuTp", menuDTO.getMenuType());
                insertList.add(data);

                menuId = (Integer) data.get("pid");
            } else {
                return;
            }
        }
    }

    @ResponseBody
    @PostMapping("salesman/menus")
    public Response saveSalesmanMenus(@RequestBody SalesmanMenusSave input, HttpServletRequest request) {
        SysLoginInfo loginUser = this.getLoginInfo(request);
        this.companyRoleService.updateMemberAuthority(input, loginUser.getDatasource());
        return Response.createSuccess().setMessage("设置成功");
    }
}
