package com.qweib.cloud.repository.plat.ws;

import com.qweib.cloud.core.dao.JdbcDaoTemplatePlud;
import com.qweib.cloud.core.domain.BscInvitation;
import com.qweib.cloud.core.exception.DaoException;
import org.springframework.jdbc.core.BatchPreparedStatementSetter;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.List;

@Repository
public class BscInvitationDao {
	@Resource(name="pdaoTemplate")
	private JdbcDaoTemplatePlud pdaoTemplate;



	/**
	  *@see 批量添加邀请信息记录
	  *@param ivMsgs
	  *@创建：作者:YYP		创建时间：2015-4-2
	 */
	public int[] addInvitationMsgs( final List<BscInvitation> ivMsgs) {
		String sql = "insert into bsc_invitation(member_id,receive_id,tp,content,datasource,belong_id,intime) values(?,?,?,?,?,?,?)";
		try{
			BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter() {

				public void setValues(PreparedStatement params, int num) throws SQLException {
					params.setInt(1,ivMsgs.get(num).getMemberId());
					params.setInt(2,ivMsgs.get(num).getReceiveId());
					params.setString(3,ivMsgs.get(num).getTp());
					params.setString(4,ivMsgs.get(num).getContent());
					if(null==ivMsgs.get(num).getDatasource()){
						params.setString(5,null);
					}else{
						params.setString(5,ivMsgs.get(num).getDatasource());
					}
					if(null==ivMsgs.get(num).getBelongId()){
						params.setString(6,null);
					}else{
						params.setInt(6,ivMsgs.get(num).getBelongId());
					}
					params.setString(7,ivMsgs.get(num).getIntime());
				}

				public int getBatchSize() {
					return ivMsgs.size();
				}
			};
			return pdaoTemplate.batchUpdate(sql.toUpperCase(), setter);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}



	/**
	  *@see 修改同意或不同意操作
	  *@param receiveId
	  *@param memId
	  *@param belongId
	  *@param tp
	  *@param idTp
	  *@创建：作者:YYP		创建时间：2015-4-3
	 */
	public Integer updateInAgree(Integer receiveId, Integer memId,
			Integer belongId, String tp, String idTp) {
		StringBuffer sql = new StringBuffer("update bsc_invitation set agree="+tp);
		sql.append(" where receive_id="+receiveId+" and member_id="+memId);
		if(null!=belongId){
			sql.append(" and belong_id="+belongId);
		}
		if("1".equals(idTp)){
			sql.append(" and tp=3 ");
		}else if("2".equals(idTp)){
			sql.append(" and tp=4 ");
		}else{
			sql.append(" and tp="+idTp);
		}
		try{
			return pdaoTemplate.update(sql.toString());
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}

}
