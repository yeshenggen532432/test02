package com.qweib.cloud.biz.system.controller.plat;

import com.qweib.cloud.biz.common.GeneralControl;
import com.qweib.cloud.biz.system.service.plat.SysMenuService;
import com.qweib.cloud.core.domain.SysMenu;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.utils.TreeMode;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;
import java.util.List;

@Controller
@RequestMapping("/manager")
public class SysMenuControl extends GeneralControl {
    @Resource
    private SysMenuService menuService;

    /**
     * 说明：到菜单管理页面
     * 作者：yxy       日期：2014-3-19
     *
     * @return
     */
    @RequestMapping("/sysMenu")
    public String sysMenu() {
        return "";
        //return "system/menu/sysMenu";
    }

    /**
     * @return
     * @说明：到添加菜单页面
     * @创建：作者:yxy 创建时间：2011-4-26
     */
    @RequestMapping("/addMenuIndex")
    public String addIndex(SysMenu menu, Model model) {
        if (null == menu) {
            menu = new SysMenu();
        }
        menu.setMenuLeaf("1");//明细菜单
        menu.setMenuTp("0");  //功能菜单
        Integer pId = menu.getPId();
        //增加可修改上级菜单选择功能04-13
        String parentMenuName = "顶级菜单";
        if (null != pId) {
            SysMenu sysMenu = this.menuService.queryMenuById(pId);
            if (null != sysMenu) {
                parentMenuName = sysMenu.getMenuNm();
                if (sysMenu.getMenuLeaf().equals("0")) {
                    if (sysMenu.getMenuTp().equals("1")) {
                        model.addAttribute("leftId", pId);
                        model.addAttribute("showMsg", "10");
                        return "system/menu/saveMenu";
                    }
                    menu.setMenuLeaf("0");//不是明细菜单
                    menu.setMenuTp("1");//功能按钮
                }
            }
        } else {
            menu.setPId(0);
        }
        model.addAttribute("parentMenuName", parentMenuName);

        model.addAttribute("menu", menu);
        return "system/menu/addIndex";
    }

    /**
     * @return
     * @说明：添加功能菜单
     * @创建：作者:yxy 创建时间：2011-4-13
     */
    @RequestMapping("/addSysMenu")
    public String addSysMenu(SysMenu menu, Model model) {
        try {
            int count = this.menuService.addMenu(menu);
            if (count > 0) {
                model.addAttribute("menu", menu);
                model.addAttribute("leftId", menu.getIdKey());
                model.addAttribute("showMsg", "1");
                return "system/menu/updateIndex";
            } else {
                model.addAttribute("menu", menu);
                model.addAttribute("leftId", menu.getPId());
                model.addAttribute("showMsg", "4");
                return "system/menu/addIndex";
            }
        } catch (ServiceException ex) {
            this.log.error("数据库添加功能菜单失败：" + ex);
            model.addAttribute("showMsg", "4");
            return "system/menu/addIndex";
        } catch (Exception ex) {
            this.log.error("功能菜单添加失败:" + ex);
            model.addAttribute("showMsg", "4");
            return "system/menu/addIndex";
        }
    }

    /**
     * @return
     * @说明：到功能菜单修改页面
     * @创建：作者:yxy 创建时间：2011-4-14
     */
    @RequestMapping("/updateMenuIndex")
    public String updateIndex(Integer leftId, Model model, String showMsg) {
        try {
            SysMenu menu = this.menuService.queryMenuById(leftId);
            model.addAttribute("menu", menu);
            model.addAttribute("menuSize", this.menuService.getMenuSizeByPid(menu.getPId()));
            model.addAttribute("showMsg", showMsg);

            //增加可修改上级菜单选择功能04-13
            String parentMenuName = "顶级菜单";
            if (menu.getPId() != 0) {
                SysMenu parentMenu = this.menuService.queryMenuById(menu.getPId());
                parentMenuName = parentMenu.getMenuNm();
            }
            model.addAttribute("parentMenuName", parentMenuName);

            return "system/menu/updateIndex";
        } catch (ServiceException de) {
            this.log.error("数据库加载菜单失败:" + de);
            return "main/error";
        } catch (Exception ex) {
            this.log.error("加载菜单失败:" + ex);
            return "main/error";
        }
    }

//    /**
//     * @return
//     * @说明：修改功能菜单
//     * @创建：作者:yxy 创建时间：2011-4-13
//     */
//    @RequestMapping("/updateSysMenu")
//    public String updateSysMenu(SysMenu menu, Model model) {
//        try {
//            this.menuService.updateMenu(menu);
//            model.addAttribute("leftId", menu.getIdKey());
//            model.addAttribute("menu", menu);
//            model.addAttribute("showMsg", "2");
//        } catch (ServiceException ex) {
//            this.log.error("数据库添加功能菜单失败:" + ex);
//            model.addAttribute("showMsg", "5");
//        } catch (Exception ex) {
//            this.log.error("功能菜单修改失败:" + ex);
//            model.addAttribute("showMsg", "5");
//        }
//        return "system/menu/saveMenu";
//    }

