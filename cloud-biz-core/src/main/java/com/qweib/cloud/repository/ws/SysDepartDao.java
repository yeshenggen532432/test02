package com.qweib.cloud.repository.ws;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.dao.JdbcDaoTemplatePlud;
import com.qweib.cloud.core.domain.SysDepart;
import com.qweib.cloud.core.domain.SysMemDTO;
import com.qweib.cloud.core.domain.SysMember;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.repository.utils.MemberUtils;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
public class SysDepartDao {
    @Resource(name = "daoTemplate")
    private JdbcDaoTemplate daoTemplate;
    @Resource(name = "pdaoTemplate")
    private JdbcDaoTemplatePlud pdaoTemplate;

    /**
     * 摘要：
     *
     * @说明：查询第一个分类
     * @创建：作者:llp 创建时间：2015-2-9
     * @修改历史： [序号](llp 2015 - 2 - 9)<修改说明>
     */
    public Integer queryOneDepart(String datasource) {
        StringBuilder sql = new StringBuilder(" select branch_id from " + datasource + ".sys_depart where parent_id=0 ");

        try {
            List<Map<String, Object>> maps = this.daoTemplate.queryForList(sql.toString());
            if (null != maps && maps.size() > 0) {
                return StrUtil.convertInt(maps.get(0).get("branch_id"));
            }
            return null;
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 摘要：
     *
     * @说明：根据id查询下级分类
     * @创建：作者:llp 创建时间：2015-2-9
     * @修改历史： [序号](llp 2015 - 2 - 9)<修改说明>
     */
    public List<SysDepart> queryDepart(SysDepart depart, String datasource) {
        StringBuilder sql = new StringBuilder(" select * from " + datasource + ".sys_depart ");
        sql.append(" where parent_id=? ");
        try {
            return this.daoTemplate.queryForLists(sql.toString(), SysDepart.class, depart.getBranchId());
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @return
     * @说明：添加部门
     * @创建者： 作者：llp  创建时间：2015-1-30
     */
    public int addDepart(SysDepart depart, String datasource) {
        try {
            return this.daoTemplate.addByObject("" + datasource + ".sys_depart", depart);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 摘要：
     *
     * @return
     * @说明：根据id获取分类
     * @创建：作者:llp 创建时间：2015-2-9
     * @修改历史： [序号](llp 2015 - 2 - 9)<修改说明>
     */
    public SysDepart queryDepartById(Integer branchId, String datasource) {
        try {
            return this.daoTemplate.queryForObj(" select a.*,b.branch_name as branchPName from " + datasource + ".sys_depart a left join " + datasource + ".sys_depart b on a.parent_id=b.branch_id where a.branch_id=" + branchId + " ", SysDepart.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
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
        try {
            Map<String, Object> whereParam = new HashMap<String, Object>();
            whereParam.put("branch_id", depart.getBranchId());
            return this.daoTemplate.updateByObject("" + datasource + ".sys_depart", depart, whereParam, "branch_id");
        } catch (Exception e) {
            throw new DaoException(e);
        }
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
        try {
            return this.daoTemplate.update(" update " + datasource + ".sys_depart set branch_leaf=? where branch_id=? ", leaf, id);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 摘要：
     *
     * @return
     * @说明：修改分类Path
     * @创建：作者:llp 创建时间：2015-3-11
     * @修改历史： [序号](llp 2015 - 3 - 11)<修改说明>
     */
    public int updateDepartPath(Integer id, String path, String datasource) {
        try {
            return this.daoTemplate.update(" update " + datasource + ".sys_depart set branch_path=? where branch_id=? ", path, id);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 摘要：
     *
     * @说明：删除分类
     * @创建：作者:llp 创建时间：2015-2-9
     * @修改历史： [序号](llp 2015 - 2 - 9)<修改说明>
     */
    public void deleteDepart(Integer ids, String datasource) {
        String sql = " delete from " + datasource + ".sys_depart where branch_id=? ";
        try {
            this.daoTemplate.deletes(sql, ids);
        } catch (Exception e) {
            throw new DaoException(e);
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
        String sql = "select count(1) from " + datasource + ".sys_depart where parent_id=? ";
        try {
            return this.daoTemplate.queryForObject(sql, new Object[]{pid}, Integer.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 摘要：
     *
     * @return
     * @说明：获取自增id
     * @创建：作者:llp 创建时间：2015-2-9
     * @修改历史： [序号](llp 2015 - 2 - 9)<修改说明>
     */
    public int queryAutoId() {
        try {
            return this.daoTemplate.getAutoIdForIntByMySql();
        } catch (Exception e) {
            throw new DaoException(e);
        }
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
        String sql = "select count(1) from " + datasource + ".sys_depart where branch_name=? ";
        try {
            return this.daoTemplate.queryForObject(sql, new Object[]{branchName}, Integer.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @return
     * @说明：获取部门上一级id，名称
     * @创建者： 作者：llp  创建时间：2015-2-7
     */
    public List<SysDepart> queryDepartLssj(String datasource) {
        String sql = "select d.parent_id,(select branch_name from " + datasource + ".sys_depart dp where dp.branch_id=d.parent_id ) as branchPName from " + datasource + ".sys_depart d where d.parent_id!=0 group by d.parent_id ";
        try {
            return this.daoTemplate.queryForLists(sql.toString(), SysDepart.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @return
     * @说明：父部门列表
     * @创建者： 作者：llp  创建时间：2015-2-2
     */
    public List<SysDepart> queryDepartLs(String datasource) {
        String sql = "select * from " + datasource + ".sys_depart where parent_id=0 ";
        try {
            return this.daoTemplate.queryForLists(sql.toString(), SysDepart.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @return
     * @说明：父部门id获取子部门列表
     * @创建者： 作者：llp  创建时间：2015-2-7
     */
    public List<SysDepart> queryDepartLsz(String datasource, Integer parentid) {
        String sql = "select * from " + datasource + ".sys_depart where parent_id=" + parentid + " ";
        try {
            return this.daoTemplate.queryForLists(sql.toString(), SysDepart.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @return
     * @说明：判断部门底下有没有子部门
     * @创建者： 作者：llp  创建时间：2015-2-7
     */
    public int queryDepartByCount(String datasource, Integer parentid) {
        String sql = " select count(1) from " + datasource + ".sys_depart where parent_id=" + parentid + " ";
        try {
            return this.daoTemplate.queryForObject(sql, Integer.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @return
     * @说明：根据部门id查底下的人员
     * @创建者： 作者：llp  创建时间：2015-2-2
     */
    public List<SysMemDTO> querySysMemLsByBid(Integer branchId, String datasource, Integer memberId, String tp, String qTp) {
        //String sql="select * from "+datasource+".sys_mem where  branch_id="+branchId+" ";
        StringBuffer sql = new StringBuffer();
        sql.append("select m.member_id,m.member_nm,m.member_head,m.first_char,m.member_mobile,m.is_unitmng as role,(select count(1) from " + datasource + ".sys_oftenuser o where o.member_id=" + memberId + " and o.bind_member_id=m.member_id )cy from " + datasource + ".sys_mem m");
        sql.append(" where 1=1 and m.member_use='1' ");
        if ("1".equals(qTp)) {//根据成员查询
            sql.append(" AND m.member_id=" + memberId + " ");
        } else {
            sql.append(" AND m.branch_id=" + branchId + " ");
        }
        if (StrUtil.isNull(tp)) {
            sql.append(" and m.is_lead!=1");
        }
        sql.append(MemberUtils.defMemberType("m"));//增加默认会员类型
        try {
            return this.daoTemplate.queryForLists(sql.toString(), SysMemDTO.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @return
     * @说明：企业底下还没分配部门的人员
     * @创建者： 作者：llp  创建时间：2015-2-2
     */
    public List<SysMemDTO> querySysMemLs(String datasource, Integer memberId, String tp) {
        //String sql="select * from "+datasource+".sys_mem where branch_id is NULL ";
        StringBuffer sql = new StringBuffer();
        sql.append("select m.member_id,m.member_nm,m.member_head,m.first_char,m.member_mobile,m.is_unitmng as role,(select count(1) from " + datasource + ".sys_oftenuser o where o.member_id=" + memberId + " and o.bind_member_id=m.member_id )cy from " + datasource + ".sys_mem m");
        sql.append(" where m.branch_id is null and m.member_use='1' ");
        if (StrUtil.isNull(tp)) {
            sql.append(" and m.is_lead!=1");
        }
        sql.append(MemberUtils.defMemberType("m"));//增加默认会员类型
        try {
            return this.daoTemplate.queryForLists(sql.toString(), SysMemDTO.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：根据部门名称查信息
     *
     * @创建：作者:llp 创建时间：2015-2-6
     * @修改历史： [序号](llp 2015 - 2 - 6)<修改说明>
     */
    public SysDepart querySysDepartByNm(String name, String datasource) {
        try {
            String sql = "select * from " + datasource + ".sys_depart where branch_name=? ";
            return this.daoTemplate.queryForObj(sql, SysDepart.class, name);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @return
     * @说明：获取所有部门
     * @创建者： 作者：llp  创建时间：2015-2-16
     */
    public List<SysDepart> queryDepartLsall(String datasource) {
        String sql = "select * from " + datasource + ".sys_depart ";
        try {
            return this.daoTemplate.queryForLists(sql.toString(), SysDepart.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public SysDepart queryDepartByid(Integer deptId, String database) {
        String sql = "select branch_id,branch_name,branch_path from " + database + ".sys_depart where branch_id=" + deptId;
        try {
            return this.daoTemplate.queryForObj(sql, SysDepart.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 验证成员是否在部门下
     */
    public Integer queryIsIndept(Integer memId, String branchPath,
                                 String database) {
        StringBuffer sql = new StringBuffer("select count(1) from ").append(database).append(".sys_mem m left join ").append(database)
                .append(".sys_depart d on m.branch_id=d.branch_id where m.member_id=")
                .append(memId).append(" and d.branch_path like '").append(branchPath).append("%'");
        sql.append(MemberUtils.defMemberType("m"));//增加默认会员类型
        try {
            return daoTemplate.queryForObject(sql.toString(), Integer.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 根据部门id修改部门名称
     */
    public void updateBranchNameByBid(String database, String branchName, Integer branchId) {
        String sql = "update " + database + ".sys_depart d SET d.branch_name=? where d.branch_id=?";
        try {
            this.daoTemplate.update(sql.toString(), branchName, branchId);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @param branchName
     * @param parentid
     * @param database
     * @创建：作者:YYP 创建时间：2015-4-10
     * 判断创建的部门是否已经存在该节点下
     */
    public Integer queryIsExistDeptNm(String branchName, Integer parentid,
                                      String database) {
        String sql = "select count(1) from " + database + ".sys_depart where parent_id=" + parentid + " and branch_name='" + branchName + "' ";
        try {
            return this.daoTemplate.queryForObject(sql, Integer.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    //修改部门名称
    public void updateDeptNm(Integer deptId, String deptNm, String database) {
        String sql = "update " + database + ".sys_depart set branch_name='" + deptNm + "' where branch_id=" + deptId;
        try {
            daoTemplate.update(sql);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 查询部门列表
     */
    public List<SysDepart> queryDeptList(Integer deptId, String datasource) {
        StringBuffer sql = new StringBuffer("select d.branch_id,d.branch_name,d.parent_id,(case when (select count(1) from " + datasource + ".sys_depart sd where sd.parent_id=d.branch_id)>0 then 1 else 2 end) as ischild from " + datasource + ".sys_depart d where 1=1");
        if (null != deptId) {//查询子部门
            sql.append(" and parent_id=" + deptId);
        } else {
            sql.append(" and parent_id=0");
        }
        try {
            return daoTemplate.queryForLists(sql.toString(), SysDepart.class);
        } catch (Exception e) {
            throw new DaoException(e);
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
        StringBuilder sql = new StringBuilder(" select c.branch_id,c.branch_name from " + datasource + ".sys_zcusr a left join " + datasource + ".sys_mem b on a.cusr_id=b.member_id left join " + datasource + ".sys_depart c on b.branch_id=c.branch_id where a.zusr_id=" + zusrId + MemberUtils.defMemberType("b") + " group by b.branch_id order by b.branch_id desc");
        try {
            return this.daoTemplate.queryForLists(sql.toString(), SysDepart.class);
        } catch (Exception e) {
            throw new DaoException(e);
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
        StringBuilder sql = new StringBuilder(" select b.member_id,b.member_nm from " + datasource + ".sys_zcusr a left join " + datasource + ".sys_mem b on a.cusr_id=b.member_id where b.branch_id=" + branchId + " and a.zusr_id=" + zusrId + MemberUtils.defMemberType("b") + " order by b.member_id desc");
        try {
            return this.daoTemplate.queryForLists(sql.toString(), SysMemDTO.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    //获取部门所有人数
    public int queryMemBmCount(String database, Integer branchId) {
        String sql = " select count(1) from " + database + ".sys_mem b where branch_id in(select branch_id from " + database + ".sys_depart where branch_path like '%-" + branchId + "-%') and member_use='1'" + MemberUtils.defMemberType("b");
        try {
            return this.daoTemplate.queryForObject(sql, Integer.class);
        } catch (DaoException e) {
            throw new DaoException(e);
        }
    }

    //获取部门对应的人数
    public int queryMemBmCountzdy(String database, Integer branchId, String mids) {
        String sql = " select count(1) from " + database + ".sys_mem b where member_id in(" + mids + ") and member_use='1' and branch_id=" + branchId + MemberUtils.defMemberType("b");
        try {
            return this.daoTemplate.queryForObject(sql, Integer.class);
        } catch (DaoException e) {
            throw new DaoException(e);
        }
    }

    /**
     * what a shame?
     * 查询部门下的全部子部门（包括当前部门）
     * 截取第一个 '当前用户部门' （倒数）之后的所有字符，并且拼接上当前部门，如-7-9-11-拼接后7-9-11-
     *
     * @param memberId
     * @return
     */
    public Map<String, Object> queryBottomDepts(Integer memberId, String datasource) {
        StringBuffer sql = new StringBuffer("");
        sql.append(" select CONCAT(m.branch_id,SUBSTRING_INDEX(d.branch_path,m.branch_id,-1))  as depts ");
        sql.append(" from " + datasource + ".sys_mem m ," + datasource + ".sys_depart d ");
        sql.append(" where m.branch_id=d.branch_id and m.member_id=?");
        sql.append(MemberUtils.defMemberType("m"));
        try {
            return this.daoTemplate.queryForMap(sql.toString(), memberId);
        } catch (DaoException e) {
            throw new DaoException(e);
        }
    }

    /**
     * 查询所有的部门id（Map）
     *
     * @return
     */
    public Map<String, Object> queryAllDeptsForMap(String datasource) {
        String sql = "SELECT GROUP_CONCAT(CAST(branch_id AS CHAR)) AS depts FROM " + datasource + ".sys_depart  ";
        return daoTemplate.queryForMap(sql);
    }

    /**
     * 查询所有在职员工ids
     */
    public List<SysMember> queryUserMemBerIds(String datasource, String departIds) {
        StringBuffer sb = new StringBuffer();
        sb.append("select member_id from " + datasource + ".sys_mem As m," + datasource + ".sys_depart AS d " +
                "where member_use = 1 and (is_del is null or is_del = 0) and m.branch_id = d.branch_id");
        if (StrUtil.isNotNull(departIds)) {
            sb.append(" and d.branch_id in (" + departIds + ")");
        }
        sb.append(MemberUtils.defMemberType("m"));
        return daoTemplate.queryForLists(sb.toString(), SysMember.class);
    }

    //根据条件（可见\不可见）查询部门
    public List<SysDepart> queryDepartsForRole(String datasource,
                                               String allDepts, String invisibleDepts) {
        StringBuilder sql = new StringBuilder("  SELECT d.branch_id,d.branch_name FROM " + datasource + ".sys_depart d WHERE 1=1 ");
        try {
            if (!StrUtil.isNull(allDepts)) {
                sql.append(" AND d.branch_id IN (" + allDepts + ") ");
            }
            if (!StrUtil.isNull(invisibleDepts)) {
                sql.append(" AND d.branch_id NOT IN (" + invisibleDepts + ") ");
            }
            sql.append(" ORDER BY d.branch_path ASC ");
            return this.daoTemplate.queryForLists(sql.toString(), SysDepart.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    //自定义-部门
    public List<SysDepart> queryDepartsForzdy(String datasource, String mids) {
        StringBuilder sql = new StringBuilder(" select b.branch_id,b.branch_name from " + datasource + ".sys_mem a left join " + datasource + ".sys_depart b on a.branch_id=b.branch_id where a.member_id in(" + mids + ") and a.member_Use='1' group by a.branch_id order by a.branch_id desc ");
        try {
            return this.daoTemplate.queryForLists(sql.toString(), SysDepart.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public List<SysMemDTO> queryMemByzdy(String datasource, Integer branchId, String mids) {
        StringBuilder sql = new StringBuilder(" select member_id,member_nm,member_head,first_char,member_mobile,is_unitmng as role from " + datasource + ".sys_mem where member_id in(" + mids + ") and member_Use='1'  and branch_id=" + branchId + " order by member_id desc");
        try {
            return this.daoTemplate.queryForLists(sql.toString(), SysMemDTO.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 查询部门下的全部成员
     *
     * @param datasource
     * @param branchId
     * @return
     */
    public List<SysMemDTO> queryMemByDepartForRole(String datasource,
                                                   Integer branchId) {
        StringBuilder sql = new StringBuilder(" ");
        sql.append(" SELECT member_id,member_nm FROM " + datasource + ".sys_mem m WHERE 1=1 and member_Use='1' AND branch_id=? ");
        sql.append(MemberUtils.defMemberType("m"));
        try {
            return this.daoTemplate.queryForLists(sql.toString(), SysMemDTO.class, branchId);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 查询成员的父级部门id
     *
     * @param memberId
     * @param memberId2
     * @return
     */
    public List<SysDepart> queryDeptsForRole(Integer memberId, String datasource) {
        StringBuilder sql = new StringBuilder(" SELECT dp.* FROM " + datasource + ".sys_depart dp WHERE dp.branch_id in ( ");
        sql.append(" SELECT substring(SUBSTRING_INDEX(d.branch_path,'-',2),2) as branch_id  ");
        sql.append(" FROM " + datasource + ".sys_depart d ");
        sql.append(" LEFT JOIN " + datasource + ".sys_mem m ON d.branch_id=m.branch_id  ");
        sql.append(" WHERE 1=1 AND m.member_id=?) ");
        sql.append(MemberUtils.defMemberType("m"));
        try {
            return this.daoTemplate.queryForLists(sql.toString(), SysDepart.class, memberId);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 根据成员id查询成员所属部门的路径（-替换成，）
     *
     * @param datasource
     * @param memberId
     * @return
     */
    public Map<String, Object> queryDepartPathByMemId(String datasource,
                                                      Integer memberId) {
        StringBuilder sql = new StringBuilder();
        sql.append(" SELECT REPLACE(d.branch_path,'-',',') AS dpath");
        sql.append(" FROM ").append(datasource).append(".sys_depart d,").append(datasource).append(".sys_mem m WHERE d.branch_id=m.branch_id AND m.member_id=?");
        sql.append(MemberUtils.defMemberType("m"));
        try {
            return this.daoTemplate.queryForMap(sql.toString(), memberId);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    //查所有部门
    public List<SysDepart> queryDepartsForAllz(String datasource) {
        StringBuilder sql = new StringBuilder(" select branch_id,branch_name from " + datasource + ".sys_depart order by branch_id desc ");
        try {
            return this.daoTemplate.queryForLists(sql.toString(), SysDepart.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }


}
