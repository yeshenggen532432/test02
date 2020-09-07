package com.qweib.cloud.repository.plat;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.dao.JdbcDaoTemplatePlud;
import com.qweib.cloud.core.domain.SysMemberCompany;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.service.member.domain.member.SysMemberCompanyDTO;
import com.qweib.cloud.service.member.domain.member.SysMemberCompanyLeaveTime;
import com.qweib.cloud.service.member.domain.member.SysMemberCompanyQuery;
import com.qweib.cloud.service.member.domain.member.SysMemberCompanySave;
import com.qweib.cloud.service.member.retrofit.SysMemberCompanyRequest;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import com.qweibframework.commons.http.ResponseUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
public class SysMemberCompanyDao {
    @Resource(name = "pdaoTemplate")
    private JdbcDaoTemplatePlud daoTemplate1;
    @Resource(name = "daoTemplate")
    private JdbcDaoTemplate daoTemplate2;



    public Page querySysMemberCompany(SysMemberCompany member, Integer page, Integer limit) {
        StringBuilder sql = new StringBuilder();
        sql.append(" select * from sys_member_company where 1=1 ");
        if (null != member) {
            if (!StrUtil.isNull(member.getMemberCompany())) {
                sql.append(" and member_company like '%" + member.getMemberCompany() + "%' ");
            }
            if (!StrUtil.isNull(member.getMemberNm())) {
                sql.append(" and member_nm like '%" + member.getMemberNm() + "%' ");
            }
            if (!StrUtil.isNull(member.getMemberMobile())) {
                sql.append(" and member_mobile like '%" + member.getMemberMobile() + "%' ");
            }
        }
        sql.append(" order by member_id desc ");
        try {
            return this.daoTemplate2.queryForPageByMySql(sql.toString(), page, limit, SysMemberCompany.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public Integer addSysMemberCompany(SysMemberCompany member) {
        SysMemberCompanySave memberCompanySave = new SysMemberCompanySave();
        memberCompanySave.setMemberId(member.getMemberId());
        memberCompanySave.setCompanyId(member.getCompanyId());
        memberCompanySave.setCompanyName(member.getMemberCompany());
        memberCompanySave.setMemberName(member.getMemberNm());
        memberCompanySave.setMobile(member.getMemberMobile());
        memberCompanySave.setJob(member.getMemberJob());
        memberCompanySave.setTrade(member.getMemberTrade());
        memberCompanySave.setEntryTime(member.getInTime());
        return this.daoTemplate1.addByObject("sys_member_company",member);

        //return ResponseUtils.convertResponse(memberCompanyRequest.save(memberCompanySave));

//        try {
//            /*****用于更改id生成方式 by guojr******/
//            Integer memId = this.daoTemplate1.addByObject("sys_member_company", member);
//            return memId;
//        } catch (Exception e) {
//            throw new DaoException(e);
//        }
    }

    public SysMemberCompany getMemberCompany(Integer memberId, Integer companyId) {
        try{
            String sql = "select * from sys_member_company where member_id=" + memberId + " and company_id=" + companyId;

            List<SysMemberCompany> list = this.daoTemplate1.queryForLists(sql, SysMemberCompany.class);
            if(list.size() > 0)return list.get(0);
            return null;
        } catch (Exception e) {
            throw new DaoException(e);
        }
        //return ResponseUtils.convertResponseNull(memberCompanyRequest.getByMemberAndCompany(memberId, companyId));
    }

    public void updateMemberCompanyLeaveTime(SysMemberCompanyLeaveTime input) {
//        try {
//            Map<String, Object> whereParam = new HashMap<String, Object>();
//            whereParam.put("fd_id", member.getFdId());
//            this.daoTemplate1.updateByObject("sys_member_company", member, whereParam, "fd_id");
//        } catch (Exception e) {
//            throw new DaoException(e);
//        }

        //ResponseUtils.syncRequest(memberCompanyRequest.updateLeaveTime(input));
    }

    public SysMemberCompany querySysMemberCompanyById(Integer Id) {
        try {
            String sql = "select * from sys_member_company where member_id=? ";
            return this.daoTemplate1.queryForObj(sql, SysMemberCompany.class, Id);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public List<SysMemberCompany> querySysMemberCompanyList(SysMemberCompany member){
        try{
            String sql = "select a.*,b.dept_nm from sys_member_company a left join sys_corporation b on a.company_id=b.dept_id where 1=1 ";
            if(member!=null){
                if(!StrUtil.isNull(member.getMemberId())){
                    sql = sql + " and a.member_id="+member.getMemberId();
                }
                if(!StrUtil.isNull(member.getCompanyId())){
                    sql = sql +" and a.company_id="+member.getCompanyId();
                }
                if(!StrUtil.isNull(member.getMemberMobile())){
                    sql = sql +" and (a.member_mobile='"+member.getMemberMobile()+"')";
                }
                if(!StrUtil.isNull(member.getOutTime())){
                    sql = sql + " and (a.out_time is null or a.out_time ='')";
                }
            }
            List<SysMemberCompany> list = this.daoTemplate1.queryForLists(sql, SysMemberCompany.class);
            for(SysMemberCompany vo: list)
                vo.setMemberCompany(vo.getDeptNm());
            return list;
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }


    public List<SysMemberCompanyDTO> querySysMemberCompanyList1(SysMemberCompanyQuery query) {
//        StringBuilder sql = new StringBuilder(128);
//        sql.append("SELECT a.* FROM sys_member_company a WHERE 1=1");
//        List<Object> values = Lists.newArrayList();

//        SysMemberCompanyQuery query = new SysMemberCompanyQuery();
//        if (member != null) {
//            if (!StrUtil.isNull(member.getMemberId())) {
//                query.setMemberId(member.getMemberId());
//            }
//            if (!StrUtil.isNull(member.getCompanyId())) {
//                query.setCompanyId(member.getCompanyId());
//            }
////            if (!StrUtil.isNull(member.getMemberMobile())) {
////                sql.append(" AND a.member_mobile=?");
////                values.add(member.getMemberMobile());
////            }
//            if (!StrUtil.isNull(member.getOutTime())) {
//                query.setDimission(false);
//            }
//        }
       // return ResponseUtils.convertResponse(memberCompanyRequest.list(query));
        return null;
    }

//    public int querySysMemberCompanyByTel(String tel) {
//        String sql = "select count(1) from sys_member_company where member_mobile=?";
//        try {
//            return this.daoTemplate1.queryForObject(sql, new Object[]{tel}, Integer.class);
//        } catch (Exception e) {
//            throw new DaoException(e);
//        }
//    }

}

