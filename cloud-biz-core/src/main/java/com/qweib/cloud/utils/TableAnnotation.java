
package com.qweib.cloud.utils;

import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;

/**
 *说明：
 *@创建：作者:yxy		创建时间：2013-4-7
 *@修改历史：
 *		[序号](yxy	2013-4-7)<修改说明>
 */
@Retention(RetentionPolicy.RUNTIME)
public @interface TableAnnotation {
	//空值也去修改
	public boolean nullToUpdate() default true;
	//是否更新
	public boolean insertAble() default true;
	//是否更新
	public boolean updateAble() default true;
}

