package com.qweib.cloud.biz.api.myzone;

import com.google.common.collect.Lists;
import com.qweib.cloud.biz.api.myzone.vo.MenuVO;
import com.qweib.cloud.repository.utils.HttpResponseUtils;
import com.qweib.cloud.service.member.domain.member.menu.MenuDTO;
import com.qweib.cloud.service.member.domain.member.menu.MenuQuery;
import com.qweib.cloud.service.member.retrofit.MemberMenuRetrofitApi;
import com.qweibframework.commons.Collections3;
import com.qweibframework.commons.web.BaseController;
import com.qweibframework.commons.web.dto.Response;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

/**
 * @author: jimmy.lin
 * @time: 2019/11/8 21:31
 * @description:
 */
@RestController
@RequestMapping("web/myzone/menu")
public class MemberMenuApiController extends BaseController {
//    @Autowired
//    private MemberMenuRetrofitApi memberMenuRetrofitApi;

    @GetMapping
    public Response list() {
//        MenuQuery query = new MenuQuery();
//        query.setEnabled(true);
//        query.setType(1);
//        List<MenuDTO> menus = HttpResponseUtils.convertResponse(memberMenuRetrofitApi.query(query));
        List<MenuVO> menuList = Lists.newArrayList();
//        if (Collections3.isNotEmpty(menus)) {
//            menuList = menus.stream().map(m -> {
//                MenuVO vo = new MenuVO();
//                vo.setApplyCode(m.getCode());
//                vo.setApplyIcon(m.getIcon());
//                vo.setPid(m.getPid());
//                vo.setId(m.getBizId());
//                vo.setApplyName(m.getName());
//                vo.setTp(m.getAppType());
//                vo.setSort(m.getSort() == null ? 0 : m.getSort());
//                return vo;
//            }).sorted(Comparator.comparing(MenuVO::getSort)).collect(Collectors.toList());
//            menuList = MenuVO.toTree(menuList);
//        }
        return success().data(menuList);
    }

}
