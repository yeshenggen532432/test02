package com.qweib.cloud.core.dao.annotations;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * @author: jimmy.lin
 * @time: 2019/5/30 10:21
 * @description:
 */
@Retention(RetentionPolicy.RUNTIME)
@Target(value = {ElementType.TYPE})
public @interface QwbTable {
    String value() default "";
}
