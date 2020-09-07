package com.qweib.cloud.repository;

import com.google.common.collect.Lists;
import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.dao.JdbcDaoTemplatePlud;
import com.qweib.cloud.core.domain.*;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.List;

/**
 * 说明：客户关系属性
 *
 * @创建：作者:llp 创建时间：2016-2-16
 * @修改历史： [序号](llp 2016 - 2 - 16)<修改说明>
 */
@Repository
public class SysKhgxsxDao {
    @Resource(name = "daoTemplate")
    private JdbcDaoTemplate daoTemplate;
    @Resource(name = "pdaoTemplate")
    private JdbcDaoTemplatePlud pdaoTemplate;

//    /**
//     * 说明：分页查询拜访频次
//     *
//     * @创建：作者:llp 创建时间：2016-2-16
//     * @修改历史： [序号](llp 2016 - 2 - 16)<修改说明>
//     */
//    public Page querySysBfpc(SysBfpc bfpc, String datasource, Integer page, Integer limit) {
//        StringBuilder sql = new StringBuilder();
//        sql.append(" select * from " + datasource + ".sys_bfpc where 1=1 ");
//        if (null != bfpc) {
//            if (!StrUtil.isNull(bfpc.getPcNm())) {
//                sql.append(" and pc_nm like '%" + bfpc.getPcNm() + "%' ");
//            }
//        }
//        sql.append(" order by id asc ");
//        try {
//            return this.daoTemplate.queryForPageByMySql(sql.toString(), page, limit, SysBfpc.class);
//        } catch (Exception e) {
//            throw new DaoException(e);
//        }
//    }

    private static final List<SysBfpc> BFPCS = Lists.newArrayListWithCapacity(5);

    static {
        BFPCS.add(makeBfpc(1, "01", "1周1访"));
        BFPCS.add(makeBfpc(2, "02", "1周2访"));
        BFPCS.add(makeBfpc(3, "03", "2周1访"));
        BFPCS.add(makeBfpc(4, "04", "4周1访"));
        BFPCS.add(makeBfpc(5, "05", "10天1访"));
    }

    private static SysBfpc makeBfpc(Integer id, String coding, String name) {
        SysBfpc bfpc = new SysBfpc();
        bfpc.setId(id);
        bfpc.setCoding(coding);
        bfpc.setPcNm(name);

        return bfpc;
    }

    /**
     * 说明：列表查询拜访频次
     *
     * @创建：作者:llp 创建时间：2016-2-17
     * @修改历史： [序号](llp 2016 - 2 - 17)<修改说明>
     */
    public List<SysBfpc> queryBfpcls() {
        return BFPCS;
//        String sql = "select * from sys_bfpc order by id";
//        try {
//            return this.pdaoTemplate.queryForLists(sql, SysBfpc.class);
//        } catch (Exception e) {
//            throw new DaoException(e);
//        }
    }
//	/**
//	 *说明：分页查询供货类型
//	 *@创建：作者:llp		创建时间：2016-2-16
//	 *@修改历史：
//	 *		[序号](llp	2016-2-16)<修改说明>
//	 */
//	public Page querySysGhtype(SysGhtype ghtype, String datasource, Integer page, Integer limit){
//		StringBuilder sql = new StringBuilder();
//		sql.append(" select * from "+datasource+".sys_ghtype where 1=1 ");
//		if(null!=ghtype){
//			if(!StrUtil.isNull(ghtype.getGhtpNm())){
//				sql.append(" and ghtp_nm like '%"+ghtype.getGhtpNm()+"%' ");
//			}
//		}
//		sql.append(" order by id asc ");
//		try {
//			return this.daoTemplate.queryForPageByMySql(sql.toString(), page, limit, SysGhtype.class);
//		} catch (Exception e) {
//			throw new DaoException(e);
//		}
//	}

    private static final List<SysGhtype> GH_TYPES = Lists.newArrayListWithCapacity(2);

    static {
		GH_TYPES.add(makeGhType(1, "01", "由本公司直接供货"));
		GH_TYPES.add(makeGhType(2, "02", "由经销商供货"));
    }

