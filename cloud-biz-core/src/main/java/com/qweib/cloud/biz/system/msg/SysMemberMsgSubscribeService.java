package com.qweib.cloud.biz.system.msg;

import com.qweib.cloud.biz.system.utils.job.MsgSubjectSignEnum;
import com.qweib.cloud.core.domain.msg.SysMemberMsgSubscribe;
import com.qweib.cloud.repository.msg.SysMemberMsgSubscribeDao;
import com.qweib.cloud.utils.Page;
import com.qweibframework.commons.MathUtils;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

/**
 * 会员消息订阅
 */
@Slf4j
@Service
public class SysMemberMsgSubscribeService {

    @Resource
    private SysMemberMsgSubscribeDao sysMemberMsgSubscribeDao;

    /**
     * 增加会员订阅
     *
     * @param database
     * @param list
     * @return
     */
    public int add(int memberId, List<SysMemberMsgSubscribe> list, String database) {
        for (SysMemberMsgSubscribe subscribe : list) {
            subscribe.setMemberId(memberId);
        }
        sysMemberMsgSubscribeDao.del(memberId, database);//先删除所有订阅数据
        sysMemberMsgSubscribeDao.add(list, database);
        return 1;
    }

    /**
     * 增加会员订阅
     *
     * @param database
     * @param sysMemberMsgSubscribe
     * @return
     */
    public int add(int memberId, SysMemberMsgSubscribe sysMemberMsgSubscribe, String database) {
        sysMemberMsgSubscribe.setMemberId(memberId);
        sysMemberMsgSubscribeDao.del(memberId, sysMemberMsgSubscribe.getSysSubjectId(), database);//先删除所有订阅数据
        if (MathUtils.valid(sysMemberMsgSubscribe.getPushNotice()))
            sysMemberMsgSubscribeDao.add(sysMemberMsgSubscribe, database);
        return 1;
    }


    /**
     * 根据会员查询所有订阅
     *
     * @param memberId
     * @param database
     * @return
     */
    public List<SysMemberMsgSubscribe> findAllByMemberId(int memberId, String database) {
        return sysMemberMsgSubscribeDao.findAllByMemberId(memberId, database);
    }


    /**
     * 根据获取标记得到订阅会员
     *
     * @param sing     获取标记
     * @param database
     * @return
     */
    public List<SysMemberMsgSubscribe> findAllBySign(MsgSubjectSignEnum sing, String database) {
        return sysMemberMsgSubscribeDao.findAllBySign(sing.toString(), database);
    }


    /**
     * 帮助用户订阅消息
     *
     * @param sysSubjectId
     * @param mIds
     * @param database
     * @return
     */
    public int addMember(Integer sysSubjectId, String mIds, String database) {
        SysMemberMsgSubscribe subscribe = new SysMemberMsgSubscribe();
        subscribe.setSysSubjectId(sysSubjectId);
        String[] ss = mIds.split(",");
        for (String id : ss) {
            Integer memberId = Integer.valueOf(id);
            subscribe.setMemberId(memberId);
            sysMemberMsgSubscribeDao.del(memberId, sysSubjectId, database);//先删除所有订阅数据
            subscribe.setPushNotice(1);
            sysMemberMsgSubscribeDao.add(subscribe, database);
        }
        return 1;
    }

    /**
     * 移除用户订阅
     *
     * @param sysSubjectId
     * @param mIds
     * @param database
     * @return
     */
    public int removeMember(Integer sysSubjectId, String mIds, String database) {
        String[] ss = mIds.split(",");
        for (String id : ss) {
            Integer memberId = Integer.valueOf(id);
            sysMemberMsgSubscribeDao.del(memberId, sysSubjectId, database);//先删除所有订阅数据
        }
        return 1;
    }


    /**
     * 根据消息ID获取订阅会员
     *
     * @param sysSubjectId
     * @param pageNo
     * @param limit
     * @param database
     * @return
     */
    public Page querySubscribeMemberPage(Integer sysSubjectId, String memberNm, Integer pageNo, Integer limit, String database) {
        return sysMemberMsgSubscribeDao.querySubscribeMemberPage(sysSubjectId, memberNm, pageNo, limit, database);
    }

    /**
     * 根据消息ID获取未订阅会员
     *
     * @param sysSubjectId
     * @param pageNo
     * @param limit
     * @param database
     * @return
     */
    public Page queryNotSubscribeMemberPage(Integer sysSubjectId, String memberNm, Integer pageNo, Integer limit, String database) {
        return sysMemberMsgSubscribeDao.queryNotSubscribeMemberPage(sysSubjectId, memberNm, pageNo, limit, database);
    }
}
