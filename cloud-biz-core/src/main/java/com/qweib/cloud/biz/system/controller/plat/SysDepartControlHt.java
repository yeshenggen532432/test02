package com.qweib.cloud.biz.system.controller.plat;

import com.qweib.cloud.biz.common.GeneralControl;
import com.qweib.cloud.biz.common.Response;
import com.qweib.cloud.biz.system.UserContext;
import com.qweib.cloud.biz.system.controller.plat.vo.DepartmentVO;
import com.qweib.cloud.biz.system.service.plat.SysMemberService;
import com.qweib.cloud.biz.system.service.ws.SysDepartService;
import com.qweib.cloud.core.domain.SysDepart;
import com.qweib.cloud.core.domain.SysLoginInfo;
import com.qweib.cloud.core.domain.SysMemDTO;
import com.qweib.cloud.utils.StrUtil;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;

@Controller
@RequestMapping("/manager")
public class SysDepartControlHt extends GeneralControl {
    @Resource
    private SysDepartService departService;
    @Resource
    private SysMemberService memberService;

    /**
     * 摘要：
     *
     * @return
     * @说明：分类主页
     * @创建：作者:llp 创建时间：2014-8-19
     * @修改历史： [序号](llp 2014 - 8 - 19)<修改说明>
     */
    @RequestMapping("/querydepartht")
    public String querydepartht(String dataTp, Model model) {
        model.addAttribute("dataTp", dataTp);
        return "/companyPlat/depart/depart";
    }

    /**
     * 摘要：
     *
     * @说明：查询分类树
     * @创建：作者:llp 创建时间：2014-8-19
     * @修改历史： [序号](llp 2013 - 4 - 14)<修改说明>
     */

    @RequestMapping("/departs")
    public void areas(Integer id, HttpServletResponse response, HttpServletRequest request, String dataTp) {
        SysLoginInfo info = getLoginInfo(request);
        try {
            if (null == id) {
                id = 0;
            }
            SysDepart depart = new SysDepart();
            depart.setBranchId(id);
            List<SysDepart> departls = this.departService.queryDepart(depart, info.getDatasource(), info.getIdKey(), dataTp);
            if (null != departls && departls.size() > 0) {
                StringBuilder str = new StringBuilder();
                str.append("[");
                String sp = "";
                for (SysDepart depart1 : departls) {
                    int pid = depart1.getParentId();
                    if (id == pid) {
                        Integer branchId = depart1.getBranchId();
                        String branchName = depart1.getBranchName();
                        String leaf = depart1.getBranchLeaf();
                        String state = "open";
                        if ("0".equals(leaf)) {
                            state = "closed";
                        }
                        str.append(sp).append("{\"id\":").append(branchId).append(",\"text\":\"")
                                .append(branchName).append("\",\"state\":\"").append(state).append("\"}");
                        sp = ",";
                    }
                }
                str.append("]");
                this.sendHtmlResponse(response, str.toString());
            }
        } catch (Exception e) {
            log.error("查询分类树出错：", e);
        }
    }

