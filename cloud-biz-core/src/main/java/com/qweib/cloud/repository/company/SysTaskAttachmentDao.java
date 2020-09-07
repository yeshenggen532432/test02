package com.qweib.cloud.repository.company;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.SysTaskAttachment;
import com.qweib.cloud.core.exception.DaoException;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.List;

/**
 * 说明：任务表附件Dao
 *
 * @创建：作者:zrp 创建时间：2015-1-26
 * @修改历史： [序号](zrp 2015 - 1 - 26)<修改说明>
 */
@Repository
public class SysTaskAttachmentDao {
    @Resource(name = "daoTemplate")
    private JdbcDaoTemplate daoTemplate;

    /**
     * 添加任务附件
     *
     * @param task
     * @param database
     * @return
     */
    public int addTaskAttachment(SysTaskAttachment task, String database) {
        try {
            return daoTemplate.addByObject(database + ".sys_task_attachment", task);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 根据ID查询附件信息
     *
     * @param task
     * @return
     */
    public SysTaskAttachment queryById(Integer id, String database) {
        try {
            String sql = "select * from " + database + ".sys_task_attachment where id = ?";
            return daoTemplate.queryForObj(sql, SysTaskAttachment.class, id);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 根据任务ID查询所有附件信息
     *
     * @param i
     * @return
     */
    public List<SysTaskAttachment> queryForList(String id, String database) {
        try {
            String sql = "select * from " + database + ".sys_task_attachment where nid=?";
            return daoTemplate.queryForLists(sql, SysTaskAttachment.class, id);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @param id
     * @param database
     * @return
     * @创建：作者:YYP 创建时间：Aug 27, 2015
     * @see 根据知识点id查询附件信息
     */
    public List<SysTaskAttachment> queryByKnowledgeId(Integer id, String database) {
        try {
            String sql = "select * from " + database + ".sys_task_attachment where ref_id=?";
            return daoTemplate.queryForLists(sql, SysTaskAttachment.class, id);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 删除附件信息
     *
     * @param i
     * @return
     */
    public void deleteByid(Integer id, String database) {
        try {
            String sql = "delete from " + database + ".sys_task_attachment where id=?";
            daoTemplate.update(sql, id);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 根据进度ID获取附件
     *
     * @param i
     * @return
     */
    public List<SysTaskAttachment> queryFeedBackList(Integer id, String database) {
        try {
            String sql = "select id,attach_name,attacth_path,pid,add_time,fsize from " + database + ".sys_task_attachment where pid = ?";
            return this.daoTemplate.queryForLists(sql, SysTaskAttachment.class, id);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 根据任务ID获取附件
     *
     * @param database
     * @param ids
     * @return
     */
    public List<SysTaskAttachment> queryForListByNid(String database,
                                                     List<Integer> ids) {
        try {
            String str = "";
            for (Integer id : ids) {
                str += id + ",";
            }
            String sql = "select * from " + database + ".sys_task_attachment where nid in (" + str.substring(0, str.length() - 1) + ")";
            return this.daoTemplate.queryForLists(sql, SysTaskAttachment.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 根据任务ID获取附件
     *
     * @param database
     * @param ids
     * @return
     */
    public List<SysTaskAttachment> queryForlistByPid(String database,
                                                     List<Integer> ids) {
        try {
            String str = "";
            for (Integer id : ids) {
                str += id + ",";
            }
            String sql = "select * from " + database + ".sys_task_attachment where pid in (" + str.substring(0, str.length() - 1) + ")";
            return this.daoTemplate.queryForLists(sql, SysTaskAttachment.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @param attTempId
     * @param database
     * @return
     * @创建：作者:YYP 创建时间：2015-7-15
     * @see 根据tempid查询附件信息
     */
    public List<SysTaskAttachment> queryAttByTempid(String attTempId,
                                                    String database) {
        String sql = "select * from " + database + ".sys_task_attachment where tempid = ?";
        try {
            return this.daoTemplate.queryForLists(sql, SysTaskAttachment.class, attTempId);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @param attachmentId
     * @param database
     * @return
     * @创建：作者:YYP 创建时间：2015-7-15
     * @see 根据多个attid删除附件
     */
    public Integer deleteByids(String attachmentId, String database) {
        String sql = "delete from " + database + ".sys_task_attachment where id in(" + attachmentId + ") ";
        try {
            return this.daoTemplate.update(sql);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    //根据多个id查询信息
    public List<SysTaskAttachment> queryAttByids(String attachmentId,
                                                 String database) {
        String sql = "select * from " + database + ".sys_task_attachment where id in(" + attachmentId + ") ";
        try {
            return this.daoTemplate.queryForLists(sql, SysTaskAttachment.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    //更新附件对应的任务id
    public void updateAtt(String attTempId, Integer tid, String database) {
        String sql = "update " + database + ".sys_task_attachment set nid=" + tid + " where tempid='" + attTempId + "'";
        try {
            this.daoTemplate.update(sql);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    //更新附件对应的反馈id
    public void updateAttForFeedId(String attTempId, Integer fid,
                                   String database) {
        String sql = "update " + database + ".sys_task_attachment set pid=" + fid + " where tempid='" + attTempId + "'";
        try {
            this.daoTemplate.update(sql);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    //更新附件对应的知识点id
    public void updateAttForRefId(String attTempId, Integer id,
                                  String datasource) {
        String sql = "update " + datasource + ".sys_task_attachment set ref_id=" + id + " where tempid='" + attTempId + "'";
        try {
            this.daoTemplate.update(sql);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    //根据任务nid查询附件信息
    public List<SysTaskAttachment> queryAttBynid(Integer nid, String database) {
        String sql = "select * from " + database + ".sys_task_attachment where nid=" + nid;
        try {
            return this.daoTemplate.queryForLists(sql, SysTaskAttachment.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }
}
