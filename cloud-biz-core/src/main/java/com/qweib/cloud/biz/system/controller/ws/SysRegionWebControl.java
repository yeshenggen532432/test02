package com.qweib.cloud.biz.system.controller.ws;

import com.qweib.cloud.biz.system.BaseWebService;
import com.qweib.cloud.biz.system.UserContext;
import com.qweib.cloud.biz.system.service.SysRegionService;
import com.qweib.cloud.core.domain.SysLoginInfo;
import com.qweib.cloud.core.domain.SysRegion;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 客户所属区域
 */
@Controller
@RequestMapping("/web")
public class SysRegionWebControl extends BaseWebService {
    @Resource
    private SysRegionService regionService;

    @ResponseBody
    @RequestMapping("/queryRegionTree")
    public Map<String, Object> queryRegionTree(String token) {
        SysLoginInfo loginInfo = UserContext.getLoginInfo();
        SysRegion type = new SysRegion();
        type.setRegionId(0);
        List<SysRegion> regions = this.regionService.queryList(type, loginInfo.getDatasource());
        Map<String, Object> map = new HashMap<>();
        map.put("state", true);
        map.put("msg", "获取客户所属区域成功");
        map.put("list", regions);
        return map;
    }


}
