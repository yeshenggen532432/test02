package com.qweib.cloud.biz.system.service.plat;

import com.qweib.cloud.core.domain.SysLoginInfo;
import com.qweib.cloud.core.domain.SysNotice;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.repository.plat.SysPublicNoticeDao;
import com.qweib.cloud.utils.Page;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

@Service
public class SysPublicNoticeService {

    @Resource
    private SysPublicNoticeDao sysPublicNoticeDao;

    /**
     * 公告分页查询
     */
    public Page page(SysNotice notice, Integer pageNo, Integer pageSize, SysLoginInfo info) {
        try {
            return sysPublicNoticeDao.page(notice, pageNo, pageSize, info);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 删除
     */
    public int[] deletenotice(Integer[] ids) {
        try {
            return this.sysPublicNoticeDao.deletenotice(ids);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 添加
     */
    public int addNotice(SysNotice notice) {
        try {
            int id = this.sysPublicNoticeDao.addNotice(notice);
            return id;
        } catch (Exception ex) {
            throw new ServiceException(ex);
        }
    }

    /**
     * 修改
     */
    public int updateNotice(SysNotice notice) {
        try {
            int i = this.sysPublicNoticeDao.updateNotice(notice);
            if (i != 1) {
                throw new ServiceException("修改出错");
            }
            return i;
        } catch (Exception ex) {
            throw new ServiceException(ex);
        }

    }

    /**
     * 通过ID获取公告信息
     */
    public SysNotice queryNoticeById(Integer id) {
        try {
            return this.sysPublicNoticeDao.queryNoticeById(id);
        } catch (Exception ex) {
            throw new ServiceException(ex);
        }

    }

    /**
     * 推送
     */
    public int updatePush(final Integer id) {
        try {
            int i = this.sysPublicNoticeDao.updatePush(id);
            if (i != 1) {
                throw new ServiceException("修改出错");
            }
            return i;
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }
}
