package com.qweib.cloud.biz.system.service;

import com.qweib.cloud.core.domain.SysRole;
import com.qweib.cloud.core.domain.SysRoleMember;
import com.qweib.cloud.core.domain.SysSalesman;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.repository.SysSalesmanDao;
import com.qweib.cloud.repository.company.SysCompanyRoleDao;
import com.qweib.cloud.repository.plat.SysRoleDao;
import com.qweib.cloud.service.member.common.RoleValueEnum;
import com.qweib.cloud.utils.Page;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;
import java.util.Objects;
import java.util.Optional;

/**
 * @author: yueji.hu
 * @time: 2019-08-07 10:52
 * @description:
 */
@Service
public class SysSalesmanService {
    @Resource
    private SysSalesmanDao sysSalesmanDao;
    @Autowired
    private SysCompanyRoleDao companyRoleDao;
    @Autowired
    private SysRoleDao roleDao;

    public Page queryData(SysSalesman vo, int page, int rows, String database) {
        try {
            return this.sysSalesmanDao.queryData(vo, page, rows, database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    public List<SysSalesman> queryList(SysSalesman vo, String database) {
        return this.sysSalesmanDao.queryList(vo, database);
    }

    public int addData(SysSalesman bo, String database) {
        try {
            return this.sysSalesmanDao.addData(bo, database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    public int updateData(SysSalesman bo, String database) {
        try {
            return this.sysSalesmanDao.updateData(bo, database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    public void updateMemberId(Integer id, String tel, Integer memberId, String database) {
        SysSalesman oldSalesman = this.sysSalesmanDao.queryById(id, database);
        final Integer oldMemberId = oldSalesman.getMemberId();
        if (Objects.equals(oldMemberId, memberId)) {
            return;
        }
        Optional.ofNullable(roleDao.queryByRoleCode(RoleValueEnum.BUSINESS_PEOPLE.getCode(), database))
                .ifPresent(roleInfo -> {
                    final Integer roleId = roleInfo.getIdKey();
                    if (Objects.nonNull(oldMemberId)) {
                        companyRoleDao.deleteCustomRoleByMemberId(database, roleId, oldMemberId);
                        Long count = Optional.ofNullable(companyRoleDao.countMemberRoles(oldMemberId, database)).orElse(0L);
                        // 如果没有其他角色，默认添加普通员工
                        if (count < 1) {
                            SysRole generalRole = companyRoleDao.queryRoleByRolecd(RoleValueEnum.GENERAL_STAFF.getCode(), database);
                            if (Objects.nonNull(generalRole)) {
                                companyRoleDao.addCompanyRoleUsr(new Integer[]{oldMemberId}, generalRole.getIdKey(), database);
                            }
                        }
                    }
                    if (Objects.nonNull(memberId) && Objects.isNull(companyRoleDao.queryByRoleIdAndMemberId(roleId, memberId, database))) {
                        SysRoleMember roleMember = new SysRoleMember();
                        roleMember.setRoleId(roleId);
                        roleMember.setMemberId(memberId);
                        companyRoleDao.addCompanyRolemember(roleMember, database);
                    }
                });
        this.sysSalesmanDao.updateMemberId(id, tel, memberId, database);
    }

//    public int deleteData(Integer id, String database) {
//        try {
//            return this.sysSalesmanDao.deleteData(id, database);
//        } catch (Exception e) {
//            throw new ServiceException(e);
//        }
//    }

    public SysSalesman findByName(String salesmanName, String database) {
        try {
            return this.sysSalesmanDao.findByName(salesmanName, database);

        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    public SysSalesman queryById(Integer id, String database) {
        try {
            return this.sysSalesmanDao.queryById(id, database);

        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

}
