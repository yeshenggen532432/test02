package com.qweib.cloud.core.dao;

import com.alibaba.druid.sql.PagerUtils;
import com.alibaba.druid.util.JdbcConstants;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.qweib.cloud.core.dao.annotations.QwbTable;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.Reflections;
import com.qweib.cloud.utils.StrUtil;
import com.qweib.cloud.utils.TableAnnotation;
import com.qweib.commons.Collections3;
import com.qweib.commons.StringUtils;
import com.qweibframework.commons.exceptions.NotFoundException;
import com.qweibframework.commons.page.PageRequest;
import lombok.extern.slf4j.Slf4j;
import org.springframework.jdbc.core.*;
import org.springframework.jdbc.datasource.DataSourceUtils;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;

import java.lang.reflect.Method;
import java.math.BigDecimal;
import java.sql.*;
import java.text.DecimalFormat;
import java.util.Date;
import java.util.*;

/**
 * Description: JdbcDaoTemplate
 *
 * @Author: xushh
 * @Version: 1.0
 */
@Slf4j
public class JdbcDaoTemplate extends JdbcTemplate {
    /**
     * 摘要：
     *
     * @return
     * @说明：获取自增id用于MySql
     * @创建：作者:yxy 创建时间：2012-6-13
     * @修改历史： [序号](yxy 2012 - 6 - 13)<修改说明>
     */
    public Integer getAutoIdForIntByMySql() {
        StringBuffer sql = new StringBuffer();
        sql.append("SELECT LAST_INSERT_ID();");
        try {
            return this.queryForObject(sql.toString(), Integer.class);
        } catch (Exception ex) {
            throw new DaoException(ex);
        }
    }

    /**
     * 摘要：
     *
     * @return
     * @说明：获取自增id用于MySql
     * @创建：作者:yxy 创建时间：2012-6-13
     * @修改历史： [序号](yxy 2012 - 6 - 13)<修改说明>
     */
    public Long getAutoIdForLongByMySql() {
        StringBuffer sql = new StringBuffer();
        sql.append("SELECT LAST_INSERT_ID();");
        try {
            return this.queryForObject(sql.toString(), Long.class);
        } catch (Exception ex) {
            throw new DaoException(ex);
        }
    }

    /**
     * 摘要：
     *
     * @param sql
     * @param page
     * @return
     * @说明：根据查询语句分页查询用于oracle查询
     * @创建：作者:yxy 创建时间：2012-1-12
     * @修改历史： [序号](yxy 2012 - 1 - 12)<修改说明>
     */
    public Page queryForPageByMySql(String sql, int page, int limit, Class cls) {
        Page p = new Page();
        if (page == 0 || limit == 0) {
            return p;
        }
        p.setPageSize(limit);
        p.setCurPage(page);
        try {
            //开始数
            int startNum = ((page == 0 ? 1 : page) - 1) * limit;
            StringBuffer pageSql = new StringBuffer();
            pageSql.append(sql).append(" limit ").append(startNum).append(" , ").append(limit);
            p.setRows(this.queryForLists(pageSql.toString(), cls));

            String countSql = PagerUtils.count(sql, JdbcConstants.MYSQL);
            //设置总条数
            int total = this.queryForObject(countSql, Integer.class);
            //设置总条数
            p.setTotal(total);
            return p;
        } catch (Exception ex) {
            throw new DaoException("queryForPage分页查询出错：", ex);
        }
    }

    public Page queryForPageByMySql(String sql, Object[] whereArgs, int page, int limit, Class cls) {
        Page p = new Page();
        if (page == 0 || limit == 0) {
            return p;
        }
        p.setPageSize(limit);
        p.setCurPage(page);
        try {
            //开始数
            int startNum = ((page == 0 ? 1 : page) - 1) * limit;
            StringBuffer pageSql = new StringBuffer();
            pageSql.append(sql).append(" limit ").append(startNum).append(" , ").append(limit);
            p.setRows(this.queryForLists(pageSql.toString(), cls, whereArgs));

            String countSql = PagerUtils.count(sql, JdbcConstants.MYSQL);
            //设置总条数
            int total = this.queryForObject(countSql, whereArgs, Integer.class);
            //设置总条数
            p.setTotal(total);
            return p;
        } catch (Exception ex) {
            throw new DaoException("queryForPage分页查询出错：" + ex);
        }
    }

