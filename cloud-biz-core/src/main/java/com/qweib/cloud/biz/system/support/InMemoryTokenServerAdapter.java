package com.qweib.cloud.biz.system.support;

import com.qweib.cloud.biz.system.service.plat.SysCorporationService;
import com.qweib.cloud.core.domain.OnlineMessage;
import com.qweib.cloud.core.domain.OnlineUser;
import com.qweib.cloud.core.domain.SysCorporation;
import com.qweib.cloud.utils.SpringContextHolder;
import com.qweib.cloud.utils.StrUtil;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class InMemoryTokenServerAdapter implements TokenServerAdapter {

    private static List<OnlineUser> onlineUserList = new ArrayList<OnlineUser>();

    @Override
    public void tokenCreated(OnlineUser onlineMember, String type) {
        onlineMember.setAccessTime(new Date());
        onlineUserList.add(onlineMember);
    }

    @Override
    public void tokenDestroyed(OnlineUser member) {
        onlineUserList.remove(member);
    }

    @Override
    public void tokenDestroyed(Integer memId) {

    }

    @Override
    public OnlineMessage tokenCheck(String token) {
        SysCorporationService sysCorporationService = SpringContextHolder.getBean("sysCorporationService");
        OnlineUser temp = null;
        OnlineMessage onlineMessage = null;
        if (onlineUserList != null && onlineUserList.size() > 0) {
            // 判断该用户是否已经登录
            for (OnlineUser onlineMember : onlineUserList) {
                if (onlineMember != null && onlineMember.getToken() != null && onlineMember.getToken().equals(token)) {
                    onlineMessage = new OnlineMessage();
//                    Date nowTime = new Date();
//                    Date accessTime = onlineMember.getAccessTime();
//                    long time = nowTime.getTime() - accessTime.getTime();
//                    long minutes = time / 60000;
//                    if (minutes > WebServerConstants.APP_OVERTIME) {// 登录超时，重新登陆
//                        onlineMessage.setMessage("访问超时，请重新登陆.");
//                        onlineMessage.setSuccess(false);
//                        temp = onlineMember;
////                      onlineUserList.remove(onlineMember);
//                    }else
                    if (null == onlineMember.getTel()) {
                        onlineMessage.setMessage("此账号在异地登陆");
                        onlineMessage.setSuccess(false);
                        temp = onlineMember;
//                        onlineUserList.remove(onlineMember);
                    } else {
                        String endDate = "";
                        if (!StrUtil.isNull(onlineMember.getDatabase())) {//没有对应公司(数据库)
                            SysCorporation corporation = sysCorporationService.queryCorporationBydata(onlineMember.getDatabase());
                            endDate = corporation.getEndDate();
                        }
                        if (!StrUtil.isNull(endDate)) {
                            try {
//    							int dnum=DateTimeUtil.getDaysDiff(DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd"),endDate, "yyyy-MM-dd");
//    							if(dnum>0){
                                onlineMember.setAccessTime(new Date());
                                onlineMessage.setMessage("登录成功.");
                                onlineMessage.setSuccess(true);
                                onlineMessage.setOnlineMember(onlineMember);
                                break;
//    							}else{
//    								onlineMessage.setMessage("您已到期了，请及时续费才能正常使用");
//    		                        onlineMessage.setSuccess(false);
//    		                        temp = onlineMember;
//    							}
                            } catch (Exception e) {
                                // TODO: handle exception
                            }
                        } else {
                            onlineMember.setAccessTime(new Date());
                            onlineMessage.setMessage("登录成功.");
                            onlineMessage.setSuccess(true);
                            onlineMessage.setOnlineMember(onlineMember);
                            break;
                        }
                    }
                }
            }
            if (null != temp) {
                onlineUserList.remove(temp);
            }
        }
        if (null == onlineMessage) {
            onlineMessage = new OnlineMessage();
            onlineMessage.setMessage("请先登录系统");
            onlineMessage.setSuccess(false);
        }
        return onlineMessage;
    }

    @Override
    public void updateToken(OnlineUser onlineUser) {

    }

    @Override
    public boolean checkLoginState(Integer usrId) {
        OnlineUser temp = null;
        if (onlineUserList != null && onlineUserList.size() > 0) {
            // 判断该用户是否已经登录
            for (OnlineUser onlineMember : onlineUserList) {
                if (onlineMember != null && onlineMember.getMemId() != null && onlineMember.getMemId().intValue() == usrId.intValue()) {
                    if (null == onlineMember.getTel()) {
                        temp = onlineMember;
//	            		onlineUserList.remove(onlineMember);
                    } else {
                        onlineMember.setTel(null);//提示异地登录用
                    }
                }
            }
            if (null != temp) {/**在list遍历完成之后再进行删除，不然会出现线程并发问题java.util.ConcurrentModificationException**/
                onlineUserList.remove(temp);
            }
        }
        return true;
    }

    @Override
    public void updateToken(String token, String database, String memberNm, String memberMobile) {
        if (onlineUserList != null && onlineUserList.size() > 0) {
            // 判断该用户是否已经登录
            for (OnlineUser onlineMember : onlineUserList) {
                if (null != onlineMember && null != onlineMember.getToken() && onlineMember.getToken().equals(token)) {
                    if (null != database) {
                        if (null == onlineMember.getDatabase() || !onlineMember.getDatabase().equals(database)) {
                            onlineMember.setDatabase(database);
                        }
                    }
                    if (null != memberNm) {
                        onlineMember.setMemberNm(memberNm);
                    }
                    if (null != memberMobile) {
                        onlineMember.setTel(memberMobile);
                    }
                }
            }
        }
    }

    @Override
    public void updateDatasource(String database, Integer memId) {
        if (onlineUserList != null && onlineUserList.size() > 0) {
            // 判断该用户是否已经登录
            for (OnlineUser onlineMember : onlineUserList) {
                if (onlineMember != null && onlineMember.getToken() != null && onlineMember.getMemId().equals(memId)) {
                    onlineMember.setDatabase(database);
                }
            }
        }
    }
}
