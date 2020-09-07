package com.qweib.cloud.repository;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.SysWareImportSub;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Repository
public class SysWareImportSubDao {
	@Resource(name="daoTemplate")
	private JdbcDaoTemplate daoTemplate;


	public Page queryPage(SysWareImportSub sub, int page, int rows, String database){
		StringBuffer sql = new StringBuffer(" select a.*,b.waretype_nm,c.name as brand_nm from "+database+".sys_ware_import_sub a  ");
		sql.append(" left join " + database + ".sys_waretype b on a.waretype=b.waretype_id ");
		sql.append(" left join "+database+".sys_brand c on a.brand_id=c.id ");
		sql.append("  where 1=1 ");
		if(sub!=null){
			if(!StrUtil.isNull(sub.getMastId())){
				sql.append(" and a.mast_id=").append(sub.getMastId());
			}
		}
		if (!StrUtil.isNull(sub.getWareNm())) {
			//sql.append(" and a.ware_nm like '%").append(ware.getWareNm()).append("%'");
			if (isContainChinese(sub.getWareNm())) {
				sub.setWareNm(sub.getWareNm().replaceAll(" ", ""));
				for (int i = 0; i < sub.getWareNm().length(); i++) {
					sql.append(" and a.ware_nm like '%" + sub.getWareNm().substring(i, i + 1) + "%'");
				}
			} else {
				sql.append(" and (a.ware_nm like '%" + sub.getWareNm() + "%' or a.ware_code like '%" + sub.getWareNm() + "%' or a.be_bar_code like '%" + sub.getWareNm() + "%' or a.pack_bar_code like '%" + sub.getWareNm() + "%' or a.py like '%" + sub.getWareNm() + "%')");
			}
		}
		if (null != sub.getWaretype() && sub.getWaretype() != 0) {
			sql.append(" and instr(b.waretype_path,'-").append(sub.getWaretype()).append("-')>0");
		}
		if(!StrUtil.isNull(sub.getBeBarCode())){
			sql.append(" and a.be_bar_code like concat('%', ").append(sub.getBeBarCode()).append(" ,'%')");
		}
		if(!StrUtil.isNull(sub.getPackBarCode())){
			sql.append(" and a.pack_bar_code like concat('%', ").append(sub.getPackBarCode()).append(" ,'%')");
		}
		try {
			return this.daoTemplate.queryForPageByMySql(sql.toString(), page, rows, SysWareImportSub.class);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}

    public List<SysWareImportSub> queryList(SysWareImportSub sub, String database){
    	StringBuffer sql = new StringBuffer(" select a.* from "+database+".sys_ware_import_sub a ");
    	sql.append(" where 1=1 ");
    	if(sub!=null){
    	}
    	return this.daoTemplate.queryForLists(sql.toString(), SysWareImportSub.class);
    }


	public int add(SysWareImportSub sub, String database){
		try{
			return this.daoTemplate.addByObject(""+database+".sys_ware_import_sub", sub);
		} catch (Exception e) {
			e.printStackTrace();
			throw new DaoException(e);
		}
	}

	public SysWareImportSub queryById(Integer id, String database){
		String sql = "select * from "+database+".sys_ware_import_sub where id=?";
		try{
			return this.daoTemplate.queryForObj(sql, SysWareImportSub.class, id);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}


	public int update(SysWareImportSub sub, String database){
		try {
			Map<String, Object> whereParam = new HashMap<String, Object>();
			whereParam.put("id", sub.getId());
			return this.daoTemplate.updateByObject(""+database+".sys_ware_import_sub", sub, whereParam,null);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}

	public boolean isContainChinese(String str) {
		Pattern p = Pattern.compile("[\u4e00-\u9fa5]");
		Matcher m = p.matcher(str);
		if (m.find()) {
			return true;
		}
		return false;
	}

}
