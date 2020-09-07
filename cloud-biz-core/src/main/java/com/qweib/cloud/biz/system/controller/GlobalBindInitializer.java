package com.qweib.cloud.biz.system.controller;

import com.qweib.cloud.service.member.common.DeviceEnum;
import com.qweib.cloud.service.member.common.LoginTypeEnum;
import com.qweibframework.commons.StringUtils;
import org.springframework.core.Ordered;
import org.springframework.core.annotation.Order;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.InitBinder;

import java.beans.PropertyEditorSupport;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2020/2/17 - 16:11
 */
@Order(Ordered.HIGHEST_PRECEDENCE)
@ControllerAdvice
public class GlobalBindInitializer {

    @InitBinder
    public void initBinder(WebDataBinder binder) {
        binder.setAutoGrowCollectionLimit(100000);
        binder.registerCustomEditor(DeviceEnum.class, new PropertyEditorSupport() {
            @Override
            public void setAsText(String text) throws IllegalArgumentException {
                if (StringUtils.isNotBlank(text)) {
                    setValue(DeviceEnum.getByDevice(StringUtils.toInteger(text)));
                }
            }
        });

        binder.registerCustomEditor(LoginTypeEnum.class, new PropertyEditorSupport() {
            @Override
            public void setAsText(String text) throws IllegalArgumentException {
                if (StringUtils.isNotBlank(text)) {
                    setValue(LoginTypeEnum.getByType(StringUtils.toInteger(text)));
                }
            }
        });

    }
}
