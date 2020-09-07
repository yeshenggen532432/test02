package com.qweib.cloud;

import com.alibaba.druid.sql.PagerUtils;
import com.alibaba.druid.sql.SQLUtils;
import com.alibaba.druid.sql.ast.SQLStatement;
import com.alibaba.druid.sql.dialect.mysql.parser.MySqlStatementParser;
import com.alibaba.druid.util.JdbcConstants;
import com.google.common.collect.Lists;
import com.qweib.cloud.core.exception.BizException;
import com.qweib.commons.security.Digests;
import com.qweibframework.boot.datasource.tenancy.MultiTenancySqlVisitor;
import org.apache.commons.io.FileUtils;
import org.junit.Test;
import org.springframework.core.io.ClassPathResource;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * @author: jimmy.lin
 * @time: 2019/10/8 23:46
 * @description:
 */
public class SqlTest {

    private final String tenantColumnName = "tenant_id";
    private final Integer tenantId = 2333;

    @Test
    public void genPwd(){
        Digests.Password pwd = Digests.encryptPwd("123456", true);
        System.out.println(pwd.getEncryptPwd());
        System.out.println(pwd.getSalt());
    }

    @Test
    public void testCreateTable() throws IOException {

        ClassPathResource schema = new ClassPathResource("xmuglcwwlkjyxgs285.sql");
        String sql = FileUtils.readFileToString(schema.getFile(), "UTF-8");

        /*String sql = "CREATE TABLE `approval_transfer_order_config` (\n" +
                "  `id` varchar(36) NOT NULL,\n" +
                "  `no` varchar(50) NOT NULL,\n" +
                "  `approval_type` varchar(10) NOT NULL,\n" +
                "  `transfer_order_type` varchar(10) NOT NULL,\n" +
                "  `status` varchar(10) NOT NULL DEFAULT '0',\n" +
                "  `system_approval` smallint(6) NOT NULL DEFAULT '0',\n" +
                "  `approval_id` varchar(100) NOT NULL,\n" +
                "  `account_subject_type` varchar(10) NOT NULL,\n" +
                "  `account_subject_item` varchar(20) NOT NULL,\n" +
                "  `payment_account` varchar(36) DEFAULT NULL,\n" +
                "  `created_by` int(11) NOT NULL,\n" +
                "  `created_time` datetime NOT NULL,\n" +
                "  `updated_by` int(11) NOT NULL,\n" +
                "  `updated_time` datetime NOT NULL,\n" +
                "  PRIMARY KEY (`id`)\n" +
                ") ENGINE=InnoDB DEFAULT CHARSET=utf8;";*/
        //System.out.println(sql);
        System.out.println("========================================================");
        System.out.println(shape(sql));
    }

