package com.qweib.cloud.repository;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.SysYfile;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;

@Repository
public class SysYfileWebDao {
    @Resource(name = "daoTemplate")
    private JdbcDaoTemplate daoTemplate;

    /**
     * 说明：添加云文件
     *
     * @创建：作者:llp 创建时间：2016-11-04
     * @修改历史： [序号](llp 2016 - 11 - 04)<修改说明>
     */
    public int addYfile(SysYfile Yfile, String database) {
        try {
            return this.daoTemplate.addByObject("" + database + ".sys_yfile", Yfile);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：分页查询云文件
     *
     * @创建：作者:llp 创建时间：2016-11-04
     * @修改历史： [序号](llp 2016 - 11 - 04)<修改说明>
     */
    public Page queryYfileWeb(String database, Integer memId, Integer tp2, String fileNm, Integer pid, Integer page, Integer limit) {

        try {
            StringBuilder sql = new StringBuilder();
            sql.append("select * from " + database + ".sys_yfile where 1=1");
            if (!StrUtil.isNull(memId)) {
                sql.append(" and member_id=" + memId + "");
            }
            if (!StrUtil.isNull(tp2)) {
                sql.append(" and tp2=" + tp2 + "");
            }
            if (!StrUtil.isNull(fileNm)) {
                sql.append(" and file_nm like '%" + fileNm + "%'");
            }
            if (!StrUtil.isNull(pid)) {
                sql.append(" and pid=" + pid + "");
            } else {
                sql.append(" and pid=0");
            }
            sql.append(" order by id desc");
            return this.daoTemplate.queryForPageByMySql(sql.toString(), page, limit, SysYfile.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：修改云文件
     *
     * @创建：作者:llp 创建时间：2016-11-7
     * @修改历史： [序号](llp 2016 - 11 - 7)<修改说明>
     */
    public void updatefileNm(String database, String fileNm, Integer id) {
        String sql = "update " + database + ".sys_yfile set file_nm='" + fileNm + "' where id=" + id;
        try {
            this.daoTemplate.update(sql);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：判断文件名称是否存在
     *
     * @创建：作者:llp 创建时间：2016-11-7
     * @修改历史： [序号](llp 2016 - 11 - 7)<修改说明>
     */
    public int queryIsfileNm(String database, String fileNm, Integer memberId) {
        String sql = "select count(1) from " + database + ".sys_yfile where file_nm='" + fileNm + "' and member_id=" + memberId + "";
        try {
            return this.daoTemplate.queryForObject(sql, Integer.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：获取文件信息
     *
     * @创建：作者:llp 创建时间：2016-11-7
     * @修改历史： [序号](llp 2016 - 11 - 7)<修改说明>
     */
    public SysYfile queryYfileById(String database, Integer Id) {
        try {
            String sql = "select * from " + database + ".sys_yfile where id=? ";
            return this.daoTemplate.queryForObj(sql, SysYfile.class, Id);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：移动云文件
     *
     * @创建：作者:llp 创建时间：2016-11-7
     * @修改历史： [序号](llp 2016 - 11 - 7)<修改说明>
     */
    public void updatefilePid(String database, Integer id, Integer pid, Integer tp2) {
        String sql = "update " + database + ".sys_yfile set pid=" + pid + ",tp2=" + tp2 + " where id=" + id;
        try {
            this.daoTemplate.update(sql);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：删除云文件
     *
     * @创建：作者:llp 创建时间：2016-11-9
     * @修改历史： [序号](llp 2016 - 11 - 9)<修改说明>
     */
    public void deletefile(String database, Integer memberId, String fileNm) {
        String sql = "delete from " + database + ".sys_yfile  where member_id=" + memberId + " and file_nm='" + fileNm + "'";
        try {
            this.daoTemplate.update(sql);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：删除云文件2
     *
     * @创建：作者:llp 创建时间：2016-11-10
     * @修改历史： [序号](llp 2016 - 11 - 10)<修改说明>
     */
    public void deletefile2(String database, String fileNm) {
        String sql = "delete from " + database + ".sys_yfile  where tp2=2 and file_nm='" + fileNm + "'";
        try {
            this.daoTemplate.update(sql);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：获取文件信息2
     *
     * @创建：作者:llp 创建时间：2016-11-9
     * @修改历史： [序号](llp 2016 - 11 - 9)<修改说明>
     */
    public SysYfile queryYfile2(String database, Integer memberId, String fileNm) {
        try {
            String sql = "select * from " + database + ".sys_yfile where member_id=" + memberId + " and file_nm='" + fileNm + "'";
            return this.daoTemplate.queryForObj(sql, SysYfile.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：判断文件夹底下有没有文件
     *
     * @创建：作者:llp 创建时间：2016-11-9
     * @修改历史： [序号](llp 2016 - 11 - 9)<修改说明>
     */
    public int queryIsfilePid(String database, Integer id) {
        String sql = "select count(1) from " + database + ".sys_yfile where pid=" + id;
        try {
            return this.daoTemplate.queryForObject(sql, Integer.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：获取文件信息3
     *
     * @创建：作者:llp 创建时间：2016-11-10
     * @修改历史： [序号](llp 2016 - 11 - 10)<修改说明>
     */
    public SysYfile queryYfile3(String database, String fileNm) {
        try {
            String sql = "select * from " + database + ".sys_yfile where tp2=2 and file_nm='" + fileNm + "'";
            return this.daoTemplate.queryForObj(sql, SysYfile.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }
}
