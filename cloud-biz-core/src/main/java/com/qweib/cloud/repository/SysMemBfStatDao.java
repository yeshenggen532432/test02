package com.qweib.cloud.repository;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.SysMemBfStat;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

@Repository
public class SysMemBfStatDao {
    @Resource(name = "daoTemplate")
    private JdbcDaoTemplate daoTemplate;

    public Page queryMemBfStatPage(SysMemBfStat vo, String database, Integer page, Integer limit)
    {
        String sql = "select a.mem_id as memberId,b.member_nm,sum(1) as cstQty from " + database + ".sys_customer a left join " + database + ".sys_mem b on a.mem_id = b.member_id where a.mem_id is not null and a.is_db = 2 ";
        if (!StrUtil.isNull(vo.getMemberNm())) sql += " and b.member_nm like '%" + vo.getMemberNm() + "%'";
        if (!StrUtil.isNull(vo.getKhNm())) sql += " and a.kh_nm like '%" + vo.getKhNm() + "%'";
        if (!StrUtil.isNull(vo.getCustomerType())) {
            sql += " and a.qdtp_nm ='" + vo.getCustomerType() + "'";

        }
        if (!StrUtil.isNull(vo.getHzfsNm())) {
            sql += " and a.hzfs_nm ='" + vo.getHzfsNm() + "'";

        }
        sql += " group by a.mem_id ";
        Page p = this.daoTemplate.queryForPageByMySql(sql,page,limit, SysMemBfStat.class);
        sql = "select mid as memberId,sum(1) as bfQty from (SELECT distinct a.mid,a.cid from " + database + ".sys_bfqdpz a join " + database + ".sys_customer b on a.cid = b.id and a.mid = b.mem_id ";
        sql += " left join " + database + ".sys_mem m on a.mid = m.member_id where  b.is_db=2 ";
        if(!StrUtil.isNull(vo.getSdate()))sql += " and qddate>='" + vo.getSdate() + "'";
        if(!StrUtil.isNull(vo.getEdate()))sql += " and qddate<'" + vo.getEdate() + "'";
        if(!StrUtil.isNull(vo.getMemberNm()))sql += " and m.member_nm like '%" + vo.getMemberNm() + "'";
        if (!StrUtil.isNull(vo.getKhNm())) sql += " and b.kh_nm like '%" + vo.getKhNm() + "%'";
        if (!StrUtil.isNull(vo.getCustomerType())) {
            sql += " and b.qdtp_nm ='" + vo.getCustomerType() + "'";

        }
        if (!StrUtil.isNull(vo.getHzfsNm())) {
            sql += " and b.hzfs_nm ='" + vo.getHzfsNm() + "'";

        }
        sql += ")aa group by mid ";
        List<SysMemBfStat> list = this.daoTemplate.queryForLists(sql, SysMemBfStat.class);
        //跨区域拜访统计
        sql = "select mid as memberId,sum(1) as bfQty from (SELECT distinct a.mid,a.cid from " + database + ".sys_bfqdpz a join " + database + ".sys_customer b on a.cid = b.id and a.mid <> b.mem_id ";
        sql += " left join " + database + ".sys_mem m on a.mid = m.member_id where  b.is_db = 2 ";
        if(!StrUtil.isNull(vo.getSdate()))sql += " and qddate>='" + vo.getSdate() + "'";
        if(!StrUtil.isNull(vo.getEdate()))sql += " and qddate<'" + vo.getEdate() + "'";
        if(!StrUtil.isNull(vo.getMemberNm()))sql += " and m.member_nm like '%" + vo.getMemberNm() + "'";
        if (!StrUtil.isNull(vo.getKhNm())) sql += " and b.kh_nm like '%" + vo.getKhNm() + "%'";
        if (!StrUtil.isNull(vo.getCustomerType())) {
            sql += " and b.qdtp_nm ='" + vo.getCustomerType() + "'";

        }
        if (!StrUtil.isNull(vo.getHzfsNm())) {
            sql += " and b.hzfs_nm ='" + vo.getHzfsNm() + "'";

        }
        sql += ")aa group by mid ";
        List<SysMemBfStat> list1 = this.daoTemplate.queryForLists(sql, SysMemBfStat.class);

        List<SysMemBfStat> retList = p.getRows();
        Integer totalBf1 = 0;
        SysMemBfStat nullVo = null;
        for(SysMemBfStat vo1: list)
        {
            if(vo1.getBfQty()!= null)totalBf1+= vo1.getBfQty();
            for(SysMemBfStat vo2: retList)
            {
                if(vo2.getMemberId()!= null)
                {
                    if(vo2.getMemberId().intValue() == vo1.getMemberId().intValue())
                    {
                        vo2.setBfQty(vo1.getBfQty());
                        Integer n = vo2.getCstQty();
                        if(n == null)n = 0;
                        if(vo2.getBfQty() == null)vo2.setBfQty(0);
                        n = n - vo2.getBfQty();
                        if(n < 0)n = 0;
                        vo2.setWbfQty(n);
                        vo2.setBfRate(new BigDecimal(0));
                        vo2.setWbfRate(new BigDecimal(0));
                        if(vo2.getCstQty().intValue() > 0)
                        {
                            BigDecimal ff = new BigDecimal(vo2.getCstQty());
                            BigDecimal mm = new BigDecimal(vo2.getBfQty());
                            ff = mm.divide(ff,2,BigDecimal.ROUND_HALF_UP);
                            ff = ff.setScale(2, BigDecimal.ROUND_HALF_UP);
                            mm = new BigDecimal(1);
                            mm = mm.subtract(ff);
                            vo2.setBfRate(ff);//拜访率
                            vo2.setWbfRate(mm);//未拜访率
                        }
                    }
                }
            }

        }
        Integer totalBf2 = 0;
        for(SysMemBfStat vo1: list1)
        {
            if(vo1.getBfQty()!= null)totalBf2+= vo1.getBfQty();
            for(SysMemBfStat vo2: retList) {
                if (vo2.getMemberId() != null) {
                    if (vo2.getMemberId().intValue() == vo1.getMemberId().intValue()) {
                        vo2.setBfQty1(vo1.getBfQty());
                    }
                }
            }
        }
        for(SysMemBfStat vo1: retList)
        {
            vo1.setOtherQty(0);
        }
        nullVo = new SysMemBfStat();
        //删除员工姓名为空的记录
        nullVo.setCstQty(0);
        nullVo.setBfQty(0);
        nullVo.setBfQty1(0);
        List<SysMemBfStat> retList1 = new ArrayList<SysMemBfStat>() ;
        for(int i = retList.size() - 1;i>-1;i--)
        {
            SysMemBfStat vo1 = retList.get(i);
            if(vo1.getBfRate()!= null)
            {
                vo1.setBfRate(new BigDecimal(vo1.getBfRate().doubleValue()*100).setScale(2, BigDecimal.ROUND_HALF_UP));
            }
            if(vo1.getWbfRate()!= null)
            {
                vo1.setWbfRate(new BigDecimal(vo1.getWbfRate().doubleValue()*100).setScale(2, BigDecimal.ROUND_HALF_UP));
            }
            if(StrUtil.isNull(vo1.getMemberNm()))
            {
                if(vo1.getBfQty1() == null)vo1.setBfQty1(0);
                if(vo1.getBfQty() == null)vo1.setBfQty(0);
                if(vo1.getCstQty() == null)vo1.setCstQty(0);
                nullVo.setCstQty(nullVo.getCstQty().intValue() + vo1.getCstQty().intValue());
                nullVo.setBfQty(nullVo.getBfQty().intValue() + vo1.getBfQty().intValue());
                nullVo.setBfQty1(nullVo.getBfQty1().intValue() + vo1.getBfQty1().intValue());
                //retList.remove(i);
            }
            else retList1.add(vo1);
        }
        nullVo.setMemberNm("无业务员客户");
        nullVo.setCstQty(nullVo.getCstQty().intValue() + this.getNullMemCstQty(vo,database).intValue());
        nullVo.setBfQty(nullVo.getBfQty().intValue() + this.getNullMemBfQty(vo,database).intValue());
        Integer n = nullVo.getCstQty() - nullVo.getBfQty();
        nullVo.setWbfQty(n);
        nullVo.setBfRate(new BigDecimal(0));
        nullVo.setOtherQty(0);
        double f = nullVo.getBfQty();
        if(nullVo.getCstQty().intValue() > 0)
        {
            f = f/nullVo.getCstQty();
            BigDecimal ff = new BigDecimal(f*100);
            ff = ff.setScale(2,BigDecimal.ROUND_HALF_UP);
            f = 100 - ff.doubleValue();
            BigDecimal ww = new BigDecimal(f);
            nullVo.setBfRate(ff);
            nullVo.setWbfRate(ww);
        }

        SysMemBfStat sumVo = new SysMemBfStat();
        sumVo.setMemberNm("合计：");
        sumVo.setCstQty(this.getTotalCstQty(vo,database));
        totalBf1+= nullVo.getBfQty();
        sumVo.setBfQty(totalBf1);
        sumVo.setBfQty1(totalBf2);
        sumVo.setWbfQty(sumVo.getCstQty() - sumVo.getBfQty());
        sumVo.setBfRate(new BigDecimal(0));
        sumVo.setWbfRate(new BigDecimal(0));
        if(sumVo.getCstQty().intValue()> 0)
        {
            f = sumVo.getBfQty();
            f = f/sumVo.getCstQty();
            BigDecimal ff = new BigDecimal(f*100);
            ff = ff.setScale(2,BigDecimal.ROUND_HALF_UP);
            f = 100 - ff.doubleValue();
            BigDecimal ww = new BigDecimal(f);
            sumVo.setBfRate(ff);
            sumVo.setWbfRate(ww);
        }
        Integer totalBf = this.getTotalBfQty(vo,database);
        sumVo.setOtherQty(sumVo.getBfQty() + sumVo.getBfQty1() - totalBf);
        if(sumVo.getOtherQty().intValue() < 0)sumVo.setOtherQty(0);
        retList1.add(nullVo);
        retList1.add(sumVo);
        p.setRows(retList1);
        return p;
    }



