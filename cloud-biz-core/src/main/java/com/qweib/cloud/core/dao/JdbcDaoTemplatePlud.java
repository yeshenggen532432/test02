package com.qweib.cloud.core.dao;

import com.alibaba.druid.sql.PagerUtils;
import com.alibaba.druid.util.JdbcConstants;
import com.qweib.cloud.core.dao.annotations.QwbTable;
import com.qweib.cloud.core.exception.BizException;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import com.qweib.cloud.utils.TableAnnotation;
import lombok.extern.slf4j.Slf4j;
import org.springframework.jdbc.core.BatchPreparedStatementSetter;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.PreparedStatementSetter;
import org.springframework.jdbc.datasource.DataSourceUtils;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;

import java.lang.reflect.Method;
import java.sql.*;
import java.text.DecimalFormat;
import java.util.*;


/**
 * Description: JdbcDaoTemplate
 *
 * @Author: xushh
 * @Version: 1.0
 */
@Slf4j
public class JdbcDaoTemplatePlud extends JdbcTemplate {
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
     * @throws DBException
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
            //TenantContext.skip(true);
            int total = this.queryForObject(countSql, Integer.class);
            //TenantContext.skip(false);
            //设置总条数
            p.setTotal(total);
            return p;
        } catch (Exception ex) {
            throw new DaoException("queryForPage分页查询出错：" + ex);
        }
    }

    public Page queryForPageByMySql(String sql, int page, int limit) {
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
            p.setRows(this.queryForList(pageSql.toString()));
            String countSql = PagerUtils.count(sql, JdbcConstants.MYSQL);
            //设置总条数
            int total = this.queryForObject(countSql, Integer.class);
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
     * @param conn
     * @param stmt
     * @param rs
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
                    String str = resultSet.getString(c);
                    ResultSetMetaData metaData = resultSet.getMetaData();
                    map.put(metaData.getColumnLabel(c).replace("_", "").toUpperCase(), str == null ? "" : str.trim());
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
     * @param sql
     * @param page
     * @throws DaoException
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
     * @param sql
     * @param page
     * @throws DBException
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
     * @param sql
     * @param page
     * @throws DBException
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
                if (null != db) {
                    DecimalFormat df = new DecimalFormat("###.##");
                    return Double.parseDouble(df.format(db));
                }
                return null;
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
            e.printStackTrace();
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
     * 反射生成SQL和参数
     *
     * @param table  表名
     * @param entity 实体对象
     * @return SqlWrapper
     * @throws Exception e
     */
    private SqlWrapper genSql(String table, Object entity) throws Exception {
        Method[] methods = entity.getClass().getMethods();
        StringBuilder condition = new StringBuilder();//条件存在
        List<Object> objs = new ArrayList<Object>();  //条件对应值存放
        StringBuilder sql = new StringBuilder(" insert into ");
        sql.append(table).append("(");
        String sp = "";
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
                Object o = method.invoke(entity);
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
        return new SqlWrapper(sql.toString(), objs);
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
            //return this.update(sql.toString().toUpperCase(),objs.toArray());

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

    public int save(Object entity) {
        if (entity == null) {
            throw new BizException("entity can not be null");
        }
        if (entity.getClass().isAnnotationPresent(QwbTable.class)) {
            QwbTable annotation = entity.getClass().getAnnotation(QwbTable.class);
            String table = annotation.value();
            return save(table, entity);
        } else {
            throw new BizException("no @QwbTable annotation found");
        }
    }

    public int save(String table, Object entity) {
        KeyHolder keyHolder = new GeneratedKeyHolder();
        try {
            SqlWrapper sqlWrapper = genSql(table, entity);
            this.update(con -> {
                //TODO tenancy
                PreparedStatement ps = con.prepareStatement(sqlWrapper.getSql(), Statement.RETURN_GENERATED_KEYS);
                PreparedStatementSetter preparedStatementSetter = newArgPreparedStatementSetter(sqlWrapper.getParams().toArray());
                preparedStatementSetter.setValues(ps);
                return ps;
            }, keyHolder);
            return keyHolder.getKey().intValue();
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
                        sql.append(sp).append(lowerField).append(" = ?");
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
}
