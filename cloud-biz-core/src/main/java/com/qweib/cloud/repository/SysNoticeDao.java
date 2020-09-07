package com.qweib.cloud.repository;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.SysNotice;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;

@Repository
public class SysNoticeDao {
    @Resource(name = "daoTemplate")
    private JdbcDaoTemplate daoTemplate;

    public Page queryNotice(SysNotice vo,Integer page,Integer limit)
    {
        String sql = "select * from publicplat.sys_notice where 1 = 1 ";
        if(!StrUtil.isNull(vo.getDatasource()))
        {
            sql += " and (datasource ='" + vo.getDatasource() + "' or datasource='')";
        }
        if(vo.getMemberId()!= null)
        {
            sql += " and member_id=" + vo.getMemberId();
        }
        if(!StrUtil.isNull(vo.getStartTime()))sql += " and notice_time>='" + vo.getStartTime() + "'";
        if(!StrUtil.isNull(vo.getEndTime()))sql += " and notice_time<='" + vo.getEndTime() + "'";
        return this.daoTemplate.queryForPageByMySql(sql,page,limit,SysNotice.class);
    }

}
