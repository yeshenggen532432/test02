package com.qweib.cloud.repository;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.SysWaretypePic;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.List;

@Repository
public class SysWaretypePicDao {
    @Resource(name = "daoTemplate")
    private JdbcDaoTemplate daoTemplate;

    public int addWarePic(SysWaretypePic warePic, String database) {
        return this.daoTemplate.addByObject("" + database + ".sys_waretype_pic", warePic);
    }

    public List<SysWaretypePic> queryList(SysWaretypePic model, String database) {
        StringBuffer sql = new StringBuffer(" select a.* from " + database + ".sys_waretype_pic a ");
        sql.append(" where 1=1 ");
        if (model != null) {
            if (!StrUtil.isNull(model.getWaretypeId())) {
                sql.append(" and a.waretype_id=").append(model.getWaretypeId());
            }
        }
        return this.daoTemplate.queryForLists(sql.toString(), SysWaretypePic.class);
    }

    public List<SysWaretypePic> queryList(String ids, String database) {
        StringBuffer sql = new StringBuffer(" select a.* from " + database + ".sys_waretype_pic a ");
        sql.append(" where a.waretype_id in (").append(ids).append(") order by id");
        return this.daoTemplate.queryForLists(sql.toString(), SysWaretypePic.class);
    }

    /**
     * 说明： 删除照片
     */
    public void deletePicByIds(String database, String delPicIds) {
        String sql = "delete from " + database + ".sys_waretype_pic where id in (" + delPicIds + ")";
        try {
            this.daoTemplate.update(sql);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 使用分类ID删除图片
     *
     * @param database
     * @param waretypeId
     */
    public int deleteByWareTypeId(Integer waretypeId, String database) {
        String sql = "delete from " + database + ".sys_waretype_pic where waretype_id=" + waretypeId;
        return this.daoTemplate.update(sql);
    }

}
