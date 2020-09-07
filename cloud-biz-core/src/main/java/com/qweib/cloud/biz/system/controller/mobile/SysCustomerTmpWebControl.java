package com.qweib.cloud.biz.system.controller.mobile;

import com.qweib.cloud.biz.system.BaseWebService;
import com.qweib.cloud.biz.system.TokenServer;
import com.qweib.cloud.biz.system.service.SysCustomerTmpService;
import com.qweib.cloud.biz.system.service.ws.SysMemberWebService;
import com.qweib.cloud.core.domain.OnlineMessage;
import com.qweib.cloud.core.domain.OnlineUser;
import com.qweib.cloud.core.domain.SysCustomerTmp;
import com.qweib.cloud.core.domain.SysMember;
import com.qweib.cloud.utils.DateTimeUtil;
import com.qweib.cloud.utils.Page;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;
import java.util.Date;

/**
 * 临时客户
 */
@Controller
@RequestMapping("/web")
public class SysCustomerTmpWebControl extends BaseWebService {

    @Resource
    private SysCustomerTmpService customerTmpService;
    @Resource
    private SysMemberWebService memberWebService;

    /**
     * 添加临时客户
     */
    @RequestMapping("addCustomerTmpWeb")
    public void addCustomerTmpWeb(HttpServletResponse response, String token, SysCustomerTmp bean){
        try {
            if(!checkParam(response, token, bean.getKhNm())){
                return;
            }
            OnlineMessage message = TokenServer.tokenCheck(token);
            if(message.isSuccess() == false){
                sendWarm(response, message.getMessage());
                return;
            }
            OnlineUser onlineUser = message.getOnlineMember();
            //判断是否存在
            SysCustomerTmp oldBean = this.customerTmpService.queryTmpCustomerByKhNm(bean.getKhNm(), onlineUser.getDatabase());
            if(oldBean != null){
                this.sendWarm(response, "该客户名称已存在");
                return;
            }
            SysMember member = this.memberWebService.queryCompanySysMemberById(onlineUser.getDatabase(),onlineUser.getMemId());
            bean.setCreateTime(DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd HH:mm:ss"));
            if (member != null){
                bean.setMemId(member.getMemberId());
                bean.setBranchId(member.getBranchId());
            }
            this.customerTmpService.addTmpCustomer(bean, onlineUser.getDatabase());
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "添加临时客户成功");
        } catch (Exception e) {
            e.printStackTrace();
            log.error("添加临时客户失败", e);
            this.sendWarm(response, "添加临时客户失败");
        }
    }

    /**
     * 删除--临时客户
     */
    @RequestMapping("deleteCustomerTmpWeb")
    public void deleteCustomerTmpWeb(HttpServletResponse response, String token, Integer id){
        try {
            if(!checkParam(response, token, id)){
                return;
            }
            OnlineMessage onlineMessage = TokenServer.tokenCheck(token);
            if(onlineMessage.isSuccess() == false){
                this.sendWarm(response, onlineMessage.getMessage());
                return;
            }
            OnlineUser onlineUser = onlineMessage.getOnlineMember();
            SysCustomerTmp bean = new SysCustomerTmp();
            bean.setId(id);
            SysCustomerTmp oldBean = this.customerTmpService.queryTmpCustomer(bean, onlineUser.getDatabase());
            if(oldBean != null){
                if(!oldBean.getMemId().toString().equals(onlineUser.getMemId().toString())){
                    this.sendWarm(response, "该客户不是自己的，不能删除");
                    return;
                }
            }

            //不做物理删除，修改为倒闭状态
            oldBean.setIsDb(1);
            this.customerTmpService.updateTmpCustomer(oldBean, onlineUser.getDatabase());
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "删除成功");
        }catch (Exception e){
            e.printStackTrace();
            log.error("删除失败", e);
            this.sendWarm(response, "删除失败");
        }
    }


    /**
     * 修改临时客户
     */
    @RequestMapping("updateCustomerTmpWeb")
    public void updateCustomerTmpWeb(HttpServletResponse response, String token, SysCustomerTmp bean){
        try {
            if(!checkParam(response, token, bean.getKhNm())){
                return;
            }
            OnlineMessage message = TokenServer.tokenCheck(token);
            if(message.isSuccess() == false){
                this.sendWarm(response, message.getMessage());
                return;
            }
            OnlineUser onlineUser = message.getOnlineMember();
            //判断客户是否存在
            SysCustomerTmp oldBean = this.customerTmpService.queryTmpCustomerByKhNm(bean.getKhNm(), onlineUser.getDatabase());
            if(oldBean != null){
                this.sendWarm(response, "该客户名称已存在");
                return;
            }
            this.customerTmpService.updateTmpCustomer(bean, onlineUser.getDatabase());
        } catch (Exception e){
            e.printStackTrace();
            log.error("修改客户失败", e);
            this.sendWarm(response, "修改客户失败");
        }
    }

    /**
     * 查询临时客户
     */
    @RequestMapping("queryCustomerTmpPageWeb")
    public void queryCustomerTmpPageWeb(HttpServletResponse response, String token, Integer pageNo, Integer pageSize,
                                        @RequestParam(defaultValue = "3") String dataTp, String mids, String khNm, Double longitude, Double latitude){
        try {
            if(!checkParam(response, token)){
                return;
            }
            OnlineMessage message = TokenServer.tokenCheck(token);
            if(message != null && message.isSuccess() == false){
                this.sendWarm(response, message.getMessage());
                return;
            }
            OnlineUser onlineUser = message.getOnlineMember();
            if(pageNo == null){
                pageNo = 1;
            }
            if(pageSize == null){
                pageSize = 10;
            }
            Page page = this.customerTmpService.queryTmpCustomerPageWeb(onlineUser.getDatabase(), pageNo, pageSize, onlineUser.getMemId(),
                    dataTp, mids, khNm, longitude, latitude);
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "查询临时客户成功");
            json.put("list", page.getRows());
        } catch (Exception e){
            e.printStackTrace();
            log.error("查询临时客户失败", e);
            this.sendWarm(response,"查询临时客户失败" + e);
        }
    }




}