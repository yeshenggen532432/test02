package com.qweib.cloud.biz.system.service.plat;

import com.google.common.collect.Lists;
import com.qweib.cloud.biz.common.*;
import com.qweib.cloud.biz.system.QiniuControl;
import com.qweib.cloud.biz.system.controller.plat.vo.importVo.ImportResults;
import com.qweib.cloud.biz.system.controller.plat.vo.importVo.ImportSysMemberVo;
import com.qweib.cloud.biz.system.service.SysInportTempService;
import com.qweib.cloud.biz.system.service.ws.SysDepartService;
import com.qweib.cloud.biz.system.utils.MemberUtils;
import com.qweib.cloud.biz.system.utils.ProgressUtil;
import com.qweib.cloud.biz.system.utils.RoleUtils;
import com.qweib.cloud.core.domain.*;
import com.qweib.cloud.core.domain.dto.SysRoleMemberDTO;
import com.qweib.cloud.core.domain.shop.*;
import com.qweib.cloud.core.domain.vo.SysMemberTypeEnum;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.memberEvent.MemberPublisher;
import com.qweib.cloud.repository.SysSalesmanDao;
import com.qweib.cloud.repository.company.SysCompanyRoleDao;
import com.qweib.cloud.repository.company.SysDeptmempowerDao;
import com.qweib.cloud.repository.mall.ShopMemberCertifyDao;
import com.qweib.cloud.repository.plat.ShopMemberCompanyDao;
import com.qweib.cloud.repository.plat.SysCorporationDao;
import com.qweib.cloud.repository.plat.SysMemberDao;
import com.qweib.cloud.repository.plat.ws.SysMemberWebDao;
import com.qweib.cloud.repository.ws.BscEmpGroupWebDao;
import com.qweib.cloud.repository.ws.SysDepartDao;
import com.qweib.cloud.service.member.common.RoleValueEnum;
import com.qweib.cloud.service.member.domain.corporation.SysCorporationDTO;
import com.qweib.cloud.service.member.domain.member.*;
import com.qweib.cloud.service.member.retrofit.SysMemberCompanyRequest;
import com.qweib.cloud.service.member.retrofit.SysMemberRequest;
import com.qweib.cloud.utils.*;
import com.qweib.cloud.utils.annotation.DataSourceAnnotation;
import com.qweib.commons.DateUtils;
import com.qweib.commons.StringUtils;
import com.qweib.commons.exceptions.BizException;
import com.qweib.commons.mapper.BeanMapper;
import com.qweibframework.async.handler.AsyncProcessHandler;
import com.qweibframework.commons.MathUtils;
import com.qweibframework.commons.http.ResponseUtils;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.BooleanUtils;
import org.dozer.Mapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.*;

@Slf4j
@Service
public class SysMemberService {
    @Resource
    private SysMemberDao memberDao;
    @Resource
    private BscEmpGroupWebDao empGroupDao;
    @Resource
    private SysDepartDao departDao;
    @Resource
    private SysCompanyRoleDao companyRoleDao;
    @Resource
    private SysDeptmempowerDao deptmempowerDao;
    @Autowired
    private SysCorporationDao corporationDao;
    @Autowired
    private ShopMemberCompanyDao shopMemberCompanyDao;

    @Autowired
    private ShopMemberCertifyDao shopMemberDao;
    @Autowired
    private SysCompanyRoleService companyRoleService;
    @Autowired
    private SysMemberCompanyService memberCompanyService;
    @Autowired
    private Mapper mapper;
    @Resource
    private SysInportTempService sysInportTempService;
    @Autowired
    private MemberPublisher memberPublisher;
    @Resource
    private SysDepartService departService;
    @Resource
    private AsyncProcessHandler asyncProcessHandler;
    @Resource
    private SysMemberWebDao memberWebDao;
    @Autowired
    private SysSalesmanDao salesmanDao;

    public List<SysMember> queryServiceList(String datasource) {
        return memberDao.getServiceList(datasource);
    }

