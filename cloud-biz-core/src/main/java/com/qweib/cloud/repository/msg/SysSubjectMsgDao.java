package com.qweib.cloud.repository.msg;

import com.google.common.collect.Lists;
import com.qweib.cloud.core.domain.msg.SysSubjectMsg;
import com.qweib.cloud.repository.utils.HttpResponseUtils;
import com.qweib.cloud.service.member.domain.basedata.SysSubjectMsgDTO;
import com.qweib.cloud.service.member.retrofit.SysSubjectMsgRetrofitApi;
import com.qweib.cloud.utils.Collections3;
import org.dozer.Mapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.stream.Collectors;

/**
 * 订阅消息主体内容
 */
@Repository
public class SysSubjectMsgDao {

//    @Autowired
//    private SysSubjectMsgRetrofitApi api;
    @Autowired
    private Mapper dozer;


    /**
     * 所有消息内容
     */
    public List<SysSubjectMsg> findAllByType(int type) {
//        List<SysSubjectMsgDTO> result = HttpResponseUtils.convertResponse(api.findByType(type));
//        if (Collections3.isNotEmpty(result)) {
//            return result.stream().map(dto -> dozer.map(dto, SysSubjectMsg.class)).collect(Collectors.toList());
//        }
        return Lists.newArrayList();
    }

    /**
     * 根据sign获取消息内容
     *
     * @param sign
     * @return
     */
    public SysSubjectMsg findBySign(String sign) {
//        SysSubjectMsgDTO dto = HttpResponseUtils.convertResponse(api.findBySign(sign));
//        if (dto != null) {
//            return dozer.map(dto, SysSubjectMsg.class);
//        }
        return null;
    }
}
