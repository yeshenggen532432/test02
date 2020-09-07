package com.qweib.cloud.biz.system.service.ws;

import com.qweib.cloud.biz.system.service.plat.SysDeptmempowerService;
import com.qweib.cloud.core.domain.OnlineUser;
import com.qweib.cloud.core.domain.SysReport;
import com.qweib.cloud.core.domain.SysReportFile;
import com.qweib.cloud.core.domain.SysReportPl;
import com.qweib.cloud.core.domain.SysReportYh;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.repository.SysReportWebDao;
import com.qweib.cloud.utils.Page;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

@Service
public class SysReportWebService {
	@Resource
	private SysReportWebDao reportWebDao;
	@Resource
	private SysDeptmempowerService deptmempowerService;
	
	/**
	 *说明：分页查询报(表)--已写
	 *@创建：作者:llp		创建时间：2016-12-16
	 *@修改历史：
	 *		[序号](llp	2016-12-16)<修改说明>
	 */
	public Page queryReportWebPage1(SysReport report,OnlineUser user, String dataTp,Integer page,Integer limit,String mids){
		try {
			Integer memberId = user.getMemId();
			String datasource = user.getDatabase();
			Map<String, Object> map = deptmempowerService.getPowerDept(dataTp, memberId, datasource);
			return this.reportWebDao.queryReportWebPage1(report, datasource, map, page, limit,mids);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：分页查询报(表)--未写
	 *@创建：作者:llp		创建时间：2016-12-16
	 *@修改历史：
	 *		[序号](llp	2016-12-16)<修改说明>
	 */
	public Page queryReportWebPage11(SysReport report,OnlineUser user, String dataTp,Integer page,Integer limit,String mids){
		try {
			Integer memberId = user.getMemId();
			String datasource = user.getDatabase();
			Map<String, Object> map = deptmempowerService.getPowerDept(dataTp, memberId, datasource);
			return this.reportWebDao.queryReportWebPage11(report, datasource, map, page, limit,mids);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：分页查询报(我发出的)
	 *@创建：作者:llp		创建时间：2016-12-16
	 *@修改历史：
	 *		[序号](llp	2016-12-16)<修改说明>
	 */
	public Page queryReportWebPage2(SysReport report,String database,Integer page,Integer limit){
		try {
			return this.reportWebDao.queryReportWebPage2(report, database, page, limit);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：分页查询报(我收到的)
	 *@创建：作者:llp		创建时间：2016-12-16
	 *@修改历史：
	 *		[序号](llp	2016-12-16)<修改说明>
	 */
	public Page queryReportWebPage3(SysReport report,String database,Integer page,Integer limit){
		try {
			return this.reportWebDao.queryReportWebPage3(report, database, page, limit);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：添加报
	 *@创建：作者:llp		创建时间：2016-12-16
	 *@修改历史：
	 *		[序号](llp	2016-12-16)<修改说明>
	 */
	public int addReport(SysReport report,List<SysReportYh> list1,List<SysReportFile> list2,List<SysReportFile> list3,String database) {
		try {
			this.reportWebDao.addReport(report, database);
			int id=this.reportWebDao.queryAutoId();
			for(SysReportYh reportYh:list1){
				reportYh.setBid(id);
				this.reportWebDao.addReportYh(reportYh, database);
			}
			for(SysReportFile reportFile:list2){
				reportFile.setBid(id);
				reportFile.setTp(1);
				this.reportWebDao.addReportFile(reportFile, database);
			}
			for(SysReportFile reportFile:list3){
				reportFile.setBid(id);
				reportFile.setTp(2);
				this.reportWebDao.addReportFile(reportFile, database);
			}
			return id;
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：根据报的id查询信息
	 *@创建：作者:llp		创建时间：2016-12-19
	 *@修改历史：
	 *		[序号](llp	2016-12-19)<修改说明>
	 */
	public SysReport queryReportById(Integer Id,String database){
		try {
			return this.reportWebDao.queryReportById(Id, database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：根据报id获取报用户关系信息
	 *@创建：作者:llp		创建时间：2016-12-16
	 *@修改历史：
	 *		[序号](llp	2016-12-16)<修改说明>
	 */
	public List<SysReportYh> queryReportYh(Integer bid,String database){
		try {
			return this.reportWebDao.queryReportYh(bid, database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：根据报id,tp获取报文件信息
	 *@创建：作者:llp		创建时间：2016-12-16
	 *@修改历史：
	 *		[序号](llp	2016-12-16)<修改说明>
	 */
	public List<SysReportFile> queryReportFile(Integer bid,Integer tp,String database){
		try {
			return this.reportWebDao.queryReportFile(bid, tp, database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：添加报评论
	 *@创建：作者:llp		创建时间：2016-12-30
	 *@修改历史：
	 *		[序号](llp	2016-12-30)<修改说明>
	 */
	public int addReportPl(SysReportPl reportPl,String database) {
		try {
			return this.reportWebDao.addReportPl(reportPl, database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：分页查询报评论
	 *@创建：作者:llp		创建时间：2016-12-30
	 *@修改历史：
	 *		[序号](llp	2016-12-30)<修改说明>
	 */
	public Page queryReportPlWebPage(Integer bid,String database,Integer page,Integer limit){
		try {
			return this.reportWebDao.queryReportPlWebPage(bid, database, page, limit);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
}
