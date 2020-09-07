package com.qweib.cloud.biz.signin.dao;

import com.qweib.cloud.biz.signin.model.SysSignIn;
import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.DateTimeUtil;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
public class SysSignInDao {
    @Resource(name="daoTemplate")
    private JdbcDaoTemplate daoTemplate;

    public int addData(SysSignIn bo,String database)
    {
        try {
            return this.daoTemplate.addByObject(""+database+".sys_sign_in", bo);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public int updateData(SysSignIn bo,String database)
    {
        try {
            Map<String,Object> whereParam = new HashMap<String, Object>();
            whereParam.put("id", bo.getId());
            return this.daoTemplate.updateByObject(""+database+".sys_sign_in", bo, whereParam, "id");
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public Page querySignInPage(SysSignIn vo,String database,Integer page,Integer limit){
        String sql = "select a.*,m.member_nm,m.member_head from " + database + ".sys_sign_in a left join " + database + ".sys_mem m on a.mid = m.member_id where 1 = 1 ";
        if(vo != null)
        {
            if(vo.getMid()!= null)
            {
                if(vo.getMid().intValue() > 0)sql += " and a.mid =" + vo.getMid();
            }
            if(!StrUtil.isNull(vo.getMids()))
            {
                sql += " and a.mid in(" + vo.getMids() + ")";
            }
            if(!StrUtil.isNull(vo.getMemberNm()))sql += " and m.member_nm like '%" + vo.getMemberNm() + "%'";
            if(!StrUtil.isNull(vo.getSdate()))sql += " and a.sign_time>='" + vo.getSdate() + "'";
            if(!StrUtil.isNull(vo.getEdate()))sql += " and a.sign_time<'" + vo.getEdate() + "'";

        }
        sql += " order by sign_time desc ";
        return this.daoTemplate.queryForPageByMySql(sql,page,limit,SysSignIn.class);

    }

    public List<SysSignIn> querySignInList(String database, Integer mid, String date){
        try {
            String eDate = DateTimeUtil.dateTimeAddToStr(date, 5, 1, "yyyy-MM-dd");
            String sql = "select a.* from " + database + ".sys_sign_in as a where 1 = 1";
            sql += " and a.mid = " + mid;
            sql += " and a.sign_time >= '" + date +"'";
            sql += " and a.sign_time < '" + eDate +"'";
            sql += " order by sign_time asc ";
            return this.daoTemplate.queryForLists(sql, SysSignIn.class);
        } catch (Exception e) {
            e.printStackTrace();
            throw new DaoException(e);
        }
    }

}
