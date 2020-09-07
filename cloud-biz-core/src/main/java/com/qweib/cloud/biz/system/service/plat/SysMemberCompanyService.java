package com.qweib.cloud.biz.system.service.plat;

import com.google.common.collect.Lists;
import com.qweib.cloud.core.domain.SysMemberCompany;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.repository.plat.SysMemberCompanyDao;
import com.qweib.cloud.service.member.common.CompanyStatusEnum;
import com.qweib.cloud.service.member.domain.member.SysMemberCompanyDTO;
import com.qweib.cloud.service.member.domain.member.SysMemberCompanyLeaveTime;
import com.qweib.cloud.service.member.domain.member.SysMemberCompanyQuery;
import com.qweib.cloud.utils.Collections3;
import com.qweib.cloud.utils.Page;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;
import java.util.Optional;

@Service
public class SysMemberCompanyService {
    @Resource
    private SysMemberCompanyDao memberCompanyDao;

    public Page querySysMemberCompany(SysMemberCompany member, Integer page, Integer limit) {
        try {
            return this.memberCompanyDao.querySysMemberCompany(member, page, limit);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public void addSysMemberCompany(SysMemberCompany member) {
        try {

                this.memberCompanyDao.addSysMemberCompany(member);

        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public SysMemberCompany getMemberCompany(Integer memberId, Integer companyId) {
        return this.memberCompanyDao.getMemberCompany(memberId, companyId);
    }

    public void updateMemberCompanyLeaveTime(SysMemberCompanyLeaveTime input) {
        try {
            this.memberCompanyDao.updateMemberCompanyLeaveTime(input);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

//    public SysMemberCompany querySysMemberCompanyById(Integer Id) {
//        try {
//            return this.memberCompanyDao.querySysMemberCompanyById(Id);
//        } catch (Exception e) {
//            throw new DaoException(e);
//        }
//    }

//    public List<SysMemberCompanyDTO> querySysMemberCompanyList(SysMemberCompanyQuery query) {
//        List<SysMemberCompanyDTO> resultList = Lists.newArrayList();
//        List<SysMemberCompanyDTO> memberCompanyDTOS = this.memberCompanyDao.querySysMemberCompanyList(query);
//        if (Collections3.isNotEmpty(memberCompanyDTOS)) {
//            for (SysMemberCompanyDTO memberCompanyDTO : memberCompanyDTOS) {
//                if (!CompanyStatusEnum.ENABLED.equals(memberCompanyDTO.getCompanyStatus())) {
//                    continue;
//                }
//
//                resultList.add(memberCompanyDTO);
//            }
//        }
//
//        return resultList;
//    }

    public List<SysMemberCompany> querySysMemberCompanyList(SysMemberCompany member) {
       return this.memberCompanyDao.querySysMemberCompanyList(member);
    }

//    public int querySysMemberCompanyByTel(String tel) {
//        try {
//            return this.memberCompanyDao.querySysMemberCompanyByTel(tel);
//        } catch (Exception e) {
//            throw new DaoException(e);
//        }
//    }
}