    /**
     * 摘要：
     *
     * @param sql
     * @param page
     * @说明：根据查询语句分页查询用于oracle查询
     * @创建：作者:yxy 创建时间：2012-1-12
     * @修改历史： [序号](yxy 2012 - 1 - 12)<修改说明>
     */
    public Page queryForPageByMySql2(String sql, int page, int limit, Class cls) {
        Page p = new Page();
        if (page == 0 || limit == 0) {
            return p;
        }
        p.setPageSize(limit);
        p.setCurPage(page);
        try {
            //开始数
            int startNum = ((page == 0 ? 1 : page) - 1) * limit;
            StringBuffer pageSql = new StringBuffer();
            pageSql.append(sql).append(" limit ").append(startNum).append(" , ").append(limit);
            p.setRows(this.queryForLists(pageSql.toString(), cls));
            //去掉sql的order by
            int order_index = sql.toLowerCase().lastIndexOf("order by");
            if (order_index > 0) {
                sql = sql.substring(0, order_index);
            }
            StringBuffer totalSql = new StringBuffer(" select count(1) from (").append(sql).append(") t");
            Integer total = this.queryForInt(totalSql.toString());
            //设置总条数
            p.setTotal(total);
            return p;
        } catch (Exception ex) {
            throw new DaoException("queryForPage分页查询出错：" + ex);
        }
    }

    /**
     * 摘要：
     *
     * @param conn
     * @param stmt
     * @param rs
     * @throws DaoException
     * @说明：关闭连接
     * @创建：作者:yxy 创建时间：2012-1-11.
     */
    public void cleanUp(Connection conn, Statement stmt, ResultSet rs) throws DaoException {
        try {
            if (rs != null) {
                rs.close();
            }
            if (stmt != null) {
                stmt.close();
            }
            releaseConn(conn);
        } catch (Exception e) {
            throw new DaoException();
        }
    }

    /**
     * 摘要：
     *
     * @throws DaoException
     * @说明：关闭连接
     * @创建：作者:yxy 创建时间：2012-1-11.
     */
    public void cleanUp(Connection conn, PreparedStatement pst, ResultSet rs) throws DaoException {
        try {
            if (rs != null) {
                rs.close();
            }
            if (pst != null) {
                pst.close();
            }
            releaseConn(conn);

        } catch (Exception e) {
            throw new DaoException();
        }
    }

    /**
     * 摘要：
     *
     * @param conn
     * @说明：释放连接
     * @创建：作者:yxy 创建时间：2012-1-11
     * @修改历史： [序号](yxy 2012 - 1 - 11)<修改说明>
     */
    public void releaseConn(Connection conn) {
        DataSourceUtils.releaseConnection(conn, getDataSource());
    }

    /**
     * 查询数据并封装到POJO
     *
     * @param sql    数据库执行语句
     * @param clz    POJO
     * @param params 查询条件（查询参数）
     * @param <T>    默认POJO
     * @return List<T>
     * @author Lins
     */
    public <T> List<T> queryForLists(String sql, Class clz, Object... params) {
        List<T> list;
        Connection conn = null;
        ResultSet rs = null;
        PreparedStatement stmt = null;
        try {
            log.debug("queryForLists:{}", sql);
            conn = DataSourceUtils.getConnection(getDataSource());
            stmt = conn.prepareStatement(sql);
            if (params != null) {
                for (int d = 0; d < params.length; d++) {
                    stmt.setString(d + 1, params[d].toString());
                }
            }
            list = RowMapper(stmt.executeQuery(), clz);
        } catch (Exception e) {
            throw new DaoException(e);
        } finally {
            cleanUp(conn, stmt, rs);
        }
        return list;
    }

