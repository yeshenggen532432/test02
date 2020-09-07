package com.qweib.cloud.biz.system.controller;

import com.google.common.collect.Lists;
import com.qweib.cloud.biz.common.CompanyRoleEnum;
import com.qweib.cloud.biz.common.GeneralControl;
import com.qweib.cloud.biz.system.service.SysQuickMenuService;
import com.qweib.cloud.biz.system.service.plat.SysCompanyRoleService;
import com.qweib.cloud.core.domain.SysApplyDTO;
import com.qweib.cloud.core.domain.SysLoginInfo;
import com.qweib.cloud.core.domain.SysQuickMenu;
import com.qweib.cloud.core.domain.dto.SysRoleMemberDTO;
import com.qweib.cloud.utils.DateTimeUtil;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import com.qweib.commons.StringUtils;
import net.sf.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.*;

@Controller
@RequestMapping("/manager/sysQuickMenu")
public class SysQuickMenuControl  extends GeneralControl {
    @Resource
    private SysQuickMenuService sysQuickMenuService;
    @Resource
    private SysCompanyRoleService companyRoleService;
    @RequestMapping("/pages")
    public void pages(HttpServletRequest request, HttpServletResponse response, SysQuickMenu vo, Integer page, Integer rows) {
        SysLoginInfo info = this.getLoginInfo(request);
        try {
            if (StringUtils.isBlank(info.getDatasource())) {
                JSONObject json = new JSONObject();
                json.put("state", true);
                json.put("total", 0);
                json.put("rows", Lists.newArrayListWithCapacity(0));
                this.sendJsonResponse(response, json.toString());
                return;
            }
            if(vo==null){
               // vo.setMemberId(info.getIdKey());
                 vo = new SysQuickMenu();
            }
            vo.setMemberId(info.getIdKey());
            List<SysRoleMemberDTO> roleMemberDTOS = companyRoleService.getRoleMemberByMemberId(info.getDatasource(), info.getIdKey());
            Boolean hasAdmin = roleMemberDTOS.stream()
                    .filter(e -> StringUtils.isNotBlank(e.getRoleCode()))
                    .map(roleMemberDTO -> CompanyRoleEnum.hasAdmin(roleMemberDTO.getRoleCode()))
                    .filter(e -> e)
                    .findFirst()
                    .orElse(false);
            List<SysApplyDTO> applyDTOS;
            // 如果有包含管理员角色，默认获得所有权限
            if (hasAdmin) {
                applyDTOS = this.companyRoleService.queryAdminRoleMenus(info.getDatasource(), "1");
            } else {
                applyDTOS = this.companyRoleService.queryRoleMenus(info.getDatasource(), info.getIdKey() , "1");
            }
            String menuIds ="";

            if(applyDTOS!=null&&applyDTOS.size()>0){
                for(int i=0;i<applyDTOS.size();i++){
                    SysApplyDTO dto = applyDTOS.get(i);
                    if("1".equals(dto.getMenuTp())){
                        continue;
                    }
                    if(!StrUtil.isNull(menuIds)){
                        menuIds = menuIds+",";
                    }
                    menuIds = menuIds+dto.getId();
                }
            }
            Page p = this.sysQuickMenuService.pages(vo,menuIds, info.getDatasource(), page, rows);
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("total", p.getTotal());
            json.put("rows", p.getRows());
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            e.printStackTrace();
            log.error("查询快捷菜单设置出错",e);
        }
    }

