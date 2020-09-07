package com.qweib.cloud.biz.system.controller.plat;

import com.qweib.cloud.biz.common.GeneralControl;
import com.qweib.cloud.biz.system.service.plat.SysApplyService;
import com.qweib.cloud.core.domain.SysApplyDTO;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.utils.TreeMode;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;
import java.util.List;

@Controller
@RequestMapping("/manager")
public class SysApplyControl extends GeneralControl {
    @Resource
    private SysApplyService sysApplyService;

    /**
     * 到移动端应用管理页面
     *
     * @return
     */
    @RequestMapping("sysApply")
    public String toApply() {
        return "system/apply/sysApply";
    }

    /**
     * @return
     * @说明：到添加菜单页面
     * @创建：作者:yxy 创建时间：2011-4-26
     */
    @RequestMapping("/addApplyIndex")
    public String addIndex(SysApplyDTO applyDTO, Model model) {
        if (null == applyDTO) {
            applyDTO = new SysApplyDTO();
        }
        applyDTO.setMenuLeaf("1");//默认明细菜单
        applyDTO.setMenuTp("0");  //默认功能菜单
        Integer pId = applyDTO.getPId();
        if (null != pId) {
            SysApplyDTO sysApplyDTO = this.sysApplyService.queryApplyById(pId);
            if (null != sysApplyDTO) {
                if (sysApplyDTO.getMenuLeaf().equals("0")) {
                    if (sysApplyDTO.getMenuTp().equals("1")) {
                        model.addAttribute("leftId", pId);
                        model.addAttribute("showMsg", "10");
                        return "system/apply/saveApply";
                    }
                    applyDTO.setMenuLeaf("0");//不是明细菜单
                    applyDTO.setMenuTp("1");//功能按钮
                }
            }
        } else {
            applyDTO.setPId(0);
        }
        model.addAttribute("applyDTO", applyDTO);
        return "system/apply/addIndex";
    }

    /**
     * @return
     * @说明：添加功能菜单
     * @创建：作者:yxy 创建时间：2011-4-13
     */
    @RequestMapping("/addSysApply")
    public String addSysApply(SysApplyDTO applyDTO, Model model) {
        try {
            int count = this.sysApplyService.addApply(applyDTO);
            if (count > 0) {
                model.addAttribute("applyDTO", applyDTO);
                model.addAttribute("leftId", applyDTO.getId());
                model.addAttribute("showMsg", "1");
                return "system/apply/updateIndex";
            } else {
                model.addAttribute("applyDTO", applyDTO);
                model.addAttribute("leftId", applyDTO.getPId());
                model.addAttribute("showMsg", "4");
                return "system/apply/addIndex";
            }
        } catch (ServiceException ex) {
            this.log.error("数据库添加应用失败：" + ex);
            model.addAttribute("showMsg", "4");
            return "system/apply/addIndex";
        } catch (Exception ex) {
            this.log.error("功能应用添加失败:" + ex);
            model.addAttribute("showMsg", "4");
            return "system/apply/addIndex";
        }
    }

    /**
     * @return
     * @说明：到功能菜单修改页面
     * @创建：作者:yxy 创建时间：2011-4-14
     */
    @RequestMapping("/updateApplyIndex")
    public String updateIndex(Integer leftId, Model model, String showMsg) {
        try {
            SysApplyDTO applyDTO = this.sysApplyService.queryApplyById(leftId);
            model.addAttribute("applyDTO", applyDTO);
            model.addAttribute("menuSize", this.sysApplyService.getApplySizeByPid(applyDTO.getPId()));
            model.addAttribute("showMsg", showMsg);
            return "system/apply/updateIndex";
        } catch (ServiceException de) {
            this.log.error("数据库加载失败:" + de);
            return "main/error";
        } catch (Exception ex) {
            this.log.error("加载应用失败:" + ex);
            return "main/error";
        }
    }

    /**
     * @return
     * @说明：修改功能菜单
     * @创建：作者:yxy 创建时间：2011-4-13
     */
    @RequestMapping("/updateSysApply")
    public String updateSysApply(SysApplyDTO applyDTO, Model model) {
        try {
            this.sysApplyService.updateApply(applyDTO);
            model.addAttribute("leftId", applyDTO.getId());
            model.addAttribute("applyDTO", applyDTO);
            model.addAttribute("showMsg", "2");
        } catch (ServiceException ex) {
            this.log.error("数据库添加功能应用失败:" + ex);
            model.addAttribute("showMsg", "5");
        } catch (Exception ex) {
            this.log.error("功能应用修改失败:" + ex);
            model.addAttribute("showMsg", "5");
        }
        return "system/apply/saveApply";
    }

    /**
     * @return
     * @说明：查询所有的功能菜单树
     * @创建：作者:yxy 创建时间：2011-4-13
     */
    @RequestMapping("/querySysApplyAll")
    public String querySysApplyAll(Integer leftId, HttpServletResponse response) {
        if (leftId == null) {
            leftId = 0;//第一次默认菜单id位0
        }
        try {
            List<TreeMode> mls = this.sysApplyService.querySysApply(leftId);
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
            this.log.error("加载功能应用树失败:", e);
        }
        return null;
    }

    /**
     * 摘要：
     *
     * @return
     * @说明：删除应用
     * @创建：作者:yxy 创建时间：2011-7-1
     * @修改历史： [序号](yxy 2011 - 7 - 1)<修改说明>
     */
    @RequestMapping("/deleteApply")
    public String deleteApply(SysApplyDTO applyDTO, Model model) {
        try {
            if (null == applyDTO) {
                model.addAttribute("showMsg", "6");
                return addIndex(applyDTO, model);
            }
            //不存在idKey删除失败
            Integer idKey = applyDTO.getId();
            Integer pId = applyDTO.getPId();
            if (null == idKey || null == pId) {
                model.addAttribute("showMsg", "6");
                return addIndex(applyDTO, model);
            }
            //存在子菜单不能删除
            int applySize = this.sysApplyService.getApplySizeByPid(idKey);
            if (applySize > 0) {
                model.addAttribute("leftId", idKey);
                model.addAttribute("showMsg", "18");
                return "system/apply/saveApply";
            }
            //执行删除
            this.sysApplyService.deleteApply(idKey);
            SysApplyDTO pApply = this.sysApplyService.queryApplyForDel(pId);
            if (null == pApply) {
                return addIndex(pApply, model);
            }
            model.addAttribute("pApply", pApply);
            model.addAttribute("showMsg", "3");
            return "system/apply/updateIndex";
        } catch (ServiceException ex) {
            this.log.error("数据库删除功能应用失败:" + ex);
            model.addAttribute("showMsg", "6");
            model.addAttribute("leftId", applyDTO.getId());
            return "system/apply/saveApply";
        } catch (Exception ex) {
            this.log.error("删除功能应用失败:" + ex);
            model.addAttribute("showMsg", "6");
            model.addAttribute("leftId", applyDTO.getId());
            return "system/apply/saveApply";
        }
    }
}
