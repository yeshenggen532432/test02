package com.qweib.cloud.repository;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.SysBfxsxj;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

@Repository
public class SysBfxsxjDao {
    @Resource(name = "daoTemplate")
    private JdbcDaoTemplate daoTemplate;

    /**
     * 说明：分页查询销售小结（根据业务员和客户）
     *
     * @创建：作者:llp 创建时间：2016-4-28
     * @修改历史： [序号](llp 2016 - 4 - 28)<修改说明>
     */
    public Page queryBfxsxjPage(String database, Integer mid, Integer cid, String xjdate, Integer page, Integer limit) {
        StringBuilder sql = new StringBuilder();
        sql.append("select a.*,b.ware_nm,b.ware_gg from " + database + ".sys_bfxsxj a left join " + database + ".sys_ware b on a.wid=b.ware_id where a.mid=" + mid + " and a.cid=" + cid + " and a.xjdate='" + xjdate + "'");
        sql.append(" order by a.id desc");
        try {
            return this.daoTemplate.queryForPageByMySql(sql.toString(), page, limit, SysBfxsxj.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public Page sumBfxsxjStatPage(SysBfxsxj xj, Integer page, Integer limit)
    {
        String database = xj.getDatabase();
        String sql = "select a.wid,w.ware_nm,sum(a.dh_num) as dhNum,sum(a.sx_num) as sxNum,sum(a.dd_num) as ddNum "
                + "from " + database + ".sys_bfxsxj a join " + database + ".sys_customer c on a.cid=c.id "
                + "join " + database + ".sys_ware w on a.wid = w.ware_id where 1 = 1 ";
        if (xj.getWaretype() != null) {
            if (xj.getWaretype().intValue() > 0)
                sql += " and w.waretype in(select waretype_id from " + database + ".sys_waretype where waretype_path like '%-" + xj.getWaretype() + "-%')";
        }
        if (!StrUtil.isNull(xj.getCustomerType())) {
            sql = sql + " and  a.cid in (select c.id from " + database + ".sys_customer c where c.qdtp_nm ='" + xj.getCustomerType() + "')";
        }
        if (!StrUtil.isNull(xj.getSdate())) {
            sql += " and a.xjdate>='" + xj.getSdate() + "'";
        }
        if (!StrUtil.isNull(xj.getEdate())) sql += " and a.xjdate<'" + xj.getEdate() + "'";
        if (!StrUtil.isNull(xj.getWareNm())) sql += " and w.ware_nm like '%" + xj.getWareNm() + "%'";
        if (xj.getNoCompany() != null) {
            if (xj.getNoCompany().intValue() == 1)//非公司
            {
                sql += " and w.waretype in(select waretype_id from " + database + ".sys_waretype where no_Company = 1)";
            }
            if (xj.getNoCompany().intValue() == 2)//公司产品
            {
                sql += " and w.waretype in(select waretype_id from " + database + ".sys_waretype where (no_Company <> 1 or no_Company is null))";
            }
        }

        if (xj.getCid() != null) {
            sql += " and a.cid = " + xj.getCid();
        }

        sql += " group by a.cid,c.kh_nm,a.wid,w.ware_nm order by a.cid,c.kh_nm,a.wid,w.ware_nm";
        return this.daoTemplate.queryForPageByMySql(sql, page, limit, SysBfxsxj.class);
    }

    public Page sumBfxsxjPage(SysBfxsxj xj, Integer page, Integer limit) {
        String database = xj.getDatabase();
        String sql = "select a.cid,c.kh_nm,a.wid,w.ware_nm,sum(a.dh_num) as dhNum,sum(a.sx_num) as sxNum,sum(a.dd_num) as ddNum "
                + "from " + database + ".sys_bfxsxj a join " + database + ".sys_customer c on a.cid=c.id "
                + "join " + database + ".sys_ware w on a.wid = w.ware_id where 1 = 1 ";
        if (xj.getWaretype() != null) {
            if (xj.getWaretype().intValue() > 0)
                sql += " and w.waretype in(select waretype_id from " + database + ".sys_waretype where waretype_path like '%-" + xj.getWaretype() + "-%')";
        }
        if (!StrUtil.isNull(xj.getCustomerType())) {
            sql = sql + " and  a.cid in (select c.id from " + database + ".sys_customer c where c.qdtp_nm ='" + xj.getCustomerType() + "')";
        }
        if (!StrUtil.isNull(xj.getSdate())) {
            sql += " and a.xjdate>='" + xj.getSdate() + "'";
        }
        if (!StrUtil.isNull(xj.getEdate())) sql += " and a.xjdate<'" + xj.getEdate() + "'";
        if (!StrUtil.isNull(xj.getWareNm())) sql += " and w.ware_nm like '%" + xj.getWareNm() + "%'";
        if (xj.getNoCompany() != null) {
            if (xj.getNoCompany().intValue() == 1)//非公司
            {
                sql += " and w.waretype in(select waretype_id from " + database + ".sys_waretype where no_Company = 1)";
            }
            if (xj.getNoCompany().intValue() == 2)//公司产品
            {
                sql += " and w.waretype in(select waretype_id from " + database + ".sys_waretype where (no_Company <> 1 or no_Company is null))";
            }
        }

        if (xj.getCid() != null) {
            sql += " and a.cid = " + xj.getCid();
        }

        sql += " group by a.cid,c.kh_nm,a.wid,w.ware_nm order by a.cid,c.kh_nm,a.wid,w.ware_nm";
        return this.daoTemplate.queryForPageByMySql(sql, page, limit, SysBfxsxj.class);

    }

    public SysBfxsxj sumBfxsxjPage_total(SysBfxsxj xj) {
        String database = xj.getDatabase();
        String sql = "select sum(a.dh_num) as dhNum,sum(a.sx_num) as sxNum,sum(a.dd_num) as ddNum "
                + "from " + database + ".sys_bfxsxj a join " + database + ".sys_customer c on a.cid=c.id "
                + "join " + database + ".sys_ware w on a.wid = w.ware_id where 1 = 1 ";
        if (xj.getWaretype() != null) {
            if (xj.getWaretype().intValue() > 0)
                sql += " and w.waretype in(select waretype_id from " + database + ".sys_waretype where waretype_path like '%-" + xj.getWaretype() + "-%')";
        }
        if (!StrUtil.isNull(xj.getCustomerType())) {
            sql = sql + " and  a.cid in (select c.id from " + database + ".sys_customer c where c.qdtp_nm ='" + xj.getCustomerType() + "')";
        }
        if (!StrUtil.isNull(xj.getSdate())) {
            sql += " and a.xjdate>='" + xj.getSdate() + "'";
        }
        if (!StrUtil.isNull(xj.getEdate())) sql += " and a.xjdate<'" + xj.getEdate() + "'";
        if (!StrUtil.isNull(xj.getWareNm())) sql += " and w.ware_nm like '%" + xj.getWareNm() + "%'";
        if (xj.getNoCompany() != null) {
            if (xj.getNoCompany().intValue() == 1)//非公司
            {
                sql += " and w.waretype in(select waretype_id from " + database + ".sys_waretype where no_Company = 1)";
            }
            if (xj.getNoCompany().intValue() == 2)//公司产品
            {
                sql += " and w.waretype in(select waretype_id from " + database + ".sys_waretype where (no_Company <> 1 or no_Company is null))";
            }
        }

        if (xj.getCid() != null) {
            sql += " and a.cid = " + xj.getCid();
        }

        List<SysBfxsxj> list = this.daoTemplate.queryForLists(sql, SysBfxsxj.class);
        if (list.size() > 0) return list.get(0);
        return null;

    }

    public Page sumBfxsxjPage1(SysBfxsxj xj, Integer page, Integer limit) {
        String database = xj.getDatabase();
        String sql = "select a.cid,c.kh_nm,sum(a.dh_num) as dhNum,sum(a.sx_num) as sxNum,sum(a.dd_num) as ddNum "
                + "from " + database + ".sys_bfxsxj a join " + database + ".sys_customer c on a.cid=c.id "
                + " join " + database + ".sys_ware w on a.wid = w.ware_id "
                + " join " + database + ".sys_mem m on a.mid = m.member_id "
                + " where 1 = 1 ";

        if (xj.getWaretype() != null) {
            if (xj.getWaretype().intValue() > 0)
                sql += " and w.waretype in(select waretype_id from " + database + ".sys_waretype where waretype_path like '%-" + xj.getWaretype() + "-%')";
        }
        if (!StrUtil.isNull(xj.getCustomerType())) {
            sql = sql + " and  a.cid in (select c.id from " + database + ".sys_customer c where c.qdtp_nm ='" + xj.getCustomerType() + "')";
        }
        if (!StrUtil.isNull(xj.getHzfsNm())) {
            sql = sql + " and  a.cid in (select c.id from " + database + ".sys_customer c where c.hzfs_nm ='" + xj.getHzfsNm() + "')";
        }
        if (!StrUtil.isNull(xj.getSdate())) {
            sql += " and a.xjdate>='" + xj.getSdate() + "'";
        }
        if (!StrUtil.isNull(xj.getMemberNm())) sql += " and m.member_nm like '%" + xj.getMemberNm() + "%'";
        if (!StrUtil.isNull(xj.getKhNm())) sql += " and c.kh_nm like '%" + xj.getKhNm() + "%'";
        if (!StrUtil.isNull(xj.getEdate())) sql += " and a.xjdate<'" + xj.getEdate() + "'";

        if (xj.getNoCompany() != null) {
            if (xj.getNoCompany().intValue() == 1)//非公司
            {
                sql += " and w.waretype in(select waretype_id from " + database + ".sys_waretype where no_Company = 1)";
            }
            if (xj.getNoCompany().intValue() == 2)//公司产品
            {
                sql += " and w.waretype in(select waretype_id from " + database + ".sys_waretype where (no_Company <> 1 or no_Company is null))";
            }
        }
        sql += " group by a.cid,c.kh_nm ";
        return this.daoTemplate.queryForPageByMySql(sql, page, limit, SysBfxsxj.class);

    }

    public SysBfxsxj sumBfxsxjPage1_total(SysBfxsxj xj) {
        String database = xj.getDatabase();
        String sql = "select sum(a.dh_num) as dhNum,sum(a.sx_num) as sxNum,sum(a.dd_num) as ddNum "
                + "from " + database + ".sys_bfxsxj a join " + database + ".sys_customer c on a.cid=c.id "
                + " join " + database + ".sys_ware w on a.wid = w.ware_id "
                + " join " + database + ".sys_mem m on a.mid = m.member_id "
                + " where 1 = 1 ";

        if (!StrUtil.isNull(xj.getCustomerType())) {
            sql = sql + " and  a.cid in (select c.id from " + database + ".sys_customer c where c.qdtp_nm ='" + xj.getCustomerType() + "')";
        }
        if (!StrUtil.isNull(xj.getHzfsNm())) {
            sql = sql + " and  a.cid in (select c.id from " + database + ".sys_customer c where c.hzfs_nm ='" + xj.getHzfsNm() + "')";
        }
        if (!StrUtil.isNull(xj.getSdate())) {
            sql += " and a.xjdate>='" + xj.getSdate() + "'";
        }
        if (!StrUtil.isNull(xj.getKhNm())) sql += " and c.kh_nm like '%" + xj.getKhNm() + "%'";
        if (!StrUtil.isNull(xj.getEdate())) sql += " and a.xjdate<'" + xj.getEdate() + "'";
        if (!StrUtil.isNull(xj.getMemberNm())) sql += " and m.member_nm like '%" + xj.getMemberNm() + "%'";
        if (xj.getNoCompany() != null) {
            if (xj.getNoCompany().intValue() == 1)//非公司
            {
                sql += " and w.waretype in(select waretype_id from " + database + ".sys_waretype where no_Company = 1)";
            }
            if (xj.getNoCompany().intValue() == 2)//公司产品
            {
                sql += " and w.waretype in(select waretype_id from " + database + ".sys_waretype where (no_Company <> 1 or no_Company is null))";
            }
        }

        List<SysBfxsxj> list = this.daoTemplate.queryForLists(sql, SysBfxsxj.class);
        if (list.size() > 0) return list.get(0);
        return null;

    }

    //最后库存汇总
    public Integer sumBfxsxjKC_total(SysBfxsxj xj) {
        String database = xj.getDatabase();
        String sql = "SELECT a.* from " + database + ".sys_bfxsxj  a join " + database + ".sys_customer c on a.cid=c.id "
                + " join " + database + ".sys_ware w on a.wid = w.ware_id "
                + " join " + database + ".sys_mem m on a.mid = m.member_id "
                + " where 1 = 1 ";
        if (!StrUtil.isNull(xj.getCustomerType())) {
            sql = sql + " and  a.cid in (select c.id from " + database + ".sys_customer c where c.qdtp_nm ='" + xj.getCustomerType() + "')";
        }
        if (!StrUtil.isNull(xj.getHzfsNm())) {
            sql = sql + " and  a.cid in (select c.id from " + database + ".sys_customer c where c.hzfs_nm ='" + xj.getHzfsNm() + "')";
        }
        if (!StrUtil.isNull(xj.getSdate())) {
            sql += " and a.xjdate>='" + xj.getSdate() + "'";
        }
        if (!StrUtil.isNull(xj.getKhNm())) sql += " and c.kh_nm like '%" + xj.getKhNm() + "%'";
        if (!StrUtil.isNull(xj.getEdate())) sql += " and a.xjdate<'" + xj.getEdate() + "'";
        if (!StrUtil.isNull(xj.getMemberNm())) sql += " and m.member_nm like '%" + xj.getMemberNm() + "%'";
        if (xj.getNoCompany() != null) {
            if (xj.getNoCompany().intValue() == 1)//非公司
            {
                sql += " and w.waretype in(select waretype_id from " + database + ".sys_waretype where no_Company = 1)";
            }
            if (xj.getNoCompany().intValue() == 2)//公司产品
            {
                sql += " and w.waretype in(select waretype_id from " + database + ".sys_waretype where (no_Company <> 1 or no_Company is null))";
            }
        }

        sql += "ORDER BY a.xjdate DESC ";
        sql = "select sum(kc_num) from (SELECT wid,cid,xjdate,kc_num from (" + sql + ") aa group by wid,cid ) bb ";
        Integer sum = this.daoTemplate.queryForObject(sql, Integer.class);
        return sum;

    }


    public List<SysBfxsxj> queryxjDetail(SysBfxsxj xj) {
        String database = xj.getDatabase();
        String sql = "select a.cid,c.kh_nm,a.wid,w.ware_nm,a.dh_num,a.sx_num,a.dd_num,a.kc_num,a.xjdate "
                + "from " + database + ".sys_bfxsxj a join " + database + ".sys_customer c on a.cid=c.id "
                + "join " + database + ".sys_ware w on a.wid = w.ware_id where 1 = 1 ";
        if (xj.getCid() != null) sql += " and a.cid=" + xj.getCid();
        if (xj.getWid() != null) sql += " and a.wid=" + xj.getWid();

        if (!StrUtil.isNull(xj.getSdate())) {
            sql += " and a.xjdate>='" + xj.getSdate() + "'";
        }
        if (!StrUtil.isNull(xj.getEdate())) sql += " and a.xjdate<'" + xj.getEdate() + "'";

        List<SysBfxsxj> list = this.daoTemplate.queryForLists(sql, SysBfxsxj.class);
        SysBfxsxj sumVo = new SysBfxsxj();
        sumVo.setDhNum(0);
        sumVo.setSxNum(0);
        sumVo.setDdNum(0);
        sumVo.setXjdate("合计：");
        for (SysBfxsxj vo : list) {
            sumVo.setDhNum(sumVo.getDhNum().intValue() + vo.getDhNum().intValue());
            sumVo.setSxNum(sumVo.getSxNum().intValue() + vo.getSxNum().intValue());
            sumVo.setDdNum(sumVo.getDdNum().intValue() + vo.getDdNum().intValue());
        }
        list.add(sumVo);
        return list;

    }

    public SysBfxsxj getLastKcNum(Integer cid, Integer wid, String sdate, String edate, String database) {
        String sql = "select  * from " + database + ".sys_bfxsxj where cid=" + cid + " and wid=" + wid
                + " and xjdate>='" + sdate + "' and xjdate<'" + edate + "'"
                + " ORDER BY xjdate DESC LIMIT 0,1 ";
        List<SysBfxsxj> list = this.daoTemplate.queryForLists(sql, SysBfxsxj.class);
        if (list.size() > 0) {
            return list.get(0);
        }
        return null;
    }

    public Integer getLastKcNum_total(Integer cid, String sdate, String edate, String database) {
        String sql = "select sum(kc_num) as kcNum from ("
                + "SELECT wid,xjdate,kc_num from(SELECT *  from " + database + ".sys_bfxsxj where cid =" + cid.toString();
        if (!StrUtil.isNull(sdate)) {
            sql += " and xjdate>='" + sdate + "'";
        }
        if (!StrUtil.isNull(edate)) sql += " and xjdate<'" + edate + "'";
        sql += " ORDER BY xjdate DESC) aa group by wid)aa ";

        Map map = this.daoTemplate.queryForMap(sql);
        String maxNo = "";
        Integer kcNum = 0;
        if (map != null) {
            if (map.get("kcnum") != null) {
                maxNo = map.get("kcnum").toString();
                Double f = Double.valueOf(maxNo);
                kcNum = (int) f.doubleValue();
            }
            //maxNo = "";
        }
        return kcNum;
    }

    public List<SysBfxsxj> getLastKcNumByCustomer(SysBfxsxj xj, String database) {
        String sql = "select cid,no_Company,sum(kc_num) as kc_num from( select cid,wid,no_Company,kc_num from ( "
        +"select a.cid,a.wid,ifnull(t.no_Company,0) as no_Company,kc_num from " + database + ".sys_bfxsxj a join " + database + ".sys_ware w on a.wid=w.ware_id "
        +"join " + database + ".sys_waretype t on w.waretype = t.waretype_id join " + database + ".sys_customer c on a.cid = c.id "
        +" join " + database + ".sys_mem m on a.mid = m.member_id where 1  = 1 ";
        if (xj.getWaretype() != null) {
            if (xj.getWaretype().intValue() > 0)
                sql += " and w.waretype in(select waretype_id from " + database + ".sys_waretype where waretype_path like '%-" + xj.getWaretype() + "-%')";
        }
        if (!StrUtil.isNull(xj.getCustomerType())) {
            sql = sql + " and  a.cid in (select c.id from " + database + ".sys_customer c where c.qdtp_nm ='" + xj.getCustomerType() + "')";
        }
        if (!StrUtil.isNull(xj.getHzfsNm())) {
            sql = sql + " and  a.cid in (select c.id from " + database + ".sys_customer c where c.hzfs_nm ='" + xj.getHzfsNm() + "')";
        }
        if (!StrUtil.isNull(xj.getSdate())) {
            sql += " and a.xjdate>='" + xj.getSdate() + "'";
        }
        if (!StrUtil.isNull(xj.getMemberNm())) sql += " and m.member_nm like '%" + xj.getMemberNm() + "%'";
        if (!StrUtil.isNull(xj.getKhNm())) sql += " and c.kh_nm like '%" + xj.getKhNm() + "%'";
        if (!StrUtil.isNull(xj.getEdate())) sql += " and a.xjdate<'" + xj.getEdate() + "'";

        if (xj.getNoCompany() != null) {
            if (xj.getNoCompany().intValue() == 1)//非公司
            {
                sql += " and w.waretype in(select waretype_id from " + database + ".sys_waretype where no_Company = 1)";
            }
            if (xj.getNoCompany().intValue() == 2)//公司产品
            {
                sql += " and w.waretype in(select waretype_id from " + database + ".sys_waretype where (no_Company <> 1 or no_Company is null))";
            }
        }


        sql += " order by a.cid,a.wid,a.xjdate desc)aa group by cid,wid,no_Company)bb GROUP BY cid,no_Company ";


        List<SysBfxsxj> list  = this.daoTemplate.queryForLists(sql, SysBfxsxj.class);
        return list;
    }



    /**
     * 查询各种商品的在售商家数
     * @param xj
     * @param page
     * @param limit
     * @return
     */
    public Page sumBfxsxjPage2(SysBfxsxj xj, Integer page, Integer limit) {
        String database = xj.getDatabase();
        String sql = "select wid,ware_nm,sum(1) as dhNum "
                + "from (select distinct a.cid,a.wid,w.ware_nm from " + database + ".sys_bfxsxj a join " + database + ".sys_customer c on a.cid=c.id "
                + " join " + database + ".sys_ware w on a.wid = w.ware_id "
                + " join " + database + ".sys_mem m on a.mid = m.member_id "
                +" left join "+xj.getDatabase()+".sys_region region on c.region_id=region.region_id "
                + " where 1 = 1 ";

        if(!StrUtil.isNull(xj.getRegionNm())){
           sql += " and region.region_nm like '%"+xj.getRegionNm()+"%'";
        }
        if (!StrUtil.isNull(xj.getCustomerType())) {
            sql = sql + " and  a.cid in (select c.id from " + database + ".sys_customer c where c.qdtp_nm ='" + xj.getCustomerType() + "')";
        }
        if (!StrUtil.isNull(xj.getHzfsNm())) {
            sql = sql + " and  a.cid in (select c.id from " + database + ".sys_customer c where c.hzfs_nm ='" + xj.getHzfsNm() + "')";
        }
        if (!StrUtil.isNull(xj.getSdate())) {
            sql += " and a.xjdate>='" + xj.getSdate() + "'";
        }
        if (!StrUtil.isNull(xj.getMemberNm())) sql += " and m.member_nm like '%" + xj.getMemberNm() + "%'";
        if (!StrUtil.isNull(xj.getKhNm())) sql += " and c.kh_nm like '%" + xj.getKhNm() + "%'";
        if (!StrUtil.isNull(xj.getEdate())) sql += " and a.xjdate<'" + xj.getEdate() + "'";
        if(!StrUtil.isNull(xj.getWareNm()))sql += " and w.ware_nm like '%" + xj.getWareNm() + "%'";

        if (xj.getNoCompany() != null) {
            if (xj.getNoCompany().intValue() == 1)//非公司
            {
                sql += " and w.waretype in(select waretype_id from " + database + ".sys_waretype where no_Company = 1)";
            }
            if (xj.getNoCompany().intValue() == 2)//公司产品
            {
                sql += " and w.waretype in(select waretype_id from " + database + ".sys_waretype where (no_Company <> 1 or no_Company is null))";
            }
        }
        if(xj.getWaretype()!= null)
        {
            if(xj.getWaretype().intValue() > 0)
            {
                sql += " and w.waretype in(select waretype_id from " + database + ".sys_waretype where waretype_path like '%-" + xj.getWaretype() + "-%')";
            }
        }
        sql += ")aa group by wid,ware_nm ";
        return this.daoTemplate.queryForPageByMySql(sql, page, limit, SysBfxsxj.class);

    }

    /**
     * 最新库存量汇总
     * @param xj
     * @return
     */

    public List<SysBfxsxj> getSumLastKcNum_total(SysBfxsxj xj) {
        String database = xj.getDatabase();
        String sql = "select wid,sum(kc_num) as kcNum from (SELECT cid,wid,kc_num from (SELECT a.cid,wid,kc_num  from " + database + ".sys_bfxsxj a  " +
                "join " + database + ".sys_customer c on a.cid=c.id  join " + database + ".sys_ware w on a.wid = w.ware_id  " +
                "join " + database + ".sys_mem m on a.mid = m.member_id "
                +" left join "+xj.getDatabase()+".sys_region region on c.region_id=region.region_id "
        +" where 1 = 1 ";
        if(!StrUtil.isNull(xj.getRegionNm())){
            sql += " and region.region_nm like '%"+xj.getRegionNm()+"%'";
        }
        if (!StrUtil.isNull(xj.getCustomerType())) {
            sql = sql + " and  a.cid in (select c.id from " + database + ".sys_customer c where c.qdtp_nm ='" + xj.getCustomerType() + "')";
        }
        if (!StrUtil.isNull(xj.getHzfsNm())) {
            sql = sql + " and  a.cid in (select c.id from " + database + ".sys_customer c where c.hzfs_nm ='" + xj.getHzfsNm() + "')";
        }
        if (!StrUtil.isNull(xj.getSdate())) {
            sql += " and a.xjdate>='" + xj.getSdate() + "'";
        }
        if (!StrUtil.isNull(xj.getMemberNm())) sql += " and m.member_nm like '%" + xj.getMemberNm() + "%'";
        if (!StrUtil.isNull(xj.getKhNm())) sql += " and c.kh_nm like '%" + xj.getKhNm() + "%'";
        if (!StrUtil.isNull(xj.getEdate())) sql += " and a.xjdate<'" + xj.getEdate() + "'";
        if(!StrUtil.isNull(xj.getWareNm()))sql += " and w.ware_nm like '%" + xj.getWareNm() + "%'";
        if (xj.getNoCompany() != null) {
            if (xj.getNoCompany().intValue() == 1)//非公司
            {
                sql += " and w.waretype in(select waretype_id from " + database + ".sys_waretype where no_Company = 1)";
            }
            if (xj.getNoCompany().intValue() == 2)//公司产品
            {
                sql += " and w.waretype in(select waretype_id from " + database + ".sys_waretype where (no_Company <> 1 or no_Company is null))";
            }
        }
        if(xj.getWaretype()!= null)
        {
            if(xj.getWaretype().intValue() > 0)
            {
                sql += " and w.waretype in(select waretype_id from " + database + ".sys_waretype where waretype_path like '%-" + xj.getWaretype() + "-%')";
            }
        }
        sql += " ORDER BY xjdate DESC) aa GROUP BY cid,wid order by cid,wid DESC)bb group by wid ";

        return this.daoTemplate.queryForLists(sql, SysBfxsxj.class);
    }


    public Integer getSumCstQty_total(SysBfxsxj xj) {
        String database = xj.getDatabase();
        String sql = "select sum(1) as kcnum from ("
                + "SELECT distinct a.cid  from " + database + ".sys_bfxsxj a  join " + database + ".sys_customer c on a.cid=c.id "
                + " join " + database + ".sys_ware w on a.wid = w.ware_id "
                + " join " + database + ".sys_mem m on a.mid = m.member_id where 1 = 1 ";
        if (!StrUtil.isNull(xj.getCustomerType())) {
            sql = sql + " and  a.cid in (select c.id from " + database + ".sys_customer c where c.qdtp_nm ='" + xj.getCustomerType() + "')";
        }
        if (!StrUtil.isNull(xj.getHzfsNm())) {
            sql = sql + " and  a.cid in (select c.id from " + database + ".sys_customer c where c.hzfs_nm ='" + xj.getHzfsNm() + "')";
        }
        if (!StrUtil.isNull(xj.getSdate())) {
            sql += " and a.xjdate>='" + xj.getSdate() + "'";
        }
        if (!StrUtil.isNull(xj.getMemberNm())) sql += " and m.member_nm like '%" + xj.getMemberNm() + "%'";
        if (!StrUtil.isNull(xj.getKhNm())) sql += " and c.kh_nm like '%" + xj.getKhNm() + "%'";
        if (!StrUtil.isNull(xj.getEdate())) sql += " and a.xjdate<'" + xj.getEdate() + "'";
        if(!StrUtil.isNull(xj.getWareNm()))sql += " and w.ware_nm like '%" + xj.getWareNm() + "%'";
        if (xj.getNoCompany() != null) {
            if (xj.getNoCompany().intValue() == 1)//非公司
            {
                sql += " and w.waretype in(select waretype_id from " + database + ".sys_waretype where no_Company = 1)";
            }
            if (xj.getNoCompany().intValue() == 2)//公司产品
            {
                sql += " and w.waretype in(select waretype_id from " + database + ".sys_waretype where (no_Company <> 1 or no_Company is null))";
            }
        }
        if(xj.getWaretype()!= null)
        {
            if(xj.getWaretype().intValue() > 0)
            {
                sql += " and w.waretype in(select waretype_id from " + database + ".sys_waretype where waretype_path like '%-" + xj.getWaretype() + "-%')";
            }
        }
        sql += " ORDER BY xjdate DESC) aa ";

        Map map = this.daoTemplate.queryForMap(sql);
        String maxNo = "";
        Integer kcNum = 0;
        if (map != null) {
            if (map.get("kcnum") != null) {
                maxNo = map.get("kcnum").toString();
                Double f = Double.valueOf(maxNo);
                kcNum = (int) f.doubleValue();
            }
            //maxNo = "";
        }
        return kcNum;
    }



}