    private static SysGhtype makeGhType(Integer id, String coding, String name) {
        SysGhtype ghType = new SysGhtype();
        ghType.setId(id);
        ghType.setCoding(coding);
        ghType.setGhtpNm(name);

        return ghType;
    }

    /**
     * 说明：列表查询供货类型
     *
     * @创建：作者:llp 创建时间：2016-2-17
     * @修改历史： [序号](llp 2016 - 2 - 17)<修改说明>
     */
    public List<SysGhtype> queryGhtypels() {
//		String sql = "select * from sys_ghtype order by id";
//		try {
//			return this.pdaoTemplate.queryForLists(sql, SysGhtype.class);
//		} catch (Exception e) {
//			throw new DaoException(e);
//		}

        return GH_TYPES;
    }

    /**
     * 说明：分页查询经销商分类
     *
     * @创建：作者:llp 创建时间：2016-2-16
     * @修改历史： [序号](llp 2016 - 2 - 16)<修改说明>
     */
    public Page querySysJxsfl(SysJxsfl jxsfl, String datasource, Integer page, Integer limit) {
        StringBuilder sql = new StringBuilder();
        sql.append(" select * from " + datasource + ".sys_jxsfl where 1=1 ");
        if (null != jxsfl) {
            if (!StrUtil.isNull(jxsfl.getFlNm())) {
                sql.append(" and fl_nm like '%" + jxsfl.getFlNm() + "%' ");
            }
        }
        sql.append(" order by id asc ");
        try {
            return this.daoTemplate.queryForPageByMySql(sql.toString(), page, limit, SysJxsfl.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：列表查询经销商分类
     *
     * @创建：作者:llp 创建时间：2016-2-17
     * @修改历史： [序号](llp 2016 - 2 - 17)<修改说明>
     */
    public List<SysJxsfl> queryJxsflls(String datasource) {
        String sql = "select * from " + datasource + ".sys_jxsfl order by id";
        try {
            return this.daoTemplate.queryForLists(sql, SysJxsfl.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：分页查询经销商级别
     *
     * @创建：作者:llp 创建时间：2016-2-16
     * @修改历史： [序号](llp 2016 - 2 - 16)<修改说明>
     */
    public Page querySysJxsjb(SysJxsjb jxsjb, String datasource, Integer page, Integer limit) {
        StringBuilder sql = new StringBuilder();
        sql.append(" select * from " + datasource + ".sys_jxsjb where 1=1 ");
        if (null != jxsjb) {
            if (!StrUtil.isNull(jxsjb.getJbNm())) {
                sql.append(" and jb_nm like '%" + jxsjb.getJbNm() + "%' ");
            }
        }
        sql.append(" order by id asc ");
        try {
            return this.daoTemplate.queryForPageByMySql(sql.toString(), page, limit, SysJxsjb.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：列表查询经销商级别
     *
     * @创建：作者:llp 创建时间：2016-2-17
     * @修改历史： [序号](llp 2016 - 2 - 17)<修改说明>
     */
    public List<SysJxsjb> queryJxsjbls(String datasource) {
        String sql = "select * from " + datasource + ".sys_jxsjb order by id";
        try {
            return this.daoTemplate.queryForLists(sql, SysJxsjb.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：分页查询经销商状态
     *
     * @创建：作者:llp 创建时间：2016-2-16
     * @修改历史： [序号](llp 2016 - 2 - 16)<修改说明>
     */
    public Page querySysJxszt(SysJxszt jxszt, String datasource, Integer page, Integer limit) {
        StringBuilder sql = new StringBuilder();
        sql.append(" select * from " + datasource + ".sys_jxszt where 1=1 ");
        if (null != jxszt) {
            if (!StrUtil.isNull(jxszt.getZtNm())) {
                sql.append(" and zt_nm like '%" + jxszt.getZtNm() + "%' ");
            }
        }
        sql.append(" order by id asc ");
        try {
            return this.daoTemplate.queryForPageByMySql(sql.toString(), page, limit, SysJxszt.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：列表查询经销商状态
     *
     * @创建：作者:llp 创建时间：2016-2-17
     * @修改历史： [序号](llp 2016 - 2 - 17)<修改说明>
     */
    public List<SysJxszt> queryJxsztls(String datasource) {
        String sql = "select * from " + datasource + ".sys_jxszt order by id";
        try {
            return this.daoTemplate.queryForLists(sql, SysJxszt.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：分页查询客户等级
     *
     * @创建：作者:llp 创建时间：2016-2-16
     * @修改历史： [序号](llp 2016 - 2 - 16)<修改说明>
     */
    public Page querySysKhlevel(SysKhlevel khlevel, String datasource, Integer page, Integer limit) {
        StringBuilder sql = new StringBuilder();
        sql.append(" select * from " + datasource + ".sys_khlevel where 1=1 ");
        if (null != khlevel) {
            if (!StrUtil.isNull(khlevel.getKhdjNm())) {
                sql.append(" and khdj_nm like '%" + khlevel.getKhdjNm() + "%' ");
            }
        }
        sql.append(" order by id asc ");
        try {
            return this.daoTemplate.queryForPageByMySql(sql.toString(), page, limit, SysKhlevel.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：列表查询客户等级
     *
     * @创建：作者:llp 创建时间：2016-2-17
     * @修改历史： [序号](llp 2016 - 2 - 17)<修改说明>
     */
    public List<SysKhlevel> queryKhlevells(Integer qdId, String datasource) {
        StringBuilder sql = new StringBuilder("select * from " + datasource + ".sys_khlevel where 1=1");
        if (!StrUtil.isNull(qdId)) {
            sql.append(" and qd_id=" + qdId + "");
        }
        sql.append(" order by id asc");
        try {
            return this.pdaoTemplate.queryForLists(sql.toString(), SysKhlevel.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：分页查询渠道类型
     *
     * @创建：作者:llp 创建时间：2016-2-16
     * @修改历史： [序号](llp 2016 - 2 - 16)<修改说明>
     */
    public Page querySysQdtype(SysQdtype qdtype, Integer page, Integer limit) {
        StringBuilder sql = new StringBuilder();
        sql.append(" select * from sys_qdtype where 1=1 ");
        if (null != qdtype) {
            if (!StrUtil.isNull(qdtype.getQdtpNm())) {
                sql.append(" and qdtp_nm like '%" + qdtype.getQdtpNm() + "%' ");
            }
        }
        sql.append(" order by id asc ");
        try {
            return this.pdaoTemplate.queryForPageByMySql(sql.toString(), page, limit, SysQdtype.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：列表查询渠道类型
     *
     * @创建：作者:llp 创建时间：2016-2-17
     * @修改历史： [序号](llp 2016 - 2 - 17)<修改说明>
     */
    public List<SysQdtype> queryQdtypls(String datasource) {
        String sql = "select * from " + datasource + ".sys_qdtype order by id";
        try {
            return this.daoTemplate.queryForLists(sql, SysQdtype.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：根据渠道名称获取信息
     *
     * @创建：作者:llp 创建时间：2016-4-13
     * @修改历史： [序号](llp 2016 - 4 - 13)<修改说明>
     */
    public SysQdtype queryQdtypone(String qdtpNm, String datasource) {
        String sql = "select * from " + datasource + ".sys_qdtype where qdtp_nm='" + qdtpNm + "'";
        try {
            return this.daoTemplate.queryForObj(sql, SysQdtype.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：分页查询市场类型
     *
     * @创建：作者:llp 创建时间：2016-2-16
     * @修改历史： [序号](llp 2016 - 2 - 16)<修改说明>
     */
    public Page querySysSctype(SysSctype sctype, String datasource, Integer page, Integer limit) {
        StringBuilder sql = new StringBuilder();
        sql.append(" select * from " + datasource + ".sys_sctype where 1=1 ");
        if (null != sctype) {
            if (!StrUtil.isNull(sctype.getSctpNm())) {
                sql.append(" and sctp_nm like '%" + sctype.getSctpNm() + "%' ");
            }
        }
        sql.append(" order by id asc ");
        try {
            return this.daoTemplate.queryForPageByMySql(sql.toString(), page, limit, SysSctype.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    private static final List<SysSctype> SYS_SCTYPES = Lists.newArrayListWithCapacity(2);
    static {
        SYS_SCTYPES.add(makeSctype(1, "核心市场", "01"));
        SYS_SCTYPES.add(makeSctype(2, "外围市场", "02"));
    }

    private static SysSctype makeSctype(Integer id, String name, String coding) {
        SysSctype sctype = new SysSctype();

        sctype.setId(id);
        sctype.setSctpNm(name);
        sctype.setCoding(coding);

        return sctype;
    }

    /**
     * 说明：列表查询市场类型
     *
     * @创建：作者:llp 创建时间：2016-2-17
     * @修改历史： [序号](llp 2016 - 2 - 17)<修改说明>
     */
    public List<SysSctype> querySctypels() {
//        String sql = "select * from sys_sctype order by id";
//        try {
//            return this.pdaoTemplate.queryForLists(sql, SysSctype.class);
//        } catch (Exception e) {
//            throw new DaoException(e);
//        }

        return SYS_SCTYPES;
    }

    /**
     * 说明：分页查询销售阶段
     *
     * @创建：作者:llp 创建时间：2016-2-16
     * @修改历史： [序号](llp 2016 - 2 - 16)<修改说明>
     */
    public Page querySysXsphase(SysXsphase xsphase, String datasource, Integer page, Integer limit) {
        StringBuilder sql = new StringBuilder();
        sql.append(" select * from " + datasource + ".sys_xsphase where 1=1 ");
        if (null != xsphase) {
            if (!StrUtil.isNull(xsphase.getPhaseNm())) {
                sql.append(" and phase_nm like '%" + xsphase.getPhaseNm() + "%' ");
            }
        }
        sql.append(" order by id asc ");
        try {
            return this.daoTemplate.queryForPageByMySql(sql.toString(), page, limit, SysXsphase.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：列表查询销售阶段
     *
     * @创建：作者:llp 创建时间：2016-2-17
     * @修改历史： [序号](llp 2016 - 2 - 17)<修改说明>
     */
    public List<SysXsphase> queryXsphasels() {
        SysXsphase xsphase = new SysXsphase();
        xsphase.setId(1);
        xsphase.setCoding("Follow");
        xsphase.setPhaseNm("跟进拜访");
        SysXsphase xsphase1 = new SysXsphase();
        xsphase1.setId(2);
        xsphase1.setCoding("Intention");
        xsphase1.setPhaseNm("意向签约");
        SysXsphase xsphase2 = new SysXsphase();
        xsphase2.setId(3);
        xsphase2.setCoding("Loss");
        xsphase2.setPhaseNm("流失");
        SysXsphase xsphase3 = new SysXsphase();
        xsphase3.setId(4);
        xsphase3.setCoding("Open");
        xsphase3.setPhaseNm("新增开立");
        SysXsphase xsphase4 = new SysXsphase();
        xsphase4.setId(5);
        xsphase4.setCoding("Order");
        xsphase4.setPhaseNm("订货下单");
        return Lists.newArrayList(xsphase,xsphase1, xsphase2,xsphase3,xsphase4);
    }

    /**
     * 说明：列表查询合作方式
     *
     * @创建：作者:llp 创建时间：2016-4-13
     * @修改历史： [序号](llp 2016 - 4 - 13)<修改说明>
     */
    public List<SysHzfs> queryHzfsls() {
        String sql = "select * from sys_hzfs order by id";
        try {
            return this.pdaoTemplate.queryForLists(sql, SysHzfs.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：列表查询销售类型
     *
     * @创建：作者:llp 创建时间：2016-4-13
     * @修改历史： [序号](llp 2016 - 4 - 13)<修改说明>
     */
    public List<SysXstype> queryXstypels() {
        String sql = "select * from sys_xstype order by id";
        try {
            return this.pdaoTemplate.queryForLists(sql, SysXstype.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }
}
