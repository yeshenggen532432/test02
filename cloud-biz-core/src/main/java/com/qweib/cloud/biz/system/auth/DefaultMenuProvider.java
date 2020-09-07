package com.qweib.cloud.biz.system.auth;

import com.google.common.collect.Lists;
import com.qweib.cloud.biz.common.CnlifeConstants;
import com.qweib.cloud.biz.system.service.plat.SysCompanyRoleService;
import com.qweib.cloud.core.domain.SysRole;
import com.qweib.cloud.service.basedata.domain.firm.FirmMenuConfigDTO;
import com.qweib.cloud.service.basedata.domain.firm.FirmMenuConfigQuery;
import com.qweib.cloud.service.basedata.retrofit.FirmMenuConfigRequest;
import com.qweib.commons.StringUtils;
import com.qweibframework.commons.Collections3;
import com.qweibframework.commons.domain.DelFlagEnum;
import com.qweibframework.commons.http.ResponseUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * @author: jimmy.lin
 * @time: 2019/11/15 11:44
 * @description:
 */
@Component
public class DefaultMenuProvider implements MenuProvider {
    //@Autowired
    //private FirmMenuConfigRequest menuApi;
    @Autowired
    private SysCompanyRoleService roleService;

    @Override
    public List<String> getAll() {
//        FirmMenuConfigQuery query = new FirmMenuConfigQuery();
//        query.setDelFlag(DelFlagEnum.NORMAL);
//        List<FirmMenuConfigDTO> menus = ResponseUtils.convertResponse(menuApi.list(query));
//        if (Collections3.isNotEmpty(menus)) {
//            return menus.stream()
//                    .filter(m -> StringUtils.isNotBlank(m.getLink()))
//                    .map(FirmMenuConfigDTO::getLink)
//                    .collect(Collectors.toList());
//        }
        return Lists.newArrayList();
    }

    //TODO fix performance improvement
    @Override
    public List<String> gerRoleMenus(String datasource, List<Integer> roleIds, Integer memberId) {
        List<String> urls = Lists.newArrayList();
        SysRole role = null;
        try {
            // 获取公司管理员角色
            role = roleService.queryRoleByRolecd(CnlifeConstants.ROLE_GSCJZ, datasource);
        } catch (Exception e) {
        }
        if (role != null) {
            List<Map<String, Object>> tmpMenus;
            if (roleIds.contains(role.getIdKey())) {
                // 公司管理员
                tmpMenus = roleService.queryRoleForCompanyAdmin(datasource);
            } else {
                tmpMenus = roleService.queryRoleMenus(memberId, null, datasource);
            }
            if (Collections3.isNotEmpty(tmpMenus)) {
                for (Map<String, Object> tmpMenu : tmpMenus) {
                    String url = (String) tmpMenu.get("menu_url");
                    if(StringUtils.isNotEmpty(url)){
                        urls.add(MenuHelper.trim(url));
                    }
                }
            }
        }
        return urls;
    }
}
