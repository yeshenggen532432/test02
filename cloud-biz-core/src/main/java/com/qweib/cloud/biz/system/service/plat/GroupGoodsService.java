package com.qweib.cloud.biz.system.service.plat;

import com.qweib.cloud.core.domain.GroupGoods;
import com.qweib.cloud.core.domain.GroupGoodsDetail;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.repository.plat.GroupGoodsDao;
import com.qweib.cloud.utils.Page;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service
public class GroupGoodsService {
	@Resource
	private GroupGoodsDao groupGoodsDao;
	
	
	/**
	 *˵������ҳ��ѯ��Ʒ
	 *@����������:llp		����ʱ�䣺2015-1-27
	 *@�޸���ʷ��
	 *		[���](llp	2015-1-27)<�޸�˵��>
	 */
	public Page queryGroupGoods(GroupGoods groupgoods,Integer page,Integer limit){
		try {
			return this.groupGoodsDao.queryGroupGoods(groupgoods, page, limit);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *˵���������Ʒ
	 *@����������:llp		����ʱ�䣺2015-1-27
	 *@�޸���ʷ��
	 *		[���](llp	2015-1-27)<�޸�˵��>
	 */
	public void addGroupGoods(GroupGoods groupgoods,List<GroupGoodsDetail> details){
		try {
			//�����Ʒ
		    this.groupGoodsDao.addGroupGoods(groupgoods);
		    int gpid = this.groupGoodsDao.queryAutoId();
		    int step = 1;
			for (GroupGoodsDetail detail : details) {
				detail.setGpid(gpid);
				detail.setStep(step);
				step++;
			}
			//���ͼƬ����
			this.groupGoodsDao.addGroupGoodsDetail(details);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *˵�����޸���Ʒ
	 *@����������:llp		����ʱ�䣺2015-1-27
	 *@�޸���ʷ��
	 *		[���](llp	2015-1-27)<�޸�˵��>
	 */
	public void updateGroupGoods(GroupGoods groupgoods,List<GroupGoodsDetail> details){
		try {
			this.groupGoodsDao.updateGroupGoods(groupgoods);
			this.groupGoodsDao.deleteGroupGoodsDetailById(groupgoods.getId());
			int step = 1;
			for (GroupGoodsDetail detail : details) {
				detail.setGpid(groupgoods.getId());
				detail.setStep(step);
				step++;
			}
			//���ͼƬ����
			this.groupGoodsDao.addGroupGoodsDetail(details);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *˵������ȡ��Ʒ
	 *@����������:llp		����ʱ�䣺2015-1-27
	 *@�޸���ʷ��
	 *		[���](llp	2015-1-27)<�޸�˵��>
	 */
	public GroupGoods queryGroupGoodsById(Integer Id){
		try {
			return this.groupGoodsDao.queryGroupGoodsById(Id);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *˵��������ɾ����Ʒ
	 *@����������:llp		����ʱ�䣺2015-1-27
	 *@�޸���ʷ��
	 *		[���](llp	2015-1-27)<�޸�˵��>
	 */
	public int[] deleteGroupGoods(Integer[] ids) {
		try {
			return this.groupGoodsDao.deleteGroupGoods(ids);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *˵����������Ʒid��ȡͼƬ����
	 *@����������:llp		����ʱ�䣺2015-2-15
	 *@�޸���ʷ��
	 *		[���](llp	2015-2-15)<�޸�˵��>
	 */
	public List<GroupGoodsDetail> queryGroupGoodsDetail(Integer gpid){
		try {
			return this.groupGoodsDao.queryGroupGoodsDetail(gpid);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	public int[] deleteGroupGoodsDetail(Integer[] ids) {
		try {
			return this.groupGoodsDao.deleteGroupGoodsDetail(ids);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
//	---------------------------�ֻ���վ�õ�--------------------------------------------
	/**
	 *˵������ҳ��ѯ��Ʒ(�ֻ���վ)
	 *@����������:llp		����ʱ�䣺2015-1-29
	 *@�޸���ʷ��
	 *		[���](llp	2015-1-29)<�޸�˵��>
	 */
	public Page queryGroupGoodssj(String tp,Integer page,Integer limit){
		try {
			return this.groupGoodsDao.queryGroupGoodssj(tp, page, limit);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
}
