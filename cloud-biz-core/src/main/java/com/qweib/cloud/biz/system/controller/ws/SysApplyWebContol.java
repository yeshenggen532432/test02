package com.qweib.cloud.biz.system.controller.ws;


import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.google.common.collect.Ordering;
import com.qweib.cloud.biz.api.myzone.vo.MenuVO;
import com.qweib.cloud.biz.system.BaseWebService;
import com.qweib.cloud.biz.system.TokenServer;
import com.qweib.cloud.biz.system.UserContext;
import com.qweib.cloud.biz.system.service.plat.SysApplyService;
import com.qweib.cloud.biz.system.utils.MenuUtils;
import com.qweib.cloud.core.domain.*;
import com.qweib.cloud.repository.utils.HttpResponseUtils;
import com.qweib.cloud.service.member.domain.member.menu.MenuDTO;
import com.qweib.cloud.service.member.domain.member.menu.MenuQuery;
import com.qweib.cloud.service.member.retrofit.MemberMenuRetrofitApi;
import com.qweib.cloud.utils.Collections3;
import com.qweib.cloud.utils.StrUtil;
import com.qweibframework.commons.StringUtils;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;
import java.util.*;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/web")
public class SysApplyWebContol extends BaseWebService {
    @Resource
    private SysApplyService applyService;
//    @Autowired
//    private MemberMenuRetrofitApi memberMenuRetrofitApi;

    /**
     * 获取应用列表
     *
     * @param response
     * @param token
     */
    @RequestMapping("queryApplyByMemberRole")
    public void queryApplyByMemberRole(HttpServletResponse response, String token) {
        try {
            if (!checkParam(response, token)) {
                return;
            }
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (!message.isSuccess()) {
                sendWarm(response, message.getMessage());
                return;
            }
            OnlineUser loginDto = message.getOnlineMember();
            List<SysApplyDTO> uglcwList = null;

            if (!StrUtil.isNull(loginDto.getDatabase())) {
                uglcwList = applyService.queryApplyByMemberRole(loginDto.getMemId(), "uglcw", loginDto.getDatabase());
                List<SysApplyDTO> qwfwList = applyService.queryApplyByMemberRole(loginDto.getMemId(), "qwfw", loginDto.getDatabase());
                if (Collections3.isNotEmpty(qwfwList)) {
                    uglcwList.addAll(qwfwList);
                }
            }

            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "获取应用列表成功");
            json.put("applyList", uglcwList);
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            e.printStackTrace();
            this.sendWarm(response, "获取应用列表失败");
        }
    }

    @RequestMapping("menus")
    @ResponseBody
    public Map<String, Object> getNewMenuList() {
        SysLoginInfo loginDto = UserContext.getLoginInfo();
        Map<String, Object> json = Maps.newHashMap();
        json.put("state", true);
        json.put("msg", "获取应用列表成功");
        List<MenuVO> myZoneMenus = getMyZoneMenus();
        if (!StrUtil.isNull(loginDto.getDatasource())) {
            List<SysApplyShowDTO> uglcwList = applyService.queryApplyByMemberRole(loginDto.getIdKey(), loginDto.getDatasource());
            List filterMenuList = Lists.newArrayListWithCapacity(uglcwList.size());
            filterMenus(uglcwList, filterMenuList, 0);
            if (Collections3.isNotEmpty(filterMenuList)) {
                final Ordering<SysApplyShowDTO> menuOrdering = MenuUtils.makeMenuOrdering();

                sortMenus(filterMenuList, menuOrdering);
            }
            filterMenuList.addAll(myZoneMenus);
            json.put("applyList", filterMenuList);
        } else {
            json.put("applyList", Lists.newArrayList(myZoneMenus));
        }
        return json;
    }

    private List<MenuVO> getMyZoneMenus() {
        MenuQuery query = new MenuQuery();
        query.setEnabled(true);
        query.setType(1);
        //List<MenuDTO> menus = HttpResponseUtils.convertResponse(memberMenuRetrofitApi.query(query));
        List<MenuVO> menuList = Lists.newArrayList();
//        if (com.qweibframework.commons.Collections3.isNotEmpty(menus)) {
//            menuList = menus.stream().map(m -> {
//                MenuVO vo = new MenuVO();
//                vo.setApplyCode(m.getCode());
//                vo.setApplyIcon(m.getIcon());
//                vo.setPid(m.getPid());
//                vo.setId(m.getBizId());
//                vo.setApplyName(m.getName());
//                vo.setTp(m.getAppType());
//                vo.setApplyUrl(m.getLink());
//                vo.setSort(m.getSort() == null ? 0 : m.getSort());
//                return vo;
//            }).sorted(Comparator.comparing(MenuVO::getSort)).collect(Collectors.toList());
//            menuList = MenuVO.toTree(menuList);
//        }
        return menuList;
    }

    private static final String[] filterMenuCodes = new String[]{"uglcw", "qwfw"};

    private static void filterMenus(List<SysApplyShowDTO> sourceMenus, List<SysApplyShowDTO> targetMenus, Integer parentId) {
        for (SysApplyShowDTO sourceMenu : sourceMenus) {
            if (StringUtils.containsAny(sourceMenu.getApplyCode(), filterMenuCodes)) {
                continue;
            }
            Integer pId = Optional.ofNullable(sourceMenu.getPId()).orElse(0);
            if (Objects.equals(pId, parentId)) {
                targetMenus.add(sourceMenu);
                sourceMenu.setChildren(new ArrayList<>());
                filterMenus(sourceMenus, sourceMenu.getChildren(), sourceMenu.getId());
            }
        }
    }

    private static void sortMenus(List<SysApplyShowDTO> menuList, final Ordering<SysApplyShowDTO> menuOrdering) {
        Collections.sort(menuList, menuOrdering);
        for (SysApplyShowDTO showDTO : menuList) {
            if (Collections3.isNotEmpty(showDTO.getChildren())) {
                sortMenus(showDTO.getChildren(), menuOrdering);
            }
        }
    }
}