    @RequestMapping("/departree")
    public void departree(Integer id, HttpServletResponse response, HttpServletRequest request) {
        SysLoginInfo info = getLoginInfo(request);
        try {
            List<SysDepart> departls = null;
            if (null == id) {//查询公司
                StringBuilder str = new StringBuilder();
                str.append("[ {\"id\":0").append(",\"text\":\"公司本级")
                        .append("\",\"state\":\"closed").append("\"} ]");
                this.sendHtmlResponse(response, str.toString());
            } else {//查询部门
                SysDepart depart = new SysDepart();
                depart.setBranchId(id);
                departls = this.departService.queryDepart(depart, info.getDatasource(), info.getIdKey(), null);
                if (null != departls && departls.size() > 0) {
                    StringBuilder str = new StringBuilder();
                    str.append("[");
                    String sp = "";
                    for (SysDepart depart1 : departls) {
                        int pid = depart1.getParentId();
                        if (id == pid) {
                            Integer branchId = depart1.getBranchId();
                            String branchName = depart1.getBranchName();
                            String leaf = depart1.getBranchLeaf();
                            String state = "open";
                            if ("0".equals(leaf)) {
                                state = "closed";
                            }
                            str.append(sp).append("{\"id\":").append(branchId).append(",\"text\":\"")
                                    .append(branchName).append("\",\"state\":\"").append(state).append("\"}");
                            sp = ",";
                        }
                    }
                    str.append("]");
                    this.sendHtmlResponse(response, str.toString());
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            log.error("查询分类树出错：", e);
        }
    }


    /**
     * 获取部门以及成员信息的tree
     */
    @RequestMapping("queryDepartMemberTree")
    public void queryDepartMemLsForRole(HttpServletResponse response, HttpServletRequest request, String dataTp) {
        try {
            int id = 0;
            SysLoginInfo info = this.getInfo(request);
            SysDepart depart2 = new SysDepart();
            depart2.setBranchId(id);//id:0全部
            List<SysDepart> departList = this.departService.queryDepart(depart2, info.getDatasource(), info.getIdKey(), dataTp);
//            for (SysDepart depart : departList) {
//                if ("3".equals(dataTp) && member.getBranchId().equals(depart.getBranchId())) {//查询个人部门角色数据，并且部门为当前用户部门
//                    //查询可见部门
//                    String visibleDepts = "," + deptmempowerService.queryPowerDepts(loginDto.getMemId(), "1", loginDto.getDatabase()) + ",";
//                    if (!visibleDepts.contains("," + depart.getBranchId() + ",")) {//可见部门不包含当前部门，则只查询当前用户的信息(如果包含则查询整个部门成员信息)
//                        SysMemDTO memberDTO = new SysMemDTO(member.getMemberId(), member.getMemberNm());
//                        List<SysMemDTO> memList = new ArrayList<SysMemDTO>();
//                        memList.add(memberDTO);
//                        depart.setMemls2(memList);
//                        continue;
//                    }
//                }
//                List<SysMemDTO> sysMemDTOList = this.departService.queryMemByDepartForRole(info.getDatasource(), depart.getBranchId());
//                depart.setMemls2(sysMemDTOList);
//            }

            if (null != departList && departList.size() > 0) {
                String bStr = "";
                String bSp = "";
                bStr = bStr + "[";

                //--------------------员工：start-------------------------
                for (SysDepart depart1 : departList) {
                    String mStr = "";
                    String mSp = "";
                    mStr += "[";
                    List<SysMemDTO> memberList = this.departService.queryMemByDepartForRole(info.getDatasource(), depart1.getBranchId());
                    if(memberList!=null && !memberList.isEmpty()){
                        for (SysMemDTO member : memberList) {
                            int memberId = member.getMemberId();
                            String memberNm = member.getMemberNm();
                            if(!StrUtil.isNull(mSp)){
                                mStr += ",";
                            }
                            mStr += "{";
                            mStr += "\"id\":"+memberId+"";
                            mStr += ",\"text\":\""+memberNm+"\"";
                            mStr += ",\"expanded\":false";
                            mStr += ",\"memberId\":"+memberId+"";
                            mStr += ",\"branchId\":"+null+"";
                            mStr += "}";
                            mSp = ",";
                        }
                    }
                    mStr += "]";
                    //--------------------员工：end-------------------------

                    //--------------------部门：start-------------------------
                    Integer branchId = depart1.getBranchId();
                    String branchName = depart1.getBranchName();
                    if(!StrUtil.isNull(bSp)){
                        bStr += ",";
                    }
                    bStr += "{";
                    bStr += "\"id\":"+branchId+"";
                    bStr += ",\"text\":\""+branchName+"\"";
                    bStr += ",\"expanded\":false";
                    bStr += ",\"memberId\":"+null+"";
                    bStr += ",\"branchId\":"+branchId+"";
                    bStr += ",\"children\":" + mStr + "";
                    bStr += "}";
                    bSp = ",";
                }
                bStr += "]";
                //--------------------部门：end-------------------------

//                //添加：根节点
//                String root = "[";
//                root = root + "{";
//                root = root + "\"id\":0";
//                root = root + ",\"text\":\"根节点\"";
//                root = root + ",\"expanded\":true";
//                root = root + ",\"memberId\":"+null+"";
//                root = root + ",\"branchId\":"+null+"";
//                root = root + ",\"children\":" + wStr + "";
//                root = root + "}";
//                root = root + "]";
//                this.sendHtmlResponse(response, root);
                this.sendHtmlResponse(response, bStr);
            }
        } catch (Exception e) {
           e.printStackTrace();
           log.error("获取部门及员工tree-出错",e);
        }

    }

    /**
     * 摘要：
     *
     * @说明：获取分类
     * @创建：作者:llp 创建时间：2014-8-19
     * @修改历史： [序号](llp 2014 - 8 - 19)<修改说明>
     */
    @RequestMapping("/getdepart")
    public void getarea(Integer id, HttpServletResponse response, HttpServletRequest request) {
        SysLoginInfo info = getLoginInfo(request);
        try {
            if (null == id) {
                id = this.departService.queryOneDepart(info.getDatasource());
            }
            if (null == id) {
                return;
            }
            SysDepart depart = this.departService.queryDepartById(id, info.getDatasource());
            JSONObject json = new JSONObject(depart);
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            e.printStackTrace();
            log.error("获取分类出错：", e);
        }
    }

    /**
     * 摘要：
     *
     * @说明：操作分类
     * @创建：作者:llp 创建时间：2014-8-19
     * @修改历史： [序号](llp 2013 - 4 - 15)<修改说明>
     */
    @RequestMapping("/operdepart")
    public void operarea(HttpServletResponse response, SysDepart depart, HttpServletRequest request) {
        SysLoginInfo info = getLoginInfo(request);
        try {
            int count = this.departService.queryBranchNameCount(depart.getBranchName(), info.getDatasource());
            if (null == depart.getBranchId() || depart.getBranchId() == 0) {
                if (null != depart.getParentId() && depart.getParentId() > 0) {
                    //获取父级分类
//					SysDepart temp = this.departService.queryDepartById(depart.getParentId(), info.getDatasource());
//					String [] strs = temp.getBranchPath().split("-");
//					if(strs.length>=6){
//						this.sendHtmlResponse(response, "-2");
//						return;
//					}
                } else {
                    depart.setParentId(0);
                }
                depart.setBranchLeaf("1");
                if (count > 0) {
                    this.sendHtmlResponse(response, "-3");
                    return;
                } else {
                    this.departService.addDepart(depart, info.getDatasource());
                    this.sendHtmlResponse(response, depart.getBranchId().toString());
                }
            } else {
                if (count > 0 && !depart.getBranchName().equals(depart.getBranchName1())) {
                    this.sendHtmlResponse(response, "-3");
                    return;
                } else {
                    this.departService.updateDepart(depart, info.getDatasource());
                    this.sendHtmlResponse(response, "0");
                }
            }
        } catch (Exception e) {
            log.error("操作分类出错：", e);
            this.sendHtmlResponse(response, "-1");
        }
    }

    /**
     * 部门树
     * @return
     */
    @GetMapping("department/tree")
    @ResponseBody
    public Response departmentTree() {
        List<SysDepart> departs = this.departService.queryDepartLsall(UserContext.getLoginInfo().getDatasource());
        List<DepartmentVO> tree = DepartmentVO.tree(departs);
        return Response.createSuccess(tree);
    }

    /**
     * 摘要：
     *
     * @param id
     * @param response
     * @说明：删除分类
     * @创建：作者:llp 创建时间：2014-8-19
     * @修改历史： [序号](yxy 2014 - 8 - 19)<修改说明>
     */
    @RequestMapping("/deletedepart")
    public void deletearea(Integer id, HttpServletResponse response, HttpServletRequest request) {
        SysLoginInfo info = getLoginInfo(request);
        try {
            SysDepart depart = this.departService.queryDepartById(id, info.getDatasource());
            //父级分类不能删除
            if ("0".equals(depart.getBranchLeaf())) {
                this.sendHtmlResponse(response, "-2");
                return;
            }
            int count = this.memberService.queryBranchId(id,info.getDatasource());
            if(count > 0){
                this.sendHtmlResponse(response,"2");
                return;
            }
            this.departService.deleteDepart(depart, info.getDatasource());
            this.sendHtmlResponse(response, "1");
        } catch (Exception e) {
            log.error("删除分类出错：", e);
            this.sendHtmlResponse(response, "-1");
        }
    }
}
