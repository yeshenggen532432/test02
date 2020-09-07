package com.qweib.cloud.repository.plat;

import com.google.common.collect.Lists;
import com.qweib.cloud.biz.common.CompanyRoleEnum;
import com.qweib.cloud.biz.customer.duplicate.DuplicateInvoker;
import com.qweib.cloud.biz.customer.duplicate.dto.CustomerDTO;
import com.qweib.cloud.biz.customer.duplicate.dto.CustomerTypeEnum;
import com.qweib.cloud.biz.customer.duplicate.dto.ResultDTO;
import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.dao.JdbcDaoTemplatePlud;
import com.qweib.cloud.core.domain.SysMemDTO;
import com.qweib.cloud.core.domain.SysMember;
import com.qweib.cloud.core.domain.vo.SysMemberTypeEnum;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.memberEvent.MemberPublisher;
import com.qweib.cloud.repository.utils.HttpResponseUtils;
import com.qweib.cloud.repository.utils.MemberUtils;
import com.qweib.cloud.service.member.common.MemberListQueryEnum;
import com.qweib.cloud.service.member.common.MemberSelectQueryEnum;
import com.qweib.cloud.service.member.common.MemberUpdatePropertyEnum;
import com.qweib.cloud.service.member.domain.member.*;
import com.qweib.cloud.service.member.retrofit.SysCorporationRequest;
import com.qweib.cloud.service.member.retrofit.SysMemberRequest;
import com.qweib.cloud.utils.MemberConstants;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import com.qweib.cloud.utils.pinyingTool;
import com.qweib.commons.Collections3;
import com.qweibframework.commons.http.ResponseUtils;
import org.dozer.Mapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
public class SysMemberDao {
    @Resource(name = "pdaoTemplate")
    private JdbcDaoTemplatePlud daoTemplate1;
    @Resource(name = "daoTemplate")
    private JdbcDaoTemplate daoTemplate2;
    @Autowired
    private Mapper mapper;
    @Autowired
    private DuplicateInvoker duplicateInvoker;
    @Autowired
    private MemberPublisher memberPublisher;

    public List<SysMember> getServiceList(String datasource) {
        String sql = "select u.member_id memberId,u.member_nm memberNm,u.member_mobile memberMobile from " + datasource + ".sys_mem u where u.is_customer_service > 0";
        return daoTemplate1.query(sql, new BeanPropertyRowMapper<>(SysMember.class));
    }

