package com.qweib.cloud.biz.system.service.plat;


import com.qweib.cloud.core.domain.SysApplyDTO;
import com.qweib.cloud.core.domain.SysCorporation;
import com.qweib.cloud.core.domain.SysMenu;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.repository.company.SysMenuApplyDao;
import com.qweib.cloud.repository.plat.SysCorporationDao;
import com.qweib.cloud.repository.plat.SysMenuDao;
import com.qweib.cloud.utils.StrUtil;
import com.qweibframework.commons.StringUtils;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Service
public class SysMenuApplyService {
    @Resource
    private SysMenuApplyDao sysMenuApplyDao;
    @Resource
    private SysCorporationDao sysCorporationDao;
    @Resource
    private SysMenuDao menuDao;

    /**
     * 公司分配菜单应用
     *
     * @param menuIds
     * @param deptId
     */
    public String updateCompanyMenuApply(Integer[] menuIds, Integer deptId, String tp) {
        String rst = "";
        try {
            //根据id查询公司信息
            SysCorporation corporation = sysCorporationDao.queryCorporationById(deptId);
            //删除已分配的菜单应用
            //查询关联的菜单或应用
            String ids = "";
            Map<String, Object> map = sysMenuApplyDao.queryBindIds(corporation.getDatasource(), tp);
            if (!StrUtil.isNull(map.get("ids"))) {//不为空
                ids = (String) map.get("ids");
            }
            this.sysMenuApplyDao.deleteMenuApplys(corporation.getDatasource(), tp, ids);
            //批量添加公司菜单应用/
            if (null != menuIds && menuIds.length > 0) {
                String mIds = StringUtils.join(menuIds, ",");
                //根据数组id查询所有的菜单应用
                List<SysApplyDTO> menuApplyList = new ArrayList<SysApplyDTO>();
                List<SysApplyDTO> list = new ArrayList<SysApplyDTO>();
                if ("1".equals(tp)) {//菜单
                    menuApplyList = sysMenuApplyDao.queryMenuByIds(mIds);
                    list = sysMenuApplyDao.queryBindApply(mIds);//查询绑定的应用
                } else {//应用
                    menuApplyList = sysMenuApplyDao.queryApplyByIds(mIds);
                    list = sysMenuApplyDao.queryBindMenu(mIds);//查询绑定的菜单
                    /******************************查询绑定的父菜单是否已经添加，未添加进行补齐***************/
                    String pIds = "";
                    for (SysApplyDTO sysApplyDTO : list) {//递归查询绑定的id的父级是否需要添加
                        pIds = getPid(sysApplyDTO.getId(), pIds);
                    }
                    if (!StrUtil.isNull(pIds)) {//有存在父id
                        List<SysApplyDTO> pIdList = sysMenuApplyDao.queryMenuByIds(pIds.substring(0, pIds.length() - 1));
                        menuApplyList.addAll(pIdList);
                    }
                    /******************************查询绑定的父菜单是否已经添加，未添加进行补齐***************/
                }
                menuApplyList.addAll(list);
                //批量添加公司菜单
                this.sysMenuApplyDao.saveCorporationMenuApply(menuApplyList, corporation.getDatasource());
            }
            rst = corporation.getDatasource();
        } catch (Exception ex) {
            throw new ServiceException(ex);
        }
        return rst;
    }

    //递归查询父id
    private String getPid(Integer id, String pIds) {
        SysMenu menu = menuDao.queryMenuById(id);//查询菜单信息
        if (menu.getPId() != 0) {
            if (!pIds.contains(menu.getPId() + ",")) {
                pIds = menu.getPId() + ",";
            }
            getPid(menu.getPId(), pIds);
        }
        return pIds;
    }


}
