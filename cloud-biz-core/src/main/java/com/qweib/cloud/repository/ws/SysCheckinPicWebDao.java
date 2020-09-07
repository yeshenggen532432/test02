package com.qweib.cloud.repository.ws;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.SysCheckinPic;
import com.qweib.cloud.core.exception.DaoException;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;

@Repository
public class SysCheckinPicWebDao {
    @Resource(name = "daoTemplate")
    private JdbcDaoTemplate daoTemplate;

    /**
     * 添加签到图片
     */
    public Integer addPic(SysCheckinPic sysCheckinPic, String database) {
        try {
            return this.daoTemplate.addByObject(database + ".sys_checkin_pic", sysCheckinPic);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }
}
