package com.qweib.cloud.repository;

import com.google.common.collect.Lists;
import com.qweib.cloud.core.dao.JdbcDaoTemplatePlud;
import com.qweib.cloud.core.domain.SysArea;
import com.qweib.cloud.repository.utils.HttpResponseUtils;
import com.qweib.cloud.service.member.domain.basedata.SysAreaDTO;
import com.qweib.cloud.service.member.retrofit.SysAreaRetrofitApi;
import com.qweib.cloud.utils.Collections3;
import com.qweib.commons.mapper.BeanMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.List;
import java.util.stream.Collectors;

/**
 * 地区DAO
 *
 * @author zzx
 */
@Repository
public class SysAreaDao {

    @Resource(name = "pdaoTemplate")
    private JdbcDaoTemplatePlud pdaoTemplate;

//    @Autowired
//    private SysAreaRetrofitApi api;

    /**
     * 根据上级ID获取子数据
     *
     * @param parentId
     * @return
     */
    public List<SysArea> getChild(Integer parentId) {
//        List<SysAreaDTO> areas = HttpResponseUtils.convertResponse(api.getChildren(parentId));
//        if (Collections3.isNotEmpty(areas)) {
//            return areas.stream().map(
//                    a -> {
//                        SysArea area = BeanMapper.map(a, SysArea.class);
//                        area.setAreaId(a.getId());
//                        return area;
//                    }
//            ).collect(Collectors.toList());
//        }
        String sql = "select * from publicplat.sys_area where area_parent_id=" + parentId;
        return this.pdaoTemplate.queryForLists(sql,SysArea.class);
    }
}
