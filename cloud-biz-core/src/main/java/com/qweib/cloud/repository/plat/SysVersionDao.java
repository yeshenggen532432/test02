package com.qweib.cloud.repository.plat;

import com.qweib.cloud.core.dao.JdbcDaoTemplatePlud;
import com.qweib.cloud.core.domain.SysVersion;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.service.basedata.common.AppPublishEnum;
import com.qweib.cloud.service.basedata.common.AppVersionTypeEnum;
import com.qweib.cloud.service.basedata.domain.platform.AppVersionDetailDTO;
import com.qweib.cloud.service.basedata.domain.platform.AppVersionQuery;
import com.qweib.cloud.service.basedata.retrofit.platform.AppVersionRequest;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import com.qweibframework.commons.Collections3;
import com.qweibframework.commons.http.ResponseUtils;
import org.dozer.Mapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
public class SysVersionDao {
    	@Resource(name="pdaoTemplate")
	private JdbcDaoTemplatePlud daoTemplate;
//    @Autowired
//    private AppVersionRequest appVersionRequest;
    @Autowired
    private Mapper mapper;

//	/**
//	  *摘要：保存客户端版本号
//	  *@说明：
//	  *@创建：作者:YYP		创建时间：2014-7-14
//	  *@param @param version
//	  *@修改历史：
//	  *		[序号](YYP	2014-7-14)<修改说明>
//	 */
	public void saveVersion(SysVersion version) {
		try{
			this.daoTemplate.addByObject("sys_version",version);
		}catch (Exception e) {
			e.printStackTrace();
			throw new DaoException(e);
		}
	}

    /**
     * @return
     * @说明：查询最新的版本更新
     */
    public SysVersion getLastVersion(String appType) {
        return new SysVersion();
//        AppVersionQuery query = new AppVersionQuery();
//        query.setStatus(AppPublishEnum.PUBLISHED);
//        query.setType(AppVersionTypeEnum.getByType(appType));
//        List<AppVersionDetailDTO> list = ResponseUtils.convertResponse(appVersionRequest.list(query));
//
//        return Collections3.isNotEmpty(list) ? mapper.map(list.get(0), SysVersion.class) : null;
//		try {
//			StringBuffer str = new StringBuffer("select * from sys_version where version_type = ? order by version_time desc ");
//			return this.daoTemplate.queryForLists(str.toString(), SysVersion.class,verSion);
//		} catch (Exception e) {
//			throw new DaoException(e);
//		}
    }

//	/**
//	  *摘要：查询版本
//	  *@说明：
//	  *@创建：作者:YYP		创建时间：2014-7-14
//	  *@param @param version
//	  *@param @param page
//	  *@param @param rows
//	  *@param @return
//	  *@修改历史：
//	  *		[序号](YYP	2014-7-14)<修改说明>
//	 */
	public Page queryVersion(SysVersion version, Integer page, Integer rows) {
		StringBuffer sql = new StringBuffer(" select *,(select member_nm from sys_member where member_id=version_user )as memberNm from sys_version where 1=1 ");
		String versionName = version.getVersionName();
		if(!StrUtil.isNull(versionName)){
			sql.append(" and version_name like'%").append(versionName).append("%' ");
		}
		sql.append(" order by id desc");
		try{
			return this.daoTemplate.queryForPageByMySql(sql.toString(), page, rows, SysVersion.class);
		}catch (Exception e) {
			e.printStackTrace();
			throw new DaoException(e);
		}
	}
//
//	/**
//	  *摘要：删除客户端版本
//	  *@说明：
//	  *@创建：作者:YYP		创建时间：2014-7-14
//	  *@param @param id
//	  *@修改历史：
//	  *		[序号](YYP	2014-7-14)<修改说明>
//	 */
	public int deleteVersionById(Integer id) {
		StringBuffer sql = new StringBuffer(" delete from sys_version where 1=1 and id=? ");
		try{
			return this.daoTemplate.update(sql.toString(),id);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}

//	/**
//	  *摘要：根据id查询版本信息
//	  *@说明：
//	  *@创建：作者:YYP		创建时间：2014-7-18
//	  *@param @param id
//	  *@param @return
//	  *@修改历史：
//	  *		[序号](YYP	2014-7-18)<修改说明>
//	 */
	public SysVersion queryVersionById(Integer id) {
		StringBuffer sql = new StringBuffer(" select * from sys_version where 1=1 and id=? ");
		try{
			return this.daoTemplate.queryForObj(sql.toString(), SysVersion.class, id);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}
//
//	/**
//	  *摘要：修改版本信息
//	  *@说明：
//	  *@创建：作者:YYP		创建时间：2014-7-18
//	  *@param @param version
//	  *@param @return
//	  *@修改历史：
//	  *		[序号](YYP	2014-7-18)<修改说明>
//	 */
	public Object updateVersion(SysVersion version) {
		try{
			Map<String,Object> params = new HashMap<String, Object>();
			params.put("id", version.getId());
			return this.daoTemplate.updateByObject("sys_version", version, params, "id");
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}

}
