package com.qweib.cloud.biz.system.service.plat;


import com.qweib.cloud.core.domain.SysCorporation;
import com.qweib.cloud.core.domain.SysCorporationRenew;
import com.qweib.cloud.core.domain.SysMenu;
import com.qweib.cloud.core.domain.SysRoleMember;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.repository.company.SysMenuApplyDao;
import com.qweib.cloud.repository.plat.*;
import com.qweib.cloud.repository.plat.ws.SysMemberWebDao;
import com.qweib.cloud.repository.ws.BscEmpGroupWebDao;
import com.qweib.cloud.repository.ws.BscKnowledgeDao;
import com.qweib.cloud.repository.ws.BscTopicWebDao;
import com.qweib.cloud.service.member.domain.corporation.SysCorporationDTO;
import com.qweib.cloud.utils.DateTimeUtil;
import com.qweib.cloud.utils.Page;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;


@Service
public class SysCorporationService {

    public static Logger logger = LoggerFactory.getLogger(SysCorporationService.class);

    @Resource
    private SysCorporationDao corporationDao;
    @Resource
    private SysMemberWebDao memberWebDao;
    @Resource
    private SysMemberDao memberDao;
    @Resource
    private BscEmpGroupWebDao empGroupWebDao;
    @Resource
    private SysRoleMemberDao sysRoleMemberDao;
    @Resource
    private BscKnowledgeDao knowledgeDao;
    @Resource
    private BscTopicWebDao topicWebDao;
    @Resource
    private SysCorporationRenewDao corporationRenewDao;
    @Resource
    private SysMenuApplyDao sysMenuApplyDao;
    @Resource
    private SysMenuDao sysMenuDao;
    @Resource
    private SysApplyDao sysApplyDao;
    @Resource
    private SysCompanyRoleService companyRoleService;

