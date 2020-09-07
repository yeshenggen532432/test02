package com.qweib.cloud.biz.system.service.ws;

import com.qweib.cloud.core.domain.SysChatMsg;
import com.qweib.cloud.core.domain.SysMemberMsg;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.repository.plat.ws.PublicMsgWebDao;
import com.qweib.cloud.repository.ws.BscMsgWebDao;
import com.qweib.commons.StringUtils;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

@Service
public class PublicMsgWebService {
    @Resource
    private PublicMsgWebDao publicMsgWebDao;
    @Resource
    private BscMsgWebDao msgWebDao;

    public int addMemerMsg(SysMemberMsg msg) {
        try {
            return publicMsgWebDao.addMemerMsg(msg);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    public int addpublicMsg(SysChatMsg scm) {
        int result = this.publicMsgWebDao.addChatMsg(scm);
        return result;
    }

    public int addPublicChatMsg(List<SysChatMsg> scms) {
        int result = 0;
        if (scms.size() > 0) {
            for (int i = 0; i < scms.size(); i++) {
                result = this.publicMsgWebDao.addChatMsg(scms.get(i));
            }
        }
        return result;
    }

    /**
     * 私信查询聊天记录
     *
     * @param pId
     * @param memId
     * @param id
     * @return
     * @创建：作者:YYP 创建时间：2015-2-12
     */
    public List queryLetterMsg(Integer pId, Integer memId,
                               Integer id, String tp, String datasource) {
        try {
            List list = publicMsgWebDao.queryLetterMsg(pId, memId, id, tp, datasource);
            return list;
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 获取未读消息
     * @param memId
     * @param database
     * @return
     * @创建：作者:YYP 创建时间：2015-2-15
     */
    public List<SysChatMsg> deletequeryUnReadMsg(Integer memId, String database) {
        try {
            List<SysChatMsg> companyMsgs = new ArrayList<SysChatMsg>();
            if (StringUtils.isNotBlank(database)) {
                companyMsgs = msgWebDao.queryChatMsg(memId, database);//查询企业平台上的未读
                msgWebDao.deleteChatMsg(memId, database);//删除企业平台上未读
            }
            List<SysChatMsg> publicMsgs = publicMsgWebDao.queryMsg(memId);//查询公共平台上的未读
            companyMsgs.addAll(publicMsgs);//合并企业和公共平台上的未读
            Collections.sort(companyMsgs, new Comparator<SysChatMsg>() {
                @Override
                public int compare(SysChatMsg o1, SysChatMsg o2) {
                    return o1.getAddtime()
                            .compareTo(o2.getAddtime());
                }
            });
            publicMsgWebDao.deleteMsg(memId);//删除公共平台上未读
            return companyMsgs;
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    public List<SysChatMsg> queryChatMsg2(Integer memId, String database) {
        try {
            return this.msgWebDao.queryChatMsg2(memId, database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

//    public SysChatMsg queryChatMsgByMRB(Integer memberId, Integer receiveId, Integer belongId, String database) {
//        try {
//            return this.msgWebDao.queryChatMsgByMRB(memberId, receiveId, belongId, database);
//        } catch (Exception e) {
//            throw new ServiceException(e);
//        }
//    }

    public SysChatMsg queryChatMsgByMsgId(Integer msgId, String database) {
        try {
            return this.msgWebDao.queryChatMsgByMsgId(msgId, database);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }


}