    @Test
    public void testSelect() {
        String sql = "select a.*,o.order_no,c.member_nm,d.stk_name,1 as count from xmlzgmyyxgs566.stk_out a left join xmlzgmyyxgs566.sys_mem c on a.mid=c.member_id  left join xmlzgmyyxgs566.stk_storage d on a.stk_id = d.id  left join xmlzgmyyxgs566.sys_bforder o on a.order_id = o.id where 1=1 and a.out_time >='2019-10-01' and a.out_time <='2019-10-23' and a.id in(select mast_id from xmlzgmyyxgs566.stk_outsub d  left join xmlzgmyyxgs566.sys_ware p on d.ware_id = p.ware_id  left join xmlzgmyyxgs566.sys_waretype w on p.waretype = w.waretype_id  where 1=1  and  w.is_type = '0') and a.out_type!='其它出库' and a.out_type!='领用出库' and a.out_type!='报损出库' and a.out_type!='借出出库' order by a.sort desc";
        String sql1 = "select * from `uglcw285`.bsc_bill_config_item where type = 1 AND t_id in (select id from t_b where f_id = ?)";
        String sql2 = "SELECT GROUP_CONCAT(d.branch_path) AS depts  FROM smxlfmyyxgs846.sys_deptmempower dp,smxlfmyyxgs846.sys_depart d, smxlfmyyxgs846.sys_role sr  WHERE dp.dept_id=d.branch_id  AND dp.member_id=? AND dp.tp=?";
        String sql3 = "select a.*,b.apply_name as menu_name,b.apply_url from zzsyjspmyyxgs845.sys_quick_menu a left join zzsyjspmyyxgs845.sys_menu_apply b on a.menu_id= b.id  where 1=1 and b.tp=1  and a.member_id=3549 and b.id in (10,37,45,47,50,51,52,53,55,56,57,58,59,60,61,62,63,65,66,73,79,89,92,93,94,95,96,97,104,108,109,110,111,112,113,115,116,119,120,121,122,125,126,127,128,129,130,131,132,133,134,135,137,138,140,144,200,201,202,203,204,205,206,207,208,209,210,211,212,213,214,215,216,217,218,219,221,222,223,224,226,227,230,232,233,234,330,332,333,335,336,337,338,339,340,341,400,401,402,403,404,405,406,407,408,409,410,411,412,413,414,415,416,417,418,566,577,578,579,582,583,600,601,606,607,609,610,611,612,620,621,622,623,624,625,626,627,633,640,641,643,644,700,701,702,703,704,705,706,707,708,709,710,711,712,713,715,717,718,720,721,722,723,724,725,726,730,731,732,733,734,735,737,740,741,742,760,761,762,766,767,768,770,771,775,776,777,778,779,780,781,782,783,784,785,788,790,791,793,794,795,796,797,798,799,800,801,802,803,804,807,808,813,815,816,817,819,835,842,843,844,845,846,848,849,850,851,854,855,856,857,860,861,862,863,865,867,868,869,870,881,886,887,888,891,893,895,896,897,899,900,901) ";
        String sql4 = "select a.id,a.kh_nm,a.kh_tp,a.qdtp_nm,a.xsjd_nm,a.linkman,a.mobile,a.tel,a.province,a.city,a.area,a.address,a.longitude,a.latitude,a.scbf_date,a.mem_id,c.member_nm,d.branch_name,FORMAT((6371.004*ACOS(SIN(24.480817/180*PI())*SIN(a.latitude/180*PI())+COS(24.480817/180*PI())*COS(a.latitude/180*PI())*COS((118.124723-a.longitude)/180*PI()))),1) as jlkm from xmuglcwwlkjyxgs285.sys_customer a  left join xmuglcwwlkjyxgs285.sys_mem c on a.mem_id=c.member_id left join xmuglcwwlkjyxgs285.sys_depart d on a.branch_id=d.branch_id  where  a.is_db=2 AND a.branch_id IN (2,3,4,5,6,7,8,3,2,4)  order by - cast(jlkm as decimal(2,1)) DESC";

        List<String> sqlList = Lists.newArrayList(sql4);
        for (String s : sqlList) {
            System.out.println("===================================raw========================================");
            System.out.println(s);
            String shapedSQL = shape(sql);
            System.out.println("===================================shaped========================================");
            System.out.println(shapedSQL);
            System.out.println("===================================count========================================");
            String countSql = PagerUtils.count(shapedSQL, JdbcConstants.MYSQL);
            System.out.println(countSql);
            System.out.println("===================================limit========================================");
            String limit = PagerUtils.limit(shapedSQL, JdbcConstants.MYSQL, 20, 10);
            System.out.println(limit);
        }
    }

    @Test
    public void testPage(){
        String sql = "select a.id,a.kh_nm,a.kh_tp,a.qdtp_nm,a.xsjd_nm,a.linkman,a.mobile,a.tel,a.province,a.city,a.area,a.address,a.longitude,a.latitude,a.scbf_date,a.mem_id,c.member_nm,d.branch_name,FORMAT((6371.004*ACOS(SIN(24.480792/180*PI())*SIN(a.latitude/180*PI())+COS(24.480792/180*PI())*COS(a.latitude/180*PI())*COS((118.124739-a.longitude)/180*PI()))),1) as jlkm from xmuglcwwlkjyxgs285.sys_customer a  left join xmuglcwwlkjyxgs285.sys_mem c on a.mem_id=c.member_id left join xmuglcwwlkjyxgs285.sys_depart d on a.branch_id=d.branch_id  where  a.is_db=2 AND a.branch_id IN (2,3,4,5,6,7,8,3,2,4)  order by -(cast(jlkm as decimal(2,1))) DESC";
        System.out.println(PagerUtils.count(sql, JdbcConstants.MYSQL));
    }


