package com.qweib.cloud.repository.plat;

import com.qweib.cloud.core.dao.JdbcDaoTemplatePlud;
import com.qweib.cloud.core.domain.SysLoginInfo;
import com.qweib.cloud.core.domain.SysNotice;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.repository.utils.HttpResponseUtils;
import com.qweib.cloud.service.member.domain.member.SysMemberDTO;
import com.qweib.cloud.service.member.retrofit.SysMemberRequest;
import com.qweib.cloud.utils.Collections3;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.jdbc.core.BatchPreparedStatementSetter;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
public class SysPublicNoticeDao {

    @Resource(name = "pdaoTemplate")
    private JdbcDaoTemplatePlud pdaoTemplate;
//    @Qualifier("memberRequest")
//    @Autowired
//    private SysMemberRequest memberRequest;

    /**
     * 公告分页查询
     */
    public Page page(SysNotice notice, Integer pageNo, Integer pageSize, SysLoginInfo info) {
        StringBuffer sql = new StringBuffer("SELECT n.notice_id,n.member_id,n.notice_tp,n.notice_time,n.is_push,");
//		sql.append("(select member_nm from sys_member m where m.member_id=n.member_id)as memberNm,");
        sql.append("(case when LENGTH(n.notice_title)>10 then concat(substring(n.notice_title,1,10),'...')else n.notice_title end) as noticeTitle,");
        sql.append("(case when length(n.notice_content)>10 then concat(substring(n.notice_content,1,10),'...')else n.notice_content end)as noticeContent");
        if ("".equals(info.getDatasource()) || null == info.getDatasource()) {//公共平台上
            sql.append(" from sys_notice n where notice_tp='1' or notice_tp='4'");
        } else {
            sql.append(" from sys_notice n where notice_tp='2' and datasource='" + info.getDatasource() + "' ");
        }
        if (null != notice) {
            if (!StrUtil.isNull(notice.getMemberId())) {
                sql.append(" and n.member_id ='").append(notice.getMemberId()).append("'");
            }
            if (!StrUtil.isNull(notice.getNoticeTitle())) {
                sql.append(" and n.notice_title like '%").append(notice.getNoticeTitle()).append("%'");
            }
            if (!StrUtil.isNull(notice.getStartTime())) {
                sql.append(" and n.notice_time >=").append("'" + notice.getStartTime() + " 00:00:00" + "'");
            }
            if (!StrUtil.isNull(notice.getEndTime())) {
                sql.append(" and n.notice_time <= '").append(notice.getEndTime() + " 23:59:59").append("'");
            }
            sql.append(" order by n.notice_id desc");
        }
        try {
            Page page = this.pdaoTemplate.queryForPageByMySql(sql.toString(), pageNo, pageSize, SysNotice.class);
//            List<SysNotice> rows = page.getRows();
//            if (Collections3.isNotEmpty(rows)) {
//                for (SysNotice row : rows) {
//                    if (row.getMemberId() != null) {
//                        SysMemberDTO memberDTO = HttpResponseUtils.convertResponseNull(memberRequest.get(row.getMemberId()));
//                        if (memberDTO != null) {
//                            row.setMemberNm(memberDTO.getName());
//                        }
//                    }
//                }
//            }

            return page;
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 删除
     */
    public int[] deletenotice(final Integer[] ids) {
        try {
            String sql = "delete from sys_notice where notice_id=?";
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
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 添加
     */
    public int addNotice(SysNotice notice) {
        try {
            /*****用于更改id生成方式 by guojr******/
            return this.pdaoTemplate.addByObject("sys_notice", notice);
            //return pdaoTemplate.getAutoIdForIntByMySql();
        } catch (Exception ex) {
            throw new DaoException(ex);
        }
    }

    /**
     * 修改
     */
    public int updateNotice(SysNotice notice) {
        try {
            Map<String, Object> whereParam = new HashMap<String, Object>();
            whereParam.put("notice_id", notice.getNoticeId());
            return this.pdaoTemplate.updateByObject("sys_notice", notice, whereParam, "notice_id");
        } catch (Exception ex) {
            throw new DaoException(ex);
        }
    }

    /**
     * 通过ID获取公告信息
     */
    public SysNotice queryNoticeById(Integer id) {
        String sql = " select * from sys_notice where notice_id=?";
        try {
            return pdaoTemplate.queryForObj(sql.toString(), SysNotice.class, id);
        } catch (Exception ex) {
            throw new DaoException(ex);
        }
    }

    /**
     * 推送
     */
    public int updatePush(Integer id) {
        try {
            String sql = " update sys_notice set is_push='1' where notice_id=?";
            return this.pdaoTemplate.update(sql.toString(), id);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }
}
