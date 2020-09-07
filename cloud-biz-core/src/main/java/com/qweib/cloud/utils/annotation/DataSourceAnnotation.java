package com.qweib.cloud.utils.annotation;

import java.lang.annotation.*;

/**
 * 动态数据源注解
 *
 * @author zzx
 * @version 1.1 2019/12/23
 * @description:
 */
@Target({ElementType.METHOD})
@Retention(RetentionPolicy.RUNTIME)
@Documented
public @interface DataSourceAnnotation {

    String companyId() default "";//公司ID

    String dataBase() default "";//公司名称

    String isJaiMi() default "";//是否加密
}