    /**
     * 获得总客人
     * @param database
     * @return
     */
    public  Integer getTotalCstQty(SysMemBfStat vo, String database)
    {
        String sql = "select sum(1) as qty from " + database + ".sys_customer where is_db=2 ";
        if(!StrUtil.isNull(vo.getMemberNm()))sql += " and member_nm like '%" + vo.getMemberNm() + "%'";
        if (!StrUtil.isNull(vo.getCustomerType())) {
            sql += " and qdtp_nm ='" + vo.getCustomerType() + "'";

        }
        if (!StrUtil.isNull(vo.getHzfsNm())) {
            sql += " and hzfs_nm ='" + vo.getHzfsNm() + "'";

        }
        Integer n;
        try {
            n = this.daoTemplate.queryForInt(sql);
        }
        catch (Exception e)
        {
            n = null;
        }
        if(n == null)n = 0;
        return n;
    }

    public  Integer getTotalBfQty(SysMemBfStat vo, String database)
    {
        String sql = "SELECT sum(1) as qty from (SELECT DISTINCT a.cid from " + database + ".sys_bfqdpz a left join " + database + ".sys_mem b on  a.mid = b.member_id "
                    +" left join " + database + ".sys_customer c on a.cid= c.id where 1 = 1 ";

        if(!StrUtil.isNull(vo.getSdate()))sql += " and qddate>='" + vo.getSdate() + "'";
        if(!StrUtil.isNull(vo.getEdate()))sql += " and qddate<'" + vo.getEdate() + "'";
        if(!StrUtil.isNull(vo.getMemberNm()))sql += " and b.member_nm like '%" + vo.getMemberNm() + "%'";
        if (!StrUtil.isNull(vo.getKhNm())) sql += " and c.kh_nm like '%" + vo.getKhNm() + "%'";
        if (!StrUtil.isNull(vo.getCustomerType())) {
            sql += " and c.qdtp_nm ='" + vo.getCustomerType() + "'";

        }
        if (!StrUtil.isNull(vo.getHzfsNm())) {
            sql += " and c.hzfs_nm ='" + vo.getHzfsNm() + "'";

        }

        sql += ") aa ";
        Integer n;
        try {
             n = this.daoTemplate.queryForInt(sql);
        }
        catch (Exception e)
        {
            n = null;
        }
        if(n == null)n = 0;
        return n;

    }

