package com.qweib.cloud.biz.system;

import com.qweib.cloud.biz.system.service.SysConfigService;
import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.SysConfig;
import com.qweib.cloud.core.domain.SysLoginInfo;
import com.qweib.cloud.utils.SpringContextHolder;
import com.qweib.cloud.utils.StrUtil;
import com.qweib.commons.DateUtils;
import com.qweibframework.boot.datasource.DataSourceContextAllocator;
import com.qweibframework.commons.StringUtils;
import org.apache.commons.lang3.math.NumberUtils;
import org.springframework.context.support.ResourceBundleMessageSource;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import javax.servlet.http.HttpServletRequest;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.text.DecimalFormat;
import java.util.List;


public class BasicUtil {


    public static List loadListByParam(String tableName, String selectBlock, String whereBlock) {
        SysLoginInfo sysLoginInfo = getSysLoginInfo();
        if (StrUtil.isNull(selectBlock)) {
            selectBlock = "*";
        }
        if (StrUtil.isNull(whereBlock)) {
            whereBlock = " 1= 1";
        }
        //private JdbcDaoTemplate daoTemplate;
        String sql = "select " + selectBlock + " from " + sysLoginInfo.getDatasource() + "." + tableName + " where 1=1 and " + whereBlock + " ";
        JdbcDaoTemplate daoTemplate = SpringContextHolder.getBean("daoTemplate");
        List list = daoTemplate.queryForList(sql);
        return list;
    }

    public static String checkFieldDisplay(String tableName, String selectBlock, String whereBlock) {
        SysLoginInfo sysLoginInfo = getSysLoginInfo();
        if (StrUtil.isNull(selectBlock)) {
            selectBlock = "*";
        }
        if (StrUtil.isNull(whereBlock)) {
            whereBlock = " 1= 1";
        }
        //private JdbcDaoTemplate daoTemplate;
        String sql = "select " + selectBlock + " from " + sysLoginInfo.getDatasource() + "." + tableName + " where 1=1 and " + whereBlock + " ";
        JdbcDaoTemplate daoTemplate = SpringContextHolder.getBean("daoTemplate");
        List list = daoTemplate.queryForList(sql);
        if (list != null && list.size() > 0) {
            return "";
        }
        return "none";
    }

    public static Boolean checkFieldBool(String tableName, String selectBlock, String whereBlock) {
        SysLoginInfo sysLoginInfo = getSysLoginInfo();
        if (StrUtil.isNull(selectBlock)) {
            selectBlock = "*";
        }
        if (StrUtil.isNull(whereBlock)) {
            whereBlock = " 1= 1";
        }
        //private JdbcDaoTemplate daoTemplate;
        String sql = "select " + selectBlock + " from " + sysLoginInfo.getDatasource() + "." + tableName + " where 1=1 and " + whereBlock + " ";
        JdbcDaoTemplate daoTemplate = SpringContextHolder.getBean("daoTemplate");
        List list = daoTemplate.queryForList(sql);
        if (list != null && list.size() > 0) {
            return true;
        }
        return false;
    }

    private static SysLoginInfo getSysLoginInfo() {
        HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder
                .getRequestAttributes())
                .getRequest();
        SysLoginInfo sysLoginInfo = (SysLoginInfo) request.getSession().getAttribute("usr");
        DataSourceContextAllocator allocator = SpringContextHolder.getBean(DataSourceContextAllocator.class);
        allocator.alloc(sysLoginInfo.getDatasource(), sysLoginInfo.getFdCompanyId());
        return sysLoginInfo;
    }

    public static Object shapeField(String value, Integer decimal) {
        if (StringUtils.isEmpty(value)) {
            return value;
        }
        if (NumberUtils.isParsable(value)) {
            BigDecimal number = new BigDecimal(value);
            decimal = decimal == null ? 0 : decimal;
            if(decimal == 0){
                int scale = number.scale();
                decimal = scale > 2? 2: scale;
            }
            number = number.setScale(decimal, BigDecimal.ROUND_HALF_EVEN);
            DecimalFormat df = new DecimalFormat();
            df.setMaximumFractionDigits(decimal);
            df.setMinimumFractionDigits(decimal);
            df.setRoundingMode(RoundingMode.HALF_EVEN);
            return df.format(number);
        }
        return value;
    }

    public static String getStorageTitleName() {
        SysLoginInfo sysLoginInfo = getSysLoginInfo();
        SysConfigService configService = SpringContextHolder.getBean("sysConfigService");
        SysConfig config = configService.querySysConfigByCode("CONFIG_JXC_USE_KUWEI", sysLoginInfo.getDatasource());
        ResourceBundleMessageSource messageSource = SpringContextHolder.getBean("messageSource");
        config = new SysConfig();
        config.setStatus("1");
        if (config != null && "1".equals(config.getStatus())) {
            return "库位";
        }
        return "仓库";
    }

    public static Boolean isUseKuwei() {
        SysLoginInfo sysLoginInfo = getSysLoginInfo();
        SysConfigService configService = SpringContextHolder.getBean("sysConfigService");
        SysConfig config = configService.querySysConfigByCode("CONFIG_JXC_USE_KUWEI", sysLoginInfo.getDatasource());
        if (config != null && "1".equals(config.getStatus())) {
            return true;
        }
        return false;
    }

    public static void main(String[] args) {
        String num = "42.8797";
        BigDecimal num1 = new BigDecimal("42.8797");
        System.out.println(num1);
        System.out.println(shapeField("5", 1));
        System.out.println(shapeField(num, 1));
        System.out.println(shapeField(num, 0));
        System.out.println(shapeField(num, 3));
        System.out.println(shapeField("23.1", 0));
        System.out.println(shapeField("23", 0));
        System.out.println(shapeField("23.233", 0));
        System.out.println(shapeField("23.233", 2));
        System.out.println(shapeField("23.233", 3));
        System.out.println(shapeField("asdfasdfa", 2));

        System.out.println(DateUtils.parseDate("Thu Apr 11 20:33:26 CST 2019"));

        System.out.println(NumberUtils.isParsable("50L"));
    }

}
