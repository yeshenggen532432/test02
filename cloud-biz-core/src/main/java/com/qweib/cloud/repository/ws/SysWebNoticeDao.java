package com.qweib.cloud.repository.ws;


import com.qweib.cloud.core.dao.JdbcDaoTemplatePlud;
import com.qweib.cloud.core.domain.SysNotice;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.repository.utils.HttpResponseUtils;
import com.qweib.cloud.service.member.domain.member.SysMemberDTO;
import com.qweib.cloud.service.member.retrofit.SysMemberRequest;
import com.qweib.cloud.utils.Collections3;
import com.qweib.cloud.utils.Page;
import com.qweib.commons.MathUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import javax.annotation.Resource;
import java.util.List;

//@Repository
public class SysWebNoticeDao {

    @Resource(name = "pdaoTemplate")
    private JdbcDaoTemplatePlud pdaoTemplate;
    @Qualifier("memberRequest")
    @Autowired
    private SysMemberRequest memberRequest;

    /**
     * 公告分页查询
     */
    public Page page(SysNotice notice, Integer pageNo, Integer pageSize, String database, String tp) {
        StringBuilder sql = new StringBuilder(64);
        sql.append("SELECT n.notice_pic,n.notice_id,n.notice_title,DATE_FORMAT(n.notice_time,'%Y-%m-%d')notice_time");
        sql.append(" FROM sys_notice n WHERE n.notice_tp='").append(tp).append("' ");
        if (StringUtils.isNotBlank(database)) {
            sql.append(" AND n.datasource='").append(database).append("' ");
        }
        sql.append(" ORDER BY n.notice_id DESC");
        try {
            Page page = this.pdaoTemplate.queryForPageByMySql(sql.toString(), pageNo, pageSize, SysNotice.class);
            List<SysNotice> rows = page.getRows();
            if (Collections3.isNotEmpty(rows)) {
                for (SysNotice data : rows) {
                    if (MathUtils.valid(data.getMemberId())) {
                        SysMemberDTO memberDTO = HttpResponseUtils.convertResponseNull(memberRequest.get(data.getMemberId()));
                        if (memberDTO != null) {
                            data.setMemberNm(memberDTO.getName());
                        }
                    }
                }
            }

            return page;
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 通过ID获取公告信息
     */
    public SysNotice queryNoticeById(Integer id, String database) {
        String sql = " select * from sys_notice where notice_id=?";
        if (null != database) {
            sql = sql + "  and datasource='" + database + "'";
        }
        try {
            return pdaoTemplate.queryForObj(sql, SysNotice.class, id);
        } catch (Exception ex) {
            throw new DaoException(ex);
        }
    }
}
