package com.qweib.cloud.repository.plat;

import com.qweib.cloud.core.dao.JdbcDaoTemplatePlud;
import com.qweib.cloud.core.domain.SysLoginInfo;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.repository.utils.HttpResponseUtils;
import com.qweib.cloud.service.member.common.MemberUseEnum;
import com.qweib.cloud.service.member.domain.corporation.SysCorporationDTO;
import com.qweib.cloud.service.member.domain.member.SysMemberDTO;
import com.qweib.cloud.service.member.retrofit.SysCorporationRequest;
import com.qweib.cloud.service.member.retrofit.SysMemberRequest;
import com.qweib.cloud.utils.Collections3;
import com.qweib.cloud.utils.StrUtil;
import com.qweib.commons.MathUtils;
import com.qweibframework.commons.StringUtils;
import com.qweibframework.commons.http.ResponseUtils;
import com.qweibframework.commons.web.dto.Response;
import org.dozer.Mapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * 说明：系统登录dao
 *
 * @创建：作者:yxy 创建时间：2012-1-12
 * @修改历史： [序号](yxy 2012 - 1 - 12)<修改说明>
 */
@Repository
public class SysLoginDao {
    @Resource(name = "pdaoTemplate")
    private JdbcDaoTemplatePlud daoTemplate;

    @Autowired
    private Mapper mapper;

    public SysLoginInfo queryById(Integer memberId){
        StringBuffer sql = new StringBuffer();
        sql.append(" select member_id as id_key,member_nm as usr_nm,member_pwd as usr_pwd,member_name as usr_no,cid,member_company as fd_company_nm,unit_id as fd_company_id,member_mobile as fd_member_mobile");
        sql.append(",(select datasource from sys_corporation where dept_id=m.unit_id ) as datasource ");
        sql.append(",(select tp_nm from sys_corporation where dept_id=m.unit_id ) as tpNm ");
        sql.append(" from sys_member m where member_id=? and member_use='1' ");
        try {
            return daoTemplate.queryForObj(sql.toString(), SysLoginInfo.class,memberId);
        } catch (Exception ex) {
            throw new DaoException(ex);
        }

//        SysMemberDTO member = HttpResponseUtils.convertResponse(memberRequest.get(memberId));
//        if (member == null || !MemberUseEnum.ENABLED.equals(member.getUsed())) {
//            return null;
//        }
//        SysLoginInfo loginInfo = mapper.map(member, SysLoginInfo.class);
//        if (MathUtils.valid(member.getCompanyId())) {
//            SysCorporationDTO corporationDTO = HttpResponseUtils.convertResponseNull(corporationRequest.get(member.getCompanyId()));
//            if (corporationDTO != null) {
//                loginInfo.setTpNm(corporationDTO.getTpNm());
//                loginInfo.setDatasource(corporationDTO.getDatabase());
//            }
//        }
//        return loginInfo;
    }

    /**
     * 摘要：
     *
     * @param userNo
     * @return
     * @说明：根据用户编号查询用户
     * @创建：作者:yxy 创建时间：2012-1-12
     * @修改历史： [序号](yxy 2012 - 1 - 12)<修改说明>
     */
    public SysLoginInfo queryLoginInfo(String userNo) {
//        SysMemberDTO loginDTO = HttpResponseUtils.convertResponse(memberRequest.getByMobile(userNo));
//        if (loginDTO == null || !MemberUseEnum.ENABLED.equals(loginDTO.getUsed())) {
//            return null;
//        }
//
//        SysLoginInfo loginInfo = mapper.map(loginDTO, SysLoginInfo.class);
//        if (MathUtils.valid(loginDTO.getCompanyId())) {
//            SysCorporationDTO corporationDTO = HttpResponseUtils.convertResponseNull(corporationRequest.get(loginDTO.getCompanyId()));
//            if (corporationDTO != null) {
//                loginInfo.setTpNm(corporationDTO.getTpNm());
//                loginInfo.setDatasource(corporationDTO.getDatabase());
//            }
//        }
//        return loginInfo;
        StringBuffer sql = new StringBuffer();
        sql.append(" select member_id as id_key,member_nm as usr_nm,member_pwd as usr_pwd,member_name as usr_no,cid,member_company as fd_company_nm,unit_id as fd_company_id,member_mobile as fd_member_mobile");
        sql.append(",(select datasource from sys_corporation where dept_id=m.unit_id ) as datasource ");
        sql.append(",(select tp_nm from sys_corporation where dept_id=m.unit_id ) as tpNm ");
        sql.append(" from sys_member m where (member_mobile=? or member_name=?) and member_use='1' ");
        try {
            return daoTemplate.queryForObj(sql.toString(), SysLoginInfo.class, userNo,userNo);
        } catch (Exception ex) {
            throw new DaoException(ex);
        }
    }

    /**
     * @param userId
     * @return
     * @说明：根据用户id查询该用户的角色
     * @创建：作者:yxy 创建时间：2012-3-24
     * @修改历史： [序号](yxy 2012 - 3 - 24)<修改说明>
     */
    public List<Integer> queryRoleIdByUsr(int userId, String datasource) {
        if (StringUtils.isBlank(datasource)) {
            return null;
        }

        StringBuilder sql = new StringBuilder(64);
        sql.append("SELECT role_id ");
        // 查询公司下的成员角色信息
//        if (!StrUtil.isNull(datasource)) {
            sql.append(" FROM ").append(datasource).append(".sys_role_member ");
//        } else {
//            sql.append(" FROM sys_role_member ");
//        }
        sql.append(" WHERE member_id=").append(userId);
        try {
            List<Map<String, Object>> temps = daoTemplate.queryForList(sql.toString());
            if (Collections3.isNotEmpty(temps)) {
                List<Integer> ls = new ArrayList<>();
                for (Map<String, Object> map : temps) {
                    Integer roleId = StrUtil.convertInt(map.get("role_id"));
                    ls.add(roleId);
                }
                return ls;
            } else {
                return null;
            }
        } catch (Exception ex) {
            throw new DaoException(ex);
        }
    }

    /**
     * 摘要：
     *
     * @param id
     * @param newPwd
     * @说明：修改密码
     * @创建：作者:yxy 创建时间：2012-3-24
     * @修改历史： [序号](yxy 2012 - 3 - 24)<修改说明>
     */
    public Boolean updatePwd(Integer id, String oldPwd, String newPwd) {
        String sql = " update sys_member set member_pwd='" + newPwd + "' where member_id=" + id.toString();
        try {
            daoTemplate.update(sql);
            return true;
        } catch (Exception ex) {
            throw new DaoException(ex);
        }
//        try {
//            Response<Boolean> response = ResponseUtils.syncRequest(memberRequest.updatePwd(id, oldPwd, newPwd));
//            if (response.isSuccess()) {
//                return response.getData();
//            } else {
//                return false;
//            }
//        } catch (Exception ex) {
//            throw new ServiceException(ex);
//        }
    }
}