    public  Integer getNullMemCstQty(SysMemBfStat vo, String database)
    {
        String sql = "select sum(1) as qty from " + database + ".sys_customer where mem_id is null and is_db=2";
        if(!StrUtil.isNull(vo.getMemberNm()))return 0;
        if (!StrUtil.isNull(vo.getKhNm())) sql += " and kh_nm like '%" + vo.getKhNm() + "%'";
        if (!StrUtil.isNull(vo.getCustomerType())) {
            sql += " and qdtp_nm ='" + vo.getCustomerType() + "'";

        }
        if (!StrUtil.isNull(vo.getHzfsNm())) {
            sql += " and hzfs_nm ='" + vo.getHzfsNm() + "'";

        }
        Integer n;
        try {
            n = this.daoTemplate.queryForInt(sql);
        }
        catch (Exception e)
        {
            n = null;
        }
        if(n == null)n = 0;
        return n;
    }

    public  Integer getNullMemBfQty(SysMemBfStat vo, String database)
    {
        if(!StrUtil.isNull(vo.getMemberNm()))return 0;
        String sql = "select sum(1) as qty from (select distinct cid from sys_bfqdpz a join sys_customer b on a.cid = b.id where b.mem_id is null ";
        if(!StrUtil.isNull(vo.getSdate()))sql += " and qddate>='" + vo.getSdate() + "'";
        if(!StrUtil.isNull(vo.getEdate()))sql += " and qddate<'" + vo.getEdate() + "'";
        sql += ") aa ";
        Integer n;
        try {
            n = this.daoTemplate.queryForInt(sql);
        }
        catch (Exception e)
        {
            n = null;
        }
        if(n == null)n = 0;
        return n;
    }






}
