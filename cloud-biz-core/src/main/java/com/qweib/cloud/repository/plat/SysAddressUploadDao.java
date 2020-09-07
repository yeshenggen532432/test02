package com.qweib.cloud.repository.plat;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.SysAddressUpload;
import com.qweib.cloud.core.exception.DaoException;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.Map;

@Repository
public class SysAddressUploadDao {
	@Resource(name="daoTemplate")
	private JdbcDaoTemplate daoTemplate;

//	public Page page(ShopMemberGrade model,int page,int rows,String database){
//		StringBuffer sql = new StringBuffer(" select a.* from "+database+".shop_member_grade a ");
//		sql.append(" where 1=1 ");
//    	if(model!=null){
//			if(!StrUtil.isNull(model.getGradeName())){
//				sql.append(" and a.grade_name like '%"+model.getGradeName()+"%'");
//			}
//	    }
//		try {
//			return this.daoTemplate.queryForPageByMySql(sql.toString(), page, rows, ShopMemberGrade.class);
//		} catch (Exception e) {
//			throw new DaoException(e);
//		}
//	}

//    public List<ShopMemberGrade> queryList(ShopMemberGrade model, String database){
//    	StringBuffer sql = new StringBuffer(" select a.* from "+database+".shop_member_grade a ");
//    	sql.append(" where 1=1 ");
////    	if(model!=null){
////    		if(!StrUtil.isNull(model.getStatus())){
////    			sql.append(" and a.status=").append(model.getStatus());
////    		}
////    	}
//    	return this.daoTemplate.queryForLists(sql.toString(), ShopMemberGrade.class);
//    }

	public int add(SysAddressUpload model, String database){
		try{
			return this.daoTemplate.addByObject(""+database+".sys_address_upload", model);
		} catch (Exception e) {
			e.printStackTrace();
			throw new DaoException(e);
		}
	}
	public int update(SysAddressUpload model, String database){
		try {
			Map<String, Object> whereParam = new HashMap<String, Object>();
			whereParam.put("mem_id", model.getMemId());
			return this.daoTemplate.updateByObject(""+database+".sys_address_upload", model, whereParam,null);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}

//	public int delete(Integer id,String database){
//		String sql = " delete from "+database+".shop_member_grade where id=? ";
//		try {
//			return this.daoTemplate.update(sql,id);
//		} catch (Exception e) {
//			throw new DaoException(e);
//		}
//	}
//
	public SysAddressUpload queryByMemId(Integer memId, String database){
		String sql = "select * from "+database+".sys_address_upload where mem_id=?";
		try{
			return this.daoTemplate.queryForObj(sql, SysAddressUpload.class, memId);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}


}
