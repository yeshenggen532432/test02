package com.qweib.cloud.biz.customer.duplicate.impl;

import com.google.common.collect.Lists;
import com.google.common.collect.Sets;
import com.qweib.cloud.biz.customer.duplicate.DataReceiver;
import com.qweib.cloud.biz.customer.duplicate.DuplicateInvoker;
import com.qweib.cloud.biz.customer.duplicate.dto.CustomerDTO;
import com.qweib.cloud.biz.customer.duplicate.dto.CustomerTypeEnum;
import com.qweib.cloud.biz.customer.duplicate.dto.ResultDTO;
import com.qweib.cloud.utils.Collections3;
import com.qweib.commons.StringUtils;
import org.springframework.beans.BeansException;
import org.springframework.beans.factory.DisposableBean;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Objects;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Description: 默认客户名称去重执行器
 *
 * @author zeng.gui
 * Created on 2019/8/9 - 10:19
 */
@Component
public class DefaultDuplicateInvoker implements DuplicateInvoker, ApplicationContextAware, InitializingBean, DisposableBean {

    private List<DataReceiver> dataReceivers;
    private DataReceiver shopMemberDataReceiver;
    private ApplicationContext applicationContext;

    @Override
    public ResultDTO invoke(String database, CustomerDTO customerDTO) {
        final String customerName = customerDTO.getName();

        List<CustomerDTO> similarCustomers = Lists.newArrayList();
        getDuplicateDatas(database, customerDTO, similarCustomers);
        if (Collections3.isEmpty(similarCustomers)) {
            return new ResultDTO(false);
        }

        if (customerDTO.getId() != null) {
            return checkNameByUpdate(similarCustomers, customerDTO);
        } else {
            return checkNameBySave(similarCustomers, customerName);
        }
    }

    private void getDuplicateDatas(String database, CustomerDTO originData, List<CustomerDTO> similarNames) {
        if (Collections3.isEmpty(dataReceivers)) {
            return;
        }

        final String customerName = originData.getName();
        if (!Objects.equals(CustomerTypeEnum.ShopMember, originData.getType())) {
            dataReceivers.forEach(dataReceiver -> mergeCustomerDatas(dataReceiver, database, customerName, similarNames));
        } else {
            mergeCustomerDatas(shopMemberDataReceiver, database, customerName, similarNames);
        }
    }

    private void mergeCustomerDatas(DataReceiver dataReceiver, String database, String customerName, List<CustomerDTO> similarNames) {
        List<CustomerDTO> nameList = dataReceiver.getDatas(database, customerName);
        if (Collections3.isNotEmpty(nameList)) {
            similarNames.addAll(nameList);
        }
    }

    private ResultDTO checkNameByUpdate(List<CustomerDTO> similarCustomers, CustomerDTO customerDTO) {
        if (similarCustomers.contains(customerDTO)) {
            return new ResultDTO(false);
        }

        return checkNameBySave(similarCustomers, customerDTO.getName());
    }

    private ResultDTO checkNameBySave(List<CustomerDTO> similarCustomers, String customerName) {
        final Set<String> similarNames = Sets.newHashSet();
        similarCustomers.forEach(e -> similarNames.add(e.getName()));

        if (!similarNames.contains(customerName)) {
            return new ResultDTO(false);
        }

        final CustomerDTO repeatData = similarCustomers.stream()
                .filter(e -> Objects.equals(e.getName(), customerName))
                .findFirst()
                .get();

        NameRegex nameRegex = patternCustomerName(customerName);
        String baseName = nameRegex.getBaseName();
        int index = nameRegex.getCurrentIndex() + 1;
        while (true) {
            String tmpName = baseName + index++;
            if (!similarNames.contains(tmpName)) {
                return new ResultDTO(true, tmpName).setRepeatData(repeatData);
            }
        }
    }

    private static final Pattern CUSTOMER_NAME_PATTERN = Pattern.compile("(.+?)(\\d*)$");

    private NameRegex patternCustomerName(String customerName) {
        Matcher matcher = CUSTOMER_NAME_PATTERN.matcher(customerName);
        int index = 1;
        String baseName = customerName;
        if (matcher.find()) {
            baseName = matcher.group(1);
            if (StringUtils.isNotBlank(matcher.group(2))) {
                index = StringUtils.toInteger(matcher.group(2));
            }
        }

        return new NameRegex(baseName, index);
    }

    static class NameRegex {
        private final String baseName;
        private final int currentIndex;

        public NameRegex(String baseName, int currentIndex) {
            this.baseName = baseName;
            this.currentIndex = currentIndex;
        }

        public String getBaseName() {
            return baseName;
        }

        public int getCurrentIndex() {
            return currentIndex;
        }
    }

    @Override
    public void setApplicationContext(ApplicationContext applicationContext) throws BeansException {
        this.applicationContext = applicationContext;
    }

    @Override
    public void afterPropertiesSet() throws Exception {
        this.dataReceivers = Lists.newArrayList();
        this.dataReceivers.add(applicationContext.getBean(SysCustomerDataReceiver.class));
        this.dataReceivers.add(applicationContext.getBean(StkProviderDataReceiver.class));
        this.dataReceivers.add(applicationContext.getBean(FinUnitDataReceiver.class));
        this.dataReceivers.add(applicationContext.getBean(SysMemDataReceiver.class));

        this.shopMemberDataReceiver = applicationContext.getBean(ShopMemberDataReceiver.class);
    }

    @Override
    public void destroy() throws Exception {
        this.dataReceivers.clear();
        this.dataReceivers = null;
    }

}
