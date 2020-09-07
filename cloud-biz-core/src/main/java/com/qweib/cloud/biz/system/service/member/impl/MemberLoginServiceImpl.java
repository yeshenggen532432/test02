package com.qweib.cloud.biz.system.service.member.impl;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.qweib.cloud.biz.system.service.member.MemberLoginService;
import com.qweib.cloud.biz.system.service.plat.SysCorporationService;
import com.qweib.cloud.core.domain.dto.MemberLoginShowDTO;
import com.qweib.cloud.repository.utils.HttpResponseUtils;
import com.qweib.cloud.service.member.domain.corporation.SysCorporationDTO;
import com.qweib.cloud.service.member.domain.member.login.MemberLoginDTO;
import com.qweib.cloud.service.member.domain.member.login.MemberLoginQuery;
import com.qweib.cloud.service.member.domain.member.login.MemberLoginSave;
import com.qweib.cloud.service.member.retrofit.MemberLoginRetrofitApi;
import com.qweib.cloud.service.member.retrofit.SysCorporationRequest;
import com.qweib.cloud.utils.DataCacheUtils;
import com.qweibframework.commons.Collections3;
import com.qweibframework.commons.page.Page;
import org.dozer.Mapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;
import java.util.Objects;

/**
 * Summary:
 *
 * @Author zeng.gui.
 * Created on 2020/2/14 - 20:40.
 */
@Service
public class MemberLoginServiceImpl implements MemberLoginService {

    @Value("${qweib.kafka.topic.member-login:topic-qweib-member-login}")
    private String topicMemberLogin;
    @Autowired
    private KafkaTemplate kafkaTemplate;
//    @Autowired
//    private MemberLoginRetrofitApi loginRetrofitApi;
    @Autowired
    private Mapper mapper;
//    @Autowired
//    private SysCorporationRequest mSysCorporationRequest;

    @Autowired
    private SysCorporationService sysCorporationService;

    @Override
    public void pushMemberLogin(MemberLoginSave input) {
        //kafkaTemplate.send(topicMemberLogin, input.getMemberId().toString(), input);
    }

    @Override
    public Page<MemberLoginShowDTO> page(MemberLoginQuery query, Integer pageNo, Integer pageSize) {
        Page<MemberLoginDTO> page = new Page<>();// HttpResponseUtils.convertResponse(loginRetrofitApi.page(query, pageNo, pageSize));
        List<MemberLoginShowDTO> dataList = Lists.newArrayListWithCapacity(pageSize);
//        if (Collections3.isNotEmpty(page.getData())) {
//            Map<Integer, SysCorporationDTO> companyCache = Maps.newHashMap();
//            for (MemberLoginDTO loginDTO : page.getData()) {
//                MemberLoginShowDTO showDTO = mapper.map(loginDTO, MemberLoginShowDTO.class);
//                SysCorporationDTO corporationDTO = DataCacheUtils.getData(companyCache, showDTO.getCompanyId(), dataListener);
//                if (Objects.nonNull(corporationDTO)) {
//                    showDTO.setCompanyName(corporationDTO.getName());
//                }
//                dataList.add(showDTO);
//            }
//        }

        return new Page<>(dataList, page.getTotalCount(), page.getPage(), page.getSize());
    }

    //private DataCacheUtils.DataListener dataListener = (DataCacheUtils.DataListener<Integer, SysCorporationDTO>) key -> HttpResponseUtils.convertResponse(mSysCorporationRequest.get(key));
}