    /**
     * 映射结果集到
     *
     * @param resultSet
     * @param elementType
     * @return
     * @throws SQLException
     * @author Lins
     */
    @SuppressWarnings("unchecked")
    public <T> List<T> RowMapper(ResultSet resultSet, Class elementType) throws SQLException {
        List<T> list = null;
        Object obj = null;
        try {
            Method[] methods = elementType.getMethods();
            Map<String, String> map = new HashMap<String, String>();
            //遍历结果集并存储<列名，值>
            list = new ArrayList<T>();
            while (resultSet.next()) {
                obj = elementType.newInstance();
                for (int c = 1; c <= resultSet.getMetaData().getColumnCount(); c++) {
                    ResultSetMetaData metaData = resultSet.getMetaData();
                    String str = resultSet.getString(c);
                    if ("blod_byte".equals(metaData.getColumnLabel(c))) {
                        String content = new String(resultSet.getBlob(c).getBytes((long) 1, (int) resultSet.getBlob(c).length()));
                        map.put("BLODHTML", content);
                    } else {
                        map.put(metaData.getColumnLabel(c).replace("_", "").toUpperCase(), str == null ? "" : str.trim());
                    }
                }
                for (Method method : methods) {
                    if (method.getName().startsWith("set")) {
                        String pType = method.getParameterTypes()[0].getSimpleName();
                        String field = method.getName().substring(3);
                        if (map.containsKey(field.toUpperCase())) {
                            method.invoke(obj, new Object[]{StrUtil.convertT(map.get(field.toUpperCase()), pType)});
                        }
                    }
                }
                list.add((T) obj);
            }
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
        return list;
    }

    /**
     * @说明：根据查询语句返回一个Map对象(用于查询一条记录)
     * @创建：作者:yxy 创建时间：2012-1-11
     * @修改历史： [序号](yxy 2012 - 1 - 11)<修改说明>
     */
    @SuppressWarnings("unchecked")
    public <T> T queryForObj(String sql, Class cls, Object... params) throws DaoException {
        Connection conn = null;
        ResultSet rs = null;
        PreparedStatement stmt = null;
        try {
            log.debug("queryForObj:{}", sql);
            conn = DataSourceUtils.getConnection(getDataSource());
            stmt = conn.prepareStatement(sql.toUpperCase());
            if (params != null) {
                for (int d = 0; d < params.length; d++) {
                    stmt.setString(d + 1, params[d].toString());
                }
            }
            rs = stmt.executeQuery();
            return (T) resultSetToObj(rs, cls);
        } catch (Exception e) {
            throw new DaoException(e);
        } finally {
            cleanUp(conn, stmt, rs);
        }
    }

    /**
     * @说明：根据查询语句返回一个Map对象(用于查询一条记录)
     * @创建：作者:yxy 创建时间：2012-1-11
     * @修改历史： [序号](yxy 2012 - 1 - 11)<修改说明>
     */
    public Map<String, Object> queryForMap(String sql) {
        Map<String, Object> map = null;
        Connection conn = null;
        ResultSet rs = null;
        Statement stmt = null;
        try {
            log.debug("queryForMap:{}", sql);
            conn = DataSourceUtils.getConnection(getDataSource());
            stmt = conn.createStatement();
            if (sql == null || sql.trim().equals(""))
                return null;
            rs = stmt.executeQuery(sql);
            map = resultSetToMap(rs);
            return map;
        } catch (Exception e) {
            throw new DaoException(e);
        } finally {
            cleanUp(conn, stmt, rs);
        }
    }

    /**
     * @说明：根据查询语句返回一个List对象(用于查询所有记录)
     * @创建：作者:yxy 创建时间：2012-1-11
     * @修改历史： [序号](yxy 2012 - 1 - 11)<修改说明>
     */
    public List<Map<String, Object>> queryForList(String sql) {
        Map<String, Object> map = null;
        Connection conn = null;
        ResultSet rs = null;
        Statement stmt = null;
        List<Map<String, Object>> list = null;
        ResultSetMetaData metaData = null;
        try {
            log.debug("queryForList:{}", sql);
            conn = DataSourceUtils.getConnection(getDataSource());
            stmt = conn.createStatement();
            if (sql == null || sql.trim().equals(""))
                return null;
            rs = stmt.executeQuery(sql);
            //遍历结果集并存储<列名，值>
            list = new ArrayList<Map<String, Object>>();
            while (rs != null && rs.next()) {
                metaData = rs.getMetaData();
                int columnCount = metaData.getColumnCount();
                map = new HashMap<String, Object>();
                for (int i = 1; i <= columnCount; i++) {
                    String columnName = metaData.getColumnLabel(i).toLowerCase();
                    Object columnValue = mapResultSet(rs, i, metaData.getColumnType(i));
                    map.put(columnName, columnValue);
                }
                list.add(map);
            }
            return list;
        } catch (Exception e) {
            throw new DaoException(e);
        } finally {
            cleanUp(conn, stmt, rs);
        }
    }

    /**
     * @param rs
     * @throws RuntimeException
     * @说明：把查询返回的结果封装为Map
     * @创建：作者:yxy 创建时间：2012-1-11
     * @修改历史： [序号](yxy 2012 - 1 - 11)<修改说明>
     */
    private Map<String, Object> resultSetToMap(ResultSet rs) {
        if (rs == null) {
            return null;
        }
        ResultSetMetaData metaData = null;
        Map<String, Object> map = null;
        try {
            metaData = rs.getMetaData();
            map = new HashMap<String, Object>();
            int columnCount = metaData.getColumnCount();
            if (rs != null && rs.next()) {
                for (int i = 1; i <= columnCount; i++) {
                    String columnName = metaData.getColumnLabel(i).toLowerCase();
                    Object columnValue = mapResultSet(rs, i, metaData.getColumnType(i));
                    map.put(columnName, columnValue);
                }
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        } finally {
            metaData = null;
        }
        return map;
    }

    /**
     * @param rs
     * @throws RuntimeException
     * @说明：进行数据库类型转化
     * @创建：作者:yxy 创建时间：2012-1-11
     * @修改历史： [序号](yxy 2012 - 1 - 11)<修改说明>
     */
    private Object mapResultSet(ResultSet rs, int columnPosition, int SQLType) {
        try {
            if (SQLType == Types.INTEGER) {
                return rs.getInt(columnPosition);
            } else if (SQLType == Types.VARCHAR || SQLType == Types.LONGVARCHAR) {
                return rs.getString(columnPosition);
            } else if (SQLType == Types.CHAR) {
                return rs.getString(columnPosition);
            } else if (SQLType == Types.DATE) {
                return rs.getDate(columnPosition);
            } else if (SQLType == Types.DECIMAL) {
                Double db = rs.getDouble(columnPosition);
                if(db==null){
                    return new Double(0);
                }
//                if (null != db) {
//                    DecimalFormat df = new DecimalFormat("###.##");
//                    return Double.parseDouble(df.format(db));
//                }
                String str = db.toString();
                if (str.contains(".")) {
                    int k = str.indexOf(".");
                    if (str.substring(k + 1).length() > 5) {
                        DecimalFormat df = new DecimalFormat("###.#####");
                       return Double.parseDouble(df.format(db));
                    }
                }
                return db;
            } else if (SQLType == Types.NUMERIC) {
                Double d = rs.getDouble(columnPosition);
                if (null != d) {
                    Integer i = d.intValue();
                    if ((d - i) == 0) {
                        return rs.getInt(columnPosition);
                    }
                }
                return d;
            } else if (SQLType == Types.DOUBLE) {
                Double db = rs.getDouble(columnPosition);
                if (null != db) {
                    DecimalFormat df = new DecimalFormat("###.##");
                    return Double.parseDouble(df.format(db));
                }
                return null;
            } else if (SQLType == Types.FLOAT) {
                return rs.getFloat(columnPosition);
            } else if (SQLType == Types.REAL) {
                return rs.getFloat(columnPosition);
            } else if (SQLType == Types.TIMESTAMP) {
                return rs.getTimestamp(columnPosition);
            } else if (SQLType == -5) {
                return rs.getString(columnPosition);
            } else if (SQLType == -6) {
                return rs.getInt(columnPosition);
            } else if (SQLType == 5) {
                return rs.getInt(columnPosition);
            } else {
                throw new RuntimeException("数据库结果集数据类型转化失败.");
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    /**
     * 摘要：
     *
     * @param rs          结果集
     * @param elementType 对应的类
     * @return
     * @throws SQLException
     * @说明：把查询返回的结果封装为Object
     * @创建：作者:yxy 创建时间：2012-4-5
     * @修改历史： [序号](yxy 2012 - 4 - 5)<修改说明>
     */
    @SuppressWarnings("unchecked")
    private <T> T resultSetToObj(ResultSet rs, Class elementType) throws SQLException {
        if (rs == null) {
            return null;
        }
        ResultSetMetaData metaData = null;
        try {
            Method[] methods = elementType.getMethods();
            Map<String, Object> tempMap = new HashMap<String, Object>();
            metaData = rs.getMetaData();
            int columnCount = metaData.getColumnCount();
            if (rs != null && rs.next()) {
                Object obj = elementType.newInstance();
                for (int i = 1; i <= columnCount; i++) {
                    String str = rs.getString(i);
                    tempMap.put(metaData.getColumnLabel(i).replace("_", "").toUpperCase(), str == null ? "" : str.trim());
                }
                for (Method method : methods) {
                    if (method.getName().startsWith("set")) {
                        String pType = method.getParameterTypes()[0].getSimpleName();
                        String field = method.getName().substring(3);
                        if (tempMap.containsKey(field.toUpperCase())) {
                            method.invoke(obj, new Object[]{StrUtil.convertT(tempMap.get(field.toUpperCase()), pType)});
                        }
                    }
                }
                return (T) obj;
            } else {
                return null;
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    /**
     * 摘要：
     *
     * @param sql
     * @param its
     * @return
     * @说明：批量删除用于int的数组
     * @创建：作者:yxy 创建时间：2012-7-12
     * @修改历史： [序号](yxy 2012 - 7 - 12)<修改说明>
     */
    public int[] deletes(String sql, final Integer... its) {
        try {
            BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter() {
                public int getBatchSize() {
                    return its.length;
                }

                ;

                public void setValues(PreparedStatement pre, int num) throws SQLException {
                    pre.setInt(1, its[num]);
                }

                ;
            };
            return this.batchUpdate(sql.toUpperCase(), setter);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    /**
     * 摘要：
     *
     * @param sql
     * @param its
     * @return
     * @说明：批量删除用于int的数组
     * @创建：作者:yxy 创建时间：2012-7-12
     * @修改历史： [序号](yxy 2012 - 7 - 12)<修改说明>
     */
    public int[] deletes(String sql, final Long... its) {
        try {
            BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter() {
                public int getBatchSize() {
                    return its.length;
                }

                ;

                public void setValues(PreparedStatement pre, int num) throws SQLException {
                    pre.setLong(1, its[num]);
                }

                ;
            };
            return this.batchUpdate(sql.toUpperCase(), setter);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    /**
     * 摘要：
     *
     * @param sql
     * @param its
     * @return
     * @说明：批量删除用于string的数组
     * @创建：作者:yxy 创建时间：2012-7-12
     * @修改历史： [序号](yxy 2012 - 7 - 12)<修改说明>
     */
    public int[] deletes(String sql, final String... its) {
        try {
            BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter() {
                public int getBatchSize() {
                    return its.length;
                }

                ;

                public void setValues(PreparedStatement pre, int num) throws SQLException {
                    pre.setString(1, its[num]);
                }

                ;
            };
            return this.batchUpdate(sql.toUpperCase(), setter);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    /**
     * 摘要：
     *
     * @param tableName
     * @param obj
     * @return
     * @说明：根据对象添加到指定表
     * @创建：作者:yxy 创建时间：2013-4-7
     * @修改历史：
     */
    public int addByObject(String tableName, Object obj) {
        Method[] methods = obj.getClass().getMethods();
        StringBuilder condition = new StringBuilder();//条件存在
        List<Object> objs = new ArrayList<Object>();  //条件对应值存放
        StringBuilder sql = new StringBuilder(" insert into ");
        sql.append(tableName).append("(");
        String sp = "";
        try {
            for (Method method : methods) {
                if (method.getName().startsWith("get")) {
                    String field = method.getName().substring(3);
                    String lowerField = field.toLowerCase();
                    if (lowerField.equals("class")) {
                        continue;
                    }
                    TableAnnotation annotation = method.getAnnotation(TableAnnotation.class);
                    if (null != annotation && !annotation.insertAble()) {
                        continue;
                    }
                    Object o = method.invoke(obj);
                    if (null != o) {
                        lowerField = StrUtil.convertField(field);
                        sql.append(sp).append(lowerField);
                        condition.append(sp).append("?");
                        objs.add(o);
                        sp = ",";
                    }
                }
            }
            sql.append(") values(").append(condition).append(") ");

            /*****用于更改id生成方式 by guojr******/
            int re = this.update(sql.toString().toUpperCase(), objs.toArray());
            if (re > 0) {
                return getAutoIdForIntByMySql();
            } else {
                return -1;
            }
            /*****************************/
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public int add(String database, Object obj) {
        return this.add(database, getTableName(obj), obj);
    }

    public int add(String database, String tableName, Object obj) {
        Method[] methods = obj.getClass().getMethods();
        StringBuilder condition = new StringBuilder();//条件存在
        List<Object> objs = new ArrayList<Object>();  //条件对应值存放
        StringBuilder sql = new StringBuilder(" insert into ");
        sql.append(database).append(".").append(tableName).append("(");
        String sp = "";
        try {
            for (Method method : methods) {
                if (method.getName().startsWith("get")) {
                    String field = method.getName().substring(3);
                    String lowerField = field.toLowerCase();
                    if (lowerField.equals("class")) {
                        continue;
                    }
                    TableAnnotation annotation = method.getAnnotation(TableAnnotation.class);
                    if (null != annotation && !annotation.insertAble()) {
                        continue;
                    }
                    Object o = method.invoke(obj);
                    if (null != o) {
                        lowerField = StrUtil.convertField(field);
                        sql.append(sp).append("`"+lowerField+"`");
                        condition.append(sp).append("?");
                        objs.add(o);
                        sp = ",";
                    }
                }
            }
            sql.append(") values(").append(condition).append(") ");
            return this.save(sql.toString(), objs.toArray());
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    private String getTableName(Object entity) {
        return getTableName(null, entity);
    }

    private String getTableName(String database, Object entity) {
        Class<?> clazz = entity.getClass();
        String table;
        if (clazz.isAnnotationPresent(QwbTable.class)) {
            table = clazz.getAnnotation(QwbTable.class).value();
        } else {
            table = StrUtil.convertField(clazz.getName());
        }
        return StringUtils.isEmpty(database) ? table : (database + "." + table);
    }

    public int updateEntity(String database, Object obj) {
        Map<String, Object> params = Maps.newHashMap();
        params.put("id", Reflections.getFieldValue(obj, "id"));
        return updateEntity(database, obj, params, "id");
    }

    public int updateEntity(String database, Object obj, Map<String, Object> additionalParams, String primaryKey) {
        String tableName = getTableName(database, obj);
        return updateByObject(tableName, obj, additionalParams, primaryKey);
    }

    /**
     * 摘要：
     * tableName
     */
    public int addByMap(String tableName, Map<String, Object> map) {
        try {
            StringBuilder sb = new StringBuilder();
            sb.append(" insert into " + tableName + " (");
            String keyStr = "";
            String valuesStr = "";
            for (Map.Entry<String, Object> entry : map.entrySet()) {
                keyStr += entry.getKey() + ",";
                if (entry.getValue() instanceof String || entry.getValue() instanceof Date) {
                    valuesStr += "'" + entry.getValue() + "',";
                } else {
                    valuesStr += "" + entry.getValue() + ",";
                }

            }
            if (keyStr.endsWith(",")) {
                keyStr = keyStr.substring(0, keyStr.length() - 1);
                valuesStr = valuesStr.substring(0, valuesStr.length() - 1);
            }
            sb.append(keyStr + ") values (" + valuesStr + ")");

            /*****用于更改id生成方式 by guojr******/
            int re = this.update(sb.toString().toUpperCase());
            if (re > 0) {
                return getAutoIdForIntByMySql();
            } else {
                return -1;
            }
            /*****************************/
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 摘要：
     */
    public int updateByMap(String tableName, Map<String, Object> map, Map<String, Object> whereParam) {
        try {
            StringBuilder sb = new StringBuilder();
            sb.append(" update " + tableName);

            //-----set-----
            String kStr = "";
            for (Map.Entry<String, Object> entry : map.entrySet()) {
                Object value = entry.getValue();
                if (value instanceof String || value instanceof Date) {
                    kStr += entry.getKey() + "=" + "'" + entry.getValue() + "',";
                } else {
                    kStr += entry.getKey() + "=" + "" + entry.getValue() + ",";
                }
            }
            //去掉多余的","
            if (kStr.endsWith(",")) {
                kStr = kStr.substring(0, kStr.length() - 1);
            }
            sb.append(" set ");
            sb.append(kStr);

            //-----where----
            String s = "";
            if (whereParam != null && whereParam.size() > 0) {
                for (Map.Entry<String, Object> entry2 : whereParam.entrySet()) {
                    s += entry2.getKey() + "=" + "'" + entry2.getValue() + "'";
                    s += " and";
                }
                //去掉多余的"and"
                if (s.endsWith("and")) {
                    s = s.substring(0, s.length() - 3);
                }
                sb.append(" where ");
                sb.append(s);
            }
            return this.update(sb.toString().toUpperCase());
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }


    /**
     * 摘要：
     *
     * @param tableName
     * @param obj
     * @return
     * @说明：根据对象修改指定表
     * @创建：作者:yxy 创建时间：2013-4-7
     * @修改历史：
     */
    public int updateByObject(String tableName, Object obj, Map<String, Object> whereParam, String autoId) {
        Method[] methods = obj.getClass().getMethods();
        List<Object> objs = new ArrayList<Object>();  //条件对应值存放
        StringBuilder sql = new StringBuilder(" update ");
        sql.append(tableName).append(" set ");
        String sp = "";
        try {
            for (Method method : methods) {
                if (method.getName().startsWith("get")) {
                    String field = method.getName().substring(3);
                    String lowerField = field.toLowerCase();
                    if (lowerField.equals("class")) {
                        continue;
                    }
                    if (!StrUtil.isNull(autoId)) {
                        if (lowerField.equals(autoId.toLowerCase())) {
                            continue;
                        }
                    }
                    Object o = method.invoke(obj);
                    lowerField = StrUtil.convertField(field);
                    TableAnnotation annotation = method.getAnnotation(TableAnnotation.class);
                    if (null != annotation && null == o && !annotation.nullToUpdate()) {
                        continue;
                    }
                    if (null == annotation || annotation.updateAble()) {
                        sql.append(sp).append("`"+lowerField+"`").append(" = ?");
                        objs.add(o);
                        sp = ",";
                    }
                }
            }
            if (whereParam != null && whereParam.size() > 0) {
                Iterator<String> fields = whereParam.keySet().iterator();
                sp = " where ";
                while (fields.hasNext()) {
                    String field = fields.next();
                    sql.append(sp).append(field).append(" = ?");
                    sp = " and ";
                    objs.add(whereParam.get(field));
                }
            }
            return this.update(sql.toString().toUpperCase(), objs.toArray());
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public Page queryForPageByMySqlForMap(String sql, int page, int limit) {
        Page p = new Page();
        if (page == 0 || limit == 0) {
            return p;
        }
        p.setPageSize(limit);
        p.setCurPage(page);
        try {
            //开始数
            int startNum = ((page == 0 ? 1 : page) - 1) * limit;
            StringBuffer pageSql = new StringBuffer();
            pageSql.append(sql).append(" limit ").append(startNum).append(" , ").append(limit);
            p.setRows(queryForList(pageSql.toString()));
            //去掉sql的order by
            int order_index = sql.toLowerCase().lastIndexOf("order by");
            if (order_index > 0) {
                sql = sql.substring(0, order_index);
            }
            StringBuffer totalSql = new StringBuffer(" select count(1) from (").append(sql).append(") t");
            //设置总条数
            //设置总条数
            int total = this.queryForObject(totalSql.toString(), Integer.class);
            //设置总条数
            p.setTotal(total);
            return p;
        } catch (Exception ex) {
            throw new DaoException("queryForPage分页查询出错：" + ex);
        }
    }

    public Integer queryForInt(String sql, Object... args) {
        if (args != null && args.length > 0) {
            return queryForObject(sql, args, Integer.class);
        } else {
            return queryForObject(sql, Integer.class);
        }
    }

    public Long queryForLong(String sql, Object... args) {
        if (args != null && args.length > 0) {
            return queryForObject(sql, args, Long.class);
        } else {
            return queryForObject(sql, Long.class);
        }
    }

    public int updateProperties(String database, String tableName, Map<String, Object> properties, Map<String, Object> whereArgs) {
        StringBuilder sql = new StringBuilder(64);
        sql.append("UPDATE ").append(database).append(".").append(tableName).append(" SET ");

        List<Object> values = Lists.newArrayList();
        int index = 0;
        for (Map.Entry<String, Object> entry : properties.entrySet()) {
            if (index > 0) {
                sql.append(",");
            }
            sql.append(entry.getKey()).append("=?");
            values.add(entry.getValue());
            index++;
        }

        sql.append(" WHERE ");
        index = 0;
        for (Map.Entry<String, Object> entry : whereArgs.entrySet()) {
            if (index > 0) {
                sql.append(" AND ");
            }
            sql.append(entry.getKey()).append("=?");
            values.add(entry.getValue());
        }

        return this.update(sql.toString(), values.toArray(new Object[values.size()]));
    }

    public Integer saveEntityAndGetKey(final String database, final String tableName, final Map<String, Object> valueMap) {
        final StringBuilder sql = new StringBuilder(128);
        sql.append("INSERT INTO ");
        if (StringUtils.isNotBlank(database)) {
            sql.append(database).append(".");
        }
        sql.append(tableName).append(" (");
        int index = 0;
        List<Object> values = Lists.newArrayListWithCapacity(valueMap.size());
        for (Map.Entry<String, Object> entry : valueMap.entrySet()) {
            if (index > 0) {
                sql.append(",");
            } else {
                index++;
            }
            sql.append(entry.getKey());
            values.add(entry.getValue());
        }
        sql.append(") VALUES (").append(StringUtils.repeat("?", ",", values.size())).append(");");

        return saveEntityAndGetKey(sql.toString(), values.toArray(new Object[values.size()]));
    }

    public Integer save(final String sql, final Object[] values) {
        KeyHolder holder = new GeneratedKeyHolder();
        int ret = this.update(conn -> {
            PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            PreparedStatementSetter preparedStatementSetter = newArgPreparedStatementSetter(values);
            preparedStatementSetter.setValues(ps);
            return ps;
        }, holder);
        return ret > 0 ? holder.getKey().intValue() : -1;
    }

    public Integer saveEntityAndGetKey(final String sql, final Object[] values) {
        final KeyHolder keyHolder = new GeneratedKeyHolder();
        int count = this.update(new PreparedStatementCreator() {
            @Override
            public PreparedStatement createPreparedStatement(Connection connection) throws SQLException {
                PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
                int index = 1;
                for (Object value : values) {
                    if (value == null) {
                        ps.setNull(index, Types.NULL);
                    } else if (value instanceof String) {
                        ps.setString(index, (String) value);
                    } else if (value instanceof Integer) {
                        ps.setInt(index, (Integer) value);
                    } else if (value instanceof Long) {
                        ps.setLong(index, (Long) value);
                    } else if (value instanceof Double) {
                        ps.setDouble(index, (Double) value);
                    } else if (value instanceof BigDecimal) {
                        ps.setBigDecimal(index, (BigDecimal) value);
                    } else if (value instanceof Timestamp) {
                        ps.setTimestamp(index, (Timestamp) value);
                    } else if (value instanceof Boolean) {
                        ps.setBoolean(index, (Boolean) value);
                    } else {
                        throw new RuntimeException("SQL类型不匹配");
                    }
                    index++;
                }

                return ps;
            }
        }, keyHolder);

        return count > 0 ? keyHolder.getKey().intValue() : null;
    }

    public int updateEntity(final String database, final String tableName, Map<String, Object> setMap, Map<String, Object> whereMap) {
        StringBuilder sql = new StringBuilder(128);
        sql.append("UPDATE ");
        if (StringUtils.isNotBlank(database)) {
            sql.append(database).append(".");
        }
        sql.append(tableName).append(" SET ");
        List<Object> values = Lists.newArrayListWithCapacity(setMap.size());
        int index = 0;
        for (Map.Entry<String, Object> entry : setMap.entrySet()) {
            if (index > 0) {
                sql.append(", ");
            } else {
                index++;
            }
            sql.append(entry.getKey()).append("=?");
            values.add(entry.getValue());
        }
        if (Collections3.isNotEmpty(whereMap)) {
            sql.append(" WHERE ");
            index = 0;
            for (Map.Entry<String, Object> entry : whereMap.entrySet()) {
                if (index > 0) {
                    sql.append(" AND ");
                } else {
                    index++;
                }
                sql.append(entry.getKey()).append("=?");
                values.add(entry.getValue());
            }
        }

        return this.update(sql.toString(), values.toArray(new Object[values.size()]));
    }

    public  <E> com.qweibframework.commons.page.Page<E> page(String sql, List<Object> whereArgs, PageRequest pageRequest, RowMapper<E> rowMapper) {
        Integer totalCount = this.count(sql, whereArgs);
        if (totalCount <= pageRequest.getOffset()) {
            return new com.qweibframework.commons.page.Page<>(Lists.newArrayListWithCapacity(0), totalCount, pageRequest);
        }

        String selectSql = new StringBuilder(sql.length() + 30)
                .append(sql).append(" LIMIT ?,?")
                .toString();

        if (whereArgs == null) {
            whereArgs = Lists.newArrayListWithCapacity(2);
        }
        whereArgs.add(pageRequest.getOffset());
        whereArgs.add(pageRequest.getSize());

        List<E> list = this.query(selectSql, whereArgs.toArray(new Object[whereArgs.size()]), rowMapper);

        return new com.qweibframework.commons.page.Page<>(list, totalCount, pageRequest);
    }

    public Integer count(String sql, List<Object> whereArgs) {
        String tmpSql = sql.toLowerCase();
        int fromIndex = tmpSql.indexOf("from");
        int orderByIndex = tmpSql.lastIndexOf("order by");
        if (fromIndex < 0) {
            throw new NotFoundException("sql unknown from char: " + sql);
        }

        if (orderByIndex > 0) {
            tmpSql = tmpSql.substring(fromIndex, orderByIndex);
        } else {
            tmpSql = tmpSql.substring(fromIndex);
        }
        String countSql = new StringBuilder(tmpSql.length() + 20)
                .append("SELECT COUNT(*) ").append(tmpSql)
                .toString();

        if (Collections3.isNotEmpty(whereArgs)) {
            return this.queryForObject(countSql, whereArgs.toArray(new Object[whereArgs.size()]), Integer.class);
        } else {
            return this.queryForObject(countSql, Integer.class);
        }
    }
}