    @RequestMapping("/quick")
    public void quick(HttpServletRequest request, HttpServletResponse response, SysQuickMenu vo, Integer page, Integer rows) {
        SysLoginInfo info = this.getLoginInfo(request);
        try {
            if (StringUtils.isBlank(info.getDatasource())) {
                JSONObject json = new JSONObject();
                json.put("state", true);
                json.put("total", 0);
                json.put("rows", Lists.newArrayListWithCapacity(0));
                this.sendJsonResponse(response, json.toString());
                return;
            }
            if(vo==null){
                // vo.setMemberId(info.getIdKey());
                vo = new SysQuickMenu();
            }
            vo.setMemberId(info.getIdKey());
            List<SysRoleMemberDTO> roleMemberDTOS = companyRoleService.getRoleMemberByMemberId(info.getDatasource(), info.getIdKey());
            Boolean hasAdmin = roleMemberDTOS.stream()
                    .filter(e -> StringUtils.isNotBlank(e.getRoleCode()))
                    .map(roleMemberDTO -> CompanyRoleEnum.hasAdmin(roleMemberDTO.getRoleCode()))
                    .filter(e -> e)
                    .findFirst()
                    .orElse(false);
            List<SysApplyDTO> applyDTOS;
            // 如果有包含管理员角色，默认获得所有权限
            if (hasAdmin) {
                applyDTOS = this.companyRoleService.queryAdminRoleMenus(info.getDatasource(), "1");
            } else {
                applyDTOS = this.companyRoleService.queryRoleMenus(info.getDatasource(), info.getIdKey() , "1");
            }
            String menuIds ="";

            if(applyDTOS!=null&&applyDTOS.size()>0){
                for(int i=0;i<applyDTOS.size();i++){
                    SysApplyDTO dto = applyDTOS.get(i);
                    if("1".equals(dto.getMenuTp())){
                        continue;
                    }
                    if(!StrUtil.isNull(menuIds)){
                        menuIds = menuIds+",";
                    }
                    menuIds = menuIds+dto.getId();
                }
            }
            Page p = this.sysQuickMenuService.pages(vo,menuIds, info.getDatasource(), page, rows);
            if(p.getRows().size()==0){
                List<SysQuickMenu> defaultList = new ArrayList<SysQuickMenu>();
                String menuNms = ",收货款管理,付款款管理,销售开票,采购开票,发货管理,收货管理,库存查询,销售退货,商品管理,客户管理,";
                Map<String,String> menuMap = new HashMap<String,String>();
                if(applyDTOS!=null&&applyDTOS.size()>0){
                    for(int i=0;i<applyDTOS.size();i++){
                        SysApplyDTO dto = applyDTOS.get(i);
                        if("1".equals(dto.getMenuTp())){
                            continue;
                        }
                        if(menuNms.contains(","+dto.getApplyName()+",")){
                            if(menuMap.containsKey(dto.getId()+"_"+dto.getApplyName())){
                                continue;
                            }
                            if(StrUtil.isNull(dto.getApplyUrl())){
                                continue;
                            }
                            menuMap.put(dto.getId()+"_"+dto.getApplyName(),dto.getApplyName());
                            SysQuickMenu sqm = new SysQuickMenu();
                            sqm.setMenuId(dto.getId());
                            sqm.setMemberId(info.getIdKey());
                            sqm.setApplyUrl(dto.getApplyUrl());
                            sqm.setMenuName(dto.getApplyName());
                            defaultList.add(sqm);
                            sysQuickMenuService.add(sqm,info.getDatasource());
                        }
                    }
                    //p.getRows().addAll(defaultList);
                }
                p = this.sysQuickMenuService.pages(vo,menuIds, info.getDatasource(), page, rows);
            }
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("total", p.getTotal());
            json.put("rows", p.getRows());
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            e.printStackTrace();
            log.error("查询快捷菜单设置出错",e);
        }
    }

    @RequestMapping("/toPage")
    public String toPage(Model model, HttpServletRequest request){
        SysLoginInfo info = this.getLoginInfo(request);
        return "system/sysQuickMenu/sysQuickMenu_page";
    }

    @RequestMapping("/save")
    public void save(HttpServletRequest request, HttpServletResponse response,SysQuickMenu vo) {
        SysLoginInfo info = this.getLoginInfo(request);
        try {
            Integer id = 0;
            String menuId = request.getParameter("menuId");
            vo.setCreateTime(DateTimeUtil.getDateToStr(new Date(),"yyyy-MM-dd HH:mm:ss"));
            vo.setMemberId(info.getIdKey());
            if(!StrUtil.isNull(menuId)){
                vo.setMenuId(Integer.valueOf(menuId));
            }
            SysQuickMenu mvo = null;

            if(!StrUtil.isNull(vo.getMenuId())){
                mvo = this.sysQuickMenuService.getByMenuId(vo,info.getDatasource());
            }
            if(mvo==null){
                id =	this.sysQuickMenuService.add(vo, info.getDatasource());
            }else{
                id = mvo.getId();
            }
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("id", id);
            json.put("msg", "保存成功!");
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            e.printStackTrace();
            log.error("保存快捷菜单设置出错",e);
        }
    }

    /**
     * 修改排序
     * @param request
     * @param id
     * @param sort
     * @return
     */
    @ResponseBody
    @RequestMapping("/updateSort")
    public int updateSort(HttpServletRequest request,Integer id,Integer sort){
        try{
            SysLoginInfo loginInfo = this.getLoginInfo(request);
            SysQuickMenu sysQuickMenu = this.sysQuickMenuService.queryById(id, loginInfo.getDatasource());
            sysQuickMenu.setSort(sort);
            this.sysQuickMenuService.updateSort(sysQuickMenu,loginInfo.getDatasource());
        }catch (Exception e){
            e.printStackTrace();
            log.error("修改快捷菜单排序出错：", e);
        }
        return 0;

    }

    @RequestMapping("delete")
    public void delete(Integer id, HttpServletResponse response, HttpServletRequest request){
        try {
            SysLoginInfo info = this.getLoginInfo(request);
            this.sysQuickMenuService.delete(id, info.getDatasource());
            this.sendHtmlResponse(response, "1");
        } catch (Exception e) {
            log.error("删除快捷菜单设置出错：", e);
            this.sendHtmlResponse(response, "-1");
        }
    }

    @RequestMapping("/edit")
    public String edit(HttpServletRequest request, HttpServletResponse response,Integer id) {
        SysLoginInfo info = this.getLoginInfo(request);
        SysQuickMenu vo  = new SysQuickMenu();
        if(StrUtil.isNull(id)){
        }else{
            vo  =	this.sysQuickMenuService.getById(id, info.getDatasource());
        }
        request.setAttribute("vo", vo);
        return "system/sysQuickMenu/sysQuickMenu_edit";
    }
}
