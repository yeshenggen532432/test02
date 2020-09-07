package com.qweib.cloud.utils;

/**
 * 主要部门相关的dataTp
 */
public class BranchMemberSqlUtil {

    public static String getBranchMemberSql( String database, String tableAlias, String visibleBranch, String invisibleBranch, int mid, String mids) {
        StringBuilder sql = new StringBuilder();
        sql.append(" left join " + database + ".sys_depart d on " + tableAlias + ".branch_id = d.branch_id");
        sql.append(" where 1 = 1");
        if (!StrUtil.isNull(visibleBranch)) {//要查询的部门和可见部门
            sql.append(" and " + tableAlias + ".branch_id in (" + visibleBranch + ") ");
        }
        if (!StrUtil.isNull(invisibleBranch)) {//不可见部门
            sql.append(" and " + tableAlias + ".branch_id not in (" + invisibleBranch + ") ");
        }
        sql.append(" and " + tableAlias + ".mid != " + mid + " ");
        if (!StrUtil.isNull(mids)) {
            sql.append(" and " + tableAlias + ".mid in (" + mids + ") ");
        }
        return sql.toString();
    }

}