    /**
     * 说明：分页查询成员（后台）
     *
     * @创建：作者:llp 创建时间：2015-2-2
     * @修改历史： [序号](llp 2015 - 2 - 3)<修改说明>
     */
    public Page querySysMember(SysMember member, Integer pageNo, Integer limit, String dataTp, SysLoginInfo info) {
        try {
            String datasource = member.getDatasource();
            Integer memberId = info.getIdKey();
            String depts = "";//
            String visibleDepts = "";//可见部门
            String invisibleDepts = "";//不可见部门
            if (!StrUtil.isNull(datasource)) {
                if ("2".equals(dataTp)) {//部门及子部门
                    Map<String, Object> map = departDao.queryBottomDepts(memberId, datasource);
                    if (null != map && !StrUtil.isNull(map.get("depts"))) {//不为空（如:7-9-11-）
                        String dpt = (String) map.get("depts");
                        depts = dpt.substring(0, dpt.length() - 1).replace("-", ",");//去掉最后一个“-”并转成逗号隔开的字符串
                    }
                }
                //查询可见部门(如：-4-，-7-4-)
                visibleDepts = getPowerDepts(datasource, memberId, "1", visibleDepts);
                //查询不可见部门
                invisibleDepts = getPowerDepts(datasource, memberId, "2", invisibleDepts);
            }

            return this.memberDao.querySysMember(member, pageNo, limit, dataTp, depts, invisibleDepts, memberId);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    //获取权限部门（可见或不可见）
    private String getPowerDepts(String datasource, Integer memberId, String tp,
                                 String visibleDepts) {
        Map<String, Object> visibleMap = deptmempowerDao.queryPowerDeptsByMemberId(memberId, tp, datasource);
        if (null != visibleMap && !StrUtil.isNull(visibleMap.get("depts"))) {//将查出来的格式（如：-4-，-7-4-）转换成逗号隔开（如：4,7,4）
            visibleDepts = visibleMap.get("depts").toString().replace("-,-", "-");
            visibleDepts = visibleDepts.substring(1, visibleDepts.length() - 1).replace("-", ",");
        }
        return visibleDepts;
    }

    public Page querySysMember(SysMember member, Integer page, Integer limit, String database) {
        try {
            return this.memberDao.querySysMember(member, page, limit, database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 说明：添加成员
     *
     * @创建：作者:llp 创建时间：2015-2-2
     * @修改历史： [序号](llp 2015 - 2 - 2)<修改说明>
     */
    public void addSysMember(SysMember member, String datasource) {
        try {
            // 保存平台会员与企业会员
            Integer memId = this.memberDao.addSysMember(member);
//			if("2".equals(member.getIsUnitmng())){
//				SysRoleMember srm = new SysRoleMember();
//				srm.setRoleId(8);
//				srm.setMemberId(member.getMemberId());
//				this.sysRoleMemberDao.addRoleMember(srm);
//			}
//			if("3".equals(member.getIsUnitmng())){
//				SysRoleMember srm = new SysRoleMember();
//				srm.setRoleId(9);
//				srm.setMemberId(member.getMemberId());
//				this.sysRoleMemberDao.addRoleMember(srm);
//			}
            MemberUtils.setLeadGroup(empGroupDao, member.getIsLead(), memId, datasource);
            //创建轨迹员工
            //String urls="http://api.map.baidu.com/trace/v2/entity/add";
            //String parameters="ak=gIzggYvrqG7zD5MCsFwSjKOkU8yv8SsC&service_id=117170&entity_name="+memId+"&entitydatabase="+datasource+"";
            //MapGjTool.postMapGjurl(urls, parameters);
            //创建轨迹员工2
            //SysCorporation corporation=this.corporationDao.queryCorporationBydata(datasource);
            //String urls2=QiniuControl.GPS_SERVICE_URL+"/User/postLocation";
            //String parameters2="company_id="+corporation.getDeptId()+"&user_id="+memId+"&location=[{\"longitude\":14.22222,\"latitude\":23.25555,\"address\":\"\",\"location_time\":"+StrUtil.getDqsjc()+",\"location_from\":\"\",\"os\":\"\"}]";
            //MapGjTool.postMapGjurl2(urls2, parameters2);
            //角色保存
            if (StringUtils.isNotBlank(member.getRoleIds())) {
                String roleIds = member.getRoleIds();
                String[] roleArray = roleIds.split(",");
                companyRoleDao.addUsrRoles(roleArray, memId, datasource);
            }
            member.setMemberId(memId);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 增加企业用户
     *
     * @param member
     * @param datasource
     */
    public void addCompanySysMember(SysMember member, String datasource) {
        try {
            Integer memId = this.memberDao.addCompanySysMember(member);
            if ("1".equals(member.getIsLead())) {//设置领导
                String dateTime = DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd HH:mm:ss");
                //加入vip权限圈
                Map<String, Object> groups = empGroupDao.queryGroupIds(member.getMemberId(), datasource);//查询不在圈内且vip开放的员工圈ids
                if (null != groups.get("ids")) {//加入vip权限圈
                    String[] ids = groups.get("ids").toString().split(",");
                    empGroupDao.addOpenGroupMems(ids, member.getMemberId(), "4", dateTime, datasource);
                }
                //加入公开圈
                Map<String, Object> openGroups = empGroupDao.queryOpenGroups(datasource);//查询公开圈
                if (null != openGroups.get("ids")) {//加入公开圈
                    String[] groupIds = openGroups.get("ids").toString().split(",");
                    empGroupDao.addOpenGroupMems(groupIds, member.getMemberId(), "3", dateTime, datasource);
                }
            }
            //创建轨迹员工
            //String urls = "http://api.map.baidu.com/trace/v2/entity/add";
            //String parameters = "ak=gIzggYvrqG7zD5MCsFwSjKOkU8yv8SsC&service_id=117170&entity_name=" + memId + "&entitydatabase=" + datasource + "";
           // MapGjTool.postMapGjurl(urls, parameters);
            //创建轨迹员工2
            SysCorporation corporation = this.corporationDao.queryCorporationBydata(datasource);
            //final String gpsUrl = QiniuControl.GPS_SERVICE_URL + "/User/postLocation";
            //GpsUtils.createGpsMember(gpsUrl, corporation.getDeptId().intValue(), memId);
            //角色保存
            if (null != member.getRoleIds() && !StrUtil.isNull(member.getRoleIds())) {
                String roleIds = member.getRoleIds();
                String[] roleArray = roleIds.split(",");
                companyRoleDao.addUsrRoles(roleArray, member.getMemberId(), datasource);
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServiceException(e);
        }
    }


    /**
     * 说明：添加成员(excel导入)
     *
     * @创建：作者:llp 创建时间：2015-2-6
     * @修改历史： [序号](llp 2015 - 2 - 6)<修改说明>
     */
    @Deprecated
    public int addSysMemberls(List<SysMember> memberls, SysLoginInfo info, String tStr, Set<String> successImportVoSet) {
        String datasource = info.getDatasource();
        this.memberDao.addSysMemberls(memberls, info.getFdCompanyId());

        if (!StrUtil.isNull(tStr)) {
            if (tStr.endsWith(","))
                tStr = tStr.substring(0, tStr.length() - 1);
            Map<String, Object> memberMap = memberDao.queryMemIdsByTels(tStr, datasource);
            if (null != memberMap && !StrUtil.isNull(memberMap.get("memids"))) {
                String[] memberIds = memberMap.get("memids").toString().split(",");
                Integer ids[] = new Integer[memberIds.length];
                for (int i = 0; i < memberIds.length; i++) {
                    ids[i] = StringUtils.toInteger(memberIds[i]);
                }
                /**********************添加成员角色*****************/
                SysRole role = companyRoleDao.queryRoleByRolecd(CnlifeConstants.ROLE_PTCY, datasource);
                companyRoleDao.addCompanyRoleUsr(ids, role.getIdKey(), datasource);
            }

            //加入公开圈内
            Map<String, Object> openGroups = empGroupDao.queryOpenGroups(datasource);//查询公开圈
            if (null != openGroups.get("ids")) {//加入公开圈
                Map<String, Object> memMap = memberDao.queryMemIdsByTels(tStr, datasource);
                String mids = (String) memMap.get("memids");
                String[] memIds = mids.split(",");
                String groupIds = (String) openGroups.get("ids");
                String[] ids = groupIds.split(",");
                for (String groupId : ids) {
                    String dateTime = DateUtils.getDateTime();
//						String[] groupIds = openGroups.get("ids").toString().split(",");
                    empGroupDao.addGroupMems(memIds, Integer.parseInt(groupId), "3", dateTime, datasource);
                }
            }
        }
        //修改数据为已导入成功标记
        if (Collections3.isNotEmpty(successImportVoSet)) {
            sysInportTempService.updateItemImportSuccess(String.join(",", successImportVoSet), info.getDatasource());
        }

        /*//导入通知商品员工会员
        for (int i = 0; i < memberls.size(); i++) {
            SysMember member = memberls.get(i);
            memberPublisher.staffChange(member.getMemberMobile(), member.getMemberNm(), member.getDatasource());
        }*/

        return 0;
    }

    /**
     * 说明：修改成员（后台）
     *
     * @创建：作者:llp 创建时间：2015-2-2
     * @修改历史： [序号](llp 2015 - 2 - 2)<修改说明>
     */
    public void updateSysMember(SysMember member, String oldisLead, String companyId) {
        try {
            this.memberDao.updateSysMember(member, companyId);
            final Integer memberId = member.getMemberId();
            final String database = member.getDatasource();
            if (!member.getIsLead().equals(oldisLead)) {
                updateMemberGroup(database, memberId, member.getIsLead());
            }

            updateMemberRoles(database, memberId, member.getRoleIds());
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 初始化完善会员信息
     *
     * @param input
     * @return
     */
    public Boolean initialSysMember(SysMemberInitial input) {
        return true;
        //return ResponseUtils.convertResponse(this.memberRequest.initialMember(input));
    }

    public void updateCompanySysMember(SysMember member, String oldisLead, String companyId) {
        try {
//            String memberPwd = member.getMemberPwd();
//            member.setMemberPwd(null);
            this.memberDao.updateCompanySysMember(member, member.getDatasource(), companyId);
            final Integer memberId = member.getMemberId();
            final String database = member.getDatasource();

            if (member.getIsLead() != null && !member.getIsLead().equals(oldisLead)) {
                updateMemberGroup(database, memberId, member.getIsLead());
            }

            updateMemberRoles(database, memberId, member.getRoleIds());
            /**
             * 员工管理不能修改员工密码
             */
//            if (StringUtils.isNotBlank(memberPwd)) {
//                this.updateSysMemberPassword(memberId, memberPwd);
//            }
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 更新员工圈
     *
     * @param database
     * @param memberId
     * @param lead
     */
    private void updateMemberGroup(String database, Integer memberId, String lead) {
        // 设置领导
        if (MemberUtils.LEAD_YES.equals(lead)) {
            String dateTime = DateUtils.getDateTime();
            /**
             * 加入vip权限圈
             */
            //查询不在圈内且vip开放的员工圈ids
            Map<String, Object> groups = empGroupDao.queryGroupIds(memberId, database);
            if (groups.get("ids") != null) {
                String[] ids = groups.get("ids").toString().split(",");
                empGroupDao.addOpenGroupMems(ids, memberId, "4", dateTime, database);
            }

            /**
             * 加入公开圈
             */
            Map<String, Object> openGroups = empGroupDao.queryOpenGroups(database);
            if (openGroups.get("ids") != null) {
                String[] groupIds = openGroups.get("ids").toString().split(",");
                empGroupDao.addOpenGroupMems(groupIds, memberId, "3", dateTime, database);
            }
        }
    }

    /**
     * 更新会员角色列表（先删除成员角色，再新增角色列表）
     *
     * @param database
     * @param memberId
     * @param roleIds
     */
    private void updateMemberRoles(String database, Integer memberId, String roleIds) {
        companyRoleDao.deleteRoleByMem(memberId, database);
        if (StringUtils.isNotBlank(roleIds)) {
            String[] roleArray = roleIds.split(",");
            companyRoleDao.addUsrRoles(roleArray, memberId, database);
        }
    }

    /**
     * 说明：修改客户的业务员部门id
     *
     * @创建：作者:llp 创建时间：2017-7-13
     * @修改历史： [序号](llp 2017 - 7 - 13)<修改说明>
     */
    public void updateCMBid(String datasource, Integer memberId, Integer branchId) {
        try {
            this.memberDao.updateCMBid(datasource, memberId, branchId);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 说明：获取成员
     *
     * @创建：作者:llp 创建时间：2015-2-2
     * @修改历史： [序号](llp 2015 - 2 - 2)<修改说明>
     */
    public SysMember querySysMemberById(Integer memberId) {
        try {
            return this.memberDao.querySysMemberById(memberId);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    public int queryBranchId(Integer id, String database) {
        try {
            return this.memberDao.queryBranchId(id, database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }

    }

    /**
     * 说明：获取成员(企业)
     *
     * @创建：作者:llp 创建时间：2015-2-2
     * @修改历史： [序号](llp 2015 - 2 - 2)<修改说明>
     */
    public SysMember querySysMemberById1(String datasource, Integer Id) {
        try {
            return this.memberDao.querySysMemberById1(datasource, Id);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    public void updatePlatSysMember(SysMember member) {
        try {
            this.memberDao.updatePlatSysMember(member);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    public Boolean updateSysMemberPassword(Integer memberId, String newPwd) {
        return memberDao.updateSysMemberPassword(memberId, newPwd);
    }

    public Integer updateUseDog(Integer memId, Integer isUse, String idKey, String database) {
        try {
            return this.memberDao.updateUseDog(memId, isUse, idKey, database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    public SysMember queryCompanySysMemberById(String datasource, Integer Id) {
        try {
            return this.memberDao.queryCompanySysMemberById(datasource, Id);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 说明：根据手机号码获取成员条数
     *
     * @创建：作者:llp 创建时间：2015-2-3
     * @修改历史： [序号](llp 2015 - 2 - 3)<修改说明>
     */
    public int querySysMemberByTel(String tel) {
        try {
            return this.memberDao.querySysMemberByTel(tel);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 说明：根据手机号码获取成员信息(企业的员工)
     */
    public SysMember querySysMemberByTel(String tel, String datasource) {
        try {
            return this.memberDao.querySysMemberByTel(tel, datasource);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }


    public SysMember queryPlatSysMemberbyTel(String tel) {
        return this.memberDao.queryPlatSysMemberbyTel(tel);
    }

    public SysMember queryPlatSysMemberbyAccNo(String tel) {
        return this.memberDao.queryPlatSysMemberbyAccNo(tel);
    }

    /**
     * 说明：添加成员
     *
     * @创建：作者:llp 创建时间：2015-2-2
     * @修改历史： [序号](llp 2015 - 2 - 2)<修改说明>
     */
    public void addSysMem(SysMember mem, String datasource) {
        try {
            this.memberDao.addSysMem(mem, datasource);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * @return
     * @说明：修改好友数
     * @创建者： 作者： llp  创建时间：2015-2-11
     */
    public Integer updateMemberByAttentions(String datasource, Integer memberId, Integer count) {
        try {
            return this.memberDao.updateMemberByAttentions(datasource, memberId, count);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * @return
     * @说明：修改黑名单数
     * @创建者： 作者： llp  创建时间：2015-2-11
     */
    public void updateMemberByBlacklist(String datasource, Integer memberId, Integer count) {
        try {
            this.memberDao.updateMemberByBlacklist(datasource, memberId, count);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 获取会员名称
     */
    public List<SysMemDTO> querypMems() {
        try {
            return this.memberDao.querypMems();
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

//    /**
//     * 删除
//     */
//    public int[] deletemember(Integer[] ids) {
//        try {
//            for (int i = 0; i < ids.length; i++) {
//                SysMemDTO member = memberWebDao.queryMemByMemId(ids[i]);
//                if (!StrUtil.isNull(member.getDatasource())) {
//                    memWebDao.deleteMemById(ids[i], member.getDatasource());
//                    memWebDao.deleteMemGjById(ids[i], member.getDatasource());
//                }
//            }
//            return this.memberDao.deletemember(ids);
//        } catch (Exception e) {
//            throw new ServiceException(e);
//        }
//    }
//
//    /**
//     * @param companyId
//     * @return
//     * @创建：作者:YYP 创建时间：2015-5-25
//     * @see 查询公司管理员或创建者
//     */
//    public List<SysMemDTO> queryCompanyAdmins(Integer companyId) {
//        try {
//            return memberDao.queryCompanyAdmins(companyId);
//        } catch (Exception e) {
//            throw new ServiceException(e);
//        }
//    }
//
//    public void updateSysMember(SysMember member) {
//        try {
//            memberDao.updateSysMember(member);
//        } catch (Exception e) {
//            throw new ServiceException(e);
//        }
//    }
//
//    /**
//     * @说明：修改停用
//     * @创建：作者:llp 创建时间：2016-5-9
//     * @修改历史： [序号](llp 2016 - 5 - 9)<修改说明>
//     */
//    public void updateIsTy(Integer id, Integer isTy, String datasource) {
//        try {
//            memberDao.updateIsTy(id, isTy, datasource);
//        } catch (Exception e) {
//            throw new ServiceException(e);
//        }
//    }

    public String updateCompanyIsTy(Integer id, Integer useStatus, SysLoginInfo info) {
        try {
            List<Integer> roleIds = Lists.newArrayList();
            boolean needClearRole = false;
            String datasource = info.getDatasource();
            switch (useStatus) {
                case 1: {
                    // 入职
                    // 判断是否有占用端口的角色，清除其他角色，只留普通员工
                    List<SysRoleMemberDTO> roleList = companyRoleDao.queryRoleMemberByMemberId(datasource, id);
                    if (companyRoleService.checkPortCountExceedLimit(roleList, datasource, StringUtils.toInteger(info.getFdCompanyId()), id)) {
                        needClearRole = true;
                        for (SysRoleMemberDTO roleMemberDTO : roleList) {
                            if (RoleValueEnum.isCreator(roleMemberDTO.getRoleCode()) ||
                                    RoleValueEnum.isExecutiveStaff(roleMemberDTO.getRoleCode()) ||
                                    RoleValueEnum.isGeneralStaff(roleMemberDTO.getRoleCode())) {
                                roleIds.add(roleMemberDTO.getRoleId());
                            }
                        }
                    }
                    Integer companyId = Integer.parseInt(info.getFdCompanyId());
                    memberWebDao.updateCompanyMember(companyId, id, null);
                    break;
                }
                case 2: {
                    // 离职
                    SysRole salesmanRole = companyRoleDao.queryRoleByRolecd(RoleValueEnum.BUSINESS_PEOPLE.getCode(), datasource);
                    if (Objects.nonNull(salesmanRole)) {
                        this.companyRoleDao.deleteCompanyRoleMember(salesmanRole.getIdKey(), id, datasource);
                        this.salesmanDao.removeBindMember(id, datasource);
                    }
                    break;
                }
            }
            memberDao.updateCompanyIsTy(id, useStatus, datasource);
            // 超过端口数：执行清空角色，增加普通员工
            if (needClearRole) {
                SysRole generalRole = companyRoleDao.queryRoleByRolecd(RoleValueEnum.GENERAL_STAFF.getCode(), datasource);
                if (Collections3.isEmpty(roleIds) && Objects.nonNull(generalRole)) {
                    roleIds.add(generalRole.getIdKey());
                }
                updateMemberRoles(datasource, id, StringUtils.join(roleIds.toArray(new Integer[roleIds.size()]), ","));

                return "用户端口已超过限制，转为普通员工。具体联系平台客服";
            }
            //离职通知商城会员改为普通会员
            SysMember member = querySysMemberById1(info.getDatasource(), id);
            System.out.println("updateCompanyIsTy=" + member.getMemberUse());
            memberPublisher.staffUpdate(member, info.getDatasource(), info.getFdCompanyId());
        } catch (Exception e) {
            throw new ServiceException(e);
        }

        return null;
    }

    /**
     * @说明：解绑设备
     * @创建：作者:llp 创建时间：2016-5-10
     * @修改历史： [序号](llp 2016 - 5 - 10)<修改说明>
     */
    public void updateUnId(Integer id, String datasource, Integer isTy) {
        try {
            memberDao.updateUnId(id, datasource, isTy);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    public void updateCompanyUnId(Integer id, String datasource, Integer isTy) {
        try {
            memberDao.updateCompanyUnId(id, datasource, isTy);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * @说明：转让客户
     * @创建：作者:llp 创建时间：2016-5-11
     * @修改历史： [序号](llp 2016 - 5 - 11)<修改说明>
     */
    public void updateZrKh(Integer mid1, Integer mid2, String datasource) {
        try {
            memberDao.updateZrKh(mid1, mid2, datasource);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 说明：根据成员名称查信息
     *
     * @创建：作者:HSL 创建时间：2016-9-14
     * @修改历史： [序号](hsl 2016 - 9 - 14)<修改说明>
     */
    public SysMember querySysDepartByNm(String name, String datasource) {
        return this.memberDao.querySysMemberByNm(name, datasource);
    }

    /**
     * 说明：根据部门id获取用户
     *
     * @创建：作者:llp 创建时间：2017-1-9
     * @修改历史： [序号](llp 2017 - 1 - 9)<修改说明>
     */
    public SysMember queryBmMemberIds(Integer branchId, String datasource) {
        try {
            return this.memberDao.queryBmMemberIds(branchId, datasource);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 说明：查询有所属公司的用户
     *
     * @创建：作者:llp 创建时间：2017-3-17
     * @修改历史： [序号](llp 2017 - 3 - 17)<修改说明>
     */
    public List<SysMember> queryMemberAll() {
        try {
            return this.memberDao.queryMemberAll();
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    public List<SysMember> queryMemberAllByDatabase(String datasource, SysMember member) {
        try {
            return this.memberDao.queryMemberAllByDatabase(datasource, member);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    public List<SysMember> queryCompanyMemberList(SysMember member, String datasource) {
        try {
            return this.memberDao.queryCompanyMemberList(member, datasource);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 根据openId查询会员
     */
   /* public int updateShopMember(Map<String, Object> map, String database) {
        try {
            return this.memberDao.updateShopMember(map, database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }*/

    /**
     * 根据openId查询会员
     */
    public String updateByRzMobile(String database, String rzMobile, Integer memberId, SysLoginInfo info) {
// 1.认证成功；2.该手机号已认证过；3.该手机号已在客户管理中认证过;4:该手机号已在会员表存在
//				1.根据认证手机号查询员工表
//				1）存在-提示该手机号已认证
//				2）不存在；再处理（员工表添加认证手机（放后面处理））
//				2.根据认证手机号查询会员表
//				1）存在：根据source判定是员工，客户还是普通会员；如果是员工或客户-提示已存在；如果是普通则修改为员工会员
//				2）不存在：再处理；（添加员工会员，会员加入平台会员企业记录（app查询供货商），员工表添加认证手机）
//				3.会员加入平台会员企业记录（app查询供货商）
        try {
            if (!StrUtil.isNull(rzMobile) && rzMobile.length() == 11) {
                //1.根据认证手机号查询员工表
                SysMember oldMember = this.memberDao.querySysMemberByRzMobile(rzMobile, database);
                if (oldMember != null) {
                    return "2";
                } else {
                    memberPublisher.customerRzMobileChange(oldMember.getRzMobile(), rzMobile, null, null, info);
                   /* SysCorporation corporation = corporationDao.queryCorporationBydata(database);
                    String result = addShopMember(memberId, rzMobile, database, corporation.getDeptId().intValue(), corporation.getDeptNm());
                    if (StringUtils.isNotBlank(result)) {
                        return result;
                    }*/
                }
            }
            //1.认证成功；2.该手机号已认证过；3.该手机号已在客户管理中认证过
            return "1";
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

   /* @Deprecated
    private String addShopMember(Integer memberId, String mobile, String database,
                                 Integer companyId, String companyName) {
        //2.根据手机号查询会员表
        Map<String, Object> shopMemberMap = this.memberDao.queryShopMemberByOpenId(null, mobile, database);
        boolean isAdd = true;
        if (Collections3.isEmpty(shopMemberMap)) {
            //TODO:添加会员（员工）
            shopMemberMap = new HashMap<>();
        } else {
            //TODO:修改会员（判定会员是否属于员工)--------如果会员是客户，要怎么处理？？？
            String source = (String) shopMemberMap.get("source");
            if (!StrUtil.isNull(source)) {
                // 如果是员工或者客户，不处理
                if ("2".equals(source)) {
                    return "4";
                }
                if ("3".equals(source)) {
                    return "3";
                }
            }
            isAdd = false;
        }
        //TODO:员工表添加认证手机号
        SysMember member = this.memberDao.querySysMemberById1(database, memberId);
        member.setRzMobile(mobile);
        member.setRzState(1);
        this.memberDao.updateSysMemberByRzMobile(member, database);

        shopMemberMap.put("name", member.getMemberNm());
        shopMemberMap.put("mobile", member.getRzMobile());
        shopMemberMap.put("mem_id", member.getMemberId());
        shopMemberMap.put("reg_date", DateUtils.formatDate("yyyy-MM-dd HH:mm"));
        shopMemberMap.put("active_date", shopMemberMap.get("reg_date"));
        shopMemberMap.put("status", 1);
        shopMemberMap.put("customer_id", null);
        shopMemberMap.put("customer_name", null);
        shopMemberMap.put("shop_no", 9998);//店号(来源：客户：9996；app：9997；员工：9998，微信公众号：9999，门店如：0001,0002)
        shopMemberMap.put("source", 2);//(来源：：普通1；员工2；客户3)
        shopMemberMap.put("hy_source", "员工管理");
        //判断是否离职
        if ("2".equals(member.getMemberUse())) {
            shopMemberMap.put("source", 1);//(来源：：普通1；员工2；客户3)
        }

        //总平台：会员加入平台会员企业记录（供货商）
        this.addShopMemberCompany(memberId, mobile, member.getMemberNm(), companyId, companyName);
        if (isAdd) {
            this.memberDao.addShopMember(shopMemberMap, database);
        } else {
            this.memberDao.updateShopMember(shopMemberMap, database);
        }

        return null;
    }*/

    //总平台：会员加入平台会员企业记录（app查询供货商）
    public void addShopMemberCompany(Integer memberId, String mobile, String memberName, Integer companyId, String companyName) {
        ShopMemberCompany smc = new ShopMemberCompany();
        smc.setMemberMobile(mobile);
        smc.setMemberId(memberId);
        smc.setCompanyId(companyId);
        List<ShopMemberCompany> rtnList = this.shopMemberCompanyDao.queryShopMemberCompanyList(smc);
        if (Collections3.isNotEmpty(rtnList)) {
            smc = rtnList.get(0);
            smc.setMemberNm(memberName);
            smc.setOutTime("");
            this.shopMemberCompanyDao.updateShopMemberCompany(smc);
        } else {
            smc.setInTime(DateUtils.getDate());
            smc.setMemberNm(memberName);
            smc.setMemberCompany(companyName);
            shopMemberCompanyDao.addShopMemberCompany(smc);
        }
    }

    public SysMember queryCompanySysMemberByName(String datasource, String name) {
        return this.memberDao.queryCompanySysMemberByName(datasource, name);
    }

    public Boolean updatePwd(Integer memberId, String oldPassword, String newPassword) {
        return true;
        //return ResponseUtils.convertResponse(memberRequest.updatePwd(memberId, oldPassword, newPassword));
    }

    /**
     * 认证系统用户
     *
     * @param memberId
     * @return
     */
    public Boolean updateMemberCertify(Integer memberId) {
        return true;
//        SysMemberCompanyQuery memberCompanyQuery = new SysMemberCompanyQuery();
//        memberCompanyQuery.setMemberId(memberId);
//        memberCompanyQuery.setDimission(false);
//        List<SysMemberCompanyDTO> memberCompanyDTOS = ResponseUtils.convertResponse(memberCompanyRequest.list(memberCompanyQuery));
//        if (Collections3.isNotEmpty(memberCompanyDTOS)) {
//            for (SysMemberCompanyDTO memberCompanyDTO : memberCompanyDTOS) {
//                Optional<SysCorporationDTO> companyOptional = corporationDao.getCompany(memberCompanyDTO.getCompanyId());
//                if (companyOptional.isPresent()) {
//                    SysCorporationDTO companyDTO = companyOptional.get();
//                    syncShopMember(memberCompanyDTO.getMemberId(), memberCompanyDTO.getMobile(),
//                            companyDTO.getId(), companyDTO.getName(), companyDTO.getDatabase());
//                }
//            }
//        }
//        SysMemberUpdateCertify input = new SysMemberUpdateCertify();
//        input.setMemberId(memberId);
//        Boolean result = ResponseUtils.convertResponse(this.memberRequest.certifyMember(input));
//        if (!BooleanUtils.isTrue(result)) {
//            throw new BizException("认证失败");
//        }
//
//        return result;
    }

    private void syncShopMember(Integer memberId, String mobile, Integer companyId, String companyName, String database) {
        SysMember companyMember;
        try {
            companyMember = this.memberDao.querySysMemberById1(database, memberId);
            if (companyMember == null) {
                return;
            }
        } catch (DaoException e) {
            return;
        }

        final String nowTime = DateUtils.getDateTime();

        ShopMemberQuery query = new ShopMemberQuery();
        query.setMobile(mobile);
        ShopMemberDTO shopMemberDTO = this.shopMemberDao.getShopMember(query, database);
        if (shopMemberDTO == null) {
            ShopMemberSave input = new ShopMemberSave();
            input.setRegisterDate(nowTime);
            input.setActiveDate(nowTime);
            setShopMemberProperties(input, companyMember);

            this.shopMemberDao.saveShopMember(input, database);
        } else {
            ShopMemberUpdate input = mapper.map(shopMemberDTO, ShopMemberUpdate.class);
            input.setActiveDate(nowTime);
            setShopMemberProperties(input, companyMember);
            this.shopMemberDao.updateShopMember(input, database);
        }

        ShopMemberCompany memberCompanyDTO = this.shopMemberDao.getShopMemberCompany(memberId, companyId);
        if (memberCompanyDTO == null) {
            ShopMemberCompanySave input = new ShopMemberCompanySave();
            input.setMemberId(memberId);
            input.setMemberName(companyMember.getMemberNm());
            input.setMemberMobile(mobile);
            input.setCompanyId(companyId);
            input.setCompanyName(companyName);
            this.shopMemberDao.saveShopMemberCompany(input);
        } else {
            ShopMemberCompanyUpdate input = new ShopMemberCompanyUpdate();
            input.setId(memberCompanyDTO.getFdId());
            input.setMemberName(companyMember.getMemberNm());
            input.setMemberMobile(mobile);
            input.setCompanyName(companyName);
            this.shopMemberDao.updateShopMemberCompany(input);
        }
    }

    private void setShopMemberProperties(ShopMemberSave input, SysMember companyMember) {
        input.setName(companyMember.getMemberNm());
        input.setMobile(companyMember.getMemberMobile());
        input.setMemberId(companyMember.getMemberId());
        input.setStatus(ShopMemberStatusEnum.ENABLED);
        input.setShopNo(ShopMemberConstant.SHOP_NO_EMPLOYEE);
        input.setSource(ShopMemberConstant.SOURCE_EMPLOYEE);
        //判断员工是否禁用
        if ("2".equals(companyMember.getMemberUse())) {
            input.setSource(ShopMemberConstant.SOURCE_NORMAL);
        }
        input.setHySource(ShopMemberConstant.HY_SOURCE_EMPLOYEE);
    }

    public String saveMember(final String database, final SysMember input, final List<Integer> roleIds,
                             final Integer companyId, final String companyName, final Integer creatorId) {
        if (!MathUtils.valid(companyId)) {
            //公司id不存在
            return "5";
        }

        Optional<SysMember> existOptional = Optional.ofNullable(this.memberDao.querySysMemberByAccNo(input.getMemberName(), database));
        if (existOptional.isPresent()) {
            // 该手机号已存在企业会员中
            if (input.getMemberType() == null || Objects.equals(input.getMemberType(), SysMemberTypeEnum.general.getType()))
                return "3";
            else {
                if (Objects.equals(input.getMemberType(), SysMemberTypeEnum.pick_shop_manager.getType())
                        || Objects.equals(input.getMemberType(), SysMemberTypeEnum.star_shop_manager.getType())) {  //自提店长，星链店长 默认角色 zzx
                    SysMember sysMember = existOptional.get();
                    List<SysRoleMemberDTO> rolesDto = this.companyRoleService.getRoleMemberByMemberId(database, sysMember.getMemberId());
                    CompanyRoleEnum sysMemberTypeEnum = (Objects.equals(input.getMemberType(), SysMemberTypeEnum.pick_shop_manager.getType())) ? CompanyRoleEnum.PICK_SHOP_MANAGER : CompanyRoleEnum.STAR_SHOP_MANAGER;
                    SysRole generalRole = companyRoleDao.queryRoleByRolecd(sysMemberTypeEnum.getRole(), database);
                    if (Objects.nonNull(generalRole)) {
                        SysRoleMemberDTO dto = new SysRoleMemberDTO();
                        dto.setRoleId(generalRole.getIdKey());
                        rolesDto.add(dto);
                    }
                    List<Integer> roleIdsList = new ArrayList<>();
                    if (Collections3.isNotEmpty(rolesDto)) {

                        for (SysRoleMemberDTO dto : rolesDto) {
                            roleIdsList.add(dto.getRoleId());
                        }
                        sysMember.setRoleIds(StringUtils.join(roleIdsList, ","));
                    }
                    sysMember.setMemberType(input.getMemberType() + sysMember.getMemberType());
                    BeanMapper.copy(sysMember, input);

                    return updateMember(database, input, roleIdsList, companyId, sysMember.getIsLead());
                }
            }
        }

        SysSalesman salesman = null;
        // 判断角色里是否包含"创建者"或"管理员"
        if (Collections3.isNotEmpty(roleIds)) {
            boolean hasRole = RoleUtils.hasCompanyRoles(roleIds, new CompanyRoleEnum[]{CompanyRoleEnum.COMPANY_CREATOR, CompanyRoleEnum.COMPANY_ADMIN},
                    companyRoleService, database);
            if (hasRole) {
                return "4";
            }

            SysRole salesmanRole = companyRoleDao.queryRoleByRolecd(RoleValueEnum.BUSINESS_PEOPLE.getCode(), database);
            if (Objects.nonNull(salesmanRole) && roleIds.contains(salesmanRole.getIdKey())) {
                salesman = salesmanDao.getNoBindSalesman(database, null);
                if (Objects.isNull(salesman)) {
                    //外勤人员不存在
                    return "6";
                }
            }
            if (companyRoleService.checkPortCountExceedLimit(roleIds, database, companyId, Lists.newArrayList(0))) {
                //端口数已超出
                return "7";
            }
        } else {
            // 默认添加普通员工角色
            SysRole generalRole = companyRoleDao.queryRoleByRolecd(RoleValueEnum.GENERAL_STAFF.getCode(), database);
            if (Objects.nonNull(generalRole)) {
                input.setRoleIds(generalRole.getIdKey().toString());
            }
        }

        //自提店长，星链店长 默认角色 zzx
        if (Objects.equals(input.getMemberType(), SysMemberTypeEnum.pick_shop_manager.getType()) || Objects.equals(input.getMemberType(), SysMemberTypeEnum.star_shop_manager.getType())) {
            CompanyRoleEnum sysMemberTypeEnum = (Objects.equals(input.getMemberType(), SysMemberTypeEnum.pick_shop_manager.getType())) ? CompanyRoleEnum.PICK_SHOP_MANAGER : CompanyRoleEnum.STAR_SHOP_MANAGER;
            SysRole generalRole = companyRoleDao.queryRoleByRolecd(sysMemberTypeEnum.getRole(), database);
            if (Objects.nonNull(generalRole)) {
                input.setRoleIds(generalRole.getIdKey().toString());
            }
        }

        input.setMemberCreatime(DateUtils.getDateTime());
        input.setUnitId(companyId);
        input.setMemberCompany(companyName);
        input.setMemberCreator(creatorId);
        input.setDatasource(database);
        input.setMemberActivate("1");
        input.setMemberUse("1");
        input.setState("2");

        final SysMember platMember = this.queryPlatSysMemberbyAccNo(input.getMemberName());

        // 如果平台也不存在该手机号，则平台与企业都要添加
        if (platMember == null) {
            input.setDatasource(database);
            input.setMemberPwd("e10adc3949ba59abbe56e057f20f883e");
            this.addSysMember(input, database);

            SysMemberCompany newSmc = MemberUtils.createBySysMember(input, companyId,
                    input.getMemberId());
            this.memberCompanyService.addSysMemberCompany(newSmc);
        } else {
            // 如果平台存在该手机号，则只需要增加企业会员与关联该企业
            final Integer memberId = platMember.getMemberId();
            input.setMemberId(memberId);
            this.addCompanySysMember(input, database);
            //平台添加该企业的会员信息
            SysMemberCompany memberCompanyOptional = this.memberCompanyService.getMemberCompany(memberId, companyId);
            if (memberCompanyOptional == null) {
                SysMemberCompany newSmc = MemberUtils.createBySysMember(input, companyId, memberId);
                this.memberCompanyService.addSysMemberCompany(newSmc);
            } else {
                SysMemberCompanyLeaveTime memberCompanyQuery = new SysMemberCompanyLeaveTime();
                memberCompanyQuery.setId(memberCompanyOptional.getFdId());
                this.memberCompanyService.updateMemberCompanyLeaveTime(memberCompanyQuery);
            }
        }

        if (Objects.nonNull(salesman)) {
            salesmanDao.updateMemberId(salesman.getId(), input.getMemberMobile(), input.getMemberId(), database);
        }

        //通知商城会员操作
        memberPublisher.staffAdd(input, database, companyId + "");
        return "1";
    }

    public String updateMember(final String database, final SysMember input, final List<Integer> roleIds,
                               final Integer companyId, String oldisLead) {
        if (!MathUtils.valid(companyId)) {
            return "5";
        }
        boolean canEditRole = companyRoleService.canEditCreatorAndAdmin(database, input.getMemberId(), roleIds);
        if (!canEditRole) {
            return "4";
        }

        SysMember companyMember = this.queryCompanySysMemberById(database, input.getMemberId());
        input.setDatasource(database);
        input.setScore(companyMember.getScore());

        boolean branchNotEqual = MathUtils.valid(companyMember.getBranchId()) && !Objects.equals(companyMember.getBranchId(), input.getBranchId());
        if (branchNotEqual || MathUtils.valid(input.getBranchId())) {
            this.updateCMBid(database, input.getMemberId(), input.getBranchId());
        }

        SysSalesman salesman = null;
        if (Collections3.isNotEmpty(roleIds)) {
            // 过滤创建人与管理员
            boolean remove = false;
            Iterator<Integer> roleIter = roleIds.iterator();
            while (roleIter.hasNext()) {
                Integer roleId = roleIter.next();
                SysRole role = companyRoleService.queryById(database, roleId);
                if (RoleValueEnum.isCreator(role.getRoleCd())) {
                    roleIter.remove();
                    remove = true;
                }
            }
            if (companyRoleService.checkPortCountExceedLimit(roleIds, database, companyId, Lists.newArrayList(input.getMemberId()))) {
                return "7";
            }
            if (remove) {
                input.setRoleIds(StringUtils.join(roleIds, ","));
            }
            SysRole salesmanRole = companyRoleDao.queryRoleByRolecd(RoleValueEnum.BUSINESS_PEOPLE.getCode(), database);
            if (Objects.nonNull(salesmanRole) && roleIds.contains(salesmanRole.getIdKey())) {
                salesman = salesmanDao.getNoBindSalesman(database, input.getMemberId());
                if (Objects.isNull(salesman)) {
                    salesman = salesmanDao.getNoBindSalesman(database, null);
                    if (Objects.isNull(salesman)) {
                        return "6";
                    }
                }
            }
        } else {
            // 默认添加普通员工角色
            SysRole generalRole = companyRoleDao.queryRoleByRolecd(RoleValueEnum.GENERAL_STAFF.getCode(), database);
            if (Objects.nonNull(generalRole)) {
                input.setRoleIds(generalRole.getIdKey().toString());
            }
        }

        if (Objects.nonNull(salesman)) {
            salesmanDao.updateMemberId(salesman.getId(), input.getMemberMobile(), input.getMemberId(), database);
        } else {
            salesmanDao.removeBindMember(input.getMemberId(), database);
        }
        this.updateCompanySysMember(input, oldisLead, companyId.toString());

        return "2";
    }

    public Page dialogShopMemberPage(SysMember sysMember, int page, int rows, Integer branchId, Integer type, String datasource) {
        try {
            return this.memberDao.dialogShopMemberPage(sysMember, page, rows, branchId, type, datasource);

        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    public int batchUpdateMemberDepartment(String ids, Integer branchId, String datasource) {
        try {
            return this.memberDao.batchUpdateMemberDepartment(ids, branchId, datasource);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 会员导入
     *
     * @param voList          导入列表
     * @param info            会员信息
     * @param taskId          进度条ID
     * @param requestParamMap 页面提交数据
     */
    @Async
    @DataSourceAnnotation(companyId = "#info.fdCompanyId")
    public void addSysMemberlImport(List<ImportSysMemberVo> voList, SysLoginInfo info, String taskId, Map<String, String[]> requestParamMap) {
        ImportResults importResults = new ImportResults();
        //走统一的保存会员操作
        long st = System.currentTimeMillis();
        try {
            //allocator.alloc(info.getDatasource(), info.getFdCompanyId());
            Set<String> idsSet = new HashSet(voList.size());
            String replaceSysMember = CommonUtil.getMapOnlyValue(requestParamMap, "replaceSysMember");
            String datasource = info.getDatasource();
            ProgressUtil progressUtil = new ProgressUtil(0, 99, voList.size());
            int i = 0;
            Map<String, Integer> cacheDepMap = new HashMap<>(voList.size());
            for (ImportSysMemberVo vo : voList) {
                i++;
                ValidationBeanUtil.ValidResult validResult = ValidationBeanUtil.validateBean(vo);
                if (validResult.hasErrors()) {
                    importResults.setErrorMsg("第" + i + "行 " + vo.getMemberNm() + " " + validResult.getErrors());
                    continue;
                }
                asyncProcessHandler.updateProgress(taskId, progressUtil.getCurrentRaised((i)), vo.getMemberNm() + "正在处理");

                SysMember oldSysMember = querySysMemberByTel(vo.getMemberMobile(), info.getDatasource());
                //验证手机号是否存在会员表
                if (StrUtil.isNull(replaceSysMember) || !Boolean.valueOf(replaceSysMember)) {
                    if (oldSysMember != null) {
                        importResults.setOperationScript("<input class='dataVaildata' name='replaceSysMember' type='checkbox'>覆盖重名会员信息");
                        importResults.setErrorMsg("第" + i + "行" + vo.getMemberNm() + vo.getMemberMobile() + "已存在");
                        importResults.addExistsNum();
                        continue;
                    }
                }
                //如果部门为空时新建
                Integer branchId;
                branchId = cacheDepMap.get(vo.getBranchName());
                if (branchId == null) {
                    SysDepart depart = this.departService.querySysDepartByNm(vo.getBranchName(), info.getDatasource());
                    if (null == depart) {
                        depart = new SysDepart();
                        depart.setBranchName(vo.getBranchName());
                        depart.setParentId(0);
                        depart.setBranchLeaf("1");
                        branchId = departService.addDepart(depart, datasource);
                        cacheDepMap.put(vo.getBranchName(), branchId);
                    } else {
                        branchId = depart.getBranchId();
                        cacheDepMap.put(vo.getBranchName(), branchId);
                    }
                }
                try {
                    String result = "";
                    List<Integer> roleIds = new ArrayList<>();
                    if (oldSysMember == null || !com.qweib.commons.MathUtils.valid(oldSysMember.getMemberId())) {
                        SysMember sysMember = mapper.map(vo, SysMember.class);
                        sysMember.setBranchId(branchId);
                        result = saveMember(datasource, sysMember, roleIds, StringUtils.toInteger(info.getFdCompanyId()), info.getFdCompanyNm(), info.getIdKey());
                    } else {
                        //有数据的修改
                        if (StringUtils.isNotEmpty(vo.getMemberNm()))
                            oldSysMember.setMemberNm(vo.getMemberNm());
                        if (StringUtils.isNotEmpty(vo.getMemberGraduated()))
                            oldSysMember.setMemberGraduated(vo.getMemberGraduated());
                        if (StringUtils.isNotEmpty(vo.getMemberHometown()))
                            oldSysMember.setMemberHometown(vo.getMemberHometown());
                        if (StringUtils.isNotEmpty(vo.getMemberJob()))
                            oldSysMember.setMemberJob(vo.getMemberJob());
                        if (StringUtils.isNotEmpty(vo.getMemberTrade()))
                            oldSysMember.setMemberTrade(vo.getMemberTrade());
                        oldSysMember.setBranchId(branchId);

                        result = updateMember(datasource, oldSysMember, roleIds, StringUtils.toInteger(info.getFdCompanyId()), oldSysMember.getOldtel());
                    }
                    if ("1".equals(result) || "2".equals(result)) {
                        importResults.addSuccessNum();
                        idsSet.add(vo.getId() + "");
                    }
                } catch (Exception e) {
                    importResults.setErrorMsg("第" + i + "行" + vo.getMemberNm() + vo.getMemberMobile() + "导入出现错误" + e.getMessage());
                    log.error(vo + "导入出现错误", e);
                    continue;
                }
            }
            //完成选项
            if (Collections3.isNotEmpty(idsSet))
                sysInportTempService.updateItemImportSuccess(String.join(",", idsSet), datasource);
        } finally {
            importResults.setSuccessMsg(st);
            asyncProcessHandler.doneTask(taskId, JsonUtil.toJson(importResults));
        }
    }

    public Integer queryAdminMemberId(String database) {
        return this.memberDao.queryAdminMemberId(database);
    }

    public SysMember queryMemberByOpenId(String openId)
    {
        return this.memberDao.queryByOpenId(openId);
    }

    public SysMember queryByOpenId_client(String openId,String database)
    {
        return this.memberDao.queryByOpenId_client(openId,database);
    }
}
