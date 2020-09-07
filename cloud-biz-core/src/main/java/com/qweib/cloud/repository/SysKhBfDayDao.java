package com.qweib.cloud.repository;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.SysKhBfDay;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.DateTimeUtil;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.Date;

@Repository
public class SysKhBfDayDao {
	@Resource(name="daoTemplate")
	private JdbcDaoTemplate daoTemplate;
	/**
	 *说明：分页查询客户天数
	 *@创建：作者:llp		创建时间：2016-6-27
	 *@修改历史：
	 *		[序号](llp	2016-6-27)<修改说明>
	 */
	public Page queryKhBfDay(SysKhBfDay khBfDay, Integer mId, String allDepts, String invisibleDepts, Integer page, Integer limit){
		try {
			String times= DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd");
			StringBuilder sql = new StringBuilder();
			sql.append("select b.kh_nm,b.mobile,b.address,(select member_nm from "+khBfDay.getDatabase()+".sys_mem where member_id=b.mem_id) as memberNm,max(a.qddate) as scbfDate,datediff('"+times+"',max(a.qddate)) as dayNum from "+khBfDay.getDatabase()+".sys_bfqdpz a left join "+khBfDay.getDatabase()+".sys_customer b on a.cid=b.id ");
			sql.append(" LEFT JOIN "+khBfDay.getDatabase()+".sys_mem m ON a.mid=m.member_id ");
			sql.append(" where b.is_db=2 ");
			if (!StrUtil.isNull(allDepts)) {//要查询的部门和可见部门
				if (!StrUtil.isNull(mId)) {//个人和可见部门结合查询
					sql.append(" AND (m.branch_id IN ("+allDepts+") ");
					sql.append(" OR a.mid="+mId+")");
				} else {
					sql.append(" AND m.branch_id IN ("+allDepts+") ");
				}
			}else if (!StrUtil.isNull(mId)) {//个人
				sql.append(" AND a.mid="+mId);
			}
			if (!StrUtil.isNull(invisibleDepts)) {//不可见部门
				sql.append(" AND m.branch_id NOT IN ("+invisibleDepts+") ");
			}
			if(null!=khBfDay){
				if(!StrUtil.isNull(khBfDay.getDayNum())){
					if(khBfDay.getDayNum()!=0){
					  sql.append(" and datediff('"+times+"',a.qddate)="+khBfDay.getDayNum()+"");
					}
				}
				if(!StrUtil.isNull(khBfDay.getMemberNm())){
				     sql.append(" and (select member_nm from "+khBfDay.getDatabase()+".sys_mem where member_id=b.mem_id) like '%"+khBfDay.getMemberNm()+"%'");
				}
				if(!StrUtil.isNull(khBfDay.getMemberIds())){
					sql.append(" and a.mem_id in("+khBfDay.getMemberIds()+") ");
				}
			}
			sql.append(" group by a.cid order by dayNum desc,b.mem_id desc");
			return this.daoTemplate.queryForPageByMySql(sql.toString(), page, limit, SysKhBfDay.class);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
}
