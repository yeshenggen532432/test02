package com.qweib.cloud.repository.plat;


import com.qweib.cloud.core.dao.JdbcDaoTemplatePlud;
import com.qweib.cloud.core.domain.GroupGoods;
import com.qweib.cloud.core.domain.GroupGoodsDetail;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.jdbc.core.BatchPreparedStatementSetter;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
public class GroupGoodsDao {

	@Resource(name="pdaoTemplate")
	private JdbcDaoTemplatePlud pdaoTemplate;

	/**
	 *˵������ҳ��ѯ��Ʒ
	 *@����������:llp		����ʱ�䣺2015-1-27
	 *@�޸���ʷ��
	 *		[���](llp	2015-1-27)<�޸�˵��>
	 */
	public Page queryGroupGoods(GroupGoods groupgoods, Integer page, Integer limit){
		StringBuilder sql = new StringBuilder();
		sql.append(" select * from group_goods where 1=1 ");
		if(null!=groupgoods){
			if(!StrUtil.isNull(groupgoods.getGname())){
				sql.append(" and gname like '%"+groupgoods.getGname()+"%' ");
			}
		}
		sql.append(" order by id desc ");
		try {
			return this.pdaoTemplate.queryForPageByMySql(sql.toString(), page, limit, GroupGoods.class);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 *˵���������Ʒ
	 *@����������:llp		����ʱ�䣺2015-1-27
	 *@�޸���ʷ��
	 *		[���](llp	2015-1-27)<�޸�˵��>
	 */
	public int addGroupGoods(GroupGoods groupgoods){
		try{
			return this.pdaoTemplate.addByObject("group_goods", groupgoods);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 *˵�����޸���Ʒ
	 *@����������:llp		����ʱ�䣺2015-1-27
	 *@�޸���ʷ��
	 *		[���](llp	2015-1-27)<�޸�˵��>
	 */
	public int updateGroupGoods(GroupGoods groupgoods){
		try{
			Map<String,Object> whereParam = new HashMap<String, Object>();
			whereParam.put("id", groupgoods.getId());
			return this.pdaoTemplate.updateByObject("group_goods", groupgoods, whereParam, "id");
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 *˵������ȡ��Ʒ
	 *@����������:llp		����ʱ�䣺2015-1-27
	 *@�޸���ʷ��
	 *		[���](llp	2015-1-27)<�޸�˵��>
	 */
	public GroupGoods queryGroupGoodsById(Integer Id){
		try{
			String sql = "select * from group_goods where id=? ";
			return this.pdaoTemplate.queryForObj(sql, GroupGoods.class,Id);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 *˵��������ɾ����Ʒ
	 *@����������:llp		����ʱ�䣺2015-1-27
	 *@�޸���ʷ��
	 *		[���](llp	2015-1-27)<�޸�˵��>
	 */
	public int[] deleteGroupGoods(final Integer[] ids) {
		try{
			String sql = "delete from group_goods where id=?";
			BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter() {
				public int getBatchSize() {
					return ids.length;
				}
                public void setValues(PreparedStatement pre, int num)
						throws SQLException {
					pre.setInt(1, ids[num]);
				}
			};
			return this.pdaoTemplate.batchUpdate(sql, setter);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 *˵������Ʒ����id
	 *@����������:llp		����ʱ�䣺2015-1-27
	 *@�޸���ʷ��
	 *		[���](llp	2015-1-27)<�޸�˵��>
	 */
	public int queryAutoId(){
		try {
			return this.pdaoTemplate.getAutoIdForIntByMySql();
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
    //---------------------------ͼƬ����--------------------------------------------
	/**
	 *˵����������Ʒid��ȡͼƬ����
	 *@����������:llp		����ʱ�䣺2015-2-15
	 *@�޸���ʷ��
	 *		[���](llp	2015-2-15)<�޸�˵��>
	 */
	public List<GroupGoodsDetail> queryGroupGoodsDetail(Integer gpid){
		String sql = "select * from group_goods_detail where gpid=? order by step ";
		try {
			return this.pdaoTemplate.queryForLists(sql, GroupGoodsDetail.class, gpid);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 *˵�������ͼƬ����
	 *@����������:llp		����ʱ�䣺2015-2-15
	 *@�޸���ʷ��
	 *		[���](llp	2015-2-15)<�޸�˵��>
	 */
	public void addGroupGoodsDetail(final List<GroupGoodsDetail> gpDetails){
		String sql = " insert into group_goods_detail(gpid,step,pic) values(?,?,?) ";
		try {
			BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter(){
				public int getBatchSize() {
					return gpDetails.size();
				}
				public void setValues(PreparedStatement arg0, int arg1) throws SQLException {
					arg0.setInt(1, gpDetails.get(arg1).getGpid());
					arg0.setInt(2, gpDetails.get(arg1).getStep());
					arg0.setString(3, gpDetails.get(arg1).getPic());
				}
			};
			this.pdaoTemplate.batchUpdate(sql, setter);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 *˵����ɾ��ͼƬ����
	 *@����������:llp		����ʱ�䣺2015-2-15
	 *@�޸���ʷ��
	 *		[���](llp	2015-2-15)<�޸�˵��>
	 */
	public void deleteGroupGoodsDetailById(Integer gpid){
		String sql = " delete from group_goods_detail where gpid=? ";
		try {
			this.pdaoTemplate.update(sql,gpid);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	public int[] deleteGroupGoodsDetail(final Integer[] ids) {
		try{
			String sql = "delete from group_goods_detail where gpid=?";
			BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter() {
				public int getBatchSize() {
					return ids.length;
				}
                public void setValues(PreparedStatement pre, int num)
						throws SQLException {
					pre.setInt(1, ids[num]);
				}
			};
			return this.pdaoTemplate.batchUpdate(sql, setter);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}
	//---------------------------�ֻ���վ�õ�--------------------------------------------
	/**
	 *˵������ҳ��ѯ��Ʒ(�ֻ���վ)
	 *@����������:llp		����ʱ�䣺2015-1-29
	 *@�޸���ʷ��
	 *		[���](llp	2015-1-29)<�޸�˵��>
	 */
	public Page queryGroupGoodssj(String tp, Integer page, Integer limit){
		StringBuilder sql = new StringBuilder();
		sql.append(" select * from group_goods where 1=1 ");
		if(tp.equals("1")){
			sql.append(" order by id desc ");
		}else{
			sql.append(" and isrx=1 order by salesvolume desc ");
		}
		try {
			return this.pdaoTemplate.queryForPageByMySql(sql.toString(), page, limit, GroupGoods.class);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
}