    /**
     * 说明：分页查询成员（后台）
     *
     * @创建：作者:llp 创建时间：2015-2-2
     * @修改历史： [序号](llp 2015 - 2 - 3)<修改说明>
     */
    public Page querySysMember(SysMember member, Integer pageNo, Integer limit, String dataTp, String depts,
                               String invisibleDepts, Integer memberId) {
//        if (StringUtils.isNotBlank(member.getDatasource())) {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT m.*,d.branch_name as branchName,u.upload,u.min,u.mem_upload ");
        sql.append(" FROM ").append(member.getDatasource()).append(".sys_mem m ");
        sql.append(" LEFT JOIN ").append(member.getDatasource()).append(".sys_depart d on d.branch_id=m.branch_id ");
        // 位置上传方式
        sql.append(" LEFT JOIN ").append(member.getDatasource()).append(".sys_address_upload u on u.mem_id=m.member_id ");
        sql.append(" WHERE 1=1 ");

        // 个人
        if ("3".equals(dataTp)) {
            sql.append(" and m.member_id=" + memberId);
        } else {
            if (null != member) {
                if (!StrUtil.isNull(member.getMemberCompany())) {
                    sql.append(" and m.member_company like '%" + member.getMemberCompany() + "%' ");
                }
                if (!StrUtil.isNull(member.getMemberNm())) {
                    sql.append(" and m.member_nm like '%" + member.getMemberNm() + "%' ");
                }
                if (!StrUtil.isNull(member.getMemberMobile())) {
                    sql.append(" and m.member_mobile like '%" + member.getMemberMobile() + "%' ");
                }
                if (!StrUtil.isNull(member.getMemberUse())) {
                    sql.append(" and m.member_use='" + member.getMemberUse() + "' ");
                }
                //增加默认显示普通员工
                if (member.getMemberType() == null) {
                    //sql.append(" and m.member_type & ").append(SysMemberTypeEnum.general.getType()).append("=").append(SysMemberTypeEnum.general.getType());
                    sql.append(MemberUtils.defMemberType("m"));
                } else {
                    sql.append(" and m.member_type & ").append(member.getMemberType()).append("=").append(member.getMemberType());
                }
            }
            // 部门及子部门数据不为空
            if (!StrUtil.isNull(depts)) {
                sql.append(" and m.branch_id in (" + depts + ") ");
            }
            // 不可见部门不为空
            if (!StrUtil.isNull(invisibleDepts)) {
                sql.append(" and m.branch_id not in (" + invisibleDepts + ") ");
            }
           /* if (StringUtils.equals(member.getIsDel(), "0")) {
                sql.append(" and (m.is_del <> 1 or m.is_del is null) ");
            }else if(StringUtils.equals(member.getIsDel(), "1")){
                sql.append(" and m.is_del = 1 ");
            }*/
        }
        sql.append(" order by m.member_id desc ");
        try {
            return this.daoTemplate1.queryForPageByMySql(sql.toString(), pageNo, limit, SysMember.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
//        } else {
//            SysMemberQuery query = new SysMemberQuery();
//            if (member != null) {
//                query.setCompany(member.getMemberCompany());
//                query.setName(member.getMemberNm());
//                query.setMobile(member.getMemberMobile());
//                query.setUsed(MemberUseEnum.getByState(member.getMemberUse()));
//            }
//            // 部门及子部门数据不为空
//            if (StringUtils.isNotBlank(depts)) {
//                query.setExistBranchIds(depts);
//            }
//            // 不可见部门不为空
//            if (StringUtils.isNotBlank(invisibleDepts)) {
//                query.setNotExistBranchIds(invisibleDepts);
//            }
//            // 个人
//            if (SysMemberTypeEnum.PERSON.getType().equals(dataTp)) {
//                query.setMemberType(SysMemberTypeEnum.PERSON);
//            }
//
//            com.qweibframework.commons.page.Page<SysMemberDTO> httpPage = HttpResponseUtils.convertResponse(memberRequest.page(query, pageNo - 1, limit));
//            final Page page = new Page();
//            page.setPageSize(limit);
//            page.setCurPage(httpPage.getPage() + 1);
//            final List<SysMember> dataList = Lists.newArrayList();
//            if (Collections3.isNotEmpty(httpPage.getData())) {
//                for (SysMemberDTO memberDTO : httpPage.getData()) {
//                    SysMember sysMember = mapper.map(memberDTO, SysMember.class);
//                    dataList.add(sysMember);
//                }
//            }
//            page.setRows(dataList);
//            page.setTotal((int) httpPage.getTotalCount());
//
//            return page;
//        }
    }

    //查分页查询成员（后台）-----增加可见部门的查询
    public Page querySysMember(SysMember member, Integer page, Integer limit,
                               String dataTp, String depts, String visibleDepts,
                               String invisibleDepts, Integer memberId) {
        String datasource = member.getDatasource();
        StringBuilder sql = new StringBuilder();
        sql.append(" SELECT DISTINCT t.*,d.branch_name as branchName FROM (");
        sql.append(" SELECT * FROM " + datasource + ".sys_mem WHERE 1=1 ");
        if (!StrUtil.isNull(depts)) {//部门及子部门数据不为空
            sql.append(" AND branch_id IN (" + depts + ") ");
        }
        if ("3".equals(dataTp)) {//个人
            sql.append(" AND member_id=" + memberId);
        }
        sql.append(" UNION ALL ");
        sql.append(" SELECT * FROM " + datasource + ".sys_mem WHERE 1=1 AND branch_id IN (" + visibleDepts + ") ");
        sql.append(" ) t ");
        sql.append(" LEFT JOIN " + datasource + ".sys_depart d on d.branch_id=t.branch_id where 1=1 ");
        if (null != member) {
            if (!StrUtil.isNull(member.getMemberCompany())) {
                sql.append(" and t.member_company like '%" + member.getMemberCompany() + "%' ");
            }
            if (!StrUtil.isNull(member.getMemberNm())) {
                sql.append(" and t.member_nm like '%" + member.getMemberNm() + "%' ");
            }
            if (!StrUtil.isNull(member.getMemberMobile())) {
                sql.append(" and t.member_mobile like '%" + member.getMemberMobile() + "%' ");
            }
            if (!StrUtil.isNull(member.getMemberUse())) {
                sql.append(" and t.member_use='" + member.getMemberUse() + "' ");
            }
        }
        if (!StrUtil.isNull(invisibleDepts)) {//不可见部门不为空
            sql.append(" and t.branch_id not in (" + invisibleDepts + ") ");
        }
        sql.append(" order by t.member_id desc ");
        try {
            return this.daoTemplate1.queryForPageByMySql(sql.toString(), page, limit, SysMember.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public Page querySysMember(SysMember member, Integer page, Integer limit, String database) {
        StringBuilder sql = new StringBuilder();
        sql.append(" select * from " + database + ".sys_mem where 1=1 ");
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
            //判断是否企业管理员登陆
            if (!StrUtil.isNull(member.getUnitId())) {
                if (member.getUnitId() != 0) {
                    sql.append(" and unit_id=" + member.getUnitId() + " ");
                }
            }
        }
        sql.append(" order by member_id desc ");
        try {
            return this.daoTemplate2.queryForPageByMySql(sql.toString(), page, limit, SysMember.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：添加成员
     *
     * @创建：作者:llp 创建时间：2015-2-2
     * @修改历史： [序号](llp 2015 - 2 - 2)<修改说明>
     */
    public Integer addSysMember(SysMember member) {
        try {
            if (member.getMemberType() == null) member.setMemberType(SysMemberTypeEnum.general.getType());
            /*****用于更改id生成方式 by guojr******/
            Integer memId = this.daoTemplate1.addByObject("sys_member", member);
            SysMemberSave memberSave = mapper.map(member, SysMemberSave.class);
            memberSave.setRegisterSource(MemberConstants.REGISTER_SOURCE_COMPANY_MEMBER);
            //Integer memId = HttpResponseUtils.convertResponse(memberRequest.save(memberSave));
            member.setMemberId(memId);
            ResultDTO resultDTO = this.duplicateInvoker.invoke(member.getDatasource(), new CustomerDTO(member.getMemberId(), CustomerTypeEnum.SysMem, member.getMemberNm()));
            if (resultDTO.isFound()) {
                member.setMemberNm(resultDTO.getSuggestName());
            }
            this.daoTemplate2.addByObject(member.getDatasource() + ".sys_mem", member);
            return memId;
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 添加企业端成员
     *
     * @param member
     * @return
     */
    public Integer addCompanySysMember(SysMember member) {
        try {
            if (member.getMemberType() == null) member.setMemberType(SysMemberTypeEnum.general.getType());
            ResultDTO resultDTO = this.duplicateInvoker.invoke(member.getDatasource(), new CustomerDTO(member.getMemberId(), CustomerTypeEnum.SysMem, member.getMemberNm()));
            if (resultDTO.isFound()) {
                member.setMemberNm(resultDTO.getSuggestName());
            }
            Integer memId = this.daoTemplate2.addByObject(member.getDatasource() + ".sys_mem", member);
            //通知商城会员操作
            //memberPublisher.staffChange(member.getMemberMobile(), member.getMemberNm(), member.getDatasource());
            return memId;
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：添加成员(excel导入)
     *
     * @创建：作者:llp 创建时间：2015-2-6
     * @修改历史： [序号](llp 2015 - 2 - 6)<修改说明>
     */
    //导入统一走同一方法，此方法有问题
    @Deprecated
    public void addSysMemberls(List<SysMember> memberls, String companyId) {
        try {
            for (int i = 0; i < memberls.size(); i++) {
                SysMember member = memberls.get(i);
                member.setMemberActivate("1");
                member.setMemberUse("1");
                member.setFirstChar(pinyingTool.getFirstLetter(member.getMemberNm()).toUpperCase());
                member.setState("2");

                /*****用于更改id生成方式 by guojr******/
                int id = this.daoTemplate1.addByObject("sys_member", member);
                member.setMemberId(id);
                this.daoTemplate2.addByObject("" + member.getDatasource() + ".sys_mem", member);
                //FIXME
				/*String reqJsonStr="{\"company_id\":\""+member.getPlatformCompanyId()+"\", \"realname\":\""+URLEncoder.encode (member.getMemberNm(), "UTF-8" )+"\",\"mobile\":\""+member.getMemberMobile()+"\"}";
				String js=MapGjTool.postqq("http://" + outUrl + "/company/editEmployee", reqJsonStr);
				JSONObject dataJson=new JSONObject(js);
				if(dataJson.getInt("code")!=0){
					System.out.println(dataJson.getInt("msg"));
				}else{
					String platformUserId=dataJson.getJSONObject("data").getString("user_id");
					String sql2="update sys_member set platform_user_id=? where member_id=? ";
					this.daoTemplate1.update(sql2,platformUserId, id);
				}
                //创建轨迹员工
				String urls="http://api.map.baidu.com/trace/v2/entity/add";
				String parameters="ak=gIzggYvrqG7zD5MCsFwSjKOkU8yv8SsC&service_id=117170&entity_name="+id+"&entitydatabase="+member.getDatasource()+"";
				MapGjTool.postMapGjurl(urls, parameters);
                //创建轨迹员工2
				String urls2=QiniuControl.GPS_SERVICE_URL+"/User/postLocation";
				String parameters2="company_id="+member.getUnitId()+"&user_id="+id+"&location=[{\"longitude\":14.22222,\"latitude\":23.25555,\"address\":\"\",\"location_time\":"+StrUtil.getDqsjc()+",\"location_from\":\"\",\"os\":\"\"}]";
				MapGjTool.postMapGjurl2(urls2, parameters2);*/
            }
        } catch (Exception e) {
            throw new DaoException(e);
        }

//        for (int i = 0; i < memberls.size(); i++) {
//            SysMember member = memberls.get(i);
//            member.setMemberActivate("1");
//            member.setMemberUse("1");
//            member.setFirstChar(pinyingTool.getFirstLetter(member.getMemberNm()).toUpperCase());
//            member.setState("2");
//
//
//            /*****用于更改id生成方式 by guojr******/
//            if (member.getMemberId() == null) {//如果存在会员ID时说明是修改（编辑后导入功能）zzx
//                Integer id = null;
//                SysMember sysMember = queryPlatSysMemberbyTel(member.getMemberMobile());
//                if (sysMember != null) {
//                    id = sysMember.getMemberId();
//                }
//                if (id == null) {
//                    SysMemberSave input = mapper.map(member, SysMemberSave.class);
//                    input.setRegisterSource(MemberConstants.REGISTER_SOURCE_EXCEL);
//                    id = HttpResponseUtils.convertResponse(memberRequest.save(input));
//                }
//                member.setMemberId(id);
//                addCompanySysMember(member);
//            } else {
//                updateSysMember(member, companyId);
//            }
//        }
    }

    /**
     * 说明：修改成员（后台）
     *
     * @创建：作者:llp 创建时间：2015-2-2
     * @修改历史： [序号](llp 2015 - 2 - 2)<修改说明>
     */
    public void updateSysMember(SysMember member, String companyId) {
        try {
//            SysMemberUpdate input = mapper.map(member, SysMemberUpdate.class);
//            HttpResponseUtils.convertResponse(memberRequest.update(input));
//
//            ResultDTO resultDTO = this.duplicateInvoker.invoke(member.getDatasource(), new CustomerDTO(member.getMemberId(), CustomerTypeEnum.SysMem, member.getMemberNm()));
//            if (resultDTO.isFound()) {
//                member.setMemberNm(resultDTO.getSuggestName());
//            }
            Map<String, Object> whereParam = new HashMap<>(2);
            whereParam.put("member_id", member.getMemberId());
            this.daoTemplate1.updateByObject("sys_member", member, whereParam, "member_id");
            if (!StrUtil.isNull(member.getDatasource())) {
                this.daoTemplate2.updateByObject("" + member.getDatasource() + ".sys_mem", member, whereParam, "member_id");
            }
            memberPublisher.staffUpdate(member, member.getDatasource(), companyId);//修改商城员工会员
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public void updatePlatSysMember(SysMember member) {
        try {
            Map<String, Object> whereParam = new HashMap<String, Object>();
            whereParam.put("member_id", member.getMemberId());
            this.daoTemplate1.updateByObject("sys_member", member, whereParam, "member_id");
        } catch (Exception e) {
            throw new DaoException(e);
        }
//        SysMemberUpdate input = mapper.map(member, SysMemberUpdate.class);
//        HttpResponseUtils.convertResponse(memberRequest.update(input));
    }

    public Boolean updateSysMemberPassword(Integer memberId, String newPwd) {
        String sql = "update publicplat.sys_member set member_pwd='" + newPwd + "' where member_id='" + memberId + "'";
        this.daoTemplate1.update(sql);
        return true;

        //return ResponseUtils.convertResponse(memberRequest.updatePwdByPlat(memberId, newPwd));
    }

    public void updateCompanySysMember(SysMember member, String datasource, String companyId) {
        try {
            ResultDTO resultDTO = this.duplicateInvoker.invoke(member.getDatasource(), new CustomerDTO(member.getMemberId(), CustomerTypeEnum.SysMem, member.getMemberNm()));
            if (resultDTO.isFound()) {
                member.setMemberNm(resultDTO.getSuggestName());
            }
            Map<String, Object> whereParam = new HashMap<>();
            whereParam.put("member_id", member.getMemberId());
            this.daoTemplate2.updateByObject(datasource + ".sys_mem", member, whereParam, "member_id");
            memberPublisher.staffUpdate(member, datasource, companyId);//修改商城员工会员
        } catch (Exception e) {
            throw new DaoException(e);
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
            String sql = new StringBuilder(48)
                    .append("update ").append(datasource).append(".sys_customer set branch_id=? where mem_id=?").toString();
            this.daoTemplate1.update(sql, branchId, memberId);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：获取成员(公共)
     *
     * @创建：作者:llp 创建时间：2015-2-2
     * @修改历史： [序号](llp 2015 - 2 - 2)<修改说明>
     */
    public SysMember querySysMemberById(Integer id) {
        try {
            String sql = "select * from sys_member where member_id=? ";
            return this.daoTemplate1.queryForObj(sql, SysMember.class, id);
        } catch (Exception e) {
            throw new DaoException(e);
        }
        //return HttpResponseUtils.convertToEntity(memberRequest.get(id), SysMember.class, mapper);
    }

    public int queryBranchId(Integer id, String database) {
        String sql = "select count(1) from " + database + ".sys_mem where branch_id=?  and member_use =1 ";
        try {
            return this.daoTemplate1.queryForObject(sql, new Object[]{id}, Integer.class);
        } catch (Exception e) {
            throw new DaoException(e);
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
            String sql = "select * from " + datasource + ".sys_mem where member_id=? ";
            return this.daoTemplate2.queryForObj(sql, SysMember.class, Id);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public SysMember querySysMemberByAccNo(String accNo,String datasource) {
        try {
            String sql = "select * from " + datasource + ".sys_mem where member_name=? ";
            return this.daoTemplate2.queryForObj(sql, SysMember.class, accNo);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }


    /**
     * 查找企业系统管理员 id
     *
     * @param database
     * @return
     */
    public Integer queryAdminMemberId(String database) {
        String sql = "SELECT m.member_id FROM " + database + ".sys_role_member m" +
                " LEFT JOIN " + database + ".sys_role r ON m.role_id = r.id_key" +
                " WHERE r.role_cd = ?";

        List<Integer> list = this.daoTemplate2.query(sql, new Object[]{CompanyRoleEnum.COMPANY_ADMIN.getRole()}, new RowMapper<Integer>() {

            @Override
            public Integer mapRow(ResultSet rs, int rowNum) throws SQLException {
                return rs.getInt("member_id");
            }
        });

        return Collections3.isNotEmpty(list) ? list.get(0) : null;
    }

    /**
     * 说明：获取成员(企业)
     */
    public SysMember queryCompanySysMemberById(String datasource, Integer Id) {
        try {
            String sql = "select * from " + datasource + ".sys_mem where member_id=? ";
            return this.daoTemplate2.queryForObj(sql, SysMember.class, Id);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    //

    public SysMember queryCompanySysMemberByName(String datasource, String name) {
        try {
            String sql = "select * from " + datasource + ".sys_mem where member_nm='" + name + "' ";
            List<SysMember> list = this.daoTemplate2.queryForLists(sql, SysMember.class);
            if (list != null && list.size() > 0) {
                return list.get(0);
            }
            return null;
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：根据手机号码获取成员条数
     *
     * @创建：作者:llp 创建时间：2015-2-3
     * @修改历史： [序号](llp 2015 - 2 - 3)<修改说明>
     */
    public int querySysMemberByTel(String tel) {
        String sql = " select count(1) from sys_member where member_mobile=? ";
        try {
            return this.daoTemplate1.queryForObject(sql, new Object[]{tel}, Integer.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
//        try {
//            SysMemberDTO memberDTO = HttpResponseUtils.convertResponseNull(memberRequest.getByMobile(tel));
//            return memberDTO != null ? 1 : 0;
//        } catch (Exception e) {
//            throw new ServiceException(e);
//        }
    }

    public SysMember queryPlatSysMemberbyTel(String tel) {
        String sql = "select * from sys_member where member_mobile=?";
        try {
            List<SysMember> list = this.daoTemplate1.queryForLists(sql, SysMember.class, new Object[]{tel});
            if (list != null && list.size() > 0) {
                return list.get(0);
            } else {
                return null;
            }
        } catch (Exception e) {
            throw new DaoException(e);
        }

//        SysMemberDTO memberDTO = MemberUtils.getByMobile(memberRequest, corporationRequest, tel);
//        if (memberDTO == null) {
//            return null;
//        }
//        return mapper.map(memberDTO, SysMember.class);
    }

    public SysMember queryPlatSysMemberbyAccNo(String tel) {
        String sql = "select * from sys_member where member_name=?";
        try {
            List<SysMember> list = this.daoTemplate1.queryForLists(sql, SysMember.class, new Object[]{tel});
            if (list != null && list.size() > 0) {
                return list.get(0);
            } else {
                return null;
            }
        } catch (Exception e) {
            throw new DaoException(e);
        }

//        SysMemberDTO memberDTO = MemberUtils.getByMobile(memberRequest, corporationRequest, tel);
//        if (memberDTO == null) {
//            return null;
//        }
//        return mapper.map(memberDTO, SysMember.class);
    }

    /**
     * 说明：添加成员(邀请同事)
     *
     * @创建：作者:llp 创建时间：2015-2-2
     * @修改历史： [序号](llp 2015 - 2 - 2)<修改说明>
     */
    public Integer addSysMem(SysMember mem, String datasource) {
        try {
            /*****用于更改id生成方式 by guojr******/
            return this.daoTemplate2.addByObject(datasource + ".sys_mem", mem);
            //return daoTemplate2.getAutoIdForIntByMySql();
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @return
     * @说明：修改好友数
     * @创建者： 作者： llp  创建时间：2015-2-11
     */
    public Integer updateMemberByAttentions(String datasource, Integer memberId, Integer count) {
        try {
            Integer jude = 0;
            String sql1 = "update sys_member set member_attentions=? where member_id=? ";
            jude = this.daoTemplate1.update(sql1, count, memberId);
//            SysMemberUpdateProperties properties = new SysMemberUpdateProperties();
//            properties.setId(memberId);
//            properties.setPropertyType(MemberUpdatePropertyEnum.ATTENTIONS);
//            properties.setFriendCount(count);
//            HttpResponseUtils.convertResponse(memberRequest.updateProperties(properties));
            if (!StrUtil.isNull(datasource)) {
                String sql2 = "update " + datasource + ".sys_mem set member_attentions=? where member_id=? ";
                jude = this.daoTemplate1.update(sql2, count, memberId);
            }
            return jude;
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @return
     * @说明：修改黑名单数
     * @创建者： 作者： llp  创建时间：2015-2-11
     */
    public void updateMemberByBlacklist(String datasource, Integer memberId, Integer count) {
        try {
            String sql1 = "update sys_member set member_blacklist=? where member_id=? ";
            this.daoTemplate1.update(sql1, count, memberId);
//            SysMemberUpdateProperties properties = new SysMemberUpdateProperties();
//            properties.setId(memberId);
//            properties.setPropertyType(MemberUpdatePropertyEnum.BLACKLIST);
//            properties.setFriendCount(count);
//            HttpResponseUtils.convertResponse(memberRequest.updateProperties(properties));
            if (!StrUtil.isNull(datasource)) {
                String sql2 = "update " + datasource + ".sys_mem set member_blacklist=? where member_id=? ";
                this.daoTemplate1.update(sql2, count, memberId);
            }
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 获取会员信息(List)
     */
    public List<SysMemDTO> querypMems() {
        String sql = "select member_id,member_mobile from sys_member where is_admin is NULL or is_admin=''";
        try {
            return this.daoTemplate1.queryForLists(sql, SysMemDTO.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }

//        SysMemberSelectQuery query = new SysMemberSelectQuery();
//        query.setQueryType(MemberSelectQueryEnum.ADMIN_NULL);
//        List<SysMemberSelectDTO> selectDTOS = HttpResponseUtils.convertResponse(memberRequest.select(query));
//        List<SysMemDTO> resultList = Lists.newArrayList();
//        if (Collections3.isNotEmpty(selectDTOS)) {
//            for (SysMemberSelectDTO selectDTO : selectDTOS) {
//                resultList.add(mapper.map(selectDTO, SysMemDTO.class));
//            }
//        }
//
//        return resultList;
    }

//    /**
//     * 删除
//     */
    public int deletemember(final Integer[] ids) {
        try {
            String sql = "delete from sys_member where member_id=?";
//            BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter() {
//                @Override
//                public int getBatchSize() {
//                    return ids.length;
//                }
//
//                @Override
//                public void setValues(PreparedStatement pre, int num)
//                        throws SQLException {
//                    pre.setInt(1, ids[num]);
//                }
//            };
             this.daoTemplate1.update(sql);
             return 0;
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }
//
//    /**
//     * @param deptId
//     * @return
//     * @创建：作者:YYP 创建时间：2015-3-24
//     * 根据公司下的成员信息修改（unit_id,member_company）
//     */
    public Integer updateMemCompany(Integer deptId) {
        String sql = " update sys_member m set m.unit_id=NULL,m.member_company=NULL,m.is_unitmng=0,m.branch_id=NULL where m.unit_id=" + deptId;
        try {
            return daoTemplate1.update(sql);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 更新是否使用软件狗验证
     *
     * @param memId
     * @param isUse
     * @param database
     * @return
     */
    public Integer updateUseDog(Integer memId, Integer isUse, String idKey, String database) {
        String sql = " update " + database + ".sys_mem m set m.use_dog=" + isUse.toString() + ",m.id_key='" + idKey + "' where m.member_id=" + memId.toString();
        try {
            return daoTemplate1.update(sql);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public Integer deleteMemCompany(Integer deptId) {
        String sql = " delete from sys_member where unit_id=" + deptId;
        try {
            return daoTemplate1.update(sql);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }
//
//    /**
//     * @param companyId
//     * @return
//     * @创建：作者:YYP 创建时间：2015-5-25
//     * 查询公司管理员或创建者
//     */
//    public List<SysMemDTO> queryCompanyAdmins(Integer companyId) {
//        String sql = "select member_id,member_nm,member_mobile from sys_member where (is_unitmng=1 or is_unitmng=2) and unit_id=" + companyId;
//        try {
//            return daoTemplate1.queryForLists(sql, SysMemDTO.class);
//        } catch (Exception e) {
//            throw new DaoException(e);
//        }
//    }

    //根据号码
    public Map<String, Object> queryMemIdsByTels(String tStr, String datasource) {
        String sql = "select group_concat(cast(member_id as char(20))) as memids from " + datasource + ".sys_mem where member_mobile in (" + tStr + ") ";
        try {
            return daoTemplate2.queryForMap(sql);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @创建：作者:YYP 创建时间：2015-7-3
     */
    public void deleteAllMember(String datasource, Integer memId) {
        String sql = "delete from " + datasource + ".sys_mem where member_id=" + memId;
        daoTemplate2.update(sql);
    }

//    /**
//     * @说明：修改停用
//     * @创建：作者:llp 创建时间：2016-5-9
//     * @修改历史： [序号](llp 2016 - 5 - 9)<修改说明>
//     */
    public void updateIsTy(Integer id, Integer isTy, String datasource) {
        String sql1 = "update sys_member set member_use=? where member_id=?";
        String sql2 = "update " + datasource + ".sys_mem set member_use=? where member_id=?";
        try {
            this.daoTemplate1.update(sql1, isTy, id);
            this.daoTemplate2.update(sql2, isTy, id);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public void updateCompanyIsTy(Integer id, Integer isTy, String datasource) {
        String sql2 = "update " + datasource + ".sys_mem set member_use=? where member_id=?";
        try {
            this.daoTemplate2.update(sql2, isTy, id);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }


    /**
     * @说明：解绑设备
     * @创建：作者:llp 创建时间：2016-5-10
     * @修改历史： [序号](llp 2016 - 5 - 10)<修改说明>
     */
    public void updateUnId(Integer id, String datasource, Integer isTy) {
        String sql1 = "";
        String sql2 = "";
		if(isTy==3){
			sql1 = "update sys_member set un_id='1' where member_id=?";
			sql2 = "update "+datasource+".sys_mem set un_id='1' where member_id=?";
		}else{
			sql1 = "update sys_member set un_id='' where member_id=?";
			sql2 = "update "+datasource+".sys_mem set un_id='' where member_id=?";
		}
        //三个状态对应数据库un_id的值
        //永不绑定:null或''
        //绑定:'1'
        //解绑设备:类似'C5D7BFD3-8B8E-46E5-8340-87D0D9A574BC'
        //点击"绑定"->"永不绑定":'1'->''
        //点击"解绑设备"->"绑定":类似'C5D7BFD3-8B8E-46E5-8340-87D0D9A574BC'->'1'
        //点击"永不绑定"->"绑定":''->'1'
        if (isTy == 1) {
            //"绑定"->"永不绑定"
            sql1 = "update sys_member set un_id='' where member_id=?";
            sql2 = "update " + datasource + ".sys_mem set un_id='' where member_id=?";
        } else if (isTy == 2) {
            //"解绑设备"->"绑定"
            sql1 = "update sys_member set un_id='1' where member_id=?";
            sql2 = "update " + datasource + ".sys_mem set un_id='1' where member_id=?";
        } else if (isTy == 3) {
            //"永不绑定"->"绑定"
            sql1 = "update sys_member set un_id='1' where member_id=?";
            sql2 = "update " + datasource + ".sys_mem set un_id='1' where member_id=?";
        } else {
            sql1 = "update sys_member set un_id='' where member_id=?";
            sql2 = "update " + datasource + ".sys_mem set un_id='' where member_id=?";
        }
        try {
            this.daoTemplate1.update(sql1, id);
//            SysMemberUpdateProperties properties = new SysMemberUpdateProperties();
//            properties.setPropertyType(MemberUpdatePropertyEnum.UN_ID);
//            properties.setId(id);
//            if (isTy == 2 || isTy == 3) {
//                properties.setUnId("1");
//            } else {
//                properties.setUnId(null);
//            }
//            HttpResponseUtils.convertResponse(memberRequest.updateProperties(properties));
            this.daoTemplate2.update(sql2, id);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public void updateCompanyUnId(Integer id, String datasource, Integer isTy) {
        String sql2 = "";
        if (isTy == 3) {
            sql2 = "update " + datasource + ".sys_mem set un_id='1' where member_id=?";
        } else {
            sql2 = "update " + datasource + ".sys_mem set un_id='' where member_id=?";
        }
        try {
            this.daoTemplate2.update(sql2, id);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @说明：转让客户
     * @创建：作者:llp 创建时间：2016-5-11
     * @修改历史： [序号](llp 2016 - 5 - 11)<修改说明>
     */
    public void updateZrKh(Integer mid1, Integer mid2, String datasource) {
        String sql = "update " + datasource + ".sys_customer set mem_id=" + mid2 + " where mem_id=" + mid1 + "";
        try {
            this.daoTemplate2.update(sql);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：根据成员名称查信息
     *
     * @创建：作者:HSL 创建时间：2016-9-14
     * @修改历史： [序号](hsl 2016 - 9 - 14)<修改说明>
     */
    public SysMember querySysMemberByNm(String name, String datasource) {
        try {
            String sql = "select * from " + datasource + ".sys_mem where member_nm=? ";
            return this.daoTemplate2.queryForObj(sql, SysMember.class, name);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：根据手机号码获取成员信息(企业的员工)
     */
    public SysMember querySysMemberByTel(String tel, String datasource) {
        try {
            String sql = "select * from " + datasource + ".sys_mem where member_mobile=? ";
            return this.daoTemplate2.queryForObj(sql, SysMember.class, tel);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：根据部门id获取用户
     *
     * @创建：作者:llp 创建时间：2017-1-9
     * @修改历史： [序号](llp 2017 - 1 - 9)<修改说明>
     */
    public SysMember queryBmMemberIds(Integer branchId, String datasource) {
        String sql = "select group_concat(CAST(member_id AS CHAR)) as memberIds from " + datasource + ".sys_mem where branch_id=? ";
        try {
            return this.daoTemplate2.queryForObj(sql, SysMember.class, branchId);
        } catch (Exception e) {
            throw new DaoException(e);
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
            String sql = "select * from sys_member where unit_id is not null";
            return this.daoTemplate1.queryForLists(sql, SysMember.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
//        SysMemberListQuery query = new SysMemberListQuery();
//        query.setQueryType(MemberListQueryEnum.COMPANY);
//        List<SysMemberDTO> memberDTOS = HttpResponseUtils.convertResponse(memberRequest.list(query));
//        List<SysMember> members = Lists.newArrayList();
//        if (Collections3.isNotEmpty(memberDTOS)) {
//            for (SysMemberDTO memberDTO : memberDTOS) {
//                members.add(mapper.map(memberDTO, SysMember.class));
//            }
//        }
//
//        return members;
    }

    public List<SysMember> queryMemberAllByDatabase(String datasource, SysMember member) {
        try {
            StringBuffer sb = new StringBuffer();
            sb.append("select * from " + datasource + ".sys_mem a");
            sb.append(" where 1 = 1 ");
            if (member != null) {
                if (!StrUtil.isNull(member.getMemberUse())) {
                    sb.append(" and a.member_use in (" + member.getMemberUse() + ")");
                }
            }
            return this.daoTemplate2.queryForLists(sb.toString(), SysMember.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

//    /**
//     * 说明：修改用户新平台唯一标识id
//     *
//     * @创建：作者:llp 创建时间：2017-11-2
//     * @修改历史： [序号](llp 2017 - 11 - 2)<修改说明>
//     */
    public void updateMemberByNewwyid(Integer memberId, String platformUserId) {
        try {
            String sql2 = "update sys_member set platform_user_id=? where member_id=? ";
            this.daoTemplate1.update(sql2, platformUserId, memberId);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：获取企业员工列表
     *
     * @param member
     * @param datasource
     * @return
     */
    public List<SysMember> queryCompanyMemberList(SysMember member, String datasource) {
        try {
            String sql = "select * from " + datasource + ".sys_mem  where 1=1 ";
            if (member != null) {
                if (!StrUtil.isNull(member.getIsLead())) {
                    sql += " and is_Lead='" + member.getIsLead() + "'";
                }
                if (!StrUtil.isNull(member.getMemberUse())) {
                    sql += " and member_use='" + member.getMemberUse() + "'";
                }
                if (!StrUtil.isNull(member.getMemberNm())) {
                    sql += " and member_nm like '%" + member.getMemberNm() + "%'";
                }
            }
            return this.daoTemplate2.queryForLists(sql, SysMember.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 认证员工手机
     */
    public int rzMemberMobile(SysMember member, String database) {
        try {
            Map<String, Object> whereParam = new HashMap<String, Object>();
            whereParam.put("member_id", member.getMemberId());
            return this.daoTemplate2.updateByObject("" + database + ".sys_mem", member, whereParam, "member_id");
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 说明：根据认证手机号码获取成员信息(企业的员工)
     */
    public SysMember querySysMemberByRzMobile(String rzMobile, String datasource) {
        try {
            String sql = "select * from " + datasource + ".sys_mem where rz_mobile=? ";
            return this.daoTemplate2.queryForObj(sql, SysMember.class, rzMobile);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }


    /**
     * 说明：添加商城会员
     */
    @Deprecated
    public int addShopMember(Map<String, Object> shopMemberMap, String dataSource) {
        try {
            return this.daoTemplate2.addByMap(dataSource + ".shop_member", shopMemberMap);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：添加商城会员
     */
    @Deprecated
    public int updateShopMember(Map<String, Object> shopMemberMap, String dataSource) {
        try {
            Map<String, Object> whereParam = new HashMap<>();
            whereParam.put("id", shopMemberMap.get("id"));
            return this.daoTemplate2.updateByMap(dataSource + ".shop_member", shopMemberMap, whereParam);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }


    /**
     * 说明：修改成员（后台）
     */
    public Integer updateSysMemberByRzMobile(SysMember member, String dataSource) {
        try {
            Map<String, Object> whereParam = new HashMap<>();
            whereParam.put("member_id", member.getMemberId());
            return this.daoTemplate2.updateByObject("" + dataSource + ".sys_mem", member, whereParam, "member_id");
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }


    /**
     * 修改客户认证时，删除会员所属客户
     *
     * @param oldMobile
     * @param database
     */
    public int updateOldMemberCustomerId(String oldMobile, String database) {
        String sql = "update " + database + ".shop_member set customer_id=null,customer_name=null,source=1 where mobile=? ";
        return this.daoTemplate2.update(sql, oldMobile);
    }

    public Page dialogShopMemberPage(SysMember sysMember, int page, int rows, Integer branchId, Integer type, String database) {
        StringBuilder sql = new StringBuilder();
        sql.append("select * from " + database + ".sys_mem where 1=1 and member_use=1 ");
        try {
            if (null != sysMember) {
                if (StrUtil.isNull(sysMember.getMemberNm())) {
                    sql.append(" and member_nm like '%").append(sysMember.getMemberNm()).append("%'");
                }
                if (type != null && type == 1) {
                    sql.append(" and branch_id is null ");
                } else {
                    sql.append(" and branch_id= " + branchId);
                }
            }
            return this.daoTemplate1.queryForPageByMySql(sql.toString(), page, rows, SysMember.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }

    }

    public int batchUpdateMemberDepartment(String ids, Integer branchId, String database) {
        String sql;
        try {
            if (branchId != null) {
                sql = " update " + database + ".sys_mem set branch_id=" + branchId + "  where member_id in(" + ids + ")";

            } else {
                sql = " update " + database + ".sys_mem set branch_id=null" + " where member_id in(" + ids + ")";
            }
            return this.daoTemplate1.update(sql);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }


    public SysMember queryByOpenId(String openId)
    {
        String sql = "select * from publicplat.sys_member where open_id='" + openId + "'";
        List<SysMember> list = this.daoTemplate1.queryForLists(sql,SysMember.class);
        if(list.size() > 0)return list.get(0);
        return null;
    }

    public SysMember queryByOpenId_client(String openId,String database)
    {
        String sql = "select * from " + database + ".sys_mem where open_id='" + openId + "'";
        List<SysMember> list = this.daoTemplate1.queryForLists(sql,SysMember.class);
        if(list.size() > 0)return list.get(0);
        return null;
    }
}