    /**
     * 说明：分页查询公司
     *
     * @修改历史： [序号](llp 2015 - 2 - 5)<修改说明>
     */
    public Page queryCorporation(SysCorporation corporation, Integer pageNo, Integer limit) {
        try {
            return this.corporationDao.queryCorporation(corporation, pageNo, limit);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 说明：获取公司
     *
     * @创建：作者:llp 创建时间：2015-2-2
     * @修改历史： [序号](llp 2015 - 2 - 2)<修改说明>
     */
    public SysCorporation queryCorporationById(Integer id) {
        try {
            return this.corporationDao.queryCorporationById(id);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    public SysCorporation get(Integer id) {
        return this.corporationDao.get(id);
    }

    /**
     * 说明：根据数据库查公司
     *
     * @创建：作者:llp 创建时间：2015-2-5
     * @修改历史： [序号](llp 2015 - 2 - 5)<修改说明>
     */
    public SysCorporation queryCorporationBydata(String datasource) {
        try {
            return this.corporationDao.queryCorporationBydata(datasource);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 说明：查询所有公司
     *
     * @创建：作者:zrp 创建时间：2015-2-5
     * @修改历史： [序号](zrp 2015 - 2 - 5)<修改说明>
     */
    public List<String> queryAllDatabase() {
        try {
            return this.corporationDao.queryCorpAll();
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 创建公司
     *
     * @param company
     * @创建：作者:YYP 创建时间：2015-3-13
     */
    public Integer addCompany(SysCorporation company, String spellNm, String deptNm, Integer memId, String isUnitmng, String path) {
        try {
            company.setDatasource(spellNm);
            final Integer companyId = corporationDao.addCompany(company);
            logger.info("保存公司完成");

            // 修改公共平台上成员信息
//            this.memberWebDao.updateMemberBycompany(deptNm, companyId, null, memId, isUnitmng);
            //添加后台管理权限
            SysRoleMember srm = new SysRoleMember();
            srm.setRoleId(8);
            srm.setMemberId(memId);
            logger.info("保存角色 ");
            this.sysRoleMemberDao.addRoleMember(srm);
            logger.info("保存角色完成 ");
//            if (companyId > 0) {
//                logger.info("开始创建数据库 ");
//                spellNm = spellNm + companyId;
//                DBUtil.createDB(spellNm);//创建数据库
//                DBUtil.createTable(path, spellNm);
//            }
//
//            // 查询公共平台用户信息
//            SysMember member = this.memberWebDao.queryMemberById(memId);
//            member.setUnitId(companyId);
//            member.setMemberCompany(company.getDeptNm());
//            member.setIsUnitmng("1");
//
//            member.setBranchId(1);
//            member.setBranchName("总经办");
//            // 添加企业成员
//            this.memberDao.addSysMem(member, spellNm);
//            /***************添加成员角色及菜单*******************/
//            saveRolemember(spellNm, memId);
//            //查询菜单列表
//            List<SysApplyDTO> applyList = sysApplyDao.queryApplyForCompany(8);
//            //添加菜单信息
//            sysMenuApplyDao.saveCorporationMenuApply(applyList, spellNm);
//            //修改员工圈、知识库、帖子等表信息
//            String nowTime = DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd HH:mm:ss");
//            empGroupWebDao.updateGroupMess(memId, nowTime, spellNm);
//            empGroupWebDao.updategMemMess(memId, nowTime, spellNm);
//            topicWebDao.updateTopicMess(memId, nowTime, spellNm);
//            knowledgeDao.updateKnowledgeMess(memId, nowTime, spellNm);
//            knowledgeDao.updateSortMess(memId, nowTime, spellNm);
//            memberDao.deleteAllMember(spellNm, 0);//删除成员表默认信息
//
//
//            //修改轨迹员工信息
//            String urls = "http://api.map.baidu.com/trace/v2/entity/update";
//            String parameters = "ak=gIzggYvrqG7zD5MCsFwSjKOkU8yv8SsC&service_id=117170&entity_name=" + memId + "&entitydatabase=" + spellNm + "";
//            MapGjTool.postMapGjurl(urls, parameters);
            return companyId;
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    //添加成员角色
//    private void saveRolemember(String spellNm, Integer memId) {
//        companyRoleService.addRolemember(spellNm, memId, CompanyRoleEnum.COMPANY_CREATOR.getRole());
//    }
//
//    /**
//     * @param deptId
//     * @param datasource
//     * @创建：作者:YYP 创建时间：2015-3-18
//     */
//    public Integer deleteCorporation(Integer deptId, String datasource) {
//        try {
//            //删除公司
//            Integer info = corporationDao.deleteCorporation(deptId);
//            //查询该公司下的角色
//            List<Map<String, Object>> memIds = sysRoleMemberDao.queryMemIds(datasource);
//            if (null != memIds.get(0).get("memids")) {
//                String string = memIds.get(0).get("memids").toString();
//                sysRoleMemberDao.deleteRoleMemBycid(string);//删除公司后删除对应的公司角色
//            }
//            //取消删除公司会员
//            //memberDao.deleteMemCompany(deptId);
////			empGroupWebDao.deleteEmpGroup(datasource);//删除公司的所有员工圈
//            return info;
//        } catch (Exception e) {
//            throw new ServiceException(e);
//        }
//    }

//    /**
//     * @param company
//     * @return
//     * @创建：作者:YYP 创建时间：2015-3-19
//     */
//    public Integer addPCompany(SysCorporation company, String spellNm, String path) {
//        try {
//            corporationDao.addCompany(company);
//
//			/*Long deptid = company.getDeptId();
//			System.out.println(deptid);
//			*/
//            Integer id = corporationDao.getAutoId();
//            corporationDao.updateCompany(spellNm + id, id);
//            if (id > 0) {
//                spellNm = spellNm + id;
//                DBUtil.createDB(spellNm);//创建数据库
//                DBUtil.createTable(path, spellNm);
//            }
//            return id;
//
//
//			/*corporationDao.addCompany(company);
//
//			return 0;*/
//
//        } catch (Exception e) {
//            throw new ServiceException(e);
//        }
//    }

    /**
     * 查询公司是否已经出现
     *
     * @param deptNm
     * @return
     * @创建：作者:YYP 创建时间：2015-3-19
     */
    public Integer queryIsExit(String deptNm) {
        try {
            return corporationDao.queryIsExit(deptNm);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

//    public SysCorporation queryMemCompany(Integer memId) {
//        try {
//            return corporationDao.queryMemCompany(memId);
//        } catch (Exception e) {
//            throw new ServiceException(e);
//        }
//    }
//
//    /**
//     * 根据会员id查询数据库名称
//     *
//     * @param memberId
//     * @author guojp
//     */
//    public SysCorporation queryDatabaseByMid(Integer memberId) {
//        try {
//            return corporationDao.queryDatabaseByMid(memberId);
//        } catch (Exception e) {
//            throw new ServiceException(e);
//        }
//    }

    /**
     * 修改公司名称
     *
     * @param companyNm
     * @param companyId
     * @param datasource
     */
    public void updateCompanyNm(String companyNm, Integer companyId, String datasource) {
        try {
            corporationDao.updateCompanyNm(companyNm, companyId);
            // 修改公共平台公司名
            corporationDao.updateMemCompanyNm2(companyId, companyNm);
            // 修改企业平台公司名
            corporationDao.updateMemCompanyNm(companyId, companyNm, datasource);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 模糊查询公司
     *
     * @param searchNm
     * @return
     * @创建：作者:YYP 创建时间：2015-5-23
     */
    public List<SysCorporation> queryLikeCompanyNm(String searchNm) {
        try {
            return corporationDao.queryLikeCompanyNm(searchNm);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    public void deleteDB(String datasource) {
        corporationDao.deleteDB(datasource);
    }

    /**
     * 添加公司续费记录
     *
     * @创建：作者:llp 创建时间：2016-7-20
     */
    public int addCorporationRenew(SysCorporationRenew corporationRenew) {
        try {
            String nowDt = DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd");
            String nowDt2 = DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd HH:mm:ss");
            SysCorporation corporation = queryCorporationById(corporationRenew.getDeptsId());
            String time = corporation.getEndDate();
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Date d1 = sdf.parse(nowDt);
            Date d2 = sdf.parse(time);
            String deadline = "";
            if (d1.getTime() >= d2.getTime()) {
                if (corporationRenew.getRenewTime().equals("一个月")) {
                    deadline = DateTimeUtil.dateTimeAddToStr(nowDt, 2, 1, "yyyy-MM-dd");
                } else if (corporationRenew.getRenewTime().equals("一季度")) {
                    deadline = DateTimeUtil.dateTimeAddToStr(nowDt, 2, 3, "yyyy-MM-dd");
                } else if (corporationRenew.getRenewTime().equals("半年")) {
                    deadline = DateTimeUtil.dateTimeAddToStr(nowDt, 2, 6, "yyyy-MM-dd");
                } else if (corporationRenew.getRenewTime().equals("一年")) {
                    deadline = DateTimeUtil.dateTimeAddToStr(nowDt, 1, 1, "yyyy-MM-dd");
                } else if (corporationRenew.getRenewTime().equals("二年")) {
                    deadline = DateTimeUtil.dateTimeAddToStr(nowDt, 1, 2, "yyyy-MM-dd");
                } else if (corporationRenew.getRenewTime().equals("三年")) {
                    deadline = DateTimeUtil.dateTimeAddToStr(nowDt, 1, 3, "yyyy-MM-dd");
                }
            } else {
                if (corporationRenew.getRenewTime().equals("一个月")) {
                    deadline = DateTimeUtil.dateTimeAddToStr(time, 2, 1, "yyyy-MM-dd");
                } else if (corporationRenew.getRenewTime().equals("一季度")) {
                    deadline = DateTimeUtil.dateTimeAddToStr(time, 2, 3, "yyyy-MM-dd");
                } else if (corporationRenew.getRenewTime().equals("半年")) {
                    deadline = DateTimeUtil.dateTimeAddToStr(time, 2, 6, "yyyy-MM-dd");
                } else if (corporationRenew.getRenewTime().equals("一年")) {
                    deadline = DateTimeUtil.dateTimeAddToStr(time, 1, 1, "yyyy-MM-dd");
                } else if (corporationRenew.getRenewTime().equals("二年")) {
                    deadline = DateTimeUtil.dateTimeAddToStr(time, 1, 2, "yyyy-MM-dd");
                } else if (corporationRenew.getRenewTime().equals("三年")) {
                    deadline = DateTimeUtil.dateTimeAddToStr(time, 1, 3, "yyyy-MM-dd");
                }
            }
            corporationRenew.setOperTime(nowDt2);
            corporationRenew.setEndDate(deadline);
            this.corporationRenewDao.addCompanyRenew(corporationRenew);
            this.corporationDao.updateCorporationEt(corporationRenew.getDeptsId(), deadline);
            return 1;
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 查询公司菜单树
     *
     * @param deptId
     * @return
     */
    public List<SysMenu> queryMenuByPidForDeptId(Integer deptId) {
        try {
            String menus = "";
            //获取公司信息
            SysCorporation corporation = queryCorporationById(deptId);
            //查询公司所有菜单菜单id(用，隔开)
            Map<String, Object> menuMap = sysMenuApplyDao.queryMenuApplyByTp(corporation.getDatasource(), "1");
            if (menuMap.get("menuApplys") != null) {
                menus = (String) menuMap.get("menuApplys");
            }
            //查询公司菜单树
            List<SysMenu> menuList = sysMenuDao.queryMenuListForCor(menus);
            return menuList;
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 查询应用树
     *
     * @param deptId
     * @return
     */
    public List<SysMenu> queryApplyByPidForDeptId(Integer deptId) {
        try {
            String applys = "";
            //获取公司信息
            SysCorporation corporation = queryCorporationById(deptId);
            //查询公司所有菜单菜单id(用，隔开)
            Map<String, Object> applyMap = sysMenuApplyDao.queryMenuApplyByTp(corporation.getDatasource(), "2");
            if (applyMap.get("menuApplys") != null) {
                applys = (String) applyMap.get("menuApplys");
            }
            //查询公司菜单树
            return sysApplyDao.queryApplyListForCor(applys);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    public int updateCorporation(SysCorporation bo)
    {
        return this.corporationDao.updateCorporateion(bo);
    }

}
