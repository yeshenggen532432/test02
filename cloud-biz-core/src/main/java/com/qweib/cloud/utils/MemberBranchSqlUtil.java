package com.qweib.cloud.utils;

import java.util.Map;

/**
 * 员工部门--dataTp权限（表中含含member_id,  branch_id）
 */
public class MemberBranchSqlUtil {

    /**
     * 区分:字段mem_id
     * a:主表
     * m:表sys_mem
     */
    public static String getMemberBranchAppendSql(String mids, Map<String, Object> map) {
        StringBuffer sb = new StringBuffer();
        if (!StrUtil.isNull(mids)) {
            sb.append(" and a.mem_id in (" + mids + ")");
        } else {
            if (!StrUtil.isNull(map.get("allDepts"))) {//要查询的部门和可见部门
                if (!StrUtil.isNull(map.get("mId"))) {//个人和可见部门结合查询
                    sb.append(" and (m.branch_id in (" + map.get("allDepts") + ") ");
                    sb.append(" or a.mem_id=" + map.get("mId") + ")");
                } else {
                    sb.append(" and m.branch_id in (" + map.get("allDepts") + ") ");
                }
            } else if (!StrUtil.isNull(map.get("mId"))) {//个人
                sb.append(" and a.mem_id=" + map.get("mId"));
            }
            if (!StrUtil.isNull(map.get("invisibleDepts"))) {//不可见部门
                sb.append(" and m.branch_id not in (" + map.get("invisibleDepts") + ") ");
            }
        }
        return sb.toString();
    }

    /**
     * 区分:字段mid
     * a:主表
     * m:表sys_mem
     */
    public static String getMemberBranchAppendSql2(String mids, Map<String, Object> map) {
        StringBuffer sb = new StringBuffer();
        if (!StrUtil.isNull(mids)) {
            sb.append(" and a.mid in (" + mids + ")");
        } else {
            if (!StrUtil.isNull(map.get("allDepts"))) {//要查询的部门和可见部门
                if (!StrUtil.isNull(map.get("mId"))) {//个人和可见部门结合查询
                    sb.append(" and (m.branch_id in (" + map.get("allDepts") + ") ");
                    sb.append(" or a.mid=" + map.get("mId") + ")");
                } else {
                    sb.append(" and m.branch_id in (" + map.get("allDepts") + ") ");
                }
            } else if (!StrUtil.isNull(map.get("mId"))) {//个人
                sb.append(" and a.mid=" + map.get("mId"));
            }
            if (!StrUtil.isNull(map.get("invisibleDepts"))) {//不可见部门
                sb.append(" and m.branch_id not in (" + map.get("invisibleDepts") + ") ");
            }
        }
        return sb.toString();
    }

    /**
     * 区分:字段
     * a:主表
     * m:表sys_mem
     * fieldName:主表的用户id的字段名（默认mid）
     */
    public static String getMemberBranchAppendSql(String mids, Map<String, Object> map, String fieldName) {
        if (StrUtil.isNull(fieldName)) {
            fieldName = "mid";
        }
        StringBuffer sb = new StringBuffer();
        if (!StrUtil.isNull(mids)) {
            sb.append(" and a." + fieldName + " in (" + mids + ")");
        } else {
            if (!StrUtil.isNull(map.get("allDepts"))) {//要查询的部门和可见部门
                if (!StrUtil.isNull(map.get("mId"))) {//个人和可见部门结合查询
                    sb.append(" and (m.branch_id in (" + map.get("allDepts") + ") ");
                    sb.append(" or a." + fieldName + "=" + map.get("mId") + ")");
                } else {
                    sb.append(" and m.branch_id in (" + map.get("allDepts") + ") ");
                }
            } else if (!StrUtil.isNull(map.get("mId"))) {//个人
                sb.append(" and a." + fieldName + "=" + map.get("mId"));
            }
            if (!StrUtil.isNull(map.get("invisibleDepts"))) {//不可见部门
                sb.append(" and m.branch_id not in (" + map.get("invisibleDepts") + ") ");
            }
        }
        return sb.toString();
    }


}
