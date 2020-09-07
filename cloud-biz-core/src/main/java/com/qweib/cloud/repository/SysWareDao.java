package com.qweib.cloud.repository;

import com.google.common.collect.Lists;
import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.SysWare;
import com.qweib.cloud.core.domain.SysWareGroup;
import com.qweib.cloud.core.domain.product.BaseProduct;
import com.qweib.cloud.core.domain.product.ProductData;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.DateTimeUtil;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import com.qweib.cloud.utils.WareSqlUtil;
import com.qweib.commons.StringUtils;
import com.qweib.commons.exceptions.BizException;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Repository
public class SysWareDao {
    @Resource(name = "daoTemplate")
    private JdbcDaoTemplate daoTemplate;

    public Page queryWare(SysWare ware, int page, int rows, String database) {
        StringBuffer sql = new StringBuffer(" select a.*,b.waretype_nm,c.name as brand_nm,g.group_name from " + database + ".sys_ware a");
        sql.append(" left join " + database + ".sys_waretype b on a.waretype=b.waretype_id ");
        sql.append(" left join " + database + ".sys_brand c on a.brand_id=c.id ");
        sql.append(" left join " + database + ".sys_warespec_group g on a.group_id=g.id ");
        sql.append("  where 1=1 ");
        if (null != ware) {
            if (!StrUtil.isNull(ware.getWareNm())) {
                //sql.append(" and a.ware_nm like '%").append(ware.getWareNm()).append("%'");

                if (isContainChinese(ware.getWareNm())) {
                    ware.setWareNm(ware.getWareNm().replaceAll(" ", ""));
                    for (int i = 0; i < ware.getWareNm().length(); i++) {
                        sql.append(" and a.ware_nm like '%" + ware.getWareNm().substring(i, i + 1) + "%'");
                    }
                } else {
                    sql.append(" and (a.ware_nm like '%" + ware.getWareNm() + "%' or a.ware_code like '%" + ware.getWareNm() + "%' or a.be_bar_code like '%" + ware.getWareNm() + "%' or a.pack_bar_code like '%" + ware.getWareNm() + "%' or a.py like '%" + ware.getWareNm() + "%')");
                }
            }
            if (!StrUtil.isNull(ware.getStatus())) {
                sql.append(" and a.status=").append(ware.getStatus());
            }
            if (!StrUtil.isNull(ware.getBeBarCode())) {
                sql.append(" and a.be_bar_code like concat('%', \'").append(ware.getBeBarCode()).append("\' ,'%')");
            }
            if (!StrUtil.isNull(ware.getPackBarCode())) {
                sql.append(" and a.pack_bar_code like concat('%', \'").append(ware.getPackBarCode()).append("\' ,'%')");
            }

            if (!StrUtil.isNull(ware.getIsType())) {
                sql.append(" and b.is_type=").append(ware.getIsType());
            }
        }
        if (null != ware.getWaretype() && ware.getWaretype() != 0) {
            sql.append(" and instr(b.waretype_path,'-").append(ware.getWaretype()).append("-')>0");
        }
       /* sql.append(" order by CASE WHEN a.sort IS NULL THEN 1 ELSE 0 END ASC, a.sort,a.ware_id asc ");*/
        sql.append(WareSqlUtil.getWareSortSql());

        try {
            return this.daoTemplate.queryForPageByMySql(sql.toString(), page, rows, SysWare.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public Page page2(SysWare ware, int page, int rows, String database, Integer brandId, Integer type) {
        StringBuilder sql = new StringBuilder();
        sql.append("select * from " + database + ".sys_ware where 1=1 and status=1 ");
        try {
            if (null != ware) {
                if (!StrUtil.isNull(ware.getWareNm())) {
                    sql.append(" and ware_nm like '%").append(ware.getWareNm()).append("%'");
                }
            }
            if (type != null && type == 1) {
                sql.append(" and  brand_id is null ");
            } else {
                sql.append(" and brand_id= " + brandId);
            }
            return this.daoTemplate.queryForPageByMySql(sql.toString(), page, rows, SysWare.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }

    }

    public Page dialogShopWareTypePage(SysWare ware, int page, int rows, String database, Integer[] waretypeId) {
        StringBuilder sql = new StringBuilder();
        sql.append("select * from " + database + ".sys_ware a left join " + database + ".sys_waretype b on a.waretype=b.waretype_id where 1=1 and a.status=1 ");
        try {
            if (null != ware) {
                if (!StrUtil.isNull(ware.getWareNm())) {
                    sql.append(" and a.ware_nm like '%").append(ware.getWareNm()).append("%'");
                }
            }
            if (waretypeId != null && waretypeId.length > 0) {
                if (waretypeId.length == 1 && !waretypeId[0].equals(0)) {
                    sql.append(" and waretype= " + waretypeId[0]);
                } else {
                    sql.append(" and waretype in (" + StringUtils.join(waretypeId, ",") + ")");
                }
            }
            if (!StrUtil.isNull(ware.getIsType())) {
                sql.append(" and b.is_type=").append(ware.getIsType());
            }
            return this.daoTemplate.queryForPageByMySql(sql.toString(), page, rows, SysWare.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public Page queryWareSpec(SysWare ware, int page, int rows, String database) {
        StringBuilder sql = new StringBuilder();
        sql.append("select * from " + database + ".sys_ware a left join " + database + ".sys_waretype b on a.waretype=b.waretype_id where 1=1 and a.status=1 ");
        try {
            if (ware != null) {
                if (!StrUtil.isNull(ware.getWareNm())) {
                    sql.append(" and a.ware_nm like '%").append(ware.getWareNm()).append("%'");
                }
                if (!StrUtil.isNull(ware.getStatus())) {
                    sql.append(" and a.status=").append(ware.getStatus());
                }
                if (!StrUtil.isNull(ware.getPackBarCode())) {
                    sql.append(" and (a.pack_bar_code like '%" + ware.getPackBarCode() + "%' or a.be_bar_code like '%" + ware.getPackBarCode() + "%')");
                }

                if (null != ware.getWaretype() && !ware.getWaretype().equals(0)) {
                    sql.append(" and instr(b.waretype_path,'-").append(ware.getWaretype()).append("-')>0");
                }
                if(null !=ware.getIsType()){
                    sql.append(" and b.is_type=").append(ware.getIsType());
                }
            }
            return this.daoTemplate.queryForPageByMySql(sql.toString(), page, rows, SysWare.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }

    }

    public Page wareAttributePage(int page, int rows, String database) {
        StringBuilder sql = new StringBuilder();
        sql.append("select a.*,b.ware_nm,b.attribute,b.ware_id from " + database + ".sys_warespec_group a left join " + database + ".sys_ware b on b.group_id=a.id where 1=1 and b.status=1 ");
        try {
            return this.daoTemplate.queryForPageByMySql(sql.toString(), page, rows, SysWareGroup.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public SysWareGroup queryAttributeById(Integer id, String database) {
        String sql = "select a.*,b.ware_nm,b.attribute from " + database + ".sys_warespec_group a left join " + database + ".sys_ware b on b.group_id=a.id where id=?";
        try {
            return this.daoTemplate.queryForObj(sql, SysWareGroup.class, id);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public int updateWareAttribute(String attribute, String database, Integer wareId) {
        String sql = "update " + database + ".sys_ware set attribute=? where ware_id=?";
        try {
            return this.daoTemplate.update(sql, attribute, wareId);

        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public int batchUpdateShopWareBrand(String ids, Integer brandId, String database) {
        String sql;
        if (brandId != null) {
            sql = " update " + database + ".sys_ware set brand_id=" + brandId + "  where ware_id in(" + ids + ")";
        } else {
            sql = " update " + database + ".sys_ware set brand_id=null" + " where ware_id in(" + ids + ")";
        }
        try {
            return this.daoTemplate.update(sql);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }


    public int batchUpdateShopWaretypeId(String ids, Integer typeId, String database) {
        String sql = "update " + database + ".sys_ware set waretype=" + typeId + "  where ware_id in(" + ids + ")";
        int k = this.daoTemplate.update(sql);
        String wareSql = "update "+database+".sys_ware a,"+database+".sys_waretype b set a.is_type=b.is_type,a.waretype_path = b.waretype_path,a.no_company=b.no_company  WHERE b.waretype_id=a.waretype and b.waretype_id="+typeId+" and a.ware_id in ("+ids+")";
        this.daoTemplate.update(wareSql);
        try {
            return k;
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public List<SysWare> queryList(SysWare ware, String database) {
        StringBuffer sb = new StringBuffer("select a.*,b.waretype_nm,b.waretype_path from " + database + ".sys_ware a  ");
        sb.append(" left join " + database + ".sys_waretype b on a.waretype=b.waretype_id where 1=1 ");
        if (ware != null) {
            if (!StrUtil.isNull(ware.getWareNm())) {
                sb.append(" and ware_nm like '%" + ware.getWareNm() + "%'");
            }
            if (null != ware.getWaretype() && ware.getWaretype() != 0) {
                sb.append(" and instr(b.waretype_path,'-").append(ware.getWaretype()).append("-')>0");
            }
        }
        sb.append(" and " + WareSqlUtil.getCompanyStockWareTypeAppendSql("b"));//过滤分类
        sb.append(" order by ware_id desc");
        return this.daoTemplate.queryForLists(sb.toString(), SysWare.class);
    }


    public List<SysWare> queryList(String ids, String database) {
        String pix = " a.ware_id,a.tran_amt, a.lower_limit, a.status, a.tc_amt, a.ware_dw, a.produce_date, a.ware_dj, a.provider_name, a.min_unit, a.waretype,"
                + " a.max_unit_code, a.pack_bar_code, a.ware_code, a.fbtime, a.ware_gg, a.be_bar_code, a.min_unit_code, a.hs_num, a.in_price,"
                + " a.quality_Days, a.ware_nm, a.max_unit, a.order_cd, a.is_cy,a.b_unit, a.s_unit, a.remark ";
        StringBuffer sb = new StringBuffer("select " + pix + " from " + database + ".sys_ware a  ");
        sb.append(" where 1=1 and a.ware_id in(" + ids + ")");
        return this.daoTemplate.queryForLists(sb.toString(), SysWare.class);
    }

    public List<SysWare> queryListByIds(String ids, String database) {
        StringBuffer sb = new StringBuffer("select * from " + database + ".sys_ware a  ");
        sb.append(" where 1=1 and a.ware_id in(" + ids + ")");
        return this.daoTemplate.queryForLists(sb.toString(), SysWare.class);
    }


    /**
     * 摘要：
     *
     * @说明：添加商品
     * @创建：作者:llp 创建时间：2016-3-22 @修改历史： [序号](llp 2016-3-22)<修改说明>
     */
    public int addWare(SysWare ware, String database) {
        try {
            ware.setHasSync(false);
            //----------加上基本数据防止使用时出现错误08-22
            ware.setMaxUnitCode("B");
            ware.setMinUnitCode("S");
            ware.setbUnit(1d);
            if (ware.getsUnit() == null)
                ware.setsUnit(1d);
            ware.setHsNum(ware.getsUnit());
            ware.setFbtime(DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd HH:mm:ss"));
            ware.setStatus("1");
            if (ware.getLsPrice() == null) ware.setLsPrice(0d);
            if (ware.getWareDj() == null) ware.setWareDj(0d);
            if (ware.getInPrice() == null) ware.setInPrice(0d);
            int id = this.daoTemplate.addByObject("" + database + ".sys_ware", ware);
            String wareSql = "update "+database+".sys_ware a,"+database+".sys_waretype b set a.is_type=b.is_type,a.waretype_path = b.waretype_path,a.no_company=b.no_company  WHERE b.waretype_id=a.waretype and b.waretype_id=? and a.ware_id=?";
            this.daoTemplate.update(wareSql,ware.getWaretype(),id);
            return id;
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 摘要：
     *
     * @说明：根据商品id获取商品信息
     * @创建：作者:llp 创建时间：2016-3-22 @修改历史： [序号](llp 2016-3-22)<修改说明>
     */
    public SysWare queryWareById(Integer wareId, String database) {
        String sql = "select a.*,b.waretype_nm  from " + database + ".sys_ware a left join " + database + ".sys_waretype b on a.waretype=b.waretype_id where ware_id=?";
        try {
            return this.daoTemplate.queryForObj(sql, SysWare.class, wareId);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }


    /**
     * 根据商品代码获取商品信息
     *
     * @param wareCode
     * @param database
     * @return
     */
    public SysWare queryWareByCode(String wareCode, String database) {

        String pix = " a.ware_id,a.tran_amt, a.lower_limit, a.status, a.tc_amt, a.ware_dw, a.produce_date, a.ware_dj, a.provider_name, a.min_unit, a.waretype,"
                + " a.max_unit_code, a.pack_bar_code, a.ware_code, a.fbtime, a.ware_gg, a.be_bar_code, a.min_unit_code, a.hs_num, a.in_price,"
                + " a.quality_Days, a.ware_nm, a.max_unit, a.order_cd, a.is_cy,a.b_unit, a.s_unit, a.remark";
        String sql = "select " + pix + ",b.waretype_nm from " + database + ".sys_ware a ";
        sql = sql + " left join " + database + ".sys_waretype b on a.waretype=b.waretype_id ";
        sql = sql + " where a.ware_code='" + wareCode + "'";
        try {
            List<SysWare> list = this.daoTemplate.queryForLists(sql, SysWare.class);
            if (list != null && list.size() > 0) {
                return list.get(0);
            }
            return null;
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }


    public Page queryWarePageByKeyWord(String keyWord, String database, Integer page, Integer limit) {
        StringBuilder sql = new StringBuilder();
        sql.append("select a.ware_id,a.ware_nm,a.ware_code,a.pack_bar_code,a.be_bar_code,a.min_unit_code,a.max_unit_code,t.waretype_path,a.sunit_front,a.hs_num,a.min_unit,a.ware_gg,a.ware_dw,a.ware_dj,a.in_price,a.py,a.status,sunit_price ");
        sql.append(" from " + database + ".sys_ware a  ");
        sql.append(" left join " + database + ".sys_waretype t on a.waretype=t.waretype_id ");
        sql.append(" where 1 = 1");
        sql.append(" and (a.status='1' or a.status='')");
        sql.append(" and (t.no_company =0 or t.no_company is null) ");
        if (!StrUtil.isNull(keyWord)) {
            if (isContainChinese(keyWord)) {
                String wareCode = keyWord.replaceAll(" ", "");
                for (int i = 0; i < wareCode.length(); i++) {
                    sql.append(" and a.ware_nm like '%" + wareCode.substring(i, i + 1) + "%'");
                }
            } else {
                sql.append(" and (a.ware_nm like '%" + keyWord + "%' or a.ware_code like '%" + keyWord + "%' or a.be_bar_code like '%" + keyWord + "%' or a.pack_bar_code like '%" + keyWord + "%' or a.py like '%" + keyWord + "%')");
            }
        }
        sql.append(" order by a.ware_id asc");
        try {
            return this.daoTemplate.queryForPageByMySql(sql.toString(), page, limit, SysWare.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }


    /**
     * 摘要：
     *
     * @说明：修改商品
     * @创建：作者:llp 创建时间：2016-3-22 @修改历史： [序号](llp 2016-3-22)<修改说明>
     */
    public int updateWare(SysWare ware, String database) {
        try {
            Map<String, Object> whereParam = new HashMap<String, Object>();
            ware.setHasSync(false);
            whereParam.put("ware_id", ware.getWareId());
            int k = this.daoTemplate.updateByObject("" + database + ".sys_ware", ware, whereParam, null);
            String wareSql = "update "+database+".sys_ware a,"+database+".sys_waretype b set a.is_type=b.is_type,a.waretype_path = b.waretype_path,a.no_company=b.no_company  WHERE b.waretype_id=a.waretype and b.waretype_id=? and a.ware_id=?";
            this.daoTemplate.update(wareSql,ware.getWaretype(),ware.getWareId());
            return k;
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }


    /**
     * 摘要：
     *
     * @说明：删除商品
     * @创建：作者:llp 创建时间：2016-3-22 @修改历史： [序号](llp 2016-3-22)<修改说明>
     */
    public int deleteWare(Integer wareId, String database) {
        String sql = " delete from " + database + ".sys_ware where ware_id=? ";
        try {
            return this.daoTemplate.update(sql, wareId);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public int updateBatchWare(String ids, Integer wareType, String database) {
          String sql = " update " + database + ".sys_ware set waretype=" + wareType + " where ware_id in (" + ids + ") ";
          int k = this.daoTemplate.update(sql);
        String wareSql = "update "+database+".sys_ware a,"+database+".sys_waretype b set a.is_type=b.is_type,a.waretype_path = b.waretype_path,a.no_company=b.no_company  WHERE b.waretype_id=a.waretype and b.waretype_id="+wareType+" and a.ware_id in("+ids+")";
        this.daoTemplate.update(wareSql);
        try {
            return k;
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public List<SysWare> queryWareLists(SysWare sysWare, String database) {
        StringBuilder sql = new StringBuilder();
        sql.append("select a.ware_id,a.ware_nm,a.ware_code,a.min_unit_code,a.max_unit_code,t.waretype_path,a.sunit_front,a.hs_num,a.min_unit,a.ware_gg,a.ware_dw,a.ware_dj,a.in_price,a.py,a.status,sunit_price ");
        sql.append(" from " + database + ".sys_ware a  ");
        sql.append(" left join " + database + ".sys_waretype t on a.waretype=t.waretype_id ");
        sql.append(" where (1 = 1)");
        sql.append(" and (a.status='1' or a.status='')");
        sql.append(" and (t.no_company =0 or t.no_company is null) ");
        sql.append(" order by a.ware_id asc");
        try {
            return this.daoTemplate.queryForLists(sql.toString(), SysWare.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 摘要：
     *
     * @return @修改历史： [序号](llp 2016-3-22)<修改说明>
     * @说明：判断商品名称唯一
     * @创建：作者:llp 创建时间：2016-3-22
     */
    public int queryWareNmCount(String wareNm, String database) {
        String sql = "select count(1) from " + database + ".sys_ware where ware_nm=?";
        try {
            return this.daoTemplate.queryForObject(sql, new Object[]{wareNm}, Integer.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public SysWare queryWareByName(String wareNm, String database) {
        String sql = "select a.*,t.waretype_path from " + database + ".sys_ware a left join " + database + ".sys_waretype t on a.waretype=t.waretype_id where a.ware_nm=?";
        List<SysWare> list = this.daoTemplate.queryForLists(sql, SysWare.class, wareNm);
        if (list.size() > 0) return list.get(0);
        return null;
    }


    /**
     * 摘要：
     *
     * @return @修改历史： [序号](llp 2016-3-22)<修改说明>
     * @说明：判断商品编码唯一
     * @创建：作者:llp 创建时间：2016-3-22
     */
    public int queryWareCodeCount(String wareCode, String database) {
        String sql = "select count(1) from " + database + ".sys_ware where ware_code=?";
        try {
            return this.daoTemplate.queryForObject(sql, new Object[]{wareCode}, Integer.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @说明：修改商品是否常用
     * @创建：作者:llp 创建时间：2016-4-19 @修改历史： [序号](llp 2016-4-19)<修改说明>
     */
    public int updateWareIsCy(String database, Integer id, Integer isCy) {
        String sql = "update " + database + ".sys_ware set is_cy=? where ware_id=?";
        try {
            return this.daoTemplate.update(sql, isCy, id);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public int updateWareSpecsunitFront(String database, Integer id, Integer sunitFront) {
        String sql = "update " + database + ".sys_ware set sunit_front=? where ware_id=?";
        try {
            return this.daoTemplate.update(sql, sunitFront, id);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public int updateWareStatus(String database, Integer id, String status) {
        String sql = "update " + database + ".sys_ware set status=? where ware_id=?";
        try {
            return this.daoTemplate.update(sql, status, id);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public int updateWareTranAmt(String database, Integer id, Double tranAmt) {
        String sql = "update " + database + ".sys_ware set tran_amt =? where ware_id=?";
        try {
            return this.daoTemplate.update(sql, tranAmt, id);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public int updateWareTcAmt(String database, Integer id, Double tcAmt) {
        String sql = "update " + database + ".sys_ware set tc_amt =? where ware_id=?";
        try {
            return this.daoTemplate.update(sql, tcAmt, id);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 摘要：
     *
     * @说明：删除所有商品
     * @创建：作者:llp 创建时间：2016-9-5 @修改历史： [序号](llp 2016-9-5)<修改说明>
     */
    public void deleteWareAll(String database) {
        String sql = "delete from " + database + ".sys_ware";
        try {
            this.daoTemplate.update(sql);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 摘要：
     *
     * @说明：删除所有商品分类
     * @创建：作者:llp 创建时间：2016-9-5 @修改历史： [序号](llp 2016-9-5)<修改说明>
     */
    public void deleteWareTpAll(String database) {
        String sql = "delete from " + database + ".sys_waretype";
        try {
            this.daoTemplate.update(sql);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public boolean isContainChinese(String str) {
        Pattern p = Pattern.compile("[\u4e00-\u9fa5]");
        Matcher m = p.matcher(str);
        if (m.find()) {
            return true;
        }
        return false;
    }

    public Integer queryWareByPackBarcode(String packBarcode, String database) {
        StringBuilder sql = new StringBuilder("select sw.ware_id from ");
        sql.append(database).append(".sys_ware sw where sw.pack_bar_code = ? limit 1");
        try {
            return this.daoTemplate.queryForObject(sql.toString(), new Object[]{packBarcode}, Integer.class);
        } catch (EmptyResultDataAccessException e) {
            return null;
        }
    }

    public Integer queryWareByBeBarcode(String beBarcode, String database) {
        StringBuilder sql = new StringBuilder("select sw.ware_id from ");
        sql.append(database).append(".sys_ware sw where sw.be_bar_code = ? limit 1");
        try {
            return this.daoTemplate.queryForObject(sql.toString(), new Object[]{beBarcode}, Integer.class);
        } catch (EmptyResultDataAccessException e) {
            return null;
        }
    }

    public Integer queryWareMaxId(String database) {
        StringBuilder sql = new StringBuilder("select max(sw.ware_id) ware_id from ");
        sql.append(database).append(".sys_ware sw ");
        Map<String, Object> map = this.daoTemplate.queryForMap(sql.toString());
        if (map != null) {
            Object wareId = map.get("ware_id");
            Integer maxId = Integer.valueOf(wareId + "");
            if (maxId < 1000) {
                maxId = 1000 + maxId;
            }
            maxId = maxId + 1;
            return Integer.valueOf(maxId + "");
        }
        return 1001;
    }

    public void updateSunitFront(List ids, Integer type, String datasource) {
        NamedParameterJdbcTemplate jdbcTemplate = new NamedParameterJdbcTemplate(this.daoTemplate);
        MapSqlParameterSource parameters = new MapSqlParameterSource();
        parameters.addValue("type", type);
        parameters.addValue("ids", ids);
        StringBuilder sql = new StringBuilder("update ").append(datasource).append(".sys_ware sw set sw.sunit_front = :type where sw.ware_id in (:ids)");
        jdbcTemplate.update(sql.toString(), parameters);
    }

    public void updateWareBarcode(Integer wareId, String barcode, String database) {
        String sql = "update " + database + ".sys_ware set be_bar_code = '" + barcode + "' where ware_id=" + wareId.toString();
        try {
            this.daoTemplate.update(sql);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public boolean checkExistBarcode(String beBarCode, String database) {
        String sql = "select ware_id from " + database + ".sys_ware where be_bar_code='" + beBarCode + "'";
        List<SysWare> list = this.daoTemplate.queryForLists(sql, SysWare.class);
        if (list.size() > 0) return true;
        return false;
    }

    public Integer saveImportProduct(String database, ProductData productData) {
        StringBuilder sql = new StringBuilder(128);
        sql.append("INSERT INTO ").append(database).append(".sys_ware (waretype,ware_code,ware_nm,py,ware_dw,ware_gg,b_Unit,min_unit,min_Ware_Gg,s_Unit,hs_num,status,is_cy,fbtime,max_unit_code,min_unit_code)")
                .append(" VALUES ");

        List<Object> values = Lists.newArrayList();
        values.add(productData.getTypeId());
        values.add(productData.getProductCode());
        values.add(productData.getProductName());
        values.add(productData.getProductPinYin());
        values.add(productData.getBigUnitName());
        values.add(productData.getBigUnitSpec());
        values.add(productData.getBigUnitScale());
        values.add(productData.getSmallUnitName());
        values.add(productData.getSmallUnitSpec());
        values.add(productData.getSmallUnitScale());
        values.add(productData.getConversionProportion());
        values.add("1");
        values.add(1);
        values.add(productData.getPublishTime());
        values.add("B");
        values.add("S");

        sql.append("(").append(StringUtils.repeat("?", ",", values.size())).append(");");

        Integer id = this.daoTemplate.saveEntityAndGetKey(sql.toString(), values.toArray(new Object[values.size()]));
        if (id == null) {
            throw new BizException("保存产品出错");
        }
        if(!StrUtil.isNull(productData.getTypeId())){
            String wareSql = "update "+database+".sys_ware a,"+database+".sys_waretype b set a.is_type=b.is_type,a.waretype_path = b.waretype_path,a.no_company=b.no_company  WHERE b.waretype_id=a.waretype and b.waretype_id=? ";
            this.daoTemplate.update(wareSql,productData.getTypeId());
        }
        return id;
    }

    public List<BaseProduct> queryAllBase(String database) {
        StringBuilder sql = new StringBuilder(64);
        sql.append("SELECT ware_id,ware_nm,ware_dw,ware_gg,min_unit,min_Ware_Gg,b_Unit,s_Unit,waretype FROM ").append(database).append(".sys_ware");

        return this.daoTemplate.query(sql.toString(), (rs, rowNum) -> {
            BaseProduct product = new BaseProduct();
            product.setId(rs.getInt("ware_id"));
            product.setName(rs.getString("ware_nm"));
            product.setWareDw(rs.getString("ware_dw"));
            product.setWareGg(rs.getString("ware_gg"));
            product.setMinUnit(rs.getString("min_unit"));
            product.setMinWareGg(rs.getString("min_Ware_Gg"));
            product.setbUnit(rs.getDouble("b_Unit"));
            product.setsUnit(rs.getDouble("s_Unit"));
            product.setTypeId(rs.getInt("waretype"));
            return product;
        });
    }

    /**
     * 检查商品是否使用
     *
     * @param database
     * @return
     */
    public int checkWareIsUse(String database, Integer wareId) {
        String sql = "select count(v.id) as num from (";
        sql += " select a.id from " + database + ".sys_bforder_detail a where a.ware_id=" + wareId + "";
        sql += " union all select a.id from " + database + ".stk_insub a where a.ware_id=" + wareId + " ";
        sql += " union all select a.id from " + database + ".stk_checksub a where a.ware_id=" + wareId + " ";
        sql += " ) v ";
        try {
            return this.daoTemplate.queryForObject(sql, Integer.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }


    public List<SysWare> queryStorageWareProductDateByWareId(Integer wareId, Integer stkId, String database) {

        StringBuffer sql = new StringBuffer();
        sql.append("select a.id as ssw_id,a.ware_id,a.product_date as produce_date  from " + database + ".stk_storage_ware a " );
        //        "left join " + database + ".sys_ware b on a.ware_id=b.ware_id " );
        sql.append(" inner join (select  k.ware_id as w_id,min(k.product_date) as product_date from " + database + ".stk_storage_ware k ");
        sql.append(" where 1=1 ");
        sql.append(" and k.product_date is not null and k.product_date !='' ");
        sql.append(" and k.qty>0 ");
        sql.append(" and k.ware_id =").append(wareId).append("");
        if (!StrUtil.isNull(stkId))
            sql.append(" and k.stk_id=").append(stkId);
        sql.append("  group by k.ware_id ) zz1 ");
        sql.append(" on a.ware_id = zz1.w_id ");
        sql.append(" and a.product_date = zz1.product_date ");
        sql.append(" where 1=1 ");
        if (!StrUtil.isNull(stkId))
            sql.append(" and a.stk_id=").append(stkId);
        sql.append(" and a.ware_id=").append(wareId);
        sql.append(" and a.qty>0 ");
        sql.append(" and a.product_date is not null and a.product_date !=''");
        try {
            return this.daoTemplate.queryForLists(sql.toString(), SysWare.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }


    /**
     * 查找启用状态公司产品的数据
     *
     * @param ware
     * @param page
     * @param rows
     * @param database
     * @return
     */
    public Page queryCompanyWare(SysWare ware, int page, int rows, String database) {
        StringBuffer sql = new StringBuffer(" select a.*,b.waretype_nm,b.waretype_path,c.name as brand_nm from " + database + ".sys_ware a");
        sql.append(" left join " + database + ".sys_waretype b on a.waretype=b.waretype_id ");
        sql.append(" left join " + database + ".sys_brand c on a.brand_id=c.id ");
        sql.append("  where 1=1 ");
        sql.append(" and ").append(WareSqlUtil.getWareWhere("a"));
        sql.append(" and ").append(WareSqlUtil.getCompanyWareTypeAppendSql("b"));
//        sql.append(" and (a.status='1' or a.status='') ");
//        sql.append(" and (b.no_company =0 or b.no_company is null) ");
        if (null != ware) {
            if (!StrUtil.isNull(ware.getWareNm())) {
                if (isContainChinese(ware.getWareNm())) {
                    ware.setWareNm(ware.getWareNm().replaceAll(" ", ""));
                    for (int i = 0; i < ware.getWareNm().length(); i++) {
                        sql.append(" and a.ware_nm like '%" + ware.getWareNm().substring(i, i + 1) + "%'");
                    }
                } else {
                    sql.append(" and (a.ware_nm like '%" + ware.getWareNm() + "%' or a.ware_code like '%" + ware.getWareNm() + "%' or a.be_bar_code like '%" + ware.getWareNm() + "%' or a.pack_bar_code like '%" + ware.getWareNm() + "%' or a.py like '%" + ware.getWareNm() + "%')");
                }
            }
            if (!StrUtil.isNull(ware.getStatus())) {
                sql.append(" and a.status=").append(ware.getStatus());
            }
            if (!StrUtil.isNull(ware.getBeBarCode())) {
                sql.append(" and a.be_bar_code like concat('%', \'").append(ware.getBeBarCode()).append("\' ,'%')");
            }
            if (!StrUtil.isNull(ware.getPackBarCode())) {
                sql.append(" and a.pack_bar_code like concat('%', \'").append(ware.getPackBarCode()).append("\' ,'%')");
            }
            if (!StrUtil.isNull(ware.getIsType())) {
                sql.append(" and b.is_type=").append(ware.getIsType());
            }
        }
        if (null != ware.getWaretype() && ware.getWaretype() != 0) {
            sql.append(" and instr(b.waretype_path,'-").append(ware.getWaretype()).append("-')>0");
        }
        sql.append(" order by a.ware_id asc ");
        try {
            return this.daoTemplate.queryForPageByMySql(sql.toString(), page, rows, SysWare.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public List<SysWare> queryCompanyStockWareList(SysWare ware, String database) {
        StringBuffer sql = new StringBuffer(" select a.*,b.waretype_nm,b.waretype_path,c.name as brand_nm from " + database + ".sys_ware a");
        sql.append(" left join " + database + ".sys_waretype b on a.waretype=b.waretype_id ");
        sql.append(" left join " + database + ".sys_brand c on a.brand_id=c.id ");
        sql.append("  where 1=1 ");
        sql.append(" and ").append(WareSqlUtil.getWareWhere("a"));
        sql.append(" and ").append(WareSqlUtil.getCompanyWareTypeAppendSql("b"));
//        sql.append(" and (a.status='1' or a.status='') ");
//        sql.append(" and (b.no_company =0 or b.no_company is null) ");
        sql.append(" and b.is_type=0 ");
        if (null != ware) {
            if (!StrUtil.isNull(ware.getWareNm())) {
                if (isContainChinese(ware.getWareNm())) {
                    ware.setWareNm(ware.getWareNm().replaceAll(" ", ""));
                    for (int i = 0; i < ware.getWareNm().length(); i++) {
                        sql.append(" and a.ware_nm like '%" + ware.getWareNm().substring(i, i + 1) + "%'");
                    }
                } else {
                    sql.append(" and (a.ware_nm like '%" + ware.getWareNm() + "%' or a.ware_code like '%" + ware.getWareNm() + "%' or a.be_bar_code like '%" + ware.getWareNm() + "%' or a.pack_bar_code like '%" + ware.getWareNm() + "%' or a.py like '%" + ware.getWareNm() + "%')");
                }
            }
            if (!StrUtil.isNull(ware.getStatus())) {
                sql.append(" and a.status=").append(ware.getStatus());
            }
            if (!StrUtil.isNull(ware.getBeBarCode())) {
                sql.append(" and a.be_bar_code like concat('%', \'").append(ware.getBeBarCode()).append("\' ,'%')");
            }
            if (!StrUtil.isNull(ware.getPackBarCode())) {
                sql.append(" and a.pack_bar_code like concat('%', \'").append(ware.getPackBarCode()).append("\' ,'%')");
            }
            if (null != ware.getWaretype() && ware.getWaretype() != 0) {
                sql.append(" and instr(b.waretype_path,'-").append(ware.getWaretype()).append("-')>0");
            }
        }
        sql.append(" order by a.ware_id asc ");
        try {
            return this.daoTemplate.queryForLists(sql.toString(), SysWare.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }


    /**
     * 修改导入数据
     *
     * @param database
     * @param id
     * @param productData
     * @return
     */
    public Integer updateImportProduct(String database, Integer id, ProductData productData) {
        StringBuilder sql = new StringBuilder(128);
        sql.append("update ").append(database).append(".sys_ware set");
        if (productData.getTypeId() != null)
            sql.append(" waretype=" + productData.getTypeId() + ",");
        if (!StrUtil.isNull(productData.getBigUnitName()))
            sql.append(" ware_dw='" + productData.getBigUnitName() + "',");
        if (!StrUtil.isNull(productData.getBigUnitSpec()))
            sql.append(" ware_gg='" + productData.getBigUnitSpec() + "',");

        if (productData.getBigUnitScale() != null)
            sql.append(" b_Unit=" + productData.getBigUnitScale() + ",");
        if (!StrUtil.isNull(productData.getSmallUnitName()))
            sql.append(" min_unit='" + productData.getSmallUnitName() + "',");
        if (!StrUtil.isNull(productData.getSmallUnitSpec()))
            sql.append(" min_Ware_Gg='" + productData.getSmallUnitSpec() + "',");
        if (productData.getSmallUnitScale() != null)
            sql.append(" s_Unit=" + productData.getSmallUnitScale() + ",");
        if (productData.getConversionProportion() != null)
            sql.append(" hs_num=" + productData.getConversionProportion());

        String ss = sql.toString();

        //如果没有一个数据修改时返回空
        if (ss.endsWith("sys_ware set"))
            return 0;
        if (ss.endsWith(","))
            ss = sql.toString().substring(0, sql.length() - 1);
        ss += " where ware_id=?";

        if(!StrUtil.isNull(productData.getTypeId())){
            String wareSql = "update "+database+".sys_ware a,"+database+".sys_waretype b set a.is_type=b.is_type,a.waretype_path = b.waretype_path,a.no_company=b.no_company  WHERE b.waretype_id=a.waretype and b.waretype_id=? ";
            this.daoTemplate.update(wareSql,productData.getTypeId());
        }

        return this.daoTemplate.update(ss, id);
    }

    public Page queryNoneGroupWare(SysWare sysWare, int page, int rows, String database) {
        StringBuilder sql = new StringBuilder();
        sql.append("select * from " + database + ".sys_ware  where 1=1 and status=1 ");
        sql.append(" and group_id is null");
        try {
            if (null != sysWare) {
                if (!StrUtil.isNull(sysWare.getWareNm())) {
                    sql.append(" and ware_nm like '%").append(sysWare.getWareNm()).append("%'");

                }
            }
            return this.daoTemplate.queryForPageByMySql(sql.toString(), page, rows, SysWare.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }

    }

    public Page queryWareByGroupId(SysWare sysWare, int groupId, int page, int rows, String database) {
        StringBuffer sql = new StringBuffer();
        sql.append("select * from " + database + ".sys_ware  where 1=1 and status=1 ");
        sql.append(" and group_id=" + groupId);
        try {
            if (null != sysWare) {
                if (!StrUtil.isNull(sysWare.getWareNm())) {
                    sql.append(" and ware_nm like '%").append(sysWare.getWareNm()).append("%'");

                }
            }
            return this.daoTemplate.queryForPageByMySql(sql.toString(), page, rows, SysWare.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }

    }

    public int batchUAddWareGroup(String ids, Integer id, String database) {
        String sql = " update " + database + ".sys_ware set group_id=" + id + " where ware_id in (" + ids + ")";

        try {
            return this.daoTemplate.update(sql);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public int batchRemoveCustomerType(String ids, String database) {
        String sql = " update " + database + ".sys_ware set group_id =null where ware_id in (" + ids + ")";

        try {
            return this.daoTemplate.update(sql);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

}