    /**
     * @return
     * @说明：查询所有的功能菜单树
     * @创建：作者:yxy 创建时间：2011-4-13
     */
    @RequestMapping("/querySysMenuAll")
    public String querySysMenuAll(Integer id, HttpServletResponse response, Integer menuId) {
        if (id == null) {
            id = 0;//第一次默认菜单id位0
        }
        try {
            List<TreeMode> mls = this.menuService.querySysMenu(id, null, null);
            StringBuilder str = new StringBuilder("[");
            String sp = "";
            for (TreeMode tree : mls) {
                str.append(sp).append("{\"id\":").append(tree.getTreeId()).append(",\"text\":\"").append(tree.getTreeNm()).append("\"");
                if (tree.getTreeLeaf() == 0) {
                    str.append(",\"state\":\"closed\"}");
                } else {
                    str.append("}");
                }
                sp = ",";
            }
            str.append("]");
            this.sendJsonResponse(response, str.toString());
        } catch (Exception e) {
            this.log.error("加载功能菜单树失败:", e);
        }
        return null;
    }

//    /**
//     * 摘要：
//     *
//     * @return
//     * @说明：删除菜单
//     * @创建：作者:yxy 创建时间：2011-7-1
//     * @修改历史： [序号](yxy 2011 - 7 - 1)<修改说明>
//     */
//    @RequestMapping("/deleteMenu")
//    public String deleteMenu(SysMenu menu, Model model) {
//        try {
//            if (null == menu) {
//                model.addAttribute("showMsg", "6");
//                return addIndex(menu, model);
//            }
//            //不存在idKey删除失败
//            Integer idKey = menu.getIdKey();
//            Integer pId = menu.getPId();
//            if (null == idKey || null == pId) {
//                model.addAttribute("showMsg", "6");
//                return addIndex(menu, model);
//            }
//            //存在子菜单不能删除
//            int menuSize = this.menuService.getMenuSizeByPid(idKey);
//            if (menuSize > 0) {
//                model.addAttribute("leftId", idKey);
//                model.addAttribute("showMsg", "18");
//                return "system/menu/saveMenu";
//            }
//            //执行删除
//            this.menuService.deleteMenu(idKey);
//            SysMenu pmenu = this.menuService.queryMenuForDel(pId);
//            if (null == pmenu) {
//                return addIndex(pmenu, model);
//            }
//            model.addAttribute("menu", pmenu);
//            model.addAttribute("showMsg", "3");
//            return "system/menu/updateIndex";
//        } catch (ServiceException ex) {
//            this.log.error("数据库删除功能菜单失败:" + ex);
//            model.addAttribute("showMsg", "6");
//            model.addAttribute("leftId", menu.getIdKey());
//            return "system/menu/saveMenu";
//        } catch (Exception ex) {
//            this.log.error("删除功能菜单失败:" + ex);
//            model.addAttribute("showMsg", "6");
//            model.addAttribute("leftId", menu.getIdKey());
//            return "system/menu/saveMenu";
//        }
//    }

    /**
     * @return
     * @说明：查询所有的功能菜单树
     * @创建：作者:yxy 创建时间：2011-4-13
     */
    @RequestMapping("/querySysMenuChild")
    @ResponseBody
    public List<TreeMode> querySysMenuChild(Integer parentId, HttpServletResponse response) {
        if (parentId == null) {
            parentId = 0;//第一次默认菜单id位0
        }
        try {
            List<TreeMode> mls = this.menuService.querySysMenu(parentId, null, null);
            return mls;
        } catch (Exception e) {
            this.log.error("加载功能菜单树失败:", e);
        }
        return null;
    }
}
