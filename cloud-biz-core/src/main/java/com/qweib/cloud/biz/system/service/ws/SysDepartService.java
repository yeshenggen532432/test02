package com.qweib.cloud.biz.system.service.ws;

import com.qweib.cloud.biz.common.CnlifeConstants;
import com.qweib.cloud.biz.system.service.plat.SysCompanyRoleService;
import com.qweib.cloud.core.domain.*;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.repository.company.SysDeptmempowerDao;
import com.qweib.cloud.repository.plat.SysMemberDao;
import com.qweib.cloud.repository.plat.ws.BscInvitationDao;
import com.qweib.cloud.repository.plat.ws.SysCorporationWebDao;
import com.qweib.cloud.repository.plat.ws.SysMemberWebDao;
import com.qweib.cloud.repository.ws.BscEmpGroupWebDao;
import com.qweib.cloud.repository.ws.SysDepartDao;
import com.qweib.cloud.repository.ws.SysMemWebDao;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class SysDepartService {

    @Resource
    private SysDepartDao departDao;
    @Resource
    private SysMemberDao memberDao;
    @Resource
    private BscInvitationDao invitationDao;
    @Resource
    private SysMemberWebDao memberWebDao;
    @Resource
    private SysMemWebDao sysMemWebDao;
    @Resource
    private SysCorporationWebDao companyDao;
    @Resource
    private BscEmpGroupWebDao empGroupDao;
    @Resource
    private SysCompanyRoleService companyRoleService;
    @Resource
    private SysDeptmempowerDao deptmempowerDao;

    /**
     * 摘要：
     *
     * @说明：查询第一个分类
     * @创建：作者:llp 创建时间：2015-2-9
     * @修改历史： [序号](llp 2015 - 2 - 9)<修改说明>
     */
    public Integer queryOneDepart(String datasource) {
        return this.departDao.queryOneDepart(datasource);
    }

    /**
     * 摘要：
     *
     * @说明：根据id查询下级分类
     * @创建：作者:llp 创建时间：2015-2-9
     * @修改历史： [序号](llp 2015 - 2 - 9)<修改说明>
     */
    public List<SysDepart> queryDepart(SysDepart depart, String datasource, Integer memberId, String dataTp) {
        List<SysDepart> deptsList = new ArrayList<SysDepart>();
        if ("1".equals(dataTp)) {
            deptsList = this.departDao.queryDepart(depart, datasource);
        } else if ("2".equals(dataTp)) {//部门及子部门数据
            Integer parentid = depart.getBranchId();
            if (0 == parentid) {//
                Map<String, Object> map = departDao.queryDepartPathByMemId(datasource, memberId);//查询所属部门的部门路径
                String departPath = "";//所属部门的部门路径
                if (null != map.get("dpath") && !StrUtil.isNull(map.get("dpath"))) {
                    departPath = map.get("dpath").toString();
                }
                List<SysDepart> allDepts = this.departDao.queryDepart(depart, datasource);//查询所有子部门信息
                Integer deptId = null;
                for (SysDepart sysDepart : allDepts) {//子部门中包含所属部门的路径下
                    if (departPath.contains(sysDepart.getBranchId() + ",")) {
                        deptId = sysDepart.getBranchId();
                    }
                }
                if (!StrUtil.isNull(deptId)) {//存在子部门中包含所属部门的路径下，则查询部门信息
                    SysDepart d = departDao.queryDepartById(deptId, datasource);
                    deptsList.add(d);
                }
            } else {
                //查询父部门是否在当前部门或当前部门的子部门下
                SysDepart parentDepart = departDao.queryDepartByid(parentid, datasource);//查询父id的部门信息
                SysMember member = memberWebDao.queryAllById(memberId);
                if (parentDepart.getBranchPath().contains("-" + member.getBranchId() + "-")) {//如果父部门为当前部门或者底下的子部门则查询全部子部门信息
                    deptsList = this.departDao.queryDepartLsz(datasource, parentid);//查询所有子部门信息
                } else {//查询当前部门的往上层级部门
                    Map<String, Object> map = departDao.queryDepartPathByMemId(datasource, memberId);//查询所属部门的部门路径
                    String departPath = "";//所属部门的部门路径
                    if (null != map.get("dpath") && !StrUtil.isNull(map.get("dpath"))) {
                        departPath = map.get("dpath").toString();
                    }
                    List<SysDepart> allDepts = this.departDao.queryDepart(depart, datasource);//查询所有子部门信息
                    Integer deptId = null;
                    for (SysDepart sysDepart : allDepts) {//子部门中包含所属部门的路径下
                        if (departPath.contains(sysDepart.getBranchId() + ",")) {
                            deptId = sysDepart.getBranchId();
                        }
                    }
                    if (!StrUtil.isNull(deptId)) {//存在子部门中包含所属部门的路径下，则查询部门信息
                        SysDepart d = departDao.queryDepartById(deptId, datasource);
                        deptsList.add(d);
                    }
                }
            }
        }
        return deptsList;
    }
    //查询公司
	/*public List<SysDepart> queryCompany(String datasource) {
		return departDao.queryCompany(datasource);
	}*/

    /**
     * 摘要：
     *
     * @return
     * @说明：根据id获取分类
     * @创建：作者:llp 创建时间：2015-2-9
     * @修改历史： [序号](llp 2015 - 2 - 9)<修改说明>
     */
    public SysDepart queryDepartById(Integer branchId, String datasource) {
        return this.departDao.queryDepartById(branchId, datasource);
    }

    /**
     * 摘要：
     *
     * @return
     * @说明：修改分类
     * @创建：作者:llp 创建时间：2015-2-9
     * @修改历史： [序号](llp 2015 - 2 - 9)<修改说明>
     */
    public int updateDepart(SysDepart depart, String datasource) {
        return this.departDao.updateDepart(depart, datasource);
    }

    /**
     * 摘要：
     *
     * @return
     * @说明：修改分类leaf
     * @创建：作者:llp 创建时间：2015-2-9
     * @修改历史： [序号](llp 2015 - 2 - 9)<修改说明>
     */
    public int updateDepartLeaf(Integer id, String leaf, String datasource) {
        return this.departDao.updateDepartLeaf(id, leaf, datasource);
    }

    /**
     * 摘要：
     *
     * @说明：删除分类
     * @创建：作者:llp 创建时间：2015-2-9
     * @修改历史： [序号](llp 2015 - 2 - 9)<修改说明>
     */
    public void deleteDepart(SysDepart depart, String datasource) {
        try {
            int count = this.queryDepartInt(depart.getParentId(), datasource);
            if (count == 1) {
                this.departDao.updateDepartLeaf(depart.getParentId(), "1", datasource);
            }
            Integer branchId = depart.getBranchId();
            this.departDao.deleteDepart(branchId, datasource);
            SysCorporation company = companyDao.queryCompanyByDatasource(datasource);

            memberWebDao.updateMemberBranchId(company.getDeptId().intValue(), branchId);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 摘要：
     *
     * @return
     * @说明：获取下级的个数
     * @创建：作者:llp 创建时间：2015-2-9
     * @修改历史： [序号](llp 2015 - 2 - 9)<修改说明>
     */
    public int queryDepartInt(Integer pid, String datasource) {
        return this.departDao.queryDepartInt(pid, datasource);
    }

    /**
     * 摘要：
     *
     * @return
     * @说明：判断分类名称唯一
     * @创建：作者:llp 创建时间：2015-2-9
     * @修改历史： [序号](llp 2015 - 2 - 9)<修改说明>
     */
    public int queryBranchNameCount(String branchName, String datasource) {
        return this.departDao.queryBranchNameCount(branchName, datasource);
    }

    /**
     * @return
     * @说明：获取部门上一级id，名称
     * @创建者： 作者：llp  创建时间：2015-2-7
     */
    public List<SysDepart> queryDepartLssj(String datasource) {
        return this.departDao.queryDepartLssj(datasource);
    }

    /**
     * @return
     * @说明：添加部门
     * @创建者： 作者：llp  创建时间：2015-1-30
     */
    public int addDepart(SysDepart depart, String datasource) {
        try {
            this.departDao.addDepart(depart, datasource);
            Integer autoId = this.departDao.queryAutoId();
            depart.setBranchId(autoId);
            //修改上级leaf为0
            if (null != depart.getParentId() && depart.getParentId() > 0) {
                this.departDao.updateDepartLeaf(depart.getParentId(), "0", datasource);
            }
            //修改path
            String path;
            if (null != depart.getParentId() && depart.getParentId() > 0) {
                SysDepart parent = this.departDao.queryDepartById(depart.getParentId(), datasource);
                path = parent.getBranchPath() + autoId + "-";
            } else {
                path = "-" + autoId + "-";
            }
            this.departDao.updateDepartPath(autoId, path, datasource);
            return autoId;
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * @return
     * @说明：父部门列表
     * @创建者： 作者：llp  创建时间：2015-2-2
     */
    public List<SysDepart> queryDepartLs(OnlineUser user, String dataTp) {
        List<SysDepart> depts = new ArrayList<SysDepart>();
        try {
            String datasource = user.getDatabase();
            Integer memberId = user.getMemId();
            if ("1".equals(dataTp)) {//查询全部的父部门
                depts = this.departDao.queryDepartLs(datasource);
            } else {//个人或部门角色数据查询对应部门的父部门
                depts = departDao.queryDeptsForRole(memberId, datasource);
            }
        } catch (Exception e) {
            throw new ServiceException(e);
        }
        return depts;
    }

    /**
     * @return
     * @说明：父部门id获取子部门列表
     * @创建者： 作者：llp  创建时间：2015-2-7
     */
    public List<SysDepart> queryDepartLsz(OnlineUser user, Integer parentid, String dataTp) {
        List<SysDepart> depts = new ArrayList<SysDepart>();
        try {
            String datasource = user.getDatabase();
            Integer memberId = user.getMemId();
            if ("1".equals(dataTp)) {
                depts = this.departDao.queryDepartLsz(datasource, parentid);//查询所有子部门信息
            } else {
                //查询父部门是否在当前部门或当前部门的子部门下
                SysDepart parentDepart = departDao.queryDepartByid(parentid, datasource);//查询父id的部门信息
                SysMember member = memberWebDao.queryAllById(memberId);
                if (parentDepart.getBranchPath().contains("-" + member.getBranchId() + "-")) {//如果父部门为当前部门或者底下的子部门则查询全部子部门信息
                    depts = this.departDao.queryDepartLsz(datasource, parentid);//查询所有子部门信息
                } else {//查询当前部门的往上层级部门
                    Map<String, Object> map = departDao.queryDepartPathByMemId(datasource, memberId);//查询所属部门的部门路径
                    String departPath = "";//所属部门的部门路径
                    if (null != map.get("dpath") && !StrUtil.isNull(map.get("dpath"))) {
                        departPath = map.get("dpath").toString();
                    }
                    List<SysDepart> allDepts = this.departDao.queryDepartLsz(datasource, parentid);//查询所有子部门信息
                    Integer deptId = null;
                    for (SysDepart sysDepart : allDepts) {//子部门中包含所属部门的路径下
                        if (departPath.contains(sysDepart.getBranchId() + ",")) {
                            deptId = sysDepart.getBranchId();
                        }
                    }
                    if (!StrUtil.isNull(deptId)) {//存在子部门中包含所属部门的路径下，则查询部门信息
                        SysDepart d = departDao.queryDepartById(deptId, datasource);
                        depts.add(d);
                    }
                }
            }
        } catch (Exception e) {
            throw new ServiceException(e);
        }
        return depts;
    }

    /**
     * @return
     * @说明：判断部门底下有没有子部门
     * @创建者： 作者：llp  创建时间：2015-2-7
     */
    public int queryDepartByCount(String datasource, Integer parentid) {
        return this.departDao.queryDepartByCount(datasource, parentid);
    }

    /**
     * @return
     * @说明：根据部门id查底下的人员
     * @创建者： 作者：llp  创建时间：2015-2-2
     */
    public List<SysMemDTO> querySysMemLsByBid(Integer branchId, String datasource, Integer memberId, String tp, String qTp) {
        return this.departDao.querySysMemLsByBid(branchId, datasource, memberId, tp, qTp);
    }

    //根据部门id查底下的人员(当前用户部门或子部门)
    public List<SysMemDTO> querySysMemLsForDepart(Integer parentid,
                                                  String datasource, Integer memberId, Integer branchId) {
        List<SysMemDTO> memLists = new ArrayList<SysMemDTO>();
        String depts = "";
        try {
            Map<String, Object> map = departDao.queryBottomDepts(memberId, datasource);
            if (null != map && !StrUtil.isNull(map.get("depts"))) {//不为空（如:7-9-11-）
                String dpt = (String) map.get("depts");
                depts = dpt.replace("-", ",");//去掉最后一个“-”并转成逗号隔开的字符串
            }
            if (parentid == branchId || depts.contains(parentid.toString() + ",")) {//当前部门或子部门,查询全部
                memLists = departDao.querySysMemLsByBid(branchId, datasource, memberId, "1", null);
            }
        } catch (Exception e) {
            throw new ServiceException(e);
        }
        return memLists;
    }

    /**
     * @return
     * @说明：企业底下还没分配部门的人员
     * @创建者： 作者：llp  创建时间：2015-2-2
     */
    public List<SysMemDTO> querySysMemLs(String datasource, Integer memberId, String tp) {
        return this.departDao.querySysMemLs(datasource, memberId, tp);
    }

    /**
     * 说明：根据部门名称查信息
     *
     * @创建：作者:llp 创建时间：2015-2-6
     * @修改历史： [序号](llp 2015 - 2 - 6)<修改说明>
     */
    public SysDepart querySysDepartByNm(String name, String datasource) {
        return this.departDao.querySysDepartByNm(name, datasource);
    }

    /**
     * @return
     * @说明：获取所有部门
     * @创建者： 作者：llp  创建时间：2015-2-16
     */
    public List<SysDepart> queryDepartLsall(String datasource) {
        return this.departDao.queryDepartLsall(datasource);
    }

    /**
     * 查询部门信息
     *
     * @param deptId
     * @param database
     * @return
     * @创建：作者:YYP 创建时间：2015-3-12
     */
    public SysDepart queryDepartByid(Integer deptId, String database) {
        return this.departDao.queryDepartByid(deptId, database);
    }

    /**
     * 验证成员是否在部门下
     *
     * @param memId
     * @param branchPath
     * @param database
     * @return
     * @创建：作者:YYP 创建时间：2015-3-21
     */
    public Integer queryIsIndept(Integer memId, String branchPath,
                                 String database) {
        return this.departDao.queryIsIndept(memId, branchPath, database);
    }

    /**
     * 邀请人加入公司或部门
     *
     * @param member
     * @param database
     * @param belongId 部门id
     * @param memId
     * @param tp       1 同意 -1不同意
     * @param idTp     1公司 2 部门
     * @创建：作者:YYP 创建时间：2015-3-23
     * @see
     */
    public Integer addMemCompany(SysMember member, String database, Integer belongId, Integer memId, String tp, String idTp) {
        try {
            Integer jude;
            this.memberDao.addSysMem(member, database);
            /**********************添加成员角色*****************/
            companyRoleService.addRolemember(database, member.getMemberId(), CnlifeConstants.ROLE_PTCY);
            if (null != tp) {
                jude = invitationDao.updateInAgree(member.getMemberId(), memId, belongId, tp, idTp);
            } else {
                jude = 1;
            }
            this.memberWebDao.updateMemberBycompany(member.getMemberCompany(), member.getUnitId(), belongId, member.getMemberId(), null);
//            //加入公开圈
//            Map<String, Object> openGroups = empGroupDao.queryOpenGroups(database);//查询公开圈
//            if (null != openGroups.get("ids")) {//加入公开圈
//                String dateTime = DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd HH:mm:ss");
//                String[] groupIds = openGroups.get("ids").toString().split(",");
//                empGroupDao.addOpenGroupMems(groupIds, member.getMemberId(), "3", dateTime, database);
//            }
            return jude;
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 有所属公司加入部门
     *
     * @param belongId
     * @param database
     * @param deptNm
     * @param deptId
     * @param receiveId
     * @param memId
     * @param tp
     * @param idTp
     * @创建：作者:YYP 创建时间：2015-3-23
     */
    public Integer updateMemDept(Integer belongId, String database, String deptNm,
                                 Integer deptId, Integer receiveId, Integer memId, String tp,
                                 String idTp) {
        try {
            Integer jude = invitationDao.updateInAgree(receiveId, memId, belongId, tp, idTp);
            this.sysMemWebDao.updateMemberBranchId(belongId, receiveId, database);
            this.memberWebDao.updateMemberBycompany(deptNm, deptId, belongId, receiveId, null);
            return jude;
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 根据会员id修改部门名称
     */
    public void updateBranchNameByBid(String database, String branchName, Integer branchId) {
        this.departDao.updateBranchNameByBid(database, branchName, branchId);
    }

    /**
     * 判断创建的部门是否已经存在该节点下
     *
     * @param branchName
     * @param database
     * @return
     * @创建：作者:YYP 创建时间：2015-4-10
     */
    public Integer queryIsExistDeptNm(String branchName, Integer parentid, String database) {
        return this.departDao.queryIsExistDeptNm(branchName, parentid, database);
    }

    //修改部门名称
    public void updateDeptNm(Integer deptId, String deptNm, String database) {
        try {
            departDao.updateDeptNm(deptId, deptNm, database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 删除部门
     *
     * @param deptId
     * @param datasource
     * @创建：作者:YYP 创建时间：2015-5-23
     */
    public void deleteDepartId(Integer deptId, String datasource) {
        try {
            this.departDao.deleteDepart(deptId, datasource);
            //sysMemWebDao.updateMemBranchId(deptId, datasource);
            SysCorporation company = companyDao.queryCompanyByDatasource(datasource);
            memberWebDao.updateMemberBranchId(company.getDeptId().intValue(), deptId);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 查询部门列表
     *
     * @param deptId
     * @param datasource
     * @return
     * @创建：作者:YYP 创建时间：2015-5-25
     */
    public List<SysDepart> queryDeptList(Integer deptId, String datasource) {
        try {
            return departDao.queryDeptList(deptId, datasource);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 移动部门
     *
     * @param deptId
     * @param memId
     * @param datasource
     * @创建：作者:YYP 创建时间：2015-5-25
     */
    public void updateBranchId(Integer deptId, Integer memId, String datasource) {
        try {
            sysMemWebDao.updateMemberBranchId(deptId, memId, datasource);
            memberWebDao.updateMemberBycompany(null, null, deptId, memId, null);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 摘要：
     *
     * @说明：查询所有部门信息
     * @创建：作者:llp 创建时间：2016-5-27
     * @修改历史： [序号](llp 2016 - 5 - 27)<修改说明>
     */
    public List<SysDepart> queryDepartAllLs(String datasource, Integer zusrId) {
        try {
            return this.departDao.queryDepartAllLs(datasource, zusrId);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    //查询所有部门信息（包含权限控制）
    public List<SysDepart> queryDepartAllLsForRole(OnlineUser loginDto,
                                                   String dataTp, Integer branchId) {
        try {
            String datasource = loginDto.getDatabase();
            Integer memberId = loginDto.getMemId();
            String depts = "";//部门
            String visibleDepts = "";//可见部门
            String invisibleDepts = "";//不可见部门
            if ("1".equals(dataTp)) {//查询全部部门
                Map<String, Object> allDeptsMap = departDao.queryAllDeptsForMap(datasource);
                if (null != allDeptsMap && !StrUtil.isNull(allDeptsMap.get("depts"))) {//不为空
                    depts = (String) allDeptsMap.get("depts");
                }
            } else if ("2".equals(dataTp)) {//部门及子部门
                Map<String, Object> map = departDao.queryBottomDepts(memberId, datasource);
                if (null != map && !StrUtil.isNull(map.get("depts"))) {//不为空（如:7-9-11-）
                    String dpt = (String) map.get("depts");
                    depts = dpt.substring(0, dpt.length() - 1).replace("-", ",");//去掉最后一个“-”并转成逗号隔开的字符串
                }
            } else if ("3".equals(dataTp)) {//个人
                depts = branchId.toString();
            }
            //查询可见部门(如：-4-，-7-4-)
            visibleDepts = getPowerDepts(datasource, memberId, "1", visibleDepts);
            //查询不可见部门
            invisibleDepts = getPowerDepts(datasource, memberId, "2", invisibleDepts);
            String allDepts = StrUtil.addStr(depts, visibleDepts);//整合要查询的部门和可见部门
            return this.departDao.queryDepartsForRole(datasource, allDepts, invisibleDepts);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    //获取权限部门（可见或不可见）
    private String getPowerDepts(String datasource, Integer memberId, String tp,
                                 String visibleDepts) {
        Map<String, Object> visibleMap = deptmempowerDao.queryPowerDeptsByMemberId(memberId, tp, datasource);
        if (null != visibleMap && !StrUtil.isNull(visibleMap.get("depts"))) {//将查出来的格式（如：-4-，-7-4-）转换成逗号隔开（如：4,7，4）
            visibleDepts = visibleMap.get("depts").toString().replace("-,-", "-");
            visibleDepts = visibleDepts.substring(1, visibleDepts.length() - 1).replace("-", ",");
        }
        return visibleDepts;
    }

    //自定义-部门
    public List<SysDepart> queryDepartsForzdy(String datasource, String mids) {
        try {
            return this.departDao.queryDepartsForzdy(datasource, mids);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    public List<SysMemDTO> queryMemByzdy(String datasource, Integer branchId, String mids) {
        try {
            return this.departDao.queryMemByzdy(datasource, branchId, mids);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 摘要：
     *
     * @说明：根据部门查询成员
     * @创建：作者:llp 创建时间：2016-5-27
     * @修改历史： [序号](llp 2016 - 5 - 27)<修改说明>
     */
    public List<SysMemDTO> queryMemByDepart(String datasource, Integer branchId, Integer zusrId) {
        try {
            return this.departDao.queryMemByDepart(datasource, branchId, zusrId);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    //查询部门下所有成员(角色控制)
    public List<SysMemDTO> queryMemByDepartForRole(String datasource,
                                                   Integer branchId) {
        try {
            return this.departDao.queryMemByDepartForRole(datasource, branchId);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    //	获取部门所有人数
    public int queryMemBmCount(String database, Integer branchId) {
        try {
            return this.departDao.queryMemBmCount(database, branchId);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    //获取部门对应的人数
    public int queryMemBmCountzdy(String database, Integer branchId, String mids) {
        try {
            return this.departDao.queryMemBmCountzdy(database, branchId, mids);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    //查所有部门
    public List<SysDepart> queryDepartsForAllz(String datasource) {
        try {
            return this.departDao.queryDepartsForAllz(datasource);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 获取可见部门和不可见部门
     * @param datasource
     * @param dataTp
     * @param mid
     * @return
     */
    public Map<String, Object> getVisibleInVisibleBranchMap(String datasource, String dataTp, int mid){
        Map<String, Object> resultMap = new HashMap<>();

        String visibleBranch = "";//可见部门
        String invisibleBranch = "";//不可见部门
        String branchs = "";//部门
        if ("1".equals(dataTp)){//查询全部部门
            Map<String, Object> allBranchMap = this.departDao.queryAllDeptsForMap(datasource);
            if (null != allBranchMap && !StrUtil.isNull(allBranchMap.get("depts"))) {//不为空
                branchs = (String) allBranchMap.get("depts");
            }
        } else if ("2".equals(dataTp)){//部门及子部门
            Map<String, Object> map = this.departDao.queryBottomDepts(mid, datasource);
            if (null != map && !StrUtil.isNull(map.get("depts"))) {//不为空（如:7-9-11-）
                String dpt = (String) map.get("depts");
                branchs = dpt.substring(0,dpt.length()-1).replace("-", ",");//去掉最后一个“-”并转成逗号隔开的字符串
            }
        }
        //查询可见部门(如：-4-，-7-4-)
        visibleBranch = getPowerDepts(datasource, mid, "1", visibleBranch);
        //查询不可见部门
        invisibleBranch = getPowerDepts(datasource, mid, "2", invisibleBranch);
        visibleBranch = StrUtil.addStr(branchs, visibleBranch);//整合要查询的部门和可见部门

        resultMap.put("visibleBranch",visibleBranch);
        resultMap.put("invisibleBranch",invisibleBranch);
        return resultMap;
    }


}
