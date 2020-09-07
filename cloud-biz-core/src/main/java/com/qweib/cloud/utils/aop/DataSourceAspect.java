package com.qweib.cloud.utils.aop;

/**
 * 动态数据源注解实现（异步或非登陆接口时无法获取客户数据源位置，前置时加入公司ID，或数据库名称）
 *
 * @author zzx
 * @version 1.1 2019/12/24
 * @description:
 */

import com.qweib.cloud.biz.system.service.plat.SysCorporationService;
import com.qweib.cloud.biz.system.utils.JiaMiCodeUtil;
import com.qweib.cloud.core.domain.SysCorporation;
import com.qweib.cloud.utils.annotation.DataSourceAnnotation;
import com.qweib.commons.StringUtils;
import com.qweibframework.boot.datasource.DataSourceContextAllocator;
import com.qweibframework.commons.expression.AnnoExpressionEvaluator;
import lombok.extern.slf4j.Slf4j;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.After;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.Ordered;
import org.springframework.stereotype.Component;

import javax.annotation.Resource;

@Slf4j
@Aspect
@Component
public class DataSourceAspect implements Ordered {

    @Autowired
    private DataSourceContextAllocator allocator;
    @Resource
    private SysCorporationService corporationService;

    private AnnoExpressionEvaluator evaluator = new AnnoExpressionEvaluator();

    @Override
    public int getOrder() {
        return Ordered.LOWEST_PRECEDENCE;
    }

    @Before("@annotation(dataSourceAnnotation)")
    public void before(JoinPoint joinPoint, DataSourceAnnotation dataSourceAnnotation) {
        log.debug("进入Before" + dataSourceAnnotation.companyId());
        try {
            String companyId = null;
            String dataBase = null;
            if (StringUtils.isNotBlank(dataSourceAnnotation.companyId())) {
                companyId = evaluator.getValue(joinPoint, dataSourceAnnotation.companyId(), String.class);

                //是否加密公司ID
                if (StringUtils.isNotBlank(dataSourceAnnotation.isJaiMi()))
                    companyId = JiaMiCodeUtil.decode(companyId);
            }
            //如果公司ID为空时,数据库名称不为空时,查找公司ID
            if (StringUtils.isEmpty(companyId) && StringUtils.isNotBlank(dataSourceAnnotation.dataBase())) {
                dataBase = evaluator.getValue(joinPoint, dataSourceAnnotation.dataBase(), String.class);
                SysCorporation sysCorporation = corporationService.queryCorporationBydata(dataBase);
                if (sysCorporation != null)
                    companyId = sysCorporation.getDeptId().toString();
            }
            log.info("动态数据库AOP=" + dataBase + "_" + companyId);
            if (StringUtils.isNotBlank(companyId)) {
                allocator.alloc(dataBase, companyId);
            }
        } catch (Exception e) {
            log.error("动态数据库AOP出现错误", e);
            throw e;
        }
    }


    @After("@annotation(dataSourceAnnotation)")
    public void after(DataSourceAnnotation dataSourceAnnotation) {
        log.debug("退出After");
        allocator.release();
    }


}