    private String shape(String sql) {
        MySqlStatementParser parser = new MySqlStatementParser(sql, true, false);
        List<SQLStatement> statements = parser.parseStatementList();
        if (statements.size() > 0) {
            for (SQLStatement statement : statements) {
                MultiTenancySqlVisitor visitor = new MultiTenancySqlVisitor(tenantColumnName, tenantId);
                statement.accept(visitor);
            }
            return SQLUtils.toSQLString(statements, JdbcConstants.MYSQL);
        }
        throw new BizException("无法解析SQL");
    }

    @Test
    public void testUpdate() {
        String sql = "update xmhyxspyxgs514.fin_account set acc_amt=acc_amt+(?) where id in (select x.id from xmhyxspyxgs514.fin_account x where x.type = ?)";
        String sql1 = "UPDATE XMHYXSPYXGS514.STK_OUT SET OUT_TIME = ?,REMARKS = ?,MID = ?,ORDER_ID = ?,TEL = ?,PSZD = ?,SHR = ?,KH_NM = ?,PRO_TYPE = ?,STK_ID = ?,CST_ID = ?,OPERATOR = ?,REC_AMT = ?,OUT_TYPE = ?,FREE_AMT = ?,DISCOUNT = ?,CREATE_TIME = ?,EMP_ID = ?,TOTAL_AMT = ?,CANCEL_USER = ?,DIS_AMT = ?,NEW_TIME = ?,SEND_TIME = ?,SALE_TYPE = ?,PRICE_FLAG = ?,SUBMIT_TIME = ?,CANCEL_TIME = ?,REAUDIT_DESC = ?,DIS_AMT1 = ?,EP_CUSTOMER_ID = ?,EP_CUSTOMER_NAME = ?,SUBMIT_USER = ?,VEH_ID = ?,DRIVER_ID = ?,STAFF = ?,STAFF_TEL = ?,ADDRESS = ?,BILL_NO = ?,STATUS = ? WHERE ID = ?";
        ArrayList<String> sqlList = Lists.newArrayList(sql, sql1);
        for (String s : sqlList) {
            System.out.println("=========================raw============================");
            System.out.println(s);
            System.out.println("=========================shaped============================");
            String shapedSql = shape(s);
            System.out.println(shapedSql);
        }
    }

    @Test
    public void testInsert() {
        String sql = "INSERT INTO SJK1538961685402512.STK_OUT(OUT_TIME,REMARKS,MID,ORDER_ID,TEL,PSZD,SHR,KH_NM,PRO_TYPE,STK_ID,CST_ID,OPERATOR,REC_AMT,OUT_TYPE,FREE_AMT,DISCOUNT,CREATE_TIME,EMP_ID,TOTAL_AMT,DIS_AMT,NEW_TIME,SALE_TYPE,PRICE_FLAG,DIS_AMT1,EP_CUSTOMER_ID,EP_CUSTOMER_NAME,STAFF,STAFF_TEL,ADDRESS,BILL_NO,STATUS) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
        //String sql2 = "INSERT INTO SJK1538961685402512.STK_OUT VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"; //必须声明插入字段
        ArrayList<String> sqlList = Lists.newArrayList(sql
                //, sql2
        );
        for (String s : sqlList) {
            System.out.println("=========================raw============================");
            System.out.println(s);
            System.out.println("=========================shaped============================");
            String shapedSql = shape(s);
            System.out.println(shapedSql);
        }
    }

    @Test
    public void testDelete() {
        String sql = "delete from ptqyspgs531.sys_chat_msg where tp!='41-1' and tp!='42-1' and receive_id=2561";
        String sql1 = "delete from sys_chat_msg where receive_id=462 and msg_id in (select id from heihei.haha where qid= ?) ";
        ArrayList<String> sqlList = Lists.newArrayList(sql, sql1);
        for (String s : sqlList) {
            System.out.println("=========================raw============================");
            System.out.println(s);
            System.out.println("=========================shaped============================");
            String shapedSql = shape(s);
            System.out.println(shapedSql);
        }
    }
}
