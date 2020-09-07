package com.qweib.cloud.biz.system.service.ws;

import com.qweib.cloud.core.domain.SysCheckIn;
import com.qweib.cloud.core.domain.SysMember;
import com.qweib.cloud.core.domain.BscCheckRule;
import com.qweib.cloud.repository.BscCheckRuleWebDao;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.utils.Page;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service
public class BscCheckRuleWebService {
	@Resource
	private BscCheckRuleWebDao checkRuleWebDao;
	
	/**
	 *说明：分页查询考勤规则
	 *@创建：作者:llp		创建时间：2017-2-22
	 *@修改历史：
	 *		[序号](llp	2017-2-22)<修改说明>
	 */
	public Page queryCheckRuleWeb(String database,Integer memId,Integer page,Integer limit){
		try {
			return this.checkRuleWebDao.queryCheckRuleWeb(database, memId, page, limit);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：添加考勤规则
	 *@创建：作者:llp		创建时间：2017-2-22
	 *@修改历史：
	 *		[序号](llp	2017-2-22)<修改说明>
	 */
	public int addCheckRuleWeb(BscCheckRule checkRule,String database) {
		try {
			this.checkRuleWebDao.addCheckRuleWeb(checkRule, database);
			return this.checkRuleWebDao.getAutoId();
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：获取考勤规则
	 *@创建：作者:llp		创建时间：2017-2-22
	 *@修改历史：
	 *		[序号](llp	2017-2-22)<修改说明>
	 */
	public BscCheckRule queryCheckRuleWebOne(String database,Integer id){
		try {
			return this.checkRuleWebDao.queryCheckRuleWebOne(database, id);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：修改考勤规则人员权限
	 *@创建：作者:llp		创建时间：2017-2-22
	 *@修改历史：
	 *		[序号](llp	2017-2-22)<修改说明>
	 */
	public void updateCheckRuleWebRy(String database,Integer id,String syMids1,String syMids2,String glMids1,String glMids2) {
		try {
			this.checkRuleWebDao.updateCheckRuleWebRy(database, id, syMids1, syMids2, glMids1, glMids2);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：修改考勤规则详情
	 *@创建：作者:llp		创建时间：2017-2-22
	 *@修改历史：
	 *		[序号](llp	2017-2-22)<修改说明>
	 */
	public void updateCheckRuleWebXq(String database,Integer id,String kqgjNm,String checkWeeks,String checkTimes,String address,String longitude,String latitude,
			Integer yxMeter,Integer zzsbTime,Integer zwxbTime,Integer sxbtxTime,Integer isQd) {
		try {
			this.checkRuleWebDao.updateCheckRuleWebXq(database, id, kqgjNm, checkWeeks, checkTimes, address, longitude, latitude, yxMeter, zzsbTime, zwxbTime, sxbtxTime, isQd);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：删除考勤规则
	 *@创建：作者:llp		创建时间：2017-2-22
	 *@修改历史：
	 *		[序号](llp	2017-2-22)<修改说明>
	 */
	public void deleteCheckRuleWeb(String database,Integer id) {
		try {
			this.checkRuleWebDao.deleteCheckRuleWeb(database, id);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：根据用户id组查询用户
	 *@创建：作者:llp		创建时间：2017-2-22
	 *@修改历史：
	 *		[序号](llp	2017-2-22)<修改说明>
	 */
	public List<SysMember> queryMemberByMids(String database,String mids){
		try {
			return this.checkRuleWebDao.queryMemberByMids(database, mids);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：根据用户id获取他的考勤规则
	 *@创建：作者:llp		创建时间：2017-2-22
	 *@修改历史：
	 *		[序号](llp	2017-2-22)<修改说明>
	 */
	public BscCheckRule queryCheckRuleWebBysyMid(String database,Integer syMid){
		try {
			return this.checkRuleWebDao.queryCheckRuleWebBysyMid(database, syMid);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：根据用户id获取他的考勤规则
	 *@创建：作者:llp		创建时间：2017-3-2
	 *@修改历史：
	 *		[序号](llp	2017-3-2)<修改说明>
	 */
	public BscCheckRule queryCheckRuleWebByMid(String database,Integer Mid){
		try {
			return this.checkRuleWebDao.queryCheckRuleWebByMid(database, Mid);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：获取迟到/早退用户人数
	 *@创建：作者:llp		创建时间：2017-3-3
	 *@修改历史：
	 *		[序号](llp	2017-3-3)<修改说明>
	 */
	public List<SysCheckIn> queryCheckInCDrs(String database,String mids,String sdate,String edate,String tp){
		try {
			return this.checkRuleWebDao.queryCheckInCDrs(database, mids, sdate, edate, tp);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：根据用户id和日期判断在是否请假
	 *@创建：作者:llp		创建时间：2017-3-3
	 *@修改历史：
	 *		[序号](llp	2017-3-3)<修改说明>
	 */
	public int queryIsAuditqJ(String database,Integer mid,String dates){
		try {
			return this.checkRuleWebDao.queryIsAuditqJ(database, mid, dates);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：根据用户id和日期判断在是否有未打卡
	 *@创建：作者:llp		创建时间：2017-3-3
	 *@修改历史：
	 *		[序号](llp	2017-3-3)<修改说明>
	 */
	public int queryIsCheckinDk(String database,Integer mid,String dates){
		try {
			return this.checkRuleWebDao.queryIsCheckinDk(database, mid, dates);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：根据用户id和日期获取迟到/早退
	 *@创建：作者:llp		创建时间：2017-3-3
	 *@修改历史：
	 *		[序号](llp	2017-3-3)<修改说明>
	 */
	public int queryIsCheckinCdZt(String database,Integer mid,String dates,String tp){
		try {
			return this.checkRuleWebDao.queryIsCheckinCdZt(database, mid, dates, tp);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：根据用户id和日期段获取请假次数
	 *@创建：作者:llp		创建时间：2017-3-3
	 *@修改历史：
	 *		[序号](llp	2017-3-3)<修改说明>
	 */
	public int queryAuditQjCount(String database,Integer mid,String sdate,String edate){
		try {
			return this.checkRuleWebDao.queryAuditQjCount(database, mid, sdate, edate);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
}
