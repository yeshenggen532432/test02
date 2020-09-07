package com.qweib.cloud.utils;

/**
 * 商品底层数据过滤
 */
public class WareSqlUtil {


    /**
     * 公司商品（库存商品）
     * @param alias
     * @param database
     * @return
     */
    public static String getCompanyStockWareAppendSql(String alias, String database) {
        return getCompanyStockWareAppendSql(alias, null, database);
    }

    public static String getCompanyStockWareAppendSqlAddAnd(String alias, String database) {
        return getCompanyStockWareAppendSql(alias, "and", database);
    }

    /**
     * 商城商品限制专用----增加过滤shop_qy（值1和2）:只请求商城选中的商品分类zzx
     *
     * @param alias
     * @param database
     * @return
     */
    public static String getShopCompanyStockWareAppendSqlAddAnd(String alias, String database, String... typeCondition) {
        StringBuffer str = new StringBuffer();
        if (typeCondition != null && typeCondition.length > 0) {
            for (String s : typeCondition) {
                str.append(" " + s + " ");
            }
        }
        return getCompanyStockWareAppendSql(alias, "and", database, "and waretype.shop_qy in(1,2) " + str);
    }


    /**
     * 查找库存类公司商品(启用的商品)
     *
     * @param alias  商品表的别称
     * @param prefix 前缀
     * @return
     */
    private static String getCompanyStockWareAppendSql(String alias, String prefix, String database, String... typeCondition) {
        StringBuffer sb = new StringBuffer();
        if (prefix != null && prefix.length() > 0) {
            sb.append(" " + prefix);
        }
        sb.append(getWareWhere(alias)); //sb.append(" (" + alias + ".status='1' or " + alias + ".status='') ");
        sb.append(" and " + alias + ".waretype in (select waretype.waretype_id from " + database + ".sys_waretype waretype where " + getCompanyStockWareTypeAppendSql("waretype", typeCondition) + ") ");//(waretype.no_company = 0 or waretype.no_company is null) and waretype.is_type=0

        return sb.toString();
    }

    /**
     * 商城限制SQL
     *
     * @param alias
     * @return
     */
    public static String getWareWhere(String alias) {
        return " (" + alias + ".status='1' or " + alias + ".status='') ";
    }

    /**
     * 获取库存类公司商品类别
     *
     * @param alias 商品类别表的别称
     * @return
     */
    public static String getCompanyStockWareTypeAppendSql(String alias, String... typeCondition) {
        StringBuffer sb = new StringBuffer();
        sb.append(" (" + alias + ".no_company = 0 or " + alias + ".no_company is null) ");
        sb.append(" and " + alias + ".is_type=0 ");
        if (typeCondition != null && typeCondition.length > 0) {
            for (String str : typeCondition) {
                sb.append(" " + str + " ");
            }
        }
        return sb.toString();
    }


    /**
     * 获取公司公司商品
     * @param alias 商品表的别称
     * @return
     */
    public static String getCompanyWareAppendSql(String alias, String database) {
        return getCompanyWareAppendSql(alias, null, database);
    }

    private static String getCompanyWareAppendSql(String alias, String prefix, String database, String... typeCondition) {
        StringBuffer sb = new StringBuffer();
        if (prefix != null && prefix.length() > 0) {
            sb.append(" " + prefix);
        }
        sb.append(getWareWhere(alias)); //sb.append(" (" + alias + ".status='1' or " + alias + ".status='') ");
        sb.append(" and " + alias + ".waretype in (select waretype.waretype_id from " + database + ".sys_waretype waretype where " + getCompanyWareTypeAppendSql("waretype", typeCondition) + ") ");//(waretype.no_company = 0 or waretype.no_company is null) and waretype.is_type=0

        return sb.toString();
    }

    /**
     * 获取公司公司商品类别
     * @param alias 商品类别表的别称
     * @return
     */
    public static String getCompanyWareTypeAppendSql(String alias, String... typeCondition) {
        StringBuffer sb = new StringBuffer();
        sb.append(" (" + alias + ".no_company = 0 or " + alias + ".no_company is null ) ");
        if (typeCondition != null && typeCondition.length > 0) {
            for (String str : typeCondition) {
                sb.append(" " + str + " ");
            }
        }
        return sb.toString();
    }


    /**
     * 获取库存商品（包括非公司的）
     */
    public static String getWareStockAppendSql(String alias, String database) {
        StringBuffer sb = new StringBuffer();
        sb.append(getWareWhere(alias));//启用
        sb.append(" and " + alias + ".waretype in (select waretype.waretype_id from " + database + ".sys_waretype waretype ");
        sb.append(" where");
        sb.append(" waretype.is_type = 0 ");//库存类
        sb.append(" )");
        return sb.toString();
    }

    /**
     * 商品排序
     */
/*    public static String getWareSortSql() {
        StringBuffer sb = new StringBuffer();
//        sb.append(" order by a.ware_id asc");
        sb.append(" order by CASE WHEN a.sort IS NULL THEN 1 ELSE 0 END ASC, a.sort,a.ware_id asc ");
        return sb.toString();
    }*/

    public static String getWareSortSql() {
        return getWareSortSql("a");
    }

    public static String getWareSortSql(String pix) {
        return " order by case when " + pix + ".sort is null then 1 else 0 end asc ";//," + pix + ".sort asc," + pix + ".fbtime desc";
    }
}
