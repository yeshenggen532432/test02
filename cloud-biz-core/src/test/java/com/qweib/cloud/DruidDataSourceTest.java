package com.qweib.cloud;

import com.google.common.collect.Maps;
import com.qweib.cloud.core.dao.JdbcDaoTemplatePlud;
import com.qweib.cloud.core.domain.settings.bill.BillConfig;
import com.qweib.cloud.utils.Page;
import com.qweib.commons.Identities;
import com.qweibframework.boot.datasource.DataSourceContextHolder;
import com.qweibframework.boot.datasource.tenancy.TenantContext;
import com.qweibframework.boot.datasource.tenancy.TenantInfo;
import com.qweibframework.boot.datasource.tenancy.TenantScope;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.annotation.Rollback;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.AbstractTransactionalJUnit4SpringContextTests;

import java.util.List;
import java.util.Map;

/**
 * @author: jimmy.lin
 * @time: 2019/10/23 14:26
 * @description:
 */
@ContextConfiguration("classpath:application.xml")
public class DruidDataSourceTest extends AbstractTransactionalJUnit4SpringContextTests {
    @Autowired
    private JdbcDaoTemplatePlud jdbcTemplate;

    @Before
    public void init() {
        //指定租户ID
        TenantInfo tenant = TenantInfo.builder()
                .tenantId(285)
                .build();
        TenantContext.setTenant(tenant);
        TenantContext.setScope(TenantScope.SHARED);
        //指定数据源
        DataSourceContextHolder.set("cloud");
    }

    @Test
    @Rollback(false)
    public void testInsert() {
        String sql = "INSERT INTO xmuglcwwlkjyxgs285.`bsc_bill_config` (title,namespace) VALUES (?,?)";
        jdbcTemplate.update(sql, "title1", "xxfp");

        BillConfig config = new BillConfig();
        config.setNamespace("xxfp2");
        config.setTitle("heihei");
        jdbcTemplate.save("bsc_bill_config", config);
        jdbcTemplate.save("xmuglcwwlkjyxgs285.bsc_bill_config", config);
        int id = jdbcTemplate.addByObject("xmuglcwwlkjyxgs285.bsc_bill_config", config);
        System.out.println(id);
    }

    @Test
    @Rollback(false)
    public void testUpdate() {
        String sql = "UPDATE xmuglcwwlkjyxgs285.`bsc_bill_config` a SET a.title = ? WHERE 1=1 AND a.id = ?";
        jdbcTemplate.update(sql, "test_update_title", 6);

        BillConfig entity = jdbcTemplate.queryForObj("select * from xmuglcwwlkjyxgs285.`bsc_bill_config` limit 1", BillConfig.class);
        entity.setTitle(Identities.uuid());
        Map<String, Object> where = Maps.newHashMap();
        where.put("id", entity.getId());
        System.out.println(jdbcTemplate.updateByObject("xmuglcwwlkjyxgs285.`bsc_bill_config`", entity, where, "id"));
    }

    @Test
    public void testSelect() {
        String sql = "select a.id,a.kh_nm,a.kh_tp,a.qdtp_nm,a.xsjd_nm,a.linkman,a.mobile,a.tel,a.province,a.city,a.area,a.address,a.longitude,a.latitude,a.scbf_date,a.mem_id,c.member_nm,d.branch_name,FORMAT((6371.004*ACOS(SIN(24.537247/180*PI())*SIN(a.latitude/180*PI())+COS(24.537247/180*PI())*COS(a.latitude/180*PI())*COS((118.122021-a.longitude)/180*PI()))),1) as jlkm from xmuglcwwlkjyxgs285.sys_customer a  left join xmuglcwwlkjyxgs285.sys_mem c on a.mem_id=c.member_id left join xmuglcwwlkjyxgs285.sys_depart d on a.branch_id=d.branch_id  where  a.is_db=2 AND a.branch_id IN (2,3,4,5,6,7,8,3,2,5,6,4) ";
        List<Map<String, Object>> maps = jdbcTemplate.queryForList(sql);
        String sql1 = "select * from xmuglcwwlkjyxgs285.`bsc_bill_config` where 1=? order by id desc";
        List<BillConfig> list = jdbcTemplate.queryForLists(sql1, BillConfig.class, 1);
        for (BillConfig config : list) {
            System.out.println(config.getTitle());
        }
        BillConfig config = jdbcTemplate.queryForObj("select * from xmuglcwwlkjyxgs285.`bsc_bill_config` where 1=? limit 1", BillConfig.class, 1);
        System.out.println(config.getTitle() + ">>>>>>>");
        System.out.println(jdbcTemplate.queryForInt("select id from xmuglcwwlkjyxgs285.`bsc_bill_config` where 1=? limit 1", 1));
    }

    @Test
    public void testPagination() {
        final String sql = "select * from xmuglcwwlkjyxgs285.`bsc_bill_config` order by id desc";
        Page page = jdbcTemplate.queryForPageByMySql(sql, 1, 10, BillConfig.class);
        System.out.println(page.getTotal());
        System.out.println("================================================================");
        Page page1 = jdbcTemplate.queryForPageByMySql(sql, 1, 10);
        System.out.println(page1.getTotal());
    }


    @After
    public void clear() {
        TenantContext.clear();
        DataSourceContextHolder.clear();
    }
}
