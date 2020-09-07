package com.qweib.cloud.biz.system.msg;

import com.qweib.cloud.core.domain.msg.SysSubjectMsg;
import com.qweib.cloud.repository.msg.SysSubjectMsgDao;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

/**
 * 订阅消息主体内容
 */
@Slf4j
@Service
public class SysSubjectMsgService {

    @Resource
    private SysSubjectMsgDao sysSubjectMsgDao;

    /**
     * 所有消息内容
     */
    public List<SysSubjectMsg> findAllByType(int type) {
        return sysSubjectMsgDao.findAllByType(type);
    }

    /**
     * 根据ID获取消息内容
     *
     * @param sign
     * @return
     */
    public SysSubjectMsg findBySign(String sign) {
        return sysSubjectMsgDao.findBySign(sign);
    }
}
